Shader "Custom/BulinnPhoneShader"
{
    Properties
    {
        _Diffuse("Diffuse", Color) = (1,1,1,1)
        _Specular("Specular", Color) = (1,1,1,1)
        _Gloss("Gloss", Range(8,256)) = 20
    }
        SubShader
    {
        Pass{
        Tags { "LightMode" = "ForwardBase" }

        CGPROGRAM
       #pragma vertex vert
       #pragma fragment frag

       #include "Lighting.cginc"

       fixed4 _Diffuse;
       fixed4 _Specular;
       float _Gloss;

       //ʹ�ýṹ�嶨�嶥����ɫ��������
       struct a2v {
           float4 vertex :POSITION;//��ģ�Ϳռ�Ķ����������vertex����
           float3 normal :NORMAL;//��ģ�Ϳռ�ķ��߷������normal����
       };
       //������ɫ������ṹ��
       struct v2f {
           //pos������˶����ڲü��ռ��е�λ����Ϣ
           float4 pos:SV_POSITION;
           float3 worldNormal:TEXCOORD0;
           float3 worldPos:TEXCOORD1;
       };

       v2f vert(a2v v) {
           v2f o;

           //����λ�ô�ģ�Ϳռ�ת�����ü��ռ�
           o.pos = UnityObjectToClipPos(v.vertex);
           //������������Ҫ4�����������ʵ���������ɫ�����㷨�ߡ���Դ����ɫ��ǿ�ȡ���Դ����
           o.worldNormal = mul(v.normal, (float3x3)unity_WorldToObject);
           o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
           return o;
       }

       fixed4 frag(v2f i) :SV_Target{
           //��ȡ������
       fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
       fixed3 worldNormal = normalize(i.worldNormal);
       //�������ڳ�����ֻ��һ��ƽ�й�
       fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);

       fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLight));

       fixed3 reflectDir = normalize(reflect(-worldLight, worldNormal));

       fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);

       fixed3 halfDir = normalize(worldLight+ viewDir);

       fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0,dot(worldNormal, halfDir)), _Gloss);

       return fixed4(ambient + diffuse + specular, 1.0);
       }
           ENDCG
           }
    }
        FallBack "Specular"
}