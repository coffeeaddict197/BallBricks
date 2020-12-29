//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Hidden/VideoDecode" {
Properties {
_MainTex ("_MainTex (A)", 2D) = "black" { }
_SecondTex ("_SecondTex (A)", 2D) = "black" { }
_ThirdTex ("_ThirdTex (A)", 2D) = "black" { }
}
SubShader {
 Pass {
  Name "YCBCR_TO_RGB1"
  ZTest Always
  ZWrite Off
  Cull Off
  GpuProgramID 28028
Program "vp" {
SubProgram "gles hw_tier00 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform highp int unity_StereoEyeIndex;
uniform highp vec4 _RightEyeUVOffset;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
  xlv_TEXCOORD0 = (((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw) + (float(unity_StereoEyeIndex) * _RightEyeUVOffset.xy));
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _SecondTex;
uniform sampler2D _ThirdTex;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 y_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0).wwww;
  y_1.w = tmpvar_2.w;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_SecondTex, xlv_TEXCOORD0);
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_ThirdTex, xlv_TEXCOORD0);
  lowp float tmpvar_5;
  tmpvar_5 = (1.15625 * tmpvar_2.w);
  y_1.x = ((tmpvar_5 + (1.59375 * tmpvar_4.w)) - 0.87254);
  y_1.y = (((tmpvar_5 - 
    (0.390625 * tmpvar_3.w)
  ) - (0.8125 * tmpvar_4.w)) + 0.53137);
  y_1.z = ((tmpvar_5 + (1.984375 * tmpvar_3.w)) - 1.06862);
  lowp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = y_1.xyz;
  gl_FragData[0] = tmpvar_6;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform highp int unity_StereoEyeIndex;
uniform highp vec4 _RightEyeUVOffset;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
  xlv_TEXCOORD0 = (((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw) + (float(unity_StereoEyeIndex) * _RightEyeUVOffset.xy));
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _SecondTex;
uniform sampler2D _ThirdTex;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 y_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0).wwww;
  y_1.w = tmpvar_2.w;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_SecondTex, xlv_TEXCOORD0);
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_ThirdTex, xlv_TEXCOORD0);
  lowp float tmpvar_5;
  tmpvar_5 = (1.15625 * tmpvar_2.w);
  y_1.x = ((tmpvar_5 + (1.59375 * tmpvar_4.w)) - 0.87254);
  y_1.y = (((tmpvar_5 - 
    (0.390625 * tmpvar_3.w)
  ) - (0.8125 * tmpvar_4.w)) + 0.53137);
  y_1.z = ((tmpvar_5 + (1.984375 * tmpvar_3.w)) - 1.06862);
  lowp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = y_1.xyz;
  gl_FragData[0] = tmpvar_6;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform highp int unity_StereoEyeIndex;
uniform highp vec4 _RightEyeUVOffset;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
  xlv_TEXCOORD0 = (((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw) + (float(unity_StereoEyeIndex) * _RightEyeUVOffset.xy));
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _SecondTex;
uniform sampler2D _ThirdTex;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 y_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0).wwww;
  y_1.w = tmpvar_2.w;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_SecondTex, xlv_TEXCOORD0);
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_ThirdTex, xlv_TEXCOORD0);
  lowp float tmpvar_5;
  tmpvar_5 = (1.15625 * tmpvar_2.w);
  y_1.x = ((tmpvar_5 + (1.59375 * tmpvar_4.w)) - 0.87254);
  y_1.y = (((tmpvar_5 - 
    (0.390625 * tmpvar_3.w)
  ) - (0.8125 * tmpvar_4.w)) + 0.53137);
  y_1.z = ((tmpvar_5 + (1.984375 * tmpvar_3.w)) - 1.06862);
  lowp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = y_1.xyz;
  gl_FragData[0] = tmpvar_6;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	int unity_StereoEyeIndex;
uniform 	vec4 _RightEyeUVOffset;
uniform 	vec4 _MainTex_ST;
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
vec4 u_xlat1;
float u_xlat4;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    u_xlat0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    u_xlat4 = float(unity_StereoEyeIndex);
    vs_TEXCOORD0.xy = vec2(u_xlat4) * _RightEyeUVOffset.xy + u_xlat0.xy;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D _SecondTex;
uniform lowp sampler2D _ThirdTex;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
lowp float u_xlat10_0;
mediump vec2 u_xlat16_1;
lowp float u_xlat10_2;
mediump float u_xlat16_3;
void main()
{
    SV_Target0.w = 1.0;
    u_xlat10_0 = texture(_SecondTex, vs_TEXCOORD0.xy).w;
    u_xlat16_1.xy = vec2(u_xlat10_0) * vec2(0.390625, 1.984375);
    u_xlat10_0 = texture(_MainTex, vs_TEXCOORD0.xy).w;
    u_xlat16_1.x = u_xlat10_0 * 1.15625 + (-u_xlat16_1.x);
    u_xlat16_3 = u_xlat10_0 * 1.15625 + u_xlat16_1.y;
    SV_Target0.z = u_xlat16_3 + -1.06861997;
    u_xlat10_2 = texture(_ThirdTex, vs_TEXCOORD0.xy).w;
    u_xlat16_1.x = (-u_xlat10_2) * 0.8125 + u_xlat16_1.x;
    u_xlat16_3 = u_xlat10_2 * 1.59375;
    u_xlat16_1.y = u_xlat10_0 * 1.15625 + u_xlat16_3;
    SV_Target0.xy = u_xlat16_1.yx + vec2(-0.872539997, 0.531369984);
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	int unity_StereoEyeIndex;
uniform 	vec4 _RightEyeUVOffset;
uniform 	vec4 _MainTex_ST;
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
vec4 u_xlat1;
float u_xlat4;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    u_xlat0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    u_xlat4 = float(unity_StereoEyeIndex);
    vs_TEXCOORD0.xy = vec2(u_xlat4) * _RightEyeUVOffset.xy + u_xlat0.xy;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D _SecondTex;
uniform lowp sampler2D _ThirdTex;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
lowp float u_xlat10_0;
mediump vec2 u_xlat16_1;
lowp float u_xlat10_2;
mediump float u_xlat16_3;
void main()
{
    SV_Target0.w = 1.0;
    u_xlat10_0 = texture(_SecondTex, vs_TEXCOORD0.xy).w;
    u_xlat16_1.xy = vec2(u_xlat10_0) * vec2(0.390625, 1.984375);
    u_xlat10_0 = texture(_MainTex, vs_TEXCOORD0.xy).w;
    u_xlat16_1.x = u_xlat10_0 * 1.15625 + (-u_xlat16_1.x);
    u_xlat16_3 = u_xlat10_0 * 1.15625 + u_xlat16_1.y;
    SV_Target0.z = u_xlat16_3 + -1.06861997;
    u_xlat10_2 = texture(_ThirdTex, vs_TEXCOORD0.xy).w;
    u_xlat16_1.x = (-u_xlat10_2) * 0.8125 + u_xlat16_1.x;
    u_xlat16_3 = u_xlat10_2 * 1.59375;
    u_xlat16_1.y = u_xlat10_0 * 1.15625 + u_xlat16_3;
    SV_Target0.xy = u_xlat16_1.yx + vec2(-0.872539997, 0.531369984);
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	int unity_StereoEyeIndex;
uniform 	vec4 _RightEyeUVOffset;
uniform 	vec4 _MainTex_ST;
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
vec4 u_xlat1;
float u_xlat4;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    u_xlat0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    u_xlat4 = float(unity_StereoEyeIndex);
    vs_TEXCOORD0.xy = vec2(u_xlat4) * _RightEyeUVOffset.xy + u_xlat0.xy;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D _SecondTex;
uniform lowp sampler2D _ThirdTex;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
lowp float u_xlat10_0;
mediump vec2 u_xlat16_1;
lowp float u_xlat10_2;
mediump float u_xlat16_3;
void main()
{
    SV_Target0.w = 1.0;
    u_xlat10_0 = texture(_SecondTex, vs_TEXCOORD0.xy).w;
    u_xlat16_1.xy = vec2(u_xlat10_0) * vec2(0.390625, 1.984375);
    u_xlat10_0 = texture(_MainTex, vs_TEXCOORD0.xy).w;
    u_xlat16_1.x = u_xlat10_0 * 1.15625 + (-u_xlat16_1.x);
    u_xlat16_3 = u_xlat10_0 * 1.15625 + u_xlat16_1.y;
    SV_Target0.z = u_xlat16_3 + -1.06861997;
    u_xlat10_2 = texture(_ThirdTex, vs_TEXCOORD0.xy).w;
    u_xlat16_1.x = (-u_xlat10_2) * 0.8125 + u_xlat16_1.x;
    u_xlat16_3 = u_xlat10_2 * 1.59375;
    u_xlat16_1.y = u_xlat10_0 * 1.15625 + u_xlat16_3;
    SV_Target0.xy = u_xlat16_1.yx + vec2(-0.872539997, 0.531369984);
    return;
}

#endif
"
}
}
Program "fp" {
SubProgram "gles hw_tier00 " {
""
}
SubProgram "gles hw_tier01 " {
""
}
SubProgram "gles hw_tier02 " {
""
}
SubProgram "gles3 hw_tier00 " {
""
}
SubProgram "gles3 hw_tier01 " {
""
}
SubProgram "gles3 hw_tier02 " {
""
}
}
}
 Pass {
  Name "YCBCRA_TO_RGBAFULL"
  ZTest Always
  ZWrite Off
  Cull Off
  GpuProgramID 113027
Program "vp" {
SubProgram "gles hw_tier00 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform highp int unity_StereoEyeIndex;
uniform highp vec4 _RightEyeUVOffset;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
  xlv_TEXCOORD0 = (((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw) + (float(unity_StereoEyeIndex) * _RightEyeUVOffset.xy));
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _SecondTex;
uniform sampler2D _ThirdTex;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 y_1;
  highp vec2 tmpvar_2;
  tmpvar_2.x = (0.5 * xlv_TEXCOORD0.x);
  tmpvar_2.y = xlv_TEXCOORD0.y;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, tmpvar_2).wwww;
  y_1.w = tmpvar_3.w;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_SecondTex, tmpvar_2);
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_ThirdTex, tmpvar_2);
  highp vec2 tmpvar_6;
  tmpvar_6.x = (tmpvar_2.x + 0.5);
  tmpvar_6.y = tmpvar_2.y;
  lowp float tmpvar_7;
  tmpvar_7 = (1.15625 * tmpvar_3.w);
  y_1.x = ((tmpvar_7 + (1.59375 * tmpvar_5.w)) - 0.87254);
  y_1.y = (((tmpvar_7 - 
    (0.390625 * tmpvar_4.w)
  ) - (0.8125 * tmpvar_5.w)) + 0.53137);
  y_1.z = ((tmpvar_7 + (1.984375 * tmpvar_4.w)) - 1.06862);
  lowp vec4 tmpvar_8;
  tmpvar_8.xyz = y_1.xyz;
  tmpvar_8.w = texture2D (_MainTex, tmpvar_6).w;
  gl_FragData[0] = tmpvar_8;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform highp int unity_StereoEyeIndex;
uniform highp vec4 _RightEyeUVOffset;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
  xlv_TEXCOORD0 = (((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw) + (float(unity_StereoEyeIndex) * _RightEyeUVOffset.xy));
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _SecondTex;
uniform sampler2D _ThirdTex;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 y_1;
  highp vec2 tmpvar_2;
  tmpvar_2.x = (0.5 * xlv_TEXCOORD0.x);
  tmpvar_2.y = xlv_TEXCOORD0.y;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, tmpvar_2).wwww;
  y_1.w = tmpvar_3.w;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_SecondTex, tmpvar_2);
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_ThirdTex, tmpvar_2);
  highp vec2 tmpvar_6;
  tmpvar_6.x = (tmpvar_2.x + 0.5);
  tmpvar_6.y = tmpvar_2.y;
  lowp float tmpvar_7;
  tmpvar_7 = (1.15625 * tmpvar_3.w);
  y_1.x = ((tmpvar_7 + (1.59375 * tmpvar_5.w)) - 0.87254);
  y_1.y = (((tmpvar_7 - 
    (0.390625 * tmpvar_4.w)
  ) - (0.8125 * tmpvar_5.w)) + 0.53137);
  y_1.z = ((tmpvar_7 + (1.984375 * tmpvar_4.w)) - 1.06862);
  lowp vec4 tmpvar_8;
  tmpvar_8.xyz = y_1.xyz;
  tmpvar_8.w = texture2D (_MainTex, tmpvar_6).w;
  gl_FragData[0] = tmpvar_8;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform highp int unity_StereoEyeIndex;
