Shader "Custom/TransitionEffect"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _EffectVal ("Effect Value",Range(0,1.0)) = 0.0
        _EffectColor ("Effect Color", Color) = (1,0,0,1)
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

            float rand (float2 co) {
                return frac(sin(dot(co.xy ,float2(12.9898,78.233))) * 43758.5453);
            }

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _EffectVal;
            float4 _EffectColor;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 p = i.uv;
                float t = _EffectVal*2.;
                float rs = 0.3;
                float r = rand(float2(0.0,p.y))*rs;
                float s = 0.5;
                float val = smoothstep(0.,s,(p.x+r+s)-t);
                float4 bc = _EffectColor;
                bc.a = 0;
                float4 col = lerp(bc,_EffectColor,val);
                return col;
            }
            ENDCG
        }
    }
}
