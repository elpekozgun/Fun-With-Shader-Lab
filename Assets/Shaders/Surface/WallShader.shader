Shader "Ozgun/Surface/Wall"
{
    Properties
    {
        _Texture("Diffuse", 2D) = "white"{}
    }

    subshader
    {
        Tags{"Queue"="Geometry"}

        Stencil
        {
            Ref 1
            comp notequal   // if values in stencil are not equal to 1, pass keep. otherwise discard.
            pass keep
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