Shader "Custom/TransitionEffect2"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _EffectVal ("Effect Value",Range(0,1.0)) = 0.0
        _EffectColor ("Effect Color", Color) = (1,0,0,1)
        _DirX ("Effect x direction", int) = 1
        _DirY ("Effect y direction", int) = 0
        _Random("Random animation", float) = 0
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
            #define B(p,s) max(abs(p).x-s.x,abs(p).y-s.y)

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
            float _EffectVal;
            float4 _EffectColor;
            int _DirX;
            int _DirY;
            float _Random;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            float rand (float2 co) {
                return frac(sin(dot(co.xy, float2(12.9898,78.233))) * 43758.5453);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 p = i.uv;

                p*=10.;
                float2 id = floor(p)-0.5;
                id.x+=4.*_DirX;
                id.y+=4.*_DirY;
                p = frac(p)-0.5;

                float t = _EffectVal*0.6;
                float targetScale = (rand(id)*_Random)+((id.x*_DirX)+(id.y*_DirY))*0.3;
                float s = t*targetScale;
                float d = B(p,float2(s,s));

                float4 bc = _EffectColor;
                bc.a = 0;
                float4 col = lerp(bc,_EffectColor,1.0-smoothstep(0.,0.001,d));

                return col;
            }
            ENDCG
        }
    }
}
