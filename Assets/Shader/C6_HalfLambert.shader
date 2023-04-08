Shader "Custom/C6_HalfLambert"
{
    Properties
    {
        _Diffuse ("Diffuse", Color) = (1,1,1,1)
    }
    SubShader
    {
        Pass {
            Tags { "LightMode"="ForwardBase" }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            uniform fixed4 _Diffuse;

            struct a2v {
                float4 vertex : POSITION;
				float3 normal : NORMAL;
            };
            
            struct v2f {
                float4 pos : SV_POSITION;
                float3 worldNormal : TEXCOORD0;
            };

            v2f vert(a2v v) {
                v2f o;
            	o.pos = UnityObjectToClipPos(v.vertex);
                o.worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));

                return o;
            }   

            fixed4 frag(v2f i) : SV_Target {
                // ambient:
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

                // diffuse:
                fixed3 worldNormal = normalize(i.worldNormal);
                fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);

                // HalfLambort's Law
                fixed3 halfLambort = dot(worldNormal, worldLight) * 0.5 + 0.5;

                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * halfLambort;

                fixed3 color = ambient + diffuse;
                return fixed4(color, 1.0);
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}
