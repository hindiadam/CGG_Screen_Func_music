Shader "Unlit/musicGraph"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Bands ("Bands", Float) = 30.0
        _Segments ("Segments", Float) = 40.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work

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

            sampler2D _MainTex;
            float _Bands; // yatay
            float _Segments; // dikey
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 uv = i.uv;
                float2 p;
                p.x = floor(uv.x*_Bands) / _Bands;
                p.y = floor(uv.y*_Segments) /_Segments;
                float fft = tex2D(_MainTex,float2(p.x,0)).r;
                float3 col = lerp(float3(0.0,1.0,0.0),float3(1.0, 2.0, 0.0), sqrt(uv.y));
                float mask = (p.y < fft) ? 1.0 : 0.1;
                float2 d = frac((uv - p) * float2(_Bands,_Segments)) -0.5;
                float led = smoothstep(0.5, 0.35, abs(d.x)) * smoothstep(0.5, 0.35, abs(d.y));
                float3 ledColor = led * col * mask;
                return float4(ledColor, 1.0);
            }
            ENDCG
        }
    }
}
