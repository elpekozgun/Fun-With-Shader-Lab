Shader "Ozgun/VertFrag/RainRipple"
{
	Properties
	{
		_MainTex("Base", 2D) = "white" {}
		_NormalTex("Normal", 2D) = "black"{}
		_Color("Color", Color) = (1,1,1,1)
		//_Amp("Amplitude", float) = 1
		_Freq("Frequency", float) = 0.01
		_Speed("Speed", float) = 1
		_WaveAmplitude1("W1", float) = 0
		_WaveAmplitude2("W2", float) = 0
		_WaveAmplitude3("W3", float) = 0
		_WaveAmplitude4("W4", float) = 0
		_WaveAmplitude5("W5", float) = 0
		_WaveAmplitude6("W6", float) = 0
		_WaveAmplitude7("W7", float) = 0
		_WaveAmplitude8("W8", float) = 0
	}

	SubShader
	{
		Tags { "Queue" = "Transparent" }
		LOD 100
		ZWrite on
		//Cull off

		CGPROGRAM
		#pragma surface surf Lambert vertex:vert

		sampler2D _MainTex;
		sampler2D _NormalTex;
		half4 _Color;
		float _Amp;
		float _Speed;
		float _Freq;
		float _WaveAmplitude1, _WaveAmplitude2, _WaveAmplitude3, _WaveAmplitude4, _WaveAmplitude5, _WaveAmplitude6, _WaveAmplitude7, _WaveAmplitude8;
		float _OffsetX1, _OffsetZ1, _OffsetX2, _OffsetZ2, _OffsetX3, _OffsetZ3, _OffsetX4, _OffsetZ4, _OffsetX5, _OffsetZ5, _OffsetX6, _OffsetZ6, _OffsetX7, _OffsetZ7, _OffsetX8, _OffsetZ8;

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


		#define MAX_COUNT 3
		#define PI 3.14159

		void vert(inout appdata v)
		{
			half offsetVertX = v.vertex.x;
			half offsetVertZ = v.vertex.y;

			half offset = sqrt(v.vertex.x * v.vertex.x + v.vertex.z * v.vertex.z);
			//half value = sin(_Time.w * _Speed - offset * _Freq) * _Amp;
			//v.vertex.y += value;
			//v.normal.z += value;

			half value1 = sin(_Time.w * _Speed  - offset * _Freq + v.vertex.x * _OffsetX1 + v.vertex.z * _OffsetZ1);
			half value2 = sin(_Time.w * _Speed - offset * _Freq + v.vertex.x * _OffsetX2 + v.vertex.z * _OffsetZ2);
			half value3 = sin(_Time.w * _Speed - offset * _Freq + v.vertex.x * _OffsetX3 + v.vertex.z * _OffsetZ3);
			half value4 = sin(_Time.w * _Speed - offset * _Freq + v.vertex.x * _OffsetX4 + v.vertex.z * _OffsetZ4);
			half value5 = sin(_Time.w * _Speed - offset * _Freq + v.vertex.x * _OffsetX5 + v.vertex.z * _OffsetZ5);
			half value6 = sin(_Time.w * _Speed - offset * _Freq + v.vertex.x * _OffsetX6 + v.vertex.z * _OffsetZ6);
			half value7 = sin(_Time.w * _Speed - offset * _Freq + v.vertex.x * _OffsetX7 + v.vertex.z * _OffsetZ7);
			half value8 = sin(_Time.w * _Speed - offset * _Freq + v.vertex.x * _OffsetX8 + v.vertex.z * _OffsetZ8);
			
			v.vertex.y += value1 * _WaveAmplitude1;
			v.normal.z += value1 * _WaveAmplitude1;
			v.vertex.y += value2 * _WaveAmplitude2;
			v.normal.z += value2 * _WaveAmplitude2;
			v.vertex.y += value3 * _WaveAmplitude3;
			v.normal.z += value3 * _WaveAmplitude3;
			v.vertex.y += value4 * _WaveAmplitude4;
			v.normal.z += value4 * _WaveAmplitude4;
			v.vertex.y += value5 * _WaveAmplitude5;
			v.normal.z += value5 * _WaveAmplitude5;
			v.vertex.y += value6 * _WaveAmplitude6;
			v.normal.z += value6 * _WaveAmplitude6;
			v.vertex.y += value7 * _WaveAmplitude7;
			v.normal.z += value7 * _WaveAmplitude7;
			v.vertex.y += value8 * _WaveAmplitude8;
			v.normal.z += value8 * _WaveAmplitude8;

		}


		void surf(Input IN, inout SurfaceOutput o )
		{
			o.Emission = _Color;
			o.Normal = UnpackNormal(tex2D(_NormalTex, IN.uv_NormalTex));
			o.Normal *= float3(3, 3, 3);
			fixed4 color = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = color.xyz;
		}


	ENDCG
	}
}