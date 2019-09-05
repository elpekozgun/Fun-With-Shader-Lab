Shader "Ozgun/VertFrag/Ripple"
{
	Properties
	{
		_MainTex("Base", 2D) = "white" {}
		_NormalTex("Normal", 2D) = "black"{}
		_Color("Color", Color) = (1,1,1,1)
		_Amplitude("Amplitude", float) = 0.2
		_WaveLength("Wave Length", float) = 0.5
		_Freq("Frequency", float) = 0.01
		_Speed("Speed", float) = 1
		_Smoothness("Smoothness", Range(0,1)) = 0
		_NormalAmp("Normal Amp", Range(0,5)) = 1
		_OffsetX("Offset X", Range(-1,1)) = 0
		_OffsetY("Offset Y", Range(-1,1)) = 0
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
		fixed4 _Color;
		float _Amplitude;
		float _WaveLength;
		float _Freq;
		float _Speed;
		float _OffsetX;
		float _OffsetY;

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

			half offsetVertical = sqrt(v.vertex.x * v.vertex.x + v.vertex.z * v.vertex.z);
			half value = sin(_Time.w * _Speed + _Freq * offsetVertical + _OffsetX);

			v.vertex.y += value * _Amplitude;
			v.normal.z -= value * _Amplitude;

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