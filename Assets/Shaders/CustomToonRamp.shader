Shader "Ozgun/CustomToonRamp"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _ToonRamp("Toon Ramp", 2D) = "white"{}        
        _Texture("Texture", 2D) = "white"{}
    }

    subshader
    {
        Tags {"Queue" = "Geometry"}

        // Lighting + <same name after surf "CustomBlinnPhong">
        CGPROGRAM
        #pragma surface surf ToonRamp

        fixed4 _Color;
        sampler2D _ToonRamp;
        sampler2D _Texture;

        // This function applies to every output parameter.
        half4 LightingToonRamp(SurfaceOutput s, half3 lightDir, half3 viewDir, half attenuation)
        {
            half lambertian = dot(s.Normal, lightDir);
            half diffuse =  lambertian * 0.5 + 0.5;
            float2 rampTex = diffuse;
            half3 ramp = tex2D(_ToonRamp,rampTex).rgb;            
            
            half4 color;
            color.rgb = s.Albedo * _LightColor0.rgb * ramp;
            color.a = s.Alpha;
            return color;
        }

        struct Input
        {
            float2 uv_Texture;
            float3 viewDir;
        };

        void surf(Input IN, inout SurfaceOutput o)
        {
            // float diff = dot (o.Normal, IN.viewDir);
			// float h = diff * 0.5 + 0.5;
			// float2 rh = h;
			// o.Albedo = tex2D(_ToonRamp, rh).rgb;
            o.Albedo = _Color.rgb + tex2D(_Texture,IN.uv_Texture).rgb;
        }

        ENDCG

    }
    fallback "Diffuse"

}