Shader "Custom/C11_Water"
{
    Properties
    {
		_MainTex ("Main Tex", 2D) = "white" {}
		_Color ("Color Tint", Color) = (1, 1, 1, 1)
		_Magnitude ("Distortion Magnitude", Float) = 1 // 幅值
 		_Frequency ("Distortion Frequency", Float) = 1 // 频率
 		_InvWaveLength ("Distortion Inverse Wave Length", Float) = 10 // 波长倒数
 		_Speed ("Speed", Float) = 0.5
    }
    SubShader
    {
        // disableBatching
	    Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "DisableBatching"="True"}

        Pass
        {
			Tags { "LightMode"="ForwardBase" }

            ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha
			Cull Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _Color;
			float _Magnitude;
			float _Frequency;
			float _InvWaveLength;
			float _Speed;

            struct appdata
            {
                float4 vertex : POSITION;
                float4 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                float4 offset;
				offset.x = sin(_Frequency * _Time.y + v.vertex.x * _InvWaveLength + v.vertex.y * _InvWaveLength + v.vertex.z * _InvWaveLength) * _Magnitude;
				offset.yzw = float3(0.0, 0.0, 0.0);
                // offset in model space
                o.vertex = UnityObjectToClipPos(v.vertex + offset);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.uv +=  float2(0.0, _Time.y * _Speed);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                col.rgb *= _Color.rgb;
                return col;
            }
            ENDCG
        }
    }
	FallBack "Transparent/VertexLit"
}
