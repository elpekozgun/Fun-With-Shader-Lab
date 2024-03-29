﻿
Shader "Ozgun/VertFrag/RainRipple"
{
	Properties
	{
		_MainTex("Base", 2D) = "white" {}
		_NormalTex("Normal", 2D) = "black"{}
		_Color("Color", Color) = (1,1,1,1)
		_Freq("Frequency", float) = 0.01
		_Amp("Amplitude", float) = 0.2
		_Speed("Speed", float) = 1
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

		sampler2D _MainTex;
		sampler2D _NormalTex;
		half4 _Color;
		float _Amp;
		float _Freq;
		float _Speed;
		float _WaveAmplitude;
		half _Smoothness;
		half _NormalAmp;
		
		float2 _Offset;
		float2 _Impact;
		float _Distance;


		struct Input
		{
			float2 uv_MainTex;
			float2 uv_NormalTex;
		};

		struct appdata
		{
			float4 vertex	: POSITION;
			float3 normal	: NORMAL;
			float4 tangent	: TANGENT;
			float2 texcoord : TEXCOORD0;
			float4 texcoord1: TEXCOORD1;
			float4 texcoord2: TEXCOORD2;
		};

		//Single ripple. Not sufficient. When second ripple drops first one cancels.

		void vert(inout appdata v, out Input o)
		{
			UNITY_INITIALIZE_OUTPUT(Input, o);

			half offsetVertical = sqrt(v.vertex.x * v.vertex.x + v.vertex.z * v.vertex.z);
			//half value0 = sin(_Time.w * _Speed - v.vertex.x * _Freq - v.vertex.z * _Freq) * _Amp;
			//v.vertex.y += value0;
			//v.normal.z += value0;

			half value = sin(_Time.w * _Speed + _Freq * offsetVertical + (v.vertex.x * _Offset.x + v.vertex.z * _Offset.y));
			//float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

			float a = _Impact.x - _Offset.x;
			float b = _Impact.y - _Offset.y;

			if (sqrt(a * a + b * b) < _Distance)
			{
				v.vertex.y += value * _WaveAmplitude;
				v.normal.z -= value * _WaveAmplitude;
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
}