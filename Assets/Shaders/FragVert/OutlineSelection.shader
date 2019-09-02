Shader "Ozgun/VertFrag/OutlineSelection"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_OutlineColor("outline", COLOR) = (1,0,0,0)
		_OutlineThickness("thickness", Range(-0.1,0.1)) = 0
		_Selected("selected", float) = 0
		[Enum(UnityEngine.Rendering.CompareFunction)] _Compare1("comp1", float) = 8
		[Enum(UnityEngine.Rendering.CompareFunction)] _Compare2("comp2", float) = 8
	}

	SubShader
	{
		Tags { "Queue" = "Transparent" }
		
		LOD 100
			
		//ZWrite off
		ZTest [_Compare1]
		Pass
		{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag alpha:fade
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float4 normal : NORMAL;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			half _OutlineThickness;
			fixed4 _OutlineColor;
			half _Selected;

			v2f vert(appdata v)
			{
				v2f o;
				if (_Selected)
				{
					float4 value = v.vertex + v.normal * _OutlineThickness;
					o.vertex = UnityObjectToClipPos(value);// +v.normal * _OutlineThickness;
				}
				else
				{
					o.vertex = UnityObjectToClipPos(v.vertex);
				}
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 col = _OutlineColor;
				return col;
			}
			ENDCG
		}
		
		//ZTest [_Compare2]
		ZWrite on
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

		
    }
	Fallback "Diffuse"
}
