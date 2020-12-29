//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Hidden/Internal-DeferredReflections" {
Properties {
_SrcBlend ("", Float) = 1
_DstBlend ("", Float) = 1
}
SubShader {
 Pass {
  ZWrite Off
  GpuProgramID 25932
Program "vp" {
SubProgram "gles " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec3 _glesNormal;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
#extension GL_EXT_shader_texture_lod : enable
lowp vec4 impl_low_textureCubeLodEXT(lowp samplerCube sampler, highp vec3 coord, mediump float lod)
{
#if defined(GL_EXT_shader_texture_lod)
	return textureCubeLodEXT(sampler, coord, lod);
#else
	return textureCube(sampler, coord, lod);
#endif
}

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform lowp samplerCube unity_SpecCube0;
uniform highp vec4 unity_SpecCube0_BoxMax;
uniform highp vec4 unity_SpecCube0_BoxMin;
uniform mediump vec4 unity_SpecCube0_HDR;
uniform highp vec4 unity_SpecCube1_ProbePosition;
uniform highp sampler2D _CameraDepthTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec3 tmpvar_1;
  highp vec4 tmpvar_2;
  mediump vec4 gbuffer2_3;
  mediump vec4 gbuffer1_4;
  mediump vec4 gbuffer0_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_6).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_8;
  tmpvar_8 = (unity_CameraToWorld * tmpvar_7).xyz;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraGBufferTexture0, tmpvar_6);
  gbuffer0_5 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_CameraGBufferTexture1, tmpvar_6);
  gbuffer1_4 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_CameraGBufferTexture2, tmpvar_6);
  gbuffer2_3 = tmpvar_11;
  mediump vec3 tmpvar_12;
  tmpvar_12 = normalize(((gbuffer2_3.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize((tmpvar_8 - _WorldSpaceCameraPos));
  tmpvar_1 = -(tmpvar_13);
  tmpvar_2 = unity_SpecCube0_HDR;
  mediump float tmpvar_14;
  tmpvar_14 = (1.0 - gbuffer1_4.w);
  mediump vec3 I_15;
  I_15 = -(tmpvar_1);
  mediump vec4 hdr_16;
  hdr_16 = tmpvar_2;
  mediump vec4 tmpvar_17;
  tmpvar_17.xyz = (I_15 - (2.0 * (
    dot (tmpvar_12, I_15)
   * tmpvar_12)));
  tmpvar_17.w = ((tmpvar_14 * (1.7 - 
    (0.7 * tmpvar_14)
  )) * 6.0);
  lowp vec4 tmpvar_18;
  tmpvar_18 = impl_low_textureCubeLodEXT (unity_SpecCube0, tmpvar_17.xyz, tmpvar_17.w);
  mediump vec4 tmpvar_19;
  tmpvar_19 = tmpvar_18;
  mediump vec3 viewDir_20;
  viewDir_20 = -(tmpvar_13);
  mediump vec2 tmpvar_21;
  tmpvar_21.x = (viewDir_20 - (2.0 * (
    dot (tmpvar_12, viewDir_20)
   * tmpvar_12))).y;
  tmpvar_21.y = (1.0 - clamp (dot (tmpvar_12, viewDir_20), 0.0, 1.0));
  mediump vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = (((
    (hdr_16.x * ((hdr_16.w * (tmpvar_19.w - 1.0)) + 1.0))
   * tmpvar_19.xyz) * gbuffer0_5.w) * mix (gbuffer1_4.xyz, vec3(clamp (
    (gbuffer1_4.w + (1.0 - (1.0 - max (
      max (gbuffer1_4.x, gbuffer1_4.y)
    , gbuffer1_4.z))))
  , 0.0, 1.0)), (
    (tmpvar_21 * tmpvar_21)
   * 
    (tmpvar_21 * tmpvar_21)
  ).yyy));
  mediump vec3 p_23;
  p_23 = tmpvar_8;
  mediump vec3 aabbMin_24;
  aabbMin_24 = unity_SpecCube0_BoxMin.xyz;
  mediump vec3 aabbMax_25;
  aabbMax_25 = unity_SpecCube0_BoxMax.xyz;
  mediump vec3 tmpvar_26;
  tmpvar_26 = max (max ((p_23 - aabbMax_25), (aabbMin_24 - p_23)), vec3(0.0, 0.0, 0.0));
  mediump float tmpvar_27;
  tmpvar_27 = sqrt(dot (tmpvar_26, tmpvar_26));
  mediump float tmpvar_28;
  highp float tmpvar_29;
  tmpvar_29 = clamp ((1.0 - (tmpvar_27 / unity_SpecCube1_ProbePosition.w)), 0.0, 1.0);
  tmpvar_28 = tmpvar_29;
  mediump vec4 tmpvar_30;
  tmpvar_30.xyz = tmpvar_22.xyz;
  tmpvar_30.w = tmpvar_28;
  gl_FragData[0] = tmpvar_30;
}


#endif
"
}
SubProgram "gles3 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixV[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	float _LightAsQuad;
in highp vec4 in_POSITION0;
in highp vec3 in_NORMAL0;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
vec4 u_xlat0;
vec4 u_xlat1;
vec4 u_xlat2;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    gl_Position = u_xlat1;
    u_xlat1.y = u_xlat1.y * _ProjectionParams.x;
    u_xlat2.xzw = u_xlat1.xwy * vec3(0.5, 0.5, 0.5);
    vs_TEXCOORD0.zw = u_xlat1.zw;
    vs_TEXCOORD0.xy = u_xlat2.zz + u_xlat2.xw;
    u_xlat1.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_MatrixV[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_MatrixV[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_MatrixV[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_MatrixV[3].xyz * u_xlat0.www + u_xlat0.xyz;
    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + in_NORMAL0.xyz;
    vs_TEXCOORD1.xyz = vec3(_LightAsQuad) * u_xlat0.xyz + u_xlat1.xyz;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 unity_SpecCube0_BoxMax;
uniform 	vec4 unity_SpecCube0_BoxMin;
uniform 	mediump vec4 unity_SpecCube0_HDR;
uniform 	vec4 unity_SpecCube1_ProbePosition;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp samplerCube unity_SpecCube0;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec2 u_xlat1;
lowp vec4 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_3;
mediump vec3 u_xlat16_4;
mediump vec3 u_xlat16_5;
float u_xlat18;
lowp float u_xlat10_18;
mediump float u_xlat16_22;
mediump float u_xlat16_23;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat18 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat18 = _ZBufferParams.x * u_xlat18 + _ZBufferParams.y;
    u_xlat18 = float(1.0) / u_xlat18;
    u_xlat0.xyz = vec3(u_xlat18) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat18 = inversesqrt(u_xlat18);
    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
    u_xlat10_3.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_4.xyz = u_xlat10_3.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat16_22 = dot(u_xlat16_4.xyz, (-u_xlat2.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_22 = min(max(u_xlat16_22, 0.0), 1.0);
#else
    u_xlat16_22 = clamp(u_xlat16_22, 0.0, 1.0);
#endif
    u_xlat16_22 = (-u_xlat16_22) + 1.0;
    u_xlat16_22 = u_xlat16_22 * u_xlat16_22;
    u_xlat16_22 = u_xlat16_22 * u_xlat16_22;
    u_xlat10_3 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_18 = texture(_CameraGBufferTexture0, u_xlat1.xy).w;
    u_xlat16_5.x = max(u_xlat10_3.y, u_xlat10_3.x);
    u_xlat16_5.x = max(u_xlat10_3.z, u_xlat16_5.x);
    u_xlat16_5.x = (-u_xlat16_5.x) + 1.0;
    u_xlat16_5.x = (-u_xlat16_5.x) + 1.0;
    u_xlat16_5.x = u_xlat10_3.w + u_xlat16_5.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat16_5.xyz = (-u_xlat10_3.xyz) + u_xlat16_5.xxx;
    u_xlat16_5.xyz = vec3(u_xlat16_22) * u_xlat16_5.xyz + u_xlat10_3.xyz;
    u_xlat16_22 = (-u_xlat10_3.w) + 1.0;
    u_xlat16_23 = (-u_xlat16_22) * 0.699999988 + 1.70000005;
    u_xlat16_22 = u_xlat16_22 * u_xlat16_23;
    u_xlat16_22 = u_xlat16_22 * 6.0;
    u_xlat16_23 = dot(u_xlat2.xyz, u_xlat16_4.xyz);
    u_xlat16_23 = u_xlat16_23 + u_xlat16_23;
    u_xlat16_4.xyz = u_xlat16_4.xyz * (-vec3(u_xlat16_23)) + u_xlat2.xyz;
    u_xlat10_1 = textureLod(unity_SpecCube0, u_xlat16_4.xyz, u_xlat16_22);
    u_xlat16_4.x = u_xlat10_1.w + -1.0;
    u_xlat16_4.x = unity_SpecCube0_HDR.w * u_xlat16_4.x + 1.0;
    u_xlat16_4.x = u_xlat16_4.x * unity_SpecCube0_HDR.x;
    u_xlat16_4.xyz = u_xlat10_1.xyz * u_xlat16_4.xxx;
    u_xlat16_4.xyz = vec3(u_xlat10_18) * u_xlat16_4.xyz;
    SV_Target0.xyz = u_xlat16_5.xyz * u_xlat16_4.xyz;
    u_xlat16_4.xyz = u_xlat0.xyz + (-unity_SpecCube0_BoxMax.xyz);
    u_xlat16_5.xyz = (-u_xlat0.xyz) + unity_SpecCube0_BoxMin.xyz;
    u_xlat16_4.xyz = max(u_xlat16_4.xyz, u_xlat16_5.xyz);
    u_xlat16_4.xyz = max(u_xlat16_4.xyz, vec3(0.0, 0.0, 0.0));
    u_xlat16_4.x = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = sqrt(u_xlat16_4.x);
    u_xlat0.x = u_xlat16_4.x / unity_SpecCube1_ProbePosition.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    SV_Target0.w = u_xlat0.x;
    return;
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
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
#extension GL_EXT_shader_texture_lod : enable
lowp vec4 impl_low_textureCubeLodEXT(lowp samplerCube sampler, highp vec3 coord, mediump float lod)
{
#if defined(GL_EXT_shader_texture_lod)
	return textureCubeLodEXT(sampler, coord, lod);
#else
	return textureCube(sampler, coord, lod);
#endif
}

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform lowp samplerCube unity_SpecCube0;
uniform highp vec4 unity_SpecCube0_BoxMax;
uniform highp vec4 unity_SpecCube0_BoxMin;
uniform mediump vec4 unity_SpecCube0_HDR;
uniform highp vec4 unity_SpecCube1_ProbePosition;
uniform highp sampler2D _CameraDepthTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec3 tmpvar_1;
  highp vec4 tmpvar_2;
  mediump vec4 gbuffer2_3;
  mediump vec4 gbuffer1_4;
  mediump vec4 gbuffer0_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_6).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_8;
  tmpvar_8 = (unity_CameraToWorld * tmpvar_7).xyz;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraGBufferTexture0, tmpvar_6);
  gbuffer0_5 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_CameraGBufferTexture1, tmpvar_6);
  gbuffer1_4 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_CameraGBufferTexture2, tmpvar_6);
  gbuffer2_3 = tmpvar_11;
  mediump vec3 tmpvar_12;
  tmpvar_12 = normalize(((gbuffer2_3.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize((tmpvar_8 - _WorldSpaceCameraPos));
  tmpvar_1 = -(tmpvar_13);
  tmpvar_2 = unity_SpecCube0_HDR;
  mediump float tmpvar_14;
  tmpvar_14 = (1.0 - gbuffer1_4.w);
  mediump vec3 I_15;
  I_15 = -(tmpvar_1);
  mediump vec4 hdr_16;
  hdr_16 = tmpvar_2;
  mediump vec4 tmpvar_17;
  tmpvar_17.xyz = (I_15 - (2.0 * (
    dot (tmpvar_12, I_15)
   * tmpvar_12)));
  tmpvar_17.w = ((tmpvar_14 * (1.7 - 
    (0.7 * tmpvar_14)
  )) * 6.0);
  lowp vec4 tmpvar_18;
  tmpvar_18 = impl_low_textureCubeLodEXT (unity_SpecCube0, tmpvar_17.xyz, tmpvar_17.w);
  mediump vec4 tmpvar_19;
  tmpvar_19 = tmpvar_18;
  mediump vec3 viewDir_20;
  viewDir_20 = -(tmpvar_13);
  mediump float tmpvar_21;
  tmpvar_21 = (1.0 - gbuffer1_4.w);
  mediump float x_22;
  x_22 = (1.0 - clamp (dot (tmpvar_12, viewDir_20), 0.0, 1.0));
  mediump vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = (((1.0 - 
    ((tmpvar_21 * tmpvar_21) * (tmpvar_21 * 0.28))
  ) * (
    ((hdr_16.x * ((hdr_16.w * 
      (tmpvar_19.w - 1.0)
    ) + 1.0)) * tmpvar_19.xyz)
   * gbuffer0_5.w)) * mix (gbuffer1_4.xyz, vec3(clamp (
    (gbuffer1_4.w + (1.0 - (1.0 - max (
      max (gbuffer1_4.x, gbuffer1_4.y)
    , gbuffer1_4.z))))
  , 0.0, 1.0)), vec3((
    (x_22 * x_22)
   * 
    (x_22 * x_22)
  ))));
  mediump vec3 p_24;
  p_24 = tmpvar_8;
  mediump vec3 aabbMin_25;
  aabbMin_25 = unity_SpecCube0_BoxMin.xyz;
  mediump vec3 aabbMax_26;
  aabbMax_26 = unity_SpecCube0_BoxMax.xyz;
  mediump vec3 tmpvar_27;
  tmpvar_27 = max (max ((p_24 - aabbMax_26), (aabbMin_25 - p_24)), vec3(0.0, 0.0, 0.0));
  mediump float tmpvar_28;
  tmpvar_28 = sqrt(dot (tmpvar_27, tmpvar_27));
  mediump float tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = clamp ((1.0 - (tmpvar_28 / unity_SpecCube1_ProbePosition.w)), 0.0, 1.0);
  tmpvar_29 = tmpvar_30;
  mediump vec4 tmpvar_31;
  tmpvar_31.xyz = tmpvar_23.xyz;
  tmpvar_31.w = tmpvar_29;
  gl_FragData[0] = tmpvar_31;
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
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp float _LightAsQuad;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_1.xyz;
  tmpvar_3 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_4));
  highp vec4 o_5;
  highp vec4 tmpvar_6;
  tmpvar_6 = (tmpvar_3 * 0.5);
  highp vec2 tmpvar_7;
  tmpvar_7.x = tmpvar_6.x;
  tmpvar_7.y = (tmpvar_6.y * _ProjectionParams.x);
  o_5.xy = (tmpvar_7 + tmpvar_6.w);
  o_5.zw = tmpvar_3.zw;
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = tmpvar_1.xyz;
  tmpvar_2 = ((unity_MatrixV * (unity_ObjectToWorld * tmpvar_8)).xyz * vec3(-1.0, -1.0, 1.0));
  highp vec3 tmpvar_9;
  tmpvar_9 = mix (tmpvar_2, _glesNormal, vec3(_LightAsQuad));
  tmpvar_2 = tmpvar_9;
  gl_Position = tmpvar_3;
  xlv_TEXCOORD0 = o_5;
  xlv_TEXCOORD1 = tmpvar_9;
}


#endif
#ifdef FRAGMENT
#extension GL_EXT_shader_texture_lod : enable
lowp vec4 impl_low_textureCubeLodEXT(lowp samplerCube sampler, highp vec3 coord, mediump float lod)
{
#if defined(GL_EXT_shader_texture_lod)
	return textureCubeLodEXT(sampler, coord, lod);
#else
	return textureCube(sampler, coord, lod);
#endif
}

uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform lowp samplerCube unity_SpecCube0;
uniform highp vec4 unity_SpecCube0_BoxMax;
uniform highp vec4 unity_SpecCube0_BoxMin;
uniform mediump vec4 unity_SpecCube0_HDR;
uniform highp vec4 unity_SpecCube1_ProbePosition;
uniform highp sampler2D _CameraDepthTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec3 tmpvar_1;
  highp vec4 tmpvar_2;
  mediump vec4 gbuffer2_3;
  mediump vec4 gbuffer1_4;
  mediump vec4 gbuffer0_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_6).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_8;
  tmpvar_8 = (unity_CameraToWorld * tmpvar_7).xyz;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraGBufferTexture0, tmpvar_6);
  gbuffer0_5 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_CameraGBufferTexture1, tmpvar_6);
  gbuffer1_4 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_CameraGBufferTexture2, tmpvar_6);
  gbuffer2_3 = tmpvar_11;
  mediump vec3 tmpvar_12;
  tmpvar_12 = normalize(((gbuffer2_3.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize((tmpvar_8 - _WorldSpaceCameraPos));
  tmpvar_1 = -(tmpvar_13);
  tmpvar_2 = unity_SpecCube0_HDR;
  mediump float tmpvar_14;
  tmpvar_14 = (1.0 - gbuffer1_4.w);
  mediump vec3 I_15;
  I_15 = -(tmpvar_1);
  mediump vec4 hdr_16;
  hdr_16 = tmpvar_2;
  mediump vec4 tmpvar_17;
  tmpvar_17.xyz = (I_15 - (2.0 * (
    dot (tmpvar_12, I_15)
   * tmpvar_12)));
  tmpvar_17.w = ((tmpvar_14 * (1.7 - 
    (0.7 * tmpvar_14)
  )) * 6.0);
  lowp vec4 tmpvar_18;
  tmpvar_18 = impl_low_textureCubeLodEXT (unity_SpecCube0, tmpvar_17.xyz, tmpvar_17.w);
  mediump vec4 tmpvar_19;
  tmpvar_19 = tmpvar_18;
  mediump vec3 viewDir_20;
  viewDir_20 = -(tmpvar_13);
  mediump float tmpvar_21;
  tmpvar_21 = (1.0 - gbuffer1_4.w);
  mediump float x_22;
  x_22 = (1.0 - clamp (dot (tmpvar_12, viewDir_20), 0.0, 1.0));
  mediump vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = (((1.0 - 
    ((tmpvar_21 * tmpvar_21) * (tmpvar_21 * 0.28))
  ) * (
    ((hdr_16.x * ((hdr_16.w * 
      (tmpvar_19.w - 1.0)
    ) + 1.0)) * tmpvar_19.xyz)
   * gbuffer0_5.w)) * mix (gbuffer1_4.xyz, vec3(clamp (
    (gbuffer1_4.w + (1.0 - (1.0 - max (
      max (gbuffer1_4.x, gbuffer1_4.y)
    , gbuffer1_4.z))))
  , 0.0, 1.0)), vec3((
    (x_22 * x_22)
   * 
    (x_22 * x_22)
  ))));
  mediump vec3 p_24;
  p_24 = tmpvar_8;
  mediump vec3 aabbMin_25;
  aabbMin_25 = unity_SpecCube0_BoxMin.xyz;
  mediump vec3 aabbMax_26;
  aabbMax_26 = unity_SpecCube0_BoxMax.xyz;
  mediump vec3 tmpvar_27;
  tmpvar_27 = max (max ((p_24 - aabbMax_26), (aabbMin_25 - p_24)), vec3(0.0, 0.0, 0.0));
  mediump float tmpvar_28;
  tmpvar_28 = sqrt(dot (tmpvar_27, tmpvar_27));
  mediump float tmpvar_29;
  highp float tmpvar_30;
  tmpvar_30 = clamp ((1.0 - (tmpvar_28 / unity_SpecCube1_ProbePosition.w)), 0.0, 1.0);
  tmpvar_29 = tmpvar_30;
  mediump vec4 tmpvar_31;
  tmpvar_31.xyz = tmpvar_23.xyz;
  tmpvar_31.w = tmpvar_29;
  gl_FragData[0] = tmpvar_31;
}


#endif
"
}
SubProgram "gles3 hw_tier01 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixV[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	float _LightAsQuad;
in highp vec4 in_POSITION0;
in highp vec3 in_NORMAL0;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
vec4 u_xlat0;
vec4 u_xlat1;
vec4 u_xlat2;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    gl_Position = u_xlat1;
    u_xlat1.y = u_xlat1.y * _ProjectionParams.x;
    u_xlat2.xzw = u_xlat1.xwy * vec3(0.5, 0.5, 0.5);
    vs_TEXCOORD0.zw = u_xlat1.zw;
    vs_TEXCOORD0.xy = u_xlat2.zz + u_xlat2.xw;
    u_xlat1.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_MatrixV[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_MatrixV[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_MatrixV[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_MatrixV[3].xyz * u_xlat0.www + u_xlat0.xyz;
    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + in_NORMAL0.xyz;
    vs_TEXCOORD1.xyz = vec3(_LightAsQuad) * u_xlat0.xyz + u_xlat1.xyz;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 unity_SpecCube0_BoxMax;
uniform 	vec4 unity_SpecCube0_BoxMin;
uniform 	mediump vec4 unity_SpecCube0_HDR;
uniform 	vec4 unity_SpecCube1_ProbePosition;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp samplerCube unity_SpecCube0;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec2 u_xlat1;
lowp vec4 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
lowp vec3 u_xlat10_3;
mediump vec3 u_xlat16_4;
mediump vec3 u_xlat16_5;
mediump vec3 u_xlat16_10;
mediump float u_xlat16_16;
float u_xlat18;
lowp float u_xlat10_18;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat18 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat18 = _ZBufferParams.x * u_xlat18 + _ZBufferParams.y;
    u_xlat18 = float(1.0) / u_xlat18;
    u_xlat0.xyz = vec3(u_xlat18) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat18 = inversesqrt(u_xlat18);
    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
    u_xlat10_3.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_4.xyz = u_xlat10_3.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat16_22 = dot(u_xlat2.xyz, u_xlat16_4.xyz);
    u_xlat16_22 = u_xlat16_22 + u_xlat16_22;
    u_xlat16_5.xyz = u_xlat16_4.xyz * (-vec3(u_xlat16_22)) + u_xlat2.xyz;
    u_xlat16_4.x = dot(u_xlat16_4.xyz, (-u_xlat2.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_4.x = (-u_xlat16_4.x) + 1.0;
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_4.x;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_18 = texture(_CameraGBufferTexture0, u_xlat1.xy).w;
    u_xlat16_4.y = (-u_xlat10_2.w) + 1.0;
    u_xlat16_4.z = (-u_xlat16_4.y) * 0.699999988 + 1.70000005;
    u_xlat16_4.xz = u_xlat16_4.xz * u_xlat16_4.xy;
    u_xlat16_16 = u_xlat16_4.z * 6.0;
    u_xlat10_1 = textureLod(unity_SpecCube0, u_xlat16_5.xyz, u_xlat16_16);
    u_xlat16_16 = u_xlat10_1.w + -1.0;
    u_xlat16_16 = unity_SpecCube0_HDR.w * u_xlat16_16 + 1.0;
    u_xlat16_16 = u_xlat16_16 * unity_SpecCube0_HDR.x;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(u_xlat16_16);
    u_xlat16_5.xyz = vec3(u_xlat10_18) * u_xlat16_5.xyz;
    u_xlat16_16 = u_xlat16_4.y * u_xlat16_4.y;
    u_xlat16_10.x = u_xlat16_4.y * u_xlat16_16;
    u_xlat16_10.x = (-u_xlat16_10.x) * 0.280000001 + 1.0;
    u_xlat16_10.xyz = u_xlat16_5.xyz * u_xlat16_10.xxx;
    u_xlat16_5.x = max(u_xlat10_2.y, u_xlat10_2.x);
    u_xlat16_5.x = max(u_xlat10_2.z, u_xlat16_5.x);
    u_xlat16_5.x = (-u_xlat16_5.x) + 1.0;
    u_xlat16_5.x = (-u_xlat16_5.x) + 1.0;
    u_xlat16_5.x = u_xlat10_2.w + u_xlat16_5.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat16_5.xyz = (-u_xlat10_2.xyz) + u_xlat16_5.xxx;
    u_xlat16_5.xyz = u_xlat16_4.xxx * u_xlat16_5.xyz + u_xlat10_2.xyz;
    SV_Target0.xyz = u_xlat16_10.xyz * u_xlat16_5.xyz;
    u_xlat16_4.xyz = u_xlat0.xyz + (-unity_SpecCube0_BoxMax.xyz);
    u_xlat16_5.xyz = (-u_xlat0.xyz) + unity_SpecCube0_BoxMin.xyz;
    u_xlat16_4.xyz = max(u_xlat16_4.xyz, u_xlat16_5.xyz);
    u_xlat16_4.xyz = max(u_xlat16_4.xyz, vec3(0.0, 0.0, 0.0));
    u_xlat16_4.x = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = sqrt(u_xlat16_4.x);
    u_xlat0.x = u_xlat16_4.x / unity_SpecCube1_ProbePosition.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    SV_Target0.w = u_xlat0.x;
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
uniform 	vec4 hlslcc_mtx4x4unity_MatrixV[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	float _LightAsQuad;
in highp vec4 in_POSITION0;
in highp vec3 in_NORMAL0;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
vec4 u_xlat0;
vec4 u_xlat1;
vec4 u_xlat2;
void main()
{
    u_xlat0 = in_POSITION0.yyyy * hlslcc_mtx4x4unity_ObjectToWorld[1];
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[0] * in_POSITION0.xxxx + u_xlat0;
    u_xlat0 = hlslcc_mtx4x4unity_ObjectToWorld[2] * in_POSITION0.zzzz + u_xlat0;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_ObjectToWorld[3];
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_MatrixVP[1];
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat1 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    gl_Position = u_xlat1;
    u_xlat1.y = u_xlat1.y * _ProjectionParams.x;
    u_xlat2.xzw = u_xlat1.xwy * vec3(0.5, 0.5, 0.5);
    vs_TEXCOORD0.zw = u_xlat1.zw;
    vs_TEXCOORD0.xy = u_xlat2.zz + u_xlat2.xw;
    u_xlat1.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_MatrixV[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_MatrixV[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_MatrixV[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_MatrixV[3].xyz * u_xlat0.www + u_xlat0.xyz;
    u_xlat1.xyz = u_xlat0.xyz * vec3(-1.0, -1.0, 1.0);
    u_xlat0.xyz = (-u_xlat0.xyz) * vec3(-1.0, -1.0, 1.0) + in_NORMAL0.xyz;
    vs_TEXCOORD1.xyz = vec3(_LightAsQuad) * u_xlat0.xyz + u_xlat1.xyz;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec3 _WorldSpaceCameraPos;
uniform 	vec4 _ProjectionParams;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 unity_SpecCube0_BoxMax;
uniform 	vec4 unity_SpecCube0_BoxMin;
uniform 	mediump vec4 unity_SpecCube0_HDR;
uniform 	vec4 unity_SpecCube1_ProbePosition;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp samplerCube unity_SpecCube0;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec2 u_xlat1;
lowp vec4 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
lowp vec3 u_xlat10_3;
mediump vec3 u_xlat16_4;
mediump vec3 u_xlat16_5;
mediump vec3 u_xlat16_10;
mediump float u_xlat16_16;
float u_xlat18;
lowp float u_xlat10_18;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat18 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat18 = _ZBufferParams.x * u_xlat18 + _ZBufferParams.y;
    u_xlat18 = float(1.0) / u_xlat18;
    u_xlat0.xyz = vec3(u_xlat18) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat18 = inversesqrt(u_xlat18);
    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
    u_xlat10_3.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_4.xyz = u_xlat10_3.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat16_22 = dot(u_xlat2.xyz, u_xlat16_4.xyz);
    u_xlat16_22 = u_xlat16_22 + u_xlat16_22;
    u_xlat16_5.xyz = u_xlat16_4.xyz * (-vec3(u_xlat16_22)) + u_xlat2.xyz;
    u_xlat16_4.x = dot(u_xlat16_4.xyz, (-u_xlat2.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_4.x = (-u_xlat16_4.x) + 1.0;
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_4.x;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_18 = texture(_CameraGBufferTexture0, u_xlat1.xy).w;
    u_xlat16_4.y = (-u_xlat10_2.w) + 1.0;
    u_xlat16_4.z = (-u_xlat16_4.y) * 0.699999988 + 1.70000005;
    u_xlat16_4.xz = u_xlat16_4.xz * u_xlat16_4.xy;
    u_xlat16_16 = u_xlat16_4.z * 6.0;
    u_xlat10_1 = textureLod(unity_SpecCube0, u_xlat16_5.xyz, u_xlat16_16);
    u_xlat16_16 = u_xlat10_1.w + -1.0;
    u_xlat16_16 = unity_SpecCube0_HDR.w * u_xlat16_16 + 1.0;
    u_xlat16_16 = u_xlat16_16 * unity_SpecCube0_HDR.x;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(u_xlat16_16);
    u_xlat16_5.xyz = vec3(u_xlat10_18) * u_xlat16_5.xyz;
    u_xlat16_16 = u_xlat16_4.y * u_xlat16_4.y;
    u_xlat16_10.x = u_xlat16_4.y * u_xlat16_16;
    u_xlat16_10.x = (-u_xlat16_10.x) * 0.280000001 + 1.0;
    u_xlat16_10.xyz = u_xlat16_5.xyz * u_xlat16_10.xxx;
    u_xlat16_5.x = max(u_xlat10_2.y, u_xlat10_2.x);
    u_xlat16_5.x = max(u_xlat10_2.z, u_xlat16_5.x);
    u_xlat16_5.x = (-u_xlat16_5.x) + 1.0;
    u_xlat16_5.x = (-u_xlat16_5.x) + 1.0;
    u_xlat16_5.x = u_xlat10_2.w + u_xlat16_5.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat16_5.xyz = (-u_xlat10_2.xyz) + u_xlat16_5.xxx;
    u_xlat16_5.xyz = u_xlat16_4.xxx * u_xlat16_5.xyz + u_xlat10_2.xyz;
    SV_Target0.xyz = u_xlat16_10.xyz * u_xlat16_5.xyz;
    u_xlat16_4.xyz = u_xlat0.xyz + (-unity_SpecCube0_BoxMax.xyz);
    u_xlat16_5.xyz = (-u_xlat0.xyz) + unity_SpecCube0_BoxMin.xyz;
    u_xlat16_4.xyz = max(u_xlat16_4.xyz, u_xlat16_5.xyz);
    u_xlat16_4.xyz = max(u_xlat16_4.xyz, vec3(0.0, 0.0, 0.0));
    u_xlat16_4.x = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = sqrt(u_xlat16_4.x);
    u_xlat0.x = u_xlat16_4.x / unity_SpecCube1_ProbePosition.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    SV_Target0.w = u_xlat0.x;
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
  GpuProgramID 99526
Program "vp" {
SubProgram "gles hw_tier00 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec2 xlv_TEXCOORD0;
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
  xlv_TEXCOORD0 = o_3.xy;
  gl_Position = tmpvar_1;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _CameraReflectionsTexture;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  mediump vec4 c_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_CameraReflectionsTexture, xlv_TEXCOORD0);
  c_1 = tmpvar_2;
  mediump vec4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = exp2(-(c_1.xyz));
  gl_FragData[0] = tmpvar_3;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec2 xlv_TEXCOORD0;
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
  xlv_TEXCOORD0 = o_3.xy;
  gl_Position = tmpvar_1;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _CameraReflectionsTexture;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  mediump vec4 c_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_CameraReflectionsTexture, xlv_TEXCOORD0);
  c_1 = tmpvar_2;
  mediump vec4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = exp2(-(c_1.xyz));
  gl_FragData[0] = tmpvar_3;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec2 xlv_TEXCOORD0;
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
  xlv_TEXCOORD0 = o_3.xy;
  gl_Position = tmpvar_1;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _CameraReflectionsTexture;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  mediump vec4 c_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_CameraReflectionsTexture, xlv_TEXCOORD0);
  c_1 = tmpvar_2;
  mediump vec4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = exp2(-(c_1.xyz));
  gl_FragData[0] = tmpvar_3;
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
    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    u_xlat1.x = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.w = u_xlat1.x * 0.5;
    u_xlat1.xz = u_xlat0.xw * vec2(0.5, 0.5);
    gl_Position = u_xlat0;
    vs_TEXCOORD0.xy = u_xlat1.zz + u_xlat1.xw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _CameraReflectionsTexture;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
lowp vec3 u_xlat10_0;
void main()
{
    u_xlat10_0.xyz = texture(_CameraReflectionsTexture, vs_TEXCOORD0.xy).xyz;
    SV_Target0.xyz = exp2((-u_xlat10_0.xyz));
    SV_Target0.w = 0.0;
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
    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    u_xlat1.x = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.w = u_xlat1.x * 0.5;
    u_xlat1.xz = u_xlat0.xw * vec2(0.5, 0.5);
    gl_Position = u_xlat0;
    vs_TEXCOORD0.xy = u_xlat1.zz + u_xlat1.xw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _CameraReflectionsTexture;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
lowp vec3 u_xlat10_0;
void main()
{
    u_xlat10_0.xyz = texture(_CameraReflectionsTexture, vs_TEXCOORD0.xy).xyz;
    SV_Target0.xyz = exp2((-u_xlat10_0.xyz));
    SV_Target0.w = 0.0;
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
    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    u_xlat1.x = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.w = u_xlat1.x * 0.5;
    u_xlat1.xz = u_xlat0.xw * vec2(0.5, 0.5);
    gl_Position = u_xlat0;
    vs_TEXCOORD0.xy = u_xlat1.zz + u_xlat1.xw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _CameraReflectionsTexture;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
lowp vec3 u_xlat10_0;
void main()
{
    u_xlat10_0.xyz = texture(_CameraReflectionsTexture, vs_TEXCOORD0.xy).xyz;
    SV_Target0.xyz = exp2((-u_xlat10_0.xyz));
    SV_Target0.w = 0.0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "UNITY_HDR_ON" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec2 xlv_TEXCOORD0;
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
  xlv_TEXCOORD0 = o_3.xy;
  gl_Position = tmpvar_1;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _CameraReflectionsTexture;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  mediump vec4 c_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_CameraReflectionsTexture, xlv_TEXCOORD0);
  c_1 = tmpvar_2;
  mediump vec4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = c_1.xyz;
  gl_FragData[0] = tmpvar_3;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "UNITY_HDR_ON" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec2 xlv_TEXCOORD0;
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
  xlv_TEXCOORD0 = o_3.xy;
  gl_Position = tmpvar_1;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _CameraReflectionsTexture;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  mediump vec4 c_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_CameraReflectionsTexture, xlv_TEXCOORD0);
  c_1 = tmpvar_2;
  mediump vec4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = c_1.xyz;
  gl_FragData[0] = tmpvar_3;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "UNITY_HDR_ON" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec2 xlv_TEXCOORD0;
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
  xlv_TEXCOORD0 = o_3.xy;
  gl_Position = tmpvar_1;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _CameraReflectionsTexture;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  mediump vec4 c_1;
  lowp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_CameraReflectionsTexture, xlv_TEXCOORD0);
  c_1 = tmpvar_2;
  mediump vec4 tmpvar_3;
  tmpvar_3.w = 0.0;
  tmpvar_3.xyz = c_1.xyz;
  gl_FragData[0] = tmpvar_3;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "UNITY_HDR_ON" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
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
    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    u_xlat1.x = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.w = u_xlat1.x * 0.5;
    u_xlat1.xz = u_xlat0.xw * vec2(0.5, 0.5);
    gl_Position = u_xlat0;
    vs_TEXCOORD0.xy = u_xlat1.zz + u_xlat1.xw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _CameraReflectionsTexture;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
lowp vec3 u_xlat10_0;
void main()
{
    u_xlat10_0.xyz = texture(_CameraReflectionsTexture, vs_TEXCOORD0.xy).xyz;
    SV_Target0.xyz = u_xlat10_0.xyz;
    SV_Target0.w = 0.0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "UNITY_HDR_ON" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
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
    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    u_xlat1.x = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.w = u_xlat1.x * 0.5;
    u_xlat1.xz = u_xlat0.xw * vec2(0.5, 0.5);
    gl_Position = u_xlat0;
    vs_TEXCOORD0.xy = u_xlat1.zz + u_xlat1.xw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _CameraReflectionsTexture;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
lowp vec3 u_xlat10_0;
void main()
{
    u_xlat10_0.xyz = texture(_CameraReflectionsTexture, vs_TEXCOORD0.xy).xyz;
    SV_Target0.xyz = u_xlat10_0.xyz;
    SV_Target0.w = 0.0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "UNITY_HDR_ON" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
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
    u_xlat0 = hlslcc_mtx4x4unity_MatrixVP[3] * u_xlat0.wwww + u_xlat1;
    u_xlat1.x = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.w = u_xlat1.x * 0.5;
    u_xlat1.xz = u_xlat0.xw * vec2(0.5, 0.5);
    gl_Position = u_xlat0;
    vs_TEXCOORD0.xy = u_xlat1.zz + u_xlat1.xw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _CameraReflectionsTexture;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
lowp vec3 u_xlat10_0;
void main()
{
    u_xlat10_0.xyz = texture(_CameraReflectionsTexture, vs_TEXCOORD0.xy).xyz;
    SV_Target0.xyz = u_xlat10_0.xyz;
    SV_Target0.w = 0.0;
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
SubProgram "gles hw_tier00 " {
Keywords { "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "UNITY_HDR_ON" }
""
}
}
}
}
}