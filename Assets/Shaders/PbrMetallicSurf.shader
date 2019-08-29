Shader "Ozgun/PbrMetallic"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _Metallic("Metallic", range(0,1)) = 0.5
        _MetalTex("Name",2D) = "black" {}
        _NormalTex("Normal", 2D) = "white"{}
        _EmisSlider("Emission", range(0,1)) = 0.5
    }

    subshader
    {
        Tags{"Queue"="Geometry"}
        CGPROGRAM
        #pragma surface surf Standard

        sampler2D _MetalTex;
        sampler2D _NormalTex;
        fixed4 _Color;
        half _Metallic;
        half _EmisSlider;

        struct Input
        {
            float2 uv_MetalTex;
            float2 uv_NormalTex;
        };

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            o.Smoothness = tex2D(_MetalTex,IN.uv_MetalTex).r;
            o.Albedo = _Color.rgb;
            o.Metallic = _Metallic;
            o.Emission = tex2D(_MetalTex,IN.uv_MetalTex).r * _EmisSlider;
            o.Normal = UnpackNormal(tex2D(_NormalTex,IN.uv_NormalTex));
        }

        
        ENDCG
    }
    FallBack "Diffuse"
}