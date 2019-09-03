
Shader "Ozgun/Volumetric/SimpleSphere"
{
	Properties
	{
		_Sphere("Sphere Center", Vector) = (0, 0,0 ,0.5) // x,y,z, radius
    }

    SubShader
    {
        Tags { "Queue" = "Transparent" }

		Blend SrcAlpha OneMinusSrcAlpha
		Cull off
		//ZWrite off

	   Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "UnityLightingCommon.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float3 wPos : TEXCOORD0;
				float4 pos : SV_POSITION;
			};

			float4 _Sphere;

			#define STEPS 128
			#define STEP_SIZE 0.01

			v2f vert(appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.wPos = mul(unity_ObjectToWorld, v.vertex).xyz;

				return o;
			}


			int SphereHit(float3 pos, float3 center, float radius)
			{
				return distance(pos, center) < radius;
			}

			float3 RaymarchHit(float3 position, float3 direction)
			{
				for (int i = 0; i < STEPS; i++)
				{
					if (SphereHit(position, _Sphere.xyz, _Sphere.w))
					{
						return position;
					}

					position += direction * STEP_SIZE;
				}

				return float3(0,0,0);
			}

			fixed4 frag(v2f i) : SV_Target
			{
				float3 viewDirection = normalize(i.wPos - _WorldSpaceCameraPos);
				float3 depth = RaymarchHit(i.wPos, viewDirection);

				float3 worldNormal = normalize(depth - _Sphere.xyz);
				float lambertian = max(0, dot(worldNormal, _WorldSpaceLightPos0));

				if (length(depth) != 0)
				{
				#if UNITY_UV_STARTS_AT_TOP
					float scale = -1.0;
				#else
					float scale = 1.0;
				#endif

					float3 val = scale* depth * lambertian * _LightColor0 * 0.03;
					return fixed4(val.x, 0, 0, 1);
				}
				else
					return fixed4(1,1,1,0);
			}
			ENDCG
		}
    }
}

