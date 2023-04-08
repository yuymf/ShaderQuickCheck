Shader "Custom/C5_FalseColor" { 
    SubShader {
        Pass {
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct v2f {
                float4 pos : SV_POSITION;  
                fixed4 color : COLOR0;
            };

            //struct a2v -> appdata_full!!!
            v2f vert(appdata_full v) {
                v2f o;
            	o.pos = UnityObjectToClipPos(v.vertex);

                // Normal
            	o.color = fixed4(v.normal * 0.5 + fixed3(0.5, 0.5, 0.5), 1.0);

                // Tangent
                o.color = fixed4(v.tangent.xyz * 0.5 + fixed3(0.5, 0.5, 0.5), 1.0);

                // Binormal: Remind how to calcu binomal!!!
                fixed3 binormal = cross(v.normal, v.tangent.xyz) * v.tangent.w;
                o.color = fixed4(binormal.xyz * 0.5 + fixed3(0.5, 0.5, 0.5), 1.0);

                // First set texcoord
				o.color = fixed4(v.texcoord.xy, 0.0, 1.0);
				
				// Second set texcoord
				o.color = fixed4(v.texcoord1.xy, 0.0, 1.0);
				
				// Fractional part of the first set texcoord
				o.color = frac(v.texcoord);
				if (any(saturate(v.texcoord) - v.texcoord)) {
					o.color.b = 0.5;
				}
				o.color.a = 1.0;

                // Fractional part of the second set texcoord
				o.color = frac(v.texcoord);
				if (any(saturate(v.texcoord) - v.texcoord)) {
					o.color.b = 0.5;
				}
				o.color.a = 1.0;

                // Visualize vertex color
                // o.color = v.color;

                return o;
            }   

            fixed4 frag(v2f i) : SV_Target {
                return i.color;
            }
            
            ENDCG
        }
    }
}
