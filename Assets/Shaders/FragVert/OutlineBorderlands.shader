Shader "Ozgun/VertFrag/OutlineBorderlands"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_OutlineColor("outline", COLOR) = (1,0,0,0)
		_OutlineThickness("thickness", Range(-0.1,0.5)) = 0
	}

	SubShader
	{
		Tags { "Queue" = "Transparent" }
		LOD 100
		
		
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				return col;
			}
			ENDCG
		}


		Pass
		{
			Cull Front
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 normal : NORMAL;
			};

			struct v2f
			{
				float4 vertex	: SV_POSITION;
				float4 color	: COLOR0;
			};

			half _OutlineThickness;
			fixed4 _OutlineColor;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex= UnityObjectToClipPos(v.vertex);

				float3 norm = normalize(mul((float3x3)UNITY_MATRIX_MV, v.normal));
				float2 offset = TransformViewToProjection(norm.xy);
				o.vertex.xy += offset * o.vertex.z * _OutlineThickness;
				o.color = _OutlineColor;
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				return i.color;
			}
			ENDCG
		}
			

		
    }
	Fallback "Diffuse"
}
