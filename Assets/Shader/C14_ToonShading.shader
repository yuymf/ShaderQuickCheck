Shader "Custom/C14_ToonShading"
{
    Properties
    {
        _Color ("Color Tint", Color) = (1, 1, 1, 1)
        _MainTex ("Main Texture", 2D) = "white" {}
        _Ramp ("Ramp Texture", 2D) = "white" {} // 漫反射渐变
        _Outline ("Outline", Range(0, 1)) = 0.1 // 轮廓线宽度
        _OutlineColor ("Outline Color", color) = (0, 0, 0, 1)  
        _Specular ("Specular", Color) = (1, 1, 1, 1)    // 高光
        _SpecularScale ("Specular Scale", Range(0, 0.1)) = 0.01 //高光阈值
    }
    SubShader
    {
		Tags { "RenderType"="Opaque" "Queue"="Geometry"}
        Pass 
        {
            NAME "OUTLINE" // 只渲染背面三角面片以做顶点偏移

            Cull Front

            CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			
			float _Outline;
			fixed4 _OutlineColor;

			struct a2v {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			}; 

			struct v2f {
			    float4 pos : SV_POSITION;
			};

            v2f vert (a2v v)
            {
                v2f o;
                // 变换到视角空间
				float4 pos = mul(UNITY_MATRIX_MV, v.vertex); 
				float3 normal = mul((float3x3)UNITY_MATRIX_IT_MV, v.normal);  
                // 防止内凹
                normal.z = -0.5;
                pos += float4(normalize(normal), 0) * _Outline; // 背面扩张
                o.pos = mul(UNITY_MATRIX_P, pos);  // 变换到裁剪空间

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				return float4(_OutlineColor.rgb, 1);    
            }

            ENDCG
        }

        Pass
        {
            Tags { "LightMode"="ForwardBase" }
			
			Cull Back
		
			CGPROGRAM
		
			#pragma vertex vert
			#pragma fragment frag
			
			#pragma multi_compile_fwdbase
		
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"
			#include "UnityShaderVariables.cginc"
			
			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _Ramp;
			fixed4 _Specular;
			fixed _SpecularScale;

            struct a2v {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
				float4 tangent : TANGENT;
			}; 
		
			struct v2f {
				float4 pos : POSITION;
				float2 uv : TEXCOORD0;
				float3 worldNormal : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				SHADOW_COORDS(3)
			};

            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

                TRANSFER_SHADOW(o);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				fixed3 worldNormal = normalize(i.worldNormal);
				fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(i.worldPos));
				fixed3 worldViewDir = normalize(UnityWorldSpaceViewDir(i.worldPos));
				fixed3 worldHalfDir = normalize(worldLightDir + worldViewDir);

				fixed4 c = tex2D (_MainTex, i.uv);
				fixed3 albedo = c.rgb * _Color.rgb;
                // Ambient:
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
                // Atten:
				UNITY_LIGHT_ATTENUATION(atten, i, i.worldPos);
                // Diffuse: halfLambert + Ramp
                fixed halfLambert = (dot(worldNormal, worldLightDir) * 0.5 + 0.5) * atten;
                fixed3 diffuse = _LightColor0.rgb * albedo * tex2D(_Ramp, float2(halfLambert, halfLambert)).rgb;
                // Specular: smooth
                fixed spec = dot(worldNormal, worldHalfDir);
                fixed w = fwidth(spec) * 2.0; // border smooth area, if SpecularSize = 0->no spec;
                fixed3 specular = _Specular.rgb * lerp(0, 1, smoothstep(-w, w, spec + _SpecularScale - 1)) * step(0.0001, _SpecularScale);
				return fixed4(ambient + diffuse + specular, 1.0);
            }

            ENDCG
        }
    }
	FallBack "Diffuse"
}
