// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Simple Shader_1" {
    Properties {
        _Color("Color Tint",Color) = (1.0,1.0,1.0,1.0)
    }


    SubShader {//针对显卡A的
        Pass {
            //设置渲染状态和标签
            
            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag
/*
            float4 vert(float4 v:POSITION):SV_POSITION{
                return UnityObjectToClipPos (v);

            }
            fixed4 frag():SV_Target{
                return fixed4(1.0,1.0,1.0,1.0);
            }
*/

            fixed4 _Color;

            //使用结构体定义顶点着色器的输入
            struct a2v {
                float4 vertex :POSITION;//用模型空间的顶点坐标填充vertex变量
                float3 normal :NORMAL;//用模型空间的法线方向填充normal变量
                float4 texcoord:TEXCOORD0;//用模型的第一套纹理坐标填充texcoord变量
            };

            struct v2f {
                //pos里包含了顶点在裁剪空间中的位置信息
                float4 pos:SV_POSITION;
                //用于存储颜色信息
                fixed3 color:COLOR0;
            };

            //顶点着色器，逐顶点执行，CG/HLSL语义：POSITION：把模型的顶点坐标填充到输入参数v中，SV_POSITION ：顶点着色器输出是裁剪空间中的顶点坐标
            v2f vert(a2v v)
            {
                //声明输出结构
                v2f o;
                o.pos =  UnityObjectToClipPos (v.vertex);
                //v.normal 包含了顶点的法线方向，其分量范围在[-1.0,1.0]
                //下面的代码把分量范围映射到了[0.0，1.0]
                //存储到o.color中传递给片元着色器
                o.color = v.normal * 0.5 +fixed3(0.5,0.5,0.5);
                
                return o;
            }
            fixed4 frag(v2f i):SV_Target {
                //将插值后的i.color显示到屏幕上
                fixed3 c = i.color;
                //c*=_Color.rgb;
                return fixed4(c,1.0);

            }
            
            ENDCG
        }
    }
}