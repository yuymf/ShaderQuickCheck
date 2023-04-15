Shader "Custom/C13_EdgeDetectNormalAndDepth"
{
	Properties
	{
		_MainTex("Base(RGB)",2D) = "white"{}
		_EdgeOnly("Edge Only",Float) = 1.0
		_EdgeColor("Edge Color",Color) = (0,0,0,1)
		_BackgroundColor("Background Color",Color) = (1,1,1,1)
		_SampleDistance("Sample Distance",Float) = 1.0
		_Sensitivity("Sensitivity",Vector) = (1,1,1,1)
	}
 
 
	SubShader
	{
		CGINCLUDE
 
		#include "UnityCG.cginc"
 
		sampler2D _MainTex;
		float _EdgeOnly;
		fixed4 _EdgeColor;
		fixed4 _BackgroundColor;
		float _SampleDistance;
		fixed4 _Sensitivity;
		half4 _MainTex_TexelSize;
 
		sampler2D _CameraDepthNormalsTexture;
 
		struct v2f
		{
			fixed4 pos : SV_POSITION;
			half2 uv[5]: TEXCOORD0;
		};
 
		v2f vert(appdata_base v)
		{
			v2f o;
			o.pos = UnityObjectToClipPos(v.vertex);
			half2 uv = v.texcoord;
 
			#if UNITY_UV_STARTS_AT_TOP
			if (_MainTex_TexelSize.y < 0)
				uv.y = 1 - uv.y;
			#endif

			o.uv[0] = uv;
  
			o.uv[1] = uv + _MainTex_TexelSize * half2(1,1)  * _SampleDistance;
			o.uv[2] = uv + _MainTex_TexelSize * half2(-1,-1) * _SampleDistance;
			o.uv[3] = uv + _MainTex_TexelSize * half2(-1,1) * _SampleDistance;
			o.uv[4] = uv + _MainTex_TexelSize * half2(1,-1) * _SampleDistance;
 
			return o;
 
		}
		
		half CheckSame(half4 center,half4 sample)
		{
			half2 centerNormal = center.xy;
			half2 centerDepth = center.zw;
			half2 sampleNormal = sample.xy;
			half2 sampleDepth = sample.zw;
 
			//abs求整数的绝对值
			half2 diffNormal = abs(centerNormal -  sampleNormal) * _Sensitivity.x;
			half2 diffDepth = abs(centerDepth - sampleDepth) * _Sensitivity.y;
 
			int isSameNormal = (diffNormal.x + diffNormal.y) < 0.1;
 
			int isSameDepth = diffDepth < 0.1 * centerDepth;
 
			return isSameNormal * isSameDepth ? 1.0 : 0.0;
		}
 
		fixed4 frag(v2f i) : SV_Target 
		{
			//用四个坐标对深度法线图进行采样
			//tex2D()对_CameraDepthNormalsTexture进行采样
			//Unity提供了DecodeDepthNormal函数对采样结果进行解码
			//sample里面xy分量存储法线信息，zw分量存储深度信息
			half4 sample1 = tex2D(_CameraDepthNormalsTexture, i.uv[1]);
			half4 sample2 = tex2D(_CameraDepthNormalsTexture, i.uv[2]);
			half4 sample3 = tex2D(_CameraDepthNormalsTexture, i.uv[3]);
			half4 sample4 = tex2D(_CameraDepthNormalsTexture, i.uv[4]);
 
			half edge = 1.0;
 
			edge *= CheckSame(sample1,sample2);
			edge *= CheckSame(sample3,sample4);
 
			//
			fixed4 withEdgeColor = lerp(_EdgeColor,tex2D(_MainTex,i.uv[0]),edge);
			fixed4 onlyEdgeColor = lerp(_EdgeColor,_BackgroundColor,edge);
 
			return lerp(withEdgeColor,onlyEdgeColor,_EdgeOnly);
 
		}
 
		ENDCG
 
		Pass
		{
			ZTest Always Cull Off ZWrite Off
 
			CGPROGRAM
 
			#pragma vertex vert 
			#pragma fragment frag 
 
			ENDCG  
		}
	}
	FallBack Off
}
 