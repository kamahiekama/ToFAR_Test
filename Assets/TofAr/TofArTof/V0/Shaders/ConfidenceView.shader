﻿Shader "TofAr/Tof/ConfidenceViewShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Strength("Strength", Float) = 1
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100
		Cull Off

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _Strength;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				float2 uv = float2(i.uv.x, 1 - i.uv.y);
				fixed4 col = tex2D(_MainTex, uv);
				col *= 16;

				float u16 = ((uint)col.r * (uint)pow(2, 3 * 4)) + ((uint)col.g * (uint)pow(2, 2 * 4)) + ((uint)col.b * (uint)pow(2, 1 * 4)) + col.a;

				float grey = u16 / 7.0f * _Strength;
				col = fixed4(grey, grey, grey, 1);
				return col;
			}
			ENDCG
		}
	}
}
