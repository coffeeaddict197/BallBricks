//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Hidden/Internal-MotionVectors" {
Properties {
}
SubShader {
 Pass {
  Tags { "LIGHTMODE" = "MOTIONVECTORS" }
  ZWrite Off
  GpuProgramID 59123
Program "vp" {
SubProgram "gles hw_tier00 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform highp mat4 _NonJitteredVP;
uniform highp mat4 _PreviousVP;
uniform highp mat4 _PreviousM;
uniform bool _HasLastPositionData;
uniform highp float _MotionVectorDepthBias;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  tmpvar_2 = _glesNormal;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_1.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  tmpvar_4.xyw = tmpvar_5.xyw;
  tmpvar_4.z = (tmpvar_5.z + (_MotionVectorDepthBias * tmpvar_5.w));
  tmpvar_3 = (_NonJitteredVP * (unity_ObjectToWorld * _glesVertex));
  highp vec4 tmpvar_7;
  if (_HasLastPositionData) {
    highp vec4 tmpvar_8;
    tmpvar_8.w = 1.0;
    tmpvar_8.xyz = tmpvar_2;
    tmpvar_7 = tmpvar_8;
  } else {
    tmpvar_7 = tmpvar_1;
  };
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (_PreviousVP * (_PreviousM * tmpvar_7));
  gl_Position = tmpvar_4;
}


#endif
#ifdef FRAGMENT
uniform bool _ForceNoMotion;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
void main ()
{
  mediump vec2 uvDiff_1;
  highp vec2 tmpvar_2;
  tmpvar_2 = (((
    (xlv_TEXCOORD0.xyz / xlv_TEXCOORD0.w)
  .xy + 1.0) / 2.0) - ((
    (xlv_TEXCOORD1.xyz / xlv_TEXCOORD1.w)
  .xy + 1.0) / 2.0));
  uvDiff_1 = tmpvar_2;
  mediump vec4 tmpvar_3;
  tmpvar_3.zw = vec2(0.0, 1.0);
  tmpvar_3.xy = uvDiff_1;
  gl_FragData[0] = (tmpvar_3 * (vec4(1.0, 1.0, 1.0, 1.0) - vec4(float(_ForceNoMotion))));
}


#endif
"
}
SubProgram "gles hw_tier01 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform highp mat4 _NonJitteredVP;
uniform highp mat4 _PreviousVP;
uniform highp mat4 _PreviousM;
uniform bool _HasLastPositionData;
uniform highp float _MotionVectorDepthBias;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  tmpvar_2 = _glesNormal;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_1.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  tmpvar_4.xyw = tmpvar_5.xyw;
  tmpvar_4.z = (tmpvar_5.z + (_MotionVectorDepthBias * tmpvar_5.w));
  tmpvar_3 = (_NonJitteredVP * (unity_ObjectToWorld * _glesVertex));
  highp vec4 tmpvar_7;
  if (_HasLastPositionData) {
    highp vec4 tmpvar_8;
    tmpvar_8.w = 1.0;
    tmpvar_8.xyz = tmpvar_2;
    tmpvar_7 = tmpvar_8;
  } else {
    tmpvar_7 = tmpvar_1;
  };
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (_PreviousVP * (_PreviousM * tmpvar_7));
  gl_Position = tmpvar_4;
}


#endif
#ifdef FRAGMENT
uniform bool _ForceNoMotion;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
void main ()
{
  mediump vec2 uvDiff_1;
  highp vec2 tmpvar_2;
  tmpvar_2 = (((
    (xlv_TEXCOORD0.xyz / xlv_TEXCOORD0.w)
  .xy + 1.0) / 2.0) - ((
    (xlv_TEXCOORD1.xyz / xlv_TEXCOORD1.w)
  .xy + 1.0) / 2.0));
  uvDiff_1 = tmpvar_2;
  mediump vec4 tmpvar_3;
  tmpvar_3.zw = vec2(0.0, 1.0);
  tmpvar_3.xy = uvDiff_1;
  gl_FragData[0] = (tmpvar_3 * (vec4(1.0, 1.0, 1.0, 1.0) - vec4(float(_ForceNoMotion))));
}


#endif
"
}
SubProgram "gles hw_tier02 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
uniform highp mat4 _NonJitteredVP;
uniform highp mat4 _PreviousVP;
uniform highp mat4 _PreviousM;
uniform bool _HasLastPositionData;
uniform highp float _MotionVectorDepthBias;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  tmpvar_2 = _glesNormal;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = tmpvar_1.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  tmpvar_4.xyw = tmpvar_5.xyw;
  tmpvar_4.z = (tmpvar_5.z + (_MotionVectorDepthBias * tmpvar_5.w));
  tmpvar_3 = (_NonJitteredVP * (unity_ObjectToWorld * _glesVertex));
  highp vec4 tmpvar_7;
  if (_HasLastPositionData) {
    highp vec4 tmpvar_8;
    tmpvar_8.w = 1.0;
    tmpvar_8.xyz = tmpvar_2;
    tmpvar_7 = tmpvar_8;
  } else {
    tmpvar_7 = tmpvar_1;
  };
  xlv_TEXCOORD0 = tmpvar_3;
  xlv_TEXCOORD1 = (_PreviousVP * (_PreviousM * tmpvar_7));
  gl_Position = tmpvar_4;
}


