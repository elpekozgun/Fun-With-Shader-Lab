Shader "Ozgun/SimpleTextureBlend"
{
	Properties
	{
		_Texture("texture", 2D) = "white"{}
		_DecalTexture("decal", 2D) = "white"{}
		[Toggle] _ShowDecal("Show decal", float) = 0
	} 

	SubShader
	{
		Tags {"Queue" = "Transparent"}

		CGPROGRAM
		#pragma surface surf Lambert 

		sampler2D _Texture;
		sampler2D _DecalTexture;
		half _ShowDecal;

		struct Input
		{
			float2 uv_Texture;
		};

		void surf(Input IN, inout SurfaceOutput o)
		{
			fixed4 color = tex2D(_Texture, IN.uv_Texture); 
			fixed4 decal = tex2D(_DecalTexture, IN.uv_Texture); 
			if(_ShowDecal)
			{
				o.Albedo =  decal.r > 0.9 ? decal.rgb : color.rgb;
			}
			else
			{
				o.Albedo = color.rgb;
			}
			
		}
		ENDCG
	}
	fallback "Diffuse"
}