uniform highp vec4 _RightEyeUVOffset;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
  xlv_TEXCOORD0 = (((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw) + (float(unity_StereoEyeIndex) * _RightEyeUVOffset.xy));
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _SecondTex;
uniform sampler2D _ThirdTex;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 y_1;
  highp vec2 tmpvar_2;
  tmpvar_2.x = (0.5 * xlv_TEXCOORD0.x);
  tmpvar_2.y = xlv_TEXCOORD0.y;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, tmpvar_2).wwww;
  y_1.w = tmpvar_3.w;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_SecondTex, tmpvar_2);
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_ThirdTex, tmpvar_2);
  highp vec2 tmpvar_6;
  tmpvar_6.x = (tmpvar_2.x + 0.5);
  tmpvar_6.y = tmpvar_2.y;
  lowp float tmpvar_7;
  tmpvar_7 = (1.15625 * tmpvar_3.w);
  y_1.x = ((tmpvar_7 + (1.59375 * tmpvar_5.w)) - 0.87254);
  y_1.y = (((tmpvar_7 - 
    (0.390625 * tmpvar_4.w)
  ) - (0.8125 * tmpvar_5.w)) + 0.53137);
  y_1.z = ((tmpvar_7 + (1.984375 * tmpvar_4.w)) - 1.06862);
  lowp vec4 tmpvar_8;
  tmpvar_8.xyz = y_1.xyz;
  tmpvar_8.w = texture2D (_MainTex, tmpvar_6).w;
  gl_FragData[0] = tmpvar_8;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	int unity_StereoEyeIndex;
uniform 	vec4 _RightEyeUVOffset;
uniform 	vec4 _MainTex_ST;
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
vec4 u_xlat1;
float u_xlat4;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    u_xlat0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    u_xlat4 = float(unity_StereoEyeIndex);
    vs_TEXCOORD0.xy = vec2(u_xlat4) * _RightEyeUVOffset.xy + u_xlat0.xy;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D _SecondTex;
uniform lowp sampler2D _ThirdTex;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec2 u_xlat0;
lowp float u_xlat10_0;
mediump vec2 u_xlat16_1;
mediump float u_xlat16_3;
lowp float u_xlat10_4;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy * vec2(0.5, 1.0) + vec2(0.5, 0.0);
    u_xlat10_0 = texture(_MainTex, u_xlat0.xy).w;
    SV_Target0.w = u_xlat10_0;
    u_xlat0.xy = vs_TEXCOORD0.xy * vec2(0.5, 1.0);
    u_xlat10_4 = texture(_SecondTex, u_xlat0.xy).w;
    u_xlat16_1.xy = vec2(u_xlat10_4) * vec2(0.390625, 1.984375);
    u_xlat10_4 = texture(_MainTex, u_xlat0.xy).w;
    u_xlat10_0 = texture(_ThirdTex, u_xlat0.xy).w;
    u_xlat16_1.x = u_xlat10_4 * 1.15625 + (-u_xlat16_1.x);
    u_xlat16_3 = u_xlat10_4 * 1.15625 + u_xlat16_1.y;
    SV_Target0.z = u_xlat16_3 + -1.06861997;
    u_xlat16_1.x = (-u_xlat10_0) * 0.8125 + u_xlat16_1.x;
    u_xlat16_3 = u_xlat10_0 * 1.59375;
    u_xlat16_1.y = u_xlat10_4 * 1.15625 + u_xlat16_3;
    SV_Target0.xy = u_xlat16_1.yx + vec2(-0.872539997, 0.531369984);
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	int unity_StereoEyeIndex;
uniform 	vec4 _RightEyeUVOffset;
uniform 	vec4 _MainTex_ST;
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
vec4 u_xlat1;
float u_xlat4;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    u_xlat0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    u_xlat4 = float(unity_StereoEyeIndex);
    vs_TEXCOORD0.xy = vec2(u_xlat4) * _RightEyeUVOffset.xy + u_xlat0.xy;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D _SecondTex;
uniform lowp sampler2D _ThirdTex;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec2 u_xlat0;
lowp float u_xlat10_0;
mediump vec2 u_xlat16_1;
mediump float u_xlat16_3;
lowp float u_xlat10_4;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy * vec2(0.5, 1.0) + vec2(0.5, 0.0);
    u_xlat10_0 = texture(_MainTex, u_xlat0.xy).w;
    SV_Target0.w = u_xlat10_0;
    u_xlat0.xy = vs_TEXCOORD0.xy * vec2(0.5, 1.0);
    u_xlat10_4 = texture(_SecondTex, u_xlat0.xy).w;
    u_xlat16_1.xy = vec2(u_xlat10_4) * vec2(0.390625, 1.984375);
    u_xlat10_4 = texture(_MainTex, u_xlat0.xy).w;
    u_xlat10_0 = texture(_ThirdTex, u_xlat0.xy).w;
    u_xlat16_1.x = u_xlat10_4 * 1.15625 + (-u_xlat16_1.x);
    u_xlat16_3 = u_xlat10_4 * 1.15625 + u_xlat16_1.y;
    SV_Target0.z = u_xlat16_3 + -1.06861997;
    u_xlat16_1.x = (-u_xlat10_0) * 0.8125 + u_xlat16_1.x;
    u_xlat16_3 = u_xlat10_0 * 1.59375;
    u_xlat16_1.y = u_xlat10_4 * 1.15625 + u_xlat16_3;
    SV_Target0.xy = u_xlat16_1.yx + vec2(-0.872539997, 0.531369984);
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	int unity_StereoEyeIndex;
uniform 	vec4 _RightEyeUVOffset;
uniform 	vec4 _MainTex_ST;
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
vec4 u_xlat1;
float u_xlat4;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    u_xlat0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    u_xlat4 = float(unity_StereoEyeIndex);
    vs_TEXCOORD0.xy = vec2(u_xlat4) * _RightEyeUVOffset.xy + u_xlat0.xy;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D _SecondTex;
uniform lowp sampler2D _ThirdTex;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec2 u_xlat0;
lowp float u_xlat10_0;
mediump vec2 u_xlat16_1;
mediump float u_xlat16_3;
lowp float u_xlat10_4;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy * vec2(0.5, 1.0) + vec2(0.5, 0.0);
    u_xlat10_0 = texture(_MainTex, u_xlat0.xy).w;
    SV_Target0.w = u_xlat10_0;
    u_xlat0.xy = vs_TEXCOORD0.xy * vec2(0.5, 1.0);
    u_xlat10_4 = texture(_SecondTex, u_xlat0.xy).w;
    u_xlat16_1.xy = vec2(u_xlat10_4) * vec2(0.390625, 1.984375);
    u_xlat10_4 = texture(_MainTex, u_xlat0.xy).w;
    u_xlat10_0 = texture(_ThirdTex, u_xlat0.xy).w;
    u_xlat16_1.x = u_xlat10_4 * 1.15625 + (-u_xlat16_1.x);
    u_xlat16_3 = u_xlat10_4 * 1.15625 + u_xlat16_1.y;
    SV_Target0.z = u_xlat16_3 + -1.06861997;
    u_xlat16_1.x = (-u_xlat10_0) * 0.8125 + u_xlat16_1.x;
    u_xlat16_3 = u_xlat10_0 * 1.59375;
    u_xlat16_1.y = u_xlat10_4 * 1.15625 + u_xlat16_3;
    SV_Target0.xy = u_xlat16_1.yx + vec2(-0.872539997, 0.531369984);
    return;
}

#endif
"
}
}
Program "fp" {
SubProgram "gles hw_tier00 " {
""
}
SubProgram "gles hw_tier01 " {
""
}
SubProgram "gles hw_tier02 " {
""
}
SubProgram "gles3 hw_tier00 " {
""
}
SubProgram "gles3 hw_tier01 " {
""
}
SubProgram "gles3 hw_tier02 " {
""
}
}
}
 Pass {
  Name "YCBCRA_TO_RGBA"
  ZTest Always
  ZWrite Off
  Cull Off
  GpuProgramID 142939
Program "vp" {
SubProgram "gles hw_tier00 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform highp int unity_StereoEyeIndex;
uniform highp vec4 _RightEyeUVOffset;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
  xlv_TEXCOORD0 = (((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw) + (float(unity_StereoEyeIndex) * _RightEyeUVOffset.xy));
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _SecondTex;
uniform sampler2D _ThirdTex;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 y_1;
  highp vec2 tmpvar_2;
  tmpvar_2.x = (0.5 * xlv_TEXCOORD0.x);
  tmpvar_2.y = xlv_TEXCOORD0.y;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, tmpvar_2).wwww;
  y_1.w = tmpvar_3.w;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_SecondTex, tmpvar_2);
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_ThirdTex, tmpvar_2);
  highp vec2 tmpvar_6;
  tmpvar_6.x = (tmpvar_2.x + 0.5);
  tmpvar_6.y = tmpvar_2.y;
  lowp float tmpvar_7;
  tmpvar_7 = (1.15625 * tmpvar_3.w);
  y_1.x = ((tmpvar_7 + (1.59375 * tmpvar_5.w)) - 0.87254);
  y_1.y = (((tmpvar_7 - 
    (0.390625 * tmpvar_4.w)
  ) - (0.8125 * tmpvar_5.w)) + 0.53137);
  y_1.z = ((tmpvar_7 + (1.984375 * tmpvar_4.w)) - 1.06862);
  lowp vec4 tmpvar_8;
  tmpvar_8.xyz = y_1.xyz;
  tmpvar_8.w = (1.15625 * (texture2D (_MainTex, tmpvar_6).w - 0.062745));
  gl_FragData[0] = tmpvar_8;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform highp int unity_StereoEyeIndex;
uniform highp vec4 _RightEyeUVOffset;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
  xlv_TEXCOORD0 = (((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw) + (float(unity_StereoEyeIndex) * _RightEyeUVOffset.xy));
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _SecondTex;
uniform sampler2D _ThirdTex;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 y_1;
  highp vec2 tmpvar_2;
  tmpvar_2.x = (0.5 * xlv_TEXCOORD0.x);
  tmpvar_2.y = xlv_TEXCOORD0.y;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, tmpvar_2).wwww;
  y_1.w = tmpvar_3.w;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_SecondTex, tmpvar_2);
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_ThirdTex, tmpvar_2);
  highp vec2 tmpvar_6;
  tmpvar_6.x = (tmpvar_2.x + 0.5);
  tmpvar_6.y = tmpvar_2.y;
  lowp float tmpvar_7;
  tmpvar_7 = (1.15625 * tmpvar_3.w);
  y_1.x = ((tmpvar_7 + (1.59375 * tmpvar_5.w)) - 0.87254);
  y_1.y = (((tmpvar_7 - 
    (0.390625 * tmpvar_4.w)
  ) - (0.8125 * tmpvar_5.w)) + 0.53137);
  y_1.z = ((tmpvar_7 + (1.984375 * tmpvar_4.w)) - 1.06862);
  lowp vec4 tmpvar_8;
  tmpvar_8.xyz = y_1.xyz;
  tmpvar_8.w = (1.15625 * (texture2D (_MainTex, tmpvar_6).w - 0.062745));
  gl_FragData[0] = tmpvar_8;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform highp int unity_StereoEyeIndex;
uniform highp vec4 _RightEyeUVOffset;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
  xlv_TEXCOORD0 = (((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw) + (float(unity_StereoEyeIndex) * _RightEyeUVOffset.xy));
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _SecondTex;
uniform sampler2D _ThirdTex;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 y_1;
  highp vec2 tmpvar_2;
  tmpvar_2.x = (0.5 * xlv_TEXCOORD0.x);
  tmpvar_2.y = xlv_TEXCOORD0.y;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, tmpvar_2).wwww;
  y_1.w = tmpvar_3.w;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_SecondTex, tmpvar_2);
  lowp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_ThirdTex, tmpvar_2);
  highp vec2 tmpvar_6;
  tmpvar_6.x = (tmpvar_2.x + 0.5);
  tmpvar_6.y = tmpvar_2.y;
  lowp float tmpvar_7;
  tmpvar_7 = (1.15625 * tmpvar_3.w);
  y_1.x = ((tmpvar_7 + (1.59375 * tmpvar_5.w)) - 0.87254);
  y_1.y = (((tmpvar_7 - 
    (0.390625 * tmpvar_4.w)
  ) - (0.8125 * tmpvar_5.w)) + 0.53137);
  y_1.z = ((tmpvar_7 + (1.984375 * tmpvar_4.w)) - 1.06862);
  lowp vec4 tmpvar_8;
  tmpvar_8.xyz = y_1.xyz;
  tmpvar_8.w = (1.15625 * (texture2D (_MainTex, tmpvar_6).w - 0.062745));
  gl_FragData[0] = tmpvar_8;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	int unity_StereoEyeIndex;
