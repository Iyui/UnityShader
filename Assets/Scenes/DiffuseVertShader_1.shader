// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Custom/DiffuseVertShader_1"
{
    Properties
    {
        _Diffuse("Diffuse",Color)=(1,1,1,1)
    }
    SubShader
    {
       Pass{
           Tags{"LightMode"="ForwardBase"}//定义了正确的LightMode.我们才能得到一些Unity的内置光照变量
       
       CGPROGRAM
       #pragma vertex vert
       #pragma fragment frag

       #include "Lighting.cginc"

       fixed4 _Diffuse;

                   //使用结构体定义顶点着色器的输入
            struct a2v {
                float4 vertex :POSITION;//用模型空间的顶点坐标填充vertex变量
                float3 normal :NORMAL;//用模型空间的法线方向填充normal变量
            };

            struct v2f {
                //pos里包含了顶点在裁剪空间中的位置信息
                float4 pos:SV_POSITION;
                //用于存储颜色信息
                fixed3 color:COLOR0;
            };


            v2f vert(a2v v){
                v2f o;

                o.pos = UnityObjectToClipPos(v.vertex);

                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

                fixed3 worldNormal = normalize(mul(v.normal,(float3x3)unity_WorldToObject));

                fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);

                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal,worldLight));

                o.color = ambient + diffuse;

                return o;
            }

            fixed4 frag(v2f i):SV_Target{
                return fixed4(i.color,1.0);
            }
       ENDCG
       }
    }
    FallBack "Diffuse"
}