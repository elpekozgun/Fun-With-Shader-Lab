Shader "Ozgun/VertFrag/SimplePlasma"
{
	Properties
	{
		_Tint("Tint", Color) = (1,1,1,1)
		_Speed("Speed", Range(-200,200)) = 2
		_Scale1("Scale 1", Range(0.1,10)) = 2
		_Scale2("Scale 2", Range(0.1,10)) = 2
		_Scale3("Scale 3", Range(0.1,10)) = 2
		_Scale4("Scale 4", Range(0.1,10)) = 2
	}
		SubShader
		{
			Tags { "RenderType" = "Opaque" }
			LOD 100


			CGPROGRAM
			#pragma	surface surf Lambert

			struct Input
			{
				float2 uv_MainTex;
				float3 worldPos;
			};

			float4 _Tint;	
			float _Speed;
			float _Scale1;
			float _Scale2;
			float _Scale3;
			float _Scale4;

			void surf(Input IN, inout SurfaceOutput o)
			{
				const float PI = 3.14159265;
				float time = _Speed * _Time.x;
			
				// horizontal
				float color = sin(IN.worldPos.x * _Scale1 + time);
				// vertical
				color += sin(IN.worldPos.z * _Scale2 + time);
				// diagonal
				color += sin(_Scale3 * (IN.worldPos.x * sin(time * 0.5) + IN.worldPos.z * cos(time * 0.33)) + time);
				//circular
				float c1 = pow(IN.worldPos.x + 0.5 * sin(time * 0.2), 2);
				float c2 = pow(IN.worldPos.z + 0.5 * cos(time * 0.33), 2);
				
				color += sin(sqrt(_Scale4 * (c1 + c2) + 1 + time));
				
				o.Albedo.r = sin(color * 0.25 * PI);
				o.Albedo.g = sin(color * 0.25 * PI + 2 * PI * 0.25);
				o.Albedo.b = sin(color * 0.25 * PI + 4 * PI * 0.25);
				o.Albedo *= _Tint;
			}


			 ENDCG
		}
}
