Shader "Custom/C13_FogWithDepthTexture"
{
    Properties
    {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_FogDensity ("Fog Density", Float) = 1.0
		_FogColor ("Fog Color", Color) = (1, 1, 1, 1)
		_FogStart ("Fog Start", Float) = 0.0
		_FogEnd ("Fog End", Float) = 1.0
    }
    SubShader
    {
		CGINCLUDE

		#include "UnityCG.cginc"

		float4x4 _FrustumCornersRay;

		sampler2D _MainTex;
		half4 _MainTex_TexelSize;
		sampler2D _CameraDepthTexture;
		half _FogDensity;	// Effect denity
		fixed4 _FogColor;	// Effect base color
		float _FogStart;	// Effect start height
		float _FogEnd;		// Effect end height

		struct v2f {
			float4 pos : SV_POSITION;
			half2 uv : TEXCOORD0;
			half2 uv_depth : TEXCOORD1;
			float4 interpolatedRay : TEXCOORD2;
		};

        v2f vert (appdata_img v)
        {
            v2f o;
            o.pos = UnityObjectToClipPos(v.vertex);
            o.uv = v.texcoord;
            o.uv_depth = v.texcoord;

            #if UNITY_UV_STARTS_AT_TOP
			if (_MainTex_TexelSize.y < 0)
				o.uv_depth.y = 1 - o.uv_depth.y;
			#endif

 			int index = 0;
			if (v.texcoord.x < 0.5 && v.texcoord.y < 0.5) {         // BR
				index = 0;
			} else if (v.texcoord.x > 0.5 && v.texcoord.y < 0.5) {  // BL
				index = 1;
			} else if (v.texcoord.x > 0.5 && v.texcoord.y > 0.5) {  // TR
				index = 2;
			} else {                                                // TL
				index = 3;
			}           

			#if UNITY_UV_STARTS_AT_TOP
			if (_MainTex_TexelSize.y < 0)
				index = 3 - index;
			#endif

			o.interpolatedRay = _FrustumCornersRay[index];

            return o;
        }

		fixed4 frag (v2f i) : SV_Target {
            // Get the worldPos from depthTexture!!!
            float d = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv_depth);
            float linearDepth = LinearEyeDepth(d);

            // KEY Eqution!
            float3 worldPos = _WorldSpaceCameraPos + linearDepth * i.interpolatedRay.xyz;

			// 1.Linear: from height
    		float fogDensity = (_FogEnd - worldPos.y) / (_FogEnd - _FogStart); 
			fogDensity = saturate(fogDensity * _FogDensity);

            // 2.Exponential:
            // 3.Exponential Squared:

            fixed4 finalColor = tex2D(_MainTex, i.uv);
			finalColor.rgb = lerp(finalColor.rgb, _FogColor.rgb, fogDensity);

			return finalColor;
		}

        ENDCG

        Pass
        {
            Cull Off ZWrite Off ZTest Always

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            ENDCG
        }
    }
 	FallBack Off
}
