Shader "Custom/AlphaBlend"
{
    Properties
    {
        _Color("Main Tint", Color) = (1,1,1,1)
        _MainTex("Main Tex", 2D) = "white" {}
        _AlphaScale("Alpha Cutoff", Range(0,1)) = 1
    }
        SubShader
        {
            Tags {"Queue" = "Transparent" "IgnoreProjector" = "True"  "RenderType" = "TransparentCutout" }
            Pass{
                Tags { "LightMode" = "ForwardBase" }
                ZWrite off
            Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc"
            fixed4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed _AlphaScale;

            //使用结构体定义顶点着色器的输入
            struct a2v {
                float4 vertex :POSITION;//用模型空间的顶点坐标填充vertex变量
                float3 normal :NORMAL;//用模型空间的法线方向填充normal变量
                float4 texcoord:TEXCOORD0;
            };

            struct v2f {
                //pos里包含了顶点在裁剪空间中的位置信息
                float4 pos:SV_POSITION;
                float3 worldNormal:TEXCOORD0;
                float3 worldPos:TEXCOORD1;
                float2 uv :TEXCOORD2;
            };

            //计算世界空间的法线方向和顶点位置以及变换后的纹理坐标，之后传递给片元着色器
            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.uv = TRANSFORM_TEX(v.texcoord,_MainTex);//使用纹理的属性值来对顶点纹理坐标进行变换，得到最终的纹理坐标
                return o;
            }
            fixed4 frag(v2f i) :SV_Target{
                fixed3 worldNormal = normalize(i.worldNormal);
                fixed3 worldLight = normalize(UnityWorldSpaceLightDir(i.worldPos));

                fixed4 texColor = tex2D(_MainTex, i.uv);

                fixed3 albedo = texColor.rgb * _Color.rgb;//对纹理进行采样。返回计算得到的纹素值，与颜色属性的乘积作为反射率

                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;

                fixed3 diffuse = _LightColor0.rgb * albedo * max(0,dot(worldNormal,worldLight));

                return fixed4(ambient + diffuse , texColor.a * _AlphaScale);
            }
            ENDCG
            }
        }
            FallBack "Transparent/VertexLit"
}
