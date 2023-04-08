// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/C5_OriginShader" { 
    // 属性声明
    Properties {
		_Color ("Color Tint", Color) = (1, 1, 1, 1)
	}

    SubShader {
        Pass {
            CGPROGRAM
            // 包含最常使用的帮助函数、宏和结构体
            #include "UnityCG.cginc"

            // 声明着色器的函数名
            #pragma vertex vert
            #pragma fragment frag

            uniform fixed4 _Color;

            struct a2v {
                float4 vertex : POSITION;       // 模型空间顶点坐标
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
            };
            
            struct v2f {
                float4 pos : SV_POSITION;       // 裁剪空间顶点坐标
                fixed3 color : COLOR0;
            };

            v2f vert(a2v v) {
                v2f o;
            	o.pos = UnityObjectToClipPos(v.vertex);
            	o.color = v.normal * 0.5 + fixed3(0.5, 0.5, 0.5);
                return o;
            }   

            // SV_Target: 片元着色器输出
            fixed4 frag(v2f i) : SV_Target {
                fixed3 c = _Color * i.color;
                return fixed4(c, 1.0);
            }
            
            ENDCG
        }
    }
}
