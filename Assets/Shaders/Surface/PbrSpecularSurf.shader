Shader "Ozgun/Surface/PbrSpecular"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _MetallicTex("Metal \m/",2D) = "black" {}
        _NormalTex("Normal", 2D) = "white"{}
        _SpecColor("Specular", Color) = (1,1,1,1)
    }

    subshader
    {
        Tags{"Queue"="Geometry"}
        CGPROGRAM
        #pragma surface surf StandardSpecular

        sampler2D _MetallicTex;
        sampler2D _NormalTex;
        fixed4 _Color;
        //Recall that idiot Unity defines _SpecColor builtin...

        struct Input
        {
            float2 uv_MetallicTex;
            float2 uv_NormalTex;
        };

        void surf(Input IN, inout SurfaceOutputStandardSpecular o)
        {
            o.Albedo = _Color.rgb;
            o.Smoothness =  tex2D(_MetallicTex,IN.uv_MetallicTex).r;
            o.Specular = _SpecColor.rgb;
            o.Normal = UnpackNormal(tex2D(_NormalTex, IN.uv_NormalTex));
        }

        
        ENDCG
    }
    FallBack "Diffuse"
}