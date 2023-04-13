Shader "Custom/C12_BrightSaturateContrast"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Brightness ("Brightness亮度", Float) = 1
		_Saturation("Saturation饱和度", Float) = 1
		_Contrast("Contrast对比度", Float) = 1
    }
    SubShader
    {
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

           sampler2D _MainTex;  
			half _Brightness;
			half _Saturation;
			half _Contrast;

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata_img v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 renderTex = tex2D(_MainTex, i.uv);
                // Brightness:
                fixed3 finalColor = renderTex.rgb * _Brightness;

                // Satutation:
				fixed luminance = 0.2125 * renderTex.r + 0.7154 * renderTex.g + 0.0721 * renderTex.b; // brightness mostly depends on g;
                fixed3 luminanceColor = fixed3(luminance, luminance, luminance);
				finalColor = lerp(luminanceColor, finalColor, _Saturation);               

                // Contrast:
                fixed3 avgColor = fixed3(0.5, 0.5, 0.5);
                finalColor = lerp(avgColor, finalColor, _Contrast);

                return fixed4(finalColor, renderTex.a);
            }
            ENDCG
        }
    }
    Fallback Off
}
