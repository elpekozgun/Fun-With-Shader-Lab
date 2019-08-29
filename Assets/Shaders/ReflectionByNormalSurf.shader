Shader "Ozgun/ReflectionWithNormal"
{
	Properties
	{
		_Normal("Normal ", 2D) = "white" {}
		_Cube("Cube Map", CUBE) = "" {}
		_AlbedoColor("Albedo Color", Color) = (0.1, 0.4, 0.7, 1)
		_NormalSlider("Normal Slider", Range(0,5)) = 1
	}
		SubShader
	{
		CGPROGRAM

		#pragma surface surf Lambert

		sampler2D _Normal;
		samplerCUBE _Cube;
		fixed4 _AlbedoColor;
		half _NormalSlider;

		struct Input
		{
			float2 uv_Normal;
			float3 worldRefl; INTERNAL_DATA
		};

		void surf(Input IN, inout SurfaceOutput o)
		{
			o.Normal = UnpackNormal(tex2D(_Normal, IN.uv_Normal)) * 0.3;
			o.Normal *= fixed3(_NormalSlider,_NormalSlider, 1);
			o.Albedo = texCUBE(_Cube, -WorldReflectionVector(IN, o.Normal)).rgb;
			o.Albedo += _AlbedoColor.rgb * 0.3;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
