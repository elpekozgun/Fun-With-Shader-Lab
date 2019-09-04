
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
		/*[HideInInspector]*/_WaveAmplitude("Wave Amp", float) = 0
	}

	SubShader
	{
		Tags { "Queue" = "Transparent" }
		LOD 100
		ZWrite on
		Blend dstAlpha OneMinusSrcAlpha
		//Cull off

		CGPROGRAM
		#pragma surface surf Lambert vertex:vert
		#pragma target 4.0

		sampler2D _MainTex;
		sampler2D _NormalTex;
		half4 _Color;
		//float _Amp;
		float _Freq;
		float _Speed;
		float _WaveAmplitude;
		
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

			// Circular Offset.
			half offsetVertical = sqrt(v.vertex.x * v.vertex.x + v.vertex.z * v.vertex.z);
			half value0 = sin(_Time.w * 0.1 * _Speed - v.vertex.x * _Freq - v.vertex.z * _Freq) * 0.2;
			v.vertex.y += value0;
			v.normal.z += value0;

			half value = sin(_Time.w * _Speed * _Freq + offsetVertical + v.vertex.x * _Offset.x + v.vertex.z * _Offset.y);
			
			float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;

			float a = worldPos.x - _Impact.x;
			float b = worldPos.z - _Impact.y;

			if (sqrt(a * a + b * b) < _Distance)
			{
				v.vertex.y += value * _WaveAmplitude;
				v.normal.z += value * _WaveAmplitude;
			}

		}

		void surf(Input IN, inout SurfaceOutput o )
		{
			o.Normal = UnpackNormal(tex2D(_NormalTex, IN.uv_NormalTex)).rgb;
			o.Normal *= float3(3, 3, 3);
			fixed4 color = tex2D(_MainTex, IN.uv_MainTex);
			/*o.Emission = color.rgb;*/
			o.Albedo = _Color.rgb;
			o.Alpha = _Color.a;
		}


	ENDCG
	}
}