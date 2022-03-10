// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Sand"
{
	Properties
	{
		_Scale("Scale", Float) = 1
		_SineFrequency("SineFrequency", Float) = 1
		_SineRotationFloat("SineRotationFloat", Float) = 74.21
		_NoiseScale("NoiseScale", Float) = 2.5
		_DistortAmplitude("DistortAmplitude", Float) = 3.26
		_SineAmplitude("Sine Amplitude", Float) = 1
		_PolygonSides("Polygon Sides", Float) = 6
		_Tiling("Tiling", Vector) = (0,0,0,0)
		_Offset("Offset", Vector) = (0,0,0,0)
		_SandLowColor("SandLowColor", Color) = (0.4716981,0.4474743,0.1891242,0)
		_SandHighColor("SandHighColor", Color) = (0.7830189,0.7599346,0.5060075,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#include "PolygonGradient.hlsl"
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows 
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform float4 _SandLowColor;
		uniform float4 _SandHighColor;
		uniform float _Scale;
		uniform float _NoiseScale;
		uniform float2 _Tiling;
		uniform float2 _Offset;
		uniform float _DistortAmplitude;
		uniform float _SineRotationFloat;
		uniform float _SineFrequency;
		uniform float _SineAmplitude;
		uniform float _PolygonSides;


		//https://www.shadertoy.com/view/XdXGW8
		float2 GradientNoiseDir( float2 x )
		{
			const float2 k = float2( 0.3183099, 0.3678794 );
			x = x * k + k.yx;
			return -1.0 + 2.0 * frac( 16.0 * k * frac( x.x * x.y * ( x.x + x.y ) ) );
		}
		
		float GradientNoise( float2 UV, float Scale )
		{
			float2 p = UV * Scale;
			float2 i = floor( p );
			float2 f = frac( p );
			float2 u = f * f * ( 3.0 - 2.0 * f );
			return lerp( lerp( dot( GradientNoiseDir( i + float2( 0.0, 0.0 ) ), f - float2( 0.0, 0.0 ) ),
					dot( GradientNoiseDir( i + float2( 1.0, 0.0 ) ), f - float2( 1.0, 0.0 ) ), u.x ),
					lerp( dot( GradientNoiseDir( i + float2( 0.0, 1.0 ) ), f - float2( 0.0, 1.0 ) ),
					dot( GradientNoiseDir( i + float2( 1.0, 1.0 ) ), f - float2( 1.0, 1.0 ) ), u.x ), u.y );
		}


		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 temp_output_3_0 = ( i.uv_texcoord * _Scale * _NoiseScale );
			float gradientNoise16 = GradientNoise(temp_output_3_0,_NoiseScale);
			gradientNoise16 = gradientNoise16*0.5 + 0.5;
			float2 break19_g1 = float2( 0,0 );
			float cos12 = cos( radians( _SineRotationFloat ) );
			float sin12 = sin( radians( _SineRotationFloat ) );
			float2 rotator12 = mul( temp_output_3_0 - float2( 0.5,0.5 ) , float2x2( cos12 , -sin12 , sin12 , cos12 )) + float2( 0.5,0.5 );
			float temp_output_1_0_g1 = ( rotator12.y * ( _SineFrequency * 6.28318548202515 ) );
			float sinIn7_g1 = sin( temp_output_1_0_g1 );
			float sinInOffset6_g1 = sin( ( temp_output_1_0_g1 + 1.0 ) );
			float lerpResult20_g1 = lerp( break19_g1.x , break19_g1.y , frac( ( sin( ( ( sinIn7_g1 - sinInOffset6_g1 ) * 91.2228 ) ) * 43758.55 ) ));
			float temp_output_2_0_g2 = _PolygonSides;
			float cosSides12_g2 = cos( ( UNITY_PI / temp_output_2_0_g2 ) );
			float2 appendResult18_g2 = (float2(( 1.0 * cosSides12_g2 ) , ( 1.0 * cosSides12_g2 )));
			float2 break23_g2 = ( (frac( ( (temp_output_3_0*_Tiling + _Offset) + ( ( (-1.0 + (gradientNoise16 - 0.0) * (1.0 - -1.0) / (1.0 - 0.0)) * _DistortAmplitude ) + ( ( lerpResult20_g1 + sinIn7_g1 ) * _SineAmplitude ) ) ) )*2.0 + -1.0) / appendResult18_g2 );
			float polarCoords30_g2 = atan2( break23_g2.x , -break23_g2.y );
			float temp_output_52_0_g2 = ( 6.28318548202515 / temp_output_2_0_g2 );
			float2 appendResult25_g2 = (float2(break23_g2.x , -break23_g2.y));
			float2 finalUVs29_g2 = appendResult25_g2;
			float temp_output_44_0_g2 = ( cos( ( ( floor( ( 0.5 + ( polarCoords30_g2 / temp_output_52_0_g2 ) ) ) * temp_output_52_0_g2 ) - polarCoords30_g2 ) ) * length( finalUVs29_g2 ) );
			float4 lerpResult48 = lerp( _SandLowColor , _SandHighColor , saturate( ( ( 1.0 - temp_output_44_0_g2 ) / fwidth( temp_output_44_0_g2 ) ) ));
			o.Albedo = lerpResult48.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18900
813;196;1461;770;-748.2932;664.7941;1;True;False
Node;AmplifyShaderEditor.TexCoordVertexDataNode;2;-1296,-16;Inherit;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;-1248,112;Inherit;False;Property;_Scale;Scale;0;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1136,256;Inherit;False;Property;_SineRotationFloat;SineRotationFloat;2;0;Create;True;0;0;0;False;0;False;74.21;66.94;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;17;-1165.97,-240.2181;Inherit;False;Property;_NoiseScale;NoiseScale;3;0;Create;True;0;0;0;False;0;False;2.5;2.52;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;3;-1072,-16;Inherit;True;3;3;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RadiansOpNode;14;-912,256;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TauNode;10;-742.9177,500.0654;Inherit;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-852.9177,352.0655;Inherit;False;Property;_SineFrequency;SineFrequency;1;0;Create;True;0;0;0;False;0;False;1;9.55;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;12;-800,-16;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0.5,0.5;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;18;-900.6302,-246.17;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;5;-528,-16;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-610.9177,321.0655;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;16;-690.7294,-280.7919;Inherit;True;Gradient;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;14.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-400,-16;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;21;-352,-96;Inherit;False;Property;_DistortAmplitude;DistortAmplitude;4;0;Create;True;0;0;0;False;0;False;3.26;5.08;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;23;101.2518,187.5922;Inherit;False;Property;_SineAmplitude;Sine Amplitude;5;0;Create;True;0;0;0;False;0;False;1;0.13;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;19;-403.7482,-286.4078;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;11;-176,-16;Inherit;True;Noise Sine Wave;-1;;1;a6eff29f739ced848846e3b648af87bd;0;2;1;FLOAT;0;False;2;FLOAT2;0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;38;126.4135,-457.798;Inherit;False;Property;_Offset;Offset;8;0;Create;True;0;0;0;False;0;False;0,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;37;15.32799,-563.8343;Inherit;False;Property;_Tiling;Tiling;7;0;Create;True;0;0;0;False;0;False;0,0;2,2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.WireNode;36;-854.0444,-540.1448;Inherit;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;138.2518,-0.4078064;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-64,-288;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;24;334.5518,-119.4078;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;35;279.8272,-614.3679;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;39;463.7098,-188.163;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.FractNode;34;578.4933,-153.0889;Inherit;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;29;760.3947,-74.95064;Inherit;False;Constant;_Float3;Float 3;7;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;608,-336;Inherit;False;Property;_PolygonSides;Polygon Sides;6;0;Create;True;0;0;0;False;0;False;6;6;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;42;1095.888,-510.3111;Inherit;False;Property;_SandHighColor;SandHighColor;10;0;Create;True;0;0;0;False;0;False;0.7830189,0.7599346,0.5060075,0;1,0.9804677,0.7688679,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;40;1071.437,-724.7469;Inherit;False;Property;_SandLowColor;SandLowColor;9;0;Create;True;0;0;0;False;0;False;0.4716981,0.4474743,0.1891242,0;0.8207547,0.7681671,0.1897027,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;25;865.4849,-345.8802;Inherit;True;Polygon;-1;;2;6906ef7087298c94c853d6753e182169;0;4;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CustomExpressionNode;15;-1476.821,228.5203;Inherit;False; ;1;True;1;True;In0;FLOAT;0;In;;Inherit;False;My Custom Expression;False;False;0;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;48;1360.867,-557.0451;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1332.006,-155.6726;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Sand;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;1;Include;PolygonGradient.hlsl;False;;Custom;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;3;0;2;0
WireConnection;3;1;4;0
WireConnection;3;2;17;0
WireConnection;14;0;13;0
WireConnection;12;0;3;0
WireConnection;12;2;14;0
WireConnection;18;0;3;0
WireConnection;5;0;12;0
WireConnection;8;0;7;0
WireConnection;8;1;10;0
WireConnection;16;0;18;0
WireConnection;16;1;17;0
WireConnection;6;0;5;1
WireConnection;6;1;8;0
WireConnection;19;0;16;0
WireConnection;11;1;6;0
WireConnection;36;0;3;0
WireConnection;22;0;11;0
WireConnection;22;1;23;0
WireConnection;20;0;19;0
WireConnection;20;1;21;0
WireConnection;24;0;20;0
WireConnection;24;1;22;0
WireConnection;35;0;36;0
WireConnection;35;1;37;0
WireConnection;35;2;38;0
WireConnection;39;0;35;0
WireConnection;39;1;24;0
WireConnection;34;0;39;0
WireConnection;25;1;34;0
WireConnection;25;2;26;0
WireConnection;25;3;29;0
WireConnection;25;4;29;0
WireConnection;48;0;40;0
WireConnection;48;1;42;0
WireConnection;48;2;25;0
WireConnection;0;0;48;0
ASEEND*/
//CHKSM=8EDD5D8BF3100935C2A327AED16F187FAE487C2E