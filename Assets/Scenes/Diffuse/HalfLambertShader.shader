// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Custom/DiffuseVertShader_1"
{
	Properties
	{
		_Diffuse("Diffuse",Color) = (1,1,1,1)
	}
		SubShader
	{
	   Pass{
		   Tags{"LightMode" = "ForwardBase"}//��������ȷ��LightMode.���ǲ��ܵõ�һЩUnity�����ù��ձ���

	   CGPROGRAM
	   #pragma vertex vert
	   #pragma fragment frag

	   #include "Lighting.cginc"

	   fixed4 _Diffuse;

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
	fixed3 worldNormal : TEXCOORD0;
};

//����Ҫ������ռ��µķ��ִ��ݸ�ƬԪ��ɫ��
v2f vert(a2v v) {
	v2f o;

	//����λ�ô�ģ�Ϳռ�ת�����ü��ռ�
	o.pos = UnityObjectToClipPos(v.vertex);

	o.worldNormal = mul(v.normal, (float3x3)unity_WorldToObject);
	return o;
}

fixed4 frag(v2f i) :SV_Target{
	//��ȡ������
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
fixed3 worldNormal = normalize(i.worldNormal);

fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);

fixed3 halfLambert = dot(worldNormal, worldLight) * 0.5 + 0.5;

fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * halfLambert;

fixed3 color = ambient + diffuse;
	return fixed4(color,1.0);
}
ENDCG
	}
	}
		FallBack "Diffuse"
}