#endif
#ifdef FRAGMENT
uniform bool _ForceNoMotion;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec4 xlv_TEXCOORD1;
void main ()
{
  mediump vec2 uvDiff_1;
  highp vec2 tmpvar_2;
  tmpvar_2 = (((
    (xlv_TEXCOORD0.xyz / xlv_TEXCOORD0.w)
  .xy + 1.0) / 2.0) - ((
    (xlv_TEXCOORD1.xyz / xlv_TEXCOORD1.w)
  .xy + 1.0) / 2.0));
  uvDiff_1 = tmpvar_2;
  mediump vec4 tmpvar_3;
  tmpvar_3.zw = vec2(0.0, 1.0);
  tmpvar_3.xy = uvDiff_1;
  gl_FragData[0] = (tmpvar_3 * (vec4(1.0, 1.0, 1.0, 1.0) - vec4(float(_ForceNoMotion))));
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	vec4 hlslcc_mtx4x4_NonJitteredVP[4];
uniform 	vec4 hlslcc_mtx4x4_PreviousVP[4];
uniform 	vec4 hlslcc_mtx4x4_PreviousM[4];
uniform 	int _HasLastPositionData;
uniform 	float _MotionVectorDepthBias;
in highp vec4 in_POSITION0;
in highp vec3 in_NORMAL0;
out highp vec4 vs_TEXCOORD0;
out highp vec4 vs_TEXCOORD1;
vec4 u_xlat0;
vec4 u_xlat1;
vec4 u_xlat2;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat1 = hlslcc_mtx4x4unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat2 = u_xlat1.yyyy * hlslcc_mtx4x4_NonJitteredVP[1];
    u_xlat2 = hlslcc_mtx4x4_NonJitteredVP[0] * u_xlat1.xxxx + u_xlat2;
    u_xlat2 = hlslcc_mtx4x4_NonJitteredVP[2] * u_xlat1.zzzz + u_xlat2;
    vs_TEXCOORD0 = hlslcc_mtx4x4_NonJitteredVP[3] * u_xlat1.wwww + u_xlat2;
    u_xlat1.xyz = in_NORMAL0.xyz;
    u_xlat1.w = 1.0;
    u_xlat1 = (_HasLastPositionData != 0) ? u_xlat1 : in_POSITION0;
    u_xlat2 = u_xlat1.yyyy * hlslcc_mtx4x4_PreviousM[1];
    u_xlat2 = hlslcc_mtx4x4_PreviousM[0] * u_xlat1.xxxx + u_xlat2;
    u_xlat2 = hlslcc_mtx4x4_PreviousM[2] * u_xlat1.zzzz + u_xlat2;
    u_xlat1 = hlslcc_mtx4x4_PreviousM[3] * u_xlat1.wwww + u_xlat2;
    u_xlat2 = u_xlat1.yyyy * hlslcc_mtx4x4_PreviousVP[1];
    u_xlat2 = hlslcc_mtx4x4_PreviousVP[0] * u_xlat1.xxxx + u_xlat2;
    u_xlat2 = hlslcc_mtx4x4_PreviousVP[2] * u_xlat1.zzzz + u_xlat2;
    vs_TEXCOORD1 = hlslcc_mtx4x4_PreviousVP[3] * u_xlat1.wwww + u_xlat2;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    gl_Position.z = _MotionVectorDepthBias * u_xlat0.w + u_xlat0.z;
    gl_Position.xyw = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	int _ForceNoMotion;
in highp vec4 vs_TEXCOORD0;
in highp vec4 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec2 u_xlat0;
mediump float u_xlat16_1;
mediump vec2 u_xlat16_3;
vec2 u_xlat4;
void main()
{
    u_xlat0.xy = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    u_xlat0.xy = u_xlat0.xy + vec2(1.0, 1.0);
    u_xlat0.xy = u_xlat0.xy * vec2(0.5, 0.5);
    u_xlat4.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat4.xy = u_xlat4.xy + vec2(1.0, 1.0);
    u_xlat0.xy = u_xlat4.xy * vec2(0.5, 0.5) + (-u_xlat0.xy);
    u_xlat16_1 = (_ForceNoMotion != 0) ? 1.0 : 0.0;
    SV_Target0.xy = vec2(u_xlat16_1) * (-u_xlat0.xy) + u_xlat0.xy;
    u_xlat16_3.x = float(-0.0);
    u_xlat16_3.y = float(-1.0);
    SV_Target0.zw = vec2(u_xlat16_1) * u_xlat16_3.xy + vec2(0.0, 1.0);
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
uniform 	vec4 hlslcc_mtx4x4_NonJitteredVP[4];
uniform 	vec4 hlslcc_mtx4x4_PreviousVP[4];
uniform 	vec4 hlslcc_mtx4x4_PreviousM[4];
uniform 	int _HasLastPositionData;
uniform 	float _MotionVectorDepthBias;
in highp vec4 in_POSITION0;
in highp vec3 in_NORMAL0;
out highp vec4 vs_TEXCOORD0;
out highp vec4 vs_TEXCOORD1;
vec4 u_xlat0;
vec4 u_xlat1;
vec4 u_xlat2;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat1 = hlslcc_mtx4x4unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat2 = u_xlat1.yyyy * hlslcc_mtx4x4_NonJitteredVP[1];
    u_xlat2 = hlslcc_mtx4x4_NonJitteredVP[0] * u_xlat1.xxxx + u_xlat2;
    u_xlat2 = hlslcc_mtx4x4_NonJitteredVP[2] * u_xlat1.zzzz + u_xlat2;
    vs_TEXCOORD0 = hlslcc_mtx4x4_NonJitteredVP[3] * u_xlat1.wwww + u_xlat2;
    u_xlat1.xyz = in_NORMAL0.xyz;
    u_xlat1.w = 1.0;
    u_xlat1 = (_HasLastPositionData != 0) ? u_xlat1 : in_POSITION0;
    u_xlat2 = u_xlat1.yyyy * hlslcc_mtx4x4_PreviousM[1];
    u_xlat2 = hlslcc_mtx4x4_PreviousM[0] * u_xlat1.xxxx + u_xlat2;
    u_xlat2 = hlslcc_mtx4x4_PreviousM[2] * u_xlat1.zzzz + u_xlat2;
    u_xlat1 = hlslcc_mtx4x4_PreviousM[3] * u_xlat1.wwww + u_xlat2;
    u_xlat2 = u_xlat1.yyyy * hlslcc_mtx4x4_PreviousVP[1];
    u_xlat2 = hlslcc_mtx4x4_PreviousVP[0] * u_xlat1.xxxx + u_xlat2;
    u_xlat2 = hlslcc_mtx4x4_PreviousVP[2] * u_xlat1.zzzz + u_xlat2;
    vs_TEXCOORD1 = hlslcc_mtx4x4_PreviousVP[3] * u_xlat1.wwww + u_xlat2;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    gl_Position.z = _MotionVectorDepthBias * u_xlat0.w + u_xlat0.z;
    gl_Position.xyw = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	int _ForceNoMotion;
in highp vec4 vs_TEXCOORD0;
in highp vec4 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec2 u_xlat0;
mediump float u_xlat16_1;
mediump vec2 u_xlat16_3;
vec2 u_xlat4;
void main()
{
    u_xlat0.xy = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    u_xlat0.xy = u_xlat0.xy + vec2(1.0, 1.0);
    u_xlat0.xy = u_xlat0.xy * vec2(0.5, 0.5);
    u_xlat4.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat4.xy = u_xlat4.xy + vec2(1.0, 1.0);
    u_xlat0.xy = u_xlat4.xy * vec2(0.5, 0.5) + (-u_xlat0.xy);
    u_xlat16_1 = (_ForceNoMotion != 0) ? 1.0 : 0.0;
    SV_Target0.xy = vec2(u_xlat16_1) * (-u_xlat0.xy) + u_xlat0.xy;
    u_xlat16_3.x = float(-0.0);
    u_xlat16_3.y = float(-1.0);
    SV_Target0.zw = vec2(u_xlat16_1) * u_xlat16_3.xy + vec2(0.0, 1.0);
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
uniform 	vec4 hlslcc_mtx4x4_NonJitteredVP[4];
uniform 	vec4 hlslcc_mtx4x4_PreviousVP[4];
uniform 	vec4 hlslcc_mtx4x4_PreviousM[4];
uniform 	int _HasLastPositionData;
uniform 	float _MotionVectorDepthBias;
in highp vec4 in_POSITION0;
in highp vec3 in_NORMAL0;
out highp vec4 vs_TEXCOORD0;
out highp vec4 vs_TEXCOORD1;
vec4 u_xlat0;
vec4 u_xlat1;
vec4 u_xlat2;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat1 = hlslcc_mtx4x4unity_ObjectToWorld[3] * in_POSITION0.wwww + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat2 = u_xlat1.yyyy * hlslcc_mtx4x4_NonJitteredVP[1];
    u_xlat2 = hlslcc_mtx4x4_NonJitteredVP[0] * u_xlat1.xxxx + u_xlat2;
    u_xlat2 = hlslcc_mtx4x4_NonJitteredVP[2] * u_xlat1.zzzz + u_xlat2;
    vs_TEXCOORD0 = hlslcc_mtx4x4_NonJitteredVP[3] * u_xlat1.wwww + u_xlat2;
    u_xlat1.xyz = in_NORMAL0.xyz;
    u_xlat1.w = 1.0;
    u_xlat1 = (_HasLastPositionData != 0) ? u_xlat1 : in_POSITION0;
    u_xlat2 = u_xlat1.yyyy * hlslcc_mtx4x4_PreviousM[1];
    u_xlat2 = hlslcc_mtx4x4_PreviousM[0] * u_xlat1.xxxx + u_xlat2;
    u_xlat2 = hlslcc_mtx4x4_PreviousM[2] * u_xlat1.zzzz + u_xlat2;
    u_xlat1 = hlslcc_mtx4x4_PreviousM[3] * u_xlat1.wwww + u_xlat2;
    u_xlat2 = u_xlat1.yyyy * hlslcc_mtx4x4_PreviousVP[1];
    u_xlat2 = hlslcc_mtx4x4_PreviousVP[0] * u_xlat1.xxxx + u_xlat2;
    u_xlat2 = hlslcc_mtx4x4_PreviousVP[2] * u_xlat1.zzzz + u_xlat2;
    vs_TEXCOORD1 = hlslcc_mtx4x4_PreviousVP[3] * u_xlat1.wwww + u_xlat2;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    gl_Position.z = _MotionVectorDepthBias * u_xlat0.w + u_xlat0.z;
    gl_Position.xyw = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	int _ForceNoMotion;
in highp vec4 vs_TEXCOORD0;
in highp vec4 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec2 u_xlat0;
mediump float u_xlat16_1;
mediump vec2 u_xlat16_3;
vec2 u_xlat4;
void main()
{
    u_xlat0.xy = vs_TEXCOORD1.xy / vs_TEXCOORD1.ww;
    u_xlat0.xy = u_xlat0.xy + vec2(1.0, 1.0);
    u_xlat0.xy = u_xlat0.xy * vec2(0.5, 0.5);
    u_xlat4.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat4.xy = u_xlat4.xy + vec2(1.0, 1.0);
    u_xlat0.xy = u_xlat4.xy * vec2(0.5, 0.5) + (-u_xlat0.xy);
    u_xlat16_1 = (_ForceNoMotion != 0) ? 1.0 : 0.0;
    SV_Target0.xy = vec2(u_xlat16_1) * (-u_xlat0.xy) + u_xlat0.xy;
    u_xlat16_3.x = float(-0.0);
    u_xlat16_3.y = float(-1.0);
    SV_Target0.zw = vec2(u_xlat16_1) * u_xlat16_3.xy + vec2(0.0, 1.0);
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
  ZTest Always
  ZWrite Off
  Cull Off
  GpuProgramID 124246
Program "vp" {
SubProgram "gles hw_tier00 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _glesVertex.xyz;
  tmpvar_1 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_2));
  highp vec4 o_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_3.xy;
  xlv_TEXCOORD1 = _glesNormal;
}


#endif
#ifdef FRAGMENT
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 _NonJitteredVP;
uniform highp mat4 _PreviousVP;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec2 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, xlv_TEXCOORD0).x)
   + _ZBufferParams.y))));
  highp vec4 tmpvar_3;
  tmpvar_3 = (unity_CameraToWorld * tmpvar_2);
  highp vec4 tmpvar_4;
  tmpvar_4 = (_PreviousVP * tmpvar_3);
  highp vec4 tmpvar_5;
  tmpvar_5 = (_NonJitteredVP * tmpvar_3);
  highp vec2 tmpvar_6;
  tmpvar_6 = (((tmpvar_4.xy / tmpvar_4.w) + 1.0) / 2.0);
  highp vec2 tmpvar_7;
  tmpvar_7 = (((tmpvar_5.xy / tmpvar_5.w) + 1.0) / 2.0);
  tmpvar_1 = (tmpvar_7 - tmpvar_6);
  mediump vec4 tmpvar_8;
  tmpvar_8.zw = vec2(0.0, 1.0);
  tmpvar_8.xy = tmpvar_1;
  gl_FragData[0] = tmpvar_8;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _glesVertex.xyz;
  tmpvar_1 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_2));
  highp vec4 o_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_3.xy;
  xlv_TEXCOORD1 = _glesNormal;
}


