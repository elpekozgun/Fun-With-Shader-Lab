Shader "Ozgun/Surface/DiffuseStencil"
{
	Properties
	{
		_Diffuse("Diffuse", 2D) = "white"{}
		_Emission("Emission", 2D) = "black"{}
		_Normal("Normal", 2D) = "normal"{}
		_Slider("Normal Intensity", range(0,10)) = 1


        _SRef("Stencil Ref",float) = 1
        [Enum(UnityEngine.Rendering.CompareFunction)] _SCompare("Stencil Compare",float) = 8
        [Enum(UnityEngine.Rendering.StencilOp)] _SPass("Stencil Op", float) = 2
	}
		SubShader
		{
			ZWrite On
			//deferred rendering are quite good for many lights.
			// but its terrible for transparency

            Stencil
            {
                Ref[_SRef]
                Comp[_SCompare]
                Pass[_SPass]
            }


			CGPROGRAM
				#pragma surface surf Lambert 

				sampler2D _Diffuse;
				sampler2D _Emission;
				sampler2D _Normal;
				half _Slider;

				struct Input
				{
					float2 uv_Diffuse;
					float2 uv_Emission;
					float2 uv_Normal;
					float2 uv_Specular;
					float3 worldRefl;
				};

				void surf(Input IN, inout SurfaceOutput o)
				{
					o.Albedo = IN.worldRefl;
					o.Albedo = o.Normal;
					o.Albedo = tex2D(_Diffuse, IN.uv_Diffuse ).rgb;
					o.Emission = tex2D(_Emission, IN.uv_Emission ).rgb;
					o.Normal = UnpackNormal(tex2D(_Normal,IN.uv_Normal ));
					o.Normal *= float3(_Slider,_Slider,1);
				}

			ENDCG
		}

		//Save Poor People
		FallBack "Diffuse"
}