Shader "Ozgun/VertFrag/Ocean"
{
	Properties
	{
		_MainTex("Base", 2D) = "white" {}
		_Color("Color", Color) = (1,1,1,1)
		_Smoothness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.5
	}

	SubShader
	{
		Tags { "Queue" = "Transparent" }

		CGPROGRAM
		#pragma surface surf Standard

		sampler2D _MainTex;
		fixed4 _Color;
		half _Smoothness;
		half _Metallic;

		struct Input
		{
			float2 uv_MainTex;
		};

		void vert(inout appdata_full v)
		{

		}

		void surf(Input IN, inout SurfaceOutputStandard o )
		{
			fixed4 color = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = color.rgb;
			o.Metallic = _Metallic;
			o.Smoothness = _Smoothness;
			o.Alpha = color.a;
		}


	ENDCG
	}
	Fallback "Diffuse"
}