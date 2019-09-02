Shader "Ozgun/VertFrag/Extruded"
{
    Properties
    {
        _Texture("Diffuse", 2D) = "white"{}
		_Extrusion("Extrusion", Range(-2,2)) = 0.1
    }

    subshader
    {

		CGPROGRAM
        #pragma surface surf Lambert vertex:vert

		// Vertex Shader part	
		half _Extrusion;

		struct appdata
		{
			float4 vertex	: POSITION;
			float3 normal	: NORMAL;
			float4 texcoord	: TEXCOORD0;
		};

		void vert(inout appdata v)
		{
			v.vertex.xyz += v.normal * _Extrusion;
		}

		sampler2D _Texture;

		struct Input
		{
			float2 uv_Texture;
		};

        void surf(Input IN, inout SurfaceOutput o)
        {
			o.Albedo = tex2D(_Texture,IN.uv_Texture).rgb;
        }
        
        ENDCG
    }
    FallBack "Diffuse"
}