#endif
#ifdef FRAGMENT
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 _NonJitteredVP;
uniform highp mat4 _PreviousVP;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec2 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, xlv_TEXCOORD0).x)
   + _ZBufferParams.y))));
  highp vec4 tmpvar_3;
  tmpvar_3 = (unity_CameraToWorld * tmpvar_2);
  highp vec4 tmpvar_4;
  tmpvar_4 = (_PreviousVP * tmpvar_3);
  highp vec4 tmpvar_5;
  tmpvar_5 = (_NonJitteredVP * tmpvar_3);
  highp vec2 tmpvar_6;
  tmpvar_6 = (((tmpvar_4.xy / tmpvar_4.w) + 1.0) / 2.0);
  highp vec2 tmpvar_7;
  tmpvar_7 = (((tmpvar_5.xy / tmpvar_5.w) + 1.0) / 2.0);
  tmpvar_1 = (tmpvar_7 - tmpvar_6);
  mediump vec4 tmpvar_8;
  tmpvar_8.zw = vec2(0.0, 1.0);
  tmpvar_8.xy = tmpvar_1;
  gl_FragData[0] = tmpvar_8;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _glesVertex.xyz;
  tmpvar_1 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_2));
  highp vec4 o_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_3.xy;
  xlv_TEXCOORD1 = _glesNormal;
}


