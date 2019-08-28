Shader "Ozgun/BlinnPhong"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _SpecColor("Specular Color", Color) = (1,1,1,1)
        _Specular("Specular", Range(0,1)) = 0.5
        _Gloss("Gloss", Range(0,1)) = 0.5
    }

	SubShader
	{
        Tags{"Queue" = "Geometry"}

		CGPROGRAM
		#pragma surface surf BlinnPhong

        fixed4 _Color;
        //fixed4 _SpecColor; Unity weirdly defines it when compiled...
        half _Specular;
        half _Gloss;
        
		struct Input
		{
            float2 uv_Texture;
		};

		void surf(Input IN, inout SurfaceOutput o)
		{
			o.Albedo = _Color.rgb;
            o.Specular = _Specular;
            o.Gloss = _Gloss;
		}
		ENDCG
	}
	fallback "diffuse"
}
