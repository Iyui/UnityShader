Shader "Custom/Texture2DShader"
{
    Properties
    {
        _Color ("Color Tint", Color) = (1,1,1,1)
		_MainTex("Main Tex",2D) = "white"{}
		_Specular("Specular", Color) = (1,1,1,1)
		_Gloss("Gloss", Range(8.0,256)) = 20
	}
		SubShader
		{
			Pass
			{
				Tags { "LightMode" = "ForwardBase" }
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#include "Lighting.cginc"


			fixed4 _Color;
		sampler2D _MainTex;
		float4 _MainTex_ST;
		fixed4 _Specular;
		float _Gloss;

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
			float4 uv :TEXCOORD2;
		}


			}
		}
			FallBack "Diffuse"
}