#endif
#ifdef FRAGMENT
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 _NonJitteredVP;
uniform highp mat4 _PreviousVP;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec2 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, xlv_TEXCOORD0).x)
   + _ZBufferParams.y))));
  highp vec4 tmpvar_3;
  tmpvar_3 = (unity_CameraToWorld * tmpvar_2);
  highp vec4 tmpvar_4;
  tmpvar_4 = (_PreviousVP * tmpvar_3);
  highp vec4 tmpvar_5;
  tmpvar_5 = (_NonJitteredVP * tmpvar_3);
  highp vec2 tmpvar_6;
  tmpvar_6 = (((tmpvar_4.xy / tmpvar_4.w) + 1.0) / 2.0);
  highp vec2 tmpvar_7;
  tmpvar_7 = (((tmpvar_5.xy / tmpvar_5.w) + 1.0) / 2.0);
  tmpvar_1 = (tmpvar_7 - tmpvar_6);
  mediump vec4 tmpvar_8;
  tmpvar_8.zw = vec2(0.0, 1.0);
  tmpvar_8.xy = tmpvar_1;
  gl_FragData[0] = tmpvar_8;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec3 in_NORMAL0;
out highp vec2 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
vec4 u_xlat0;
vec4 u_xlat1;
float u_xlat2;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    gl_Position = u_xlat0;
    u_xlat2 = u_xlat0.y * _ProjectionParams.x;
    u_xlat0.xz = u_xlat0.xw * vec2(0.5, 0.5);
    u_xlat0.w = u_xlat2 * 0.5;
    vs_TEXCOORD0.xy = u_xlat0.zz + u_xlat0.xw;
    vs_TEXCOORD1.xyz = in_NORMAL0.xyz;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 hlslcc_mtx4x4_NonJitteredVP[4];
