Shader "Unlit/SnowTrailDraw"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_BrushTex ("Brush", 2D) = "white"{}
		_Coordinate("Coordinate", Vector) = (0,0,0,0)
		_Color("Color", Color) = (1,0,0,0)
		_Size("Size", Range(0,100)) = 0.25
		_Strength("Strength",Range(0,10)) = 10
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
		Cull off
		ZWrite Off
		ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

			sampler2D _MainTex;
			sampler2D _BrushTex;
			float4 _MainTex_ST;
			fixed4 _Coordinate;
			fixed4 _Color;
			float _Size;
			float _Strength;

			float4 _Brush_TexelSize;
			float4 _MainTex_TexelSize;

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

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
				/*fixed scale = (_Size * _Brush_TexelSize.z * _MainTex_TexelSize.x);

				fixed2 pos = i.uv - (_Coordinate.xy - 0.5 * scale);

				if (pos.x > 0 && pos.x < 1 && pos.y > 0 && pos.y < 1)
					_Color = tex2D(_BrushTex, pos);
				*/
				//return lerp(col, float4(maskCol.rgb, 1.0), maskCol.a);
				float d = pow(saturate(1 - distance(i.uv, _Coordinate.xy)), 100 / _Size);
				
				
				fixed4 drawColor = _Color * (d* _Strength);
				return saturate(col + drawColor);
            }
            ENDCG
        }
    }
}
