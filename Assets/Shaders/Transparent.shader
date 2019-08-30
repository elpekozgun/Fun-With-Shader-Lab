Shader "Ozgun/Transparent"
{
	Properties
	{
		_Texture("texture", 2D) = "black"{}
	}

	SubShader
	{
		Tags {"Queue" = "Transparent"}
		Cull off
		Blend srcAlpha oneminussrcalpha

		// idiotic way of shader lab to write the Below CGPROGRAM HLSL CODE
		Pass
		{
			SetTexture [_Texture] {Combine texture}
		}

	}
	fallback "Diffuse"
}