uniform 	vec4 hlslcc_mtx4x4_PreviousVP[4];
uniform highp sampler2D _CameraDepthTexture;
in highp vec2 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
vec3 u_xlat3;
void main()
{
    u_xlat0.x = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat0.x = _ZBufferParams.x * u_xlat0.x + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat3.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat3.xyz = u_xlat3.xxx * vs_TEXCOORD1.xyz;
    u_xlat0.xyz = u_xlat0.xxx * u_xlat3.xyz;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat1.xyz = u_xlat0.yyy * hlslcc_mtx4x4_PreviousVP[1].xyw;
    u_xlat1.xyz = hlslcc_mtx4x4_PreviousVP[0].xyw * u_xlat0.xxx + u_xlat1.xyz;
    u_xlat1.xyz = hlslcc_mtx4x4_PreviousVP[2].xyw * u_xlat0.zzz + u_xlat1.xyz;
    u_xlat1.xyz = hlslcc_mtx4x4_PreviousVP[3].xyw * u_xlat0.www + u_xlat1.xyz;
    u_xlat1.xy = u_xlat1.xy / u_xlat1.zz;
    u_xlat1.xy = u_xlat1.xy + vec2(1.0, 1.0);
    u_xlat1.xy = u_xlat1.xy * vec2(0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4_NonJitteredVP[1].xyw;
    u_xlat2.xyz = hlslcc_mtx4x4_NonJitteredVP[0].xyw * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4_NonJitteredVP[2].xyw * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4_NonJitteredVP[3].xyw * u_xlat0.www + u_xlat0.xyz;
    u_xlat0.xy = u_xlat0.xy / u_xlat0.zz;
    u_xlat0.xy = u_xlat0.xy + vec2(1.0, 1.0);
    u_xlat0.xy = u_xlat0.xy * vec2(0.5, 0.5) + (-u_xlat1.xy);
    SV_Target0.xy = u_xlat0.xy;
    SV_Target0.zw = vec2(0.0, 1.0);
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec3 in_NORMAL0;
out highp vec2 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
vec4 u_xlat0;
vec4 u_xlat1;
float u_xlat2;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    gl_Position = u_xlat0;
    u_xlat2 = u_xlat0.y * _ProjectionParams.x;
    u_xlat0.xz = u_xlat0.xw * vec2(0.5, 0.5);
    u_xlat0.w = u_xlat2 * 0.5;
    vs_TEXCOORD0.xy = u_xlat0.zz + u_xlat0.xw;
    vs_TEXCOORD1.xyz = in_NORMAL0.xyz;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 hlslcc_mtx4x4_NonJitteredVP[4];
uniform 	vec4 hlslcc_mtx4x4_PreviousVP[4];
uniform highp sampler2D _CameraDepthTexture;
in highp vec2 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
vec3 u_xlat3;
void main()
{
    u_xlat0.x = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat0.x = _ZBufferParams.x * u_xlat0.x + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat3.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat3.xyz = u_xlat3.xxx * vs_TEXCOORD1.xyz;
    u_xlat0.xyz = u_xlat0.xxx * u_xlat3.xyz;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat1.xyz = u_xlat0.yyy * hlslcc_mtx4x4_PreviousVP[1].xyw;
    u_xlat1.xyz = hlslcc_mtx4x4_PreviousVP[0].xyw * u_xlat0.xxx + u_xlat1.xyz;
    u_xlat1.xyz = hlslcc_mtx4x4_PreviousVP[2].xyw * u_xlat0.zzz + u_xlat1.xyz;
    u_xlat1.xyz = hlslcc_mtx4x4_PreviousVP[3].xyw * u_xlat0.www + u_xlat1.xyz;
    u_xlat1.xy = u_xlat1.xy / u_xlat1.zz;
    u_xlat1.xy = u_xlat1.xy + vec2(1.0, 1.0);
    u_xlat1.xy = u_xlat1.xy * vec2(0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4_NonJitteredVP[1].xyw;
    u_xlat2.xyz = hlslcc_mtx4x4_NonJitteredVP[0].xyw * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4_NonJitteredVP[2].xyw * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4_NonJitteredVP[3].xyw * u_xlat0.www + u_xlat0.xyz;
    u_xlat0.xy = u_xlat0.xy / u_xlat0.zz;
    u_xlat0.xy = u_xlat0.xy + vec2(1.0, 1.0);
    u_xlat0.xy = u_xlat0.xy * vec2(0.5, 0.5) + (-u_xlat1.xy);
    SV_Target0.xy = u_xlat0.xy;
    SV_Target0.zw = vec2(0.0, 1.0);
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec3 in_NORMAL0;
out highp vec2 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
vec4 u_xlat0;
vec4 u_xlat1;
float u_xlat2;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    gl_Position = u_xlat0;
    u_xlat2 = u_xlat0.y * _ProjectionParams.x;
    u_xlat0.xz = u_xlat0.xw * vec2(0.5, 0.5);
    u_xlat0.w = u_xlat2 * 0.5;
    vs_TEXCOORD0.xy = u_xlat0.zz + u_xlat0.xw;
    vs_TEXCOORD1.xyz = in_NORMAL0.xyz;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 hlslcc_mtx4x4_NonJitteredVP[4];
uniform 	vec4 hlslcc_mtx4x4_PreviousVP[4];
uniform highp sampler2D _CameraDepthTexture;
in highp vec2 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
vec3 u_xlat3;
void main()
{
    u_xlat0.x = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat0.x = _ZBufferParams.x * u_xlat0.x + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat3.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat3.xyz = u_xlat3.xxx * vs_TEXCOORD1.xyz;
    u_xlat0.xyz = u_xlat0.xxx * u_xlat3.xyz;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat1.xyz = u_xlat0.yyy * hlslcc_mtx4x4_PreviousVP[1].xyw;
    u_xlat1.xyz = hlslcc_mtx4x4_PreviousVP[0].xyw * u_xlat0.xxx + u_xlat1.xyz;
    u_xlat1.xyz = hlslcc_mtx4x4_PreviousVP[2].xyw * u_xlat0.zzz + u_xlat1.xyz;
    u_xlat1.xyz = hlslcc_mtx4x4_PreviousVP[3].xyw * u_xlat0.www + u_xlat1.xyz;
    u_xlat1.xy = u_xlat1.xy / u_xlat1.zz;
    u_xlat1.xy = u_xlat1.xy + vec2(1.0, 1.0);
    u_xlat1.xy = u_xlat1.xy * vec2(0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4_NonJitteredVP[1].xyw;
    u_xlat2.xyz = hlslcc_mtx4x4_NonJitteredVP[0].xyw * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4_NonJitteredVP[2].xyw * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4_NonJitteredVP[3].xyw * u_xlat0.www + u_xlat0.xyz;
    u_xlat0.xy = u_xlat0.xy / u_xlat0.zz;
    u_xlat0.xy = u_xlat0.xy + vec2(1.0, 1.0);
    u_xlat0.xy = u_xlat0.xy * vec2(0.5, 0.5) + (-u_xlat1.xy);
    SV_Target0.xy = u_xlat0.xy;
    SV_Target0.zw = vec2(0.0, 1.0);
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
  ZTest Always
  Cull Off
  GpuProgramID 143618
Program "vp" {
SubProgram "gles hw_tier00 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _glesVertex.xyz;
  tmpvar_1 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_2));
  highp vec4 o_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_3.xy;
  xlv_TEXCOORD1 = _glesNormal;
}


#endif
#ifdef FRAGMENT
#extension GL_EXT_frag_depth : enable
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 _NonJitteredVP;
uniform highp mat4 _PreviousVP;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_CameraDepthTexture, xlv_TEXCOORD0);
  mediump vec2 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_1.x)
   + _ZBufferParams.y))));
  highp vec4 tmpvar_4;
  tmpvar_4 = (unity_CameraToWorld * tmpvar_3);
  highp vec4 tmpvar_5;
  tmpvar_5 = (_PreviousVP * tmpvar_4);
  highp vec4 tmpvar_6;
  tmpvar_6 = (_NonJitteredVP * tmpvar_4);
  highp vec2 tmpvar_7;
  tmpvar_7 = (((tmpvar_5.xy / tmpvar_5.w) + 1.0) / 2.0);
  highp vec2 tmpvar_8;
  tmpvar_8 = (((tmpvar_6.xy / tmpvar_6.w) + 1.0) / 2.0);
  tmpvar_2 = (tmpvar_8 - tmpvar_7);
  mediump vec4 tmpvar_9;
  tmpvar_9.zw = vec2(0.0, 1.0);
  tmpvar_9.xy = tmpvar_2;
  gl_FragDepthEXT = tmpvar_1.x;
  gl_FragData[0] = tmpvar_9;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _glesVertex.xyz;
  tmpvar_1 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_2));
  highp vec4 o_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_3.xy;
  xlv_TEXCOORD1 = _glesNormal;
}