uniform 	vec4 _RightEyeUVOffset;
uniform 	vec4 _MainTex_ST;
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
vec4 u_xlat1;
float u_xlat4;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    u_xlat0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    u_xlat4 = float(unity_StereoEyeIndex);
    vs_TEXCOORD0.xy = vec2(u_xlat4) * _RightEyeUVOffset.xy + u_xlat0.xy;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D _SecondTex;
uniform lowp sampler2D _ThirdTex;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec2 u_xlat0;
lowp float u_xlat10_0;
mediump vec2 u_xlat16_1;
mediump float u_xlat16_3;
lowp float u_xlat10_4;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy * vec2(0.5, 1.0) + vec2(0.5, 0.0);
    u_xlat10_0 = texture(_MainTex, u_xlat0.xy).w;
    u_xlat16_1.x = u_xlat10_0 + -0.0627449974;
    SV_Target0.w = u_xlat16_1.x * 1.15625;
    u_xlat0.xy = vs_TEXCOORD0.xy * vec2(0.5, 1.0);
    u_xlat10_4 = texture(_SecondTex, u_xlat0.xy).w;
    u_xlat16_1.xy = vec2(u_xlat10_4) * vec2(0.390625, 1.984375);
    u_xlat10_4 = texture(_MainTex, u_xlat0.xy).w;
    u_xlat10_0 = texture(_ThirdTex, u_xlat0.xy).w;
    u_xlat16_1.x = u_xlat10_4 * 1.15625 + (-u_xlat16_1.x);
    u_xlat16_3 = u_xlat10_4 * 1.15625 + u_xlat16_1.y;
    SV_Target0.z = u_xlat16_3 + -1.06861997;
    u_xlat16_1.x = (-u_xlat10_0) * 0.8125 + u_xlat16_1.x;
    u_xlat16_3 = u_xlat10_0 * 1.59375;
    u_xlat16_1.y = u_xlat10_4 * 1.15625 + u_xlat16_3;
    SV_Target0.xy = u_xlat16_1.yx + vec2(-0.872539997, 0.531369984);
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	int unity_StereoEyeIndex;
uniform 	vec4 _RightEyeUVOffset;
uniform 	vec4 _MainTex_ST;
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
vec4 u_xlat1;
float u_xlat4;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    u_xlat0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    u_xlat4 = float(unity_StereoEyeIndex);
    vs_TEXCOORD0.xy = vec2(u_xlat4) * _RightEyeUVOffset.xy + u_xlat0.xy;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D _SecondTex;
uniform lowp sampler2D _ThirdTex;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec2 u_xlat0;
lowp float u_xlat10_0;
mediump vec2 u_xlat16_1;
mediump float u_xlat16_3;
lowp float u_xlat10_4;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy * vec2(0.5, 1.0) + vec2(0.5, 0.0);
    u_xlat10_0 = texture(_MainTex, u_xlat0.xy).w;
    u_xlat16_1.x = u_xlat10_0 + -0.0627449974;
    SV_Target0.w = u_xlat16_1.x * 1.15625;
    u_xlat0.xy = vs_TEXCOORD0.xy * vec2(0.5, 1.0);
    u_xlat10_4 = texture(_SecondTex, u_xlat0.xy).w;
    u_xlat16_1.xy = vec2(u_xlat10_4) * vec2(0.390625, 1.984375);
    u_xlat10_4 = texture(_MainTex, u_xlat0.xy).w;
    u_xlat10_0 = texture(_ThirdTex, u_xlat0.xy).w;
    u_xlat16_1.x = u_xlat10_4 * 1.15625 + (-u_xlat16_1.x);
    u_xlat16_3 = u_xlat10_4 * 1.15625 + u_xlat16_1.y;
    SV_Target0.z = u_xlat16_3 + -1.06861997;
    u_xlat16_1.x = (-u_xlat10_0) * 0.8125 + u_xlat16_1.x;
    u_xlat16_3 = u_xlat10_0 * 1.59375;
    u_xlat16_1.y = u_xlat10_4 * 1.15625 + u_xlat16_3;
    SV_Target0.xy = u_xlat16_1.yx + vec2(-0.872539997, 0.531369984);
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	int unity_StereoEyeIndex;
uniform 	vec4 _RightEyeUVOffset;
uniform 	vec4 _MainTex_ST;
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
vec4 u_xlat1;
float u_xlat4;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    u_xlat0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    u_xlat4 = float(unity_StereoEyeIndex);
    vs_TEXCOORD0.xy = vec2(u_xlat4) * _RightEyeUVOffset.xy + u_xlat0.xy;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D _SecondTex;
uniform lowp sampler2D _ThirdTex;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec2 u_xlat0;
lowp float u_xlat10_0;
mediump vec2 u_xlat16_1;
mediump float u_xlat16_3;
lowp float u_xlat10_4;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy * vec2(0.5, 1.0) + vec2(0.5, 0.0);
    u_xlat10_0 = texture(_MainTex, u_xlat0.xy).w;
    u_xlat16_1.x = u_xlat10_0 + -0.0627449974;
    SV_Target0.w = u_xlat16_1.x * 1.15625;
    u_xlat0.xy = vs_TEXCOORD0.xy * vec2(0.5, 1.0);
    u_xlat10_4 = texture(_SecondTex, u_xlat0.xy).w;
    u_xlat16_1.xy = vec2(u_xlat10_4) * vec2(0.390625, 1.984375);
    u_xlat10_4 = texture(_MainTex, u_xlat0.xy).w;
    u_xlat10_0 = texture(_ThirdTex, u_xlat0.xy).w;
    u_xlat16_1.x = u_xlat10_4 * 1.15625 + (-u_xlat16_1.x);
    u_xlat16_3 = u_xlat10_4 * 1.15625 + u_xlat16_1.y;
    SV_Target0.z = u_xlat16_3 + -1.06861997;
    u_xlat16_1.x = (-u_xlat10_0) * 0.8125 + u_xlat16_1.x;
    u_xlat16_3 = u_xlat10_0 * 1.59375;
    u_xlat16_1.y = u_xlat10_4 * 1.15625 + u_xlat16_3;
    SV_Target0.xy = u_xlat16_1.yx + vec2(-0.872539997, 0.531369984);
    return;
}

