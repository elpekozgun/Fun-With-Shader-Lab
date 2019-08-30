Shader "Ozgun/Hologram"
{
	Properties
	{
		_RimColor ("Rim Color", Color) = (0.0, 0.5, 0.5, 0)
		_RimPower ("Rim Power", range(0.5, 6.0)) = 3.0
	}

	SubShader
	{
		Tags{"Queue" = "Transparent"}

		// Single pass is a single draw call. We want depth test before shader code runs. 
		// so need 2 draw calls, or another extra "Pass1"
		
		Pass 
		{
			ZWrite On
			Colormask 0
		}

		CGPROGRAM
		#pragma surface surf Lambert alpha:fade

		fixed4 _RimColor;
		half _RimPower;

		struct Input
		{
			float3 viewDir;
		};

		void surf(Input IN, inout SurfaceOutput o)
		{
			half rim = 1 - saturate(dot(IN.viewDir, o.Normal));
			rim = pow(rim,_RimPower);
	
			o.Emission.r = _RimColor.r * pow(rim, _RimPower);
			o.Emission.g = _RimColor.g * pow(rim, _RimPower);
			o.Emission.b = _RimColor.b * pow(rim, _RimPower);
			o.Alpha = pow(rim, _RimPower);// * _RimColor.a;
		}
		ENDCG

	}

	// frac(float3 ) function takes the fractional part of a floating point number.

	//Get a new computer...
	fallback "Diffuse"

}