#endif
#ifdef FRAGMENT
#extension GL_EXT_frag_depth : enable
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 _NonJitteredVP;
uniform highp mat4 _PreviousVP;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_CameraDepthTexture, xlv_TEXCOORD0);
  mediump vec2 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_1.x)
   + _ZBufferParams.y))));
  highp vec4 tmpvar_4;
  tmpvar_4 = (unity_CameraToWorld * tmpvar_3);
  highp vec4 tmpvar_5;
  tmpvar_5 = (_PreviousVP * tmpvar_4);
  highp vec4 tmpvar_6;
  tmpvar_6 = (_NonJitteredVP * tmpvar_4);
  highp vec2 tmpvar_7;
  tmpvar_7 = (((tmpvar_5.xy / tmpvar_5.w) + 1.0) / 2.0);
  highp vec2 tmpvar_8;
  tmpvar_8 = (((tmpvar_6.xy / tmpvar_6.w) + 1.0) / 2.0);
  tmpvar_2 = (tmpvar_8 - tmpvar_7);
  mediump vec4 tmpvar_9;
  tmpvar_9.zw = vec2(0.0, 1.0);
  tmpvar_9.xy = tmpvar_2;
  gl_FragDepthEXT = tmpvar_1.x;
  gl_FragData[0] = tmpvar_9;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _glesVertex.xyz;
  tmpvar_1 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_2));
  highp vec4 o_3;
  highp vec4 tmpvar_4;
  tmpvar_4 = (tmpvar_1 * 0.5);
  highp vec2 tmpvar_5;
  tmpvar_5.x = tmpvar_4.x;
  tmpvar_5.y = (tmpvar_4.y * _ProjectionParams.x);
  o_3.xy = (tmpvar_5 + tmpvar_4.w);
  o_3.zw = tmpvar_1.zw;
  gl_Position = tmpvar_1;
  xlv_TEXCOORD0 = o_3.xy;
  xlv_TEXCOORD1 = _glesNormal;
}


