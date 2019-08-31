Shader "Ozgun/Surface/ViewDirShader"
{
	SubShader
	{
		CGPROGRAM

		#pragma surface surf Lambert

		struct Input
		{
			float3 viewDir;
		};

		void surf(Input IN, inout SurfaceOutput o)
		{
			//half dotp = dot(IN.viewDir, o.Normal);
			half dotp = 1 - dot(IN.viewDir, o.Normal);
			o.Albedo = float3(1-dotp, dotp, 0);
		}
		ENDCG
	}
	fallback "diffuse"
}
