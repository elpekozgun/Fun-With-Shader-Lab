Shader "Ozgun/VertFrag/SimpleWave"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Tint("Tint", Color) = (1,1,1,1)
		_Freq("Frequency", Range(0,10)) = 3
		_Speed("Speed", Range(0,200)) = 20
		_Amplitude("Amplitude", Range(0,2)) = 0.3
	}
	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 100


		CGPROGRAM
		#pragma	surface surf Lambert vertex:vert

		struct Input
		{
			float2 uv_MainTex;
			float3 vertColor;
		};
		
		sampler2D _MainTex;
		fixed4 _Tint;
		half _Freq;
		half _Speed;
		half _Amplitude;

        struct appdata
        {
            float4 vertex	: POSITION;
			float3 normal	: NORMAL;
            float2 texcoord : TEXCOORD0;
			float4 texcoord1: TEXCOORD1;
			float4 texcoord2: TEXCOORD2;
			
        };

		void vert(inout appdata v, out Input o)
		{
			UNITY_INITIALIZE_OUTPUT(Input, o);
			float t = _Time * _Speed;
			float waveHeight = sin(t + v.vertex.x * _Freq) * _Amplitude + sin(t + v.vertex.x * 2*_Freq ) * _Amplitude;
			v.vertex.y += waveHeight;
			v.normal = normalize(float3(v.normal.x + waveHeight, v.normal.y, v.normal.z));
			o.vertColor = waveHeight + 2;
		}

		void surf(Input IN, inout SurfaceOutput o)
		{
			float4 color = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = color * IN.vertColor.rgb;
		}

          
         ENDCG
    }
}
