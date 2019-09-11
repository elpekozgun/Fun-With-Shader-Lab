Shader "Ozgun/VertFrag/Snow" 
{
	Properties
	{
		_SnowTex("Snow Texture", 2D) = "white" {}
		_SnowColor("Snow Color", color) = (1,1,1,0)
		_GroundTex("Ground Texture",2D) = "white" {}
		_GroundColor("Ground Color", color) = (1,1,1,0)

		_DispTex("Disp Tex", 2D) = "white"{}

		_NormalMap("Normalmap", 2D) = "normal" {}
		_GroundNormal("Ground Normal", 2D) = "normal"{}
		_HeightMap("Height Map", 2D) = "height"{}
		_TrailMap("Trail Map", 2D) = "black" {}
		
		_Tess("Tessellation", Range(1,32)) = 4
		_Displacement("Displacement", Range(0, 1.0)) = 0.3
		_SpecColor("Spec color", color) = (0.5,0.5,0.5,0.5)
		_Gloss("Gloss", Range(0,1)) = 0.5
		_Specular("Specular", Range(0,1)) = 0.5
		_NormalAMP("normal Amp", Range(0,5)) = 1
		_SnowGroundMixLevel("range", Range(0,10)) = 1
	}
	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 300

		CGPROGRAM
		#pragma surface surf BlinnPhong addshadow fullforwardshadows vertex:vert tessellate:Tess nolightmap
		#pragma target 4.6
		#include "Tessellation.cginc"

		struct appdata 
		{
			float4 vertex : POSITION;
			float4 tangent : TANGENT;
			float3 normal : NORMAL;
			float2 texcoord : TEXCOORD0;
			float3 trailnormal : TEXCOORD1;
		};

		sampler2D _SnowTex;
		sampler2D _GroundTex;
		fixed4 _SnowColor;
		fixed4 _GroundColor;

		sampler2D _DispTex;
			
		sampler2D _NormalMap;
		sampler2D _TrailMap;
		sampler2D _HeightMap;
		sampler2D _GroundNormal;

			
		float _Displacement;
		float _Tess;

		half _Specular;
		half _Gloss;
		half _NormalAMP;

		half _SnowGroundMixLevel;

		struct Input
		{
			float2 uv_SnowTex;
			float2 uv_GroundTex;
			float2 uv_TrailMap;
			float2 uv_HeightMap;
			float3 worldPos;
		};

		float4 Tess(appdata v0, appdata v1, appdata v2)
		{
			float minDist = 5.0;
			float maxDist = 20.0;
			return UnityDistanceBasedTess(v0.vertex, v1.vertex, v2.vertex, minDist, maxDist, _Tess);
		}

		void vert(inout appdata v)
		{
			float d = tex2Dlod(_TrailMap, float4(v.texcoord.xy,0,0)).r * _Displacement;
			v.vertex.xyz += v.normal * (1 - d) ;
		}
			
		void surf(Input IN, inout SurfaceOutput o) 
		{
			half4 snowColor = tex2D(_SnowTex, IN.uv_SnowTex) * _SnowColor;
			half4 groundColor = tex2D(_GroundTex, IN.uv_SnowTex) * _GroundColor;
			float lerpVal = tex2Dlod(_TrailMap, float4(IN.uv_SnowTex, 0, 0)).r;
			
			half4 c = lerp(snowColor, groundColor, lerpVal);
			/*half4 c = float4(0,0,0,0);
			if (IN.worldPos.y < _SnowGroundMixLevel)
			{
				c = lerp(snowColor, groundColor, lerpVal);
			}
			else
			{
				c = snowColor;
			}*/

			float3 normalSnow = UnpackNormal(tex2D(_NormalMap, IN.uv_SnowTex));
			float3 normalGround = UnpackNormal(tex2D(_GroundNormal, IN.uv_SnowTex));
			float3 n = lerp(normalSnow, normalGround, lerpVal);
			n *= float3(_NormalAMP, _NormalAMP, 1);
			o.Normal = n;

			fixed4 col = tex2D(_DispTex, IN.uv_SnowTex);

			o.Albedo = float3(col.a, 0,0) + snowColor;
			//o.Albedo = c.rgb;
			o.Specular = _Specular;
			o.Gloss = _Gloss;
			o.Alpha = 1;// _GroundColor.a;
			//o.Normal = UnpackNormal(tex2D(_NormalMap, IN.uv_SnowTex));
		}
		ENDCG
	}
		FallBack "Diffuse"
}