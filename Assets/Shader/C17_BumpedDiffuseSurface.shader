Shader "Custom/C17_BumpedDiffuseSurface"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_BumpMap ("Normalmap", 2D) = "bump" {}
    }
    SubShader
    { // No Pass!
        Tags { "RenderType"="Opaque" }
        LOD 300 // LOD

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Lambert

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

		sampler2D _MainTex;
		sampler2D _BumpMap;
		fixed4 _Color;

        struct Input
        {
			float2 uv_MainTex;
			float2 uv_BumpMap;
        };
        // SurfaceOutput: NoPBS, SurfaceOutputStandard: PBS(MR) ; SurfaceOutputSpecular: PBS(SG)
        void surf (Input IN, inout SurfaceOutput o)
        {
			fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = tex.rgb * _Color.rgb;
			o.Alpha = tex.a * _Color.a;
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
        }
        ENDCG
    }
    FallBack "Diffuse"
}
