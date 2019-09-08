Shader "Ozgun/Volumetric/SphereFog"
{
    Properties
    {
		_Center("Center + Radius", vector) = (0,0,0,0.5)
		_FogColor("Color", Color) = (1, 1, 1, 1)
		_Ratio("Ratio", Range(0, 1)) = 0.5
		_Density("Density", Range(0,1)) = 0.5
    }

    SubShader
    {
        Tags { "Queue"="Transparent" }

		Blend SrcAlpha OneMinusSrcAlpha
		Cull Off Lighting Off ZWrite Off
		ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

			 
		float CalculateFog(float3 sphereCenter, float sphereRadius, float ratio, float density, float camPos, float viewDir, float maxDistance)
		{
			//(d.d)t2 + 2d.(o – c)t + (o – c).(o – c) – R2 = 0
			//	 a			b				c
			float o_c = camPos - sphereCenter;
			float3 a = dot(viewDir, viewDir);
			float3 b = 2 * dot(viewDir,o_c);
			float3 c = dot(o_c, o_c) - sphereRadius * sphereRadius;

			float discriminant = b * b - 4 * a * c;
			if (discriminant < 0.0f)
			{
				return 0;
			}

			float t1 = max(-b - sqrt(discriminant) / (2 * a), 0);
			float t2 = max(-b + sqrt(discriminant) / (2 * a), 0);
			
			float farMax = min(maxDistance, t2);
			float sample = t1;
			float step = (farMax - t1) / 10;
			float stepDensity = density;

			float centerValue = 1 / (1 - ratio);

			float clarity = 1;
			for (int i = 0; i < 10; i++)
			{
				float3 pos = camPos + viewDir * sample;
				float value = saturate(centerValue * (1 - length(pos) / sphereRadius));
				float fogValue = saturate(value * stepDensity);
				clarity *= (1 - fogValue);
				sample += step;
			}

			return 1 - clarity;
		}


        struct v2f
        {
            float3 viewDir	: TEXCOORD0;
            float4 pos		: SV_POSITION;
			float4 projection: TEXCOORD1;
        };


		float4 _Center;
		fixed4 _FogColor;
		float _Ratio;
		float _Density;
		sampler2D _CameraDepthTexture;

        v2f vert (appdata_base v)
        {
			v2f o;
			float4 wPos = mul(unity_ObjectToWorld, v.vertex);
			o.pos = UnityObjectToClipPos(v.vertex);
			o.viewDir = wPos.xyz - _WorldSpaceCameraPos;
			o.projection = ComputeScreenPos(o.pos);

			float inFrontOf = (o.pos.z / o.pos.w) > 0;
			o.pos.z *= inFrontOf;

			return o;
        }

		fixed4 frag(v2f i) : SV_Target
		{
			half4 color = half4(1,1,1,1);
			float depth = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.projection))));
			float3 viewDir = normalize(i.viewDir);

			float fog = CalculateFog(_Center.xyz, _Center.w, _Ratio, _Density, _WorldSpaceCameraPos, viewDir, depth);

			color.rgb = _FogColor.rgb;
			color.a = fog;

			return color;

        }
        ENDCG
        }
    }
}
