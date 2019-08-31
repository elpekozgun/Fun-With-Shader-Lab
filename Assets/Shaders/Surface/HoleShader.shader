Shader "Ozgun/Surface/Hole"
{
    Properties
    {
        _Texture("Diffuse", 2D) = "white"{}
    }

    subshader
    {
        // this way its drawn to the stencil buffer first.
        Tags{"Queue"="Geometry-1"}
        Colormask 0
        ZWrite off
        stencil
        {
            Ref 1   //write 1 on every pixel corresponding this shader on stencil buffer.
            Comp always // Always compare stencil buffer values (g.eq, eq, less, l.eq etc)
            Pass replace //What to do with the corresponding pixels on screen with this stencil buffer.
        }
        
        CGPROGRAM
        #pragma surface surf StandardSpecular

        sampler2D _Texture;

        struct Input
        {
            float2 uv_Texture;
        };

        void surf(Input IN, inout SurfaceOutputStandardSpecular o)
        {
            fixed4 c = tex2D(_Texture,IN.uv_Texture);
            o.Albedo = c.rgb;
        }
        
        ENDCG
    }
    FallBack "Diffuse"
}