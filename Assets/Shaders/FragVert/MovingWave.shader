Shader "Ozgun/VertFrag/MovingWave"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_FoamTex("Foam", 2D) = "black"{}
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
				float2 uv_FoamTex;
				float3 vertColor;
			};

			sampler2D _MainTex;
			sampler2D _FoamTex;
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
				float waveHeight = (sin(t + v.vertex.x * _Freq) + sin(t + v.vertex.x * 2 * _Freq)) * _Amplitude;
				v.vertex.y += waveHeight;
				v.normal = normalize(float3(v.normal.x + waveHeight, v.normal.y, v.normal.z));
				o.vertColor = waveHeight + 1.5;
			}

			void surf(Input IN, inout SurfaceOutput o)
			{
				float t = _Time * _Speed;
				float3 water = (tex2D(_MainTex, IN.uv_MainTex + float2(t, 0))).rgb;
				float3 foam = ((tex2D(_FoamTex, IN.uv_FoamTex + float2(t / 4.0, 0)))).rgb;
				o.Albedo = (water + foam) * 0.5 * IN.vertColor.rgb;
			}


			 ENDCG
		}
}
