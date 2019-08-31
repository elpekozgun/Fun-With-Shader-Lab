Shader "Ozgun/Surface/CustomLambert"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)        
    }

    subshader
    {
        Tags {"Queue" = "Geometry"}

        CGPROGRAM
        #pragma surface surf CustomLambert
        
        fixed4 _Color;

        // Lighting + <same name after surf "CustomLambert">
        half4 LightingCustomLambert(SurfaceOutput s, half3 lightDir, half attenuation)
        {
            half lambertian = dot(s.Normal, lightDir);
            half4 color;
            color.rgb = s.Albedo * _LightColor0.rgb * (lambertian * attenuation);
            color.a = s.Alpha;
            return color;
        }

        struct Input
        {
            float2 uv_Texture;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            o.Albedo = _Color.rgb;
        }

        ENDCG
    }
    fallback "Diffuse"

}