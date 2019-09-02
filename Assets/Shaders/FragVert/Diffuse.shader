Shader "Ozgun/VertFrag/Diffuse"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Color("Color", COLOR) = (1,1,1,1)
    }
    SubShader
    {
        Tags 
		{ 
			"RenderType"="Opaque"
			"LightMode" = "ForwardBase" 
		}
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
			#include "UnityLightingCommon.cginc"	// This needs to be included whenever lighting related stuff is calculated.

            struct appdata
            {
                float4 vertex	: POSITION;
				float3 normal	: NORMAL;
                float2 uv		: TEXCOORD0;
            };

            struct v2f
            {
                float2 uv		: TEXCOORD0;
				float3 diff		: COLOR0;
                float4 vertex	: SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			fixed4 _Color;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
				
				// lighting stuff, general diffuse. lambertian = n.l;
				half3 worldNormal = UnityObjectToWorldNormal(v.normal);
				half lambertian = max(0, dot(worldNormal, _WorldSpaceLightPos0.xyz));
				o.diff = lambertian * _LightColor0 + _Color;
                
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
				col *= float4(i.diff,1);
                return col;
            }
            ENDCG
        }
    }
}
