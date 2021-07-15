// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/SpecularVertShader"
{
    Properties
    {
        _Diffuse("Diffuse", Color) = (1,1,1,1)
        _Specular("Specular", Color) = (1,1,1,1)
        _Gloss ("Gloss", Range(8.0,256)) = 20
    }
    SubShader
    {
        Pass{
        Tags { "LightMode"="ForwardBase" }

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
        //���ڴ洢��ɫ��Ϣ
        fixed3 color : COLOR;
    };

    v2f vert(a2v v) {
        v2f o;

        //����λ�ô�ģ�Ϳռ�ת�����ü��ռ�
        o.pos = UnityObjectToClipPos(v.vertex);
        //��ȡ������
        fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
        //������������Ҫ4�����������ʵ���������ɫ�����㷨�ߡ���Դ����ɫ��ǿ�ȡ���Դ����
        fixed3 worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
        //�������ڳ�����ֻ��һ��ƽ�й�
        fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);

        fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLight));

        //���㷴�������
        fixed3 reflectDir = normalize(reflect(-worldLight, worldNormal));
        //����λ�ô�ģ�Ϳռ�תΪ����ռ䣬���������������ռ�λ��������ȿɵ�����ռ��µ��ӽǷ���
        fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld, v.vertex).xyz);
        fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(reflectDir, viewDir)), _Gloss); 

        o.color = ambient + diffuse +specular;

        return o;
    }

    fixed4 frag(v2f i) :SV_Target{
               return fixed4(i.color,1.0);
    }
        ENDCG
        }
    }
    FallBack "Specular"
}
