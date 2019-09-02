Shader "Ozgun/VertFrag/GrabTextureSimpleRipple"
{
    Properties
    {
        _Texture("Texture", 2D) = "white"{}
        _ScaleUVx("scale X", float) = 2
        _ScaleUVy("scale Y", float) = 2
    }
    SubShader
    {
        
        Tags 
        { 
            //"RenderType" = "Opaque"
            "Queue" = "Transparent"
        }

        //Blend srcAlpha oneminussrcalpha
        
		GrabPass{} //takes whatever is about to be drawn on the screen (framebuffer data. and must be defined as _GrabTexture in shader)

        Pass
        {
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            // Input for vertex
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            // Output of vertex = input of fragment
            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD00;
            };

			sampler2D _GrabTexture;
            sampler2D _Texture;
            float4 _Texture_ST; 
			float4 _GrabTexture_ST;
            float _ScaleUVx;
            float _ScaleUVy;

#if UNITY_UV_STARTS_AT_TOP
			float scale = -1.0;
#else
			float scale = 1.0;
#endif

            // Take vertex shdaer input, and make fragment shader input(or vertex shader output)
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _GrabTexture);
				o.uv.x = sin(o.uv.x * _ScaleUVx);
				o.uv.y = cos(o.uv.y * _ScaleUVy) ;// *_SinTime;

                return o;
            }

            // Paint stuff using vertex shader output (or fragment shader input)
            fixed4 frag (v2f i) : SV_Target
            {
				fixed4 c = tex2D(_GrabTexture,i.uv);
				c += tex2D(_Texture,i.uv);
                return c;
            }
            ENDCG
        }
    }
}
