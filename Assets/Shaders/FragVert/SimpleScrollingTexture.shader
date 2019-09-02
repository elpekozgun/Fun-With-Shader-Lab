Shader "Ozgun/VertFrag/SimpleScrollingTexture"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_FoamTex("Foam", 2D) = "black"{}
		_SpeedX("Speed X",Range(-100,100)) = 0
		_SpeedY("Speed Y",Range(-100,100)) = 0
	}
	
	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 100

		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		sampler2D _FoamTex;
		half _SliderX;
		half _SliderY;
		half _SpeedX;
		half _SpeedY;

		struct Input
		{
			float2 uv_MainTex;
			float2 uv_FoamTex;
		};

		void surf(Input IN, inout SurfaceOutput o) 
		{
			_SpeedX *= _Time;
			_SpeedY *= _Time;
			float3 water = (tex2D(_MainTex, IN.uv_MainTex + float2(_SpeedX, _SpeedY))).rgb;
			float3 foam = ((tex2D(_FoamTex, IN.uv_FoamTex + float2(_SpeedX / 4.0, _SpeedY / 6.0)))).rgb;
			o.Albedo = (water + foam) * 0.5;
		}

          
		ENDCG
    }
}
