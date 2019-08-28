Shader "Ozgun/RimLighting"
{
	Properties
	{
		_Diffuse("Diffuse", 2D) = "white"{}
		_RimColor ("Rim Color", Color) = (0.0, 0.5, 0.5, 0)
		_RimPower ("Rim Power", range(0.5, 6.0)) = 3.0
		_Stripe("stripe Value", range(0.0,1.0)) = 0.4
	}

	SubShader
	{
		CGPROGRAM
		#pragma surface surf Lambert

		float3 _RimColor;
		half _RimPower;
		half _Stripe;
		sampler2D _Diffuse;

		struct Input
		{
			float2 uv_Diffuse;
			float3 viewDir;
			float3 worldPos;
		};

		void surf(Input IN, inout SurfaceOutput o)
		{
			half rim = 1 - saturate(dot(IN.viewDir, o.Normal));
			rim = pow(rim,_RimPower);
			o.Emission = frac(IN.worldPos.y * 20 ) > _Stripe ? float3(0,1,0) * rim : float3(0,0,1) * rim;
			o.Albedo = tex2D(_Diffuse,IN.uv_Diffuse);
			// o.Emission = IN.worldPos.y > 1 ? float3(0,1,0) : float3(0,0,1);
			//o.Emission += (rim > 0.6 ? float3(1,0,0) : rim > 0.3 ? float3(0,1,0) : rim > 0.1 ? float3(0,0,1) : 0);   
			//o.Emission += _RimColor.rgb *pow(rim,_RimPower);
		}
		ENDCG
	}

	// frac(float3 ) function takes the fractional part of a floating point number.

	//Get a new computer...
	fallback "Diffuse"

}