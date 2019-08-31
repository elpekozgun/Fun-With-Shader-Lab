Shader "Ozgun/Surface/SimpleBlend"
{
	Properties
	{
		_Texture("texture", 2D) = "black"{}
	}

	SubShader
	{
		Tags {"Queue" = "Transparent"}

		Blend One one


		// idiotic way of shader lab to write the Below CGPROGRAM HLSL CODE
		Pass
		{
			SetTexture [_Texture] {Combine texture}
		}

		CGPROGRAM
		#pragma surface surf Lambert 

		sampler2D _Texture;

		struct Input
		{
			float2 uv_Texture;
		};

		void surf(Input IN, inout SurfaceOutput o)
		{
			fixed4 color = tex2D(_Texture, IN.uv_Texture); 
			o.Albedo = color.rgb;
			//o.Alpha = color.a;
		}
		ENDCG

	}
	fallback "Diffuse"
}