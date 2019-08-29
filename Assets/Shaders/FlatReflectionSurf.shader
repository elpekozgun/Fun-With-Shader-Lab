
// Use this shader with a model that calculates normals with 0 angle.

Shader "Ozgun/FlatReflection"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_Diffuse("Diffuse", 2D) = "white"{}
		_Emission("Emission", 2D) = "black"{}
		_Normal("Normal", 2D) = "normal"{}
		_Slider("Normal Intensity", range(0,10)) = 1
        _CubeMap("Cubemap",CUBE) = "white"{}
	}

		SubShader
		{
			CGPROGRAM
				#pragma surface surf Lambert 

				fixed4 _Color;
				sampler2D _Diffuse;
				sampler2D _Emission;
				sampler2D _Normal;
                samplerCUBE _CubeMap;
				half _Slider;

				struct Input
				{
					float2 uv_Diffuse;
					float2 uv_Emission;
					float2 uv_Normal;
					float3 worldRefl;
					float3 viewDir;
				};

				void surf(Input IN, inout SurfaceOutput o)
				{
					half dotp = dot(IN.viewDir, o.Normal);
					o.Albedo = _Color.rgb * dotp;
                    o.Albedo += texCUBE(_CubeMap,IN.worldRefl).rgb;
					o.Emission = tex2D(_Emission, IN.uv_Emission ).rgb;
					//o.Albedo = tex2D(_Diffuse, IN.uv_Diffuse ).rgb;
					//o.Normal = UnpackNormal(tex2D(_Normal,IN.uv_Normal));
					//o.Normal *= float3(_Slider,_Slider,1);
				}

			ENDCG
		}

		//Save Poor People
		FallBack "Diffuse"
}