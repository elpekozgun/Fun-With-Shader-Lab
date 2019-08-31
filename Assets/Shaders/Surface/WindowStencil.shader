Shader "Ozgun/Surface/WindowStencil"
{
    Properties
    {
        _Texture("Diffuse", 2D) = "white"{}
        _SRef("Stencil Ref", float) = 1
        [Enum(UnityEngine.Rendering.CompareFunction)] _SCompare("StencilComp", float) = 8
        [Enum(UnityEngine.Rendering.StencilOp)] _SPass("Stencil Op", float) = 2
    }

    subshader
    {
        // this way its drawn to the stencil buffer first.
        Tags{"Queue"="Geometry-1"}
        
        Colormask 0
        ZWrite off
        
        stencil
        {
            Ref[_SRef]
            Comp[_SCompare]
            Pass[_SPass]
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