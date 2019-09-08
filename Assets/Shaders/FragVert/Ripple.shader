Shader "Ozgun/VertFrag/Ripple"
{
	Properties
	{
		_MainTex("Base", 2D) = "white" {}
		_NormalTex("Normal", 2D) = "black"{}
		_Color("Color", Color) = (1,1,1,1)
		_Freq("Frequency", float) = 0.01
		_Speed("Speed", float) = 1
		_AmplitudeAmplifier("Amplitude Amp", float) = 1
		_Smoothness("Smoothness", Range(0,1)) = 0
		_NormalAmp("Normal Amp", Range(0,5)) = 1
		
	}

	SubShader
	{
		Tags { "Queue" = "Transparent" }
		LOD 100
		ZWrite on
		Blend dstAlpha OneMinusSrcAlpha

		CGPROGRAM
		#pragma surface surf Standard vertex:vert
		#pragma target 4.0
		
		#define MAX_WAVE 8

		sampler2D _MainTex;
		sampler2D _NormalTex;
		fixed4 _Color;
		float _Freq;
		float _Speed;
		float _AmplitudeAmplifier;
		float _TravelDistance[MAX_WAVE];
		float _Amplitude[MAX_WAVE];
		float _OffsetX[MAX_WAVE];
		float _OffsetZ[MAX_WAVE];

		half _Smoothness;
		half _NormalAmp;
		

		struct Input
		{
			float2 uv_MainTex;
			float2 uv_NormalTex;
		};


		void vert(inout appdata_full v, out Input o)
		{
			UNITY_INITIALIZE_OUTPUT(Input, o);

			float3 p = v.vertex.xyz;

			for (int i = 0; i < MAX_WAVE; i++)
			{
				float px = p.x - _OffsetX[i];
				float pz = p.z - _OffsetZ[i];

				half offsetVertical = sqrt(px * px + pz * pz);

				half value = cos((_Speed + _Freq * offsetVertical));

				if (sqrt(px * px + pz * pz) < _TravelDistance[i])
				{
					v.vertex.y -= value * _Amplitude[i] * _AmplitudeAmplifier;
					v.normal.z += value * _Amplitude[i] * _AmplitudeAmplifier;
				}
			}
		}

		void surf(Input IN, inout SurfaceOutputStandard o )
		{
			fixed4 color = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = color.rgb;

			o.Normal = UnpackNormal(tex2D(_NormalTex, IN.uv_NormalTex)).rgb;
			o.Normal *= float3(_NormalAmp, _NormalAmp, 1);
			o.Alpha = color.a;
			o.Smoothness = _Smoothness;
		}

		ENDCG
	}
	Fallback "Diffuse"
}