#endif
"
}
}
Program "fp" {
SubProgram "gles hw_tier00 " {
""
}
SubProgram "gles hw_tier01 " {
""
}
SubProgram "gles hw_tier02 " {
""
}
SubProgram "gles3 hw_tier00 " {
""
}
SubProgram "gles3 hw_tier01 " {
""
}
SubProgram "gles3 hw_tier02 " {
""
}
}
}
 Pass {
  Name "COMPOSITE_RGBA_TO_RGBA"
  Cull Off
  GpuProgramID 238344
Program "vp" {
SubProgram "gles hw_tier00 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform highp int unity_StereoEyeIndex;
uniform highp vec4 _RightEyeUVOffset;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
  xlv_TEXCOORD0 = (((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw) + (float(unity_StereoEyeIndex) * _RightEyeUVOffset.xy));
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform highp float _AlphaParam;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 tmpvar_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec4 tmpvar_3;
  tmpvar_3.xyz = tmpvar_2.xyz;
  tmpvar_3.w = (tmpvar_2.w * _AlphaParam);
  tmpvar_1 = tmpvar_3;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform highp int unity_StereoEyeIndex;
uniform highp vec4 _RightEyeUVOffset;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
  xlv_TEXCOORD0 = (((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw) + (float(unity_StereoEyeIndex) * _RightEyeUVOffset.xy));
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform highp float _AlphaParam;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 tmpvar_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec4 tmpvar_3;
  tmpvar_3.xyz = tmpvar_2.xyz;
  tmpvar_3.w = (tmpvar_2.w * _AlphaParam);
  tmpvar_1 = tmpvar_3;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform highp int unity_StereoEyeIndex;
uniform highp vec4 _RightEyeUVOffset;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
  xlv_TEXCOORD0 = (((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw) + (float(unity_StereoEyeIndex) * _RightEyeUVOffset.xy));
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform highp float _AlphaParam;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 tmpvar_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec4 tmpvar_3;
  tmpvar_3.xyz = tmpvar_2.xyz;
  tmpvar_3.w = (tmpvar_2.w * _AlphaParam);
  tmpvar_1 = tmpvar_3;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	int unity_StereoEyeIndex;
uniform 	vec4 _RightEyeUVOffset;
uniform 	vec4 _MainTex_ST;
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
vec4 u_xlat1;
float u_xlat4;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    u_xlat0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    u_xlat4 = float(unity_StereoEyeIndex);
    vs_TEXCOORD0.xy = vec2(u_xlat4) * _RightEyeUVOffset.xy + u_xlat0.xy;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	float _AlphaParam;
uniform lowp sampler2D _MainTex;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
void main()
{
    u_xlat0 = texture(_MainTex, vs_TEXCOORD0.xy);
    u_xlat0.w = u_xlat0.w * _AlphaParam;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	int unity_StereoEyeIndex;
uniform 	vec4 _RightEyeUVOffset;
uniform 	vec4 _MainTex_ST;
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
vec4 u_xlat1;
float u_xlat4;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    u_xlat0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    u_xlat4 = float(unity_StereoEyeIndex);
    vs_TEXCOORD0.xy = vec2(u_xlat4) * _RightEyeUVOffset.xy + u_xlat0.xy;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	float _AlphaParam;
uniform lowp sampler2D _MainTex;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
void main()
{
    u_xlat0 = texture(_MainTex, vs_TEXCOORD0.xy);
    u_xlat0.w = u_xlat0.w * _AlphaParam;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	int unity_StereoEyeIndex;
uniform 	vec4 _RightEyeUVOffset;
uniform 	vec4 _MainTex_ST;
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
vec4 u_xlat1;
float u_xlat4;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    u_xlat0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    u_xlat4 = float(unity_StereoEyeIndex);
    vs_TEXCOORD0.xy = vec2(u_xlat4) * _RightEyeUVOffset.xy + u_xlat0.xy;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	float _AlphaParam;
uniform lowp sampler2D _MainTex;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
void main()
{
    u_xlat0 = texture(_MainTex, vs_TEXCOORD0.xy);
    u_xlat0.w = u_xlat0.w * _AlphaParam;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
}
Program "fp" {
SubProgram "gles hw_tier00 " {
""
}
SubProgram "gles hw_tier01 " {
""
}
SubProgram "gles hw_tier02 " {
""
}
SubProgram "gles3 hw_tier00 " {
""
}
SubProgram "gles3 hw_tier01 " {
""
}
SubProgram "gles3 hw_tier02 " {
""
}
}
}
 Pass {
  Name "FLIP_RGBA_TO_RGBA"
  ZTest Always
  ZWrite Off
  Cull Off
  GpuProgramID 288062
Program "vp" {
SubProgram "gles hw_tier00 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec2 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _glesVertex.xyz;
  tmpvar_1.x = _glesMultiTexCoord0.x;
  tmpvar_1.y = (1.0 - _glesMultiTexCoord0.y);
  tmpvar_1 = ((tmpvar_1 * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_2));
  xlv_TEXCOORD0 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform highp float _AlphaParam;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec4 tmpvar_2;
  tmpvar_2.xyz = tmpvar_1.xyz;
  tmpvar_2.w = (tmpvar_1.w * _AlphaParam);
  lowp vec4 color_3;
  color_3 = tmpvar_2;
  gl_FragData[0] = color_3;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec2 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _glesVertex.xyz;
  tmpvar_1.x = _glesMultiTexCoord0.x;
  tmpvar_1.y = (1.0 - _glesMultiTexCoord0.y);
  tmpvar_1 = ((tmpvar_1 * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_2));
  xlv_TEXCOORD0 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform highp float _AlphaParam;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec4 tmpvar_2;
  tmpvar_2.xyz = tmpvar_1.xyz;
  tmpvar_2.w = (tmpvar_1.w * _AlphaParam);
  lowp vec4 color_3;
  color_3 = tmpvar_2;
  gl_FragData[0] = color_3;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec2 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _glesVertex.xyz;
  tmpvar_1.x = _glesMultiTexCoord0.x;
  tmpvar_1.y = (1.0 - _glesMultiTexCoord0.y);
  tmpvar_1 = ((tmpvar_1 * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_2));
  xlv_TEXCOORD0 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform highp float _AlphaParam;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_MainTex, xlv_TEXCOORD0);
  highp vec4 tmpvar_2;
  tmpvar_2.xyz = tmpvar_1.xyz;
  tmpvar_2.w = (tmpvar_1.w * _AlphaParam);
  lowp vec4 color_3;
  color_3 = tmpvar_2;
  gl_FragData[0] = color_3;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	vec4 _MainTex_ST;
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
vec4 u_xlat1;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    u_xlat0.xy = in_TEXCOORD0.xy * vec2(1.0, -1.0) + vec2(0.0, 1.0);
    vs_TEXCOORD0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	float _AlphaParam;
uniform lowp sampler2D _MainTex;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
void main()
{
    u_xlat0 = texture(_MainTex, vs_TEXCOORD0.xy);
    u_xlat0.w = u_xlat0.w * _AlphaParam;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	vec4 _MainTex_ST;
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
vec4 u_xlat1;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    u_xlat0.xy = in_TEXCOORD0.xy * vec2(1.0, -1.0) + vec2(0.0, 1.0);
    vs_TEXCOORD0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	float _AlphaParam;
uniform lowp sampler2D _MainTex;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
void main()
{
    u_xlat0 = texture(_MainTex, vs_TEXCOORD0.xy);
    u_xlat0.w = u_xlat0.w * _AlphaParam;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	vec4 _MainTex_ST;
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
vec4 u_xlat1;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    u_xlat0.xy = in_TEXCOORD0.xy * vec2(1.0, -1.0) + vec2(0.0, 1.0);
    vs_TEXCOORD0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	float _AlphaParam;
uniform lowp sampler2D _MainTex;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
void main()
{
    u_xlat0 = texture(_MainTex, vs_TEXCOORD0.xy);
    u_xlat0.w = u_xlat0.w * _AlphaParam;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
}
Program "fp" {
SubProgram "gles hw_tier00 " {
""
}
SubProgram "gles hw_tier01 " {
""
}
SubProgram "gles hw_tier02 " {
""
}
SubProgram "gles3 hw_tier00 " {
""
}
SubProgram "gles3 hw_tier01 " {
""
}
SubProgram "gles3 hw_tier02 " {
""
}
}
}
 Pass {
  Name "FLIP_RGBASPLIT_TO_RGBA"
  ZTest Always
  ZWrite Off
  Cull Off
  GpuProgramID 375129
Program "vp" {
SubProgram "gles hw_tier00 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec2 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _glesVertex.xyz;
  tmpvar_1.x = _glesMultiTexCoord0.x;
  tmpvar_1.y = (1.0 - _glesMultiTexCoord0.y);
  tmpvar_1 = ((tmpvar_1 * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_2));
  xlv_TEXCOORD0 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec2 tmpvar_1;
  tmpvar_1.x = (0.5 * xlv_TEXCOORD0.x);
  tmpvar_1.y = xlv_TEXCOORD0.y;
  highp vec2 tmpvar_2;
  tmpvar_2.x = (tmpvar_1.x + 0.5);
  tmpvar_2.y = tmpvar_1.y;
  lowp vec4 tmpvar_3;
  tmpvar_3.xyz = texture2D (_MainTex, tmpvar_1).xyz;
  tmpvar_3.w = texture2D (_MainTex, tmpvar_2).y;
  gl_FragData[0] = tmpvar_3;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec2 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _glesVertex.xyz;
  tmpvar_1.x = _glesMultiTexCoord0.x;
  tmpvar_1.y = (1.0 - _glesMultiTexCoord0.y);
  tmpvar_1 = ((tmpvar_1 * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_2));
  xlv_TEXCOORD0 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec2 tmpvar_1;
  tmpvar_1.x = (0.5 * xlv_TEXCOORD0.x);
  tmpvar_1.y = xlv_TEXCOORD0.y;
  highp vec2 tmpvar_2;
  tmpvar_2.x = (tmpvar_1.x + 0.5);
  tmpvar_2.y = tmpvar_1.y;
  lowp vec4 tmpvar_3;
  tmpvar_3.xyz = texture2D (_MainTex, tmpvar_1).xyz;
  tmpvar_3.w = texture2D (_MainTex, tmpvar_2).y;
  gl_FragData[0] = tmpvar_3;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec2 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _glesVertex.xyz;
  tmpvar_1.x = _glesMultiTexCoord0.x;
  tmpvar_1.y = (1.0 - _glesMultiTexCoord0.y);
  tmpvar_1 = ((tmpvar_1 * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_2));
  xlv_TEXCOORD0 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec2 tmpvar_1;
  tmpvar_1.x = (0.5 * xlv_TEXCOORD0.x);
  tmpvar_1.y = xlv_TEXCOORD0.y;
  highp vec2 tmpvar_2;
  tmpvar_2.x = (tmpvar_1.x + 0.5);
  tmpvar_2.y = tmpvar_1.y;
  lowp vec4 tmpvar_3;
  tmpvar_3.xyz = texture2D (_MainTex, tmpvar_1).xyz;
  tmpvar_3.w = texture2D (_MainTex, tmpvar_2).y;
  gl_FragData[0] = tmpvar_3;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	vec4 _MainTex_ST;
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
vec4 u_xlat1;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    u_xlat0.xy = in_TEXCOORD0.xy * vec2(1.0, -1.0) + vec2(0.0, 1.0);
    vs_TEXCOORD0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _MainTex;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec2 u_xlat1;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy * vec2(0.5, 1.0);
    u_xlat0.xyz = texture(_MainTex, u_xlat0.xy).xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy * vec2(0.5, 1.0) + vec2(0.5, 0.0);
    u_xlat0.w = texture(_MainTex, u_xlat1.xy).y;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	vec4 _MainTex_ST;
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
vec4 u_xlat1;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    u_xlat0.xy = in_TEXCOORD0.xy * vec2(1.0, -1.0) + vec2(0.0, 1.0);
    vs_TEXCOORD0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _MainTex;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec2 u_xlat1;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy * vec2(0.5, 1.0);
    u_xlat0.xyz = texture(_MainTex, u_xlat0.xy).xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy * vec2(0.5, 1.0) + vec2(0.5, 0.0);
    u_xlat0.w = texture(_MainTex, u_xlat1.xy).y;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	vec4 _MainTex_ST;
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
vec4 u_xlat1;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    u_xlat0.xy = in_TEXCOORD0.xy * vec2(1.0, -1.0) + vec2(0.0, 1.0);
    vs_TEXCOORD0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _MainTex;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec2 u_xlat1;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy * vec2(0.5, 1.0);
    u_xlat0.xyz = texture(_MainTex, u_xlat0.xy).xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy * vec2(0.5, 1.0) + vec2(0.5, 0.0);
    u_xlat0.w = texture(_MainTex, u_xlat1.xy).y;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
}
Program "fp" {
SubProgram "gles hw_tier00 " {
""
}
SubProgram "gles hw_tier01 " {
""
}
SubProgram "gles hw_tier02 " {
""
}
SubProgram "gles3 hw_tier00 " {
""
}
SubProgram "gles3 hw_tier01 " {
""
}
SubProgram "gles3 hw_tier02 " {
""
}
}
}
 Pass {
  Name "FLIP_SEMIPLANARYCBCR_TO_RGB1"
  ZTest Always
  ZWrite Off
  Cull Off
  GpuProgramID 440144
Program "vp" {
SubProgram "gles hw_tier00 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec2 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _glesVertex.xyz;
  tmpvar_1.x = _glesMultiTexCoord0.x;
  tmpvar_1.y = (1.0 - _glesMultiTexCoord0.y);
  tmpvar_1 = ((tmpvar_1 * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_2));
  xlv_TEXCOORD0 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _SecondTex;
uniform highp vec4 _MainTex_TexelSize;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp float tmpvar_1;
  tmpvar_1 = (_MainTex_TexelSize.z - 0.5);
  highp float tmpvar_2;
  tmpvar_2 = (1.0/(tmpvar_1));
  highp int tmpvar_3;
  tmpvar_3 = int(floor((
    (xlv_TEXCOORD0.x * tmpvar_1)
   + 0.5)));
  highp float tmpvar_4;
  tmpvar_4 = (float(tmpvar_3) / 2.0);
  highp float tmpvar_5;
  tmpvar_5 = (fract(abs(tmpvar_4)) * 2.0);
  highp float tmpvar_6;
  if ((tmpvar_4 >= 0.0)) {
    tmpvar_6 = tmpvar_5;
  } else {
    tmpvar_6 = -(tmpvar_5);
  };
  highp int tmpvar_7;
  if ((tmpvar_6 == 0.0)) {
    tmpvar_7 = tmpvar_3;
  } else {
    tmpvar_7 = (tmpvar_3 - 1);
  };
  highp vec2 tmpvar_8;
  tmpvar_8.x = (float(tmpvar_7) * tmpvar_2);
  tmpvar_8.y = xlv_TEXCOORD0.y;
  highp vec2 tmpvar_9;
  tmpvar_9.x = (float((tmpvar_7 + 1)) * tmpvar_2);
  tmpvar_9.y = xlv_TEXCOORD0.y;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_SecondTex, tmpvar_8);
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_SecondTex, tmpvar_9);
  lowp float tmpvar_12;
  tmpvar_12 = (1.15625 * texture2D (_MainTex, xlv_TEXCOORD0).w);
  lowp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.x = ((tmpvar_12 + (1.59375 * tmpvar_11.w)) - 0.87254);
  tmpvar_13.y = (((tmpvar_12 - 
    (0.390625 * tmpvar_10.w)
  ) - (0.8125 * tmpvar_11.w)) + 0.53137);
  tmpvar_13.z = ((tmpvar_12 + (1.984375 * tmpvar_10.w)) - 1.06862);
  gl_FragData[0] = tmpvar_13;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec2 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _glesVertex.xyz;
  tmpvar_1.x = _glesMultiTexCoord0.x;
  tmpvar_1.y = (1.0 - _glesMultiTexCoord0.y);
  tmpvar_1 = ((tmpvar_1 * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_2));
  xlv_TEXCOORD0 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _SecondTex;
uniform highp vec4 _MainTex_TexelSize;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp float tmpvar_1;
  tmpvar_1 = (_MainTex_TexelSize.z - 0.5);
  highp float tmpvar_2;
  tmpvar_2 = (1.0/(tmpvar_1));
  highp int tmpvar_3;
  tmpvar_3 = int(floor((
    (xlv_TEXCOORD0.x * tmpvar_1)
   + 0.5)));
  highp float tmpvar_4;
  tmpvar_4 = (float(tmpvar_3) / 2.0);
  highp float tmpvar_5;
  tmpvar_5 = (fract(abs(tmpvar_4)) * 2.0);
  highp float tmpvar_6;
  if ((tmpvar_4 >= 0.0)) {
    tmpvar_6 = tmpvar_5;
  } else {
    tmpvar_6 = -(tmpvar_5);
  };
  highp int tmpvar_7;
  if ((tmpvar_6 == 0.0)) {
    tmpvar_7 = tmpvar_3;
  } else {
    tmpvar_7 = (tmpvar_3 - 1);
  };
  highp vec2 tmpvar_8;
  tmpvar_8.x = (float(tmpvar_7) * tmpvar_2);
  tmpvar_8.y = xlv_TEXCOORD0.y;
  highp vec2 tmpvar_9;
  tmpvar_9.x = (float((tmpvar_7 + 1)) * tmpvar_2);
  tmpvar_9.y = xlv_TEXCOORD0.y;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_SecondTex, tmpvar_8);
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_SecondTex, tmpvar_9);
  lowp float tmpvar_12;
  tmpvar_12 = (1.15625 * texture2D (_MainTex, xlv_TEXCOORD0).w);
  lowp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.x = ((tmpvar_12 + (1.59375 * tmpvar_11.w)) - 0.87254);
  tmpvar_13.y = (((tmpvar_12 - 
    (0.390625 * tmpvar_10.w)
  ) - (0.8125 * tmpvar_11.w)) + 0.53137);
  tmpvar_13.z = ((tmpvar_12 + (1.984375 * tmpvar_10.w)) - 1.06862);
  gl_FragData[0] = tmpvar_13;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec2 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _glesVertex.xyz;
  tmpvar_1.x = _glesMultiTexCoord0.x;
  tmpvar_1.y = (1.0 - _glesMultiTexCoord0.y);
  tmpvar_1 = ((tmpvar_1 * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_2));
  xlv_TEXCOORD0 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _SecondTex;
uniform highp vec4 _MainTex_TexelSize;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp float tmpvar_1;
  tmpvar_1 = (_MainTex_TexelSize.z - 0.5);
  highp float tmpvar_2;
  tmpvar_2 = (1.0/(tmpvar_1));
  highp int tmpvar_3;
  tmpvar_3 = int(floor((
    (xlv_TEXCOORD0.x * tmpvar_1)
   + 0.5)));
  highp float tmpvar_4;
  tmpvar_4 = (float(tmpvar_3) / 2.0);
  highp float tmpvar_5;
  tmpvar_5 = (fract(abs(tmpvar_4)) * 2.0);
  highp float tmpvar_6;
  if ((tmpvar_4 >= 0.0)) {
    tmpvar_6 = tmpvar_5;
  } else {
    tmpvar_6 = -(tmpvar_5);
  };
  highp int tmpvar_7;
  if ((tmpvar_6 == 0.0)) {
    tmpvar_7 = tmpvar_3;
  } else {
    tmpvar_7 = (tmpvar_3 - 1);
  };
  highp vec2 tmpvar_8;
  tmpvar_8.x = (float(tmpvar_7) * tmpvar_2);
  tmpvar_8.y = xlv_TEXCOORD0.y;
  highp vec2 tmpvar_9;
  tmpvar_9.x = (float((tmpvar_7 + 1)) * tmpvar_2);
  tmpvar_9.y = xlv_TEXCOORD0.y;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_SecondTex, tmpvar_8);
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_SecondTex, tmpvar_9);
  lowp float tmpvar_12;
  tmpvar_12 = (1.15625 * texture2D (_MainTex, xlv_TEXCOORD0).w);
  lowp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.x = ((tmpvar_12 + (1.59375 * tmpvar_11.w)) - 0.87254);
  tmpvar_13.y = (((tmpvar_12 - 
    (0.390625 * tmpvar_10.w)
  ) - (0.8125 * tmpvar_11.w)) + 0.53137);
  tmpvar_13.z = ((tmpvar_12 + (1.984375 * tmpvar_10.w)) - 1.06862);
  gl_FragData[0] = tmpvar_13;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	vec4 _MainTex_ST;
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
vec4 u_xlat1;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    u_xlat0.xy = in_TEXCOORD0.xy * vec2(1.0, -1.0) + vec2(0.0, 1.0);
    vs_TEXCOORD0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _MainTex_TexelSize;
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D _SecondTex;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
float u_xlat0;
lowp float u_xlat10_0;
vec4 u_xlat1;
mediump vec2 u_xlat16_2;
float u_xlat3;
lowp float u_xlat10_3;
int u_xlati3;
mediump float u_xlat16_5;
float u_xlat6;
int u_xlati6;
bool u_xlatb6;
int u_xlati9;
bool u_xlatb9;
void main()
{
    u_xlat0 = _MainTex_TexelSize.z + -0.5;
    u_xlat3 = vs_TEXCOORD0.x * u_xlat0 + 0.5;
    u_xlat0 = float(1.0) / u_xlat0;
    u_xlat3 = floor(u_xlat3);
    u_xlat6 = u_xlat3 * 0.5;
    u_xlati3 = int(u_xlat3);
#ifdef UNITY_ADRENO_ES3
    u_xlatb9 = !!(u_xlat6>=(-u_xlat6));
#else
    u_xlatb9 = u_xlat6>=(-u_xlat6);
#endif
    u_xlat6 = fract(abs(u_xlat6));
    u_xlat6 = (u_xlatb9) ? u_xlat6 : (-u_xlat6);
#ifdef UNITY_ADRENO_ES3
    u_xlatb6 = !!(u_xlat6==0.0);
#else
    u_xlatb6 = u_xlat6==0.0;
#endif
    u_xlati9 = u_xlati3 + int(0xFFFFFFFFu);
    u_xlati3 = (u_xlatb6) ? u_xlati3 : u_xlati9;
    u_xlati6 = u_xlati3 + 1;
    u_xlat3 = float(u_xlati3);
    u_xlat1.x = u_xlat0 * u_xlat3;
    u_xlat3 = float(u_xlati6);
    u_xlat1.z = u_xlat0 * u_xlat3;
    u_xlat1.yw = vs_TEXCOORD0.yy;
    u_xlat10_0 = texture(_SecondTex, u_xlat1.zw).w;
    u_xlat10_3 = texture(_SecondTex, u_xlat1.xy).w;
    u_xlat16_2.xy = vec2(u_xlat10_3) * vec2(0.390625, 1.984375);
    u_xlat10_3 = texture(_MainTex, vs_TEXCOORD0.xy).w;
    u_xlat16_2.x = u_xlat10_3 * 1.15625 + (-u_xlat16_2.x);
    u_xlat16_5 = u_xlat10_3 * 1.15625 + u_xlat16_2.y;
    SV_Target0.z = u_xlat16_5 + -1.06861997;
    u_xlat16_2.x = (-u_xlat10_0) * 0.8125 + u_xlat16_2.x;
    u_xlat16_5 = u_xlat10_0 * 1.59375;
    u_xlat16_2.y = u_xlat10_3 * 1.15625 + u_xlat16_5;
    SV_Target0.xy = u_xlat16_2.yx + vec2(-0.872539997, 0.531369984);
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	vec4 _MainTex_ST;
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
vec4 u_xlat1;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    u_xlat0.xy = in_TEXCOORD0.xy * vec2(1.0, -1.0) + vec2(0.0, 1.0);
    vs_TEXCOORD0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _MainTex_TexelSize;
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D _SecondTex;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
float u_xlat0;
lowp float u_xlat10_0;
vec4 u_xlat1;
mediump vec2 u_xlat16_2;
float u_xlat3;
lowp float u_xlat10_3;
int u_xlati3;
mediump float u_xlat16_5;
float u_xlat6;
int u_xlati6;
bool u_xlatb6;
int u_xlati9;
bool u_xlatb9;
void main()
{
    u_xlat0 = _MainTex_TexelSize.z + -0.5;
    u_xlat3 = vs_TEXCOORD0.x * u_xlat0 + 0.5;
    u_xlat0 = float(1.0) / u_xlat0;
    u_xlat3 = floor(u_xlat3);
    u_xlat6 = u_xlat3 * 0.5;
    u_xlati3 = int(u_xlat3);
#ifdef UNITY_ADRENO_ES3
    u_xlatb9 = !!(u_xlat6>=(-u_xlat6));
#else
    u_xlatb9 = u_xlat6>=(-u_xlat6);
#endif
    u_xlat6 = fract(abs(u_xlat6));
    u_xlat6 = (u_xlatb9) ? u_xlat6 : (-u_xlat6);
#ifdef UNITY_ADRENO_ES3
    u_xlatb6 = !!(u_xlat6==0.0);
#else
    u_xlatb6 = u_xlat6==0.0;
#endif
    u_xlati9 = u_xlati3 + int(0xFFFFFFFFu);
    u_xlati3 = (u_xlatb6) ? u_xlati3 : u_xlati9;
    u_xlati6 = u_xlati3 + 1;
    u_xlat3 = float(u_xlati3);
    u_xlat1.x = u_xlat0 * u_xlat3;
    u_xlat3 = float(u_xlati6);
    u_xlat1.z = u_xlat0 * u_xlat3;
    u_xlat1.yw = vs_TEXCOORD0.yy;
    u_xlat10_0 = texture(_SecondTex, u_xlat1.zw).w;
    u_xlat10_3 = texture(_SecondTex, u_xlat1.xy).w;
    u_xlat16_2.xy = vec2(u_xlat10_3) * vec2(0.390625, 1.984375);
    u_xlat10_3 = texture(_MainTex, vs_TEXCOORD0.xy).w;
    u_xlat16_2.x = u_xlat10_3 * 1.15625 + (-u_xlat16_2.x);
    u_xlat16_5 = u_xlat10_3 * 1.15625 + u_xlat16_2.y;
    SV_Target0.z = u_xlat16_5 + -1.06861997;
    u_xlat16_2.x = (-u_xlat10_0) * 0.8125 + u_xlat16_2.x;
    u_xlat16_5 = u_xlat10_0 * 1.59375;
    u_xlat16_2.y = u_xlat10_3 * 1.15625 + u_xlat16_5;
    SV_Target0.xy = u_xlat16_2.yx + vec2(-0.872539997, 0.531369984);
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	vec4 _MainTex_ST;
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
vec4 u_xlat1;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    u_xlat0.xy = in_TEXCOORD0.xy * vec2(1.0, -1.0) + vec2(0.0, 1.0);
    vs_TEXCOORD0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _MainTex_TexelSize;
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D _SecondTex;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
float u_xlat0;
lowp float u_xlat10_0;
vec4 u_xlat1;
mediump vec2 u_xlat16_2;
float u_xlat3;
lowp float u_xlat10_3;
int u_xlati3;
mediump float u_xlat16_5;
float u_xlat6;
int u_xlati6;
bool u_xlatb6;
int u_xlati9;
bool u_xlatb9;
void main()
{
    u_xlat0 = _MainTex_TexelSize.z + -0.5;
    u_xlat3 = vs_TEXCOORD0.x * u_xlat0 + 0.5;
    u_xlat0 = float(1.0) / u_xlat0;
    u_xlat3 = floor(u_xlat3);
    u_xlat6 = u_xlat3 * 0.5;
    u_xlati3 = int(u_xlat3);
#ifdef UNITY_ADRENO_ES3
    u_xlatb9 = !!(u_xlat6>=(-u_xlat6));
#else
    u_xlatb9 = u_xlat6>=(-u_xlat6);
#endif
    u_xlat6 = fract(abs(u_xlat6));
    u_xlat6 = (u_xlatb9) ? u_xlat6 : (-u_xlat6);
#ifdef UNITY_ADRENO_ES3
    u_xlatb6 = !!(u_xlat6==0.0);
#else
    u_xlatb6 = u_xlat6==0.0;
#endif
    u_xlati9 = u_xlati3 + int(0xFFFFFFFFu);
    u_xlati3 = (u_xlatb6) ? u_xlati3 : u_xlati9;
    u_xlati6 = u_xlati3 + 1;
    u_xlat3 = float(u_xlati3);
    u_xlat1.x = u_xlat0 * u_xlat3;
    u_xlat3 = float(u_xlati6);
    u_xlat1.z = u_xlat0 * u_xlat3;
    u_xlat1.yw = vs_TEXCOORD0.yy;
    u_xlat10_0 = texture(_SecondTex, u_xlat1.zw).w;
    u_xlat10_3 = texture(_SecondTex, u_xlat1.xy).w;
    u_xlat16_2.xy = vec2(u_xlat10_3) * vec2(0.390625, 1.984375);
    u_xlat10_3 = texture(_MainTex, vs_TEXCOORD0.xy).w;
    u_xlat16_2.x = u_xlat10_3 * 1.15625 + (-u_xlat16_2.x);
    u_xlat16_5 = u_xlat10_3 * 1.15625 + u_xlat16_2.y;
    SV_Target0.z = u_xlat16_5 + -1.06861997;
    u_xlat16_2.x = (-u_xlat10_0) * 0.8125 + u_xlat16_2.x;
    u_xlat16_5 = u_xlat10_0 * 1.59375;
    u_xlat16_2.y = u_xlat10_3 * 1.15625 + u_xlat16_5;
    SV_Target0.xy = u_xlat16_2.yx + vec2(-0.872539997, 0.531369984);
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
}
Program "fp" {
SubProgram "gles hw_tier00 " {
""
}
SubProgram "gles hw_tier01 " {
""
}
SubProgram "gles hw_tier02 " {
""
}
SubProgram "gles3 hw_tier00 " {
""
}
SubProgram "gles3 hw_tier01 " {
""
}
SubProgram "gles3 hw_tier02 " {
""
}
}
}
 Pass {
  Name "FLIP_SEMIPLANARYCBCRA_TO_RGBA"
  ZTest Always
  ZWrite Off
  Cull Off
  GpuProgramID 487501
Program "vp" {
SubProgram "gles hw_tier00 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec2 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _glesVertex.xyz;
  tmpvar_1.x = _glesMultiTexCoord0.x;
  tmpvar_1.y = (1.0 - _glesMultiTexCoord0.y);
  tmpvar_1 = ((tmpvar_1 * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_2));
  xlv_TEXCOORD0 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _SecondTex;
uniform highp vec4 _MainTex_TexelSize;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp float tmpvar_1;
  tmpvar_1 = (_MainTex_TexelSize.z - 0.5);
  highp float tmpvar_2;
  tmpvar_2 = (2.0 / tmpvar_1);
  highp float tmpvar_3;
  tmpvar_3 = (0.5 * xlv_TEXCOORD0.x);
  highp int tmpvar_4;
  tmpvar_4 = int(floor((
    (tmpvar_3 * tmpvar_1)
   + 0.5)));
  highp float tmpvar_5;
  tmpvar_5 = (float(tmpvar_4) / 2.0);
  highp float tmpvar_6;
  tmpvar_6 = (fract(abs(tmpvar_5)) * 2.0);
  highp float tmpvar_7;
  if ((tmpvar_5 >= 0.0)) {
    tmpvar_7 = tmpvar_6;
  } else {
    tmpvar_7 = -(tmpvar_6);
  };
  highp int tmpvar_8;
  if ((tmpvar_7 == 0.0)) {
    tmpvar_8 = tmpvar_4;
  } else {
    tmpvar_8 = (tmpvar_4 - 1);
  };
  highp vec2 tmpvar_9;
  tmpvar_9.x = (float(tmpvar_8) * tmpvar_2);
  tmpvar_9.y = xlv_TEXCOORD0.y;
  highp vec2 tmpvar_10;
  tmpvar_10.x = (float((tmpvar_8 + 1)) * tmpvar_2);
  tmpvar_10.y = xlv_TEXCOORD0.y;
  highp vec2 tmpvar_11;
  tmpvar_11.x = tmpvar_3;
  tmpvar_11.y = xlv_TEXCOORD0.y;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_SecondTex, tmpvar_9);
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_SecondTex, tmpvar_10);
  highp vec2 tmpvar_14;
  tmpvar_14.x = (tmpvar_3 + 0.5);
  tmpvar_14.y = xlv_TEXCOORD0.y;
  lowp float tmpvar_15;
  tmpvar_15 = (1.15625 * texture2D (_MainTex, tmpvar_11).w);
  lowp vec4 tmpvar_16;
  tmpvar_16.x = ((tmpvar_15 + (1.59375 * tmpvar_13.w)) - 0.87254);
  tmpvar_16.y = (((tmpvar_15 - 
    (0.390625 * tmpvar_12.w)
  ) - (0.8125 * tmpvar_13.w)) + 0.53137);
  tmpvar_16.z = ((tmpvar_15 + (1.984375 * tmpvar_12.w)) - 1.06862);
  tmpvar_16.w = (1.15625 * (texture2D (_MainTex, tmpvar_14).w - 0.062745));
  gl_FragData[0] = tmpvar_16;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec2 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _glesVertex.xyz;
  tmpvar_1.x = _glesMultiTexCoord0.x;
  tmpvar_1.y = (1.0 - _glesMultiTexCoord0.y);
  tmpvar_1 = ((tmpvar_1 * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_2));
  xlv_TEXCOORD0 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _SecondTex;
uniform highp vec4 _MainTex_TexelSize;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp float tmpvar_1;
  tmpvar_1 = (_MainTex_TexelSize.z - 0.5);
  highp float tmpvar_2;
  tmpvar_2 = (2.0 / tmpvar_1);
  highp float tmpvar_3;
  tmpvar_3 = (0.5 * xlv_TEXCOORD0.x);
  highp int tmpvar_4;
  tmpvar_4 = int(floor((
    (tmpvar_3 * tmpvar_1)
   + 0.5)));
  highp float tmpvar_5;
  tmpvar_5 = (float(tmpvar_4) / 2.0);
  highp float tmpvar_6;
  tmpvar_6 = (fract(abs(tmpvar_5)) * 2.0);
  highp float tmpvar_7;
  if ((tmpvar_5 >= 0.0)) {
    tmpvar_7 = tmpvar_6;
  } else {
    tmpvar_7 = -(tmpvar_6);
  };
  highp int tmpvar_8;
  if ((tmpvar_7 == 0.0)) {
    tmpvar_8 = tmpvar_4;
  } else {
    tmpvar_8 = (tmpvar_4 - 1);
  };
  highp vec2 tmpvar_9;
  tmpvar_9.x = (float(tmpvar_8) * tmpvar_2);
  tmpvar_9.y = xlv_TEXCOORD0.y;
  highp vec2 tmpvar_10;
  tmpvar_10.x = (float((tmpvar_8 + 1)) * tmpvar_2);
  tmpvar_10.y = xlv_TEXCOORD0.y;
  highp vec2 tmpvar_11;
  tmpvar_11.x = tmpvar_3;
  tmpvar_11.y = xlv_TEXCOORD0.y;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_SecondTex, tmpvar_9);
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_SecondTex, tmpvar_10);
  highp vec2 tmpvar_14;
  tmpvar_14.x = (tmpvar_3 + 0.5);
  tmpvar_14.y = xlv_TEXCOORD0.y;
  lowp float tmpvar_15;
  tmpvar_15 = (1.15625 * texture2D (_MainTex, tmpvar_11).w);
  lowp vec4 tmpvar_16;
  tmpvar_16.x = ((tmpvar_15 + (1.59375 * tmpvar_13.w)) - 0.87254);
  tmpvar_16.y = (((tmpvar_15 - 
    (0.390625 * tmpvar_12.w)
  ) - (0.8125 * tmpvar_13.w)) + 0.53137);
  tmpvar_16.z = ((tmpvar_15 + (1.984375 * tmpvar_12.w)) - 1.06862);
  tmpvar_16.w = (1.15625 * (texture2D (_MainTex, tmpvar_14).w - 0.062745));
  gl_FragData[0] = tmpvar_16;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec2 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _glesVertex.xyz;
  tmpvar_1.x = _glesMultiTexCoord0.x;
  tmpvar_1.y = (1.0 - _glesMultiTexCoord0.y);
  tmpvar_1 = ((tmpvar_1 * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_2));
  xlv_TEXCOORD0 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _SecondTex;
uniform highp vec4 _MainTex_TexelSize;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp float tmpvar_1;
  tmpvar_1 = (_MainTex_TexelSize.z - 0.5);
  highp float tmpvar_2;
  tmpvar_2 = (2.0 / tmpvar_1);
  highp float tmpvar_3;
  tmpvar_3 = (0.5 * xlv_TEXCOORD0.x);
  highp int tmpvar_4;
  tmpvar_4 = int(floor((
    (tmpvar_3 * tmpvar_1)
   + 0.5)));
  highp float tmpvar_5;
  tmpvar_5 = (float(tmpvar_4) / 2.0);
  highp float tmpvar_6;
  tmpvar_6 = (fract(abs(tmpvar_5)) * 2.0);
  highp float tmpvar_7;
  if ((tmpvar_5 >= 0.0)) {
    tmpvar_7 = tmpvar_6;
  } else {
    tmpvar_7 = -(tmpvar_6);
  };
  highp int tmpvar_8;
  if ((tmpvar_7 == 0.0)) {
    tmpvar_8 = tmpvar_4;
  } else {
    tmpvar_8 = (tmpvar_4 - 1);
  };
  highp vec2 tmpvar_9;
  tmpvar_9.x = (float(tmpvar_8) * tmpvar_2);
  tmpvar_9.y = xlv_TEXCOORD0.y;
  highp vec2 tmpvar_10;
  tmpvar_10.x = (float((tmpvar_8 + 1)) * tmpvar_2);
  tmpvar_10.y = xlv_TEXCOORD0.y;
  highp vec2 tmpvar_11;
  tmpvar_11.x = tmpvar_3;
  tmpvar_11.y = xlv_TEXCOORD0.y;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_SecondTex, tmpvar_9);
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_SecondTex, tmpvar_10);
  highp vec2 tmpvar_14;
  tmpvar_14.x = (tmpvar_3 + 0.5);
  tmpvar_14.y = xlv_TEXCOORD0.y;
  lowp float tmpvar_15;
  tmpvar_15 = (1.15625 * texture2D (_MainTex, tmpvar_11).w);
  lowp vec4 tmpvar_16;
  tmpvar_16.x = ((tmpvar_15 + (1.59375 * tmpvar_13.w)) - 0.87254);
  tmpvar_16.y = (((tmpvar_15 - 
    (0.390625 * tmpvar_12.w)
  ) - (0.8125 * tmpvar_13.w)) + 0.53137);
  tmpvar_16.z = ((tmpvar_15 + (1.984375 * tmpvar_12.w)) - 1.06862);
  tmpvar_16.w = (1.15625 * (texture2D (_MainTex, tmpvar_14).w - 0.062745));
  gl_FragData[0] = tmpvar_16;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	vec4 _MainTex_ST;
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
vec4 u_xlat1;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    u_xlat0.xy = in_TEXCOORD0.xy * vec2(1.0, -1.0) + vec2(0.0, 1.0);
    vs_TEXCOORD0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _MainTex_TexelSize;
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D _SecondTex;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec2 u_xlat0;
lowp float u_xlat10_0;
vec4 u_xlat1;
int u_xlati1;
bool u_xlatb1;
mediump vec2 u_xlat16_2;
vec3 u_xlat3;
lowp float u_xlat10_3;
int u_xlati3;
mediump float u_xlat16_5;
lowp float u_xlat10_6;
float u_xlat9;
int u_xlati9;
bool u_xlatb9;
void main()
{
    u_xlat0.x = _MainTex_TexelSize.z + -0.5;
    u_xlat3.xyz = vs_TEXCOORD0.xxy * vec3(0.5, 0.5, 1.0);
    u_xlat3.x = u_xlat3.x * u_xlat0.x + 0.5;
    u_xlat0.x = 2.0 / u_xlat0.x;
    u_xlat10_6 = texture(_MainTex, u_xlat3.yz).w;
    u_xlat3.x = floor(u_xlat3.x);
    u_xlat9 = u_xlat3.x * 0.5;
    u_xlati3 = int(u_xlat3.x);
#ifdef UNITY_ADRENO_ES3
    u_xlatb1 = !!(u_xlat9>=(-u_xlat9));
#else
    u_xlatb1 = u_xlat9>=(-u_xlat9);
#endif
    u_xlat9 = fract(abs(u_xlat9));
    u_xlat9 = (u_xlatb1) ? u_xlat9 : (-u_xlat9);
#ifdef UNITY_ADRENO_ES3
    u_xlatb9 = !!(u_xlat9==0.0);
#else
    u_xlatb9 = u_xlat9==0.0;
#endif
    u_xlati1 = u_xlati3 + int(0xFFFFFFFFu);
    u_xlati3 = (u_xlatb9) ? u_xlati3 : u_xlati1;
    u_xlati9 = u_xlati3 + 1;
    u_xlat3.x = float(u_xlati3);
    u_xlat1.x = u_xlat0.x * u_xlat3.x;
    u_xlat3.x = float(u_xlati9);
    u_xlat1.z = u_xlat0.x * u_xlat3.x;
    u_xlat1.yw = vs_TEXCOORD0.yy;
    u_xlat10_0 = texture(_SecondTex, u_xlat1.zw).w;
    u_xlat10_3 = texture(_SecondTex, u_xlat1.xy).w;
    u_xlat16_2.xy = vec2(u_xlat10_3) * vec2(0.390625, 1.984375);
    u_xlat16_2.x = u_xlat10_6 * 1.15625 + (-u_xlat16_2.x);
    u_xlat16_5 = u_xlat10_6 * 1.15625 + u_xlat16_2.y;
    SV_Target0.z = u_xlat16_5 + -1.06861997;
    u_xlat16_2.x = (-u_xlat10_0) * 0.8125 + u_xlat16_2.x;
    u_xlat16_5 = u_xlat10_0 * 1.59375;
    u_xlat16_2.y = u_xlat10_6 * 1.15625 + u_xlat16_5;
    SV_Target0.xy = u_xlat16_2.yx + vec2(-0.872539997, 0.531369984);
    u_xlat0.xy = vs_TEXCOORD0.xy * vec2(0.5, 1.0) + vec2(0.5, 0.0);
    u_xlat10_0 = texture(_MainTex, u_xlat0.xy).w;
    u_xlat16_2.x = u_xlat10_0 + -0.0627449974;
    SV_Target0.w = u_xlat16_2.x * 1.15625;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	vec4 _MainTex_ST;
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
vec4 u_xlat1;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    u_xlat0.xy = in_TEXCOORD0.xy * vec2(1.0, -1.0) + vec2(0.0, 1.0);
    vs_TEXCOORD0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _MainTex_TexelSize;
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D _SecondTex;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec2 u_xlat0;
lowp float u_xlat10_0;
vec4 u_xlat1;
int u_xlati1;
bool u_xlatb1;
mediump vec2 u_xlat16_2;
vec3 u_xlat3;
lowp float u_xlat10_3;
int u_xlati3;
mediump float u_xlat16_5;
lowp float u_xlat10_6;
float u_xlat9;
int u_xlati9;
bool u_xlatb9;
void main()
{
    u_xlat0.x = _MainTex_TexelSize.z + -0.5;
    u_xlat3.xyz = vs_TEXCOORD0.xxy * vec3(0.5, 0.5, 1.0);
    u_xlat3.x = u_xlat3.x * u_xlat0.x + 0.5;
    u_xlat0.x = 2.0 / u_xlat0.x;
    u_xlat10_6 = texture(_MainTex, u_xlat3.yz).w;
    u_xlat3.x = floor(u_xlat3.x);
    u_xlat9 = u_xlat3.x * 0.5;
    u_xlati3 = int(u_xlat3.x);
#ifdef UNITY_ADRENO_ES3
    u_xlatb1 = !!(u_xlat9>=(-u_xlat9));
#else
    u_xlatb1 = u_xlat9>=(-u_xlat9);
#endif
    u_xlat9 = fract(abs(u_xlat9));
    u_xlat9 = (u_xlatb1) ? u_xlat9 : (-u_xlat9);
#ifdef UNITY_ADRENO_ES3
    u_xlatb9 = !!(u_xlat9==0.0);
#else
    u_xlatb9 = u_xlat9==0.0;
#endif
    u_xlati1 = u_xlati3 + int(0xFFFFFFFFu);
    u_xlati3 = (u_xlatb9) ? u_xlati3 : u_xlati1;
    u_xlati9 = u_xlati3 + 1;
    u_xlat3.x = float(u_xlati3);
    u_xlat1.x = u_xlat0.x * u_xlat3.x;
    u_xlat3.x = float(u_xlati9);
    u_xlat1.z = u_xlat0.x * u_xlat3.x;
    u_xlat1.yw = vs_TEXCOORD0.yy;
    u_xlat10_0 = texture(_SecondTex, u_xlat1.zw).w;
    u_xlat10_3 = texture(_SecondTex, u_xlat1.xy).w;
    u_xlat16_2.xy = vec2(u_xlat10_3) * vec2(0.390625, 1.984375);
    u_xlat16_2.x = u_xlat10_6 * 1.15625 + (-u_xlat16_2.x);
    u_xlat16_5 = u_xlat10_6 * 1.15625 + u_xlat16_2.y;
    SV_Target0.z = u_xlat16_5 + -1.06861997;
    u_xlat16_2.x = (-u_xlat10_0) * 0.8125 + u_xlat16_2.x;
    u_xlat16_5 = u_xlat10_0 * 1.59375;
    u_xlat16_2.y = u_xlat10_6 * 1.15625 + u_xlat16_5;
    SV_Target0.xy = u_xlat16_2.yx + vec2(-0.872539997, 0.531369984);
    u_xlat0.xy = vs_TEXCOORD0.xy * vec2(0.5, 1.0) + vec2(0.5, 0.0);
    u_xlat10_0 = texture(_MainTex, u_xlat0.xy).w;
    u_xlat16_2.x = u_xlat10_0 + -0.0627449974;
    SV_Target0.w = u_xlat16_2.x * 1.15625;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	vec4 _MainTex_ST;
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
vec4 u_xlat1;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    u_xlat0.xy = in_TEXCOORD0.xy * vec2(1.0, -1.0) + vec2(0.0, 1.0);
    vs_TEXCOORD0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _MainTex_TexelSize;
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D _SecondTex;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec2 u_xlat0;
lowp float u_xlat10_0;
vec4 u_xlat1;
int u_xlati1;
bool u_xlatb1;
mediump vec2 u_xlat16_2;
vec3 u_xlat3;
lowp float u_xlat10_3;
int u_xlati3;
mediump float u_xlat16_5;
lowp float u_xlat10_6;
float u_xlat9;
int u_xlati9;
bool u_xlatb9;
void main()
{
    u_xlat0.x = _MainTex_TexelSize.z + -0.5;
    u_xlat3.xyz = vs_TEXCOORD0.xxy * vec3(0.5, 0.5, 1.0);
    u_xlat3.x = u_xlat3.x * u_xlat0.x + 0.5;
    u_xlat0.x = 2.0 / u_xlat0.x;
    u_xlat10_6 = texture(_MainTex, u_xlat3.yz).w;
    u_xlat3.x = floor(u_xlat3.x);
    u_xlat9 = u_xlat3.x * 0.5;
    u_xlati3 = int(u_xlat3.x);
#ifdef UNITY_ADRENO_ES3
    u_xlatb1 = !!(u_xlat9>=(-u_xlat9));
#else
    u_xlatb1 = u_xlat9>=(-u_xlat9);
#endif
    u_xlat9 = fract(abs(u_xlat9));
    u_xlat9 = (u_xlatb1) ? u_xlat9 : (-u_xlat9);
#ifdef UNITY_ADRENO_ES3
    u_xlatb9 = !!(u_xlat9==0.0);
#else
    u_xlatb9 = u_xlat9==0.0;
#endif
    u_xlati1 = u_xlati3 + int(0xFFFFFFFFu);
    u_xlati3 = (u_xlatb9) ? u_xlati3 : u_xlati1;
    u_xlati9 = u_xlati3 + 1;
    u_xlat3.x = float(u_xlati3);
    u_xlat1.x = u_xlat0.x * u_xlat3.x;
    u_xlat3.x = float(u_xlati9);
    u_xlat1.z = u_xlat0.x * u_xlat3.x;
    u_xlat1.yw = vs_TEXCOORD0.yy;
    u_xlat10_0 = texture(_SecondTex, u_xlat1.zw).w;
    u_xlat10_3 = texture(_SecondTex, u_xlat1.xy).w;
    u_xlat16_2.xy = vec2(u_xlat10_3) * vec2(0.390625, 1.984375);
    u_xlat16_2.x = u_xlat10_6 * 1.15625 + (-u_xlat16_2.x);
    u_xlat16_5 = u_xlat10_6 * 1.15625 + u_xlat16_2.y;
    SV_Target0.z = u_xlat16_5 + -1.06861997;
    u_xlat16_2.x = (-u_xlat10_0) * 0.8125 + u_xlat16_2.x;
    u_xlat16_5 = u_xlat10_0 * 1.59375;
    u_xlat16_2.y = u_xlat10_6 * 1.15625 + u_xlat16_5;
    SV_Target0.xy = u_xlat16_2.yx + vec2(-0.872539997, 0.531369984);
    u_xlat0.xy = vs_TEXCOORD0.xy * vec2(0.5, 1.0) + vec2(0.5, 0.0);
    u_xlat10_0 = texture(_MainTex, u_xlat0.xy).w;
    u_xlat16_2.x = u_xlat10_0 + -0.0627449974;
    SV_Target0.w = u_xlat16_2.x * 1.15625;
    return;
}

#endif
"
}
}
Program "fp" {
SubProgram "gles hw_tier00 " {
""
}
SubProgram "gles hw_tier01 " {
""
}
SubProgram "gles hw_tier02 " {
""
}
SubProgram "gles3 hw_tier00 " {
""
}
SubProgram "gles3 hw_tier01 " {
""
}
SubProgram "gles3 hw_tier02 " {
""
}
}
}
 Pass {
  Name "FLIP_NV12_TO_RGB1"
  ZTest Always
  ZWrite Off
  Cull Off
  GpuProgramID 586429
Program "vp" {
SubProgram "gles hw_tier00 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec2 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _glesVertex.xyz;
  tmpvar_1.x = _glesMultiTexCoord0.x;
  tmpvar_1.y = (1.0 - _glesMultiTexCoord0.y);
  tmpvar_1 = ((tmpvar_1 * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_2));
  xlv_TEXCOORD0 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _SecondTex;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 result_1;
  highp vec3 yCbCr_2;
  lowp vec3 tmpvar_3;
  tmpvar_3.x = (texture2D (_MainTex, xlv_TEXCOORD0).w - 0.0625);
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_SecondTex, xlv_TEXCOORD0);
  tmpvar_3.y = (tmpvar_4.x - 0.5);
  tmpvar_3.z = (tmpvar_4.y - 0.5);
  yCbCr_2 = tmpvar_3;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.x = dot (vec3(1.1644, 0.0, 1.7927), yCbCr_2);
  tmpvar_5.y = dot (vec3(1.1644, -0.2133, -0.5329), yCbCr_2);
  tmpvar_5.z = dot (vec3(1.1644, 2.1124, 0.0), yCbCr_2);
  result_1 = tmpvar_5;
  gl_FragData[0] = result_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec2 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _glesVertex.xyz;
  tmpvar_1.x = _glesMultiTexCoord0.x;
  tmpvar_1.y = (1.0 - _glesMultiTexCoord0.y);
  tmpvar_1 = ((tmpvar_1 * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_2));
  xlv_TEXCOORD0 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _SecondTex;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 result_1;
  highp vec3 yCbCr_2;
  lowp vec3 tmpvar_3;
  tmpvar_3.x = (texture2D (_MainTex, xlv_TEXCOORD0).w - 0.0625);
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_SecondTex, xlv_TEXCOORD0);
  tmpvar_3.y = (tmpvar_4.x - 0.5);
  tmpvar_3.z = (tmpvar_4.y - 0.5);
  yCbCr_2 = tmpvar_3;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.x = dot (vec3(1.1644, 0.0, 1.7927), yCbCr_2);
  tmpvar_5.y = dot (vec3(1.1644, -0.2133, -0.5329), yCbCr_2);
  tmpvar_5.z = dot (vec3(1.1644, 2.1124, 0.0), yCbCr_2);
  result_1 = tmpvar_5;
  gl_FragData[0] = result_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec2 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _glesVertex.xyz;
  tmpvar_1.x = _glesMultiTexCoord0.x;
  tmpvar_1.y = (1.0 - _glesMultiTexCoord0.y);
  tmpvar_1 = ((tmpvar_1 * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_2));
  xlv_TEXCOORD0 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _SecondTex;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 result_1;
  highp vec3 yCbCr_2;
  lowp vec3 tmpvar_3;
  tmpvar_3.x = (texture2D (_MainTex, xlv_TEXCOORD0).w - 0.0625);
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_SecondTex, xlv_TEXCOORD0);
  tmpvar_3.y = (tmpvar_4.x - 0.5);
  tmpvar_3.z = (tmpvar_4.y - 0.5);
  yCbCr_2 = tmpvar_3;
  highp vec4 tmpvar_5;
  tmpvar_5.w = 1.0;
  tmpvar_5.x = dot (vec3(1.1644, 0.0, 1.7927), yCbCr_2);
  tmpvar_5.y = dot (vec3(1.1644, -0.2133, -0.5329), yCbCr_2);
  tmpvar_5.z = dot (vec3(1.1644, 2.1124, 0.0), yCbCr_2);
  result_1 = tmpvar_5;
  gl_FragData[0] = result_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	vec4 _MainTex_ST;
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
vec4 u_xlat1;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    u_xlat0.xy = in_TEXCOORD0.xy * vec2(1.0, -1.0) + vec2(0.0, 1.0);
    vs_TEXCOORD0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D _SecondTex;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec3 u_xlat1;