#endif
#ifdef FRAGMENT
#extension GL_EXT_frag_depth : enable
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 _NonJitteredVP;
uniform highp mat4 _PreviousVP;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = texture2D (_CameraDepthTexture, xlv_TEXCOORD0);
  mediump vec2 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * tmpvar_1.x)
   + _ZBufferParams.y))));
  highp vec4 tmpvar_4;
  tmpvar_4 = (unity_CameraToWorld * tmpvar_3);
  highp vec4 tmpvar_5;
  tmpvar_5 = (_PreviousVP * tmpvar_4);
  highp vec4 tmpvar_6;
  tmpvar_6 = (_NonJitteredVP * tmpvar_4);
  highp vec2 tmpvar_7;
  tmpvar_7 = (((tmpvar_5.xy / tmpvar_5.w) + 1.0) / 2.0);
  highp vec2 tmpvar_8;
  tmpvar_8 = (((tmpvar_6.xy / tmpvar_6.w) + 1.0) / 2.0);
  tmpvar_2 = (tmpvar_8 - tmpvar_7);
  mediump vec4 tmpvar_9;
  tmpvar_9.zw = vec2(0.0, 1.0);
  tmpvar_9.xy = tmpvar_2;
  gl_FragDepthEXT = tmpvar_1.x;
  gl_FragData[0] = tmpvar_9;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec3 in_NORMAL0;
out highp vec2 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
vec4 u_xlat0;
vec4 u_xlat1;
float u_xlat2;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    gl_Position = u_xlat0;
    u_xlat2 = u_xlat0.y * _ProjectionParams.x;
    u_xlat0.xz = u_xlat0.xw * vec2(0.5, 0.5);
    u_xlat0.w = u_xlat2 * 0.5;
    vs_TEXCOORD0.xy = u_xlat0.zz + u_xlat0.xw;
    vs_TEXCOORD1.xyz = in_NORMAL0.xyz;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 hlslcc_mtx4x4_NonJitteredVP[4];
