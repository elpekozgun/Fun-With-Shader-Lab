Shader "Ozgun/CustomBlinnPhong"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)        
    }

    subshader
    {
        Tags {"Queue" = "Geometry"}

        // Lighting + <same name after surf "CustomBlinnPhong">
        CGPROGRAM
        #pragma surface surf CustomBlinnPhong

        half4 LightingCustomBlinnPhong(SurfaceOutput s, half3 lightDir, half3 viewDir, half attenuation)
        {
            half3 halfway =  normalize(lightDir + viewDir); 
            
            half lambertian = dot(s.Normal, lightDir);
            half diffuse = max(0,lambertian);
            
            float NdotH = max(0, dot(s.Normal, halfway));
            float spec = pow(NdotH, 48); // --> Unity Uses 48...
            
            half4 color;
            color.rgb = (s.Albedo * _LightColor0.rgb * diffuse + _LightColor0.rgb * spec) * attenuation;
            color.a = s.Alpha;
            return color;
        }

        fixed4 _Color;
        
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