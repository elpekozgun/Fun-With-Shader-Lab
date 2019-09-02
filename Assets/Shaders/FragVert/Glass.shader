Shader "Ozgun/VertFrag/Glass"
{


    Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_BumpTex("NormalTex", 2D) = "bump"{}
		_ScaleUV("Scale", Range(1,200)) = 1
	}

	SubShader
	{
		Tags { "Queue" = "Transparent+1" }
		LOD 100
		ZWrite on
		ZTest LEqual
		Cull off

		GrabPass{}
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float4 uv : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex	: SV_POSITION;
				float2 uv		: TEXCOORD0;
				float2 uvBump	: TEXCOORD1;
				float4 uvGrab	: TEXCOORD2;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _GrabTexture;
			float4 _GrabTexture_TexelSize;
			sampler2D _BumpTex;
			float4 _BumpTex_ST;
			half _ScaleUV;


			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				o.uvBump = TRANSFORM_TEX(v.uv, _BumpTex);

			#if UNITY_UV_STARTS_AT_TOP
				float scale = -1.0;
			#else
				float scale = 1.0;
			#endif

				o.uvGrab.xy = (float2(o.vertex.x, o.vertex.y * scale) + o.vertex.w) * 0.5;
				o.uvGrab.zw = o.vertex.zw;
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				half2 bump = UnpackNormal(tex2D(_BumpTex, i.uvBump)).rg;
				float2 offset = bump * _ScaleUV * _GrabTexture_TexelSize.xy;
				i.uvGrab.xy += offset * i.uvGrab.z;

				fixed4 col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvGrab));
				fixed4 tint = tex2D(_MainTex, i.uv);
				col *= tint;
				return col;
			}
			ENDCG
		}
		
    }
	Fallback "Diffuse"
}
