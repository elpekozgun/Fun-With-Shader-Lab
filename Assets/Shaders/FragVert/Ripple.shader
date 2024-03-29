﻿Shader "Ozgun/VertFrag/Ripple"
{
	Properties
	{
		_MainTex("Base", 2D) = "white" {}
		_NormalTex("Normal", 2D) = "black"{}
		_Color("Color", Color) = (1,1,1,1)
		_Freq("Frequency", float) = 0.01
		_Speed("Speed", float) = 1
		_AmplitudeAmplifier("Amplitude Amp", float) = 1
		_TravelDistanceOffset("TravelDistanceOffset", float) = 0
		_Smoothness("Smoothness", Range(0,1)) = 0
		_NormalAmp("Normal Amp", Range(0,5)) = 1

		//Tesellation Stuff
		_Displacement("Displacement", Range(0,1)) = 0.5
		_DispTex("Displacement Texture", 2D) = "gray" {}
		_Tess("Tessellation", Range(1,32)) = 4
	}

		SubShader
		{
			Tags { "Queue" = "Transparent" }
			LOD 300
			ZWrite on
			Blend dstAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma surface surf Standard addshadow fullforwardshadows vertex:vert tessellate:TessFixed nolightmap
			#pragma target 5.0

			#define MAX_WAVE 256

			sampler2D _MainTex;
			sampler2D _NormalTex;
			sampler2D _DispTex;
			fixed4 _Color;
			float _Freq;
			float _Speed;
			float _AmplitudeAmplifier;
			float _TravelDistance[MAX_WAVE];
			float _TravelDistanceOffset;
			float _Amplitude[MAX_WAVE];
			float _MeshScale;
			float _OffsetX[MAX_WAVE];
			float _OffsetZ[MAX_WAVE];
			float _T0[MAX_WAVE];
			float _Displacement;
			float _Tess;

			half _Smoothness;
			half _NormalAmp;

			float4 TessFixed()
			{
				return _Tess;
			}

			struct appdata 
			{
				float4 vertex : POSITION;
				float4 tangent : TANGENT;
				float3 normal : NORMAL;
				float2 texcoord : TEXCOORD0;
			};

			struct Input
			{
				float2 uv_MainTex;
				float2 uv_NormalTex;
			};

			void vert(inout appdata v)
			{
				//UNITY_INITIALIZE_OUTPUT(Input, o);

				for (int i = 0; i < MAX_WAVE; i++)
				{
					float px = (v.vertex.x - _OffsetX[i]);
					float pz = (v.vertex.z - _OffsetZ[i]);

					half offsetVertical = sqrt(px * px + pz * pz);
					_T0[i] = _Time.w;

					float t = _Time.w - _T0[i];

					//half value = cos(( _Speed + _Freq * offsetVertical));
					half value = cos(t * offsetVertical) * _Amplitude[i];

					if (offsetVertical < _TravelDistance[i] && offsetVertical > _TravelDistance[i] - _TravelDistanceOffset)
					{
						float d = tex2Dlod(_DispTex, float4(v.texcoord.xy, 0, 0)).r * _Displacement;
						v.vertex.xyz += v.normal * d * value * _AmplitudeAmplifier;
						v.normal.z += value * _AmplitudeAmplifier;
					}
				}
			}


			void surf(Input IN, inout SurfaceOutputStandard o)
			{
				fixed4 color = tex2D(_MainTex, IN.uv_MainTex) * _Color;
				o.Albedo = color.rgb;
				o.Smoothness = _Smoothness;
				o.Normal = UnpackNormal(tex2D(_NormalTex, IN.uv_NormalTex)).rgb;
				o.Normal *= float3(_NormalAmp, _NormalAmp, 1);
				o.Alpha = color.a;
			}

			ENDCG
		}
			Fallback "Diffuse"
}
