Shader "Custom/C13_MotionBlurWithDepthTexture"
{
    Properties
    {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_BlurAmount ("Blur Amount", Float) = 1.0
    }
    SubShader
    {
		CGINCLUDE

		#include "UnityCG.cginc"

		sampler2D _MainTex;
		half4 _MainTex_TexelSize;
        sampler2D _CameraDepthTexture;
		float4x4 _CurrentViewProjectionInverseMatrix;
		float4x4 _PreviousViewProjectionMatrix;
		half _BlurSize;

        struct v2f
        {
            float4 vertex : SV_POSITION;
            float2 uv : TEXCOORD0;
            float2 uv_depth : TEXCOORD1;
        };

        v2f vert (appdata_img v)
        {
            v2f o;
            o.vertex = UnityObjectToClipPos(v.vertex);
            o.uv = v.texcoord;
            o.uv_depth = v.texcoord;

            #if UNITY_UV_STARTS_AT_TOP
			if (_MainTex_TexelSize.y < 0)
				o.uv_depth.y = 1 - o.uv_depth.y;
			#endif

            return o;
        }

		fixed4 frag (v2f i) : SV_Target {
            // Get the worldPos from depthTexture!!!
            float d = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv_depth);
            float4 H = float4(i.uv.x * 2 - 1, i.uv.y * 2 - 1, d * 2 - 1, 1);    // NDC space
            float4 D = mul(_CurrentViewProjectionInverseMatrix, H);             
            float4 worldPos = D / D.w;                                          // World space

            float4 currentPos = H;
            float4 previousPos = mul(_PreviousViewProjectionMatrix, worldPos);
            previousPos /= previousPos.w;

            float2 velocity = (currentPos.xy - previousPos.xy)/2.0f;

            // Sample: Size(_BlurSize), Avgpool:
            float2 uv = i.uv;
            float4 c = tex2D(_MainTex, uv);
            uv += velocity * _BlurSize;
            for (int it = 1; it < 3; it++, uv += velocity * _BlurSize)
            {
                float4 currentColor = tex2D(_MainTex, uv);
                c += currentColor;
            }
            c /= 3;

			return fixed4(c.rgb, 1.0);
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