lowp float u_xlat10_1;
lowp vec2 u_xlat10_2;
void main()
{
    u_xlat0.w = 1.0;
    u_xlat10_1 = texture(_MainTex, vs_TEXCOORD0.xy).w;
    u_xlat1.x = u_xlat10_1 + -0.0625;
    u_xlat10_2.xy = texture(_SecondTex, vs_TEXCOORD0.xy).xy;
    u_xlat1.yz = u_xlat10_2.xy + vec2(-0.5, -0.5);
    u_xlat0.x = dot(vec2(1.16439998, 1.79270005), u_xlat1.xz);
    u_xlat0.y = dot(vec3(1.16439998, -0.213300005, -0.532899976), u_xlat1.xyz);
    u_xlat0.z = dot(vec2(1.16439998, 2.11240005), u_xlat1.xy);
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	vec4 _MainTex_ST;
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
vec4 u_xlat1;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    u_xlat0.xy = in_TEXCOORD0.xy * vec2(1.0, -1.0) + vec2(0.0, 1.0);
    vs_TEXCOORD0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D _SecondTex;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec3 u_xlat1;
lowp float u_xlat10_1;
lowp vec2 u_xlat10_2;
void main()
{
    u_xlat0.w = 1.0;
    u_xlat10_1 = texture(_MainTex, vs_TEXCOORD0.xy).w;
    u_xlat1.x = u_xlat10_1 + -0.0625;
    u_xlat10_2.xy = texture(_SecondTex, vs_TEXCOORD0.xy).xy;
    u_xlat1.yz = u_xlat10_2.xy + vec2(-0.5, -0.5);
    u_xlat0.x = dot(vec2(1.16439998, 1.79270005), u_xlat1.xz);
    u_xlat0.y = dot(vec3(1.16439998, -0.213300005, -0.532899976), u_xlat1.xyz);
    u_xlat0.z = dot(vec2(1.16439998, 2.11240005), u_xlat1.xy);
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	vec4 _MainTex_ST;
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
vec4 u_xlat1;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    u_xlat0.xy = in_TEXCOORD0.xy * vec2(1.0, -1.0) + vec2(0.0, 1.0);
    vs_TEXCOORD0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D _SecondTex;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec3 u_xlat1;
lowp float u_xlat10_1;
lowp vec2 u_xlat10_2;
void main()
{
    u_xlat0.w = 1.0;
    u_xlat10_1 = texture(_MainTex, vs_TEXCOORD0.xy).w;
    u_xlat1.x = u_xlat10_1 + -0.0625;
    u_xlat10_2.xy = texture(_SecondTex, vs_TEXCOORD0.xy).xy;
    u_xlat1.yz = u_xlat10_2.xy + vec2(-0.5, -0.5);
    u_xlat0.x = dot(vec2(1.16439998, 1.79270005), u_xlat1.xz);
    u_xlat0.y = dot(vec3(1.16439998, -0.213300005, -0.532899976), u_xlat1.xyz);
    u_xlat0.z = dot(vec2(1.16439998, 2.11240005), u_xlat1.xy);
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
}
Program "fp" {
SubProgram "gles hw_tier00 " {
""
}
SubProgram "gles hw_tier01 " {
""
}
SubProgram "gles hw_tier02 " {
""
}
SubProgram "gles3 hw_tier00 " {
""
}
SubProgram "gles3 hw_tier01 " {
""
}
SubProgram "gles3 hw_tier02 " {
""
}
}
}
 Pass {
  Name "FLIP_NV12_TO_RGBA"
  ZTest Always
  ZWrite Off
  Cull Off
  GpuProgramID 632801
Program "vp" {
SubProgram "gles hw_tier00 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec2 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _glesVertex.xyz;
  tmpvar_1.x = _glesMultiTexCoord0.x;
  tmpvar_1.y = (1.0 - _glesMultiTexCoord0.y);
  tmpvar_1 = ((tmpvar_1 * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_2));
  xlv_TEXCOORD0 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _SecondTex;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp float tmpvar_1;
  tmpvar_1 = (0.5 * xlv_TEXCOORD0.x);
  highp vec2 tmpvar_2;
  tmpvar_2.x = tmpvar_1;
  tmpvar_2.y = xlv_TEXCOORD0.y;
  highp vec2 tmpvar_3;
  tmpvar_3.x = (tmpvar_1 + 0.5);
  tmpvar_3.y = xlv_TEXCOORD0.y;
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_1;
  tmpvar_4.y = xlv_TEXCOORD0.y;
  lowp vec2 tmpvar_5;
  tmpvar_5 = texture2D (_SecondTex, tmpvar_4).xy;
  lowp float tmpvar_6;
  tmpvar_6 = (1.15625 * texture2D (_MainTex, tmpvar_2).w);
  lowp vec4 tmpvar_7;
  tmpvar_7.x = ((tmpvar_6 + (1.59375 * tmpvar_5.y)) - 0.87254);
  tmpvar_7.y = (((tmpvar_6 - 
    (0.390625 * tmpvar_5.x)
  ) - (0.8125 * tmpvar_5.y)) + 0.53137);
  tmpvar_7.z = ((tmpvar_6 + (1.984375 * tmpvar_5.x)) - 1.06862);
  tmpvar_7.w = (1.15625 * (texture2D (_MainTex, tmpvar_3).w - 0.062745));
  gl_FragData[0] = tmpvar_7;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec2 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _glesVertex.xyz;
  tmpvar_1.x = _glesMultiTexCoord0.x;
  tmpvar_1.y = (1.0 - _glesMultiTexCoord0.y);
  tmpvar_1 = ((tmpvar_1 * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_2));
  xlv_TEXCOORD0 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _SecondTex;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp float tmpvar_1;
  tmpvar_1 = (0.5 * xlv_TEXCOORD0.x);
  highp vec2 tmpvar_2;
  tmpvar_2.x = tmpvar_1;
  tmpvar_2.y = xlv_TEXCOORD0.y;
  highp vec2 tmpvar_3;
  tmpvar_3.x = (tmpvar_1 + 0.5);
  tmpvar_3.y = xlv_TEXCOORD0.y;
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_1;
  tmpvar_4.y = xlv_TEXCOORD0.y;
  lowp vec2 tmpvar_5;
  tmpvar_5 = texture2D (_SecondTex, tmpvar_4).xy;
  lowp float tmpvar_6;
  tmpvar_6 = (1.15625 * texture2D (_MainTex, tmpvar_2).w);
  lowp vec4 tmpvar_7;
  tmpvar_7.x = ((tmpvar_6 + (1.59375 * tmpvar_5.y)) - 0.87254);
  tmpvar_7.y = (((tmpvar_6 - 
    (0.390625 * tmpvar_5.x)
  ) - (0.8125 * tmpvar_5.y)) + 0.53137);
  tmpvar_7.z = ((tmpvar_6 + (1.984375 * tmpvar_5.x)) - 1.06862);
  tmpvar_7.w = (1.15625 * (texture2D (_MainTex, tmpvar_3).w - 0.062745));
  gl_FragData[0] = tmpvar_7;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform highp vec4 _MainTex_ST;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec2 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _glesVertex.xyz;
  tmpvar_1.x = _glesMultiTexCoord0.x;
  tmpvar_1.y = (1.0 - _glesMultiTexCoord0.y);
  tmpvar_1 = ((tmpvar_1 * _MainTex_ST.xy) + _MainTex_ST.zw);
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_2));
  xlv_TEXCOORD0 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _MainTex;
uniform sampler2D _SecondTex;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp float tmpvar_1;
  tmpvar_1 = (0.5 * xlv_TEXCOORD0.x);
  highp vec2 tmpvar_2;
  tmpvar_2.x = tmpvar_1;
  tmpvar_2.y = xlv_TEXCOORD0.y;
  highp vec2 tmpvar_3;
  tmpvar_3.x = (tmpvar_1 + 0.5);
  tmpvar_3.y = xlv_TEXCOORD0.y;
  highp vec2 tmpvar_4;
  tmpvar_4.x = tmpvar_1;
  tmpvar_4.y = xlv_TEXCOORD0.y;
  lowp vec2 tmpvar_5;
  tmpvar_5 = texture2D (_SecondTex, tmpvar_4).xy;
  lowp float tmpvar_6;
  tmpvar_6 = (1.15625 * texture2D (_MainTex, tmpvar_2).w);
  lowp vec4 tmpvar_7;
  tmpvar_7.x = ((tmpvar_6 + (1.59375 * tmpvar_5.y)) - 0.87254);
  tmpvar_7.y = (((tmpvar_6 - 
    (0.390625 * tmpvar_5.x)
  ) - (0.8125 * tmpvar_5.y)) + 0.53137);
  tmpvar_7.z = ((tmpvar_6 + (1.984375 * tmpvar_5.x)) - 1.06862);
  tmpvar_7.w = (1.15625 * (texture2D (_MainTex, tmpvar_3).w - 0.062745));
  gl_FragData[0] = tmpvar_7;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	vec4 _MainTex_ST;
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
vec4 u_xlat1;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    u_xlat0.xy = in_TEXCOORD0.xy * vec2(1.0, -1.0) + vec2(0.0, 1.0);
    vs_TEXCOORD0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D _SecondTex;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec2 u_xlat0;
lowp vec2 u_xlat10_0;
mediump vec3 u_xlat16_1;
mediump float u_xlat16_3;
lowp float u_xlat10_4;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy * vec2(0.5, 1.0) + vec2(0.5, 0.0);
    u_xlat10_0.x = texture(_MainTex, u_xlat0.xy).w;
    u_xlat16_1.x = u_xlat10_0.x + -0.0627449974;
    SV_Target0.w = u_xlat16_1.x * 1.15625;
    u_xlat0.xy = vs_TEXCOORD0.xy * vec2(0.5, 1.0);
    u_xlat10_4 = texture(_MainTex, u_xlat0.xy).w;
    u_xlat10_0.xy = texture(_SecondTex, u_xlat0.xy).xy;
    u_xlat16_1.xyz = u_xlat10_0.yxx * vec3(1.59375, 0.390625, 1.984375);
    u_xlat16_3 = u_xlat10_4 * 1.15625 + (-u_xlat16_1.y);
    u_xlat16_1.xz = vec2(u_xlat10_4) * vec2(1.15625, 1.15625) + u_xlat16_1.xz;
    SV_Target0.xz = u_xlat16_1.xz + vec2(-0.872539997, -1.06861997);
    u_xlat16_1.x = (-u_xlat10_0.y) * 0.8125 + u_xlat16_3;
    SV_Target0.y = u_xlat16_1.x + 0.531369984;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	vec4 _MainTex_ST;
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
vec4 u_xlat1;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    u_xlat0.xy = in_TEXCOORD0.xy * vec2(1.0, -1.0) + vec2(0.0, 1.0);
    vs_TEXCOORD0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D _SecondTex;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec2 u_xlat0;
lowp vec2 u_xlat10_0;
mediump vec3 u_xlat16_1;
mediump float u_xlat16_3;
lowp float u_xlat10_4;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy * vec2(0.5, 1.0) + vec2(0.5, 0.0);
    u_xlat10_0.x = texture(_MainTex, u_xlat0.xy).w;
    u_xlat16_1.x = u_xlat10_0.x + -0.0627449974;
    SV_Target0.w = u_xlat16_1.x * 1.15625;
    u_xlat0.xy = vs_TEXCOORD0.xy * vec2(0.5, 1.0);
    u_xlat10_4 = texture(_MainTex, u_xlat0.xy).w;
    u_xlat10_0.xy = texture(_SecondTex, u_xlat0.xy).xy;
    u_xlat16_1.xyz = u_xlat10_0.yxx * vec3(1.59375, 0.390625, 1.984375);
    u_xlat16_3 = u_xlat10_4 * 1.15625 + (-u_xlat16_1.y);
    u_xlat16_1.xz = vec2(u_xlat10_4) * vec2(1.15625, 1.15625) + u_xlat16_1.xz;
    SV_Target0.xz = u_xlat16_1.xz + vec2(-0.872539997, -1.06861997);
    u_xlat16_1.x = (-u_xlat10_0.y) * 0.8125 + u_xlat16_3;
    SV_Target0.y = u_xlat16_1.x + 0.531369984;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	vec4 _MainTex_ST;
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
out highp vec2 vs_TEXCOORD0;
vec4 u_xlat0;
vec4 u_xlat1;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    gl_Position = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    u_xlat0.xy = in_TEXCOORD0.xy * vec2(1.0, -1.0) + vec2(0.0, 1.0);
    vs_TEXCOORD0.xy = u_xlat0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D _SecondTex;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec2 u_xlat0;
lowp vec2 u_xlat10_0;
mediump vec3 u_xlat16_1;
mediump float u_xlat16_3;
lowp float u_xlat10_4;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy * vec2(0.5, 1.0) + vec2(0.5, 0.0);
    u_xlat10_0.x = texture(_MainTex, u_xlat0.xy).w;
    u_xlat16_1.x = u_xlat10_0.x + -0.0627449974;
    SV_Target0.w = u_xlat16_1.x * 1.15625;
    u_xlat0.xy = vs_TEXCOORD0.xy * vec2(0.5, 1.0);
    u_xlat10_4 = texture(_MainTex, u_xlat0.xy).w;
    u_xlat10_0.xy = texture(_SecondTex, u_xlat0.xy).xy;
    u_xlat16_1.xyz = u_xlat10_0.yxx * vec3(1.59375, 0.390625, 1.984375);
    u_xlat16_3 = u_xlat10_4 * 1.15625 + (-u_xlat16_1.y);
    u_xlat16_1.xz = vec2(u_xlat10_4) * vec2(1.15625, 1.15625) + u_xlat16_1.xz;
    SV_Target0.xz = u_xlat16_1.xz + vec2(-0.872539997, -1.06861997);
    u_xlat16_1.x = (-u_xlat10_0.y) * 0.8125 + u_xlat16_3;
    SV_Target0.y = u_xlat16_1.x + 0.531369984;
    return;
}

#endif
"
}
}
Program "fp" {
SubProgram "gles hw_tier00 " {
""
}
SubProgram "gles hw_tier01 " {
""
}
SubProgram "gles hw_tier02 " {
""
}
SubProgram "gles3 hw_tier00 " {
""
}
SubProgram "gles3 hw_tier01 " {
""
}
SubProgram "gles3 hw_tier02 " {
""
}
}
}
}
}