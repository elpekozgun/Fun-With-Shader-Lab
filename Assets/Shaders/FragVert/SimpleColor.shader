Shader "Ozgun/VertFrag/SimpleColor"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        
        Tags 
        { 
            //"RenderType" = "Opaque"
            "Queue" = "Transparent"
        }

        Blend srcAlpha oneminussrcalpha
        
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
            };

            // Output of vertex = input of fragment
            struct v2f
            {
                float4 vertex : SV_POSITION;
                float4 color : COLOR0;
            };

            float4 _Color;

            // Take vertex shdaer input, and make fragment shader input(or vertex shader output)
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.color = _Color;
                o.color.g += (v.vertex.x + 5) / 20;
                return o;
            }

            // Paint stuff using vertex shader output (or fragment shader input)
            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 c = i.color;
                //c.g = (i.vertex.z + 5) / 20; // screen space vertex 
                fixed4 col = c;
                return col;
            }
            ENDCG
        }
    }
}
