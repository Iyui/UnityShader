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

            //ʹ�ýṹ�嶨�嶥����ɫ��������
            struct a2v {
                float4 vertex :POSITION;//��ģ�Ϳռ�Ķ����������vertex����
                float3 normal :NORMAL;//��ģ�Ϳռ�ķ��߷������normal����
                float4 texcoord:TEXCOORD0;
            };

            struct v2f {
                //pos������˶����ڲü��ռ��е�λ����Ϣ
                float4 pos:SV_POSITION;
                float3 worldNormal:TEXCOORD0;
                float3 worldPos:TEXCOORD1;
                float2 uv :TEXCOORD2;
            };

            //��������ռ�ķ��߷���Ͷ���λ���Լ��任����������֮꣬�󴫵ݸ�ƬԪ��ɫ��
            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.uv = TRANSFORM_TEX(v.texcoord,_MainTex);//ʹ�����������ֵ���Զ�������������б任���õ����յ���������
                return o;
            }
            fixed4 frag(v2f i) :SV_Target{
                fixed3 worldNormal = normalize(i.worldNormal);
                fixed3 worldLight = normalize(UnityWorldSpaceLightDir(i.worldPos));

                fixed4 texColor = tex2D(_MainTex, i.uv);

                fixed3 albedo = texColor.rgb * _Color.rgb;//��������в��������ؼ���õ�������ֵ������ɫ���Եĳ˻���Ϊ������

                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;

                fixed3 diffuse = _LightColor0.rgb * albedo * max(0,dot(worldNormal,worldLight));

                return fixed4(ambient + diffuse , texColor.a * _AlphaScale);
            }
            ENDCG
            }
        }
            FallBack "Transparent/VertexLit"
}
