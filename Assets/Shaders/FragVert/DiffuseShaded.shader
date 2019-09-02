Shader "Ozgun/VertFrag/DiffuseShaded"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Pass
        {
			Tags
			{
				"RenderType" = "Opaque"
				"LightMode" = "ForwardBase"
			}
			LOD 100

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
			#include "UnityLightingCommon.cginc"	// This needs to be included whenever lighting related stuff is calculated.

            struct appdata
            {
                float4 vertex		: POSITION;
				float3 normal		: NORMAL;
                float4 texCoord		: TEXCOORD0;
            };

            struct v2f
            {
                float2 uv		: TEXCOORD0;
				float4 diff		: COLOR0;
                float4 vertex	: SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.texCoord, _MainTex);

				// lighting stuff, general diffuse. lambertian = n.l;
				half3 worldNormal = UnityObjectToWorldNormal(v.normal);
				half lambertian = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
				o.diff = lambertian * _LightColor0;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
				col *= i.diff;
                return col;
            }
            ENDCG
        }
		Pass
		{
			Tags {"LightMode" = "ShadowCaster"}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_shadowcaster
			#include "UnityCG.cginc"

			struct appdata 
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
			};

			struct v2f 
			{
				V2F_SHADOW_CASTER;
			};

			v2f vert(appdata v)
			{
				v2f o;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
				return o;
			}

			float4 frag(v2f i) : SV_Target
			{
				SHADOW_CASTER_FRAGMENT(i)
			}
			ENDCG
		}
    }
}
