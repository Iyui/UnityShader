Shader "Custom/SpecularPixelShader"
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

       //使用结构体定义顶点着色器的输入
       struct a2v {
           float4 vertex :POSITION;//用模型空间的顶点坐标填充vertex变量
           float3 normal :NORMAL;//用模型空间的法线方向填充normal变量
       };
       //顶点着色器输出结构体
       struct v2f {
           //pos里包含了顶点在裁剪空间中的位置信息
           float4 pos:SV_POSITION;
           float3 worldNormal:TEXCOORD0;
           float3 worldPos:TEXCOORD1;
       };

       v2f vert(a2v v) {
           v2f o;

           //顶点位置从模型空间转换到裁剪空间
           o.pos = UnityObjectToClipPos(v.vertex);
           //计算漫反射需要4个参数：材质的漫反射颜色、顶点法线、光源的颜色和强度、光源方向
           o.worldNormal = mul(v.normal, (float3x3)unity_WorldToObject);
           o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
           return o;
       }

       fixed4 frag(v2f i) :SV_Target{
           //获取环境光
       fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
       fixed3 worldNormal = normalize(i.worldNormal);
       //仅适用于场景中只有一个平行光
       fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);

       fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLight));

       fixed3 reflectDir = normalize(reflect(-worldLight, worldNormal));

       fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz-i.worldPos.xyz);

       fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(reflectDir, viewDir)), _Gloss);

       return fixed4(ambient + diffuse + specular, 1.0);
       }
           ENDCG
           }
    }
        FallBack "Specular"
}
