Shader "Custom/TransitionEffect3"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _EffectColor ("Effect Color", Color) = (0,0,0,1)
        _Blur ("Blur",float) = 0.001
    }
    SubShader
    {
        Tags{ "Queue" = "AlphaTest" "RenderType" = "TransparentCutout" "IgnoreProjector" = "True" }
        LOD 200
        Blend SrcAlpha OneMinusSrcAlpha
        Cull Off
        ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #define S(d,b)1.0-smoothstep(0.0,b,d)
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _EffectColor;
            float _Blur;
            float4 _CirclePos[5];
            float _CircleSize[5];

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 res = _ScreenParams.xy;
                float2 p = i.uv-0.5;
                p.x*=lerp(1.0,(res.x/res.y),step((res.x/res.y),1.0));
                p.y*=lerp(1.0,(res.y/res.x),step((res.y/res.x),1.0));

                float4 col = _EffectColor;

                float d = length(p-_CirclePos[0].xy)-_CircleSize[0];
                float d2 = length(p-_CirclePos[1].xy)-_CircleSize[1];
                d = min(d,d2);
                d2 = length(p-_CirclePos[2].xy)-_CircleSize[2];
                d = min(d,d2);
                d2 = length(p-_CirclePos[3].xy)-_CircleSize[3];
                d = min(d,d2);
                d2 = length(p-_CirclePos[4].xy)-_CircleSize[4];
                d = min(d,d2);
                col = lerp(col,float4(1,1,1,0),S(d,_Blur));

                return col;
            }
            ENDCG
        }
    }
}