uniform 	vec4 hlslcc_mtx4x4_PreviousVP[4];
uniform highp sampler2D _CameraDepthTexture;
in highp vec2 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
float u_xlat9;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat9 = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat1.x = _ZBufferParams.x * u_xlat9 + _ZBufferParams.y;
    gl_FragDepth = u_xlat9;
    u_xlat9 = float(1.0) / u_xlat1.x;
    u_xlat0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat1.xyz = u_xlat0.yyy * hlslcc_mtx4x4_PreviousVP[1].xyw;
    u_xlat1.xyz = hlslcc_mtx4x4_PreviousVP[0].xyw * u_xlat0.xxx + u_xlat1.xyz;
    u_xlat1.xyz = hlslcc_mtx4x4_PreviousVP[2].xyw * u_xlat0.zzz + u_xlat1.xyz;
    u_xlat1.xyz = hlslcc_mtx4x4_PreviousVP[3].xyw * u_xlat0.www + u_xlat1.xyz;
    u_xlat1.xy = u_xlat1.xy / u_xlat1.zz;
    u_xlat1.xy = u_xlat1.xy + vec2(1.0, 1.0);
    u_xlat1.xy = u_xlat1.xy * vec2(0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4_NonJitteredVP[1].xyw;
    u_xlat2.xyz = hlslcc_mtx4x4_NonJitteredVP[0].xyw * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4_NonJitteredVP[2].xyw * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4_NonJitteredVP[3].xyw * u_xlat0.www + u_xlat0.xyz;
    u_xlat0.xy = u_xlat0.xy / u_xlat0.zz;
    u_xlat0.xy = u_xlat0.xy + vec2(1.0, 1.0);
    u_xlat0.xy = u_xlat0.xy * vec2(0.5, 0.5) + (-u_xlat1.xy);
    SV_Target0.xy = u_xlat0.xy;
    SV_Target0.zw = vec2(0.0, 1.0);
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec3 in_NORMAL0;
out highp vec2 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
vec4 u_xlat0;
vec4 u_xlat1;
float u_xlat2;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    gl_Position = u_xlat0;
    u_xlat2 = u_xlat0.y * _ProjectionParams.x;
    u_xlat0.xz = u_xlat0.xw * vec2(0.5, 0.5);
    u_xlat0.w = u_xlat2 * 0.5;
    vs_TEXCOORD0.xy = u_xlat0.zz + u_xlat0.xw;
    vs_TEXCOORD1.xyz = in_NORMAL0.xyz;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 hlslcc_mtx4x4_NonJitteredVP[4];
uniform 	vec4 hlslcc_mtx4x4_PreviousVP[4];
uniform highp sampler2D _CameraDepthTexture;
in highp vec2 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
float u_xlat9;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat9 = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat1.x = _ZBufferParams.x * u_xlat9 + _ZBufferParams.y;
    gl_FragDepth = u_xlat9;
    u_xlat9 = float(1.0) / u_xlat1.x;
    u_xlat0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat1.xyz = u_xlat0.yyy * hlslcc_mtx4x4_PreviousVP[1].xyw;
    u_xlat1.xyz = hlslcc_mtx4x4_PreviousVP[0].xyw * u_xlat0.xxx + u_xlat1.xyz;
    u_xlat1.xyz = hlslcc_mtx4x4_PreviousVP[2].xyw * u_xlat0.zzz + u_xlat1.xyz;
    u_xlat1.xyz = hlslcc_mtx4x4_PreviousVP[3].xyw * u_xlat0.www + u_xlat1.xyz;
    u_xlat1.xy = u_xlat1.xy / u_xlat1.zz;
    u_xlat1.xy = u_xlat1.xy + vec2(1.0, 1.0);
    u_xlat1.xy = u_xlat1.xy * vec2(0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4_NonJitteredVP[1].xyw;
    u_xlat2.xyz = hlslcc_mtx4x4_NonJitteredVP[0].xyw * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4_NonJitteredVP[2].xyw * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4_NonJitteredVP[3].xyw * u_xlat0.www + u_xlat0.xyz;
    u_xlat0.xy = u_xlat0.xy / u_xlat0.zz;
    u_xlat0.xy = u_xlat0.xy + vec2(1.0, 1.0);
    u_xlat0.xy = u_xlat0.xy * vec2(0.5, 0.5) + (-u_xlat1.xy);
    SV_Target0.xy = u_xlat0.xy;
    SV_Target0.zw = vec2(0.0, 1.0);
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec3 in_NORMAL0;
out highp vec2 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
vec4 u_xlat0;
vec4 u_xlat1;
float u_xlat2;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    gl_Position = u_xlat0;
    u_xlat2 = u_xlat0.y * _ProjectionParams.x;
    u_xlat0.xz = u_xlat0.xw * vec2(0.5, 0.5);
    u_xlat0.w = u_xlat2 * 0.5;
    vs_TEXCOORD0.xy = u_xlat0.zz + u_xlat0.xw;
    vs_TEXCOORD1.xyz = in_NORMAL0.xyz;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 hlslcc_mtx4x4_NonJitteredVP[4];
uniform 	vec4 hlslcc_mtx4x4_PreviousVP[4];
uniform highp sampler2D _CameraDepthTexture;
in highp vec2 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
float u_xlat9;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat9 = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat1.x = _ZBufferParams.x * u_xlat9 + _ZBufferParams.y;
    gl_FragDepth = u_xlat9;
    u_xlat9 = float(1.0) / u_xlat1.x;
    u_xlat0.xyz = vec3(u_xlat9) * u_xlat0.xyz;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat1.xyz = u_xlat0.yyy * hlslcc_mtx4x4_PreviousVP[1].xyw;
    u_xlat1.xyz = hlslcc_mtx4x4_PreviousVP[0].xyw * u_xlat0.xxx + u_xlat1.xyz;
    u_xlat1.xyz = hlslcc_mtx4x4_PreviousVP[2].xyw * u_xlat0.zzz + u_xlat1.xyz;
    u_xlat1.xyz = hlslcc_mtx4x4_PreviousVP[3].xyw * u_xlat0.www + u_xlat1.xyz;
    u_xlat1.xy = u_xlat1.xy / u_xlat1.zz;
    u_xlat1.xy = u_xlat1.xy + vec2(1.0, 1.0);
    u_xlat1.xy = u_xlat1.xy * vec2(0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4_NonJitteredVP[1].xyw;
    u_xlat2.xyz = hlslcc_mtx4x4_NonJitteredVP[0].xyw * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4_NonJitteredVP[2].xyw * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4_NonJitteredVP[3].xyw * u_xlat0.www + u_xlat0.xyz;
    u_xlat0.xy = u_xlat0.xy / u_xlat0.zz;
    u_xlat0.xy = u_xlat0.xy + vec2(1.0, 1.0);
    u_xlat0.xy = u_xlat0.xy * vec2(0.5, 0.5) + (-u_xlat1.xy);
    SV_Target0.xy = u_xlat0.xy;
    SV_Target0.zw = vec2(0.0, 1.0);
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