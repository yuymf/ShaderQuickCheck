// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Custom/C6_DiffuseVertex"
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
                fixed3 color : COLOR0;
            };

            v2f vert(a2v v) {
                v2f o;
            	o.pos = UnityObjectToClipPos(v.vertex);

                // ambient:
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                // diffuse: Lambort's Law
                fixed3 worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));// _World2Object not _worldObject
                fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLight));

            	o.color = ambient + diffuse;
                return o;
            }   

            fixed4 frag(v2f i) : SV_Target {
                return fixed4(i.color, 1.0);
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}
