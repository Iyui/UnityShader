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
			float4 uv :TEXCOORD2;
		}


			}
		}
			FallBack "Diffuse"
}
