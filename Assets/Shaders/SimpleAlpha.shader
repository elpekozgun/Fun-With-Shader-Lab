Shader "Ozgun/SimpleAlphaTest"
{
	Properties
	{
		_Texture("texture", 2D) = "white"{}
	}

	SubShader
	{
		Tags {"Queue" = "Transparent"}

		CGPROGRAM
		#pragma surface surf Lambert alpha:fade

		sampler2D _Texture;

		struct Input
		{
			float2 uv_Texture;
		};

		void surf(Input IN, inout SurfaceOutput o)
		{
			fixed4 color = tex2D(_Texture, IN.uv_Texture); 
			o.Albedo = color.rgb;
			o.Alpha = color.a;
		}
		ENDCG
	}
	fallback "Diffuse"
}