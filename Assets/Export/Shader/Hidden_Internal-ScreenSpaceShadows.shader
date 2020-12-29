//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Hidden/Internal-ScreenSpaceShadows" {
Properties {
_ShadowMapTexture ("", any) = "" { }
}
SubShader {
 Tags { "ShadowmapFilter" = "HardShadow" }
 Pass {
  Tags { "ShadowmapFilter" = "HardShadow" }
  ZTest Always
  ZWrite Off
  Cull Off
  GpuProgramID 13895
Program "vp" {
SubProgram "gles hw_tier00 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec3 orthoPosFar_1;
  highp vec3 orthoPosNear_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _glesVertex.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  clipPos_3.xzw = tmpvar_5.xzw;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 o_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_5.zw;
  tmpvar_4.zw = o_7.xy;
  clipPos_3.y = (tmpvar_5.y * _ProjectionParams.x);
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(-1.0, 1.0);
  tmpvar_10.xy = clipPos_3.xy;
  highp vec3 tmpvar_11;
  tmpvar_11 = (unity_CameraInvProjection * tmpvar_10).xyz;
  orthoPosNear_2.xy = tmpvar_11.xy;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(1.0, 1.0);
  tmpvar_12.xy = clipPos_3.xy;
  highp vec3 tmpvar_13;
  tmpvar_13 = (unity_CameraInvProjection * tmpvar_12).xyz;
  orthoPosFar_1.xy = tmpvar_13.xy;
  orthoPosNear_2.z = -(tmpvar_11.z);
  orthoPosFar_1.z = -(tmpvar_13.z);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = _glesMultiTexCoord1.xyz;
  xlv_TEXCOORD2 = orthoPosNear_2;
  xlv_TEXCOORD3 = orthoPosFar_1;
}


#endif
#ifdef FRAGMENT
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_OrthoParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _ShadowMapTexture;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  lowp float shadow_1;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_CameraDepthTexture, xlv_TEXCOORD0.xy);
  tmpvar_2 = mix ((xlv_TEXCOORD1 * mix (
    (1.0/(((_ZBufferParams.x * tmpvar_3.x) + _ZBufferParams.y)))
  , tmpvar_3.x, unity_OrthoParams.w)), mix (xlv_TEXCOORD2, xlv_TEXCOORD3, tmpvar_3.xxx), unity_OrthoParams.www);
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_2;
  highp vec4 tmpvar_5;
  tmpvar_5 = (unity_CameraToWorld * tmpvar_4);
  bvec4 tmpvar_6;
  tmpvar_6 = greaterThanEqual (tmpvar_2.zzzz, _LightSplitsNear);
  bvec4 tmpvar_7;
  tmpvar_7 = lessThan (tmpvar_2.zzzz, _LightSplitsFar);
  lowp vec4 tmpvar_8;
  tmpvar_8 = (vec4(tmpvar_6) * vec4(tmpvar_7));
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = (((
    ((unity_WorldToShadow[0] * tmpvar_5).xyz * tmpvar_8.x)
   + 
    ((unity_WorldToShadow[1] * tmpvar_5).xyz * tmpvar_8.y)
  ) + (
    (unity_WorldToShadow[2] * tmpvar_5)
  .xyz * tmpvar_8.z)) + ((unity_WorldToShadow[3] * tmpvar_5).xyz * tmpvar_8.w));
  highp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_ShadowMapTexture, tmpvar_9.xy);
  lowp float tmpvar_11;
  if ((tmpvar_10.x < tmpvar_9.z)) {
    tmpvar_11 = 0.0;
  } else {
    tmpvar_11 = 1.0;
  };
  mediump float tmpvar_12;
  tmpvar_12 = mix (_LightShadowData.x, 1.0, tmpvar_11);
  shadow_1 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = vec4(shadow_1);
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
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec3 orthoPosFar_1;
  highp vec3 orthoPosNear_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _glesVertex.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  clipPos_3.xzw = tmpvar_5.xzw;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 o_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_5.zw;
  tmpvar_4.zw = o_7.xy;
  clipPos_3.y = (tmpvar_5.y * _ProjectionParams.x);
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(-1.0, 1.0);
  tmpvar_10.xy = clipPos_3.xy;
  highp vec3 tmpvar_11;
  tmpvar_11 = (unity_CameraInvProjection * tmpvar_10).xyz;
  orthoPosNear_2.xy = tmpvar_11.xy;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(1.0, 1.0);
  tmpvar_12.xy = clipPos_3.xy;
  highp vec3 tmpvar_13;
  tmpvar_13 = (unity_CameraInvProjection * tmpvar_12).xyz;
  orthoPosFar_1.xy = tmpvar_13.xy;
  orthoPosNear_2.z = -(tmpvar_11.z);
  orthoPosFar_1.z = -(tmpvar_13.z);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = _glesMultiTexCoord1.xyz;
  xlv_TEXCOORD2 = orthoPosNear_2;
  xlv_TEXCOORD3 = orthoPosFar_1;
}


#endif
#ifdef FRAGMENT
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_OrthoParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _ShadowMapTexture;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  lowp float shadow_1;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_CameraDepthTexture, xlv_TEXCOORD0.xy);
  tmpvar_2 = mix ((xlv_TEXCOORD1 * mix (
    (1.0/(((_ZBufferParams.x * tmpvar_3.x) + _ZBufferParams.y)))
  , tmpvar_3.x, unity_OrthoParams.w)), mix (xlv_TEXCOORD2, xlv_TEXCOORD3, tmpvar_3.xxx), unity_OrthoParams.www);
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_2;
  highp vec4 tmpvar_5;
  tmpvar_5 = (unity_CameraToWorld * tmpvar_4);
  bvec4 tmpvar_6;
  tmpvar_6 = greaterThanEqual (tmpvar_2.zzzz, _LightSplitsNear);
  bvec4 tmpvar_7;
  tmpvar_7 = lessThan (tmpvar_2.zzzz, _LightSplitsFar);
  lowp vec4 tmpvar_8;
  tmpvar_8 = (vec4(tmpvar_6) * vec4(tmpvar_7));
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = (((
    ((unity_WorldToShadow[0] * tmpvar_5).xyz * tmpvar_8.x)
   + 
    ((unity_WorldToShadow[1] * tmpvar_5).xyz * tmpvar_8.y)
  ) + (
    (unity_WorldToShadow[2] * tmpvar_5)
  .xyz * tmpvar_8.z)) + ((unity_WorldToShadow[3] * tmpvar_5).xyz * tmpvar_8.w));
  highp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_ShadowMapTexture, tmpvar_9.xy);
  lowp float tmpvar_11;
  if ((tmpvar_10.x < tmpvar_9.z)) {
    tmpvar_11 = 0.0;
  } else {
    tmpvar_11 = 1.0;
  };
  mediump float tmpvar_12;
  tmpvar_12 = mix (_LightShadowData.x, 1.0, tmpvar_11);
  shadow_1 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = vec4(shadow_1);
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
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec3 orthoPosFar_1;
  highp vec3 orthoPosNear_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _glesVertex.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  clipPos_3.xzw = tmpvar_5.xzw;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 o_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_5.zw;
  tmpvar_4.zw = o_7.xy;
  clipPos_3.y = (tmpvar_5.y * _ProjectionParams.x);
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(-1.0, 1.0);
  tmpvar_10.xy = clipPos_3.xy;
  highp vec3 tmpvar_11;
  tmpvar_11 = (unity_CameraInvProjection * tmpvar_10).xyz;
  orthoPosNear_2.xy = tmpvar_11.xy;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(1.0, 1.0);
  tmpvar_12.xy = clipPos_3.xy;
  highp vec3 tmpvar_13;
  tmpvar_13 = (unity_CameraInvProjection * tmpvar_12).xyz;
  orthoPosFar_1.xy = tmpvar_13.xy;
  orthoPosNear_2.z = -(tmpvar_11.z);
  orthoPosFar_1.z = -(tmpvar_13.z);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = _glesMultiTexCoord1.xyz;
  xlv_TEXCOORD2 = orthoPosNear_2;
  xlv_TEXCOORD3 = orthoPosFar_1;
}


#endif
#ifdef FRAGMENT
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_OrthoParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _ShadowMapTexture;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  lowp float shadow_1;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_CameraDepthTexture, xlv_TEXCOORD0.xy);
  tmpvar_2 = mix ((xlv_TEXCOORD1 * mix (
    (1.0/(((_ZBufferParams.x * tmpvar_3.x) + _ZBufferParams.y)))
  , tmpvar_3.x, unity_OrthoParams.w)), mix (xlv_TEXCOORD2, xlv_TEXCOORD3, tmpvar_3.xxx), unity_OrthoParams.www);
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_2;
  highp vec4 tmpvar_5;
  tmpvar_5 = (unity_CameraToWorld * tmpvar_4);
  bvec4 tmpvar_6;
  tmpvar_6 = greaterThanEqual (tmpvar_2.zzzz, _LightSplitsNear);
  bvec4 tmpvar_7;
  tmpvar_7 = lessThan (tmpvar_2.zzzz, _LightSplitsFar);
  lowp vec4 tmpvar_8;
  tmpvar_8 = (vec4(tmpvar_6) * vec4(tmpvar_7));
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = (((
    ((unity_WorldToShadow[0] * tmpvar_5).xyz * tmpvar_8.x)
   + 
    ((unity_WorldToShadow[1] * tmpvar_5).xyz * tmpvar_8.y)
  ) + (
    (unity_WorldToShadow[2] * tmpvar_5)
  .xyz * tmpvar_8.z)) + ((unity_WorldToShadow[3] * tmpvar_5).xyz * tmpvar_8.w));
  highp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_ShadowMapTexture, tmpvar_9.xy);
  lowp float tmpvar_11;
  if ((tmpvar_10.x < tmpvar_9.z)) {
    tmpvar_11 = 0.0;
  } else {
    tmpvar_11 = 1.0;
  };
  mediump float tmpvar_12;
  tmpvar_12 = mix (_LightShadowData.x, 1.0, tmpvar_11);
  shadow_1 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = vec4(shadow_1);
  gl_FragData[0] = tmpvar_13;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
in highp vec3 in_TEXCOORD1;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
out highp vec3 vs_TEXCOORD2;
out highp vec3 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
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
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraInvProjection[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraInvProjection[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    vs_TEXCOORD0.zw = u_xlat1.zz + u_xlat1.xw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    vs_TEXCOORD1.xyz = in_TEXCOORD1.xyz;
    u_xlat1.xyz = u_xlat0.xyz + (-hlslcc_mtx4x4unity_CameraInvProjection[2].xyz);
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[2].xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.w = (-u_xlat1.z);
    vs_TEXCOORD2.xyz = u_xlat1.xyw;
    u_xlat0.w = (-u_xlat0.z);
    vs_TEXCOORD3.xyz = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 unity_OrthoParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 _LightSplitsNear;
uniform 	vec4 _LightSplitsFar;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
in highp vec3 vs_TEXCOORD2;
in highp vec3 vs_TEXCOORD3;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
lowp float u_xlat10_0;
vec4 u_xlat1;
mediump vec4 u_xlat16_1;
bvec4 u_xlatb1;
vec4 u_xlat2;
bvec4 u_xlatb2;
vec3 u_xlat3;
mediump float u_xlat16_4;
float u_xlat5;
float u_xlat10;
void main()
{
    u_xlat0.x = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat5 = _ZBufferParams.x * u_xlat0.x + _ZBufferParams.y;
    u_xlat5 = float(1.0) / u_xlat5;
    u_xlat10 = (-u_xlat5) + u_xlat0.x;
    u_xlat5 = unity_OrthoParams.w * u_xlat10 + u_xlat5;
    u_xlat1.xyz = (-vs_TEXCOORD2.xyz) + vs_TEXCOORD3.xyz;
    u_xlat0.xzw = u_xlat0.xxx * u_xlat1.xyz + vs_TEXCOORD2.xyz;
    u_xlat0.xzw = (-vs_TEXCOORD1.xyz) * vec3(u_xlat5) + u_xlat0.xzw;
    u_xlat1.xyz = vec3(u_xlat5) * vs_TEXCOORD1.xyz;
    u_xlat0.xyz = unity_OrthoParams.www * u_xlat0.xzw + u_xlat1.xyz;
    u_xlatb1 = greaterThanEqual(u_xlat0.zzzz, _LightSplitsNear);
    u_xlat1 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb1));
    u_xlatb2 = lessThan(u_xlat0.zzzz, _LightSplitsFar);
    u_xlat2 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb2));
    u_xlat16_1 = u_xlat1 * u_xlat2;
    u_xlat2 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat2 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat2;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * u_xlat0.zzzz + u_xlat2;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[5].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[4].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[6].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[7].xyz * u_xlat0.www + u_xlat2.xyz;
    u_xlat2.xyz = u_xlat16_1.yyy * u_xlat2.xyz;
    u_xlat3.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * u_xlat0.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * u_xlat0.zzz + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[3].xyz * u_xlat0.www + u_xlat3.xyz;
    u_xlat2.xyz = u_xlat3.xyz * u_xlat16_1.xxx + u_xlat2.xyz;
    u_xlat3.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[9].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[8].xyz * u_xlat0.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[10].xyz * u_xlat0.zzz + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[11].xyz * u_xlat0.www + u_xlat3.xyz;
    u_xlat2.xyz = u_xlat3.xyz * u_xlat16_1.zzz + u_xlat2.xyz;
    u_xlat3.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[13].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[12].xyz * u_xlat0.xxx + u_xlat3.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[14].xyz * u_xlat0.zzz + u_xlat3.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[15].xyz * u_xlat0.www + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www + u_xlat2.xyz;
    vec3 txVec0 = vec3(u_xlat0.xy,u_xlat0.z);
    u_xlat10_0 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_4 = (-_LightShadowData.x) + 1.0;
    SV_Target0 = vec4(u_xlat10_0) * vec4(u_xlat16_4) + _LightShadowData.xxxx;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
in highp vec3 in_TEXCOORD1;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
out highp vec3 vs_TEXCOORD2;
out highp vec3 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
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
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraInvProjection[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraInvProjection[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    vs_TEXCOORD0.zw = u_xlat1.zz + u_xlat1.xw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    vs_TEXCOORD1.xyz = in_TEXCOORD1.xyz;
    u_xlat1.xyz = u_xlat0.xyz + (-hlslcc_mtx4x4unity_CameraInvProjection[2].xyz);
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[2].xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.w = (-u_xlat1.z);
    vs_TEXCOORD2.xyz = u_xlat1.xyw;
    u_xlat0.w = (-u_xlat0.z);
    vs_TEXCOORD3.xyz = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 unity_OrthoParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 _LightSplitsNear;
uniform 	vec4 _LightSplitsFar;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
in highp vec3 vs_TEXCOORD2;
in highp vec3 vs_TEXCOORD3;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
lowp float u_xlat10_0;
vec4 u_xlat1;
mediump vec4 u_xlat16_1;
bvec4 u_xlatb1;
vec4 u_xlat2;
bvec4 u_xlatb2;
vec3 u_xlat3;
mediump float u_xlat16_4;
float u_xlat5;
float u_xlat10;
void main()
{
    u_xlat0.x = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat5 = _ZBufferParams.x * u_xlat0.x + _ZBufferParams.y;
    u_xlat5 = float(1.0) / u_xlat5;
    u_xlat10 = (-u_xlat5) + u_xlat0.x;
    u_xlat5 = unity_OrthoParams.w * u_xlat10 + u_xlat5;
    u_xlat1.xyz = (-vs_TEXCOORD2.xyz) + vs_TEXCOORD3.xyz;
    u_xlat0.xzw = u_xlat0.xxx * u_xlat1.xyz + vs_TEXCOORD2.xyz;
    u_xlat0.xzw = (-vs_TEXCOORD1.xyz) * vec3(u_xlat5) + u_xlat0.xzw;
    u_xlat1.xyz = vec3(u_xlat5) * vs_TEXCOORD1.xyz;
    u_xlat0.xyz = unity_OrthoParams.www * u_xlat0.xzw + u_xlat1.xyz;
    u_xlatb1 = greaterThanEqual(u_xlat0.zzzz, _LightSplitsNear);
    u_xlat1 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb1));
    u_xlatb2 = lessThan(u_xlat0.zzzz, _LightSplitsFar);
    u_xlat2 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb2));
    u_xlat16_1 = u_xlat1 * u_xlat2;
    u_xlat2 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat2 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat2;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * u_xlat0.zzzz + u_xlat2;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[5].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[4].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[6].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[7].xyz * u_xlat0.www + u_xlat2.xyz;
    u_xlat2.xyz = u_xlat16_1.yyy * u_xlat2.xyz;
    u_xlat3.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * u_xlat0.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * u_xlat0.zzz + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[3].xyz * u_xlat0.www + u_xlat3.xyz;
    u_xlat2.xyz = u_xlat3.xyz * u_xlat16_1.xxx + u_xlat2.xyz;
    u_xlat3.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[9].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[8].xyz * u_xlat0.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[10].xyz * u_xlat0.zzz + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[11].xyz * u_xlat0.www + u_xlat3.xyz;
    u_xlat2.xyz = u_xlat3.xyz * u_xlat16_1.zzz + u_xlat2.xyz;
    u_xlat3.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[13].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[12].xyz * u_xlat0.xxx + u_xlat3.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[14].xyz * u_xlat0.zzz + u_xlat3.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[15].xyz * u_xlat0.www + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www + u_xlat2.xyz;
    vec3 txVec0 = vec3(u_xlat0.xy,u_xlat0.z);
    u_xlat10_0 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_4 = (-_LightShadowData.x) + 1.0;
    SV_Target0 = vec4(u_xlat10_0) * vec4(u_xlat16_4) + _LightShadowData.xxxx;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
in highp vec3 in_TEXCOORD1;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
out highp vec3 vs_TEXCOORD2;
out highp vec3 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
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
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraInvProjection[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraInvProjection[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    vs_TEXCOORD0.zw = u_xlat1.zz + u_xlat1.xw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    vs_TEXCOORD1.xyz = in_TEXCOORD1.xyz;
    u_xlat1.xyz = u_xlat0.xyz + (-hlslcc_mtx4x4unity_CameraInvProjection[2].xyz);
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[2].xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.w = (-u_xlat1.z);
    vs_TEXCOORD2.xyz = u_xlat1.xyw;
    u_xlat0.w = (-u_xlat0.z);
    vs_TEXCOORD3.xyz = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 unity_OrthoParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 _LightSplitsNear;
uniform 	vec4 _LightSplitsFar;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
in highp vec3 vs_TEXCOORD2;
in highp vec3 vs_TEXCOORD3;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
lowp float u_xlat10_0;
vec4 u_xlat1;
mediump vec4 u_xlat16_1;
bvec4 u_xlatb1;
vec4 u_xlat2;
bvec4 u_xlatb2;
vec3 u_xlat3;
mediump float u_xlat16_4;
float u_xlat5;
float u_xlat10;
void main()
{
    u_xlat0.x = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat5 = _ZBufferParams.x * u_xlat0.x + _ZBufferParams.y;
    u_xlat5 = float(1.0) / u_xlat5;
    u_xlat10 = (-u_xlat5) + u_xlat0.x;
    u_xlat5 = unity_OrthoParams.w * u_xlat10 + u_xlat5;
    u_xlat1.xyz = (-vs_TEXCOORD2.xyz) + vs_TEXCOORD3.xyz;
    u_xlat0.xzw = u_xlat0.xxx * u_xlat1.xyz + vs_TEXCOORD2.xyz;
    u_xlat0.xzw = (-vs_TEXCOORD1.xyz) * vec3(u_xlat5) + u_xlat0.xzw;
    u_xlat1.xyz = vec3(u_xlat5) * vs_TEXCOORD1.xyz;
    u_xlat0.xyz = unity_OrthoParams.www * u_xlat0.xzw + u_xlat1.xyz;
    u_xlatb1 = greaterThanEqual(u_xlat0.zzzz, _LightSplitsNear);
    u_xlat1 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb1));
    u_xlatb2 = lessThan(u_xlat0.zzzz, _LightSplitsFar);
    u_xlat2 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb2));
    u_xlat16_1 = u_xlat1 * u_xlat2;
    u_xlat2 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat2 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat2;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * u_xlat0.zzzz + u_xlat2;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[5].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[4].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[6].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[7].xyz * u_xlat0.www + u_xlat2.xyz;
    u_xlat2.xyz = u_xlat16_1.yyy * u_xlat2.xyz;
    u_xlat3.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * u_xlat0.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * u_xlat0.zzz + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[3].xyz * u_xlat0.www + u_xlat3.xyz;
    u_xlat2.xyz = u_xlat3.xyz * u_xlat16_1.xxx + u_xlat2.xyz;
    u_xlat3.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[9].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[8].xyz * u_xlat0.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[10].xyz * u_xlat0.zzz + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[11].xyz * u_xlat0.www + u_xlat3.xyz;
    u_xlat2.xyz = u_xlat3.xyz * u_xlat16_1.zzz + u_xlat2.xyz;
    u_xlat3.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[13].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[12].xyz * u_xlat0.xxx + u_xlat3.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[14].xyz * u_xlat0.zzz + u_xlat3.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[15].xyz * u_xlat0.www + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www + u_xlat2.xyz;
    vec3 txVec0 = vec3(u_xlat0.xy,u_xlat0.z);
    u_xlat10_0 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_4 = (-_LightShadowData.x) + 1.0;
    SV_Target0 = vec4(u_xlat10_0) * vec4(u_xlat16_4) + _LightShadowData.xxxx;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "SHADOWS_SPLIT_SPHERES" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec3 orthoPosFar_1;
  highp vec3 orthoPosNear_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _glesVertex.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  clipPos_3.xzw = tmpvar_5.xzw;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 o_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_5.zw;
  tmpvar_4.zw = o_7.xy;
  clipPos_3.y = (tmpvar_5.y * _ProjectionParams.x);
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(-1.0, 1.0);
  tmpvar_10.xy = clipPos_3.xy;
  highp vec3 tmpvar_11;
  tmpvar_11 = (unity_CameraInvProjection * tmpvar_10).xyz;
  orthoPosNear_2.xy = tmpvar_11.xy;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(1.0, 1.0);
  tmpvar_12.xy = clipPos_3.xy;
  highp vec3 tmpvar_13;
  tmpvar_13 = (unity_CameraInvProjection * tmpvar_12).xyz;
  orthoPosFar_1.xy = tmpvar_13.xy;
  orthoPosNear_2.z = -(tmpvar_11.z);
  orthoPosFar_1.z = -(tmpvar_13.z);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = _glesMultiTexCoord1.xyz;
  xlv_TEXCOORD2 = orthoPosNear_2;
  xlv_TEXCOORD3 = orthoPosFar_1;
}


#endif
#ifdef FRAGMENT
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_OrthoParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _ShadowMapTexture;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  lowp float shadow_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_CameraDepthTexture, xlv_TEXCOORD0.xy);
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = mix ((xlv_TEXCOORD1 * mix (
    (1.0/(((_ZBufferParams.x * tmpvar_2.x) + _ZBufferParams.y)))
  , tmpvar_2.x, unity_OrthoParams.w)), mix (xlv_TEXCOORD2, xlv_TEXCOORD3, tmpvar_2.xxx), unity_OrthoParams.www);
  highp vec4 tmpvar_4;
  tmpvar_4 = (unity_CameraToWorld * tmpvar_3);
  lowp vec4 weights_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_4.xyz - unity_ShadowSplitSpheres[0].xyz);
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_4.xyz - unity_ShadowSplitSpheres[1].xyz);
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_4.xyz - unity_ShadowSplitSpheres[2].xyz);
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_4.xyz - unity_ShadowSplitSpheres[3].xyz);
  highp vec4 tmpvar_10;
  tmpvar_10.x = dot (tmpvar_6, tmpvar_6);
  tmpvar_10.y = dot (tmpvar_7, tmpvar_7);
  tmpvar_10.z = dot (tmpvar_8, tmpvar_8);
  tmpvar_10.w = dot (tmpvar_9, tmpvar_9);
  bvec4 tmpvar_11;
  tmpvar_11 = lessThan (tmpvar_10, unity_ShadowSplitSqRadii);
  lowp vec4 tmpvar_12;
  tmpvar_12 = vec4(tmpvar_11);
  weights_5.x = tmpvar_12.x;
  weights_5.yzw = clamp ((tmpvar_12.yzw - tmpvar_12.xyz), 0.0, 1.0);
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = (((
    ((unity_WorldToShadow[0] * tmpvar_4).xyz * tmpvar_12.x)
   + 
    ((unity_WorldToShadow[1] * tmpvar_4).xyz * weights_5.y)
  ) + (
    (unity_WorldToShadow[2] * tmpvar_4)
  .xyz * weights_5.z)) + ((unity_WorldToShadow[3] * tmpvar_4).xyz * weights_5.w));
  highp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_ShadowMapTexture, tmpvar_13.xy);
  lowp float tmpvar_15;
  if ((tmpvar_14.x < tmpvar_13.z)) {
    tmpvar_15 = 0.0;
  } else {
    tmpvar_15 = 1.0;
  };
  mediump float tmpvar_16;
  tmpvar_16 = mix (_LightShadowData.x, 1.0, tmpvar_15);
  shadow_1 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = vec4(shadow_1);
  gl_FragData[0] = tmpvar_17;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "SHADOWS_SPLIT_SPHERES" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec3 orthoPosFar_1;
  highp vec3 orthoPosNear_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _glesVertex.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  clipPos_3.xzw = tmpvar_5.xzw;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 o_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_5.zw;
  tmpvar_4.zw = o_7.xy;
  clipPos_3.y = (tmpvar_5.y * _ProjectionParams.x);
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(-1.0, 1.0);
  tmpvar_10.xy = clipPos_3.xy;
  highp vec3 tmpvar_11;
  tmpvar_11 = (unity_CameraInvProjection * tmpvar_10).xyz;
  orthoPosNear_2.xy = tmpvar_11.xy;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(1.0, 1.0);
  tmpvar_12.xy = clipPos_3.xy;
  highp vec3 tmpvar_13;
  tmpvar_13 = (unity_CameraInvProjection * tmpvar_12).xyz;
  orthoPosFar_1.xy = tmpvar_13.xy;
  orthoPosNear_2.z = -(tmpvar_11.z);
  orthoPosFar_1.z = -(tmpvar_13.z);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = _glesMultiTexCoord1.xyz;
  xlv_TEXCOORD2 = orthoPosNear_2;
  xlv_TEXCOORD3 = orthoPosFar_1;
}


#endif
#ifdef FRAGMENT
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_OrthoParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _ShadowMapTexture;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  lowp float shadow_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_CameraDepthTexture, xlv_TEXCOORD0.xy);
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = mix ((xlv_TEXCOORD1 * mix (
    (1.0/(((_ZBufferParams.x * tmpvar_2.x) + _ZBufferParams.y)))
  , tmpvar_2.x, unity_OrthoParams.w)), mix (xlv_TEXCOORD2, xlv_TEXCOORD3, tmpvar_2.xxx), unity_OrthoParams.www);
  highp vec4 tmpvar_4;
  tmpvar_4 = (unity_CameraToWorld * tmpvar_3);
  lowp vec4 weights_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_4.xyz - unity_ShadowSplitSpheres[0].xyz);
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_4.xyz - unity_ShadowSplitSpheres[1].xyz);
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_4.xyz - unity_ShadowSplitSpheres[2].xyz);
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_4.xyz - unity_ShadowSplitSpheres[3].xyz);
  highp vec4 tmpvar_10;
  tmpvar_10.x = dot (tmpvar_6, tmpvar_6);
  tmpvar_10.y = dot (tmpvar_7, tmpvar_7);
  tmpvar_10.z = dot (tmpvar_8, tmpvar_8);
  tmpvar_10.w = dot (tmpvar_9, tmpvar_9);
  bvec4 tmpvar_11;
  tmpvar_11 = lessThan (tmpvar_10, unity_ShadowSplitSqRadii);
  lowp vec4 tmpvar_12;
  tmpvar_12 = vec4(tmpvar_11);
  weights_5.x = tmpvar_12.x;
  weights_5.yzw = clamp ((tmpvar_12.yzw - tmpvar_12.xyz), 0.0, 1.0);
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = (((
    ((unity_WorldToShadow[0] * tmpvar_4).xyz * tmpvar_12.x)
   + 
    ((unity_WorldToShadow[1] * tmpvar_4).xyz * weights_5.y)
  ) + (
    (unity_WorldToShadow[2] * tmpvar_4)
  .xyz * weights_5.z)) + ((unity_WorldToShadow[3] * tmpvar_4).xyz * weights_5.w));
  highp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_ShadowMapTexture, tmpvar_13.xy);
  lowp float tmpvar_15;
  if ((tmpvar_14.x < tmpvar_13.z)) {
    tmpvar_15 = 0.0;
  } else {
    tmpvar_15 = 1.0;
  };
  mediump float tmpvar_16;
  tmpvar_16 = mix (_LightShadowData.x, 1.0, tmpvar_15);
  shadow_1 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = vec4(shadow_1);
  gl_FragData[0] = tmpvar_17;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "SHADOWS_SPLIT_SPHERES" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec3 orthoPosFar_1;
  highp vec3 orthoPosNear_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _glesVertex.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  clipPos_3.xzw = tmpvar_5.xzw;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 o_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_5.zw;
  tmpvar_4.zw = o_7.xy;
  clipPos_3.y = (tmpvar_5.y * _ProjectionParams.x);
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(-1.0, 1.0);
  tmpvar_10.xy = clipPos_3.xy;
  highp vec3 tmpvar_11;
  tmpvar_11 = (unity_CameraInvProjection * tmpvar_10).xyz;
  orthoPosNear_2.xy = tmpvar_11.xy;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(1.0, 1.0);
  tmpvar_12.xy = clipPos_3.xy;
  highp vec3 tmpvar_13;
  tmpvar_13 = (unity_CameraInvProjection * tmpvar_12).xyz;
  orthoPosFar_1.xy = tmpvar_13.xy;
  orthoPosNear_2.z = -(tmpvar_11.z);
  orthoPosFar_1.z = -(tmpvar_13.z);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = _glesMultiTexCoord1.xyz;
  xlv_TEXCOORD2 = orthoPosNear_2;
  xlv_TEXCOORD3 = orthoPosFar_1;
}


#endif
#ifdef FRAGMENT
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_OrthoParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _ShadowMapTexture;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  lowp float shadow_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_CameraDepthTexture, xlv_TEXCOORD0.xy);
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = mix ((xlv_TEXCOORD1 * mix (
    (1.0/(((_ZBufferParams.x * tmpvar_2.x) + _ZBufferParams.y)))
  , tmpvar_2.x, unity_OrthoParams.w)), mix (xlv_TEXCOORD2, xlv_TEXCOORD3, tmpvar_2.xxx), unity_OrthoParams.www);
  highp vec4 tmpvar_4;
  tmpvar_4 = (unity_CameraToWorld * tmpvar_3);
  lowp vec4 weights_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_4.xyz - unity_ShadowSplitSpheres[0].xyz);
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_4.xyz - unity_ShadowSplitSpheres[1].xyz);
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_4.xyz - unity_ShadowSplitSpheres[2].xyz);
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_4.xyz - unity_ShadowSplitSpheres[3].xyz);
  highp vec4 tmpvar_10;
  tmpvar_10.x = dot (tmpvar_6, tmpvar_6);
  tmpvar_10.y = dot (tmpvar_7, tmpvar_7);
  tmpvar_10.z = dot (tmpvar_8, tmpvar_8);
  tmpvar_10.w = dot (tmpvar_9, tmpvar_9);
  bvec4 tmpvar_11;
  tmpvar_11 = lessThan (tmpvar_10, unity_ShadowSplitSqRadii);
  lowp vec4 tmpvar_12;
  tmpvar_12 = vec4(tmpvar_11);
  weights_5.x = tmpvar_12.x;
  weights_5.yzw = clamp ((tmpvar_12.yzw - tmpvar_12.xyz), 0.0, 1.0);
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = (((
    ((unity_WorldToShadow[0] * tmpvar_4).xyz * tmpvar_12.x)
   + 
    ((unity_WorldToShadow[1] * tmpvar_4).xyz * weights_5.y)
  ) + (
    (unity_WorldToShadow[2] * tmpvar_4)
  .xyz * weights_5.z)) + ((unity_WorldToShadow[3] * tmpvar_4).xyz * weights_5.w));
  highp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_ShadowMapTexture, tmpvar_13.xy);
  lowp float tmpvar_15;
  if ((tmpvar_14.x < tmpvar_13.z)) {
    tmpvar_15 = 0.0;
  } else {
    tmpvar_15 = 1.0;
  };
  mediump float tmpvar_16;
  tmpvar_16 = mix (_LightShadowData.x, 1.0, tmpvar_15);
  shadow_1 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = vec4(shadow_1);
  gl_FragData[0] = tmpvar_17;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SHADOWS_SPLIT_SPHERES" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
in highp vec3 in_TEXCOORD1;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
out highp vec3 vs_TEXCOORD2;
out highp vec3 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
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
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraInvProjection[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraInvProjection[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    vs_TEXCOORD0.zw = u_xlat1.zz + u_xlat1.xw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    vs_TEXCOORD1.xyz = in_TEXCOORD1.xyz;
    u_xlat1.xyz = u_xlat0.xyz + (-hlslcc_mtx4x4unity_CameraInvProjection[2].xyz);
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[2].xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.w = (-u_xlat1.z);
    vs_TEXCOORD2.xyz = u_xlat1.xyw;
    u_xlat0.w = (-u_xlat0.z);
    vs_TEXCOORD3.xyz = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 unity_OrthoParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 unity_ShadowSplitSpheres[4];
uniform 	vec4 unity_ShadowSplitSqRadii;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
in highp vec3 vs_TEXCOORD2;
in highp vec3 vs_TEXCOORD3;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
lowp float u_xlat10_0;
vec4 u_xlat1;
bvec4 u_xlatb1;
vec3 u_xlat2;
mediump vec3 u_xlat16_3;
float u_xlat4;
vec3 u_xlat5;
float u_xlat8;
void main()
{
    u_xlat0.x = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat4 = _ZBufferParams.x * u_xlat0.x + _ZBufferParams.y;
    u_xlat4 = float(1.0) / u_xlat4;
    u_xlat8 = (-u_xlat4) + u_xlat0.x;
    u_xlat4 = unity_OrthoParams.w * u_xlat8 + u_xlat4;
    u_xlat1.xyz = (-vs_TEXCOORD2.xyz) + vs_TEXCOORD3.xyz;
    u_xlat0.xzw = u_xlat0.xxx * u_xlat1.xyz + vs_TEXCOORD2.xyz;
    u_xlat0.xzw = (-vs_TEXCOORD1.xyz) * vec3(u_xlat4) + u_xlat0.xzw;
    u_xlat1.xyz = vec3(u_xlat4) * vs_TEXCOORD1.xyz;
    u_xlat0.xyz = unity_OrthoParams.www * u_xlat0.xzw + u_xlat1.xyz;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat1.xyz = u_xlat0.xyz + (-unity_ShadowSplitSpheres[0].xyz);
    u_xlat1.x = dot(u_xlat1.xyz, u_xlat1.xyz);
    u_xlat2.xyz = u_xlat0.xyz + (-unity_ShadowSplitSpheres[1].xyz);
    u_xlat1.y = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat2.xyz = u_xlat0.xyz + (-unity_ShadowSplitSpheres[2].xyz);
    u_xlat1.z = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat2.xyz = u_xlat0.xyz + (-unity_ShadowSplitSpheres[3].xyz);
    u_xlat1.w = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlatb1 = lessThan(u_xlat1, unity_ShadowSplitSqRadii);
    u_xlat16_3.x = (u_xlatb1.x) ? float(-1.0) : float(-0.0);
    u_xlat16_3.y = (u_xlatb1.y) ? float(-1.0) : float(-0.0);
    u_xlat16_3.z = (u_xlatb1.z) ? float(-1.0) : float(-0.0);
    u_xlat1 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb1));
    u_xlat16_3.xyz = vec3(u_xlat16_3.x + u_xlat1.y, u_xlat16_3.y + u_xlat1.z, u_xlat16_3.z + u_xlat1.w);
    u_xlat16_3.xyz = max(u_xlat16_3.xyz, vec3(0.0, 0.0, 0.0));
    u_xlat5.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[5].xyz;
    u_xlat5.xyz = hlslcc_mtx4x4unity_WorldToShadow[4].xyz * u_xlat0.xxx + u_xlat5.xyz;
    u_xlat5.xyz = hlslcc_mtx4x4unity_WorldToShadow[6].xyz * u_xlat0.zzz + u_xlat5.xyz;
    u_xlat5.xyz = hlslcc_mtx4x4unity_WorldToShadow[7].xyz * u_xlat0.www + u_xlat5.xyz;
    u_xlat5.xyz = u_xlat16_3.xxx * u_xlat5.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[3].xyz * u_xlat0.www + u_xlat2.xyz;
    u_xlat1.xyz = u_xlat2.xyz * u_xlat1.xxx + u_xlat5.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[9].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[8].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[10].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[11].xyz * u_xlat0.www + u_xlat2.xyz;
    u_xlat1.xyz = u_xlat2.xyz * u_xlat16_3.yyy + u_xlat1.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[13].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[12].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[14].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[15].xyz * u_xlat0.www + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_3.zzz + u_xlat1.xyz;
    vec3 txVec0 = vec3(u_xlat0.xy,u_xlat0.z);
    u_xlat10_0 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_3.x = (-_LightShadowData.x) + 1.0;
    SV_Target0 = vec4(u_xlat10_0) * u_xlat16_3.xxxx + _LightShadowData.xxxx;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SHADOWS_SPLIT_SPHERES" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
in highp vec3 in_TEXCOORD1;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
out highp vec3 vs_TEXCOORD2;
out highp vec3 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
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
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraInvProjection[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraInvProjection[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    vs_TEXCOORD0.zw = u_xlat1.zz + u_xlat1.xw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    vs_TEXCOORD1.xyz = in_TEXCOORD1.xyz;
    u_xlat1.xyz = u_xlat0.xyz + (-hlslcc_mtx4x4unity_CameraInvProjection[2].xyz);
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[2].xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.w = (-u_xlat1.z);
    vs_TEXCOORD2.xyz = u_xlat1.xyw;
    u_xlat0.w = (-u_xlat0.z);
    vs_TEXCOORD3.xyz = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 unity_OrthoParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 unity_ShadowSplitSpheres[4];
uniform 	vec4 unity_ShadowSplitSqRadii;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
in highp vec3 vs_TEXCOORD2;
in highp vec3 vs_TEXCOORD3;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
lowp float u_xlat10_0;
vec4 u_xlat1;
bvec4 u_xlatb1;
vec3 u_xlat2;
mediump vec3 u_xlat16_3;
float u_xlat4;
vec3 u_xlat5;
float u_xlat8;
void main()
{
    u_xlat0.x = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat4 = _ZBufferParams.x * u_xlat0.x + _ZBufferParams.y;
    u_xlat4 = float(1.0) / u_xlat4;
    u_xlat8 = (-u_xlat4) + u_xlat0.x;
    u_xlat4 = unity_OrthoParams.w * u_xlat8 + u_xlat4;
    u_xlat1.xyz = (-vs_TEXCOORD2.xyz) + vs_TEXCOORD3.xyz;
    u_xlat0.xzw = u_xlat0.xxx * u_xlat1.xyz + vs_TEXCOORD2.xyz;
    u_xlat0.xzw = (-vs_TEXCOORD1.xyz) * vec3(u_xlat4) + u_xlat0.xzw;
    u_xlat1.xyz = vec3(u_xlat4) * vs_TEXCOORD1.xyz;
    u_xlat0.xyz = unity_OrthoParams.www * u_xlat0.xzw + u_xlat1.xyz;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat1.xyz = u_xlat0.xyz + (-unity_ShadowSplitSpheres[0].xyz);
    u_xlat1.x = dot(u_xlat1.xyz, u_xlat1.xyz);
    u_xlat2.xyz = u_xlat0.xyz + (-unity_ShadowSplitSpheres[1].xyz);
    u_xlat1.y = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat2.xyz = u_xlat0.xyz + (-unity_ShadowSplitSpheres[2].xyz);
    u_xlat1.z = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat2.xyz = u_xlat0.xyz + (-unity_ShadowSplitSpheres[3].xyz);
    u_xlat1.w = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlatb1 = lessThan(u_xlat1, unity_ShadowSplitSqRadii);
    u_xlat16_3.x = (u_xlatb1.x) ? float(-1.0) : float(-0.0);
    u_xlat16_3.y = (u_xlatb1.y) ? float(-1.0) : float(-0.0);
    u_xlat16_3.z = (u_xlatb1.z) ? float(-1.0) : float(-0.0);
    u_xlat1 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb1));
    u_xlat16_3.xyz = vec3(u_xlat16_3.x + u_xlat1.y, u_xlat16_3.y + u_xlat1.z, u_xlat16_3.z + u_xlat1.w);
    u_xlat16_3.xyz = max(u_xlat16_3.xyz, vec3(0.0, 0.0, 0.0));
    u_xlat5.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[5].xyz;
    u_xlat5.xyz = hlslcc_mtx4x4unity_WorldToShadow[4].xyz * u_xlat0.xxx + u_xlat5.xyz;
    u_xlat5.xyz = hlslcc_mtx4x4unity_WorldToShadow[6].xyz * u_xlat0.zzz + u_xlat5.xyz;
    u_xlat5.xyz = hlslcc_mtx4x4unity_WorldToShadow[7].xyz * u_xlat0.www + u_xlat5.xyz;
    u_xlat5.xyz = u_xlat16_3.xxx * u_xlat5.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[3].xyz * u_xlat0.www + u_xlat2.xyz;
    u_xlat1.xyz = u_xlat2.xyz * u_xlat1.xxx + u_xlat5.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[9].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[8].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[10].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[11].xyz * u_xlat0.www + u_xlat2.xyz;
    u_xlat1.xyz = u_xlat2.xyz * u_xlat16_3.yyy + u_xlat1.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[13].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[12].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[14].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[15].xyz * u_xlat0.www + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_3.zzz + u_xlat1.xyz;
    vec3 txVec0 = vec3(u_xlat0.xy,u_xlat0.z);
    u_xlat10_0 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_3.x = (-_LightShadowData.x) + 1.0;
    SV_Target0 = vec4(u_xlat10_0) * u_xlat16_3.xxxx + _LightShadowData.xxxx;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SHADOWS_SPLIT_SPHERES" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
in highp vec3 in_TEXCOORD1;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
out highp vec3 vs_TEXCOORD2;
out highp vec3 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
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
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraInvProjection[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraInvProjection[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    vs_TEXCOORD0.zw = u_xlat1.zz + u_xlat1.xw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    vs_TEXCOORD1.xyz = in_TEXCOORD1.xyz;
    u_xlat1.xyz = u_xlat0.xyz + (-hlslcc_mtx4x4unity_CameraInvProjection[2].xyz);
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[2].xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.w = (-u_xlat1.z);
    vs_TEXCOORD2.xyz = u_xlat1.xyw;
    u_xlat0.w = (-u_xlat0.z);
    vs_TEXCOORD3.xyz = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 unity_OrthoParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 unity_ShadowSplitSpheres[4];
uniform 	vec4 unity_ShadowSplitSqRadii;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
in highp vec3 vs_TEXCOORD2;
in highp vec3 vs_TEXCOORD3;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
lowp float u_xlat10_0;
vec4 u_xlat1;
bvec4 u_xlatb1;
vec3 u_xlat2;
mediump vec3 u_xlat16_3;
float u_xlat4;
vec3 u_xlat5;
float u_xlat8;
void main()
{
    u_xlat0.x = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat4 = _ZBufferParams.x * u_xlat0.x + _ZBufferParams.y;
    u_xlat4 = float(1.0) / u_xlat4;
    u_xlat8 = (-u_xlat4) + u_xlat0.x;
    u_xlat4 = unity_OrthoParams.w * u_xlat8 + u_xlat4;
    u_xlat1.xyz = (-vs_TEXCOORD2.xyz) + vs_TEXCOORD3.xyz;
    u_xlat0.xzw = u_xlat0.xxx * u_xlat1.xyz + vs_TEXCOORD2.xyz;
    u_xlat0.xzw = (-vs_TEXCOORD1.xyz) * vec3(u_xlat4) + u_xlat0.xzw;
    u_xlat1.xyz = vec3(u_xlat4) * vs_TEXCOORD1.xyz;
    u_xlat0.xyz = unity_OrthoParams.www * u_xlat0.xzw + u_xlat1.xyz;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat1.xyz = u_xlat0.xyz + (-unity_ShadowSplitSpheres[0].xyz);
    u_xlat1.x = dot(u_xlat1.xyz, u_xlat1.xyz);
    u_xlat2.xyz = u_xlat0.xyz + (-unity_ShadowSplitSpheres[1].xyz);
    u_xlat1.y = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat2.xyz = u_xlat0.xyz + (-unity_ShadowSplitSpheres[2].xyz);
    u_xlat1.z = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat2.xyz = u_xlat0.xyz + (-unity_ShadowSplitSpheres[3].xyz);
    u_xlat1.w = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlatb1 = lessThan(u_xlat1, unity_ShadowSplitSqRadii);
    u_xlat16_3.x = (u_xlatb1.x) ? float(-1.0) : float(-0.0);
    u_xlat16_3.y = (u_xlatb1.y) ? float(-1.0) : float(-0.0);
    u_xlat16_3.z = (u_xlatb1.z) ? float(-1.0) : float(-0.0);
    u_xlat1 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb1));
    u_xlat16_3.xyz = vec3(u_xlat16_3.x + u_xlat1.y, u_xlat16_3.y + u_xlat1.z, u_xlat16_3.z + u_xlat1.w);
    u_xlat16_3.xyz = max(u_xlat16_3.xyz, vec3(0.0, 0.0, 0.0));
    u_xlat5.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[5].xyz;
    u_xlat5.xyz = hlslcc_mtx4x4unity_WorldToShadow[4].xyz * u_xlat0.xxx + u_xlat5.xyz;
    u_xlat5.xyz = hlslcc_mtx4x4unity_WorldToShadow[6].xyz * u_xlat0.zzz + u_xlat5.xyz;
    u_xlat5.xyz = hlslcc_mtx4x4unity_WorldToShadow[7].xyz * u_xlat0.www + u_xlat5.xyz;
    u_xlat5.xyz = u_xlat16_3.xxx * u_xlat5.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[3].xyz * u_xlat0.www + u_xlat2.xyz;
    u_xlat1.xyz = u_xlat2.xyz * u_xlat1.xxx + u_xlat5.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[9].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[8].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[10].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[11].xyz * u_xlat0.www + u_xlat2.xyz;
    u_xlat1.xyz = u_xlat2.xyz * u_xlat16_3.yyy + u_xlat1.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[13].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[12].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[14].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[15].xyz * u_xlat0.www + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_3.zzz + u_xlat1.xyz;
    vec3 txVec0 = vec3(u_xlat0.xy,u_xlat0.z);
    u_xlat10_0 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_3.x = (-_LightShadowData.x) + 1.0;
    SV_Target0 = vec4(u_xlat10_0) * u_xlat16_3.xxxx + _LightShadowData.xxxx;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "SHADOWS_SINGLE_CASCADE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec3 orthoPosFar_1;
  highp vec3 orthoPosNear_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _glesVertex.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  clipPos_3.xzw = tmpvar_5.xzw;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 o_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_5.zw;
  tmpvar_4.zw = o_7.xy;
  clipPos_3.y = (tmpvar_5.y * _ProjectionParams.x);
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(-1.0, 1.0);
  tmpvar_10.xy = clipPos_3.xy;
  highp vec3 tmpvar_11;
  tmpvar_11 = (unity_CameraInvProjection * tmpvar_10).xyz;
  orthoPosNear_2.xy = tmpvar_11.xy;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(1.0, 1.0);
  tmpvar_12.xy = clipPos_3.xy;
  highp vec3 tmpvar_13;
  tmpvar_13 = (unity_CameraInvProjection * tmpvar_12).xyz;
  orthoPosFar_1.xy = tmpvar_13.xy;
  orthoPosNear_2.z = -(tmpvar_11.z);
  orthoPosFar_1.z = -(tmpvar_13.z);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = _glesMultiTexCoord1.xyz;
  xlv_TEXCOORD2 = orthoPosNear_2;
  xlv_TEXCOORD3 = orthoPosFar_1;
}


#endif
#ifdef FRAGMENT
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_OrthoParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _ShadowMapTexture;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  lowp float shadow_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_CameraDepthTexture, xlv_TEXCOORD0.xy);
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = mix ((xlv_TEXCOORD1 * mix (
    (1.0/(((_ZBufferParams.x * tmpvar_2.x) + _ZBufferParams.y)))
  , tmpvar_2.x, unity_OrthoParams.w)), mix (xlv_TEXCOORD2, xlv_TEXCOORD3, tmpvar_2.xxx), unity_OrthoParams.www);
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = (unity_WorldToShadow[0] * (unity_CameraToWorld * tmpvar_3)).xyz;
  highp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_ShadowMapTexture, tmpvar_4.xy);
  lowp float tmpvar_6;
  if ((tmpvar_5.x < tmpvar_4.z)) {
    tmpvar_6 = 0.0;
  } else {
    tmpvar_6 = 1.0;
  };
  mediump float tmpvar_7;
  tmpvar_7 = mix (_LightShadowData.x, 1.0, tmpvar_6);
  shadow_1 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = vec4(shadow_1);
  gl_FragData[0] = tmpvar_8;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "SHADOWS_SINGLE_CASCADE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec3 orthoPosFar_1;
  highp vec3 orthoPosNear_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _glesVertex.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  clipPos_3.xzw = tmpvar_5.xzw;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 o_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_5.zw;
  tmpvar_4.zw = o_7.xy;
  clipPos_3.y = (tmpvar_5.y * _ProjectionParams.x);
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(-1.0, 1.0);
  tmpvar_10.xy = clipPos_3.xy;
  highp vec3 tmpvar_11;
  tmpvar_11 = (unity_CameraInvProjection * tmpvar_10).xyz;
  orthoPosNear_2.xy = tmpvar_11.xy;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(1.0, 1.0);
  tmpvar_12.xy = clipPos_3.xy;
  highp vec3 tmpvar_13;
  tmpvar_13 = (unity_CameraInvProjection * tmpvar_12).xyz;
  orthoPosFar_1.xy = tmpvar_13.xy;
  orthoPosNear_2.z = -(tmpvar_11.z);
  orthoPosFar_1.z = -(tmpvar_13.z);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = _glesMultiTexCoord1.xyz;
  xlv_TEXCOORD2 = orthoPosNear_2;
  xlv_TEXCOORD3 = orthoPosFar_1;
}


#endif
#ifdef FRAGMENT
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_OrthoParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _ShadowMapTexture;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  lowp float shadow_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_CameraDepthTexture, xlv_TEXCOORD0.xy);
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = mix ((xlv_TEXCOORD1 * mix (
    (1.0/(((_ZBufferParams.x * tmpvar_2.x) + _ZBufferParams.y)))
  , tmpvar_2.x, unity_OrthoParams.w)), mix (xlv_TEXCOORD2, xlv_TEXCOORD3, tmpvar_2.xxx), unity_OrthoParams.www);
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = (unity_WorldToShadow[0] * (unity_CameraToWorld * tmpvar_3)).xyz;
  highp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_ShadowMapTexture, tmpvar_4.xy);
  lowp float tmpvar_6;
  if ((tmpvar_5.x < tmpvar_4.z)) {
    tmpvar_6 = 0.0;
  } else {
    tmpvar_6 = 1.0;
  };
  mediump float tmpvar_7;
  tmpvar_7 = mix (_LightShadowData.x, 1.0, tmpvar_6);
  shadow_1 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = vec4(shadow_1);
  gl_FragData[0] = tmpvar_8;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "SHADOWS_SINGLE_CASCADE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec3 orthoPosFar_1;
  highp vec3 orthoPosNear_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _glesVertex.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  clipPos_3.xzw = tmpvar_5.xzw;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 o_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_5.zw;
  tmpvar_4.zw = o_7.xy;
  clipPos_3.y = (tmpvar_5.y * _ProjectionParams.x);
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(-1.0, 1.0);
  tmpvar_10.xy = clipPos_3.xy;
  highp vec3 tmpvar_11;
  tmpvar_11 = (unity_CameraInvProjection * tmpvar_10).xyz;
  orthoPosNear_2.xy = tmpvar_11.xy;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(1.0, 1.0);
  tmpvar_12.xy = clipPos_3.xy;
  highp vec3 tmpvar_13;
  tmpvar_13 = (unity_CameraInvProjection * tmpvar_12).xyz;
  orthoPosFar_1.xy = tmpvar_13.xy;
  orthoPosNear_2.z = -(tmpvar_11.z);
  orthoPosFar_1.z = -(tmpvar_13.z);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = _glesMultiTexCoord1.xyz;
  xlv_TEXCOORD2 = orthoPosNear_2;
  xlv_TEXCOORD3 = orthoPosFar_1;
}


#endif
#ifdef FRAGMENT
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_OrthoParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _ShadowMapTexture;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  lowp float shadow_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_CameraDepthTexture, xlv_TEXCOORD0.xy);
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = mix ((xlv_TEXCOORD1 * mix (
    (1.0/(((_ZBufferParams.x * tmpvar_2.x) + _ZBufferParams.y)))
  , tmpvar_2.x, unity_OrthoParams.w)), mix (xlv_TEXCOORD2, xlv_TEXCOORD3, tmpvar_2.xxx), unity_OrthoParams.www);
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = (unity_WorldToShadow[0] * (unity_CameraToWorld * tmpvar_3)).xyz;
  highp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_ShadowMapTexture, tmpvar_4.xy);
  lowp float tmpvar_6;
  if ((tmpvar_5.x < tmpvar_4.z)) {
    tmpvar_6 = 0.0;
  } else {
    tmpvar_6 = 1.0;
  };
  mediump float tmpvar_7;
  tmpvar_7 = mix (_LightShadowData.x, 1.0, tmpvar_6);
  shadow_1 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = vec4(shadow_1);
  gl_FragData[0] = tmpvar_8;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SHADOWS_SINGLE_CASCADE" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
in highp vec3 in_TEXCOORD1;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
out highp vec3 vs_TEXCOORD2;
out highp vec3 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
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
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraInvProjection[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraInvProjection[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    vs_TEXCOORD0.zw = u_xlat1.zz + u_xlat1.xw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    vs_TEXCOORD1.xyz = in_TEXCOORD1.xyz;
    u_xlat1.xyz = u_xlat0.xyz + (-hlslcc_mtx4x4unity_CameraInvProjection[2].xyz);
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[2].xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.w = (-u_xlat1.z);
    vs_TEXCOORD2.xyz = u_xlat1.xyw;
    u_xlat0.w = (-u_xlat0.z);
    vs_TEXCOORD3.xyz = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 unity_OrthoParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
in highp vec3 vs_TEXCOORD2;
in highp vec3 vs_TEXCOORD3;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
lowp float u_xlat10_0;
vec4 u_xlat1;
mediump float u_xlat16_2;
float u_xlat3;
float u_xlat6;
void main()
{
    u_xlat0.x = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat3 = _ZBufferParams.x * u_xlat0.x + _ZBufferParams.y;
    u_xlat3 = float(1.0) / u_xlat3;
    u_xlat6 = (-u_xlat3) + u_xlat0.x;
    u_xlat3 = unity_OrthoParams.w * u_xlat6 + u_xlat3;
    u_xlat1.xyz = (-vs_TEXCOORD2.xyz) + vs_TEXCOORD3.xyz;
    u_xlat0.xzw = u_xlat0.xxx * u_xlat1.xyz + vs_TEXCOORD2.xyz;
    u_xlat0.xzw = (-vs_TEXCOORD1.xyz) * vec3(u_xlat3) + u_xlat0.xzw;
    u_xlat1.xyz = vec3(u_xlat3) * vs_TEXCOORD1.xyz;
    u_xlat0.xyz = unity_OrthoParams.www * u_xlat0.xzw + u_xlat1.xyz;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat1.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[3].xyz * u_xlat0.www + u_xlat0.xyz;
    vec3 txVec0 = vec3(u_xlat0.xy,u_xlat0.z);
    u_xlat10_0 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_2 = (-_LightShadowData.x) + 1.0;
    SV_Target0 = vec4(u_xlat10_0) * vec4(u_xlat16_2) + _LightShadowData.xxxx;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SHADOWS_SINGLE_CASCADE" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
in highp vec3 in_TEXCOORD1;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
out highp vec3 vs_TEXCOORD2;
out highp vec3 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
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
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraInvProjection[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraInvProjection[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    vs_TEXCOORD0.zw = u_xlat1.zz + u_xlat1.xw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    vs_TEXCOORD1.xyz = in_TEXCOORD1.xyz;
    u_xlat1.xyz = u_xlat0.xyz + (-hlslcc_mtx4x4unity_CameraInvProjection[2].xyz);
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[2].xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.w = (-u_xlat1.z);
    vs_TEXCOORD2.xyz = u_xlat1.xyw;
    u_xlat0.w = (-u_xlat0.z);
    vs_TEXCOORD3.xyz = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 unity_OrthoParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
in highp vec3 vs_TEXCOORD2;
in highp vec3 vs_TEXCOORD3;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
lowp float u_xlat10_0;
vec4 u_xlat1;
mediump float u_xlat16_2;
float u_xlat3;
float u_xlat6;
void main()
{
    u_xlat0.x = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat3 = _ZBufferParams.x * u_xlat0.x + _ZBufferParams.y;
    u_xlat3 = float(1.0) / u_xlat3;
    u_xlat6 = (-u_xlat3) + u_xlat0.x;
    u_xlat3 = unity_OrthoParams.w * u_xlat6 + u_xlat3;
    u_xlat1.xyz = (-vs_TEXCOORD2.xyz) + vs_TEXCOORD3.xyz;
    u_xlat0.xzw = u_xlat0.xxx * u_xlat1.xyz + vs_TEXCOORD2.xyz;
    u_xlat0.xzw = (-vs_TEXCOORD1.xyz) * vec3(u_xlat3) + u_xlat0.xzw;
    u_xlat1.xyz = vec3(u_xlat3) * vs_TEXCOORD1.xyz;
    u_xlat0.xyz = unity_OrthoParams.www * u_xlat0.xzw + u_xlat1.xyz;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat1.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[3].xyz * u_xlat0.www + u_xlat0.xyz;
    vec3 txVec0 = vec3(u_xlat0.xy,u_xlat0.z);
    u_xlat10_0 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_2 = (-_LightShadowData.x) + 1.0;
    SV_Target0 = vec4(u_xlat10_0) * vec4(u_xlat16_2) + _LightShadowData.xxxx;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SHADOWS_SINGLE_CASCADE" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
in highp vec3 in_TEXCOORD1;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
out highp vec3 vs_TEXCOORD2;
out highp vec3 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
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
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraInvProjection[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraInvProjection[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    vs_TEXCOORD0.zw = u_xlat1.zz + u_xlat1.xw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    vs_TEXCOORD1.xyz = in_TEXCOORD1.xyz;
    u_xlat1.xyz = u_xlat0.xyz + (-hlslcc_mtx4x4unity_CameraInvProjection[2].xyz);
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[2].xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.w = (-u_xlat1.z);
    vs_TEXCOORD2.xyz = u_xlat1.xyw;
    u_xlat0.w = (-u_xlat0.z);
    vs_TEXCOORD3.xyz = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 unity_OrthoParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
in highp vec3 vs_TEXCOORD2;
in highp vec3 vs_TEXCOORD3;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
lowp float u_xlat10_0;
vec4 u_xlat1;
mediump float u_xlat16_2;
float u_xlat3;
float u_xlat6;
void main()
{
    u_xlat0.x = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat3 = _ZBufferParams.x * u_xlat0.x + _ZBufferParams.y;
    u_xlat3 = float(1.0) / u_xlat3;
    u_xlat6 = (-u_xlat3) + u_xlat0.x;
    u_xlat3 = unity_OrthoParams.w * u_xlat6 + u_xlat3;
    u_xlat1.xyz = (-vs_TEXCOORD2.xyz) + vs_TEXCOORD3.xyz;
    u_xlat0.xzw = u_xlat0.xxx * u_xlat1.xyz + vs_TEXCOORD2.xyz;
    u_xlat0.xzw = (-vs_TEXCOORD1.xyz) * vec3(u_xlat3) + u_xlat0.xzw;
    u_xlat1.xyz = vec3(u_xlat3) * vs_TEXCOORD1.xyz;
    u_xlat0.xyz = unity_OrthoParams.www * u_xlat0.xzw + u_xlat1.xyz;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat1.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[3].xyz * u_xlat0.www + u_xlat0.xyz;
    vec3 txVec0 = vec3(u_xlat0.xy,u_xlat0.z);
    u_xlat10_0 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_2 = (-_LightShadowData.x) + 1.0;
    SV_Target0 = vec4(u_xlat10_0) * vec4(u_xlat16_2) + _LightShadowData.xxxx;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec3 orthoPosFar_1;
  highp vec3 orthoPosNear_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _glesVertex.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  clipPos_3.xzw = tmpvar_5.xzw;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 o_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_5.zw;
  tmpvar_4.zw = o_7.xy;
  clipPos_3.y = (tmpvar_5.y * _ProjectionParams.x);
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(-1.0, 1.0);
  tmpvar_10.xy = clipPos_3.xy;
  highp vec3 tmpvar_11;
  tmpvar_11 = (unity_CameraInvProjection * tmpvar_10).xyz;
  orthoPosNear_2.xy = tmpvar_11.xy;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(1.0, 1.0);
  tmpvar_12.xy = clipPos_3.xy;
  highp vec3 tmpvar_13;
  tmpvar_13 = (unity_CameraInvProjection * tmpvar_12).xyz;
  orthoPosFar_1.xy = tmpvar_13.xy;
  orthoPosNear_2.z = -(tmpvar_11.z);
  orthoPosFar_1.z = -(tmpvar_13.z);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = _glesMultiTexCoord1.xyz;
  xlv_TEXCOORD2 = orthoPosNear_2;
  xlv_TEXCOORD3 = orthoPosFar_1;
}


#endif
#ifdef FRAGMENT
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_OrthoParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _ShadowMapTexture;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  lowp float shadow_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_CameraDepthTexture, xlv_TEXCOORD0.xy);
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = mix ((xlv_TEXCOORD1 * mix (
    (1.0/(((_ZBufferParams.x * tmpvar_2.x) + _ZBufferParams.y)))
  , tmpvar_2.x, unity_OrthoParams.w)), mix (xlv_TEXCOORD2, xlv_TEXCOORD3, tmpvar_2.xxx), unity_OrthoParams.www);
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = (unity_WorldToShadow[0] * (unity_CameraToWorld * tmpvar_3)).xyz;
  highp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_ShadowMapTexture, tmpvar_4.xy);
  lowp float tmpvar_6;
  if ((tmpvar_5.x < tmpvar_4.z)) {
    tmpvar_6 = 0.0;
  } else {
    tmpvar_6 = 1.0;
  };
  mediump float tmpvar_7;
  tmpvar_7 = mix (_LightShadowData.x, 1.0, tmpvar_6);
  shadow_1 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = vec4(shadow_1);
  gl_FragData[0] = tmpvar_8;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec3 orthoPosFar_1;
  highp vec3 orthoPosNear_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _glesVertex.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  clipPos_3.xzw = tmpvar_5.xzw;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 o_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_5.zw;
  tmpvar_4.zw = o_7.xy;
  clipPos_3.y = (tmpvar_5.y * _ProjectionParams.x);
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(-1.0, 1.0);
  tmpvar_10.xy = clipPos_3.xy;
  highp vec3 tmpvar_11;
  tmpvar_11 = (unity_CameraInvProjection * tmpvar_10).xyz;
  orthoPosNear_2.xy = tmpvar_11.xy;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(1.0, 1.0);
  tmpvar_12.xy = clipPos_3.xy;
  highp vec3 tmpvar_13;
  tmpvar_13 = (unity_CameraInvProjection * tmpvar_12).xyz;
  orthoPosFar_1.xy = tmpvar_13.xy;
  orthoPosNear_2.z = -(tmpvar_11.z);
  orthoPosFar_1.z = -(tmpvar_13.z);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = _glesMultiTexCoord1.xyz;
  xlv_TEXCOORD2 = orthoPosNear_2;
  xlv_TEXCOORD3 = orthoPosFar_1;
}


#endif
#ifdef FRAGMENT
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_OrthoParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _ShadowMapTexture;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  lowp float shadow_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_CameraDepthTexture, xlv_TEXCOORD0.xy);
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = mix ((xlv_TEXCOORD1 * mix (
    (1.0/(((_ZBufferParams.x * tmpvar_2.x) + _ZBufferParams.y)))
  , tmpvar_2.x, unity_OrthoParams.w)), mix (xlv_TEXCOORD2, xlv_TEXCOORD3, tmpvar_2.xxx), unity_OrthoParams.www);
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = (unity_WorldToShadow[0] * (unity_CameraToWorld * tmpvar_3)).xyz;
  highp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_ShadowMapTexture, tmpvar_4.xy);
  lowp float tmpvar_6;
  if ((tmpvar_5.x < tmpvar_4.z)) {
    tmpvar_6 = 0.0;
  } else {
    tmpvar_6 = 1.0;
  };
  mediump float tmpvar_7;
  tmpvar_7 = mix (_LightShadowData.x, 1.0, tmpvar_6);
  shadow_1 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = vec4(shadow_1);
  gl_FragData[0] = tmpvar_8;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec3 orthoPosFar_1;
  highp vec3 orthoPosNear_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _glesVertex.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  clipPos_3.xzw = tmpvar_5.xzw;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 o_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_5.zw;
  tmpvar_4.zw = o_7.xy;
  clipPos_3.y = (tmpvar_5.y * _ProjectionParams.x);
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(-1.0, 1.0);
  tmpvar_10.xy = clipPos_3.xy;
  highp vec3 tmpvar_11;
  tmpvar_11 = (unity_CameraInvProjection * tmpvar_10).xyz;
  orthoPosNear_2.xy = tmpvar_11.xy;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(1.0, 1.0);
  tmpvar_12.xy = clipPos_3.xy;
  highp vec3 tmpvar_13;
  tmpvar_13 = (unity_CameraInvProjection * tmpvar_12).xyz;
  orthoPosFar_1.xy = tmpvar_13.xy;
  orthoPosNear_2.z = -(tmpvar_11.z);
  orthoPosFar_1.z = -(tmpvar_13.z);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = _glesMultiTexCoord1.xyz;
  xlv_TEXCOORD2 = orthoPosNear_2;
  xlv_TEXCOORD3 = orthoPosFar_1;
}


#endif
#ifdef FRAGMENT
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_OrthoParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _ShadowMapTexture;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  lowp float shadow_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_CameraDepthTexture, xlv_TEXCOORD0.xy);
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = mix ((xlv_TEXCOORD1 * mix (
    (1.0/(((_ZBufferParams.x * tmpvar_2.x) + _ZBufferParams.y)))
  , tmpvar_2.x, unity_OrthoParams.w)), mix (xlv_TEXCOORD2, xlv_TEXCOORD3, tmpvar_2.xxx), unity_OrthoParams.www);
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = (unity_WorldToShadow[0] * (unity_CameraToWorld * tmpvar_3)).xyz;
  highp vec4 tmpvar_5;
  tmpvar_5 = texture2D (_ShadowMapTexture, tmpvar_4.xy);
  lowp float tmpvar_6;
  if ((tmpvar_5.x < tmpvar_4.z)) {
    tmpvar_6 = 0.0;
  } else {
    tmpvar_6 = 1.0;
  };
  mediump float tmpvar_7;
  tmpvar_7 = mix (_LightShadowData.x, 1.0, tmpvar_6);
  shadow_1 = tmpvar_7;
  lowp vec4 tmpvar_8;
  tmpvar_8 = vec4(shadow_1);
  gl_FragData[0] = tmpvar_8;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
in highp vec3 in_TEXCOORD1;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
out highp vec3 vs_TEXCOORD2;
out highp vec3 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
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
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraInvProjection[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraInvProjection[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    vs_TEXCOORD0.zw = u_xlat1.zz + u_xlat1.xw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    vs_TEXCOORD1.xyz = in_TEXCOORD1.xyz;
    u_xlat1.xyz = u_xlat0.xyz + (-hlslcc_mtx4x4unity_CameraInvProjection[2].xyz);
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[2].xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.w = (-u_xlat1.z);
    vs_TEXCOORD2.xyz = u_xlat1.xyw;
    u_xlat0.w = (-u_xlat0.z);
    vs_TEXCOORD3.xyz = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 unity_OrthoParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
in highp vec3 vs_TEXCOORD2;
in highp vec3 vs_TEXCOORD3;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
lowp float u_xlat10_0;
vec4 u_xlat1;
mediump float u_xlat16_2;
float u_xlat3;
float u_xlat6;
void main()
{
    u_xlat0.x = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat3 = _ZBufferParams.x * u_xlat0.x + _ZBufferParams.y;
    u_xlat3 = float(1.0) / u_xlat3;
    u_xlat6 = (-u_xlat3) + u_xlat0.x;
    u_xlat3 = unity_OrthoParams.w * u_xlat6 + u_xlat3;
    u_xlat1.xyz = (-vs_TEXCOORD2.xyz) + vs_TEXCOORD3.xyz;
    u_xlat0.xzw = u_xlat0.xxx * u_xlat1.xyz + vs_TEXCOORD2.xyz;
    u_xlat0.xzw = (-vs_TEXCOORD1.xyz) * vec3(u_xlat3) + u_xlat0.xzw;
    u_xlat1.xyz = vec3(u_xlat3) * vs_TEXCOORD1.xyz;
    u_xlat0.xyz = unity_OrthoParams.www * u_xlat0.xzw + u_xlat1.xyz;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat1.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[3].xyz * u_xlat0.www + u_xlat0.xyz;
    vec3 txVec0 = vec3(u_xlat0.xy,u_xlat0.z);
    u_xlat10_0 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_2 = (-_LightShadowData.x) + 1.0;
    SV_Target0 = vec4(u_xlat10_0) * vec4(u_xlat16_2) + _LightShadowData.xxxx;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
in highp vec3 in_TEXCOORD1;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
out highp vec3 vs_TEXCOORD2;
out highp vec3 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
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
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraInvProjection[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraInvProjection[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    vs_TEXCOORD0.zw = u_xlat1.zz + u_xlat1.xw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    vs_TEXCOORD1.xyz = in_TEXCOORD1.xyz;
    u_xlat1.xyz = u_xlat0.xyz + (-hlslcc_mtx4x4unity_CameraInvProjection[2].xyz);
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[2].xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.w = (-u_xlat1.z);
    vs_TEXCOORD2.xyz = u_xlat1.xyw;
    u_xlat0.w = (-u_xlat0.z);
    vs_TEXCOORD3.xyz = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 unity_OrthoParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
in highp vec3 vs_TEXCOORD2;
in highp vec3 vs_TEXCOORD3;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
lowp float u_xlat10_0;
vec4 u_xlat1;
mediump float u_xlat16_2;
float u_xlat3;
float u_xlat6;
void main()
{
    u_xlat0.x = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat3 = _ZBufferParams.x * u_xlat0.x + _ZBufferParams.y;
    u_xlat3 = float(1.0) / u_xlat3;
    u_xlat6 = (-u_xlat3) + u_xlat0.x;
    u_xlat3 = unity_OrthoParams.w * u_xlat6 + u_xlat3;
    u_xlat1.xyz = (-vs_TEXCOORD2.xyz) + vs_TEXCOORD3.xyz;
    u_xlat0.xzw = u_xlat0.xxx * u_xlat1.xyz + vs_TEXCOORD2.xyz;
    u_xlat0.xzw = (-vs_TEXCOORD1.xyz) * vec3(u_xlat3) + u_xlat0.xzw;
    u_xlat1.xyz = vec3(u_xlat3) * vs_TEXCOORD1.xyz;
    u_xlat0.xyz = unity_OrthoParams.www * u_xlat0.xzw + u_xlat1.xyz;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat1.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[3].xyz * u_xlat0.www + u_xlat0.xyz;
    vec3 txVec0 = vec3(u_xlat0.xy,u_xlat0.z);
    u_xlat10_0 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_2 = (-_LightShadowData.x) + 1.0;
    SV_Target0 = vec4(u_xlat10_0) * vec4(u_xlat16_2) + _LightShadowData.xxxx;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
in highp vec3 in_TEXCOORD1;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
out highp vec3 vs_TEXCOORD2;
out highp vec3 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
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
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraInvProjection[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraInvProjection[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    vs_TEXCOORD0.zw = u_xlat1.zz + u_xlat1.xw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    vs_TEXCOORD1.xyz = in_TEXCOORD1.xyz;
    u_xlat1.xyz = u_xlat0.xyz + (-hlslcc_mtx4x4unity_CameraInvProjection[2].xyz);
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[2].xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.w = (-u_xlat1.z);
    vs_TEXCOORD2.xyz = u_xlat1.xyw;
    u_xlat0.w = (-u_xlat0.z);
    vs_TEXCOORD3.xyz = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 unity_OrthoParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
in highp vec3 vs_TEXCOORD2;
in highp vec3 vs_TEXCOORD3;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
lowp float u_xlat10_0;
vec4 u_xlat1;
mediump float u_xlat16_2;
float u_xlat3;
float u_xlat6;
void main()
{
    u_xlat0.x = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat3 = _ZBufferParams.x * u_xlat0.x + _ZBufferParams.y;
    u_xlat3 = float(1.0) / u_xlat3;
    u_xlat6 = (-u_xlat3) + u_xlat0.x;
    u_xlat3 = unity_OrthoParams.w * u_xlat6 + u_xlat3;
    u_xlat1.xyz = (-vs_TEXCOORD2.xyz) + vs_TEXCOORD3.xyz;
    u_xlat0.xzw = u_xlat0.xxx * u_xlat1.xyz + vs_TEXCOORD2.xyz;
    u_xlat0.xzw = (-vs_TEXCOORD1.xyz) * vec3(u_xlat3) + u_xlat0.xzw;
    u_xlat1.xyz = vec3(u_xlat3) * vs_TEXCOORD1.xyz;
    u_xlat0.xyz = unity_OrthoParams.www * u_xlat0.xzw + u_xlat1.xyz;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat1.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[3].xyz * u_xlat0.www + u_xlat0.xyz;
    vec3 txVec0 = vec3(u_xlat0.xy,u_xlat0.z);
    u_xlat10_0 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_2 = (-_LightShadowData.x) + 1.0;
    SV_Target0 = vec4(u_xlat10_0) * vec4(u_xlat16_2) + _LightShadowData.xxxx;
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
Keywords { "SHADOWS_SPLIT_SPHERES" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "SHADOWS_SPLIT_SPHERES" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "SHADOWS_SPLIT_SPHERES" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SHADOWS_SPLIT_SPHERES" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SHADOWS_SPLIT_SPHERES" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SHADOWS_SPLIT_SPHERES" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "SHADOWS_SINGLE_CASCADE" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "SHADOWS_SINGLE_CASCADE" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "SHADOWS_SINGLE_CASCADE" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SHADOWS_SINGLE_CASCADE" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SHADOWS_SINGLE_CASCADE" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SHADOWS_SINGLE_CASCADE" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" }
""
}
}
}
}
SubShader {
 Tags { "ShadowmapFilter" = "HardShadow_FORCE_INV_PROJECTION_IN_PS" }
 Pass {
  Tags { "ShadowmapFilter" = "HardShadow_FORCE_INV_PROJECTION_IN_PS" }
  ZTest Always
  ZWrite Off
  Cull Off
  GpuProgramID 88231
Program "vp" {
SubProgram "gles hw_tier00 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec3 orthoPosFar_1;
  highp vec3 orthoPosNear_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _glesVertex.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  clipPos_3.xzw = tmpvar_5.xzw;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 o_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_5.zw;
  tmpvar_4.zw = o_7.xy;
  clipPos_3.y = (tmpvar_5.y * _ProjectionParams.x);
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(-1.0, 1.0);
  tmpvar_10.xy = clipPos_3.xy;
  highp vec3 tmpvar_11;
  tmpvar_11 = (unity_CameraInvProjection * tmpvar_10).xyz;
  orthoPosNear_2.xy = tmpvar_11.xy;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(1.0, 1.0);
  tmpvar_12.xy = clipPos_3.xy;
  highp vec3 tmpvar_13;
  tmpvar_13 = (unity_CameraInvProjection * tmpvar_12).xyz;
  orthoPosFar_1.xy = tmpvar_13.xy;
  orthoPosNear_2.z = -(tmpvar_11.z);
  orthoPosFar_1.z = -(tmpvar_13.z);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = _glesMultiTexCoord1.xyz;
  xlv_TEXCOORD2 = orthoPosNear_2;
  xlv_TEXCOORD3 = orthoPosFar_1;
}


#endif
#ifdef FRAGMENT
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _ShadowMapTexture;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec4 xlv_TEXCOORD0;
void main ()
{
  lowp float shadow_1;
  highp vec4 camPos_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xy = xlv_TEXCOORD0.zw;
  tmpvar_4.z = texture2D (_CameraDepthTexture, xlv_TEXCOORD0.xy).x;
  clipPos_3.w = tmpvar_4.w;
  clipPos_3.xyz = ((2.0 * tmpvar_4.xyz) - 1.0);
  highp vec4 tmpvar_5;
  tmpvar_5 = (unity_CameraInvProjection * clipPos_3);
  camPos_2.w = tmpvar_5.w;
  camPos_2.xyz = (tmpvar_5.xyz / tmpvar_5.w);
  camPos_2.z = -(camPos_2.z);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = camPos_2.xyz;
  highp vec4 tmpvar_7;
  tmpvar_7 = (unity_CameraToWorld * tmpvar_6);
  bvec4 tmpvar_8;
  tmpvar_8 = greaterThanEqual (camPos_2.zzzz, _LightSplitsNear);
  bvec4 tmpvar_9;
  tmpvar_9 = lessThan (camPos_2.zzzz, _LightSplitsFar);
  lowp vec4 tmpvar_10;
  tmpvar_10 = (vec4(tmpvar_8) * vec4(tmpvar_9));
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = (((
    ((unity_WorldToShadow[0] * tmpvar_7).xyz * tmpvar_10.x)
   + 
    ((unity_WorldToShadow[1] * tmpvar_7).xyz * tmpvar_10.y)
  ) + (
    (unity_WorldToShadow[2] * tmpvar_7)
  .xyz * tmpvar_10.z)) + ((unity_WorldToShadow[3] * tmpvar_7).xyz * tmpvar_10.w));
  highp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_ShadowMapTexture, tmpvar_11.xy);
  lowp float tmpvar_13;
  if ((tmpvar_12.x < tmpvar_11.z)) {
    tmpvar_13 = 0.0;
  } else {
    tmpvar_13 = 1.0;
  };
  mediump float tmpvar_14;
  tmpvar_14 = mix (_LightShadowData.x, 1.0, tmpvar_13);
  shadow_1 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = vec4(shadow_1);
  gl_FragData[0] = tmpvar_15;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec3 orthoPosFar_1;
  highp vec3 orthoPosNear_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _glesVertex.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  clipPos_3.xzw = tmpvar_5.xzw;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 o_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_5.zw;
  tmpvar_4.zw = o_7.xy;
  clipPos_3.y = (tmpvar_5.y * _ProjectionParams.x);
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(-1.0, 1.0);
  tmpvar_10.xy = clipPos_3.xy;
  highp vec3 tmpvar_11;
  tmpvar_11 = (unity_CameraInvProjection * tmpvar_10).xyz;
  orthoPosNear_2.xy = tmpvar_11.xy;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(1.0, 1.0);
  tmpvar_12.xy = clipPos_3.xy;
  highp vec3 tmpvar_13;
  tmpvar_13 = (unity_CameraInvProjection * tmpvar_12).xyz;
  orthoPosFar_1.xy = tmpvar_13.xy;
  orthoPosNear_2.z = -(tmpvar_11.z);
  orthoPosFar_1.z = -(tmpvar_13.z);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = _glesMultiTexCoord1.xyz;
  xlv_TEXCOORD2 = orthoPosNear_2;
  xlv_TEXCOORD3 = orthoPosFar_1;
}


#endif
#ifdef FRAGMENT
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _ShadowMapTexture;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec4 xlv_TEXCOORD0;
void main ()
{
  lowp float shadow_1;
  highp vec4 camPos_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xy = xlv_TEXCOORD0.zw;
  tmpvar_4.z = texture2D (_CameraDepthTexture, xlv_TEXCOORD0.xy).x;
  clipPos_3.w = tmpvar_4.w;
  clipPos_3.xyz = ((2.0 * tmpvar_4.xyz) - 1.0);
  highp vec4 tmpvar_5;
  tmpvar_5 = (unity_CameraInvProjection * clipPos_3);
  camPos_2.w = tmpvar_5.w;
  camPos_2.xyz = (tmpvar_5.xyz / tmpvar_5.w);
  camPos_2.z = -(camPos_2.z);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = camPos_2.xyz;
  highp vec4 tmpvar_7;
  tmpvar_7 = (unity_CameraToWorld * tmpvar_6);
  bvec4 tmpvar_8;
  tmpvar_8 = greaterThanEqual (camPos_2.zzzz, _LightSplitsNear);
  bvec4 tmpvar_9;
  tmpvar_9 = lessThan (camPos_2.zzzz, _LightSplitsFar);
  lowp vec4 tmpvar_10;
  tmpvar_10 = (vec4(tmpvar_8) * vec4(tmpvar_9));
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = (((
    ((unity_WorldToShadow[0] * tmpvar_7).xyz * tmpvar_10.x)
   + 
    ((unity_WorldToShadow[1] * tmpvar_7).xyz * tmpvar_10.y)
  ) + (
    (unity_WorldToShadow[2] * tmpvar_7)
  .xyz * tmpvar_10.z)) + ((unity_WorldToShadow[3] * tmpvar_7).xyz * tmpvar_10.w));
  highp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_ShadowMapTexture, tmpvar_11.xy);
  lowp float tmpvar_13;
  if ((tmpvar_12.x < tmpvar_11.z)) {
    tmpvar_13 = 0.0;
  } else {
    tmpvar_13 = 1.0;
  };
  mediump float tmpvar_14;
  tmpvar_14 = mix (_LightShadowData.x, 1.0, tmpvar_13);
  shadow_1 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = vec4(shadow_1);
  gl_FragData[0] = tmpvar_15;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec3 orthoPosFar_1;
  highp vec3 orthoPosNear_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _glesVertex.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  clipPos_3.xzw = tmpvar_5.xzw;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 o_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_5.zw;
  tmpvar_4.zw = o_7.xy;
  clipPos_3.y = (tmpvar_5.y * _ProjectionParams.x);
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(-1.0, 1.0);
  tmpvar_10.xy = clipPos_3.xy;
  highp vec3 tmpvar_11;
  tmpvar_11 = (unity_CameraInvProjection * tmpvar_10).xyz;
  orthoPosNear_2.xy = tmpvar_11.xy;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(1.0, 1.0);
  tmpvar_12.xy = clipPos_3.xy;
  highp vec3 tmpvar_13;
  tmpvar_13 = (unity_CameraInvProjection * tmpvar_12).xyz;
  orthoPosFar_1.xy = tmpvar_13.xy;
  orthoPosNear_2.z = -(tmpvar_11.z);
  orthoPosFar_1.z = -(tmpvar_13.z);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = _glesMultiTexCoord1.xyz;
  xlv_TEXCOORD2 = orthoPosNear_2;
  xlv_TEXCOORD3 = orthoPosFar_1;
}


#endif
#ifdef FRAGMENT
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _ShadowMapTexture;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec4 xlv_TEXCOORD0;
void main ()
{
  lowp float shadow_1;
  highp vec4 camPos_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xy = xlv_TEXCOORD0.zw;
  tmpvar_4.z = texture2D (_CameraDepthTexture, xlv_TEXCOORD0.xy).x;
  clipPos_3.w = tmpvar_4.w;
  clipPos_3.xyz = ((2.0 * tmpvar_4.xyz) - 1.0);
  highp vec4 tmpvar_5;
  tmpvar_5 = (unity_CameraInvProjection * clipPos_3);
  camPos_2.w = tmpvar_5.w;
  camPos_2.xyz = (tmpvar_5.xyz / tmpvar_5.w);
  camPos_2.z = -(camPos_2.z);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = camPos_2.xyz;
  highp vec4 tmpvar_7;
  tmpvar_7 = (unity_CameraToWorld * tmpvar_6);
  bvec4 tmpvar_8;
  tmpvar_8 = greaterThanEqual (camPos_2.zzzz, _LightSplitsNear);
  bvec4 tmpvar_9;
  tmpvar_9 = lessThan (camPos_2.zzzz, _LightSplitsFar);
  lowp vec4 tmpvar_10;
  tmpvar_10 = (vec4(tmpvar_8) * vec4(tmpvar_9));
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = (((
    ((unity_WorldToShadow[0] * tmpvar_7).xyz * tmpvar_10.x)
   + 
    ((unity_WorldToShadow[1] * tmpvar_7).xyz * tmpvar_10.y)
  ) + (
    (unity_WorldToShadow[2] * tmpvar_7)
  .xyz * tmpvar_10.z)) + ((unity_WorldToShadow[3] * tmpvar_7).xyz * tmpvar_10.w));
  highp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_ShadowMapTexture, tmpvar_11.xy);
  lowp float tmpvar_13;
  if ((tmpvar_12.x < tmpvar_11.z)) {
    tmpvar_13 = 0.0;
  } else {
    tmpvar_13 = 1.0;
  };
  mediump float tmpvar_14;
  tmpvar_14 = mix (_LightShadowData.x, 1.0, tmpvar_13);
  shadow_1 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = vec4(shadow_1);
  gl_FragData[0] = tmpvar_15;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
in highp vec3 in_TEXCOORD1;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
out highp vec3 vs_TEXCOORD2;
out highp vec3 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
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
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraInvProjection[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraInvProjection[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    vs_TEXCOORD0.zw = u_xlat1.zz + u_xlat1.xw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    vs_TEXCOORD1.xyz = in_TEXCOORD1.xyz;
    u_xlat1.xyz = u_xlat0.xyz + (-hlslcc_mtx4x4unity_CameraInvProjection[2].xyz);
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[2].xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.w = (-u_xlat1.z);
    vs_TEXCOORD2.xyz = u_xlat1.xyw;
    u_xlat0.w = (-u_xlat0.z);
    vs_TEXCOORD3.xyz = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 _LightSplitsNear;
uniform 	vec4 _LightSplitsFar;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
lowp float u_xlat10_0;
vec4 u_xlat1;
mediump vec4 u_xlat16_1;
bvec4 u_xlatb1;
vec4 u_xlat2;
bvec4 u_xlatb2;
vec3 u_xlat3;
mediump float u_xlat16_4;
void main()
{
    u_xlat0.z = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat0.xy = vs_TEXCOORD0.zw;
    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraInvProjection[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraInvProjection[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraInvProjection[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraInvProjection[3];
    u_xlat0.xyz = u_xlat0.xyz / u_xlat0.www;
    u_xlatb1 = greaterThanEqual((-u_xlat0.zzzz), _LightSplitsNear);
    u_xlat1 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb1));
    u_xlatb2 = lessThan((-u_xlat0.zzzz), _LightSplitsFar);
    u_xlat2 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb2));
    u_xlat16_1 = u_xlat1 * u_xlat2;
    u_xlat2 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat2 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat2;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * (-u_xlat0.zzzz) + u_xlat2;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[5].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[4].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[6].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[7].xyz * u_xlat0.www + u_xlat2.xyz;
    u_xlat2.xyz = u_xlat16_1.yyy * u_xlat2.xyz;
    u_xlat3.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * u_xlat0.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * u_xlat0.zzz + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[3].xyz * u_xlat0.www + u_xlat3.xyz;
    u_xlat2.xyz = u_xlat3.xyz * u_xlat16_1.xxx + u_xlat2.xyz;
    u_xlat3.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[9].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[8].xyz * u_xlat0.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[10].xyz * u_xlat0.zzz + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[11].xyz * u_xlat0.www + u_xlat3.xyz;
    u_xlat2.xyz = u_xlat3.xyz * u_xlat16_1.zzz + u_xlat2.xyz;
    u_xlat3.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[13].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[12].xyz * u_xlat0.xxx + u_xlat3.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[14].xyz * u_xlat0.zzz + u_xlat3.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[15].xyz * u_xlat0.www + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www + u_xlat2.xyz;
    vec3 txVec0 = vec3(u_xlat0.xy,u_xlat0.z);
    u_xlat10_0 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_4 = (-_LightShadowData.x) + 1.0;
    SV_Target0 = vec4(u_xlat10_0) * vec4(u_xlat16_4) + _LightShadowData.xxxx;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
in highp vec3 in_TEXCOORD1;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
out highp vec3 vs_TEXCOORD2;
out highp vec3 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
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
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraInvProjection[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraInvProjection[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    vs_TEXCOORD0.zw = u_xlat1.zz + u_xlat1.xw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    vs_TEXCOORD1.xyz = in_TEXCOORD1.xyz;
    u_xlat1.xyz = u_xlat0.xyz + (-hlslcc_mtx4x4unity_CameraInvProjection[2].xyz);
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[2].xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.w = (-u_xlat1.z);
    vs_TEXCOORD2.xyz = u_xlat1.xyw;
    u_xlat0.w = (-u_xlat0.z);
    vs_TEXCOORD3.xyz = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 _LightSplitsNear;
uniform 	vec4 _LightSplitsFar;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
lowp float u_xlat10_0;
vec4 u_xlat1;
mediump vec4 u_xlat16_1;
bvec4 u_xlatb1;
vec4 u_xlat2;
bvec4 u_xlatb2;
vec3 u_xlat3;
mediump float u_xlat16_4;
void main()
{
    u_xlat0.z = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat0.xy = vs_TEXCOORD0.zw;
    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraInvProjection[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraInvProjection[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraInvProjection[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraInvProjection[3];
    u_xlat0.xyz = u_xlat0.xyz / u_xlat0.www;
    u_xlatb1 = greaterThanEqual((-u_xlat0.zzzz), _LightSplitsNear);
    u_xlat1 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb1));
    u_xlatb2 = lessThan((-u_xlat0.zzzz), _LightSplitsFar);
    u_xlat2 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb2));
    u_xlat16_1 = u_xlat1 * u_xlat2;
    u_xlat2 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat2 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat2;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * (-u_xlat0.zzzz) + u_xlat2;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[5].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[4].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[6].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[7].xyz * u_xlat0.www + u_xlat2.xyz;
    u_xlat2.xyz = u_xlat16_1.yyy * u_xlat2.xyz;
    u_xlat3.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * u_xlat0.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * u_xlat0.zzz + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[3].xyz * u_xlat0.www + u_xlat3.xyz;
    u_xlat2.xyz = u_xlat3.xyz * u_xlat16_1.xxx + u_xlat2.xyz;
    u_xlat3.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[9].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[8].xyz * u_xlat0.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[10].xyz * u_xlat0.zzz + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[11].xyz * u_xlat0.www + u_xlat3.xyz;
    u_xlat2.xyz = u_xlat3.xyz * u_xlat16_1.zzz + u_xlat2.xyz;
    u_xlat3.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[13].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[12].xyz * u_xlat0.xxx + u_xlat3.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[14].xyz * u_xlat0.zzz + u_xlat3.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[15].xyz * u_xlat0.www + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www + u_xlat2.xyz;
    vec3 txVec0 = vec3(u_xlat0.xy,u_xlat0.z);
    u_xlat10_0 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_4 = (-_LightShadowData.x) + 1.0;
    SV_Target0 = vec4(u_xlat10_0) * vec4(u_xlat16_4) + _LightShadowData.xxxx;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
in highp vec3 in_TEXCOORD1;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
out highp vec3 vs_TEXCOORD2;
out highp vec3 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
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
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraInvProjection[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraInvProjection[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    vs_TEXCOORD0.zw = u_xlat1.zz + u_xlat1.xw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    vs_TEXCOORD1.xyz = in_TEXCOORD1.xyz;
    u_xlat1.xyz = u_xlat0.xyz + (-hlslcc_mtx4x4unity_CameraInvProjection[2].xyz);
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[2].xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.w = (-u_xlat1.z);
    vs_TEXCOORD2.xyz = u_xlat1.xyw;
    u_xlat0.w = (-u_xlat0.z);
    vs_TEXCOORD3.xyz = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 _LightSplitsNear;
uniform 	vec4 _LightSplitsFar;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
lowp float u_xlat10_0;
vec4 u_xlat1;
mediump vec4 u_xlat16_1;
bvec4 u_xlatb1;
vec4 u_xlat2;
bvec4 u_xlatb2;
vec3 u_xlat3;
mediump float u_xlat16_4;
void main()
{
    u_xlat0.z = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat0.xy = vs_TEXCOORD0.zw;
    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraInvProjection[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraInvProjection[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraInvProjection[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraInvProjection[3];
    u_xlat0.xyz = u_xlat0.xyz / u_xlat0.www;
    u_xlatb1 = greaterThanEqual((-u_xlat0.zzzz), _LightSplitsNear);
    u_xlat1 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb1));
    u_xlatb2 = lessThan((-u_xlat0.zzzz), _LightSplitsFar);
    u_xlat2 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb2));
    u_xlat16_1 = u_xlat1 * u_xlat2;
    u_xlat2 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat2 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat2;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * (-u_xlat0.zzzz) + u_xlat2;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[5].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[4].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[6].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[7].xyz * u_xlat0.www + u_xlat2.xyz;
    u_xlat2.xyz = u_xlat16_1.yyy * u_xlat2.xyz;
    u_xlat3.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * u_xlat0.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * u_xlat0.zzz + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[3].xyz * u_xlat0.www + u_xlat3.xyz;
    u_xlat2.xyz = u_xlat3.xyz * u_xlat16_1.xxx + u_xlat2.xyz;
    u_xlat3.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[9].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[8].xyz * u_xlat0.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[10].xyz * u_xlat0.zzz + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[11].xyz * u_xlat0.www + u_xlat3.xyz;
    u_xlat2.xyz = u_xlat3.xyz * u_xlat16_1.zzz + u_xlat2.xyz;
    u_xlat3.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[13].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[12].xyz * u_xlat0.xxx + u_xlat3.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[14].xyz * u_xlat0.zzz + u_xlat3.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[15].xyz * u_xlat0.www + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www + u_xlat2.xyz;
    vec3 txVec0 = vec3(u_xlat0.xy,u_xlat0.z);
    u_xlat10_0 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_4 = (-_LightShadowData.x) + 1.0;
    SV_Target0 = vec4(u_xlat10_0) * vec4(u_xlat16_4) + _LightShadowData.xxxx;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "SHADOWS_SPLIT_SPHERES" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec3 orthoPosFar_1;
  highp vec3 orthoPosNear_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _glesVertex.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  clipPos_3.xzw = tmpvar_5.xzw;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 o_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_5.zw;
  tmpvar_4.zw = o_7.xy;
  clipPos_3.y = (tmpvar_5.y * _ProjectionParams.x);
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(-1.0, 1.0);
  tmpvar_10.xy = clipPos_3.xy;
  highp vec3 tmpvar_11;
  tmpvar_11 = (unity_CameraInvProjection * tmpvar_10).xyz;
  orthoPosNear_2.xy = tmpvar_11.xy;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(1.0, 1.0);
  tmpvar_12.xy = clipPos_3.xy;
  highp vec3 tmpvar_13;
  tmpvar_13 = (unity_CameraInvProjection * tmpvar_12).xyz;
  orthoPosFar_1.xy = tmpvar_13.xy;
  orthoPosNear_2.z = -(tmpvar_11.z);
  orthoPosFar_1.z = -(tmpvar_13.z);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = _glesMultiTexCoord1.xyz;
  xlv_TEXCOORD2 = orthoPosNear_2;
  xlv_TEXCOORD3 = orthoPosFar_1;
}


#endif
#ifdef FRAGMENT
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _ShadowMapTexture;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec4 xlv_TEXCOORD0;
void main ()
{
  lowp float shadow_1;
  highp vec4 camPos_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xy = xlv_TEXCOORD0.zw;
  tmpvar_4.z = texture2D (_CameraDepthTexture, xlv_TEXCOORD0.xy).x;
  clipPos_3.w = tmpvar_4.w;
  clipPos_3.xyz = ((2.0 * tmpvar_4.xyz) - 1.0);
  highp vec4 tmpvar_5;
  tmpvar_5 = (unity_CameraInvProjection * clipPos_3);
  camPos_2.w = tmpvar_5.w;
  camPos_2.xyz = (tmpvar_5.xyz / tmpvar_5.w);
  camPos_2.z = -(camPos_2.z);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = camPos_2.xyz;
  highp vec4 tmpvar_7;
  tmpvar_7 = (unity_CameraToWorld * tmpvar_6);
  lowp vec4 weights_8;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_7.xyz - unity_ShadowSplitSpheres[0].xyz);
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_7.xyz - unity_ShadowSplitSpheres[1].xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_7.xyz - unity_ShadowSplitSpheres[2].xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_7.xyz - unity_ShadowSplitSpheres[3].xyz);
  highp vec4 tmpvar_13;
  tmpvar_13.x = dot (tmpvar_9, tmpvar_9);
  tmpvar_13.y = dot (tmpvar_10, tmpvar_10);
  tmpvar_13.z = dot (tmpvar_11, tmpvar_11);
  tmpvar_13.w = dot (tmpvar_12, tmpvar_12);
  bvec4 tmpvar_14;
  tmpvar_14 = lessThan (tmpvar_13, unity_ShadowSplitSqRadii);
  lowp vec4 tmpvar_15;
  tmpvar_15 = vec4(tmpvar_14);
  weights_8.x = tmpvar_15.x;
  weights_8.yzw = clamp ((tmpvar_15.yzw - tmpvar_15.xyz), 0.0, 1.0);
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = (((
    ((unity_WorldToShadow[0] * tmpvar_7).xyz * tmpvar_15.x)
   + 
    ((unity_WorldToShadow[1] * tmpvar_7).xyz * weights_8.y)
  ) + (
    (unity_WorldToShadow[2] * tmpvar_7)
  .xyz * weights_8.z)) + ((unity_WorldToShadow[3] * tmpvar_7).xyz * weights_8.w));
  highp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_ShadowMapTexture, tmpvar_16.xy);
  lowp float tmpvar_18;
  if ((tmpvar_17.x < tmpvar_16.z)) {
    tmpvar_18 = 0.0;
  } else {
    tmpvar_18 = 1.0;
  };
  mediump float tmpvar_19;
  tmpvar_19 = mix (_LightShadowData.x, 1.0, tmpvar_18);
  shadow_1 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = vec4(shadow_1);
  gl_FragData[0] = tmpvar_20;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "SHADOWS_SPLIT_SPHERES" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec3 orthoPosFar_1;
  highp vec3 orthoPosNear_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _glesVertex.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  clipPos_3.xzw = tmpvar_5.xzw;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 o_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_5.zw;
  tmpvar_4.zw = o_7.xy;
  clipPos_3.y = (tmpvar_5.y * _ProjectionParams.x);
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(-1.0, 1.0);
  tmpvar_10.xy = clipPos_3.xy;
  highp vec3 tmpvar_11;
  tmpvar_11 = (unity_CameraInvProjection * tmpvar_10).xyz;
  orthoPosNear_2.xy = tmpvar_11.xy;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(1.0, 1.0);
  tmpvar_12.xy = clipPos_3.xy;
  highp vec3 tmpvar_13;
  tmpvar_13 = (unity_CameraInvProjection * tmpvar_12).xyz;
  orthoPosFar_1.xy = tmpvar_13.xy;
  orthoPosNear_2.z = -(tmpvar_11.z);
  orthoPosFar_1.z = -(tmpvar_13.z);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = _glesMultiTexCoord1.xyz;
  xlv_TEXCOORD2 = orthoPosNear_2;
  xlv_TEXCOORD3 = orthoPosFar_1;
}


#endif
#ifdef FRAGMENT
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _ShadowMapTexture;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec4 xlv_TEXCOORD0;
void main ()
{
  lowp float shadow_1;
  highp vec4 camPos_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xy = xlv_TEXCOORD0.zw;
  tmpvar_4.z = texture2D (_CameraDepthTexture, xlv_TEXCOORD0.xy).x;
  clipPos_3.w = tmpvar_4.w;
  clipPos_3.xyz = ((2.0 * tmpvar_4.xyz) - 1.0);
  highp vec4 tmpvar_5;
  tmpvar_5 = (unity_CameraInvProjection * clipPos_3);
  camPos_2.w = tmpvar_5.w;
  camPos_2.xyz = (tmpvar_5.xyz / tmpvar_5.w);
  camPos_2.z = -(camPos_2.z);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = camPos_2.xyz;
  highp vec4 tmpvar_7;
  tmpvar_7 = (unity_CameraToWorld * tmpvar_6);
  lowp vec4 weights_8;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_7.xyz - unity_ShadowSplitSpheres[0].xyz);
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_7.xyz - unity_ShadowSplitSpheres[1].xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_7.xyz - unity_ShadowSplitSpheres[2].xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_7.xyz - unity_ShadowSplitSpheres[3].xyz);
  highp vec4 tmpvar_13;
  tmpvar_13.x = dot (tmpvar_9, tmpvar_9);
  tmpvar_13.y = dot (tmpvar_10, tmpvar_10);
  tmpvar_13.z = dot (tmpvar_11, tmpvar_11);
  tmpvar_13.w = dot (tmpvar_12, tmpvar_12);
  bvec4 tmpvar_14;
  tmpvar_14 = lessThan (tmpvar_13, unity_ShadowSplitSqRadii);
  lowp vec4 tmpvar_15;
  tmpvar_15 = vec4(tmpvar_14);
  weights_8.x = tmpvar_15.x;
  weights_8.yzw = clamp ((tmpvar_15.yzw - tmpvar_15.xyz), 0.0, 1.0);
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = (((
    ((unity_WorldToShadow[0] * tmpvar_7).xyz * tmpvar_15.x)
   + 
    ((unity_WorldToShadow[1] * tmpvar_7).xyz * weights_8.y)
  ) + (
    (unity_WorldToShadow[2] * tmpvar_7)
  .xyz * weights_8.z)) + ((unity_WorldToShadow[3] * tmpvar_7).xyz * weights_8.w));
  highp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_ShadowMapTexture, tmpvar_16.xy);
  lowp float tmpvar_18;
  if ((tmpvar_17.x < tmpvar_16.z)) {
    tmpvar_18 = 0.0;
  } else {
    tmpvar_18 = 1.0;
  };
  mediump float tmpvar_19;
  tmpvar_19 = mix (_LightShadowData.x, 1.0, tmpvar_18);
  shadow_1 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = vec4(shadow_1);
  gl_FragData[0] = tmpvar_20;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "SHADOWS_SPLIT_SPHERES" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec3 orthoPosFar_1;
  highp vec3 orthoPosNear_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _glesVertex.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  clipPos_3.xzw = tmpvar_5.xzw;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 o_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_5.zw;
  tmpvar_4.zw = o_7.xy;
  clipPos_3.y = (tmpvar_5.y * _ProjectionParams.x);
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(-1.0, 1.0);
  tmpvar_10.xy = clipPos_3.xy;
  highp vec3 tmpvar_11;
  tmpvar_11 = (unity_CameraInvProjection * tmpvar_10).xyz;
  orthoPosNear_2.xy = tmpvar_11.xy;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(1.0, 1.0);
  tmpvar_12.xy = clipPos_3.xy;
  highp vec3 tmpvar_13;
  tmpvar_13 = (unity_CameraInvProjection * tmpvar_12).xyz;
  orthoPosFar_1.xy = tmpvar_13.xy;
  orthoPosNear_2.z = -(tmpvar_11.z);
  orthoPosFar_1.z = -(tmpvar_13.z);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = _glesMultiTexCoord1.xyz;
  xlv_TEXCOORD2 = orthoPosNear_2;
  xlv_TEXCOORD3 = orthoPosFar_1;
}


#endif
#ifdef FRAGMENT
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _ShadowMapTexture;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec4 xlv_TEXCOORD0;
void main ()
{
  lowp float shadow_1;
  highp vec4 camPos_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xy = xlv_TEXCOORD0.zw;
  tmpvar_4.z = texture2D (_CameraDepthTexture, xlv_TEXCOORD0.xy).x;
  clipPos_3.w = tmpvar_4.w;
  clipPos_3.xyz = ((2.0 * tmpvar_4.xyz) - 1.0);
  highp vec4 tmpvar_5;
  tmpvar_5 = (unity_CameraInvProjection * clipPos_3);
  camPos_2.w = tmpvar_5.w;
  camPos_2.xyz = (tmpvar_5.xyz / tmpvar_5.w);
  camPos_2.z = -(camPos_2.z);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = camPos_2.xyz;
  highp vec4 tmpvar_7;
  tmpvar_7 = (unity_CameraToWorld * tmpvar_6);
  lowp vec4 weights_8;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_7.xyz - unity_ShadowSplitSpheres[0].xyz);
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_7.xyz - unity_ShadowSplitSpheres[1].xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_7.xyz - unity_ShadowSplitSpheres[2].xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_7.xyz - unity_ShadowSplitSpheres[3].xyz);
  highp vec4 tmpvar_13;
  tmpvar_13.x = dot (tmpvar_9, tmpvar_9);
  tmpvar_13.y = dot (tmpvar_10, tmpvar_10);
  tmpvar_13.z = dot (tmpvar_11, tmpvar_11);
  tmpvar_13.w = dot (tmpvar_12, tmpvar_12);
  bvec4 tmpvar_14;
  tmpvar_14 = lessThan (tmpvar_13, unity_ShadowSplitSqRadii);
  lowp vec4 tmpvar_15;
  tmpvar_15 = vec4(tmpvar_14);
  weights_8.x = tmpvar_15.x;
  weights_8.yzw = clamp ((tmpvar_15.yzw - tmpvar_15.xyz), 0.0, 1.0);
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = (((
    ((unity_WorldToShadow[0] * tmpvar_7).xyz * tmpvar_15.x)
   + 
    ((unity_WorldToShadow[1] * tmpvar_7).xyz * weights_8.y)
  ) + (
    (unity_WorldToShadow[2] * tmpvar_7)
  .xyz * weights_8.z)) + ((unity_WorldToShadow[3] * tmpvar_7).xyz * weights_8.w));
  highp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_ShadowMapTexture, tmpvar_16.xy);
  lowp float tmpvar_18;
  if ((tmpvar_17.x < tmpvar_16.z)) {
    tmpvar_18 = 0.0;
  } else {
    tmpvar_18 = 1.0;
  };
  mediump float tmpvar_19;
  tmpvar_19 = mix (_LightShadowData.x, 1.0, tmpvar_18);
  shadow_1 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = vec4(shadow_1);
  gl_FragData[0] = tmpvar_20;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SHADOWS_SPLIT_SPHERES" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
in highp vec3 in_TEXCOORD1;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
out highp vec3 vs_TEXCOORD2;
out highp vec3 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
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
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraInvProjection[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraInvProjection[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    vs_TEXCOORD0.zw = u_xlat1.zz + u_xlat1.xw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    vs_TEXCOORD1.xyz = in_TEXCOORD1.xyz;
    u_xlat1.xyz = u_xlat0.xyz + (-hlslcc_mtx4x4unity_CameraInvProjection[2].xyz);
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[2].xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.w = (-u_xlat1.z);
    vs_TEXCOORD2.xyz = u_xlat1.xyw;
    u_xlat0.w = (-u_xlat0.z);
    vs_TEXCOORD3.xyz = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 unity_ShadowSplitSpheres[4];
uniform 	vec4 unity_ShadowSplitSqRadii;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
lowp float u_xlat10_0;
vec4 u_xlat1;
bvec4 u_xlatb1;
vec3 u_xlat2;
mediump vec3 u_xlat16_3;
vec3 u_xlat5;
void main()
{
    u_xlat0.z = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat0.xy = vs_TEXCOORD0.zw;
    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraInvProjection[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraInvProjection[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraInvProjection[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraInvProjection[3];
    u_xlat0.xyz = u_xlat0.xyz / u_xlat0.www;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * (-u_xlat0.zzzz) + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat1.xyz = u_xlat0.xyz + (-unity_ShadowSplitSpheres[0].xyz);
    u_xlat1.x = dot(u_xlat1.xyz, u_xlat1.xyz);
    u_xlat2.xyz = u_xlat0.xyz + (-unity_ShadowSplitSpheres[1].xyz);
    u_xlat1.y = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat2.xyz = u_xlat0.xyz + (-unity_ShadowSplitSpheres[2].xyz);
    u_xlat1.z = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat2.xyz = u_xlat0.xyz + (-unity_ShadowSplitSpheres[3].xyz);
    u_xlat1.w = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlatb1 = lessThan(u_xlat1, unity_ShadowSplitSqRadii);
    u_xlat16_3.x = (u_xlatb1.x) ? float(-1.0) : float(-0.0);
    u_xlat16_3.y = (u_xlatb1.y) ? float(-1.0) : float(-0.0);
    u_xlat16_3.z = (u_xlatb1.z) ? float(-1.0) : float(-0.0);
    u_xlat1 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb1));
    u_xlat16_3.xyz = vec3(u_xlat16_3.x + u_xlat1.y, u_xlat16_3.y + u_xlat1.z, u_xlat16_3.z + u_xlat1.w);
    u_xlat16_3.xyz = max(u_xlat16_3.xyz, vec3(0.0, 0.0, 0.0));
    u_xlat5.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[5].xyz;
    u_xlat5.xyz = hlslcc_mtx4x4unity_WorldToShadow[4].xyz * u_xlat0.xxx + u_xlat5.xyz;
    u_xlat5.xyz = hlslcc_mtx4x4unity_WorldToShadow[6].xyz * u_xlat0.zzz + u_xlat5.xyz;
    u_xlat5.xyz = hlslcc_mtx4x4unity_WorldToShadow[7].xyz * u_xlat0.www + u_xlat5.xyz;
    u_xlat5.xyz = u_xlat16_3.xxx * u_xlat5.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[3].xyz * u_xlat0.www + u_xlat2.xyz;
    u_xlat1.xyz = u_xlat2.xyz * u_xlat1.xxx + u_xlat5.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[9].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[8].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[10].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[11].xyz * u_xlat0.www + u_xlat2.xyz;
    u_xlat1.xyz = u_xlat2.xyz * u_xlat16_3.yyy + u_xlat1.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[13].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[12].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[14].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[15].xyz * u_xlat0.www + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_3.zzz + u_xlat1.xyz;
    vec3 txVec0 = vec3(u_xlat0.xy,u_xlat0.z);
    u_xlat10_0 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_3.x = (-_LightShadowData.x) + 1.0;
    SV_Target0 = vec4(u_xlat10_0) * u_xlat16_3.xxxx + _LightShadowData.xxxx;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SHADOWS_SPLIT_SPHERES" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
in highp vec3 in_TEXCOORD1;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
out highp vec3 vs_TEXCOORD2;
out highp vec3 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
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
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraInvProjection[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraInvProjection[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    vs_TEXCOORD0.zw = u_xlat1.zz + u_xlat1.xw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    vs_TEXCOORD1.xyz = in_TEXCOORD1.xyz;
    u_xlat1.xyz = u_xlat0.xyz + (-hlslcc_mtx4x4unity_CameraInvProjection[2].xyz);
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[2].xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.w = (-u_xlat1.z);
    vs_TEXCOORD2.xyz = u_xlat1.xyw;
    u_xlat0.w = (-u_xlat0.z);
    vs_TEXCOORD3.xyz = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 unity_ShadowSplitSpheres[4];
uniform 	vec4 unity_ShadowSplitSqRadii;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
lowp float u_xlat10_0;
vec4 u_xlat1;
bvec4 u_xlatb1;
vec3 u_xlat2;
mediump vec3 u_xlat16_3;
vec3 u_xlat5;
void main()
{
    u_xlat0.z = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat0.xy = vs_TEXCOORD0.zw;
    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraInvProjection[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraInvProjection[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraInvProjection[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraInvProjection[3];
    u_xlat0.xyz = u_xlat0.xyz / u_xlat0.www;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * (-u_xlat0.zzzz) + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat1.xyz = u_xlat0.xyz + (-unity_ShadowSplitSpheres[0].xyz);
    u_xlat1.x = dot(u_xlat1.xyz, u_xlat1.xyz);
    u_xlat2.xyz = u_xlat0.xyz + (-unity_ShadowSplitSpheres[1].xyz);
    u_xlat1.y = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat2.xyz = u_xlat0.xyz + (-unity_ShadowSplitSpheres[2].xyz);
    u_xlat1.z = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat2.xyz = u_xlat0.xyz + (-unity_ShadowSplitSpheres[3].xyz);
    u_xlat1.w = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlatb1 = lessThan(u_xlat1, unity_ShadowSplitSqRadii);
    u_xlat16_3.x = (u_xlatb1.x) ? float(-1.0) : float(-0.0);
    u_xlat16_3.y = (u_xlatb1.y) ? float(-1.0) : float(-0.0);
    u_xlat16_3.z = (u_xlatb1.z) ? float(-1.0) : float(-0.0);
    u_xlat1 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb1));
    u_xlat16_3.xyz = vec3(u_xlat16_3.x + u_xlat1.y, u_xlat16_3.y + u_xlat1.z, u_xlat16_3.z + u_xlat1.w);
    u_xlat16_3.xyz = max(u_xlat16_3.xyz, vec3(0.0, 0.0, 0.0));
    u_xlat5.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[5].xyz;
    u_xlat5.xyz = hlslcc_mtx4x4unity_WorldToShadow[4].xyz * u_xlat0.xxx + u_xlat5.xyz;
    u_xlat5.xyz = hlslcc_mtx4x4unity_WorldToShadow[6].xyz * u_xlat0.zzz + u_xlat5.xyz;
    u_xlat5.xyz = hlslcc_mtx4x4unity_WorldToShadow[7].xyz * u_xlat0.www + u_xlat5.xyz;
    u_xlat5.xyz = u_xlat16_3.xxx * u_xlat5.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[3].xyz * u_xlat0.www + u_xlat2.xyz;
    u_xlat1.xyz = u_xlat2.xyz * u_xlat1.xxx + u_xlat5.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[9].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[8].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[10].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[11].xyz * u_xlat0.www + u_xlat2.xyz;
    u_xlat1.xyz = u_xlat2.xyz * u_xlat16_3.yyy + u_xlat1.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[13].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[12].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[14].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[15].xyz * u_xlat0.www + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_3.zzz + u_xlat1.xyz;
    vec3 txVec0 = vec3(u_xlat0.xy,u_xlat0.z);
    u_xlat10_0 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_3.x = (-_LightShadowData.x) + 1.0;
    SV_Target0 = vec4(u_xlat10_0) * u_xlat16_3.xxxx + _LightShadowData.xxxx;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SHADOWS_SPLIT_SPHERES" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
in highp vec3 in_TEXCOORD1;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
out highp vec3 vs_TEXCOORD2;
out highp vec3 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
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
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraInvProjection[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraInvProjection[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    vs_TEXCOORD0.zw = u_xlat1.zz + u_xlat1.xw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    vs_TEXCOORD1.xyz = in_TEXCOORD1.xyz;
    u_xlat1.xyz = u_xlat0.xyz + (-hlslcc_mtx4x4unity_CameraInvProjection[2].xyz);
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[2].xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.w = (-u_xlat1.z);
    vs_TEXCOORD2.xyz = u_xlat1.xyw;
    u_xlat0.w = (-u_xlat0.z);
    vs_TEXCOORD3.xyz = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 unity_ShadowSplitSpheres[4];
uniform 	vec4 unity_ShadowSplitSqRadii;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
lowp float u_xlat10_0;
vec4 u_xlat1;
bvec4 u_xlatb1;
vec3 u_xlat2;
mediump vec3 u_xlat16_3;
vec3 u_xlat5;
void main()
{
    u_xlat0.z = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat0.xy = vs_TEXCOORD0.zw;
    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraInvProjection[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraInvProjection[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraInvProjection[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraInvProjection[3];
    u_xlat0.xyz = u_xlat0.xyz / u_xlat0.www;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * (-u_xlat0.zzzz) + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat1.xyz = u_xlat0.xyz + (-unity_ShadowSplitSpheres[0].xyz);
    u_xlat1.x = dot(u_xlat1.xyz, u_xlat1.xyz);
    u_xlat2.xyz = u_xlat0.xyz + (-unity_ShadowSplitSpheres[1].xyz);
    u_xlat1.y = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat2.xyz = u_xlat0.xyz + (-unity_ShadowSplitSpheres[2].xyz);
    u_xlat1.z = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat2.xyz = u_xlat0.xyz + (-unity_ShadowSplitSpheres[3].xyz);
    u_xlat1.w = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlatb1 = lessThan(u_xlat1, unity_ShadowSplitSqRadii);
    u_xlat16_3.x = (u_xlatb1.x) ? float(-1.0) : float(-0.0);
    u_xlat16_3.y = (u_xlatb1.y) ? float(-1.0) : float(-0.0);
    u_xlat16_3.z = (u_xlatb1.z) ? float(-1.0) : float(-0.0);
    u_xlat1 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb1));
    u_xlat16_3.xyz = vec3(u_xlat16_3.x + u_xlat1.y, u_xlat16_3.y + u_xlat1.z, u_xlat16_3.z + u_xlat1.w);
    u_xlat16_3.xyz = max(u_xlat16_3.xyz, vec3(0.0, 0.0, 0.0));
    u_xlat5.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[5].xyz;
    u_xlat5.xyz = hlslcc_mtx4x4unity_WorldToShadow[4].xyz * u_xlat0.xxx + u_xlat5.xyz;
    u_xlat5.xyz = hlslcc_mtx4x4unity_WorldToShadow[6].xyz * u_xlat0.zzz + u_xlat5.xyz;
    u_xlat5.xyz = hlslcc_mtx4x4unity_WorldToShadow[7].xyz * u_xlat0.www + u_xlat5.xyz;
    u_xlat5.xyz = u_xlat16_3.xxx * u_xlat5.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[3].xyz * u_xlat0.www + u_xlat2.xyz;
    u_xlat1.xyz = u_xlat2.xyz * u_xlat1.xxx + u_xlat5.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[9].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[8].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[10].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[11].xyz * u_xlat0.www + u_xlat2.xyz;
    u_xlat1.xyz = u_xlat2.xyz * u_xlat16_3.yyy + u_xlat1.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[13].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[12].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[14].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[15].xyz * u_xlat0.www + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_3.zzz + u_xlat1.xyz;
    vec3 txVec0 = vec3(u_xlat0.xy,u_xlat0.z);
    u_xlat10_0 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_3.x = (-_LightShadowData.x) + 1.0;
    SV_Target0 = vec4(u_xlat10_0) * u_xlat16_3.xxxx + _LightShadowData.xxxx;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "SHADOWS_SINGLE_CASCADE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec3 orthoPosFar_1;
  highp vec3 orthoPosNear_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _glesVertex.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  clipPos_3.xzw = tmpvar_5.xzw;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 o_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_5.zw;
  tmpvar_4.zw = o_7.xy;
  clipPos_3.y = (tmpvar_5.y * _ProjectionParams.x);
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(-1.0, 1.0);
  tmpvar_10.xy = clipPos_3.xy;
  highp vec3 tmpvar_11;
  tmpvar_11 = (unity_CameraInvProjection * tmpvar_10).xyz;
  orthoPosNear_2.xy = tmpvar_11.xy;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(1.0, 1.0);
  tmpvar_12.xy = clipPos_3.xy;
  highp vec3 tmpvar_13;
  tmpvar_13 = (unity_CameraInvProjection * tmpvar_12).xyz;
  orthoPosFar_1.xy = tmpvar_13.xy;
  orthoPosNear_2.z = -(tmpvar_11.z);
  orthoPosFar_1.z = -(tmpvar_13.z);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = _glesMultiTexCoord1.xyz;
  xlv_TEXCOORD2 = orthoPosNear_2;
  xlv_TEXCOORD3 = orthoPosFar_1;
}


#endif
#ifdef FRAGMENT
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _ShadowMapTexture;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec4 xlv_TEXCOORD0;
void main ()
{
  lowp float shadow_1;
  highp vec4 camPos_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xy = xlv_TEXCOORD0.zw;
  tmpvar_4.z = texture2D (_CameraDepthTexture, xlv_TEXCOORD0.xy).x;
  clipPos_3.w = tmpvar_4.w;
  clipPos_3.xyz = ((2.0 * tmpvar_4.xyz) - 1.0);
  highp vec4 tmpvar_5;
  tmpvar_5 = (unity_CameraInvProjection * clipPos_3);
  camPos_2.w = tmpvar_5.w;
  camPos_2.xyz = (tmpvar_5.xyz / tmpvar_5.w);
  camPos_2.z = -(camPos_2.z);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = camPos_2.xyz;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = (unity_WorldToShadow[0] * (unity_CameraToWorld * tmpvar_6)).xyz;
  highp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_ShadowMapTexture, tmpvar_7.xy);
  lowp float tmpvar_9;
  if ((tmpvar_8.x < tmpvar_7.z)) {
    tmpvar_9 = 0.0;
  } else {
    tmpvar_9 = 1.0;
  };
  mediump float tmpvar_10;
  tmpvar_10 = mix (_LightShadowData.x, 1.0, tmpvar_9);
  shadow_1 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = vec4(shadow_1);
  gl_FragData[0] = tmpvar_11;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "SHADOWS_SINGLE_CASCADE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec3 orthoPosFar_1;
  highp vec3 orthoPosNear_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _glesVertex.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  clipPos_3.xzw = tmpvar_5.xzw;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 o_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_5.zw;
  tmpvar_4.zw = o_7.xy;
  clipPos_3.y = (tmpvar_5.y * _ProjectionParams.x);
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(-1.0, 1.0);
  tmpvar_10.xy = clipPos_3.xy;
  highp vec3 tmpvar_11;
  tmpvar_11 = (unity_CameraInvProjection * tmpvar_10).xyz;
  orthoPosNear_2.xy = tmpvar_11.xy;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(1.0, 1.0);
  tmpvar_12.xy = clipPos_3.xy;
  highp vec3 tmpvar_13;
  tmpvar_13 = (unity_CameraInvProjection * tmpvar_12).xyz;
  orthoPosFar_1.xy = tmpvar_13.xy;
  orthoPosNear_2.z = -(tmpvar_11.z);
  orthoPosFar_1.z = -(tmpvar_13.z);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = _glesMultiTexCoord1.xyz;
  xlv_TEXCOORD2 = orthoPosNear_2;
  xlv_TEXCOORD3 = orthoPosFar_1;
}


#endif
#ifdef FRAGMENT
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _ShadowMapTexture;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec4 xlv_TEXCOORD0;
void main ()
{
  lowp float shadow_1;
  highp vec4 camPos_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xy = xlv_TEXCOORD0.zw;
  tmpvar_4.z = texture2D (_CameraDepthTexture, xlv_TEXCOORD0.xy).x;
  clipPos_3.w = tmpvar_4.w;
  clipPos_3.xyz = ((2.0 * tmpvar_4.xyz) - 1.0);
  highp vec4 tmpvar_5;
  tmpvar_5 = (unity_CameraInvProjection * clipPos_3);
  camPos_2.w = tmpvar_5.w;
  camPos_2.xyz = (tmpvar_5.xyz / tmpvar_5.w);
  camPos_2.z = -(camPos_2.z);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = camPos_2.xyz;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = (unity_WorldToShadow[0] * (unity_CameraToWorld * tmpvar_6)).xyz;
  highp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_ShadowMapTexture, tmpvar_7.xy);
  lowp float tmpvar_9;
  if ((tmpvar_8.x < tmpvar_7.z)) {
    tmpvar_9 = 0.0;
  } else {
    tmpvar_9 = 1.0;
  };
  mediump float tmpvar_10;
  tmpvar_10 = mix (_LightShadowData.x, 1.0, tmpvar_9);
  shadow_1 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = vec4(shadow_1);
  gl_FragData[0] = tmpvar_11;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "SHADOWS_SINGLE_CASCADE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec3 orthoPosFar_1;
  highp vec3 orthoPosNear_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _glesVertex.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  clipPos_3.xzw = tmpvar_5.xzw;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 o_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_5.zw;
  tmpvar_4.zw = o_7.xy;
  clipPos_3.y = (tmpvar_5.y * _ProjectionParams.x);
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(-1.0, 1.0);
  tmpvar_10.xy = clipPos_3.xy;
  highp vec3 tmpvar_11;
  tmpvar_11 = (unity_CameraInvProjection * tmpvar_10).xyz;
  orthoPosNear_2.xy = tmpvar_11.xy;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(1.0, 1.0);
  tmpvar_12.xy = clipPos_3.xy;
  highp vec3 tmpvar_13;
  tmpvar_13 = (unity_CameraInvProjection * tmpvar_12).xyz;
  orthoPosFar_1.xy = tmpvar_13.xy;
  orthoPosNear_2.z = -(tmpvar_11.z);
  orthoPosFar_1.z = -(tmpvar_13.z);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = _glesMultiTexCoord1.xyz;
  xlv_TEXCOORD2 = orthoPosNear_2;
  xlv_TEXCOORD3 = orthoPosFar_1;
}


#endif
#ifdef FRAGMENT
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _ShadowMapTexture;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec4 xlv_TEXCOORD0;
void main ()
{
  lowp float shadow_1;
  highp vec4 camPos_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xy = xlv_TEXCOORD0.zw;
  tmpvar_4.z = texture2D (_CameraDepthTexture, xlv_TEXCOORD0.xy).x;
  clipPos_3.w = tmpvar_4.w;
  clipPos_3.xyz = ((2.0 * tmpvar_4.xyz) - 1.0);
  highp vec4 tmpvar_5;
  tmpvar_5 = (unity_CameraInvProjection * clipPos_3);
  camPos_2.w = tmpvar_5.w;
  camPos_2.xyz = (tmpvar_5.xyz / tmpvar_5.w);
  camPos_2.z = -(camPos_2.z);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = camPos_2.xyz;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = (unity_WorldToShadow[0] * (unity_CameraToWorld * tmpvar_6)).xyz;
  highp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_ShadowMapTexture, tmpvar_7.xy);
  lowp float tmpvar_9;
  if ((tmpvar_8.x < tmpvar_7.z)) {
    tmpvar_9 = 0.0;
  } else {
    tmpvar_9 = 1.0;
  };
  mediump float tmpvar_10;
  tmpvar_10 = mix (_LightShadowData.x, 1.0, tmpvar_9);
  shadow_1 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = vec4(shadow_1);
  gl_FragData[0] = tmpvar_11;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SHADOWS_SINGLE_CASCADE" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
in highp vec3 in_TEXCOORD1;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
out highp vec3 vs_TEXCOORD2;
out highp vec3 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
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
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraInvProjection[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraInvProjection[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    vs_TEXCOORD0.zw = u_xlat1.zz + u_xlat1.xw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    vs_TEXCOORD1.xyz = in_TEXCOORD1.xyz;
    u_xlat1.xyz = u_xlat0.xyz + (-hlslcc_mtx4x4unity_CameraInvProjection[2].xyz);
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[2].xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.w = (-u_xlat1.z);
    vs_TEXCOORD2.xyz = u_xlat1.xyw;
    u_xlat0.w = (-u_xlat0.z);
    vs_TEXCOORD3.xyz = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
lowp float u_xlat10_0;
vec4 u_xlat1;
mediump float u_xlat16_2;
void main()
{
    u_xlat0.z = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat0.xy = vs_TEXCOORD0.zw;
    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraInvProjection[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraInvProjection[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraInvProjection[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraInvProjection[3];
    u_xlat0.xyz = u_xlat0.xyz / u_xlat0.www;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * (-u_xlat0.zzzz) + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat1.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[3].xyz * u_xlat0.www + u_xlat0.xyz;
    vec3 txVec0 = vec3(u_xlat0.xy,u_xlat0.z);
    u_xlat10_0 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_2 = (-_LightShadowData.x) + 1.0;
    SV_Target0 = vec4(u_xlat10_0) * vec4(u_xlat16_2) + _LightShadowData.xxxx;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SHADOWS_SINGLE_CASCADE" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
in highp vec3 in_TEXCOORD1;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
out highp vec3 vs_TEXCOORD2;
out highp vec3 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
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
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraInvProjection[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraInvProjection[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    vs_TEXCOORD0.zw = u_xlat1.zz + u_xlat1.xw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    vs_TEXCOORD1.xyz = in_TEXCOORD1.xyz;
    u_xlat1.xyz = u_xlat0.xyz + (-hlslcc_mtx4x4unity_CameraInvProjection[2].xyz);
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[2].xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.w = (-u_xlat1.z);
    vs_TEXCOORD2.xyz = u_xlat1.xyw;
    u_xlat0.w = (-u_xlat0.z);
    vs_TEXCOORD3.xyz = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
lowp float u_xlat10_0;
vec4 u_xlat1;
mediump float u_xlat16_2;
void main()
{
    u_xlat0.z = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat0.xy = vs_TEXCOORD0.zw;
    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraInvProjection[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraInvProjection[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraInvProjection[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraInvProjection[3];
    u_xlat0.xyz = u_xlat0.xyz / u_xlat0.www;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * (-u_xlat0.zzzz) + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat1.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[3].xyz * u_xlat0.www + u_xlat0.xyz;
    vec3 txVec0 = vec3(u_xlat0.xy,u_xlat0.z);
    u_xlat10_0 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_2 = (-_LightShadowData.x) + 1.0;
    SV_Target0 = vec4(u_xlat10_0) * vec4(u_xlat16_2) + _LightShadowData.xxxx;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SHADOWS_SINGLE_CASCADE" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
in highp vec3 in_TEXCOORD1;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
out highp vec3 vs_TEXCOORD2;
out highp vec3 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
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
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraInvProjection[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraInvProjection[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    vs_TEXCOORD0.zw = u_xlat1.zz + u_xlat1.xw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    vs_TEXCOORD1.xyz = in_TEXCOORD1.xyz;
    u_xlat1.xyz = u_xlat0.xyz + (-hlslcc_mtx4x4unity_CameraInvProjection[2].xyz);
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[2].xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.w = (-u_xlat1.z);
    vs_TEXCOORD2.xyz = u_xlat1.xyw;
    u_xlat0.w = (-u_xlat0.z);
    vs_TEXCOORD3.xyz = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
lowp float u_xlat10_0;
vec4 u_xlat1;
mediump float u_xlat16_2;
void main()
{
    u_xlat0.z = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat0.xy = vs_TEXCOORD0.zw;
    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraInvProjection[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraInvProjection[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraInvProjection[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraInvProjection[3];
    u_xlat0.xyz = u_xlat0.xyz / u_xlat0.www;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * (-u_xlat0.zzzz) + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat1.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[3].xyz * u_xlat0.www + u_xlat0.xyz;
    vec3 txVec0 = vec3(u_xlat0.xy,u_xlat0.z);
    u_xlat10_0 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_2 = (-_LightShadowData.x) + 1.0;
    SV_Target0 = vec4(u_xlat10_0) * vec4(u_xlat16_2) + _LightShadowData.xxxx;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec3 orthoPosFar_1;
  highp vec3 orthoPosNear_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _glesVertex.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  clipPos_3.xzw = tmpvar_5.xzw;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 o_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_5.zw;
  tmpvar_4.zw = o_7.xy;
  clipPos_3.y = (tmpvar_5.y * _ProjectionParams.x);
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(-1.0, 1.0);
  tmpvar_10.xy = clipPos_3.xy;
  highp vec3 tmpvar_11;
  tmpvar_11 = (unity_CameraInvProjection * tmpvar_10).xyz;
  orthoPosNear_2.xy = tmpvar_11.xy;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(1.0, 1.0);
  tmpvar_12.xy = clipPos_3.xy;
  highp vec3 tmpvar_13;
  tmpvar_13 = (unity_CameraInvProjection * tmpvar_12).xyz;
  orthoPosFar_1.xy = tmpvar_13.xy;
  orthoPosNear_2.z = -(tmpvar_11.z);
  orthoPosFar_1.z = -(tmpvar_13.z);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = _glesMultiTexCoord1.xyz;
  xlv_TEXCOORD2 = orthoPosNear_2;
  xlv_TEXCOORD3 = orthoPosFar_1;
}


#endif
#ifdef FRAGMENT
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _ShadowMapTexture;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec4 xlv_TEXCOORD0;
void main ()
{
  lowp float shadow_1;
  highp vec4 camPos_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xy = xlv_TEXCOORD0.zw;
  tmpvar_4.z = texture2D (_CameraDepthTexture, xlv_TEXCOORD0.xy).x;
  clipPos_3.w = tmpvar_4.w;
  clipPos_3.xyz = ((2.0 * tmpvar_4.xyz) - 1.0);
  highp vec4 tmpvar_5;
  tmpvar_5 = (unity_CameraInvProjection * clipPos_3);
  camPos_2.w = tmpvar_5.w;
  camPos_2.xyz = (tmpvar_5.xyz / tmpvar_5.w);
  camPos_2.z = -(camPos_2.z);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = camPos_2.xyz;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = (unity_WorldToShadow[0] * (unity_CameraToWorld * tmpvar_6)).xyz;
  highp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_ShadowMapTexture, tmpvar_7.xy);
  lowp float tmpvar_9;
  if ((tmpvar_8.x < tmpvar_7.z)) {
    tmpvar_9 = 0.0;
  } else {
    tmpvar_9 = 1.0;
  };
  mediump float tmpvar_10;
  tmpvar_10 = mix (_LightShadowData.x, 1.0, tmpvar_9);
  shadow_1 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = vec4(shadow_1);
  gl_FragData[0] = tmpvar_11;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec3 orthoPosFar_1;
  highp vec3 orthoPosNear_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _glesVertex.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  clipPos_3.xzw = tmpvar_5.xzw;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 o_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_5.zw;
  tmpvar_4.zw = o_7.xy;
  clipPos_3.y = (tmpvar_5.y * _ProjectionParams.x);
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(-1.0, 1.0);
  tmpvar_10.xy = clipPos_3.xy;
  highp vec3 tmpvar_11;
  tmpvar_11 = (unity_CameraInvProjection * tmpvar_10).xyz;
  orthoPosNear_2.xy = tmpvar_11.xy;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(1.0, 1.0);
  tmpvar_12.xy = clipPos_3.xy;
  highp vec3 tmpvar_13;
  tmpvar_13 = (unity_CameraInvProjection * tmpvar_12).xyz;
  orthoPosFar_1.xy = tmpvar_13.xy;
  orthoPosNear_2.z = -(tmpvar_11.z);
  orthoPosFar_1.z = -(tmpvar_13.z);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = _glesMultiTexCoord1.xyz;
  xlv_TEXCOORD2 = orthoPosNear_2;
  xlv_TEXCOORD3 = orthoPosFar_1;
}


#endif
#ifdef FRAGMENT
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _ShadowMapTexture;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec4 xlv_TEXCOORD0;
void main ()
{
  lowp float shadow_1;
  highp vec4 camPos_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xy = xlv_TEXCOORD0.zw;
  tmpvar_4.z = texture2D (_CameraDepthTexture, xlv_TEXCOORD0.xy).x;
  clipPos_3.w = tmpvar_4.w;
  clipPos_3.xyz = ((2.0 * tmpvar_4.xyz) - 1.0);
  highp vec4 tmpvar_5;
  tmpvar_5 = (unity_CameraInvProjection * clipPos_3);
  camPos_2.w = tmpvar_5.w;
  camPos_2.xyz = (tmpvar_5.xyz / tmpvar_5.w);
  camPos_2.z = -(camPos_2.z);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = camPos_2.xyz;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = (unity_WorldToShadow[0] * (unity_CameraToWorld * tmpvar_6)).xyz;
  highp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_ShadowMapTexture, tmpvar_7.xy);
  lowp float tmpvar_9;
  if ((tmpvar_8.x < tmpvar_7.z)) {
    tmpvar_9 = 0.0;
  } else {
    tmpvar_9 = 1.0;
  };
  mediump float tmpvar_10;
  tmpvar_10 = mix (_LightShadowData.x, 1.0, tmpvar_9);
  shadow_1 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = vec4(shadow_1);
  gl_FragData[0] = tmpvar_11;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec3 orthoPosFar_1;
  highp vec3 orthoPosNear_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _glesVertex.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  clipPos_3.xzw = tmpvar_5.xzw;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 o_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_5.zw;
  tmpvar_4.zw = o_7.xy;
  clipPos_3.y = (tmpvar_5.y * _ProjectionParams.x);
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(-1.0, 1.0);
  tmpvar_10.xy = clipPos_3.xy;
  highp vec3 tmpvar_11;
  tmpvar_11 = (unity_CameraInvProjection * tmpvar_10).xyz;
  orthoPosNear_2.xy = tmpvar_11.xy;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(1.0, 1.0);
  tmpvar_12.xy = clipPos_3.xy;
  highp vec3 tmpvar_13;
  tmpvar_13 = (unity_CameraInvProjection * tmpvar_12).xyz;
  orthoPosFar_1.xy = tmpvar_13.xy;
  orthoPosNear_2.z = -(tmpvar_11.z);
  orthoPosFar_1.z = -(tmpvar_13.z);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = _glesMultiTexCoord1.xyz;
  xlv_TEXCOORD2 = orthoPosNear_2;
  xlv_TEXCOORD3 = orthoPosFar_1;
}


#endif
#ifdef FRAGMENT
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _ShadowMapTexture;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec4 xlv_TEXCOORD0;
void main ()
{
  lowp float shadow_1;
  highp vec4 camPos_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xy = xlv_TEXCOORD0.zw;
  tmpvar_4.z = texture2D (_CameraDepthTexture, xlv_TEXCOORD0.xy).x;
  clipPos_3.w = tmpvar_4.w;
  clipPos_3.xyz = ((2.0 * tmpvar_4.xyz) - 1.0);
  highp vec4 tmpvar_5;
  tmpvar_5 = (unity_CameraInvProjection * clipPos_3);
  camPos_2.w = tmpvar_5.w;
  camPos_2.xyz = (tmpvar_5.xyz / tmpvar_5.w);
  camPos_2.z = -(camPos_2.z);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = camPos_2.xyz;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = (unity_WorldToShadow[0] * (unity_CameraToWorld * tmpvar_6)).xyz;
  highp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_ShadowMapTexture, tmpvar_7.xy);
  lowp float tmpvar_9;
  if ((tmpvar_8.x < tmpvar_7.z)) {
    tmpvar_9 = 0.0;
  } else {
    tmpvar_9 = 1.0;
  };
  mediump float tmpvar_10;
  tmpvar_10 = mix (_LightShadowData.x, 1.0, tmpvar_9);
  shadow_1 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = vec4(shadow_1);
  gl_FragData[0] = tmpvar_11;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
in highp vec3 in_TEXCOORD1;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
out highp vec3 vs_TEXCOORD2;
out highp vec3 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
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
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraInvProjection[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraInvProjection[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    vs_TEXCOORD0.zw = u_xlat1.zz + u_xlat1.xw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    vs_TEXCOORD1.xyz = in_TEXCOORD1.xyz;
    u_xlat1.xyz = u_xlat0.xyz + (-hlslcc_mtx4x4unity_CameraInvProjection[2].xyz);
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[2].xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.w = (-u_xlat1.z);
    vs_TEXCOORD2.xyz = u_xlat1.xyw;
    u_xlat0.w = (-u_xlat0.z);
    vs_TEXCOORD3.xyz = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
lowp float u_xlat10_0;
vec4 u_xlat1;
mediump float u_xlat16_2;
void main()
{
    u_xlat0.z = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat0.xy = vs_TEXCOORD0.zw;
    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraInvProjection[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraInvProjection[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraInvProjection[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraInvProjection[3];
    u_xlat0.xyz = u_xlat0.xyz / u_xlat0.www;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * (-u_xlat0.zzzz) + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat1.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[3].xyz * u_xlat0.www + u_xlat0.xyz;
    vec3 txVec0 = vec3(u_xlat0.xy,u_xlat0.z);
    u_xlat10_0 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_2 = (-_LightShadowData.x) + 1.0;
    SV_Target0 = vec4(u_xlat10_0) * vec4(u_xlat16_2) + _LightShadowData.xxxx;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
in highp vec3 in_TEXCOORD1;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
out highp vec3 vs_TEXCOORD2;
out highp vec3 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
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
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraInvProjection[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraInvProjection[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    vs_TEXCOORD0.zw = u_xlat1.zz + u_xlat1.xw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    vs_TEXCOORD1.xyz = in_TEXCOORD1.xyz;
    u_xlat1.xyz = u_xlat0.xyz + (-hlslcc_mtx4x4unity_CameraInvProjection[2].xyz);
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[2].xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.w = (-u_xlat1.z);
    vs_TEXCOORD2.xyz = u_xlat1.xyw;
    u_xlat0.w = (-u_xlat0.z);
    vs_TEXCOORD3.xyz = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
lowp float u_xlat10_0;
vec4 u_xlat1;
mediump float u_xlat16_2;
void main()
{
    u_xlat0.z = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat0.xy = vs_TEXCOORD0.zw;
    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraInvProjection[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraInvProjection[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraInvProjection[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraInvProjection[3];
    u_xlat0.xyz = u_xlat0.xyz / u_xlat0.www;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * (-u_xlat0.zzzz) + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat1.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[3].xyz * u_xlat0.www + u_xlat0.xyz;
    vec3 txVec0 = vec3(u_xlat0.xy,u_xlat0.z);
    u_xlat10_0 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_2 = (-_LightShadowData.x) + 1.0;
    SV_Target0 = vec4(u_xlat10_0) * vec4(u_xlat16_2) + _LightShadowData.xxxx;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
in highp vec3 in_TEXCOORD1;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
out highp vec3 vs_TEXCOORD2;
out highp vec3 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
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
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraInvProjection[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraInvProjection[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    vs_TEXCOORD0.zw = u_xlat1.zz + u_xlat1.xw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    vs_TEXCOORD1.xyz = in_TEXCOORD1.xyz;
    u_xlat1.xyz = u_xlat0.xyz + (-hlslcc_mtx4x4unity_CameraInvProjection[2].xyz);
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[2].xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.w = (-u_xlat1.z);
    vs_TEXCOORD2.xyz = u_xlat1.xyw;
    u_xlat0.w = (-u_xlat0.z);
    vs_TEXCOORD3.xyz = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
lowp float u_xlat10_0;
vec4 u_xlat1;
mediump float u_xlat16_2;
void main()
{
    u_xlat0.z = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat0.xy = vs_TEXCOORD0.zw;
    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraInvProjection[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraInvProjection[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraInvProjection[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraInvProjection[3];
    u_xlat0.xyz = u_xlat0.xyz / u_xlat0.www;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * (-u_xlat0.zzzz) + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat1.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[3].xyz * u_xlat0.www + u_xlat0.xyz;
    vec3 txVec0 = vec3(u_xlat0.xy,u_xlat0.z);
    u_xlat10_0 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_2 = (-_LightShadowData.x) + 1.0;
    SV_Target0 = vec4(u_xlat10_0) * vec4(u_xlat16_2) + _LightShadowData.xxxx;
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
Keywords { "SHADOWS_SPLIT_SPHERES" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "SHADOWS_SPLIT_SPHERES" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "SHADOWS_SPLIT_SPHERES" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SHADOWS_SPLIT_SPHERES" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SHADOWS_SPLIT_SPHERES" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SHADOWS_SPLIT_SPHERES" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "SHADOWS_SINGLE_CASCADE" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "SHADOWS_SINGLE_CASCADE" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "SHADOWS_SINGLE_CASCADE" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SHADOWS_SINGLE_CASCADE" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SHADOWS_SINGLE_CASCADE" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SHADOWS_SINGLE_CASCADE" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" }
""
}
}
}
}
SubShader {
 Tags { "ShadowmapFilter" = "PCF_SOFT" }
 Pass {
  Tags { "ShadowmapFilter" = "PCF_SOFT" }
  ZTest Always
  ZWrite Off
  Cull Off
  GpuProgramID 136644
Program "vp" {
SubProgram "gles hw_tier00 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec3 orthoPosFar_1;
  highp vec3 orthoPosNear_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _glesVertex.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  clipPos_3.xzw = tmpvar_5.xzw;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 o_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_5.zw;
  tmpvar_4.zw = o_7.xy;
  clipPos_3.y = (tmpvar_5.y * _ProjectionParams.x);
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(-1.0, 1.0);
  tmpvar_10.xy = clipPos_3.xy;
  highp vec3 tmpvar_11;
  tmpvar_11 = (unity_CameraInvProjection * tmpvar_10).xyz;
  orthoPosNear_2.xy = tmpvar_11.xy;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(1.0, 1.0);
  tmpvar_12.xy = clipPos_3.xy;
  highp vec3 tmpvar_13;
  tmpvar_13 = (unity_CameraInvProjection * tmpvar_12).xyz;
  orthoPosFar_1.xy = tmpvar_13.xy;
  orthoPosNear_2.z = -(tmpvar_11.z);
  orthoPosFar_1.z = -(tmpvar_13.z);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = _glesMultiTexCoord1.xyz;
  xlv_TEXCOORD2 = orthoPosNear_2;
  xlv_TEXCOORD3 = orthoPosFar_1;
}


#endif
#ifdef FRAGMENT
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_OrthoParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_CameraDepthTexture, xlv_TEXCOORD0.xy);
  tmpvar_2 = mix ((xlv_TEXCOORD1 * mix (
    (1.0/(((_ZBufferParams.x * tmpvar_3.x) + _ZBufferParams.y)))
  , tmpvar_3.x, unity_OrthoParams.w)), mix (xlv_TEXCOORD2, xlv_TEXCOORD3, tmpvar_3.xxx), unity_OrthoParams.www);
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_2;
  highp vec4 tmpvar_5;
  tmpvar_5 = (unity_CameraToWorld * tmpvar_4);
  bvec4 tmpvar_6;
  tmpvar_6 = greaterThanEqual (tmpvar_2.zzzz, _LightSplitsNear);
  bvec4 tmpvar_7;
  tmpvar_7 = lessThan (tmpvar_2.zzzz, _LightSplitsFar);
  lowp vec4 tmpvar_8;
  tmpvar_8 = (vec4(tmpvar_6) * vec4(tmpvar_7));
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = (((
    ((unity_WorldToShadow[0] * tmpvar_5).xyz * tmpvar_8.x)
   + 
    ((unity_WorldToShadow[1] * tmpvar_5).xyz * tmpvar_8.y)
  ) + (
    (unity_WorldToShadow[2] * tmpvar_5)
  .xyz * tmpvar_8.z)) + ((unity_WorldToShadow[3] * tmpvar_5).xyz * tmpvar_8.w));
  mediump float shadow_10;
  highp vec2 tmpvar_11;
  tmpvar_11 = _ShadowMapTexture_TexelSize.xy;
  shadow_10 = 0.0;
  highp vec3 tmpvar_12;
  tmpvar_12.xy = (tmpvar_9.xy - _ShadowMapTexture_TexelSize.xy);
  tmpvar_12.z = tmpvar_9.z;
  highp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_ShadowMapTexture, tmpvar_12.xy);
  mediump float tmpvar_14;
  if ((tmpvar_13.x < tmpvar_9.z)) {
    tmpvar_14 = 0.0;
  } else {
    tmpvar_14 = 1.0;
  };
  shadow_10 = tmpvar_14;
  highp vec2 tmpvar_15;
  tmpvar_15.x = 0.0;
  tmpvar_15.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_16;
  tmpvar_16.xy = (tmpvar_9.xy + tmpvar_15);
  tmpvar_16.z = tmpvar_9.z;
  highp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_ShadowMapTexture, tmpvar_16.xy);
  highp float tmpvar_18;
  if ((tmpvar_17.x < tmpvar_9.z)) {
    tmpvar_18 = 0.0;
  } else {
    tmpvar_18 = 1.0;
  };
  shadow_10 = (tmpvar_14 + tmpvar_18);
  highp vec2 tmpvar_19;
  tmpvar_19.x = tmpvar_11.x;
  tmpvar_19.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_20;
  tmpvar_20.xy = (tmpvar_9.xy + tmpvar_19);
  tmpvar_20.z = tmpvar_9.z;
  highp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_ShadowMapTexture, tmpvar_20.xy);
  highp float tmpvar_22;
  if ((tmpvar_21.x < tmpvar_9.z)) {
    tmpvar_22 = 0.0;
  } else {
    tmpvar_22 = 1.0;
  };
  shadow_10 = (shadow_10 + tmpvar_22);
  highp vec2 tmpvar_23;
  tmpvar_23.y = 0.0;
  tmpvar_23.x = -(_ShadowMapTexture_TexelSize.x);
  highp vec3 tmpvar_24;
  tmpvar_24.xy = (tmpvar_9.xy + tmpvar_23);
  tmpvar_24.z = tmpvar_9.z;
  highp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_ShadowMapTexture, tmpvar_24.xy);
  highp float tmpvar_26;
  if ((tmpvar_25.x < tmpvar_9.z)) {
    tmpvar_26 = 0.0;
  } else {
    tmpvar_26 = 1.0;
  };
  shadow_10 = (shadow_10 + tmpvar_26);
  highp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_ShadowMapTexture, tmpvar_9.xy);
  highp float tmpvar_28;
  if ((tmpvar_27.x < tmpvar_9.z)) {
    tmpvar_28 = 0.0;
  } else {
    tmpvar_28 = 1.0;
  };
  shadow_10 = (shadow_10 + tmpvar_28);
  highp vec2 tmpvar_29;
  tmpvar_29.y = 0.0;
  tmpvar_29.x = tmpvar_11.x;
  highp vec3 tmpvar_30;
  tmpvar_30.xy = (tmpvar_9.xy + tmpvar_29);
  tmpvar_30.z = tmpvar_9.z;
  highp vec4 tmpvar_31;
  tmpvar_31 = texture2D (_ShadowMapTexture, tmpvar_30.xy);
  highp float tmpvar_32;
  if ((tmpvar_31.x < tmpvar_9.z)) {
    tmpvar_32 = 0.0;
  } else {
    tmpvar_32 = 1.0;
  };
  shadow_10 = (shadow_10 + tmpvar_32);
  highp vec2 tmpvar_33;
  tmpvar_33.x = -(_ShadowMapTexture_TexelSize.x);
  tmpvar_33.y = tmpvar_11.y;
  highp vec3 tmpvar_34;
  tmpvar_34.xy = (tmpvar_9.xy + tmpvar_33);
  tmpvar_34.z = tmpvar_9.z;
  highp vec4 tmpvar_35;
  tmpvar_35 = texture2D (_ShadowMapTexture, tmpvar_34.xy);
  highp float tmpvar_36;
  if ((tmpvar_35.x < tmpvar_9.z)) {
    tmpvar_36 = 0.0;
  } else {
    tmpvar_36 = 1.0;
  };
  shadow_10 = (shadow_10 + tmpvar_36);
  highp vec2 tmpvar_37;
  tmpvar_37.x = 0.0;
  tmpvar_37.y = tmpvar_11.y;
  highp vec3 tmpvar_38;
  tmpvar_38.xy = (tmpvar_9.xy + tmpvar_37);
  tmpvar_38.z = tmpvar_9.z;
  highp vec4 tmpvar_39;
  tmpvar_39 = texture2D (_ShadowMapTexture, tmpvar_38.xy);
  highp float tmpvar_40;
  if ((tmpvar_39.x < tmpvar_9.z)) {
    tmpvar_40 = 0.0;
  } else {
    tmpvar_40 = 1.0;
  };
  shadow_10 = (shadow_10 + tmpvar_40);
  highp vec3 tmpvar_41;
  tmpvar_41.xy = (tmpvar_9.xy + _ShadowMapTexture_TexelSize.xy);
  tmpvar_41.z = tmpvar_9.z;
  highp vec4 tmpvar_42;
  tmpvar_42 = texture2D (_ShadowMapTexture, tmpvar_41.xy);
  highp float tmpvar_43;
  if ((tmpvar_42.x < tmpvar_9.z)) {
    tmpvar_43 = 0.0;
  } else {
    tmpvar_43 = 1.0;
  };
  shadow_10 = (shadow_10 + tmpvar_43);
  shadow_10 = (shadow_10 / 9.0);
  mediump vec4 tmpvar_44;
  tmpvar_44 = vec4(mix (_LightShadowData.x, 1.0, shadow_10));
  tmpvar_1 = tmpvar_44;
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
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec3 orthoPosFar_1;
  highp vec3 orthoPosNear_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _glesVertex.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  clipPos_3.xzw = tmpvar_5.xzw;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 o_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_5.zw;
  tmpvar_4.zw = o_7.xy;
  clipPos_3.y = (tmpvar_5.y * _ProjectionParams.x);
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(-1.0, 1.0);
  tmpvar_10.xy = clipPos_3.xy;
  highp vec3 tmpvar_11;
  tmpvar_11 = (unity_CameraInvProjection * tmpvar_10).xyz;
  orthoPosNear_2.xy = tmpvar_11.xy;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(1.0, 1.0);
  tmpvar_12.xy = clipPos_3.xy;
  highp vec3 tmpvar_13;
  tmpvar_13 = (unity_CameraInvProjection * tmpvar_12).xyz;
  orthoPosFar_1.xy = tmpvar_13.xy;
  orthoPosNear_2.z = -(tmpvar_11.z);
  orthoPosFar_1.z = -(tmpvar_13.z);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = _glesMultiTexCoord1.xyz;
  xlv_TEXCOORD2 = orthoPosNear_2;
  xlv_TEXCOORD3 = orthoPosFar_1;
}


#endif
#ifdef FRAGMENT
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_OrthoParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_CameraDepthTexture, xlv_TEXCOORD0.xy);
  tmpvar_2 = mix ((xlv_TEXCOORD1 * mix (
    (1.0/(((_ZBufferParams.x * tmpvar_3.x) + _ZBufferParams.y)))
  , tmpvar_3.x, unity_OrthoParams.w)), mix (xlv_TEXCOORD2, xlv_TEXCOORD3, tmpvar_3.xxx), unity_OrthoParams.www);
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_2;
  highp vec4 tmpvar_5;
  tmpvar_5 = (unity_CameraToWorld * tmpvar_4);
  bvec4 tmpvar_6;
  tmpvar_6 = greaterThanEqual (tmpvar_2.zzzz, _LightSplitsNear);
  bvec4 tmpvar_7;
  tmpvar_7 = lessThan (tmpvar_2.zzzz, _LightSplitsFar);
  lowp vec4 tmpvar_8;
  tmpvar_8 = (vec4(tmpvar_6) * vec4(tmpvar_7));
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = (((
    ((unity_WorldToShadow[0] * tmpvar_5).xyz * tmpvar_8.x)
   + 
    ((unity_WorldToShadow[1] * tmpvar_5).xyz * tmpvar_8.y)
  ) + (
    (unity_WorldToShadow[2] * tmpvar_5)
  .xyz * tmpvar_8.z)) + ((unity_WorldToShadow[3] * tmpvar_5).xyz * tmpvar_8.w));
  mediump float shadow_10;
  highp vec2 tmpvar_11;
  tmpvar_11 = _ShadowMapTexture_TexelSize.xy;
  shadow_10 = 0.0;
  highp vec3 tmpvar_12;
  tmpvar_12.xy = (tmpvar_9.xy - _ShadowMapTexture_TexelSize.xy);
  tmpvar_12.z = tmpvar_9.z;
  highp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_ShadowMapTexture, tmpvar_12.xy);
  mediump float tmpvar_14;
  if ((tmpvar_13.x < tmpvar_9.z)) {
    tmpvar_14 = 0.0;
  } else {
    tmpvar_14 = 1.0;
  };
  shadow_10 = tmpvar_14;
  highp vec2 tmpvar_15;
  tmpvar_15.x = 0.0;
  tmpvar_15.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_16;
  tmpvar_16.xy = (tmpvar_9.xy + tmpvar_15);
  tmpvar_16.z = tmpvar_9.z;
  highp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_ShadowMapTexture, tmpvar_16.xy);
  highp float tmpvar_18;
  if ((tmpvar_17.x < tmpvar_9.z)) {
    tmpvar_18 = 0.0;
  } else {
    tmpvar_18 = 1.0;
  };
  shadow_10 = (tmpvar_14 + tmpvar_18);
  highp vec2 tmpvar_19;
  tmpvar_19.x = tmpvar_11.x;
  tmpvar_19.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_20;
  tmpvar_20.xy = (tmpvar_9.xy + tmpvar_19);
  tmpvar_20.z = tmpvar_9.z;
  highp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_ShadowMapTexture, tmpvar_20.xy);
  highp float tmpvar_22;
  if ((tmpvar_21.x < tmpvar_9.z)) {
    tmpvar_22 = 0.0;
  } else {
    tmpvar_22 = 1.0;
  };
  shadow_10 = (shadow_10 + tmpvar_22);
  highp vec2 tmpvar_23;
  tmpvar_23.y = 0.0;
  tmpvar_23.x = -(_ShadowMapTexture_TexelSize.x);
  highp vec3 tmpvar_24;
  tmpvar_24.xy = (tmpvar_9.xy + tmpvar_23);
  tmpvar_24.z = tmpvar_9.z;
  highp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_ShadowMapTexture, tmpvar_24.xy);
  highp float tmpvar_26;
  if ((tmpvar_25.x < tmpvar_9.z)) {
    tmpvar_26 = 0.0;
  } else {
    tmpvar_26 = 1.0;
  };
  shadow_10 = (shadow_10 + tmpvar_26);
  highp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_ShadowMapTexture, tmpvar_9.xy);
  highp float tmpvar_28;
  if ((tmpvar_27.x < tmpvar_9.z)) {
    tmpvar_28 = 0.0;
  } else {
    tmpvar_28 = 1.0;
  };
  shadow_10 = (shadow_10 + tmpvar_28);
  highp vec2 tmpvar_29;
  tmpvar_29.y = 0.0;
  tmpvar_29.x = tmpvar_11.x;
  highp vec3 tmpvar_30;
  tmpvar_30.xy = (tmpvar_9.xy + tmpvar_29);
  tmpvar_30.z = tmpvar_9.z;
  highp vec4 tmpvar_31;
  tmpvar_31 = texture2D (_ShadowMapTexture, tmpvar_30.xy);
  highp float tmpvar_32;
  if ((tmpvar_31.x < tmpvar_9.z)) {
    tmpvar_32 = 0.0;
  } else {
    tmpvar_32 = 1.0;
  };
  shadow_10 = (shadow_10 + tmpvar_32);
  highp vec2 tmpvar_33;
  tmpvar_33.x = -(_ShadowMapTexture_TexelSize.x);
  tmpvar_33.y = tmpvar_11.y;
  highp vec3 tmpvar_34;
  tmpvar_34.xy = (tmpvar_9.xy + tmpvar_33);
  tmpvar_34.z = tmpvar_9.z;
  highp vec4 tmpvar_35;
  tmpvar_35 = texture2D (_ShadowMapTexture, tmpvar_34.xy);
  highp float tmpvar_36;
  if ((tmpvar_35.x < tmpvar_9.z)) {
    tmpvar_36 = 0.0;
  } else {
    tmpvar_36 = 1.0;
  };
  shadow_10 = (shadow_10 + tmpvar_36);
  highp vec2 tmpvar_37;
  tmpvar_37.x = 0.0;
  tmpvar_37.y = tmpvar_11.y;
  highp vec3 tmpvar_38;
  tmpvar_38.xy = (tmpvar_9.xy + tmpvar_37);
  tmpvar_38.z = tmpvar_9.z;
  highp vec4 tmpvar_39;
  tmpvar_39 = texture2D (_ShadowMapTexture, tmpvar_38.xy);
  highp float tmpvar_40;
  if ((tmpvar_39.x < tmpvar_9.z)) {
    tmpvar_40 = 0.0;
  } else {
    tmpvar_40 = 1.0;
  };
  shadow_10 = (shadow_10 + tmpvar_40);
  highp vec3 tmpvar_41;
  tmpvar_41.xy = (tmpvar_9.xy + _ShadowMapTexture_TexelSize.xy);
  tmpvar_41.z = tmpvar_9.z;
  highp vec4 tmpvar_42;
  tmpvar_42 = texture2D (_ShadowMapTexture, tmpvar_41.xy);
  highp float tmpvar_43;
  if ((tmpvar_42.x < tmpvar_9.z)) {
    tmpvar_43 = 0.0;
  } else {
    tmpvar_43 = 1.0;
  };
  shadow_10 = (shadow_10 + tmpvar_43);
  shadow_10 = (shadow_10 / 9.0);
  mediump vec4 tmpvar_44;
  tmpvar_44 = vec4(mix (_LightShadowData.x, 1.0, shadow_10));
  tmpvar_1 = tmpvar_44;
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
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec3 orthoPosFar_1;
  highp vec3 orthoPosNear_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _glesVertex.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  clipPos_3.xzw = tmpvar_5.xzw;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 o_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_5.zw;
  tmpvar_4.zw = o_7.xy;
  clipPos_3.y = (tmpvar_5.y * _ProjectionParams.x);
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(-1.0, 1.0);
  tmpvar_10.xy = clipPos_3.xy;
  highp vec3 tmpvar_11;
  tmpvar_11 = (unity_CameraInvProjection * tmpvar_10).xyz;
  orthoPosNear_2.xy = tmpvar_11.xy;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(1.0, 1.0);
  tmpvar_12.xy = clipPos_3.xy;
  highp vec3 tmpvar_13;
  tmpvar_13 = (unity_CameraInvProjection * tmpvar_12).xyz;
  orthoPosFar_1.xy = tmpvar_13.xy;
  orthoPosNear_2.z = -(tmpvar_11.z);
  orthoPosFar_1.z = -(tmpvar_13.z);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = _glesMultiTexCoord1.xyz;
  xlv_TEXCOORD2 = orthoPosNear_2;
  xlv_TEXCOORD3 = orthoPosFar_1;
}


#endif
#ifdef FRAGMENT
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_OrthoParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec3 tmpvar_2;
  highp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_CameraDepthTexture, xlv_TEXCOORD0.xy);
  tmpvar_2 = mix ((xlv_TEXCOORD1 * mix (
    (1.0/(((_ZBufferParams.x * tmpvar_3.x) + _ZBufferParams.y)))
  , tmpvar_3.x, unity_OrthoParams.w)), mix (xlv_TEXCOORD2, xlv_TEXCOORD3, tmpvar_3.xxx), unity_OrthoParams.www);
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xyz = tmpvar_2;
  highp vec4 tmpvar_5;
  tmpvar_5 = (unity_CameraToWorld * tmpvar_4);
  bvec4 tmpvar_6;
  tmpvar_6 = greaterThanEqual (tmpvar_2.zzzz, _LightSplitsNear);
  bvec4 tmpvar_7;
  tmpvar_7 = lessThan (tmpvar_2.zzzz, _LightSplitsFar);
  lowp vec4 tmpvar_8;
  tmpvar_8 = (vec4(tmpvar_6) * vec4(tmpvar_7));
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = (((
    ((unity_WorldToShadow[0] * tmpvar_5).xyz * tmpvar_8.x)
   + 
    ((unity_WorldToShadow[1] * tmpvar_5).xyz * tmpvar_8.y)
  ) + (
    (unity_WorldToShadow[2] * tmpvar_5)
  .xyz * tmpvar_8.z)) + ((unity_WorldToShadow[3] * tmpvar_5).xyz * tmpvar_8.w));
  mediump float shadow_10;
  highp vec2 tmpvar_11;
  tmpvar_11 = _ShadowMapTexture_TexelSize.xy;
  shadow_10 = 0.0;
  highp vec3 tmpvar_12;
  tmpvar_12.xy = (tmpvar_9.xy - _ShadowMapTexture_TexelSize.xy);
  tmpvar_12.z = tmpvar_9.z;
  highp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_ShadowMapTexture, tmpvar_12.xy);
  mediump float tmpvar_14;
  if ((tmpvar_13.x < tmpvar_9.z)) {
    tmpvar_14 = 0.0;
  } else {
    tmpvar_14 = 1.0;
  };
  shadow_10 = tmpvar_14;
  highp vec2 tmpvar_15;
  tmpvar_15.x = 0.0;
  tmpvar_15.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_16;
  tmpvar_16.xy = (tmpvar_9.xy + tmpvar_15);
  tmpvar_16.z = tmpvar_9.z;
  highp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_ShadowMapTexture, tmpvar_16.xy);
  highp float tmpvar_18;
  if ((tmpvar_17.x < tmpvar_9.z)) {
    tmpvar_18 = 0.0;
  } else {
    tmpvar_18 = 1.0;
  };
  shadow_10 = (tmpvar_14 + tmpvar_18);
  highp vec2 tmpvar_19;
  tmpvar_19.x = tmpvar_11.x;
  tmpvar_19.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_20;
  tmpvar_20.xy = (tmpvar_9.xy + tmpvar_19);
  tmpvar_20.z = tmpvar_9.z;
  highp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_ShadowMapTexture, tmpvar_20.xy);
  highp float tmpvar_22;
  if ((tmpvar_21.x < tmpvar_9.z)) {
    tmpvar_22 = 0.0;
  } else {
    tmpvar_22 = 1.0;
  };
  shadow_10 = (shadow_10 + tmpvar_22);
  highp vec2 tmpvar_23;
  tmpvar_23.y = 0.0;
  tmpvar_23.x = -(_ShadowMapTexture_TexelSize.x);
  highp vec3 tmpvar_24;
  tmpvar_24.xy = (tmpvar_9.xy + tmpvar_23);
  tmpvar_24.z = tmpvar_9.z;
  highp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_ShadowMapTexture, tmpvar_24.xy);
  highp float tmpvar_26;
  if ((tmpvar_25.x < tmpvar_9.z)) {
    tmpvar_26 = 0.0;
  } else {
    tmpvar_26 = 1.0;
  };
  shadow_10 = (shadow_10 + tmpvar_26);
  highp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_ShadowMapTexture, tmpvar_9.xy);
  highp float tmpvar_28;
  if ((tmpvar_27.x < tmpvar_9.z)) {
    tmpvar_28 = 0.0;
  } else {
    tmpvar_28 = 1.0;
  };
  shadow_10 = (shadow_10 + tmpvar_28);
  highp vec2 tmpvar_29;
  tmpvar_29.y = 0.0;
  tmpvar_29.x = tmpvar_11.x;
  highp vec3 tmpvar_30;
  tmpvar_30.xy = (tmpvar_9.xy + tmpvar_29);
  tmpvar_30.z = tmpvar_9.z;
  highp vec4 tmpvar_31;
  tmpvar_31 = texture2D (_ShadowMapTexture, tmpvar_30.xy);
  highp float tmpvar_32;
  if ((tmpvar_31.x < tmpvar_9.z)) {
    tmpvar_32 = 0.0;
  } else {
    tmpvar_32 = 1.0;
  };
  shadow_10 = (shadow_10 + tmpvar_32);
  highp vec2 tmpvar_33;
  tmpvar_33.x = -(_ShadowMapTexture_TexelSize.x);
  tmpvar_33.y = tmpvar_11.y;
  highp vec3 tmpvar_34;
  tmpvar_34.xy = (tmpvar_9.xy + tmpvar_33);
  tmpvar_34.z = tmpvar_9.z;
  highp vec4 tmpvar_35;
  tmpvar_35 = texture2D (_ShadowMapTexture, tmpvar_34.xy);
  highp float tmpvar_36;
  if ((tmpvar_35.x < tmpvar_9.z)) {
    tmpvar_36 = 0.0;
  } else {
    tmpvar_36 = 1.0;
  };
  shadow_10 = (shadow_10 + tmpvar_36);
  highp vec2 tmpvar_37;
  tmpvar_37.x = 0.0;
  tmpvar_37.y = tmpvar_11.y;
  highp vec3 tmpvar_38;
  tmpvar_38.xy = (tmpvar_9.xy + tmpvar_37);
  tmpvar_38.z = tmpvar_9.z;
  highp vec4 tmpvar_39;
  tmpvar_39 = texture2D (_ShadowMapTexture, tmpvar_38.xy);
  highp float tmpvar_40;
  if ((tmpvar_39.x < tmpvar_9.z)) {
    tmpvar_40 = 0.0;
  } else {
    tmpvar_40 = 1.0;
  };
  shadow_10 = (shadow_10 + tmpvar_40);
  highp vec3 tmpvar_41;
  tmpvar_41.xy = (tmpvar_9.xy + _ShadowMapTexture_TexelSize.xy);
  tmpvar_41.z = tmpvar_9.z;
  highp vec4 tmpvar_42;
  tmpvar_42 = texture2D (_ShadowMapTexture, tmpvar_41.xy);
  highp float tmpvar_43;
  if ((tmpvar_42.x < tmpvar_9.z)) {
    tmpvar_43 = 0.0;
  } else {
    tmpvar_43 = 1.0;
  };
  shadow_10 = (shadow_10 + tmpvar_43);
  shadow_10 = (shadow_10 / 9.0);
  mediump vec4 tmpvar_44;
  tmpvar_44 = vec4(mix (_LightShadowData.x, 1.0, shadow_10));
  tmpvar_1 = tmpvar_44;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
in highp vec3 in_TEXCOORD1;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
out highp vec3 vs_TEXCOORD2;
out highp vec3 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
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
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraInvProjection[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraInvProjection[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    vs_TEXCOORD0.zw = u_xlat1.zz + u_xlat1.xw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    vs_TEXCOORD1.xyz = in_TEXCOORD1.xyz;
    u_xlat1.xyz = u_xlat0.xyz + (-hlslcc_mtx4x4unity_CameraInvProjection[2].xyz);
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[2].xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.w = (-u_xlat1.z);
    vs_TEXCOORD2.xyz = u_xlat1.xyw;
    u_xlat0.w = (-u_xlat0.z);
    vs_TEXCOORD3.xyz = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 unity_OrthoParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 _LightSplitsNear;
uniform 	vec4 _LightSplitsFar;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
in highp vec3 vs_TEXCOORD2;
in highp vec3 vs_TEXCOORD3;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
mediump vec4 u_xlat16_1;
bvec4 u_xlatb1;
vec4 u_xlat2;
lowp float u_xlat10_2;
bvec4 u_xlatb2;
vec4 u_xlat3;
lowp float u_xlat10_3;
vec4 u_xlat4;
vec4 u_xlat5;
vec4 u_xlat6;
float u_xlat7;
mediump float u_xlat16_7;
lowp float u_xlat10_9;
float u_xlat14;
lowp float u_xlat10_14;
vec2 u_xlat16;
lowp float u_xlat10_16;
lowp float u_xlat10_21;
lowp float u_xlat10_23;
void main()
{
    u_xlat0.x = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat7 = _ZBufferParams.x * u_xlat0.x + _ZBufferParams.y;
    u_xlat7 = float(1.0) / u_xlat7;
    u_xlat14 = (-u_xlat7) + u_xlat0.x;
    u_xlat7 = unity_OrthoParams.w * u_xlat14 + u_xlat7;
    u_xlat1.xyz = (-vs_TEXCOORD2.xyz) + vs_TEXCOORD3.xyz;
    u_xlat0.xzw = u_xlat0.xxx * u_xlat1.xyz + vs_TEXCOORD2.xyz;
    u_xlat0.xzw = (-vs_TEXCOORD1.xyz) * vec3(u_xlat7) + u_xlat0.xzw;
    u_xlat1.xyz = vec3(u_xlat7) * vs_TEXCOORD1.xyz;
    u_xlat0.xyz = unity_OrthoParams.www * u_xlat0.xzw + u_xlat1.xyz;
    u_xlatb1 = greaterThanEqual(u_xlat0.zzzz, _LightSplitsNear);
    u_xlat1 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb1));
    u_xlatb2 = lessThan(u_xlat0.zzzz, _LightSplitsFar);
    u_xlat2 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb2));
    u_xlat16_1 = u_xlat1 * u_xlat2;
    u_xlat2 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat2 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat2;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * u_xlat0.zzzz + u_xlat2;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[5].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[4].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[6].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[7].xyz * u_xlat0.www + u_xlat2.xyz;
    u_xlat2.xyz = u_xlat16_1.yyy * u_xlat2.xyz;
    u_xlat3.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * u_xlat0.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * u_xlat0.zzz + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[3].xyz * u_xlat0.www + u_xlat3.xyz;
    u_xlat2.xyz = u_xlat3.xyz * u_xlat16_1.xxx + u_xlat2.xyz;
    u_xlat3.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[9].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[8].xyz * u_xlat0.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[10].xyz * u_xlat0.zzz + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[11].xyz * u_xlat0.www + u_xlat3.xyz;
    u_xlat2.xyz = u_xlat3.xyz * u_xlat16_1.zzz + u_xlat2.xyz;
    u_xlat3.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[13].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[12].xyz * u_xlat0.xxx + u_xlat3.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[14].xyz * u_xlat0.zzz + u_xlat3.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[15].xyz * u_xlat0.www + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www + u_xlat2.xyz;
    u_xlat2.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + vec2(0.5, 0.5);
    u_xlat2.xy = floor(u_xlat2.xy);
    u_xlat0.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + (-u_xlat2.xy);
    u_xlat16.xy = min(u_xlat0.xy, vec2(0.0, 0.0));
    u_xlat3.xy = (-u_xlat0.xy) + vec2(1.0, 1.0);
    u_xlat16.xy = (-u_xlat16.xy) * u_xlat16.xy + u_xlat3.xy;
    u_xlat1.xy = u_xlat3.xy * vec2(0.159999996, 0.159999996);
    u_xlat16.xy = u_xlat16.xy + vec2(1.0, 1.0);
    u_xlat3.xy = u_xlat16.xy * vec2(0.159999996, 0.159999996);
    u_xlat16.xy = max(u_xlat0.xy, vec2(0.0, 0.0));
    u_xlat4 = u_xlat0.xxyy + vec4(0.5, 1.0, 0.5, 1.0);
    u_xlat16.xy = (-u_xlat16.xy) * u_xlat16.xy + u_xlat4.yw;
    u_xlat16.xy = u_xlat16.xy + vec2(1.0, 1.0);
    u_xlat5.xy = u_xlat16.xy * vec2(0.159999996, 0.159999996);
    u_xlat6 = u_xlat4.xxzz * u_xlat4.xxzz;
    u_xlat16.xy = vec2(u_xlat4.y * float(0.159999996), u_xlat4.w * float(0.159999996));
    u_xlat0.xy = u_xlat6.xz * vec2(0.5, 0.5) + (-u_xlat0.xy);
    u_xlat1.zw = vec2(u_xlat6.w * float(0.0799999982), u_xlat6.y * float(0.0799999982));
    u_xlat4.xy = u_xlat0.xy * vec2(0.159999996, 0.159999996);
    u_xlat3.z = u_xlat4.y;
    u_xlat3.w = u_xlat16.y;
    u_xlat4.w = u_xlat16.x;
    u_xlat5.zw = u_xlat1.yz;
    u_xlat0.xyw = vec3(u_xlat3.z + u_xlat5.z, u_xlat3.y + u_xlat5.y, u_xlat3.w + u_xlat5.w);
    u_xlat4.z = u_xlat3.x;
    u_xlat3.xyz = vec3(u_xlat5.z / u_xlat0.x, u_xlat5.y / u_xlat0.y, u_xlat5.w / u_xlat0.w);
    u_xlat1.z = u_xlat5.x;
    u_xlat3.xyz = u_xlat3.xyz + vec3(-2.5, -0.5, 1.5);
    u_xlat3.xyz = u_xlat3.xyz * _ShadowMapTexture_TexelSize.yyy;
    u_xlat5.w = u_xlat3.x;
    u_xlat4 = u_xlat1.zwxz + u_xlat4.zwxz;
    u_xlat6.xyz = vec3(u_xlat1.x / u_xlat4.z, u_xlat1.z / u_xlat4.w, u_xlat1.w / u_xlat4.y);
    u_xlat6.xyz = u_xlat6.xyz + vec3(-2.5, -0.5, 1.5);
    u_xlat5.xyz = u_xlat6.yxz * _ShadowMapTexture_TexelSize.xxx;
    u_xlat1 = u_xlat2.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.ywxw;
    u_xlat16.xy = u_xlat2.xy * _ShadowMapTexture_TexelSize.xy + u_xlat5.zw;
    vec3 txVec0 = vec3(u_xlat16.xy,u_xlat0.z);
    u_xlat10_16 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    vec3 txVec1 = vec3(u_xlat1.xy,u_xlat0.z);
    u_xlat10_23 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec1, 0.0);
    vec3 txVec2 = vec3(u_xlat1.zw,u_xlat0.z);
    u_xlat10_3 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec2, 0.0);
    u_xlat1 = vec4(u_xlat0.x * u_xlat4.z, u_xlat0.x * u_xlat4.w, u_xlat0.x * u_xlat4.y, u_xlat0.y * u_xlat4.z);
    u_xlat0.x = u_xlat10_3 * u_xlat1.y;
    u_xlat0.x = u_xlat1.x * u_xlat10_23 + u_xlat0.x;
    u_xlat0.x = u_xlat1.z * u_xlat10_16 + u_xlat0.x;
    u_xlat3.w = u_xlat5.y;
    u_xlat6 = u_xlat2.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat3.wywz;
    u_xlat5.yw = u_xlat3.yz;
    vec3 txVec3 = vec3(u_xlat6.xy,u_xlat0.z);
    u_xlat10_16 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec3, 0.0);
    vec3 txVec4 = vec3(u_xlat6.zw,u_xlat0.z);
    u_xlat10_23 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec4, 0.0);
    u_xlat0.x = u_xlat1.w * u_xlat10_16 + u_xlat0.x;
    u_xlat1 = u_xlat2.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xyzy;
    u_xlat3 = u_xlat2.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xwzw;
    vec3 txVec5 = vec3(u_xlat1.xy,u_xlat0.z);
    u_xlat10_2 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec5, 0.0);
    vec3 txVec6 = vec3(u_xlat1.zw,u_xlat0.z);
    u_xlat10_9 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec6, 0.0);
    u_xlat1 = vec4(u_xlat0.y * u_xlat4.x, u_xlat0.y * u_xlat4.y, u_xlat0.w * u_xlat4.z, u_xlat0.w * u_xlat4.w);
    u_xlat7 = u_xlat0.w * u_xlat4.y;
    u_xlat0.x = u_xlat1.x * u_xlat10_2 + u_xlat0.x;
    u_xlat0.x = u_xlat1.y * u_xlat10_9 + u_xlat0.x;
    u_xlat0.x = u_xlat1.z * u_xlat10_23 + u_xlat0.x;
    vec3 txVec7 = vec3(u_xlat3.xy,u_xlat0.z);
    u_xlat10_21 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec7, 0.0);
    vec3 txVec8 = vec3(u_xlat3.zw,u_xlat0.z);
    u_xlat10_14 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec8, 0.0);
    u_xlat0.x = u_xlat1.w * u_xlat10_21 + u_xlat0.x;
    u_xlat0.x = u_xlat7 * u_xlat10_14 + u_xlat0.x;
    u_xlat16_7 = (-_LightShadowData.x) + 1.0;
    u_xlat0 = u_xlat0.xxxx * vec4(u_xlat16_7) + _LightShadowData.xxxx;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
in highp vec3 in_TEXCOORD1;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
out highp vec3 vs_TEXCOORD2;
out highp vec3 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
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
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraInvProjection[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraInvProjection[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    vs_TEXCOORD0.zw = u_xlat1.zz + u_xlat1.xw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    vs_TEXCOORD1.xyz = in_TEXCOORD1.xyz;
    u_xlat1.xyz = u_xlat0.xyz + (-hlslcc_mtx4x4unity_CameraInvProjection[2].xyz);
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[2].xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.w = (-u_xlat1.z);
    vs_TEXCOORD2.xyz = u_xlat1.xyw;
    u_xlat0.w = (-u_xlat0.z);
    vs_TEXCOORD3.xyz = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 unity_OrthoParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 _LightSplitsNear;
uniform 	vec4 _LightSplitsFar;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
in highp vec3 vs_TEXCOORD2;
in highp vec3 vs_TEXCOORD3;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
mediump vec4 u_xlat16_1;
bvec4 u_xlatb1;
vec4 u_xlat2;
lowp float u_xlat10_2;
bvec4 u_xlatb2;
vec4 u_xlat3;
lowp float u_xlat10_3;
vec4 u_xlat4;
vec4 u_xlat5;
vec4 u_xlat6;
float u_xlat7;
mediump float u_xlat16_7;
lowp float u_xlat10_9;
float u_xlat14;
lowp float u_xlat10_14;
vec2 u_xlat16;
lowp float u_xlat10_16;
lowp float u_xlat10_21;
lowp float u_xlat10_23;
void main()
{
    u_xlat0.x = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat7 = _ZBufferParams.x * u_xlat0.x + _ZBufferParams.y;
    u_xlat7 = float(1.0) / u_xlat7;
    u_xlat14 = (-u_xlat7) + u_xlat0.x;
    u_xlat7 = unity_OrthoParams.w * u_xlat14 + u_xlat7;
    u_xlat1.xyz = (-vs_TEXCOORD2.xyz) + vs_TEXCOORD3.xyz;
    u_xlat0.xzw = u_xlat0.xxx * u_xlat1.xyz + vs_TEXCOORD2.xyz;
    u_xlat0.xzw = (-vs_TEXCOORD1.xyz) * vec3(u_xlat7) + u_xlat0.xzw;
    u_xlat1.xyz = vec3(u_xlat7) * vs_TEXCOORD1.xyz;
    u_xlat0.xyz = unity_OrthoParams.www * u_xlat0.xzw + u_xlat1.xyz;
    u_xlatb1 = greaterThanEqual(u_xlat0.zzzz, _LightSplitsNear);
    u_xlat1 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb1));
    u_xlatb2 = lessThan(u_xlat0.zzzz, _LightSplitsFar);
    u_xlat2 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb2));
    u_xlat16_1 = u_xlat1 * u_xlat2;
    u_xlat2 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat2 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat2;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * u_xlat0.zzzz + u_xlat2;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[5].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[4].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[6].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[7].xyz * u_xlat0.www + u_xlat2.xyz;
    u_xlat2.xyz = u_xlat16_1.yyy * u_xlat2.xyz;
    u_xlat3.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * u_xlat0.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * u_xlat0.zzz + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[3].xyz * u_xlat0.www + u_xlat3.xyz;
    u_xlat2.xyz = u_xlat3.xyz * u_xlat16_1.xxx + u_xlat2.xyz;
    u_xlat3.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[9].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[8].xyz * u_xlat0.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[10].xyz * u_xlat0.zzz + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[11].xyz * u_xlat0.www + u_xlat3.xyz;
    u_xlat2.xyz = u_xlat3.xyz * u_xlat16_1.zzz + u_xlat2.xyz;
    u_xlat3.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[13].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[12].xyz * u_xlat0.xxx + u_xlat3.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[14].xyz * u_xlat0.zzz + u_xlat3.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[15].xyz * u_xlat0.www + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www + u_xlat2.xyz;
    u_xlat2.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + vec2(0.5, 0.5);
    u_xlat2.xy = floor(u_xlat2.xy);
    u_xlat0.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + (-u_xlat2.xy);
    u_xlat16.xy = min(u_xlat0.xy, vec2(0.0, 0.0));
    u_xlat3.xy = (-u_xlat0.xy) + vec2(1.0, 1.0);
    u_xlat16.xy = (-u_xlat16.xy) * u_xlat16.xy + u_xlat3.xy;
    u_xlat1.xy = u_xlat3.xy * vec2(0.159999996, 0.159999996);
    u_xlat16.xy = u_xlat16.xy + vec2(1.0, 1.0);
    u_xlat3.xy = u_xlat16.xy * vec2(0.159999996, 0.159999996);
    u_xlat16.xy = max(u_xlat0.xy, vec2(0.0, 0.0));
    u_xlat4 = u_xlat0.xxyy + vec4(0.5, 1.0, 0.5, 1.0);
    u_xlat16.xy = (-u_xlat16.xy) * u_xlat16.xy + u_xlat4.yw;
    u_xlat16.xy = u_xlat16.xy + vec2(1.0, 1.0);
    u_xlat5.xy = u_xlat16.xy * vec2(0.159999996, 0.159999996);
    u_xlat6 = u_xlat4.xxzz * u_xlat4.xxzz;
    u_xlat16.xy = vec2(u_xlat4.y * float(0.159999996), u_xlat4.w * float(0.159999996));
    u_xlat0.xy = u_xlat6.xz * vec2(0.5, 0.5) + (-u_xlat0.xy);
    u_xlat1.zw = vec2(u_xlat6.w * float(0.0799999982), u_xlat6.y * float(0.0799999982));
    u_xlat4.xy = u_xlat0.xy * vec2(0.159999996, 0.159999996);
    u_xlat3.z = u_xlat4.y;
    u_xlat3.w = u_xlat16.y;
    u_xlat4.w = u_xlat16.x;
    u_xlat5.zw = u_xlat1.yz;
    u_xlat0.xyw = vec3(u_xlat3.z + u_xlat5.z, u_xlat3.y + u_xlat5.y, u_xlat3.w + u_xlat5.w);
    u_xlat4.z = u_xlat3.x;
    u_xlat3.xyz = vec3(u_xlat5.z / u_xlat0.x, u_xlat5.y / u_xlat0.y, u_xlat5.w / u_xlat0.w);
    u_xlat1.z = u_xlat5.x;
    u_xlat3.xyz = u_xlat3.xyz + vec3(-2.5, -0.5, 1.5);
    u_xlat3.xyz = u_xlat3.xyz * _ShadowMapTexture_TexelSize.yyy;
    u_xlat5.w = u_xlat3.x;
    u_xlat4 = u_xlat1.zwxz + u_xlat4.zwxz;
    u_xlat6.xyz = vec3(u_xlat1.x / u_xlat4.z, u_xlat1.z / u_xlat4.w, u_xlat1.w / u_xlat4.y);
    u_xlat6.xyz = u_xlat6.xyz + vec3(-2.5, -0.5, 1.5);
    u_xlat5.xyz = u_xlat6.yxz * _ShadowMapTexture_TexelSize.xxx;
    u_xlat1 = u_xlat2.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.ywxw;
    u_xlat16.xy = u_xlat2.xy * _ShadowMapTexture_TexelSize.xy + u_xlat5.zw;
    vec3 txVec0 = vec3(u_xlat16.xy,u_xlat0.z);
    u_xlat10_16 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    vec3 txVec1 = vec3(u_xlat1.xy,u_xlat0.z);
    u_xlat10_23 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec1, 0.0);
    vec3 txVec2 = vec3(u_xlat1.zw,u_xlat0.z);
    u_xlat10_3 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec2, 0.0);
    u_xlat1 = vec4(u_xlat0.x * u_xlat4.z, u_xlat0.x * u_xlat4.w, u_xlat0.x * u_xlat4.y, u_xlat0.y * u_xlat4.z);
    u_xlat0.x = u_xlat10_3 * u_xlat1.y;
    u_xlat0.x = u_xlat1.x * u_xlat10_23 + u_xlat0.x;
    u_xlat0.x = u_xlat1.z * u_xlat10_16 + u_xlat0.x;
    u_xlat3.w = u_xlat5.y;
    u_xlat6 = u_xlat2.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat3.wywz;
    u_xlat5.yw = u_xlat3.yz;
    vec3 txVec3 = vec3(u_xlat6.xy,u_xlat0.z);
    u_xlat10_16 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec3, 0.0);
    vec3 txVec4 = vec3(u_xlat6.zw,u_xlat0.z);
    u_xlat10_23 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec4, 0.0);
    u_xlat0.x = u_xlat1.w * u_xlat10_16 + u_xlat0.x;
    u_xlat1 = u_xlat2.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xyzy;
    u_xlat3 = u_xlat2.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xwzw;
    vec3 txVec5 = vec3(u_xlat1.xy,u_xlat0.z);
    u_xlat10_2 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec5, 0.0);
    vec3 txVec6 = vec3(u_xlat1.zw,u_xlat0.z);
    u_xlat10_9 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec6, 0.0);
    u_xlat1 = vec4(u_xlat0.y * u_xlat4.x, u_xlat0.y * u_xlat4.y, u_xlat0.w * u_xlat4.z, u_xlat0.w * u_xlat4.w);
    u_xlat7 = u_xlat0.w * u_xlat4.y;
    u_xlat0.x = u_xlat1.x * u_xlat10_2 + u_xlat0.x;
    u_xlat0.x = u_xlat1.y * u_xlat10_9 + u_xlat0.x;
    u_xlat0.x = u_xlat1.z * u_xlat10_23 + u_xlat0.x;
    vec3 txVec7 = vec3(u_xlat3.xy,u_xlat0.z);
    u_xlat10_21 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec7, 0.0);
    vec3 txVec8 = vec3(u_xlat3.zw,u_xlat0.z);
    u_xlat10_14 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec8, 0.0);
    u_xlat0.x = u_xlat1.w * u_xlat10_21 + u_xlat0.x;
    u_xlat0.x = u_xlat7 * u_xlat10_14 + u_xlat0.x;
    u_xlat16_7 = (-_LightShadowData.x) + 1.0;
    u_xlat0 = u_xlat0.xxxx * vec4(u_xlat16_7) + _LightShadowData.xxxx;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
in highp vec3 in_TEXCOORD1;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
out highp vec3 vs_TEXCOORD2;
out highp vec3 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
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
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraInvProjection[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraInvProjection[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    vs_TEXCOORD0.zw = u_xlat1.zz + u_xlat1.xw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    vs_TEXCOORD1.xyz = in_TEXCOORD1.xyz;
    u_xlat1.xyz = u_xlat0.xyz + (-hlslcc_mtx4x4unity_CameraInvProjection[2].xyz);
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[2].xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.w = (-u_xlat1.z);
    vs_TEXCOORD2.xyz = u_xlat1.xyw;
    u_xlat0.w = (-u_xlat0.z);
    vs_TEXCOORD3.xyz = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 unity_OrthoParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 _LightSplitsNear;
uniform 	vec4 _LightSplitsFar;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
in highp vec3 vs_TEXCOORD2;
in highp vec3 vs_TEXCOORD3;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
mediump vec4 u_xlat16_1;
bvec4 u_xlatb1;
vec4 u_xlat2;
lowp float u_xlat10_2;
bvec4 u_xlatb2;
vec4 u_xlat3;
lowp float u_xlat10_3;
vec4 u_xlat4;
vec4 u_xlat5;
vec4 u_xlat6;
float u_xlat7;
mediump float u_xlat16_7;
lowp float u_xlat10_9;
float u_xlat14;
lowp float u_xlat10_14;
vec2 u_xlat16;
lowp float u_xlat10_16;
lowp float u_xlat10_21;
lowp float u_xlat10_23;
void main()
{
    u_xlat0.x = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat7 = _ZBufferParams.x * u_xlat0.x + _ZBufferParams.y;
    u_xlat7 = float(1.0) / u_xlat7;
    u_xlat14 = (-u_xlat7) + u_xlat0.x;
    u_xlat7 = unity_OrthoParams.w * u_xlat14 + u_xlat7;
    u_xlat1.xyz = (-vs_TEXCOORD2.xyz) + vs_TEXCOORD3.xyz;
    u_xlat0.xzw = u_xlat0.xxx * u_xlat1.xyz + vs_TEXCOORD2.xyz;
    u_xlat0.xzw = (-vs_TEXCOORD1.xyz) * vec3(u_xlat7) + u_xlat0.xzw;
    u_xlat1.xyz = vec3(u_xlat7) * vs_TEXCOORD1.xyz;
    u_xlat0.xyz = unity_OrthoParams.www * u_xlat0.xzw + u_xlat1.xyz;
    u_xlatb1 = greaterThanEqual(u_xlat0.zzzz, _LightSplitsNear);
    u_xlat1 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb1));
    u_xlatb2 = lessThan(u_xlat0.zzzz, _LightSplitsFar);
    u_xlat2 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb2));
    u_xlat16_1 = u_xlat1 * u_xlat2;
    u_xlat2 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat2 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat2;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * u_xlat0.zzzz + u_xlat2;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[5].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[4].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[6].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[7].xyz * u_xlat0.www + u_xlat2.xyz;
    u_xlat2.xyz = u_xlat16_1.yyy * u_xlat2.xyz;
    u_xlat3.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * u_xlat0.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * u_xlat0.zzz + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[3].xyz * u_xlat0.www + u_xlat3.xyz;
    u_xlat2.xyz = u_xlat3.xyz * u_xlat16_1.xxx + u_xlat2.xyz;
    u_xlat3.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[9].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[8].xyz * u_xlat0.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[10].xyz * u_xlat0.zzz + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[11].xyz * u_xlat0.www + u_xlat3.xyz;
    u_xlat2.xyz = u_xlat3.xyz * u_xlat16_1.zzz + u_xlat2.xyz;
    u_xlat3.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[13].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[12].xyz * u_xlat0.xxx + u_xlat3.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[14].xyz * u_xlat0.zzz + u_xlat3.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[15].xyz * u_xlat0.www + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www + u_xlat2.xyz;
    u_xlat2.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + vec2(0.5, 0.5);
    u_xlat2.xy = floor(u_xlat2.xy);
    u_xlat0.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + (-u_xlat2.xy);
    u_xlat16.xy = min(u_xlat0.xy, vec2(0.0, 0.0));
    u_xlat3.xy = (-u_xlat0.xy) + vec2(1.0, 1.0);
    u_xlat16.xy = (-u_xlat16.xy) * u_xlat16.xy + u_xlat3.xy;
    u_xlat1.xy = u_xlat3.xy * vec2(0.159999996, 0.159999996);
    u_xlat16.xy = u_xlat16.xy + vec2(1.0, 1.0);
    u_xlat3.xy = u_xlat16.xy * vec2(0.159999996, 0.159999996);
    u_xlat16.xy = max(u_xlat0.xy, vec2(0.0, 0.0));
    u_xlat4 = u_xlat0.xxyy + vec4(0.5, 1.0, 0.5, 1.0);
    u_xlat16.xy = (-u_xlat16.xy) * u_xlat16.xy + u_xlat4.yw;
    u_xlat16.xy = u_xlat16.xy + vec2(1.0, 1.0);
    u_xlat5.xy = u_xlat16.xy * vec2(0.159999996, 0.159999996);
    u_xlat6 = u_xlat4.xxzz * u_xlat4.xxzz;
    u_xlat16.xy = vec2(u_xlat4.y * float(0.159999996), u_xlat4.w * float(0.159999996));
    u_xlat0.xy = u_xlat6.xz * vec2(0.5, 0.5) + (-u_xlat0.xy);
    u_xlat1.zw = vec2(u_xlat6.w * float(0.0799999982), u_xlat6.y * float(0.0799999982));
    u_xlat4.xy = u_xlat0.xy * vec2(0.159999996, 0.159999996);
    u_xlat3.z = u_xlat4.y;
    u_xlat3.w = u_xlat16.y;
    u_xlat4.w = u_xlat16.x;
    u_xlat5.zw = u_xlat1.yz;
    u_xlat0.xyw = vec3(u_xlat3.z + u_xlat5.z, u_xlat3.y + u_xlat5.y, u_xlat3.w + u_xlat5.w);
    u_xlat4.z = u_xlat3.x;
    u_xlat3.xyz = vec3(u_xlat5.z / u_xlat0.x, u_xlat5.y / u_xlat0.y, u_xlat5.w / u_xlat0.w);
    u_xlat1.z = u_xlat5.x;
    u_xlat3.xyz = u_xlat3.xyz + vec3(-2.5, -0.5, 1.5);
    u_xlat3.xyz = u_xlat3.xyz * _ShadowMapTexture_TexelSize.yyy;
    u_xlat5.w = u_xlat3.x;
    u_xlat4 = u_xlat1.zwxz + u_xlat4.zwxz;
    u_xlat6.xyz = vec3(u_xlat1.x / u_xlat4.z, u_xlat1.z / u_xlat4.w, u_xlat1.w / u_xlat4.y);
    u_xlat6.xyz = u_xlat6.xyz + vec3(-2.5, -0.5, 1.5);
    u_xlat5.xyz = u_xlat6.yxz * _ShadowMapTexture_TexelSize.xxx;
    u_xlat1 = u_xlat2.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.ywxw;
    u_xlat16.xy = u_xlat2.xy * _ShadowMapTexture_TexelSize.xy + u_xlat5.zw;
    vec3 txVec0 = vec3(u_xlat16.xy,u_xlat0.z);
    u_xlat10_16 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    vec3 txVec1 = vec3(u_xlat1.xy,u_xlat0.z);
    u_xlat10_23 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec1, 0.0);
    vec3 txVec2 = vec3(u_xlat1.zw,u_xlat0.z);
    u_xlat10_3 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec2, 0.0);
    u_xlat1 = vec4(u_xlat0.x * u_xlat4.z, u_xlat0.x * u_xlat4.w, u_xlat0.x * u_xlat4.y, u_xlat0.y * u_xlat4.z);
    u_xlat0.x = u_xlat10_3 * u_xlat1.y;
    u_xlat0.x = u_xlat1.x * u_xlat10_23 + u_xlat0.x;
    u_xlat0.x = u_xlat1.z * u_xlat10_16 + u_xlat0.x;
    u_xlat3.w = u_xlat5.y;
    u_xlat6 = u_xlat2.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat3.wywz;
    u_xlat5.yw = u_xlat3.yz;
    vec3 txVec3 = vec3(u_xlat6.xy,u_xlat0.z);
    u_xlat10_16 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec3, 0.0);
    vec3 txVec4 = vec3(u_xlat6.zw,u_xlat0.z);
    u_xlat10_23 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec4, 0.0);
    u_xlat0.x = u_xlat1.w * u_xlat10_16 + u_xlat0.x;
    u_xlat1 = u_xlat2.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xyzy;
    u_xlat3 = u_xlat2.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xwzw;
    vec3 txVec5 = vec3(u_xlat1.xy,u_xlat0.z);
    u_xlat10_2 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec5, 0.0);
    vec3 txVec6 = vec3(u_xlat1.zw,u_xlat0.z);
    u_xlat10_9 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec6, 0.0);
    u_xlat1 = vec4(u_xlat0.y * u_xlat4.x, u_xlat0.y * u_xlat4.y, u_xlat0.w * u_xlat4.z, u_xlat0.w * u_xlat4.w);
    u_xlat7 = u_xlat0.w * u_xlat4.y;
    u_xlat0.x = u_xlat1.x * u_xlat10_2 + u_xlat0.x;
    u_xlat0.x = u_xlat1.y * u_xlat10_9 + u_xlat0.x;
    u_xlat0.x = u_xlat1.z * u_xlat10_23 + u_xlat0.x;
    vec3 txVec7 = vec3(u_xlat3.xy,u_xlat0.z);
    u_xlat10_21 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec7, 0.0);
    vec3 txVec8 = vec3(u_xlat3.zw,u_xlat0.z);
    u_xlat10_14 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec8, 0.0);
    u_xlat0.x = u_xlat1.w * u_xlat10_21 + u_xlat0.x;
    u_xlat0.x = u_xlat7 * u_xlat10_14 + u_xlat0.x;
    u_xlat16_7 = (-_LightShadowData.x) + 1.0;
    u_xlat0 = u_xlat0.xxxx * vec4(u_xlat16_7) + _LightShadowData.xxxx;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "SHADOWS_SPLIT_SPHERES" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec3 orthoPosFar_1;
  highp vec3 orthoPosNear_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _glesVertex.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  clipPos_3.xzw = tmpvar_5.xzw;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 o_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_5.zw;
  tmpvar_4.zw = o_7.xy;
  clipPos_3.y = (tmpvar_5.y * _ProjectionParams.x);
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(-1.0, 1.0);
  tmpvar_10.xy = clipPos_3.xy;
  highp vec3 tmpvar_11;
  tmpvar_11 = (unity_CameraInvProjection * tmpvar_10).xyz;
  orthoPosNear_2.xy = tmpvar_11.xy;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(1.0, 1.0);
  tmpvar_12.xy = clipPos_3.xy;
  highp vec3 tmpvar_13;
  tmpvar_13 = (unity_CameraInvProjection * tmpvar_12).xyz;
  orthoPosFar_1.xy = tmpvar_13.xy;
  orthoPosNear_2.z = -(tmpvar_11.z);
  orthoPosFar_1.z = -(tmpvar_13.z);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = _glesMultiTexCoord1.xyz;
  xlv_TEXCOORD2 = orthoPosNear_2;
  xlv_TEXCOORD3 = orthoPosFar_1;
}


#endif
#ifdef FRAGMENT
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_OrthoParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_CameraDepthTexture, xlv_TEXCOORD0.xy);
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = mix ((xlv_TEXCOORD1 * mix (
    (1.0/(((_ZBufferParams.x * tmpvar_2.x) + _ZBufferParams.y)))
  , tmpvar_2.x, unity_OrthoParams.w)), mix (xlv_TEXCOORD2, xlv_TEXCOORD3, tmpvar_2.xxx), unity_OrthoParams.www);
  highp vec4 tmpvar_4;
  tmpvar_4 = (unity_CameraToWorld * tmpvar_3);
  lowp vec4 weights_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_4.xyz - unity_ShadowSplitSpheres[0].xyz);
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_4.xyz - unity_ShadowSplitSpheres[1].xyz);
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_4.xyz - unity_ShadowSplitSpheres[2].xyz);
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_4.xyz - unity_ShadowSplitSpheres[3].xyz);
  highp vec4 tmpvar_10;
  tmpvar_10.x = dot (tmpvar_6, tmpvar_6);
  tmpvar_10.y = dot (tmpvar_7, tmpvar_7);
  tmpvar_10.z = dot (tmpvar_8, tmpvar_8);
  tmpvar_10.w = dot (tmpvar_9, tmpvar_9);
  bvec4 tmpvar_11;
  tmpvar_11 = lessThan (tmpvar_10, unity_ShadowSplitSqRadii);
  lowp vec4 tmpvar_12;
  tmpvar_12 = vec4(tmpvar_11);
  weights_5.x = tmpvar_12.x;
  weights_5.yzw = clamp ((tmpvar_12.yzw - tmpvar_12.xyz), 0.0, 1.0);
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = (((
    ((unity_WorldToShadow[0] * tmpvar_4).xyz * tmpvar_12.x)
   + 
    ((unity_WorldToShadow[1] * tmpvar_4).xyz * weights_5.y)
  ) + (
    (unity_WorldToShadow[2] * tmpvar_4)
  .xyz * weights_5.z)) + ((unity_WorldToShadow[3] * tmpvar_4).xyz * weights_5.w));
  mediump float shadow_14;
  highp vec2 tmpvar_15;
  tmpvar_15 = _ShadowMapTexture_TexelSize.xy;
  shadow_14 = 0.0;
  highp vec3 tmpvar_16;
  tmpvar_16.xy = (tmpvar_13.xy - _ShadowMapTexture_TexelSize.xy);
  tmpvar_16.z = tmpvar_13.z;
  highp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_ShadowMapTexture, tmpvar_16.xy);
  mediump float tmpvar_18;
  if ((tmpvar_17.x < tmpvar_13.z)) {
    tmpvar_18 = 0.0;
  } else {
    tmpvar_18 = 1.0;
  };
  shadow_14 = tmpvar_18;
  highp vec2 tmpvar_19;
  tmpvar_19.x = 0.0;
  tmpvar_19.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_20;
  tmpvar_20.xy = (tmpvar_13.xy + tmpvar_19);
  tmpvar_20.z = tmpvar_13.z;
  highp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_ShadowMapTexture, tmpvar_20.xy);
  highp float tmpvar_22;
  if ((tmpvar_21.x < tmpvar_13.z)) {
    tmpvar_22 = 0.0;
  } else {
    tmpvar_22 = 1.0;
  };
  shadow_14 = (tmpvar_18 + tmpvar_22);
  highp vec2 tmpvar_23;
  tmpvar_23.x = tmpvar_15.x;
  tmpvar_23.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_24;
  tmpvar_24.xy = (tmpvar_13.xy + tmpvar_23);
  tmpvar_24.z = tmpvar_13.z;
  highp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_ShadowMapTexture, tmpvar_24.xy);
  highp float tmpvar_26;
  if ((tmpvar_25.x < tmpvar_13.z)) {
    tmpvar_26 = 0.0;
  } else {
    tmpvar_26 = 1.0;
  };
  shadow_14 = (shadow_14 + tmpvar_26);
  highp vec2 tmpvar_27;
  tmpvar_27.y = 0.0;
  tmpvar_27.x = -(_ShadowMapTexture_TexelSize.x);
  highp vec3 tmpvar_28;
  tmpvar_28.xy = (tmpvar_13.xy + tmpvar_27);
  tmpvar_28.z = tmpvar_13.z;
  highp vec4 tmpvar_29;
  tmpvar_29 = texture2D (_ShadowMapTexture, tmpvar_28.xy);
  highp float tmpvar_30;
  if ((tmpvar_29.x < tmpvar_13.z)) {
    tmpvar_30 = 0.0;
  } else {
    tmpvar_30 = 1.0;
  };
  shadow_14 = (shadow_14 + tmpvar_30);
  highp vec4 tmpvar_31;
  tmpvar_31 = texture2D (_ShadowMapTexture, tmpvar_13.xy);
  highp float tmpvar_32;
  if ((tmpvar_31.x < tmpvar_13.z)) {
    tmpvar_32 = 0.0;
  } else {
    tmpvar_32 = 1.0;
  };
  shadow_14 = (shadow_14 + tmpvar_32);
  highp vec2 tmpvar_33;
  tmpvar_33.y = 0.0;
  tmpvar_33.x = tmpvar_15.x;
  highp vec3 tmpvar_34;
  tmpvar_34.xy = (tmpvar_13.xy + tmpvar_33);
  tmpvar_34.z = tmpvar_13.z;
  highp vec4 tmpvar_35;
  tmpvar_35 = texture2D (_ShadowMapTexture, tmpvar_34.xy);
  highp float tmpvar_36;
  if ((tmpvar_35.x < tmpvar_13.z)) {
    tmpvar_36 = 0.0;
  } else {
    tmpvar_36 = 1.0;
  };
  shadow_14 = (shadow_14 + tmpvar_36);
  highp vec2 tmpvar_37;
  tmpvar_37.x = -(_ShadowMapTexture_TexelSize.x);
  tmpvar_37.y = tmpvar_15.y;
  highp vec3 tmpvar_38;
  tmpvar_38.xy = (tmpvar_13.xy + tmpvar_37);
  tmpvar_38.z = tmpvar_13.z;
  highp vec4 tmpvar_39;
  tmpvar_39 = texture2D (_ShadowMapTexture, tmpvar_38.xy);
  highp float tmpvar_40;
  if ((tmpvar_39.x < tmpvar_13.z)) {
    tmpvar_40 = 0.0;
  } else {
    tmpvar_40 = 1.0;
  };
  shadow_14 = (shadow_14 + tmpvar_40);
  highp vec2 tmpvar_41;
  tmpvar_41.x = 0.0;
  tmpvar_41.y = tmpvar_15.y;
  highp vec3 tmpvar_42;
  tmpvar_42.xy = (tmpvar_13.xy + tmpvar_41);
  tmpvar_42.z = tmpvar_13.z;
  highp vec4 tmpvar_43;
  tmpvar_43 = texture2D (_ShadowMapTexture, tmpvar_42.xy);
  highp float tmpvar_44;
  if ((tmpvar_43.x < tmpvar_13.z)) {
    tmpvar_44 = 0.0;
  } else {
    tmpvar_44 = 1.0;
  };
  shadow_14 = (shadow_14 + tmpvar_44);
  highp vec3 tmpvar_45;
  tmpvar_45.xy = (tmpvar_13.xy + _ShadowMapTexture_TexelSize.xy);
  tmpvar_45.z = tmpvar_13.z;
  highp vec4 tmpvar_46;
  tmpvar_46 = texture2D (_ShadowMapTexture, tmpvar_45.xy);
  highp float tmpvar_47;
  if ((tmpvar_46.x < tmpvar_13.z)) {
    tmpvar_47 = 0.0;
  } else {
    tmpvar_47 = 1.0;
  };
  shadow_14 = (shadow_14 + tmpvar_47);
  shadow_14 = (shadow_14 / 9.0);
  mediump vec4 tmpvar_48;
  tmpvar_48 = vec4(mix (_LightShadowData.x, 1.0, shadow_14));
  tmpvar_1 = tmpvar_48;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "SHADOWS_SPLIT_SPHERES" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec3 orthoPosFar_1;
  highp vec3 orthoPosNear_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _glesVertex.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  clipPos_3.xzw = tmpvar_5.xzw;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 o_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_5.zw;
  tmpvar_4.zw = o_7.xy;
  clipPos_3.y = (tmpvar_5.y * _ProjectionParams.x);
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(-1.0, 1.0);
  tmpvar_10.xy = clipPos_3.xy;
  highp vec3 tmpvar_11;
  tmpvar_11 = (unity_CameraInvProjection * tmpvar_10).xyz;
  orthoPosNear_2.xy = tmpvar_11.xy;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(1.0, 1.0);
  tmpvar_12.xy = clipPos_3.xy;
  highp vec3 tmpvar_13;
  tmpvar_13 = (unity_CameraInvProjection * tmpvar_12).xyz;
  orthoPosFar_1.xy = tmpvar_13.xy;
  orthoPosNear_2.z = -(tmpvar_11.z);
  orthoPosFar_1.z = -(tmpvar_13.z);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = _glesMultiTexCoord1.xyz;
  xlv_TEXCOORD2 = orthoPosNear_2;
  xlv_TEXCOORD3 = orthoPosFar_1;
}


#endif
#ifdef FRAGMENT
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_OrthoParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_CameraDepthTexture, xlv_TEXCOORD0.xy);
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = mix ((xlv_TEXCOORD1 * mix (
    (1.0/(((_ZBufferParams.x * tmpvar_2.x) + _ZBufferParams.y)))
  , tmpvar_2.x, unity_OrthoParams.w)), mix (xlv_TEXCOORD2, xlv_TEXCOORD3, tmpvar_2.xxx), unity_OrthoParams.www);
  highp vec4 tmpvar_4;
  tmpvar_4 = (unity_CameraToWorld * tmpvar_3);
  lowp vec4 weights_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_4.xyz - unity_ShadowSplitSpheres[0].xyz);
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_4.xyz - unity_ShadowSplitSpheres[1].xyz);
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_4.xyz - unity_ShadowSplitSpheres[2].xyz);
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_4.xyz - unity_ShadowSplitSpheres[3].xyz);
  highp vec4 tmpvar_10;
  tmpvar_10.x = dot (tmpvar_6, tmpvar_6);
  tmpvar_10.y = dot (tmpvar_7, tmpvar_7);
  tmpvar_10.z = dot (tmpvar_8, tmpvar_8);
  tmpvar_10.w = dot (tmpvar_9, tmpvar_9);
  bvec4 tmpvar_11;
  tmpvar_11 = lessThan (tmpvar_10, unity_ShadowSplitSqRadii);
  lowp vec4 tmpvar_12;
  tmpvar_12 = vec4(tmpvar_11);
  weights_5.x = tmpvar_12.x;
  weights_5.yzw = clamp ((tmpvar_12.yzw - tmpvar_12.xyz), 0.0, 1.0);
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = (((
    ((unity_WorldToShadow[0] * tmpvar_4).xyz * tmpvar_12.x)
   + 
    ((unity_WorldToShadow[1] * tmpvar_4).xyz * weights_5.y)
  ) + (
    (unity_WorldToShadow[2] * tmpvar_4)
  .xyz * weights_5.z)) + ((unity_WorldToShadow[3] * tmpvar_4).xyz * weights_5.w));
  mediump float shadow_14;
  highp vec2 tmpvar_15;
  tmpvar_15 = _ShadowMapTexture_TexelSize.xy;
  shadow_14 = 0.0;
  highp vec3 tmpvar_16;
  tmpvar_16.xy = (tmpvar_13.xy - _ShadowMapTexture_TexelSize.xy);
  tmpvar_16.z = tmpvar_13.z;
  highp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_ShadowMapTexture, tmpvar_16.xy);
  mediump float tmpvar_18;
  if ((tmpvar_17.x < tmpvar_13.z)) {
    tmpvar_18 = 0.0;
  } else {
    tmpvar_18 = 1.0;
  };
  shadow_14 = tmpvar_18;
  highp vec2 tmpvar_19;
  tmpvar_19.x = 0.0;
  tmpvar_19.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_20;
  tmpvar_20.xy = (tmpvar_13.xy + tmpvar_19);
  tmpvar_20.z = tmpvar_13.z;
  highp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_ShadowMapTexture, tmpvar_20.xy);
  highp float tmpvar_22;
  if ((tmpvar_21.x < tmpvar_13.z)) {
    tmpvar_22 = 0.0;
  } else {
    tmpvar_22 = 1.0;
  };
  shadow_14 = (tmpvar_18 + tmpvar_22);
  highp vec2 tmpvar_23;
  tmpvar_23.x = tmpvar_15.x;
  tmpvar_23.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_24;
  tmpvar_24.xy = (tmpvar_13.xy + tmpvar_23);
  tmpvar_24.z = tmpvar_13.z;
  highp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_ShadowMapTexture, tmpvar_24.xy);
  highp float tmpvar_26;
  if ((tmpvar_25.x < tmpvar_13.z)) {
    tmpvar_26 = 0.0;
  } else {
    tmpvar_26 = 1.0;
  };
  shadow_14 = (shadow_14 + tmpvar_26);
  highp vec2 tmpvar_27;
  tmpvar_27.y = 0.0;
  tmpvar_27.x = -(_ShadowMapTexture_TexelSize.x);
  highp vec3 tmpvar_28;
  tmpvar_28.xy = (tmpvar_13.xy + tmpvar_27);
  tmpvar_28.z = tmpvar_13.z;
  highp vec4 tmpvar_29;
  tmpvar_29 = texture2D (_ShadowMapTexture, tmpvar_28.xy);
  highp float tmpvar_30;
  if ((tmpvar_29.x < tmpvar_13.z)) {
    tmpvar_30 = 0.0;
  } else {
    tmpvar_30 = 1.0;
  };
  shadow_14 = (shadow_14 + tmpvar_30);
  highp vec4 tmpvar_31;
  tmpvar_31 = texture2D (_ShadowMapTexture, tmpvar_13.xy);
  highp float tmpvar_32;
  if ((tmpvar_31.x < tmpvar_13.z)) {
    tmpvar_32 = 0.0;
  } else {
    tmpvar_32 = 1.0;
  };
  shadow_14 = (shadow_14 + tmpvar_32);
  highp vec2 tmpvar_33;
  tmpvar_33.y = 0.0;
  tmpvar_33.x = tmpvar_15.x;
  highp vec3 tmpvar_34;
  tmpvar_34.xy = (tmpvar_13.xy + tmpvar_33);
  tmpvar_34.z = tmpvar_13.z;
  highp vec4 tmpvar_35;
  tmpvar_35 = texture2D (_ShadowMapTexture, tmpvar_34.xy);
  highp float tmpvar_36;
  if ((tmpvar_35.x < tmpvar_13.z)) {
    tmpvar_36 = 0.0;
  } else {
    tmpvar_36 = 1.0;
  };
  shadow_14 = (shadow_14 + tmpvar_36);
  highp vec2 tmpvar_37;
  tmpvar_37.x = -(_ShadowMapTexture_TexelSize.x);
  tmpvar_37.y = tmpvar_15.y;
  highp vec3 tmpvar_38;
  tmpvar_38.xy = (tmpvar_13.xy + tmpvar_37);
  tmpvar_38.z = tmpvar_13.z;
  highp vec4 tmpvar_39;
  tmpvar_39 = texture2D (_ShadowMapTexture, tmpvar_38.xy);
  highp float tmpvar_40;
  if ((tmpvar_39.x < tmpvar_13.z)) {
    tmpvar_40 = 0.0;
  } else {
    tmpvar_40 = 1.0;
  };
  shadow_14 = (shadow_14 + tmpvar_40);
  highp vec2 tmpvar_41;
  tmpvar_41.x = 0.0;
  tmpvar_41.y = tmpvar_15.y;
  highp vec3 tmpvar_42;
  tmpvar_42.xy = (tmpvar_13.xy + tmpvar_41);
  tmpvar_42.z = tmpvar_13.z;
  highp vec4 tmpvar_43;
  tmpvar_43 = texture2D (_ShadowMapTexture, tmpvar_42.xy);
  highp float tmpvar_44;
  if ((tmpvar_43.x < tmpvar_13.z)) {
    tmpvar_44 = 0.0;
  } else {
    tmpvar_44 = 1.0;
  };
  shadow_14 = (shadow_14 + tmpvar_44);
  highp vec3 tmpvar_45;
  tmpvar_45.xy = (tmpvar_13.xy + _ShadowMapTexture_TexelSize.xy);
  tmpvar_45.z = tmpvar_13.z;
  highp vec4 tmpvar_46;
  tmpvar_46 = texture2D (_ShadowMapTexture, tmpvar_45.xy);
  highp float tmpvar_47;
  if ((tmpvar_46.x < tmpvar_13.z)) {
    tmpvar_47 = 0.0;
  } else {
    tmpvar_47 = 1.0;
  };
  shadow_14 = (shadow_14 + tmpvar_47);
  shadow_14 = (shadow_14 / 9.0);
  mediump vec4 tmpvar_48;
  tmpvar_48 = vec4(mix (_LightShadowData.x, 1.0, shadow_14));
  tmpvar_1 = tmpvar_48;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "SHADOWS_SPLIT_SPHERES" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec3 orthoPosFar_1;
  highp vec3 orthoPosNear_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _glesVertex.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  clipPos_3.xzw = tmpvar_5.xzw;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 o_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_5.zw;
  tmpvar_4.zw = o_7.xy;
  clipPos_3.y = (tmpvar_5.y * _ProjectionParams.x);
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(-1.0, 1.0);
  tmpvar_10.xy = clipPos_3.xy;
  highp vec3 tmpvar_11;
  tmpvar_11 = (unity_CameraInvProjection * tmpvar_10).xyz;
  orthoPosNear_2.xy = tmpvar_11.xy;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(1.0, 1.0);
  tmpvar_12.xy = clipPos_3.xy;
  highp vec3 tmpvar_13;
  tmpvar_13 = (unity_CameraInvProjection * tmpvar_12).xyz;
  orthoPosFar_1.xy = tmpvar_13.xy;
  orthoPosNear_2.z = -(tmpvar_11.z);
  orthoPosFar_1.z = -(tmpvar_13.z);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = _glesMultiTexCoord1.xyz;
  xlv_TEXCOORD2 = orthoPosNear_2;
  xlv_TEXCOORD3 = orthoPosFar_1;
}


#endif
#ifdef FRAGMENT
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_OrthoParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_CameraDepthTexture, xlv_TEXCOORD0.xy);
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = mix ((xlv_TEXCOORD1 * mix (
    (1.0/(((_ZBufferParams.x * tmpvar_2.x) + _ZBufferParams.y)))
  , tmpvar_2.x, unity_OrthoParams.w)), mix (xlv_TEXCOORD2, xlv_TEXCOORD3, tmpvar_2.xxx), unity_OrthoParams.www);
  highp vec4 tmpvar_4;
  tmpvar_4 = (unity_CameraToWorld * tmpvar_3);
  lowp vec4 weights_5;
  highp vec3 tmpvar_6;
  tmpvar_6 = (tmpvar_4.xyz - unity_ShadowSplitSpheres[0].xyz);
  highp vec3 tmpvar_7;
  tmpvar_7 = (tmpvar_4.xyz - unity_ShadowSplitSpheres[1].xyz);
  highp vec3 tmpvar_8;
  tmpvar_8 = (tmpvar_4.xyz - unity_ShadowSplitSpheres[2].xyz);
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_4.xyz - unity_ShadowSplitSpheres[3].xyz);
  highp vec4 tmpvar_10;
  tmpvar_10.x = dot (tmpvar_6, tmpvar_6);
  tmpvar_10.y = dot (tmpvar_7, tmpvar_7);
  tmpvar_10.z = dot (tmpvar_8, tmpvar_8);
  tmpvar_10.w = dot (tmpvar_9, tmpvar_9);
  bvec4 tmpvar_11;
  tmpvar_11 = lessThan (tmpvar_10, unity_ShadowSplitSqRadii);
  lowp vec4 tmpvar_12;
  tmpvar_12 = vec4(tmpvar_11);
  weights_5.x = tmpvar_12.x;
  weights_5.yzw = clamp ((tmpvar_12.yzw - tmpvar_12.xyz), 0.0, 1.0);
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = (((
    ((unity_WorldToShadow[0] * tmpvar_4).xyz * tmpvar_12.x)
   + 
    ((unity_WorldToShadow[1] * tmpvar_4).xyz * weights_5.y)
  ) + (
    (unity_WorldToShadow[2] * tmpvar_4)
  .xyz * weights_5.z)) + ((unity_WorldToShadow[3] * tmpvar_4).xyz * weights_5.w));
  mediump float shadow_14;
  highp vec2 tmpvar_15;
  tmpvar_15 = _ShadowMapTexture_TexelSize.xy;
  shadow_14 = 0.0;
  highp vec3 tmpvar_16;
  tmpvar_16.xy = (tmpvar_13.xy - _ShadowMapTexture_TexelSize.xy);
  tmpvar_16.z = tmpvar_13.z;
  highp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_ShadowMapTexture, tmpvar_16.xy);
  mediump float tmpvar_18;
  if ((tmpvar_17.x < tmpvar_13.z)) {
    tmpvar_18 = 0.0;
  } else {
    tmpvar_18 = 1.0;
  };
  shadow_14 = tmpvar_18;
  highp vec2 tmpvar_19;
  tmpvar_19.x = 0.0;
  tmpvar_19.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_20;
  tmpvar_20.xy = (tmpvar_13.xy + tmpvar_19);
  tmpvar_20.z = tmpvar_13.z;
  highp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_ShadowMapTexture, tmpvar_20.xy);
  highp float tmpvar_22;
  if ((tmpvar_21.x < tmpvar_13.z)) {
    tmpvar_22 = 0.0;
  } else {
    tmpvar_22 = 1.0;
  };
  shadow_14 = (tmpvar_18 + tmpvar_22);
  highp vec2 tmpvar_23;
  tmpvar_23.x = tmpvar_15.x;
  tmpvar_23.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_24;
  tmpvar_24.xy = (tmpvar_13.xy + tmpvar_23);
  tmpvar_24.z = tmpvar_13.z;
  highp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_ShadowMapTexture, tmpvar_24.xy);
  highp float tmpvar_26;
  if ((tmpvar_25.x < tmpvar_13.z)) {
    tmpvar_26 = 0.0;
  } else {
    tmpvar_26 = 1.0;
  };
  shadow_14 = (shadow_14 + tmpvar_26);
  highp vec2 tmpvar_27;
  tmpvar_27.y = 0.0;
  tmpvar_27.x = -(_ShadowMapTexture_TexelSize.x);
  highp vec3 tmpvar_28;
  tmpvar_28.xy = (tmpvar_13.xy + tmpvar_27);
  tmpvar_28.z = tmpvar_13.z;
  highp vec4 tmpvar_29;
  tmpvar_29 = texture2D (_ShadowMapTexture, tmpvar_28.xy);
  highp float tmpvar_30;
  if ((tmpvar_29.x < tmpvar_13.z)) {
    tmpvar_30 = 0.0;
  } else {
    tmpvar_30 = 1.0;
  };
  shadow_14 = (shadow_14 + tmpvar_30);
  highp vec4 tmpvar_31;
  tmpvar_31 = texture2D (_ShadowMapTexture, tmpvar_13.xy);
  highp float tmpvar_32;
  if ((tmpvar_31.x < tmpvar_13.z)) {
    tmpvar_32 = 0.0;
  } else {
    tmpvar_32 = 1.0;
  };
  shadow_14 = (shadow_14 + tmpvar_32);
  highp vec2 tmpvar_33;
  tmpvar_33.y = 0.0;
  tmpvar_33.x = tmpvar_15.x;
  highp vec3 tmpvar_34;
  tmpvar_34.xy = (tmpvar_13.xy + tmpvar_33);
  tmpvar_34.z = tmpvar_13.z;
  highp vec4 tmpvar_35;
  tmpvar_35 = texture2D (_ShadowMapTexture, tmpvar_34.xy);
  highp float tmpvar_36;
  if ((tmpvar_35.x < tmpvar_13.z)) {
    tmpvar_36 = 0.0;
  } else {
    tmpvar_36 = 1.0;
  };
  shadow_14 = (shadow_14 + tmpvar_36);
  highp vec2 tmpvar_37;
  tmpvar_37.x = -(_ShadowMapTexture_TexelSize.x);
  tmpvar_37.y = tmpvar_15.y;
  highp vec3 tmpvar_38;
  tmpvar_38.xy = (tmpvar_13.xy + tmpvar_37);
  tmpvar_38.z = tmpvar_13.z;
  highp vec4 tmpvar_39;
  tmpvar_39 = texture2D (_ShadowMapTexture, tmpvar_38.xy);
  highp float tmpvar_40;
  if ((tmpvar_39.x < tmpvar_13.z)) {
    tmpvar_40 = 0.0;
  } else {
    tmpvar_40 = 1.0;
  };
  shadow_14 = (shadow_14 + tmpvar_40);
  highp vec2 tmpvar_41;
  tmpvar_41.x = 0.0;
  tmpvar_41.y = tmpvar_15.y;
  highp vec3 tmpvar_42;
  tmpvar_42.xy = (tmpvar_13.xy + tmpvar_41);
  tmpvar_42.z = tmpvar_13.z;
  highp vec4 tmpvar_43;
  tmpvar_43 = texture2D (_ShadowMapTexture, tmpvar_42.xy);
  highp float tmpvar_44;
  if ((tmpvar_43.x < tmpvar_13.z)) {
    tmpvar_44 = 0.0;
  } else {
    tmpvar_44 = 1.0;
  };
  shadow_14 = (shadow_14 + tmpvar_44);
  highp vec3 tmpvar_45;
  tmpvar_45.xy = (tmpvar_13.xy + _ShadowMapTexture_TexelSize.xy);
  tmpvar_45.z = tmpvar_13.z;
  highp vec4 tmpvar_46;
  tmpvar_46 = texture2D (_ShadowMapTexture, tmpvar_45.xy);
  highp float tmpvar_47;
  if ((tmpvar_46.x < tmpvar_13.z)) {
    tmpvar_47 = 0.0;
  } else {
    tmpvar_47 = 1.0;
  };
  shadow_14 = (shadow_14 + tmpvar_47);
  shadow_14 = (shadow_14 / 9.0);
  mediump vec4 tmpvar_48;
  tmpvar_48 = vec4(mix (_LightShadowData.x, 1.0, shadow_14));
  tmpvar_1 = tmpvar_48;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SHADOWS_SPLIT_SPHERES" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
in highp vec3 in_TEXCOORD1;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
out highp vec3 vs_TEXCOORD2;
out highp vec3 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
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
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraInvProjection[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraInvProjection[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    vs_TEXCOORD0.zw = u_xlat1.zz + u_xlat1.xw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    vs_TEXCOORD1.xyz = in_TEXCOORD1.xyz;
    u_xlat1.xyz = u_xlat0.xyz + (-hlslcc_mtx4x4unity_CameraInvProjection[2].xyz);
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[2].xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.w = (-u_xlat1.z);
    vs_TEXCOORD2.xyz = u_xlat1.xyw;
    u_xlat0.w = (-u_xlat0.z);
    vs_TEXCOORD3.xyz = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 unity_OrthoParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 unity_ShadowSplitSpheres[4];
uniform 	vec4 unity_ShadowSplitSqRadii;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
in highp vec3 vs_TEXCOORD2;
in highp vec3 vs_TEXCOORD3;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp float u_xlat10_1;
bvec4 u_xlatb1;
vec4 u_xlat2;
vec4 u_xlat3;
mediump vec3 u_xlat16_3;
vec4 u_xlat4;
lowp float u_xlat10_4;
vec4 u_xlat5;
vec4 u_xlat6;
float u_xlat7;
mediump float u_xlat16_7;
vec3 u_xlat8;
lowp float u_xlat10_8;
float u_xlat14;
lowp float u_xlat10_14;
vec2 u_xlat15;
lowp float u_xlat10_15;
lowp float u_xlat10_21;
lowp float u_xlat10_22;
void main()
{
    u_xlat0.x = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat7 = _ZBufferParams.x * u_xlat0.x + _ZBufferParams.y;
    u_xlat7 = float(1.0) / u_xlat7;
    u_xlat14 = (-u_xlat7) + u_xlat0.x;
    u_xlat7 = unity_OrthoParams.w * u_xlat14 + u_xlat7;
    u_xlat1.xyz = (-vs_TEXCOORD2.xyz) + vs_TEXCOORD3.xyz;
    u_xlat0.xzw = u_xlat0.xxx * u_xlat1.xyz + vs_TEXCOORD2.xyz;
    u_xlat0.xzw = (-vs_TEXCOORD1.xyz) * vec3(u_xlat7) + u_xlat0.xzw;
    u_xlat1.xyz = vec3(u_xlat7) * vs_TEXCOORD1.xyz;
    u_xlat0.xyz = unity_OrthoParams.www * u_xlat0.xzw + u_xlat1.xyz;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat1.xyz = u_xlat0.xyz + (-unity_ShadowSplitSpheres[0].xyz);
    u_xlat1.x = dot(u_xlat1.xyz, u_xlat1.xyz);
    u_xlat2.xyz = u_xlat0.xyz + (-unity_ShadowSplitSpheres[1].xyz);
    u_xlat1.y = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat2.xyz = u_xlat0.xyz + (-unity_ShadowSplitSpheres[2].xyz);
    u_xlat1.z = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat2.xyz = u_xlat0.xyz + (-unity_ShadowSplitSpheres[3].xyz);
    u_xlat1.w = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlatb1 = lessThan(u_xlat1, unity_ShadowSplitSqRadii);
    u_xlat16_3.x = (u_xlatb1.x) ? float(-1.0) : float(-0.0);
    u_xlat16_3.y = (u_xlatb1.y) ? float(-1.0) : float(-0.0);
    u_xlat16_3.z = (u_xlatb1.z) ? float(-1.0) : float(-0.0);
    u_xlat1 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb1));
    u_xlat16_3.xyz = vec3(u_xlat16_3.x + u_xlat1.y, u_xlat16_3.y + u_xlat1.z, u_xlat16_3.z + u_xlat1.w);
    u_xlat16_3.xyz = max(u_xlat16_3.xyz, vec3(0.0, 0.0, 0.0));
    u_xlat8.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[5].xyz;
    u_xlat8.xyz = hlslcc_mtx4x4unity_WorldToShadow[4].xyz * u_xlat0.xxx + u_xlat8.xyz;
    u_xlat8.xyz = hlslcc_mtx4x4unity_WorldToShadow[6].xyz * u_xlat0.zzz + u_xlat8.xyz;
    u_xlat8.xyz = hlslcc_mtx4x4unity_WorldToShadow[7].xyz * u_xlat0.www + u_xlat8.xyz;
    u_xlat8.xyz = u_xlat16_3.xxx * u_xlat8.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[3].xyz * u_xlat0.www + u_xlat2.xyz;
    u_xlat1.xyz = u_xlat2.xyz * u_xlat1.xxx + u_xlat8.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[9].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[8].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[10].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[11].xyz * u_xlat0.www + u_xlat2.xyz;
    u_xlat1.xyz = u_xlat2.xyz * u_xlat16_3.yyy + u_xlat1.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[13].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[12].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[14].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[15].xyz * u_xlat0.www + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_3.zzz + u_xlat1.xyz;
    u_xlat1.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + vec2(0.5, 0.5);
    u_xlat1.xy = floor(u_xlat1.xy);
    u_xlat0.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + (-u_xlat1.xy);
    u_xlat15.xy = max(u_xlat0.xy, vec2(0.0, 0.0));
    u_xlat2 = u_xlat0.xxyy + vec4(0.5, 1.0, 0.5, 1.0);
    u_xlat15.xy = (-u_xlat15.xy) * u_xlat15.xy + u_xlat2.yw;
    u_xlat15.xy = u_xlat15.xy + vec2(1.0, 1.0);
    u_xlat3.xy = u_xlat15.xy * vec2(0.159999996, 0.159999996);
    u_xlat15.xy = min(u_xlat0.xy, vec2(0.0, 0.0));
    u_xlat4.xy = (-u_xlat0.xy) + vec2(1.0, 1.0);
    u_xlat15.xy = (-u_xlat15.xy) * u_xlat15.xy + u_xlat4.xy;
    u_xlat4.xy = u_xlat4.xy * vec2(0.159999996, 0.159999996);
    u_xlat15.xy = u_xlat15.xy + vec2(1.0, 1.0);
    u_xlat5.xy = u_xlat15.xy * vec2(0.159999996, 0.159999996);
    u_xlat6 = u_xlat2.xxzz * u_xlat2.xxzz;
    u_xlat15.xy = vec2(u_xlat2.y * float(0.159999996), u_xlat2.w * float(0.159999996));
    u_xlat0.xy = u_xlat6.xz * vec2(0.5, 0.5) + (-u_xlat0.xy);
    u_xlat4.zw = vec2(u_xlat6.w * float(0.0799999982), u_xlat6.y * float(0.0799999982));
    u_xlat2.xy = u_xlat0.xy * vec2(0.159999996, 0.159999996);
    u_xlat5.z = u_xlat2.y;
    u_xlat5.w = u_xlat15.y;
    u_xlat2.w = u_xlat15.x;
    u_xlat3.zw = u_xlat4.yz;
    u_xlat0.xyw = vec3(u_xlat3.z + u_xlat5.z, u_xlat3.y + u_xlat5.y, u_xlat3.w + u_xlat5.w);
    u_xlat2.z = u_xlat5.x;
    u_xlat5.xyz = vec3(u_xlat3.z / u_xlat0.x, u_xlat3.y / u_xlat0.y, u_xlat3.w / u_xlat0.w);
    u_xlat4.z = u_xlat3.x;
    u_xlat5.xyz = u_xlat5.xyz + vec3(-2.5, -0.5, 1.5);
    u_xlat3.xyz = u_xlat5.xyz * _ShadowMapTexture_TexelSize.yyy;
    u_xlat5.w = u_xlat3.x;
    u_xlat2 = u_xlat2.zwxz + u_xlat4.zwxz;
    u_xlat4.xyz = vec3(u_xlat4.x / u_xlat2.z, u_xlat4.z / u_xlat2.w, u_xlat4.w / u_xlat2.y);
    u_xlat4.xyz = u_xlat4.xyz + vec3(-2.5, -0.5, 1.5);
    u_xlat5.xyz = u_xlat4.yxz * _ShadowMapTexture_TexelSize.xxx;
    u_xlat4 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.ywxw;
    u_xlat15.xy = u_xlat1.xy * _ShadowMapTexture_TexelSize.xy + u_xlat5.zw;
    vec3 txVec0 = vec3(u_xlat15.xy,u_xlat0.z);
    u_xlat10_15 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    vec3 txVec1 = vec3(u_xlat4.xy,u_xlat0.z);
    u_xlat10_22 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec1, 0.0);
    vec3 txVec2 = vec3(u_xlat4.zw,u_xlat0.z);
    u_xlat10_4 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec2, 0.0);
    u_xlat6 = vec4(u_xlat0.x * u_xlat2.z, u_xlat0.x * u_xlat2.w, u_xlat0.x * u_xlat2.y, u_xlat0.y * u_xlat2.z);
    u_xlat0.x = u_xlat10_4 * u_xlat6.y;
    u_xlat0.x = u_xlat6.x * u_xlat10_22 + u_xlat0.x;
    u_xlat0.x = u_xlat6.z * u_xlat10_15 + u_xlat0.x;
    u_xlat3.w = u_xlat5.y;
    u_xlat4 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat3.wywz;
    u_xlat5.yw = u_xlat3.yz;
    vec3 txVec3 = vec3(u_xlat4.xy,u_xlat0.z);
    u_xlat10_15 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec3, 0.0);
    vec3 txVec4 = vec3(u_xlat4.zw,u_xlat0.z);
    u_xlat10_22 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec4, 0.0);
    u_xlat0.x = u_xlat6.w * u_xlat10_15 + u_xlat0.x;
    u_xlat3 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xyzy;
    u_xlat4 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xwzw;
    vec3 txVec5 = vec3(u_xlat3.xy,u_xlat0.z);
    u_xlat10_1 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec5, 0.0);
    vec3 txVec6 = vec3(u_xlat3.zw,u_xlat0.z);
    u_xlat10_8 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec6, 0.0);
    u_xlat3 = vec4(u_xlat0.y * u_xlat2.x, u_xlat0.y * u_xlat2.y, u_xlat0.w * u_xlat2.z, u_xlat0.w * u_xlat2.w);
    u_xlat7 = u_xlat0.w * u_xlat2.y;
    u_xlat0.x = u_xlat3.x * u_xlat10_1 + u_xlat0.x;
    u_xlat0.x = u_xlat3.y * u_xlat10_8 + u_xlat0.x;
    u_xlat0.x = u_xlat3.z * u_xlat10_22 + u_xlat0.x;
    vec3 txVec7 = vec3(u_xlat4.xy,u_xlat0.z);
    u_xlat10_21 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec7, 0.0);
    vec3 txVec8 = vec3(u_xlat4.zw,u_xlat0.z);
    u_xlat10_14 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec8, 0.0);
    u_xlat0.x = u_xlat3.w * u_xlat10_21 + u_xlat0.x;
    u_xlat0.x = u_xlat7 * u_xlat10_14 + u_xlat0.x;
    u_xlat16_7 = (-_LightShadowData.x) + 1.0;
    u_xlat0 = u_xlat0.xxxx * vec4(u_xlat16_7) + _LightShadowData.xxxx;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SHADOWS_SPLIT_SPHERES" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
in highp vec3 in_TEXCOORD1;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
out highp vec3 vs_TEXCOORD2;
out highp vec3 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
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
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraInvProjection[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraInvProjection[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    vs_TEXCOORD0.zw = u_xlat1.zz + u_xlat1.xw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    vs_TEXCOORD1.xyz = in_TEXCOORD1.xyz;
    u_xlat1.xyz = u_xlat0.xyz + (-hlslcc_mtx4x4unity_CameraInvProjection[2].xyz);
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[2].xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.w = (-u_xlat1.z);
    vs_TEXCOORD2.xyz = u_xlat1.xyw;
    u_xlat0.w = (-u_xlat0.z);
    vs_TEXCOORD3.xyz = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 unity_OrthoParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 unity_ShadowSplitSpheres[4];
uniform 	vec4 unity_ShadowSplitSqRadii;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
in highp vec3 vs_TEXCOORD2;
in highp vec3 vs_TEXCOORD3;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp float u_xlat10_1;
bvec4 u_xlatb1;
vec4 u_xlat2;
vec4 u_xlat3;
mediump vec3 u_xlat16_3;
vec4 u_xlat4;
lowp float u_xlat10_4;
vec4 u_xlat5;
vec4 u_xlat6;
float u_xlat7;
mediump float u_xlat16_7;
vec3 u_xlat8;
lowp float u_xlat10_8;
float u_xlat14;
lowp float u_xlat10_14;
vec2 u_xlat15;
lowp float u_xlat10_15;
lowp float u_xlat10_21;
lowp float u_xlat10_22;
void main()
{
    u_xlat0.x = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat7 = _ZBufferParams.x * u_xlat0.x + _ZBufferParams.y;
    u_xlat7 = float(1.0) / u_xlat7;
    u_xlat14 = (-u_xlat7) + u_xlat0.x;
    u_xlat7 = unity_OrthoParams.w * u_xlat14 + u_xlat7;
    u_xlat1.xyz = (-vs_TEXCOORD2.xyz) + vs_TEXCOORD3.xyz;
    u_xlat0.xzw = u_xlat0.xxx * u_xlat1.xyz + vs_TEXCOORD2.xyz;
    u_xlat0.xzw = (-vs_TEXCOORD1.xyz) * vec3(u_xlat7) + u_xlat0.xzw;
    u_xlat1.xyz = vec3(u_xlat7) * vs_TEXCOORD1.xyz;
    u_xlat0.xyz = unity_OrthoParams.www * u_xlat0.xzw + u_xlat1.xyz;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat1.xyz = u_xlat0.xyz + (-unity_ShadowSplitSpheres[0].xyz);
    u_xlat1.x = dot(u_xlat1.xyz, u_xlat1.xyz);
    u_xlat2.xyz = u_xlat0.xyz + (-unity_ShadowSplitSpheres[1].xyz);
    u_xlat1.y = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat2.xyz = u_xlat0.xyz + (-unity_ShadowSplitSpheres[2].xyz);
    u_xlat1.z = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat2.xyz = u_xlat0.xyz + (-unity_ShadowSplitSpheres[3].xyz);
    u_xlat1.w = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlatb1 = lessThan(u_xlat1, unity_ShadowSplitSqRadii);
    u_xlat16_3.x = (u_xlatb1.x) ? float(-1.0) : float(-0.0);
    u_xlat16_3.y = (u_xlatb1.y) ? float(-1.0) : float(-0.0);
    u_xlat16_3.z = (u_xlatb1.z) ? float(-1.0) : float(-0.0);
    u_xlat1 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb1));
    u_xlat16_3.xyz = vec3(u_xlat16_3.x + u_xlat1.y, u_xlat16_3.y + u_xlat1.z, u_xlat16_3.z + u_xlat1.w);
    u_xlat16_3.xyz = max(u_xlat16_3.xyz, vec3(0.0, 0.0, 0.0));
    u_xlat8.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[5].xyz;
    u_xlat8.xyz = hlslcc_mtx4x4unity_WorldToShadow[4].xyz * u_xlat0.xxx + u_xlat8.xyz;
    u_xlat8.xyz = hlslcc_mtx4x4unity_WorldToShadow[6].xyz * u_xlat0.zzz + u_xlat8.xyz;
    u_xlat8.xyz = hlslcc_mtx4x4unity_WorldToShadow[7].xyz * u_xlat0.www + u_xlat8.xyz;
    u_xlat8.xyz = u_xlat16_3.xxx * u_xlat8.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[3].xyz * u_xlat0.www + u_xlat2.xyz;
    u_xlat1.xyz = u_xlat2.xyz * u_xlat1.xxx + u_xlat8.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[9].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[8].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[10].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[11].xyz * u_xlat0.www + u_xlat2.xyz;
    u_xlat1.xyz = u_xlat2.xyz * u_xlat16_3.yyy + u_xlat1.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[13].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[12].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[14].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[15].xyz * u_xlat0.www + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_3.zzz + u_xlat1.xyz;
    u_xlat1.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + vec2(0.5, 0.5);
    u_xlat1.xy = floor(u_xlat1.xy);
    u_xlat0.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + (-u_xlat1.xy);
    u_xlat15.xy = max(u_xlat0.xy, vec2(0.0, 0.0));
    u_xlat2 = u_xlat0.xxyy + vec4(0.5, 1.0, 0.5, 1.0);
    u_xlat15.xy = (-u_xlat15.xy) * u_xlat15.xy + u_xlat2.yw;
    u_xlat15.xy = u_xlat15.xy + vec2(1.0, 1.0);
    u_xlat3.xy = u_xlat15.xy * vec2(0.159999996, 0.159999996);
    u_xlat15.xy = min(u_xlat0.xy, vec2(0.0, 0.0));
    u_xlat4.xy = (-u_xlat0.xy) + vec2(1.0, 1.0);
    u_xlat15.xy = (-u_xlat15.xy) * u_xlat15.xy + u_xlat4.xy;
    u_xlat4.xy = u_xlat4.xy * vec2(0.159999996, 0.159999996);
    u_xlat15.xy = u_xlat15.xy + vec2(1.0, 1.0);
    u_xlat5.xy = u_xlat15.xy * vec2(0.159999996, 0.159999996);
    u_xlat6 = u_xlat2.xxzz * u_xlat2.xxzz;
    u_xlat15.xy = vec2(u_xlat2.y * float(0.159999996), u_xlat2.w * float(0.159999996));
    u_xlat0.xy = u_xlat6.xz * vec2(0.5, 0.5) + (-u_xlat0.xy);
    u_xlat4.zw = vec2(u_xlat6.w * float(0.0799999982), u_xlat6.y * float(0.0799999982));
    u_xlat2.xy = u_xlat0.xy * vec2(0.159999996, 0.159999996);
    u_xlat5.z = u_xlat2.y;
    u_xlat5.w = u_xlat15.y;
    u_xlat2.w = u_xlat15.x;
    u_xlat3.zw = u_xlat4.yz;
    u_xlat0.xyw = vec3(u_xlat3.z + u_xlat5.z, u_xlat3.y + u_xlat5.y, u_xlat3.w + u_xlat5.w);
    u_xlat2.z = u_xlat5.x;
    u_xlat5.xyz = vec3(u_xlat3.z / u_xlat0.x, u_xlat3.y / u_xlat0.y, u_xlat3.w / u_xlat0.w);
    u_xlat4.z = u_xlat3.x;
    u_xlat5.xyz = u_xlat5.xyz + vec3(-2.5, -0.5, 1.5);
    u_xlat3.xyz = u_xlat5.xyz * _ShadowMapTexture_TexelSize.yyy;
    u_xlat5.w = u_xlat3.x;
    u_xlat2 = u_xlat2.zwxz + u_xlat4.zwxz;
    u_xlat4.xyz = vec3(u_xlat4.x / u_xlat2.z, u_xlat4.z / u_xlat2.w, u_xlat4.w / u_xlat2.y);
    u_xlat4.xyz = u_xlat4.xyz + vec3(-2.5, -0.5, 1.5);
    u_xlat5.xyz = u_xlat4.yxz * _ShadowMapTexture_TexelSize.xxx;
    u_xlat4 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.ywxw;
    u_xlat15.xy = u_xlat1.xy * _ShadowMapTexture_TexelSize.xy + u_xlat5.zw;
    vec3 txVec0 = vec3(u_xlat15.xy,u_xlat0.z);
    u_xlat10_15 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    vec3 txVec1 = vec3(u_xlat4.xy,u_xlat0.z);
    u_xlat10_22 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec1, 0.0);
    vec3 txVec2 = vec3(u_xlat4.zw,u_xlat0.z);
    u_xlat10_4 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec2, 0.0);
    u_xlat6 = vec4(u_xlat0.x * u_xlat2.z, u_xlat0.x * u_xlat2.w, u_xlat0.x * u_xlat2.y, u_xlat0.y * u_xlat2.z);
    u_xlat0.x = u_xlat10_4 * u_xlat6.y;
    u_xlat0.x = u_xlat6.x * u_xlat10_22 + u_xlat0.x;
    u_xlat0.x = u_xlat6.z * u_xlat10_15 + u_xlat0.x;
    u_xlat3.w = u_xlat5.y;
    u_xlat4 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat3.wywz;
    u_xlat5.yw = u_xlat3.yz;
    vec3 txVec3 = vec3(u_xlat4.xy,u_xlat0.z);
    u_xlat10_15 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec3, 0.0);
    vec3 txVec4 = vec3(u_xlat4.zw,u_xlat0.z);
    u_xlat10_22 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec4, 0.0);
    u_xlat0.x = u_xlat6.w * u_xlat10_15 + u_xlat0.x;
    u_xlat3 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xyzy;
    u_xlat4 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xwzw;
    vec3 txVec5 = vec3(u_xlat3.xy,u_xlat0.z);
    u_xlat10_1 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec5, 0.0);
    vec3 txVec6 = vec3(u_xlat3.zw,u_xlat0.z);
    u_xlat10_8 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec6, 0.0);
    u_xlat3 = vec4(u_xlat0.y * u_xlat2.x, u_xlat0.y * u_xlat2.y, u_xlat0.w * u_xlat2.z, u_xlat0.w * u_xlat2.w);
    u_xlat7 = u_xlat0.w * u_xlat2.y;
    u_xlat0.x = u_xlat3.x * u_xlat10_1 + u_xlat0.x;
    u_xlat0.x = u_xlat3.y * u_xlat10_8 + u_xlat0.x;
    u_xlat0.x = u_xlat3.z * u_xlat10_22 + u_xlat0.x;
    vec3 txVec7 = vec3(u_xlat4.xy,u_xlat0.z);
    u_xlat10_21 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec7, 0.0);
    vec3 txVec8 = vec3(u_xlat4.zw,u_xlat0.z);
    u_xlat10_14 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec8, 0.0);
    u_xlat0.x = u_xlat3.w * u_xlat10_21 + u_xlat0.x;
    u_xlat0.x = u_xlat7 * u_xlat10_14 + u_xlat0.x;
    u_xlat16_7 = (-_LightShadowData.x) + 1.0;
    u_xlat0 = u_xlat0.xxxx * vec4(u_xlat16_7) + _LightShadowData.xxxx;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SHADOWS_SPLIT_SPHERES" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
in highp vec3 in_TEXCOORD1;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
out highp vec3 vs_TEXCOORD2;
out highp vec3 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
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
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraInvProjection[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraInvProjection[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    vs_TEXCOORD0.zw = u_xlat1.zz + u_xlat1.xw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    vs_TEXCOORD1.xyz = in_TEXCOORD1.xyz;
    u_xlat1.xyz = u_xlat0.xyz + (-hlslcc_mtx4x4unity_CameraInvProjection[2].xyz);
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[2].xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.w = (-u_xlat1.z);
    vs_TEXCOORD2.xyz = u_xlat1.xyw;
    u_xlat0.w = (-u_xlat0.z);
    vs_TEXCOORD3.xyz = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 unity_OrthoParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 unity_ShadowSplitSpheres[4];
uniform 	vec4 unity_ShadowSplitSqRadii;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
in highp vec3 vs_TEXCOORD2;
in highp vec3 vs_TEXCOORD3;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp float u_xlat10_1;
bvec4 u_xlatb1;
vec4 u_xlat2;
vec4 u_xlat3;
mediump vec3 u_xlat16_3;
vec4 u_xlat4;
lowp float u_xlat10_4;
vec4 u_xlat5;
vec4 u_xlat6;
float u_xlat7;
mediump float u_xlat16_7;
vec3 u_xlat8;
lowp float u_xlat10_8;
float u_xlat14;
lowp float u_xlat10_14;
vec2 u_xlat15;
lowp float u_xlat10_15;
lowp float u_xlat10_21;
lowp float u_xlat10_22;
void main()
{
    u_xlat0.x = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat7 = _ZBufferParams.x * u_xlat0.x + _ZBufferParams.y;
    u_xlat7 = float(1.0) / u_xlat7;
    u_xlat14 = (-u_xlat7) + u_xlat0.x;
    u_xlat7 = unity_OrthoParams.w * u_xlat14 + u_xlat7;
    u_xlat1.xyz = (-vs_TEXCOORD2.xyz) + vs_TEXCOORD3.xyz;
    u_xlat0.xzw = u_xlat0.xxx * u_xlat1.xyz + vs_TEXCOORD2.xyz;
    u_xlat0.xzw = (-vs_TEXCOORD1.xyz) * vec3(u_xlat7) + u_xlat0.xzw;
    u_xlat1.xyz = vec3(u_xlat7) * vs_TEXCOORD1.xyz;
    u_xlat0.xyz = unity_OrthoParams.www * u_xlat0.xzw + u_xlat1.xyz;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat1.xyz = u_xlat0.xyz + (-unity_ShadowSplitSpheres[0].xyz);
    u_xlat1.x = dot(u_xlat1.xyz, u_xlat1.xyz);
    u_xlat2.xyz = u_xlat0.xyz + (-unity_ShadowSplitSpheres[1].xyz);
    u_xlat1.y = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat2.xyz = u_xlat0.xyz + (-unity_ShadowSplitSpheres[2].xyz);
    u_xlat1.z = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat2.xyz = u_xlat0.xyz + (-unity_ShadowSplitSpheres[3].xyz);
    u_xlat1.w = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlatb1 = lessThan(u_xlat1, unity_ShadowSplitSqRadii);
    u_xlat16_3.x = (u_xlatb1.x) ? float(-1.0) : float(-0.0);
    u_xlat16_3.y = (u_xlatb1.y) ? float(-1.0) : float(-0.0);
    u_xlat16_3.z = (u_xlatb1.z) ? float(-1.0) : float(-0.0);
    u_xlat1 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb1));
    u_xlat16_3.xyz = vec3(u_xlat16_3.x + u_xlat1.y, u_xlat16_3.y + u_xlat1.z, u_xlat16_3.z + u_xlat1.w);
    u_xlat16_3.xyz = max(u_xlat16_3.xyz, vec3(0.0, 0.0, 0.0));
    u_xlat8.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[5].xyz;
    u_xlat8.xyz = hlslcc_mtx4x4unity_WorldToShadow[4].xyz * u_xlat0.xxx + u_xlat8.xyz;
    u_xlat8.xyz = hlslcc_mtx4x4unity_WorldToShadow[6].xyz * u_xlat0.zzz + u_xlat8.xyz;
    u_xlat8.xyz = hlslcc_mtx4x4unity_WorldToShadow[7].xyz * u_xlat0.www + u_xlat8.xyz;
    u_xlat8.xyz = u_xlat16_3.xxx * u_xlat8.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[3].xyz * u_xlat0.www + u_xlat2.xyz;
    u_xlat1.xyz = u_xlat2.xyz * u_xlat1.xxx + u_xlat8.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[9].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[8].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[10].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[11].xyz * u_xlat0.www + u_xlat2.xyz;
    u_xlat1.xyz = u_xlat2.xyz * u_xlat16_3.yyy + u_xlat1.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[13].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[12].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[14].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[15].xyz * u_xlat0.www + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_3.zzz + u_xlat1.xyz;
    u_xlat1.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + vec2(0.5, 0.5);
    u_xlat1.xy = floor(u_xlat1.xy);
    u_xlat0.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + (-u_xlat1.xy);
    u_xlat15.xy = max(u_xlat0.xy, vec2(0.0, 0.0));
    u_xlat2 = u_xlat0.xxyy + vec4(0.5, 1.0, 0.5, 1.0);
    u_xlat15.xy = (-u_xlat15.xy) * u_xlat15.xy + u_xlat2.yw;
    u_xlat15.xy = u_xlat15.xy + vec2(1.0, 1.0);
    u_xlat3.xy = u_xlat15.xy * vec2(0.159999996, 0.159999996);
    u_xlat15.xy = min(u_xlat0.xy, vec2(0.0, 0.0));
    u_xlat4.xy = (-u_xlat0.xy) + vec2(1.0, 1.0);
    u_xlat15.xy = (-u_xlat15.xy) * u_xlat15.xy + u_xlat4.xy;
    u_xlat4.xy = u_xlat4.xy * vec2(0.159999996, 0.159999996);
    u_xlat15.xy = u_xlat15.xy + vec2(1.0, 1.0);
    u_xlat5.xy = u_xlat15.xy * vec2(0.159999996, 0.159999996);
    u_xlat6 = u_xlat2.xxzz * u_xlat2.xxzz;
    u_xlat15.xy = vec2(u_xlat2.y * float(0.159999996), u_xlat2.w * float(0.159999996));
    u_xlat0.xy = u_xlat6.xz * vec2(0.5, 0.5) + (-u_xlat0.xy);
    u_xlat4.zw = vec2(u_xlat6.w * float(0.0799999982), u_xlat6.y * float(0.0799999982));
    u_xlat2.xy = u_xlat0.xy * vec2(0.159999996, 0.159999996);
    u_xlat5.z = u_xlat2.y;
    u_xlat5.w = u_xlat15.y;
    u_xlat2.w = u_xlat15.x;
    u_xlat3.zw = u_xlat4.yz;
    u_xlat0.xyw = vec3(u_xlat3.z + u_xlat5.z, u_xlat3.y + u_xlat5.y, u_xlat3.w + u_xlat5.w);
    u_xlat2.z = u_xlat5.x;
    u_xlat5.xyz = vec3(u_xlat3.z / u_xlat0.x, u_xlat3.y / u_xlat0.y, u_xlat3.w / u_xlat0.w);
    u_xlat4.z = u_xlat3.x;
    u_xlat5.xyz = u_xlat5.xyz + vec3(-2.5, -0.5, 1.5);
    u_xlat3.xyz = u_xlat5.xyz * _ShadowMapTexture_TexelSize.yyy;
    u_xlat5.w = u_xlat3.x;
    u_xlat2 = u_xlat2.zwxz + u_xlat4.zwxz;
    u_xlat4.xyz = vec3(u_xlat4.x / u_xlat2.z, u_xlat4.z / u_xlat2.w, u_xlat4.w / u_xlat2.y);
    u_xlat4.xyz = u_xlat4.xyz + vec3(-2.5, -0.5, 1.5);
    u_xlat5.xyz = u_xlat4.yxz * _ShadowMapTexture_TexelSize.xxx;
    u_xlat4 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.ywxw;
    u_xlat15.xy = u_xlat1.xy * _ShadowMapTexture_TexelSize.xy + u_xlat5.zw;
    vec3 txVec0 = vec3(u_xlat15.xy,u_xlat0.z);
    u_xlat10_15 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    vec3 txVec1 = vec3(u_xlat4.xy,u_xlat0.z);
    u_xlat10_22 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec1, 0.0);
    vec3 txVec2 = vec3(u_xlat4.zw,u_xlat0.z);
    u_xlat10_4 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec2, 0.0);
    u_xlat6 = vec4(u_xlat0.x * u_xlat2.z, u_xlat0.x * u_xlat2.w, u_xlat0.x * u_xlat2.y, u_xlat0.y * u_xlat2.z);
    u_xlat0.x = u_xlat10_4 * u_xlat6.y;
    u_xlat0.x = u_xlat6.x * u_xlat10_22 + u_xlat0.x;
    u_xlat0.x = u_xlat6.z * u_xlat10_15 + u_xlat0.x;
    u_xlat3.w = u_xlat5.y;
    u_xlat4 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat3.wywz;
    u_xlat5.yw = u_xlat3.yz;
    vec3 txVec3 = vec3(u_xlat4.xy,u_xlat0.z);
    u_xlat10_15 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec3, 0.0);
    vec3 txVec4 = vec3(u_xlat4.zw,u_xlat0.z);
    u_xlat10_22 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec4, 0.0);
    u_xlat0.x = u_xlat6.w * u_xlat10_15 + u_xlat0.x;
    u_xlat3 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xyzy;
    u_xlat4 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xwzw;
    vec3 txVec5 = vec3(u_xlat3.xy,u_xlat0.z);
    u_xlat10_1 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec5, 0.0);
    vec3 txVec6 = vec3(u_xlat3.zw,u_xlat0.z);
    u_xlat10_8 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec6, 0.0);
    u_xlat3 = vec4(u_xlat0.y * u_xlat2.x, u_xlat0.y * u_xlat2.y, u_xlat0.w * u_xlat2.z, u_xlat0.w * u_xlat2.w);
    u_xlat7 = u_xlat0.w * u_xlat2.y;
    u_xlat0.x = u_xlat3.x * u_xlat10_1 + u_xlat0.x;
    u_xlat0.x = u_xlat3.y * u_xlat10_8 + u_xlat0.x;
    u_xlat0.x = u_xlat3.z * u_xlat10_22 + u_xlat0.x;
    vec3 txVec7 = vec3(u_xlat4.xy,u_xlat0.z);
    u_xlat10_21 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec7, 0.0);
    vec3 txVec8 = vec3(u_xlat4.zw,u_xlat0.z);
    u_xlat10_14 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec8, 0.0);
    u_xlat0.x = u_xlat3.w * u_xlat10_21 + u_xlat0.x;
    u_xlat0.x = u_xlat7 * u_xlat10_14 + u_xlat0.x;
    u_xlat16_7 = (-_LightShadowData.x) + 1.0;
    u_xlat0 = u_xlat0.xxxx * vec4(u_xlat16_7) + _LightShadowData.xxxx;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "SHADOWS_SINGLE_CASCADE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec3 orthoPosFar_1;
  highp vec3 orthoPosNear_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _glesVertex.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  clipPos_3.xzw = tmpvar_5.xzw;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 o_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_5.zw;
  tmpvar_4.zw = o_7.xy;
  clipPos_3.y = (tmpvar_5.y * _ProjectionParams.x);
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(-1.0, 1.0);
  tmpvar_10.xy = clipPos_3.xy;
  highp vec3 tmpvar_11;
  tmpvar_11 = (unity_CameraInvProjection * tmpvar_10).xyz;
  orthoPosNear_2.xy = tmpvar_11.xy;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(1.0, 1.0);
  tmpvar_12.xy = clipPos_3.xy;
  highp vec3 tmpvar_13;
  tmpvar_13 = (unity_CameraInvProjection * tmpvar_12).xyz;
  orthoPosFar_1.xy = tmpvar_13.xy;
  orthoPosNear_2.z = -(tmpvar_11.z);
  orthoPosFar_1.z = -(tmpvar_13.z);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = _glesMultiTexCoord1.xyz;
  xlv_TEXCOORD2 = orthoPosNear_2;
  xlv_TEXCOORD3 = orthoPosFar_1;
}


#endif
#ifdef FRAGMENT
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_OrthoParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_CameraDepthTexture, xlv_TEXCOORD0.xy);
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = mix ((xlv_TEXCOORD1 * mix (
    (1.0/(((_ZBufferParams.x * tmpvar_2.x) + _ZBufferParams.y)))
  , tmpvar_2.x, unity_OrthoParams.w)), mix (xlv_TEXCOORD2, xlv_TEXCOORD3, tmpvar_2.xxx), unity_OrthoParams.www);
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = (unity_WorldToShadow[0] * (unity_CameraToWorld * tmpvar_3)).xyz;
  mediump float shadow_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = _ShadowMapTexture_TexelSize.xy;
  shadow_5 = 0.0;
  highp vec3 tmpvar_7;
  tmpvar_7.xy = (tmpvar_4.xy - _ShadowMapTexture_TexelSize.xy);
  tmpvar_7.z = tmpvar_4.z;
  highp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_ShadowMapTexture, tmpvar_7.xy);
  mediump float tmpvar_9;
  if ((tmpvar_8.x < tmpvar_4.z)) {
    tmpvar_9 = 0.0;
  } else {
    tmpvar_9 = 1.0;
  };
  shadow_5 = tmpvar_9;
  highp vec2 tmpvar_10;
  tmpvar_10.x = 0.0;
  tmpvar_10.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_11;
  tmpvar_11.xy = (tmpvar_4.xy + tmpvar_10);
  tmpvar_11.z = tmpvar_4.z;
  highp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_ShadowMapTexture, tmpvar_11.xy);
  highp float tmpvar_13;
  if ((tmpvar_12.x < tmpvar_4.z)) {
    tmpvar_13 = 0.0;
  } else {
    tmpvar_13 = 1.0;
  };
  shadow_5 = (tmpvar_9 + tmpvar_13);
  highp vec2 tmpvar_14;
  tmpvar_14.x = tmpvar_6.x;
  tmpvar_14.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_15;
  tmpvar_15.xy = (tmpvar_4.xy + tmpvar_14);
  tmpvar_15.z = tmpvar_4.z;
  highp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_ShadowMapTexture, tmpvar_15.xy);
  highp float tmpvar_17;
  if ((tmpvar_16.x < tmpvar_4.z)) {
    tmpvar_17 = 0.0;
  } else {
    tmpvar_17 = 1.0;
  };
  shadow_5 = (shadow_5 + tmpvar_17);
  highp vec2 tmpvar_18;
  tmpvar_18.y = 0.0;
  tmpvar_18.x = -(_ShadowMapTexture_TexelSize.x);
  highp vec3 tmpvar_19;
  tmpvar_19.xy = (tmpvar_4.xy + tmpvar_18);
  tmpvar_19.z = tmpvar_4.z;
  highp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_ShadowMapTexture, tmpvar_19.xy);
  highp float tmpvar_21;
  if ((tmpvar_20.x < tmpvar_4.z)) {
    tmpvar_21 = 0.0;
  } else {
    tmpvar_21 = 1.0;
  };
  shadow_5 = (shadow_5 + tmpvar_21);
  highp vec4 tmpvar_22;
  tmpvar_22 = texture2D (_ShadowMapTexture, tmpvar_4.xy);
  highp float tmpvar_23;
  if ((tmpvar_22.x < tmpvar_4.z)) {
    tmpvar_23 = 0.0;
  } else {
    tmpvar_23 = 1.0;
  };
  shadow_5 = (shadow_5 + tmpvar_23);
  highp vec2 tmpvar_24;
  tmpvar_24.y = 0.0;
  tmpvar_24.x = tmpvar_6.x;
  highp vec3 tmpvar_25;
  tmpvar_25.xy = (tmpvar_4.xy + tmpvar_24);
  tmpvar_25.z = tmpvar_4.z;
  highp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_ShadowMapTexture, tmpvar_25.xy);
  highp float tmpvar_27;
  if ((tmpvar_26.x < tmpvar_4.z)) {
    tmpvar_27 = 0.0;
  } else {
    tmpvar_27 = 1.0;
  };
  shadow_5 = (shadow_5 + tmpvar_27);
  highp vec2 tmpvar_28;
  tmpvar_28.x = -(_ShadowMapTexture_TexelSize.x);
  tmpvar_28.y = tmpvar_6.y;
  highp vec3 tmpvar_29;
  tmpvar_29.xy = (tmpvar_4.xy + tmpvar_28);
  tmpvar_29.z = tmpvar_4.z;
  highp vec4 tmpvar_30;
  tmpvar_30 = texture2D (_ShadowMapTexture, tmpvar_29.xy);
  highp float tmpvar_31;
  if ((tmpvar_30.x < tmpvar_4.z)) {
    tmpvar_31 = 0.0;
  } else {
    tmpvar_31 = 1.0;
  };
  shadow_5 = (shadow_5 + tmpvar_31);
  highp vec2 tmpvar_32;
  tmpvar_32.x = 0.0;
  tmpvar_32.y = tmpvar_6.y;
  highp vec3 tmpvar_33;
  tmpvar_33.xy = (tmpvar_4.xy + tmpvar_32);
  tmpvar_33.z = tmpvar_4.z;
  highp vec4 tmpvar_34;
  tmpvar_34 = texture2D (_ShadowMapTexture, tmpvar_33.xy);
  highp float tmpvar_35;
  if ((tmpvar_34.x < tmpvar_4.z)) {
    tmpvar_35 = 0.0;
  } else {
    tmpvar_35 = 1.0;
  };
  shadow_5 = (shadow_5 + tmpvar_35);
  highp vec3 tmpvar_36;
  tmpvar_36.xy = (tmpvar_4.xy + _ShadowMapTexture_TexelSize.xy);
  tmpvar_36.z = tmpvar_4.z;
  highp vec4 tmpvar_37;
  tmpvar_37 = texture2D (_ShadowMapTexture, tmpvar_36.xy);
  highp float tmpvar_38;
  if ((tmpvar_37.x < tmpvar_4.z)) {
    tmpvar_38 = 0.0;
  } else {
    tmpvar_38 = 1.0;
  };
  shadow_5 = (shadow_5 + tmpvar_38);
  shadow_5 = (shadow_5 / 9.0);
  mediump vec4 tmpvar_39;
  tmpvar_39 = vec4(mix (_LightShadowData.x, 1.0, shadow_5));
  tmpvar_1 = tmpvar_39;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "SHADOWS_SINGLE_CASCADE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec3 orthoPosFar_1;
  highp vec3 orthoPosNear_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _glesVertex.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  clipPos_3.xzw = tmpvar_5.xzw;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 o_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_5.zw;
  tmpvar_4.zw = o_7.xy;
  clipPos_3.y = (tmpvar_5.y * _ProjectionParams.x);
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(-1.0, 1.0);
  tmpvar_10.xy = clipPos_3.xy;
  highp vec3 tmpvar_11;
  tmpvar_11 = (unity_CameraInvProjection * tmpvar_10).xyz;
  orthoPosNear_2.xy = tmpvar_11.xy;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(1.0, 1.0);
  tmpvar_12.xy = clipPos_3.xy;
  highp vec3 tmpvar_13;
  tmpvar_13 = (unity_CameraInvProjection * tmpvar_12).xyz;
  orthoPosFar_1.xy = tmpvar_13.xy;
  orthoPosNear_2.z = -(tmpvar_11.z);
  orthoPosFar_1.z = -(tmpvar_13.z);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = _glesMultiTexCoord1.xyz;
  xlv_TEXCOORD2 = orthoPosNear_2;
  xlv_TEXCOORD3 = orthoPosFar_1;
}


#endif
#ifdef FRAGMENT
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_OrthoParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_CameraDepthTexture, xlv_TEXCOORD0.xy);
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = mix ((xlv_TEXCOORD1 * mix (
    (1.0/(((_ZBufferParams.x * tmpvar_2.x) + _ZBufferParams.y)))
  , tmpvar_2.x, unity_OrthoParams.w)), mix (xlv_TEXCOORD2, xlv_TEXCOORD3, tmpvar_2.xxx), unity_OrthoParams.www);
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = (unity_WorldToShadow[0] * (unity_CameraToWorld * tmpvar_3)).xyz;
  mediump float shadow_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = _ShadowMapTexture_TexelSize.xy;
  shadow_5 = 0.0;
  highp vec3 tmpvar_7;
  tmpvar_7.xy = (tmpvar_4.xy - _ShadowMapTexture_TexelSize.xy);
  tmpvar_7.z = tmpvar_4.z;
  highp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_ShadowMapTexture, tmpvar_7.xy);
  mediump float tmpvar_9;
  if ((tmpvar_8.x < tmpvar_4.z)) {
    tmpvar_9 = 0.0;
  } else {
    tmpvar_9 = 1.0;
  };
  shadow_5 = tmpvar_9;
  highp vec2 tmpvar_10;
  tmpvar_10.x = 0.0;
  tmpvar_10.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_11;
  tmpvar_11.xy = (tmpvar_4.xy + tmpvar_10);
  tmpvar_11.z = tmpvar_4.z;
  highp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_ShadowMapTexture, tmpvar_11.xy);
  highp float tmpvar_13;
  if ((tmpvar_12.x < tmpvar_4.z)) {
    tmpvar_13 = 0.0;
  } else {
    tmpvar_13 = 1.0;
  };
  shadow_5 = (tmpvar_9 + tmpvar_13);
  highp vec2 tmpvar_14;
  tmpvar_14.x = tmpvar_6.x;
  tmpvar_14.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_15;
  tmpvar_15.xy = (tmpvar_4.xy + tmpvar_14);
  tmpvar_15.z = tmpvar_4.z;
  highp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_ShadowMapTexture, tmpvar_15.xy);
  highp float tmpvar_17;
  if ((tmpvar_16.x < tmpvar_4.z)) {
    tmpvar_17 = 0.0;
  } else {
    tmpvar_17 = 1.0;
  };
  shadow_5 = (shadow_5 + tmpvar_17);
  highp vec2 tmpvar_18;
  tmpvar_18.y = 0.0;
  tmpvar_18.x = -(_ShadowMapTexture_TexelSize.x);
  highp vec3 tmpvar_19;
  tmpvar_19.xy = (tmpvar_4.xy + tmpvar_18);
  tmpvar_19.z = tmpvar_4.z;
  highp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_ShadowMapTexture, tmpvar_19.xy);
  highp float tmpvar_21;
  if ((tmpvar_20.x < tmpvar_4.z)) {
    tmpvar_21 = 0.0;
  } else {
    tmpvar_21 = 1.0;
  };
  shadow_5 = (shadow_5 + tmpvar_21);
  highp vec4 tmpvar_22;
  tmpvar_22 = texture2D (_ShadowMapTexture, tmpvar_4.xy);
  highp float tmpvar_23;
  if ((tmpvar_22.x < tmpvar_4.z)) {
    tmpvar_23 = 0.0;
  } else {
    tmpvar_23 = 1.0;
  };
  shadow_5 = (shadow_5 + tmpvar_23);
  highp vec2 tmpvar_24;
  tmpvar_24.y = 0.0;
  tmpvar_24.x = tmpvar_6.x;
  highp vec3 tmpvar_25;
  tmpvar_25.xy = (tmpvar_4.xy + tmpvar_24);
  tmpvar_25.z = tmpvar_4.z;
  highp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_ShadowMapTexture, tmpvar_25.xy);
  highp float tmpvar_27;
  if ((tmpvar_26.x < tmpvar_4.z)) {
    tmpvar_27 = 0.0;
  } else {
    tmpvar_27 = 1.0;
  };
  shadow_5 = (shadow_5 + tmpvar_27);
  highp vec2 tmpvar_28;
  tmpvar_28.x = -(_ShadowMapTexture_TexelSize.x);
  tmpvar_28.y = tmpvar_6.y;
  highp vec3 tmpvar_29;
  tmpvar_29.xy = (tmpvar_4.xy + tmpvar_28);
  tmpvar_29.z = tmpvar_4.z;
  highp vec4 tmpvar_30;
  tmpvar_30 = texture2D (_ShadowMapTexture, tmpvar_29.xy);
  highp float tmpvar_31;
  if ((tmpvar_30.x < tmpvar_4.z)) {
    tmpvar_31 = 0.0;
  } else {
    tmpvar_31 = 1.0;
  };
  shadow_5 = (shadow_5 + tmpvar_31);
  highp vec2 tmpvar_32;
  tmpvar_32.x = 0.0;
  tmpvar_32.y = tmpvar_6.y;
  highp vec3 tmpvar_33;
  tmpvar_33.xy = (tmpvar_4.xy + tmpvar_32);
  tmpvar_33.z = tmpvar_4.z;
  highp vec4 tmpvar_34;
  tmpvar_34 = texture2D (_ShadowMapTexture, tmpvar_33.xy);
  highp float tmpvar_35;
  if ((tmpvar_34.x < tmpvar_4.z)) {
    tmpvar_35 = 0.0;
  } else {
    tmpvar_35 = 1.0;
  };
  shadow_5 = (shadow_5 + tmpvar_35);
  highp vec3 tmpvar_36;
  tmpvar_36.xy = (tmpvar_4.xy + _ShadowMapTexture_TexelSize.xy);
  tmpvar_36.z = tmpvar_4.z;
  highp vec4 tmpvar_37;
  tmpvar_37 = texture2D (_ShadowMapTexture, tmpvar_36.xy);
  highp float tmpvar_38;
  if ((tmpvar_37.x < tmpvar_4.z)) {
    tmpvar_38 = 0.0;
  } else {
    tmpvar_38 = 1.0;
  };
  shadow_5 = (shadow_5 + tmpvar_38);
  shadow_5 = (shadow_5 / 9.0);
  mediump vec4 tmpvar_39;
  tmpvar_39 = vec4(mix (_LightShadowData.x, 1.0, shadow_5));
  tmpvar_1 = tmpvar_39;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "SHADOWS_SINGLE_CASCADE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec3 orthoPosFar_1;
  highp vec3 orthoPosNear_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _glesVertex.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  clipPos_3.xzw = tmpvar_5.xzw;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 o_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_5.zw;
  tmpvar_4.zw = o_7.xy;
  clipPos_3.y = (tmpvar_5.y * _ProjectionParams.x);
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(-1.0, 1.0);
  tmpvar_10.xy = clipPos_3.xy;
  highp vec3 tmpvar_11;
  tmpvar_11 = (unity_CameraInvProjection * tmpvar_10).xyz;
  orthoPosNear_2.xy = tmpvar_11.xy;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(1.0, 1.0);
  tmpvar_12.xy = clipPos_3.xy;
  highp vec3 tmpvar_13;
  tmpvar_13 = (unity_CameraInvProjection * tmpvar_12).xyz;
  orthoPosFar_1.xy = tmpvar_13.xy;
  orthoPosNear_2.z = -(tmpvar_11.z);
  orthoPosFar_1.z = -(tmpvar_13.z);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = _glesMultiTexCoord1.xyz;
  xlv_TEXCOORD2 = orthoPosNear_2;
  xlv_TEXCOORD3 = orthoPosFar_1;
}


#endif
#ifdef FRAGMENT
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_OrthoParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_CameraDepthTexture, xlv_TEXCOORD0.xy);
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = mix ((xlv_TEXCOORD1 * mix (
    (1.0/(((_ZBufferParams.x * tmpvar_2.x) + _ZBufferParams.y)))
  , tmpvar_2.x, unity_OrthoParams.w)), mix (xlv_TEXCOORD2, xlv_TEXCOORD3, tmpvar_2.xxx), unity_OrthoParams.www);
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = (unity_WorldToShadow[0] * (unity_CameraToWorld * tmpvar_3)).xyz;
  mediump float shadow_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = _ShadowMapTexture_TexelSize.xy;
  shadow_5 = 0.0;
  highp vec3 tmpvar_7;
  tmpvar_7.xy = (tmpvar_4.xy - _ShadowMapTexture_TexelSize.xy);
  tmpvar_7.z = tmpvar_4.z;
  highp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_ShadowMapTexture, tmpvar_7.xy);
  mediump float tmpvar_9;
  if ((tmpvar_8.x < tmpvar_4.z)) {
    tmpvar_9 = 0.0;
  } else {
    tmpvar_9 = 1.0;
  };
  shadow_5 = tmpvar_9;
  highp vec2 tmpvar_10;
  tmpvar_10.x = 0.0;
  tmpvar_10.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_11;
  tmpvar_11.xy = (tmpvar_4.xy + tmpvar_10);
  tmpvar_11.z = tmpvar_4.z;
  highp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_ShadowMapTexture, tmpvar_11.xy);
  highp float tmpvar_13;
  if ((tmpvar_12.x < tmpvar_4.z)) {
    tmpvar_13 = 0.0;
  } else {
    tmpvar_13 = 1.0;
  };
  shadow_5 = (tmpvar_9 + tmpvar_13);
  highp vec2 tmpvar_14;
  tmpvar_14.x = tmpvar_6.x;
  tmpvar_14.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_15;
  tmpvar_15.xy = (tmpvar_4.xy + tmpvar_14);
  tmpvar_15.z = tmpvar_4.z;
  highp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_ShadowMapTexture, tmpvar_15.xy);
  highp float tmpvar_17;
  if ((tmpvar_16.x < tmpvar_4.z)) {
    tmpvar_17 = 0.0;
  } else {
    tmpvar_17 = 1.0;
  };
  shadow_5 = (shadow_5 + tmpvar_17);
  highp vec2 tmpvar_18;
  tmpvar_18.y = 0.0;
  tmpvar_18.x = -(_ShadowMapTexture_TexelSize.x);
  highp vec3 tmpvar_19;
  tmpvar_19.xy = (tmpvar_4.xy + tmpvar_18);
  tmpvar_19.z = tmpvar_4.z;
  highp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_ShadowMapTexture, tmpvar_19.xy);
  highp float tmpvar_21;
  if ((tmpvar_20.x < tmpvar_4.z)) {
    tmpvar_21 = 0.0;
  } else {
    tmpvar_21 = 1.0;
  };
  shadow_5 = (shadow_5 + tmpvar_21);
  highp vec4 tmpvar_22;
  tmpvar_22 = texture2D (_ShadowMapTexture, tmpvar_4.xy);
  highp float tmpvar_23;
  if ((tmpvar_22.x < tmpvar_4.z)) {
    tmpvar_23 = 0.0;
  } else {
    tmpvar_23 = 1.0;
  };
  shadow_5 = (shadow_5 + tmpvar_23);
  highp vec2 tmpvar_24;
  tmpvar_24.y = 0.0;
  tmpvar_24.x = tmpvar_6.x;
  highp vec3 tmpvar_25;
  tmpvar_25.xy = (tmpvar_4.xy + tmpvar_24);
  tmpvar_25.z = tmpvar_4.z;
  highp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_ShadowMapTexture, tmpvar_25.xy);
  highp float tmpvar_27;
  if ((tmpvar_26.x < tmpvar_4.z)) {
    tmpvar_27 = 0.0;
  } else {
    tmpvar_27 = 1.0;
  };
  shadow_5 = (shadow_5 + tmpvar_27);
  highp vec2 tmpvar_28;
  tmpvar_28.x = -(_ShadowMapTexture_TexelSize.x);
  tmpvar_28.y = tmpvar_6.y;
  highp vec3 tmpvar_29;
  tmpvar_29.xy = (tmpvar_4.xy + tmpvar_28);
  tmpvar_29.z = tmpvar_4.z;
  highp vec4 tmpvar_30;
  tmpvar_30 = texture2D (_ShadowMapTexture, tmpvar_29.xy);
  highp float tmpvar_31;
  if ((tmpvar_30.x < tmpvar_4.z)) {
    tmpvar_31 = 0.0;
  } else {
    tmpvar_31 = 1.0;
  };
  shadow_5 = (shadow_5 + tmpvar_31);
  highp vec2 tmpvar_32;
  tmpvar_32.x = 0.0;
  tmpvar_32.y = tmpvar_6.y;
  highp vec3 tmpvar_33;
  tmpvar_33.xy = (tmpvar_4.xy + tmpvar_32);
  tmpvar_33.z = tmpvar_4.z;
  highp vec4 tmpvar_34;
  tmpvar_34 = texture2D (_ShadowMapTexture, tmpvar_33.xy);
  highp float tmpvar_35;
  if ((tmpvar_34.x < tmpvar_4.z)) {
    tmpvar_35 = 0.0;
  } else {
    tmpvar_35 = 1.0;
  };
  shadow_5 = (shadow_5 + tmpvar_35);
  highp vec3 tmpvar_36;
  tmpvar_36.xy = (tmpvar_4.xy + _ShadowMapTexture_TexelSize.xy);
  tmpvar_36.z = tmpvar_4.z;
  highp vec4 tmpvar_37;
  tmpvar_37 = texture2D (_ShadowMapTexture, tmpvar_36.xy);
  highp float tmpvar_38;
  if ((tmpvar_37.x < tmpvar_4.z)) {
    tmpvar_38 = 0.0;
  } else {
    tmpvar_38 = 1.0;
  };
  shadow_5 = (shadow_5 + tmpvar_38);
  shadow_5 = (shadow_5 / 9.0);
  mediump vec4 tmpvar_39;
  tmpvar_39 = vec4(mix (_LightShadowData.x, 1.0, shadow_5));
  tmpvar_1 = tmpvar_39;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SHADOWS_SINGLE_CASCADE" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
in highp vec3 in_TEXCOORD1;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
out highp vec3 vs_TEXCOORD2;
out highp vec3 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
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
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraInvProjection[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraInvProjection[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    vs_TEXCOORD0.zw = u_xlat1.zz + u_xlat1.xw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    vs_TEXCOORD1.xyz = in_TEXCOORD1.xyz;
    u_xlat1.xyz = u_xlat0.xyz + (-hlslcc_mtx4x4unity_CameraInvProjection[2].xyz);
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[2].xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.w = (-u_xlat1.z);
    vs_TEXCOORD2.xyz = u_xlat1.xyw;
    u_xlat0.w = (-u_xlat0.z);
    vs_TEXCOORD3.xyz = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 unity_OrthoParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
in highp vec3 vs_TEXCOORD2;
in highp vec3 vs_TEXCOORD3;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp float u_xlat10_1;
vec4 u_xlat2;
lowp float u_xlat10_2;
vec4 u_xlat3;
vec4 u_xlat4;
vec4 u_xlat5;
vec4 u_xlat6;
float u_xlat7;
mediump float u_xlat16_7;
lowp float u_xlat10_8;
float u_xlat14;
lowp float u_xlat10_14;
vec2 u_xlat15;
lowp float u_xlat10_15;
lowp float u_xlat10_21;
lowp float u_xlat10_22;
void main()
{
    u_xlat0.x = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat7 = _ZBufferParams.x * u_xlat0.x + _ZBufferParams.y;
    u_xlat7 = float(1.0) / u_xlat7;
    u_xlat14 = (-u_xlat7) + u_xlat0.x;
    u_xlat7 = unity_OrthoParams.w * u_xlat14 + u_xlat7;
    u_xlat1.xyz = (-vs_TEXCOORD2.xyz) + vs_TEXCOORD3.xyz;
    u_xlat0.xzw = u_xlat0.xxx * u_xlat1.xyz + vs_TEXCOORD2.xyz;
    u_xlat0.xzw = (-vs_TEXCOORD1.xyz) * vec3(u_xlat7) + u_xlat0.xzw;
    u_xlat1.xyz = vec3(u_xlat7) * vs_TEXCOORD1.xyz;
    u_xlat0.xyz = unity_OrthoParams.www * u_xlat0.xzw + u_xlat1.xyz;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat1.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[3].xyz * u_xlat0.www + u_xlat0.xyz;
    u_xlat1.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + vec2(0.5, 0.5);
    u_xlat1.xy = floor(u_xlat1.xy);
    u_xlat0.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + (-u_xlat1.xy);
    u_xlat15.xy = min(u_xlat0.xy, vec2(0.0, 0.0));
    u_xlat2.xy = (-u_xlat0.xy) + vec2(1.0, 1.0);
    u_xlat15.xy = (-u_xlat15.xy) * u_xlat15.xy + u_xlat2.xy;
    u_xlat2.xy = u_xlat2.xy * vec2(0.159999996, 0.159999996);
    u_xlat15.xy = u_xlat15.xy + vec2(1.0, 1.0);
    u_xlat3.xy = u_xlat15.xy * vec2(0.159999996, 0.159999996);
    u_xlat15.xy = max(u_xlat0.xy, vec2(0.0, 0.0));
    u_xlat4 = u_xlat0.xxyy + vec4(0.5, 1.0, 0.5, 1.0);
    u_xlat15.xy = (-u_xlat15.xy) * u_xlat15.xy + u_xlat4.yw;
    u_xlat15.xy = u_xlat15.xy + vec2(1.0, 1.0);
    u_xlat5.xy = u_xlat15.xy * vec2(0.159999996, 0.159999996);
    u_xlat6 = u_xlat4.xxzz * u_xlat4.xxzz;
    u_xlat15.xy = vec2(u_xlat4.y * float(0.159999996), u_xlat4.w * float(0.159999996));
    u_xlat0.xy = u_xlat6.xz * vec2(0.5, 0.5) + (-u_xlat0.xy);
    u_xlat2.zw = vec2(u_xlat6.w * float(0.0799999982), u_xlat6.y * float(0.0799999982));
    u_xlat4.xy = u_xlat0.xy * vec2(0.159999996, 0.159999996);
    u_xlat3.z = u_xlat4.y;
    u_xlat3.w = u_xlat15.y;
    u_xlat4.w = u_xlat15.x;
    u_xlat5.zw = u_xlat2.yz;
    u_xlat0.xyw = vec3(u_xlat3.z + u_xlat5.z, u_xlat3.y + u_xlat5.y, u_xlat3.w + u_xlat5.w);
    u_xlat4.z = u_xlat3.x;
    u_xlat3.xyz = vec3(u_xlat5.z / u_xlat0.x, u_xlat5.y / u_xlat0.y, u_xlat5.w / u_xlat0.w);
    u_xlat2.z = u_xlat5.x;
    u_xlat3.xyz = u_xlat3.xyz + vec3(-2.5, -0.5, 1.5);
    u_xlat3.xyz = u_xlat3.xyz * _ShadowMapTexture_TexelSize.yyy;
    u_xlat5.w = u_xlat3.x;
    u_xlat4 = u_xlat2.zwxz + u_xlat4.zwxz;
    u_xlat2.xyz = vec3(u_xlat2.x / u_xlat4.z, u_xlat2.z / u_xlat4.w, u_xlat2.w / u_xlat4.y);
    u_xlat2.xyz = u_xlat2.xyz + vec3(-2.5, -0.5, 1.5);
    u_xlat5.xyz = u_xlat2.yxz * _ShadowMapTexture_TexelSize.xxx;
    u_xlat2 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.ywxw;
    u_xlat15.xy = u_xlat1.xy * _ShadowMapTexture_TexelSize.xy + u_xlat5.zw;
    vec3 txVec0 = vec3(u_xlat15.xy,u_xlat0.z);
    u_xlat10_15 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    vec3 txVec1 = vec3(u_xlat2.xy,u_xlat0.z);
    u_xlat10_22 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec1, 0.0);
    vec3 txVec2 = vec3(u_xlat2.zw,u_xlat0.z);
    u_xlat10_2 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec2, 0.0);
    u_xlat6 = vec4(u_xlat0.x * u_xlat4.z, u_xlat0.x * u_xlat4.w, u_xlat0.x * u_xlat4.y, u_xlat0.y * u_xlat4.z);
    u_xlat0.x = u_xlat10_2 * u_xlat6.y;
    u_xlat0.x = u_xlat6.x * u_xlat10_22 + u_xlat0.x;
    u_xlat0.x = u_xlat6.z * u_xlat10_15 + u_xlat0.x;
    u_xlat3.w = u_xlat5.y;
    u_xlat2 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat3.wywz;
    u_xlat5.yw = u_xlat3.yz;
    vec3 txVec3 = vec3(u_xlat2.xy,u_xlat0.z);
    u_xlat10_15 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec3, 0.0);
    vec3 txVec4 = vec3(u_xlat2.zw,u_xlat0.z);
    u_xlat10_22 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec4, 0.0);
    u_xlat0.x = u_xlat6.w * u_xlat10_15 + u_xlat0.x;
    u_xlat2 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xyzy;
    u_xlat3 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xwzw;
    vec3 txVec5 = vec3(u_xlat2.xy,u_xlat0.z);
    u_xlat10_1 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec5, 0.0);
    vec3 txVec6 = vec3(u_xlat2.zw,u_xlat0.z);
    u_xlat10_8 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec6, 0.0);
    u_xlat2 = vec4(u_xlat0.y * u_xlat4.x, u_xlat0.y * u_xlat4.y, u_xlat0.w * u_xlat4.z, u_xlat0.w * u_xlat4.w);
    u_xlat7 = u_xlat0.w * u_xlat4.y;
    u_xlat0.x = u_xlat2.x * u_xlat10_1 + u_xlat0.x;
    u_xlat0.x = u_xlat2.y * u_xlat10_8 + u_xlat0.x;
    u_xlat0.x = u_xlat2.z * u_xlat10_22 + u_xlat0.x;
    vec3 txVec7 = vec3(u_xlat3.xy,u_xlat0.z);
    u_xlat10_21 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec7, 0.0);
    vec3 txVec8 = vec3(u_xlat3.zw,u_xlat0.z);
    u_xlat10_14 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec8, 0.0);
    u_xlat0.x = u_xlat2.w * u_xlat10_21 + u_xlat0.x;
    u_xlat0.x = u_xlat7 * u_xlat10_14 + u_xlat0.x;
    u_xlat16_7 = (-_LightShadowData.x) + 1.0;
    u_xlat0 = u_xlat0.xxxx * vec4(u_xlat16_7) + _LightShadowData.xxxx;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SHADOWS_SINGLE_CASCADE" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
in highp vec3 in_TEXCOORD1;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
out highp vec3 vs_TEXCOORD2;
out highp vec3 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
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
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraInvProjection[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraInvProjection[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    vs_TEXCOORD0.zw = u_xlat1.zz + u_xlat1.xw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    vs_TEXCOORD1.xyz = in_TEXCOORD1.xyz;
    u_xlat1.xyz = u_xlat0.xyz + (-hlslcc_mtx4x4unity_CameraInvProjection[2].xyz);
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[2].xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.w = (-u_xlat1.z);
    vs_TEXCOORD2.xyz = u_xlat1.xyw;
    u_xlat0.w = (-u_xlat0.z);
    vs_TEXCOORD3.xyz = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 unity_OrthoParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
in highp vec3 vs_TEXCOORD2;
in highp vec3 vs_TEXCOORD3;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp float u_xlat10_1;
vec4 u_xlat2;
lowp float u_xlat10_2;
vec4 u_xlat3;
vec4 u_xlat4;
vec4 u_xlat5;
vec4 u_xlat6;
float u_xlat7;
mediump float u_xlat16_7;
lowp float u_xlat10_8;
float u_xlat14;
lowp float u_xlat10_14;
vec2 u_xlat15;
lowp float u_xlat10_15;
lowp float u_xlat10_21;
lowp float u_xlat10_22;
void main()
{
    u_xlat0.x = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat7 = _ZBufferParams.x * u_xlat0.x + _ZBufferParams.y;
    u_xlat7 = float(1.0) / u_xlat7;
    u_xlat14 = (-u_xlat7) + u_xlat0.x;
    u_xlat7 = unity_OrthoParams.w * u_xlat14 + u_xlat7;
    u_xlat1.xyz = (-vs_TEXCOORD2.xyz) + vs_TEXCOORD3.xyz;
    u_xlat0.xzw = u_xlat0.xxx * u_xlat1.xyz + vs_TEXCOORD2.xyz;
    u_xlat0.xzw = (-vs_TEXCOORD1.xyz) * vec3(u_xlat7) + u_xlat0.xzw;
    u_xlat1.xyz = vec3(u_xlat7) * vs_TEXCOORD1.xyz;
    u_xlat0.xyz = unity_OrthoParams.www * u_xlat0.xzw + u_xlat1.xyz;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat1.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[3].xyz * u_xlat0.www + u_xlat0.xyz;
    u_xlat1.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + vec2(0.5, 0.5);
    u_xlat1.xy = floor(u_xlat1.xy);
    u_xlat0.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + (-u_xlat1.xy);
    u_xlat15.xy = min(u_xlat0.xy, vec2(0.0, 0.0));
    u_xlat2.xy = (-u_xlat0.xy) + vec2(1.0, 1.0);
    u_xlat15.xy = (-u_xlat15.xy) * u_xlat15.xy + u_xlat2.xy;
    u_xlat2.xy = u_xlat2.xy * vec2(0.159999996, 0.159999996);
    u_xlat15.xy = u_xlat15.xy + vec2(1.0, 1.0);
    u_xlat3.xy = u_xlat15.xy * vec2(0.159999996, 0.159999996);
    u_xlat15.xy = max(u_xlat0.xy, vec2(0.0, 0.0));
    u_xlat4 = u_xlat0.xxyy + vec4(0.5, 1.0, 0.5, 1.0);
    u_xlat15.xy = (-u_xlat15.xy) * u_xlat15.xy + u_xlat4.yw;
    u_xlat15.xy = u_xlat15.xy + vec2(1.0, 1.0);
    u_xlat5.xy = u_xlat15.xy * vec2(0.159999996, 0.159999996);
    u_xlat6 = u_xlat4.xxzz * u_xlat4.xxzz;
    u_xlat15.xy = vec2(u_xlat4.y * float(0.159999996), u_xlat4.w * float(0.159999996));
    u_xlat0.xy = u_xlat6.xz * vec2(0.5, 0.5) + (-u_xlat0.xy);
    u_xlat2.zw = vec2(u_xlat6.w * float(0.0799999982), u_xlat6.y * float(0.0799999982));
    u_xlat4.xy = u_xlat0.xy * vec2(0.159999996, 0.159999996);
    u_xlat3.z = u_xlat4.y;
    u_xlat3.w = u_xlat15.y;
    u_xlat4.w = u_xlat15.x;
    u_xlat5.zw = u_xlat2.yz;
    u_xlat0.xyw = vec3(u_xlat3.z + u_xlat5.z, u_xlat3.y + u_xlat5.y, u_xlat3.w + u_xlat5.w);
    u_xlat4.z = u_xlat3.x;
    u_xlat3.xyz = vec3(u_xlat5.z / u_xlat0.x, u_xlat5.y / u_xlat0.y, u_xlat5.w / u_xlat0.w);
    u_xlat2.z = u_xlat5.x;
    u_xlat3.xyz = u_xlat3.xyz + vec3(-2.5, -0.5, 1.5);
    u_xlat3.xyz = u_xlat3.xyz * _ShadowMapTexture_TexelSize.yyy;
    u_xlat5.w = u_xlat3.x;
    u_xlat4 = u_xlat2.zwxz + u_xlat4.zwxz;
    u_xlat2.xyz = vec3(u_xlat2.x / u_xlat4.z, u_xlat2.z / u_xlat4.w, u_xlat2.w / u_xlat4.y);
    u_xlat2.xyz = u_xlat2.xyz + vec3(-2.5, -0.5, 1.5);
    u_xlat5.xyz = u_xlat2.yxz * _ShadowMapTexture_TexelSize.xxx;
    u_xlat2 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.ywxw;
    u_xlat15.xy = u_xlat1.xy * _ShadowMapTexture_TexelSize.xy + u_xlat5.zw;
    vec3 txVec0 = vec3(u_xlat15.xy,u_xlat0.z);
    u_xlat10_15 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    vec3 txVec1 = vec3(u_xlat2.xy,u_xlat0.z);
    u_xlat10_22 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec1, 0.0);
    vec3 txVec2 = vec3(u_xlat2.zw,u_xlat0.z);
    u_xlat10_2 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec2, 0.0);
    u_xlat6 = vec4(u_xlat0.x * u_xlat4.z, u_xlat0.x * u_xlat4.w, u_xlat0.x * u_xlat4.y, u_xlat0.y * u_xlat4.z);
    u_xlat0.x = u_xlat10_2 * u_xlat6.y;
    u_xlat0.x = u_xlat6.x * u_xlat10_22 + u_xlat0.x;
    u_xlat0.x = u_xlat6.z * u_xlat10_15 + u_xlat0.x;
    u_xlat3.w = u_xlat5.y;
    u_xlat2 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat3.wywz;
    u_xlat5.yw = u_xlat3.yz;
    vec3 txVec3 = vec3(u_xlat2.xy,u_xlat0.z);
    u_xlat10_15 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec3, 0.0);
    vec3 txVec4 = vec3(u_xlat2.zw,u_xlat0.z);
    u_xlat10_22 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec4, 0.0);
    u_xlat0.x = u_xlat6.w * u_xlat10_15 + u_xlat0.x;
    u_xlat2 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xyzy;
    u_xlat3 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xwzw;
    vec3 txVec5 = vec3(u_xlat2.xy,u_xlat0.z);
    u_xlat10_1 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec5, 0.0);
    vec3 txVec6 = vec3(u_xlat2.zw,u_xlat0.z);
    u_xlat10_8 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec6, 0.0);
    u_xlat2 = vec4(u_xlat0.y * u_xlat4.x, u_xlat0.y * u_xlat4.y, u_xlat0.w * u_xlat4.z, u_xlat0.w * u_xlat4.w);
    u_xlat7 = u_xlat0.w * u_xlat4.y;
    u_xlat0.x = u_xlat2.x * u_xlat10_1 + u_xlat0.x;
    u_xlat0.x = u_xlat2.y * u_xlat10_8 + u_xlat0.x;
    u_xlat0.x = u_xlat2.z * u_xlat10_22 + u_xlat0.x;
    vec3 txVec7 = vec3(u_xlat3.xy,u_xlat0.z);
    u_xlat10_21 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec7, 0.0);
    vec3 txVec8 = vec3(u_xlat3.zw,u_xlat0.z);
    u_xlat10_14 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec8, 0.0);
    u_xlat0.x = u_xlat2.w * u_xlat10_21 + u_xlat0.x;
    u_xlat0.x = u_xlat7 * u_xlat10_14 + u_xlat0.x;
    u_xlat16_7 = (-_LightShadowData.x) + 1.0;
    u_xlat0 = u_xlat0.xxxx * vec4(u_xlat16_7) + _LightShadowData.xxxx;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SHADOWS_SINGLE_CASCADE" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
in highp vec3 in_TEXCOORD1;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
out highp vec3 vs_TEXCOORD2;
out highp vec3 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
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
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraInvProjection[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraInvProjection[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    vs_TEXCOORD0.zw = u_xlat1.zz + u_xlat1.xw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    vs_TEXCOORD1.xyz = in_TEXCOORD1.xyz;
    u_xlat1.xyz = u_xlat0.xyz + (-hlslcc_mtx4x4unity_CameraInvProjection[2].xyz);
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[2].xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.w = (-u_xlat1.z);
    vs_TEXCOORD2.xyz = u_xlat1.xyw;
    u_xlat0.w = (-u_xlat0.z);
    vs_TEXCOORD3.xyz = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 unity_OrthoParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
in highp vec3 vs_TEXCOORD2;
in highp vec3 vs_TEXCOORD3;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp float u_xlat10_1;
vec4 u_xlat2;
lowp float u_xlat10_2;
vec4 u_xlat3;
vec4 u_xlat4;
vec4 u_xlat5;
vec4 u_xlat6;
float u_xlat7;
mediump float u_xlat16_7;
lowp float u_xlat10_8;
float u_xlat14;
lowp float u_xlat10_14;
vec2 u_xlat15;
lowp float u_xlat10_15;
lowp float u_xlat10_21;
lowp float u_xlat10_22;
void main()
{
    u_xlat0.x = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat7 = _ZBufferParams.x * u_xlat0.x + _ZBufferParams.y;
    u_xlat7 = float(1.0) / u_xlat7;
    u_xlat14 = (-u_xlat7) + u_xlat0.x;
    u_xlat7 = unity_OrthoParams.w * u_xlat14 + u_xlat7;
    u_xlat1.xyz = (-vs_TEXCOORD2.xyz) + vs_TEXCOORD3.xyz;
    u_xlat0.xzw = u_xlat0.xxx * u_xlat1.xyz + vs_TEXCOORD2.xyz;
    u_xlat0.xzw = (-vs_TEXCOORD1.xyz) * vec3(u_xlat7) + u_xlat0.xzw;
    u_xlat1.xyz = vec3(u_xlat7) * vs_TEXCOORD1.xyz;
    u_xlat0.xyz = unity_OrthoParams.www * u_xlat0.xzw + u_xlat1.xyz;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat1.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[3].xyz * u_xlat0.www + u_xlat0.xyz;
    u_xlat1.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + vec2(0.5, 0.5);
    u_xlat1.xy = floor(u_xlat1.xy);
    u_xlat0.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + (-u_xlat1.xy);
    u_xlat15.xy = min(u_xlat0.xy, vec2(0.0, 0.0));
    u_xlat2.xy = (-u_xlat0.xy) + vec2(1.0, 1.0);
    u_xlat15.xy = (-u_xlat15.xy) * u_xlat15.xy + u_xlat2.xy;
    u_xlat2.xy = u_xlat2.xy * vec2(0.159999996, 0.159999996);
    u_xlat15.xy = u_xlat15.xy + vec2(1.0, 1.0);
    u_xlat3.xy = u_xlat15.xy * vec2(0.159999996, 0.159999996);
    u_xlat15.xy = max(u_xlat0.xy, vec2(0.0, 0.0));
    u_xlat4 = u_xlat0.xxyy + vec4(0.5, 1.0, 0.5, 1.0);
    u_xlat15.xy = (-u_xlat15.xy) * u_xlat15.xy + u_xlat4.yw;
    u_xlat15.xy = u_xlat15.xy + vec2(1.0, 1.0);
    u_xlat5.xy = u_xlat15.xy * vec2(0.159999996, 0.159999996);
    u_xlat6 = u_xlat4.xxzz * u_xlat4.xxzz;
    u_xlat15.xy = vec2(u_xlat4.y * float(0.159999996), u_xlat4.w * float(0.159999996));
    u_xlat0.xy = u_xlat6.xz * vec2(0.5, 0.5) + (-u_xlat0.xy);
    u_xlat2.zw = vec2(u_xlat6.w * float(0.0799999982), u_xlat6.y * float(0.0799999982));
    u_xlat4.xy = u_xlat0.xy * vec2(0.159999996, 0.159999996);
    u_xlat3.z = u_xlat4.y;
    u_xlat3.w = u_xlat15.y;
    u_xlat4.w = u_xlat15.x;
    u_xlat5.zw = u_xlat2.yz;
    u_xlat0.xyw = vec3(u_xlat3.z + u_xlat5.z, u_xlat3.y + u_xlat5.y, u_xlat3.w + u_xlat5.w);
    u_xlat4.z = u_xlat3.x;
    u_xlat3.xyz = vec3(u_xlat5.z / u_xlat0.x, u_xlat5.y / u_xlat0.y, u_xlat5.w / u_xlat0.w);
    u_xlat2.z = u_xlat5.x;
    u_xlat3.xyz = u_xlat3.xyz + vec3(-2.5, -0.5, 1.5);
    u_xlat3.xyz = u_xlat3.xyz * _ShadowMapTexture_TexelSize.yyy;
    u_xlat5.w = u_xlat3.x;
    u_xlat4 = u_xlat2.zwxz + u_xlat4.zwxz;
    u_xlat2.xyz = vec3(u_xlat2.x / u_xlat4.z, u_xlat2.z / u_xlat4.w, u_xlat2.w / u_xlat4.y);
    u_xlat2.xyz = u_xlat2.xyz + vec3(-2.5, -0.5, 1.5);
    u_xlat5.xyz = u_xlat2.yxz * _ShadowMapTexture_TexelSize.xxx;
    u_xlat2 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.ywxw;
    u_xlat15.xy = u_xlat1.xy * _ShadowMapTexture_TexelSize.xy + u_xlat5.zw;
    vec3 txVec0 = vec3(u_xlat15.xy,u_xlat0.z);
    u_xlat10_15 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    vec3 txVec1 = vec3(u_xlat2.xy,u_xlat0.z);
    u_xlat10_22 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec1, 0.0);
    vec3 txVec2 = vec3(u_xlat2.zw,u_xlat0.z);
    u_xlat10_2 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec2, 0.0);
    u_xlat6 = vec4(u_xlat0.x * u_xlat4.z, u_xlat0.x * u_xlat4.w, u_xlat0.x * u_xlat4.y, u_xlat0.y * u_xlat4.z);
    u_xlat0.x = u_xlat10_2 * u_xlat6.y;
    u_xlat0.x = u_xlat6.x * u_xlat10_22 + u_xlat0.x;
    u_xlat0.x = u_xlat6.z * u_xlat10_15 + u_xlat0.x;
    u_xlat3.w = u_xlat5.y;
    u_xlat2 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat3.wywz;
    u_xlat5.yw = u_xlat3.yz;
    vec3 txVec3 = vec3(u_xlat2.xy,u_xlat0.z);
    u_xlat10_15 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec3, 0.0);
    vec3 txVec4 = vec3(u_xlat2.zw,u_xlat0.z);
    u_xlat10_22 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec4, 0.0);
    u_xlat0.x = u_xlat6.w * u_xlat10_15 + u_xlat0.x;
    u_xlat2 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xyzy;
    u_xlat3 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xwzw;
    vec3 txVec5 = vec3(u_xlat2.xy,u_xlat0.z);
    u_xlat10_1 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec5, 0.0);
    vec3 txVec6 = vec3(u_xlat2.zw,u_xlat0.z);
    u_xlat10_8 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec6, 0.0);
    u_xlat2 = vec4(u_xlat0.y * u_xlat4.x, u_xlat0.y * u_xlat4.y, u_xlat0.w * u_xlat4.z, u_xlat0.w * u_xlat4.w);
    u_xlat7 = u_xlat0.w * u_xlat4.y;
    u_xlat0.x = u_xlat2.x * u_xlat10_1 + u_xlat0.x;
    u_xlat0.x = u_xlat2.y * u_xlat10_8 + u_xlat0.x;
    u_xlat0.x = u_xlat2.z * u_xlat10_22 + u_xlat0.x;
    vec3 txVec7 = vec3(u_xlat3.xy,u_xlat0.z);
    u_xlat10_21 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec7, 0.0);
    vec3 txVec8 = vec3(u_xlat3.zw,u_xlat0.z);
    u_xlat10_14 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec8, 0.0);
    u_xlat0.x = u_xlat2.w * u_xlat10_21 + u_xlat0.x;
    u_xlat0.x = u_xlat7 * u_xlat10_14 + u_xlat0.x;
    u_xlat16_7 = (-_LightShadowData.x) + 1.0;
    u_xlat0 = u_xlat0.xxxx * vec4(u_xlat16_7) + _LightShadowData.xxxx;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec3 orthoPosFar_1;
  highp vec3 orthoPosNear_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _glesVertex.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  clipPos_3.xzw = tmpvar_5.xzw;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 o_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_5.zw;
  tmpvar_4.zw = o_7.xy;
  clipPos_3.y = (tmpvar_5.y * _ProjectionParams.x);
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(-1.0, 1.0);
  tmpvar_10.xy = clipPos_3.xy;
  highp vec3 tmpvar_11;
  tmpvar_11 = (unity_CameraInvProjection * tmpvar_10).xyz;
  orthoPosNear_2.xy = tmpvar_11.xy;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(1.0, 1.0);
  tmpvar_12.xy = clipPos_3.xy;
  highp vec3 tmpvar_13;
  tmpvar_13 = (unity_CameraInvProjection * tmpvar_12).xyz;
  orthoPosFar_1.xy = tmpvar_13.xy;
  orthoPosNear_2.z = -(tmpvar_11.z);
  orthoPosFar_1.z = -(tmpvar_13.z);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = _glesMultiTexCoord1.xyz;
  xlv_TEXCOORD2 = orthoPosNear_2;
  xlv_TEXCOORD3 = orthoPosFar_1;
}


#endif
#ifdef FRAGMENT
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_OrthoParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_CameraDepthTexture, xlv_TEXCOORD0.xy);
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = mix ((xlv_TEXCOORD1 * mix (
    (1.0/(((_ZBufferParams.x * tmpvar_2.x) + _ZBufferParams.y)))
  , tmpvar_2.x, unity_OrthoParams.w)), mix (xlv_TEXCOORD2, xlv_TEXCOORD3, tmpvar_2.xxx), unity_OrthoParams.www);
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = (unity_WorldToShadow[0] * (unity_CameraToWorld * tmpvar_3)).xyz;
  mediump float shadow_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = _ShadowMapTexture_TexelSize.xy;
  shadow_5 = 0.0;
  highp vec3 tmpvar_7;
  tmpvar_7.xy = (tmpvar_4.xy - _ShadowMapTexture_TexelSize.xy);
  tmpvar_7.z = tmpvar_4.z;
  highp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_ShadowMapTexture, tmpvar_7.xy);
  mediump float tmpvar_9;
  if ((tmpvar_8.x < tmpvar_4.z)) {
    tmpvar_9 = 0.0;
  } else {
    tmpvar_9 = 1.0;
  };
  shadow_5 = tmpvar_9;
  highp vec2 tmpvar_10;
  tmpvar_10.x = 0.0;
  tmpvar_10.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_11;
  tmpvar_11.xy = (tmpvar_4.xy + tmpvar_10);
  tmpvar_11.z = tmpvar_4.z;
  highp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_ShadowMapTexture, tmpvar_11.xy);
  highp float tmpvar_13;
  if ((tmpvar_12.x < tmpvar_4.z)) {
    tmpvar_13 = 0.0;
  } else {
    tmpvar_13 = 1.0;
  };
  shadow_5 = (tmpvar_9 + tmpvar_13);
  highp vec2 tmpvar_14;
  tmpvar_14.x = tmpvar_6.x;
  tmpvar_14.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_15;
  tmpvar_15.xy = (tmpvar_4.xy + tmpvar_14);
  tmpvar_15.z = tmpvar_4.z;
  highp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_ShadowMapTexture, tmpvar_15.xy);
  highp float tmpvar_17;
  if ((tmpvar_16.x < tmpvar_4.z)) {
    tmpvar_17 = 0.0;
  } else {
    tmpvar_17 = 1.0;
  };
  shadow_5 = (shadow_5 + tmpvar_17);
  highp vec2 tmpvar_18;
  tmpvar_18.y = 0.0;
  tmpvar_18.x = -(_ShadowMapTexture_TexelSize.x);
  highp vec3 tmpvar_19;
  tmpvar_19.xy = (tmpvar_4.xy + tmpvar_18);
  tmpvar_19.z = tmpvar_4.z;
  highp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_ShadowMapTexture, tmpvar_19.xy);
  highp float tmpvar_21;
  if ((tmpvar_20.x < tmpvar_4.z)) {
    tmpvar_21 = 0.0;
  } else {
    tmpvar_21 = 1.0;
  };
  shadow_5 = (shadow_5 + tmpvar_21);
  highp vec4 tmpvar_22;
  tmpvar_22 = texture2D (_ShadowMapTexture, tmpvar_4.xy);
  highp float tmpvar_23;
  if ((tmpvar_22.x < tmpvar_4.z)) {
    tmpvar_23 = 0.0;
  } else {
    tmpvar_23 = 1.0;
  };
  shadow_5 = (shadow_5 + tmpvar_23);
  highp vec2 tmpvar_24;
  tmpvar_24.y = 0.0;
  tmpvar_24.x = tmpvar_6.x;
  highp vec3 tmpvar_25;
  tmpvar_25.xy = (tmpvar_4.xy + tmpvar_24);
  tmpvar_25.z = tmpvar_4.z;
  highp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_ShadowMapTexture, tmpvar_25.xy);
  highp float tmpvar_27;
  if ((tmpvar_26.x < tmpvar_4.z)) {
    tmpvar_27 = 0.0;
  } else {
    tmpvar_27 = 1.0;
  };
  shadow_5 = (shadow_5 + tmpvar_27);
  highp vec2 tmpvar_28;
  tmpvar_28.x = -(_ShadowMapTexture_TexelSize.x);
  tmpvar_28.y = tmpvar_6.y;
  highp vec3 tmpvar_29;
  tmpvar_29.xy = (tmpvar_4.xy + tmpvar_28);
  tmpvar_29.z = tmpvar_4.z;
  highp vec4 tmpvar_30;
  tmpvar_30 = texture2D (_ShadowMapTexture, tmpvar_29.xy);
  highp float tmpvar_31;
  if ((tmpvar_30.x < tmpvar_4.z)) {
    tmpvar_31 = 0.0;
  } else {
    tmpvar_31 = 1.0;
  };
  shadow_5 = (shadow_5 + tmpvar_31);
  highp vec2 tmpvar_32;
  tmpvar_32.x = 0.0;
  tmpvar_32.y = tmpvar_6.y;
  highp vec3 tmpvar_33;
  tmpvar_33.xy = (tmpvar_4.xy + tmpvar_32);
  tmpvar_33.z = tmpvar_4.z;
  highp vec4 tmpvar_34;
  tmpvar_34 = texture2D (_ShadowMapTexture, tmpvar_33.xy);
  highp float tmpvar_35;
  if ((tmpvar_34.x < tmpvar_4.z)) {
    tmpvar_35 = 0.0;
  } else {
    tmpvar_35 = 1.0;
  };
  shadow_5 = (shadow_5 + tmpvar_35);
  highp vec3 tmpvar_36;
  tmpvar_36.xy = (tmpvar_4.xy + _ShadowMapTexture_TexelSize.xy);
  tmpvar_36.z = tmpvar_4.z;
  highp vec4 tmpvar_37;
  tmpvar_37 = texture2D (_ShadowMapTexture, tmpvar_36.xy);
  highp float tmpvar_38;
  if ((tmpvar_37.x < tmpvar_4.z)) {
    tmpvar_38 = 0.0;
  } else {
    tmpvar_38 = 1.0;
  };
  shadow_5 = (shadow_5 + tmpvar_38);
  shadow_5 = (shadow_5 / 9.0);
  mediump vec4 tmpvar_39;
  tmpvar_39 = vec4(mix (_LightShadowData.x, 1.0, shadow_5));
  tmpvar_1 = tmpvar_39;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec3 orthoPosFar_1;
  highp vec3 orthoPosNear_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _glesVertex.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  clipPos_3.xzw = tmpvar_5.xzw;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 o_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_5.zw;
  tmpvar_4.zw = o_7.xy;
  clipPos_3.y = (tmpvar_5.y * _ProjectionParams.x);
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(-1.0, 1.0);
  tmpvar_10.xy = clipPos_3.xy;
  highp vec3 tmpvar_11;
  tmpvar_11 = (unity_CameraInvProjection * tmpvar_10).xyz;
  orthoPosNear_2.xy = tmpvar_11.xy;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(1.0, 1.0);
  tmpvar_12.xy = clipPos_3.xy;
  highp vec3 tmpvar_13;
  tmpvar_13 = (unity_CameraInvProjection * tmpvar_12).xyz;
  orthoPosFar_1.xy = tmpvar_13.xy;
  orthoPosNear_2.z = -(tmpvar_11.z);
  orthoPosFar_1.z = -(tmpvar_13.z);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = _glesMultiTexCoord1.xyz;
  xlv_TEXCOORD2 = orthoPosNear_2;
  xlv_TEXCOORD3 = orthoPosFar_1;
}


#endif
#ifdef FRAGMENT
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_OrthoParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_CameraDepthTexture, xlv_TEXCOORD0.xy);
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = mix ((xlv_TEXCOORD1 * mix (
    (1.0/(((_ZBufferParams.x * tmpvar_2.x) + _ZBufferParams.y)))
  , tmpvar_2.x, unity_OrthoParams.w)), mix (xlv_TEXCOORD2, xlv_TEXCOORD3, tmpvar_2.xxx), unity_OrthoParams.www);
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = (unity_WorldToShadow[0] * (unity_CameraToWorld * tmpvar_3)).xyz;
  mediump float shadow_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = _ShadowMapTexture_TexelSize.xy;
  shadow_5 = 0.0;
  highp vec3 tmpvar_7;
  tmpvar_7.xy = (tmpvar_4.xy - _ShadowMapTexture_TexelSize.xy);
  tmpvar_7.z = tmpvar_4.z;
  highp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_ShadowMapTexture, tmpvar_7.xy);
  mediump float tmpvar_9;
  if ((tmpvar_8.x < tmpvar_4.z)) {
    tmpvar_9 = 0.0;
  } else {
    tmpvar_9 = 1.0;
  };
  shadow_5 = tmpvar_9;
  highp vec2 tmpvar_10;
  tmpvar_10.x = 0.0;
  tmpvar_10.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_11;
  tmpvar_11.xy = (tmpvar_4.xy + tmpvar_10);
  tmpvar_11.z = tmpvar_4.z;
  highp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_ShadowMapTexture, tmpvar_11.xy);
  highp float tmpvar_13;
  if ((tmpvar_12.x < tmpvar_4.z)) {
    tmpvar_13 = 0.0;
  } else {
    tmpvar_13 = 1.0;
  };
  shadow_5 = (tmpvar_9 + tmpvar_13);
  highp vec2 tmpvar_14;
  tmpvar_14.x = tmpvar_6.x;
  tmpvar_14.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_15;
  tmpvar_15.xy = (tmpvar_4.xy + tmpvar_14);
  tmpvar_15.z = tmpvar_4.z;
  highp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_ShadowMapTexture, tmpvar_15.xy);
  highp float tmpvar_17;
  if ((tmpvar_16.x < tmpvar_4.z)) {
    tmpvar_17 = 0.0;
  } else {
    tmpvar_17 = 1.0;
  };
  shadow_5 = (shadow_5 + tmpvar_17);
  highp vec2 tmpvar_18;
  tmpvar_18.y = 0.0;
  tmpvar_18.x = -(_ShadowMapTexture_TexelSize.x);
  highp vec3 tmpvar_19;
  tmpvar_19.xy = (tmpvar_4.xy + tmpvar_18);
  tmpvar_19.z = tmpvar_4.z;
  highp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_ShadowMapTexture, tmpvar_19.xy);
  highp float tmpvar_21;
  if ((tmpvar_20.x < tmpvar_4.z)) {
    tmpvar_21 = 0.0;
  } else {
    tmpvar_21 = 1.0;
  };
  shadow_5 = (shadow_5 + tmpvar_21);
  highp vec4 tmpvar_22;
  tmpvar_22 = texture2D (_ShadowMapTexture, tmpvar_4.xy);
  highp float tmpvar_23;
  if ((tmpvar_22.x < tmpvar_4.z)) {
    tmpvar_23 = 0.0;
  } else {
    tmpvar_23 = 1.0;
  };
  shadow_5 = (shadow_5 + tmpvar_23);
  highp vec2 tmpvar_24;
  tmpvar_24.y = 0.0;
  tmpvar_24.x = tmpvar_6.x;
  highp vec3 tmpvar_25;
  tmpvar_25.xy = (tmpvar_4.xy + tmpvar_24);
  tmpvar_25.z = tmpvar_4.z;
  highp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_ShadowMapTexture, tmpvar_25.xy);
  highp float tmpvar_27;
  if ((tmpvar_26.x < tmpvar_4.z)) {
    tmpvar_27 = 0.0;
  } else {
    tmpvar_27 = 1.0;
  };
  shadow_5 = (shadow_5 + tmpvar_27);
  highp vec2 tmpvar_28;
  tmpvar_28.x = -(_ShadowMapTexture_TexelSize.x);
  tmpvar_28.y = tmpvar_6.y;
  highp vec3 tmpvar_29;
  tmpvar_29.xy = (tmpvar_4.xy + tmpvar_28);
  tmpvar_29.z = tmpvar_4.z;
  highp vec4 tmpvar_30;
  tmpvar_30 = texture2D (_ShadowMapTexture, tmpvar_29.xy);
  highp float tmpvar_31;
  if ((tmpvar_30.x < tmpvar_4.z)) {
    tmpvar_31 = 0.0;
  } else {
    tmpvar_31 = 1.0;
  };
  shadow_5 = (shadow_5 + tmpvar_31);
  highp vec2 tmpvar_32;
  tmpvar_32.x = 0.0;
  tmpvar_32.y = tmpvar_6.y;
  highp vec3 tmpvar_33;
  tmpvar_33.xy = (tmpvar_4.xy + tmpvar_32);
  tmpvar_33.z = tmpvar_4.z;
  highp vec4 tmpvar_34;
  tmpvar_34 = texture2D (_ShadowMapTexture, tmpvar_33.xy);
  highp float tmpvar_35;
  if ((tmpvar_34.x < tmpvar_4.z)) {
    tmpvar_35 = 0.0;
  } else {
    tmpvar_35 = 1.0;
  };
  shadow_5 = (shadow_5 + tmpvar_35);
  highp vec3 tmpvar_36;
  tmpvar_36.xy = (tmpvar_4.xy + _ShadowMapTexture_TexelSize.xy);
  tmpvar_36.z = tmpvar_4.z;
  highp vec4 tmpvar_37;
  tmpvar_37 = texture2D (_ShadowMapTexture, tmpvar_36.xy);
  highp float tmpvar_38;
  if ((tmpvar_37.x < tmpvar_4.z)) {
    tmpvar_38 = 0.0;
  } else {
    tmpvar_38 = 1.0;
  };
  shadow_5 = (shadow_5 + tmpvar_38);
  shadow_5 = (shadow_5 / 9.0);
  mediump vec4 tmpvar_39;
  tmpvar_39 = vec4(mix (_LightShadowData.x, 1.0, shadow_5));
  tmpvar_1 = tmpvar_39;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec3 orthoPosFar_1;
  highp vec3 orthoPosNear_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _glesVertex.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  clipPos_3.xzw = tmpvar_5.xzw;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 o_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_5.zw;
  tmpvar_4.zw = o_7.xy;
  clipPos_3.y = (tmpvar_5.y * _ProjectionParams.x);
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(-1.0, 1.0);
  tmpvar_10.xy = clipPos_3.xy;
  highp vec3 tmpvar_11;
  tmpvar_11 = (unity_CameraInvProjection * tmpvar_10).xyz;
  orthoPosNear_2.xy = tmpvar_11.xy;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(1.0, 1.0);
  tmpvar_12.xy = clipPos_3.xy;
  highp vec3 tmpvar_13;
  tmpvar_13 = (unity_CameraInvProjection * tmpvar_12).xyz;
  orthoPosFar_1.xy = tmpvar_13.xy;
  orthoPosNear_2.z = -(tmpvar_11.z);
  orthoPosFar_1.z = -(tmpvar_13.z);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = _glesMultiTexCoord1.xyz;
  xlv_TEXCOORD2 = orthoPosNear_2;
  xlv_TEXCOORD3 = orthoPosFar_1;
}


#endif
#ifdef FRAGMENT
uniform highp vec4 _ZBufferParams;
uniform highp vec4 unity_OrthoParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2 = texture2D (_CameraDepthTexture, xlv_TEXCOORD0.xy);
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = mix ((xlv_TEXCOORD1 * mix (
    (1.0/(((_ZBufferParams.x * tmpvar_2.x) + _ZBufferParams.y)))
  , tmpvar_2.x, unity_OrthoParams.w)), mix (xlv_TEXCOORD2, xlv_TEXCOORD3, tmpvar_2.xxx), unity_OrthoParams.www);
  highp vec4 tmpvar_4;
  tmpvar_4.w = 0.0;
  tmpvar_4.xyz = (unity_WorldToShadow[0] * (unity_CameraToWorld * tmpvar_3)).xyz;
  mediump float shadow_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = _ShadowMapTexture_TexelSize.xy;
  shadow_5 = 0.0;
  highp vec3 tmpvar_7;
  tmpvar_7.xy = (tmpvar_4.xy - _ShadowMapTexture_TexelSize.xy);
  tmpvar_7.z = tmpvar_4.z;
  highp vec4 tmpvar_8;
  tmpvar_8 = texture2D (_ShadowMapTexture, tmpvar_7.xy);
  mediump float tmpvar_9;
  if ((tmpvar_8.x < tmpvar_4.z)) {
    tmpvar_9 = 0.0;
  } else {
    tmpvar_9 = 1.0;
  };
  shadow_5 = tmpvar_9;
  highp vec2 tmpvar_10;
  tmpvar_10.x = 0.0;
  tmpvar_10.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_11;
  tmpvar_11.xy = (tmpvar_4.xy + tmpvar_10);
  tmpvar_11.z = tmpvar_4.z;
  highp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_ShadowMapTexture, tmpvar_11.xy);
  highp float tmpvar_13;
  if ((tmpvar_12.x < tmpvar_4.z)) {
    tmpvar_13 = 0.0;
  } else {
    tmpvar_13 = 1.0;
  };
  shadow_5 = (tmpvar_9 + tmpvar_13);
  highp vec2 tmpvar_14;
  tmpvar_14.x = tmpvar_6.x;
  tmpvar_14.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_15;
  tmpvar_15.xy = (tmpvar_4.xy + tmpvar_14);
  tmpvar_15.z = tmpvar_4.z;
  highp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_ShadowMapTexture, tmpvar_15.xy);
  highp float tmpvar_17;
  if ((tmpvar_16.x < tmpvar_4.z)) {
    tmpvar_17 = 0.0;
  } else {
    tmpvar_17 = 1.0;
  };
  shadow_5 = (shadow_5 + tmpvar_17);
  highp vec2 tmpvar_18;
  tmpvar_18.y = 0.0;
  tmpvar_18.x = -(_ShadowMapTexture_TexelSize.x);
  highp vec3 tmpvar_19;
  tmpvar_19.xy = (tmpvar_4.xy + tmpvar_18);
  tmpvar_19.z = tmpvar_4.z;
  highp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_ShadowMapTexture, tmpvar_19.xy);
  highp float tmpvar_21;
  if ((tmpvar_20.x < tmpvar_4.z)) {
    tmpvar_21 = 0.0;
  } else {
    tmpvar_21 = 1.0;
  };
  shadow_5 = (shadow_5 + tmpvar_21);
  highp vec4 tmpvar_22;
  tmpvar_22 = texture2D (_ShadowMapTexture, tmpvar_4.xy);
  highp float tmpvar_23;
  if ((tmpvar_22.x < tmpvar_4.z)) {
    tmpvar_23 = 0.0;
  } else {
    tmpvar_23 = 1.0;
  };
  shadow_5 = (shadow_5 + tmpvar_23);
  highp vec2 tmpvar_24;
  tmpvar_24.y = 0.0;
  tmpvar_24.x = tmpvar_6.x;
  highp vec3 tmpvar_25;
  tmpvar_25.xy = (tmpvar_4.xy + tmpvar_24);
  tmpvar_25.z = tmpvar_4.z;
  highp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_ShadowMapTexture, tmpvar_25.xy);
  highp float tmpvar_27;
  if ((tmpvar_26.x < tmpvar_4.z)) {
    tmpvar_27 = 0.0;
  } else {
    tmpvar_27 = 1.0;
  };
  shadow_5 = (shadow_5 + tmpvar_27);
  highp vec2 tmpvar_28;
  tmpvar_28.x = -(_ShadowMapTexture_TexelSize.x);
  tmpvar_28.y = tmpvar_6.y;
  highp vec3 tmpvar_29;
  tmpvar_29.xy = (tmpvar_4.xy + tmpvar_28);
  tmpvar_29.z = tmpvar_4.z;
  highp vec4 tmpvar_30;
  tmpvar_30 = texture2D (_ShadowMapTexture, tmpvar_29.xy);
  highp float tmpvar_31;
  if ((tmpvar_30.x < tmpvar_4.z)) {
    tmpvar_31 = 0.0;
  } else {
    tmpvar_31 = 1.0;
  };
  shadow_5 = (shadow_5 + tmpvar_31);
  highp vec2 tmpvar_32;
  tmpvar_32.x = 0.0;
  tmpvar_32.y = tmpvar_6.y;
  highp vec3 tmpvar_33;
  tmpvar_33.xy = (tmpvar_4.xy + tmpvar_32);
  tmpvar_33.z = tmpvar_4.z;
  highp vec4 tmpvar_34;
  tmpvar_34 = texture2D (_ShadowMapTexture, tmpvar_33.xy);
  highp float tmpvar_35;
  if ((tmpvar_34.x < tmpvar_4.z)) {
    tmpvar_35 = 0.0;
  } else {
    tmpvar_35 = 1.0;
  };
  shadow_5 = (shadow_5 + tmpvar_35);
  highp vec3 tmpvar_36;
  tmpvar_36.xy = (tmpvar_4.xy + _ShadowMapTexture_TexelSize.xy);
  tmpvar_36.z = tmpvar_4.z;
  highp vec4 tmpvar_37;
  tmpvar_37 = texture2D (_ShadowMapTexture, tmpvar_36.xy);
  highp float tmpvar_38;
  if ((tmpvar_37.x < tmpvar_4.z)) {
    tmpvar_38 = 0.0;
  } else {
    tmpvar_38 = 1.0;
  };
  shadow_5 = (shadow_5 + tmpvar_38);
  shadow_5 = (shadow_5 / 9.0);
  mediump vec4 tmpvar_39;
  tmpvar_39 = vec4(mix (_LightShadowData.x, 1.0, shadow_5));
  tmpvar_1 = tmpvar_39;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
in highp vec3 in_TEXCOORD1;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
out highp vec3 vs_TEXCOORD2;
out highp vec3 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
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
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraInvProjection[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraInvProjection[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    vs_TEXCOORD0.zw = u_xlat1.zz + u_xlat1.xw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    vs_TEXCOORD1.xyz = in_TEXCOORD1.xyz;
    u_xlat1.xyz = u_xlat0.xyz + (-hlslcc_mtx4x4unity_CameraInvProjection[2].xyz);
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[2].xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.w = (-u_xlat1.z);
    vs_TEXCOORD2.xyz = u_xlat1.xyw;
    u_xlat0.w = (-u_xlat0.z);
    vs_TEXCOORD3.xyz = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 unity_OrthoParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
in highp vec3 vs_TEXCOORD2;
in highp vec3 vs_TEXCOORD3;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp float u_xlat10_1;
vec4 u_xlat2;
lowp float u_xlat10_2;
vec4 u_xlat3;
vec4 u_xlat4;
vec4 u_xlat5;
vec4 u_xlat6;
float u_xlat7;
mediump float u_xlat16_7;
lowp float u_xlat10_8;
float u_xlat14;
lowp float u_xlat10_14;
vec2 u_xlat15;
lowp float u_xlat10_15;
lowp float u_xlat10_21;
lowp float u_xlat10_22;
void main()
{
    u_xlat0.x = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat7 = _ZBufferParams.x * u_xlat0.x + _ZBufferParams.y;
    u_xlat7 = float(1.0) / u_xlat7;
    u_xlat14 = (-u_xlat7) + u_xlat0.x;
    u_xlat7 = unity_OrthoParams.w * u_xlat14 + u_xlat7;
    u_xlat1.xyz = (-vs_TEXCOORD2.xyz) + vs_TEXCOORD3.xyz;
    u_xlat0.xzw = u_xlat0.xxx * u_xlat1.xyz + vs_TEXCOORD2.xyz;
    u_xlat0.xzw = (-vs_TEXCOORD1.xyz) * vec3(u_xlat7) + u_xlat0.xzw;
    u_xlat1.xyz = vec3(u_xlat7) * vs_TEXCOORD1.xyz;
    u_xlat0.xyz = unity_OrthoParams.www * u_xlat0.xzw + u_xlat1.xyz;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat1.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[3].xyz * u_xlat0.www + u_xlat0.xyz;
    u_xlat1.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + vec2(0.5, 0.5);
    u_xlat1.xy = floor(u_xlat1.xy);
    u_xlat0.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + (-u_xlat1.xy);
    u_xlat15.xy = min(u_xlat0.xy, vec2(0.0, 0.0));
    u_xlat2.xy = (-u_xlat0.xy) + vec2(1.0, 1.0);
    u_xlat15.xy = (-u_xlat15.xy) * u_xlat15.xy + u_xlat2.xy;
    u_xlat2.xy = u_xlat2.xy * vec2(0.159999996, 0.159999996);
    u_xlat15.xy = u_xlat15.xy + vec2(1.0, 1.0);
    u_xlat3.xy = u_xlat15.xy * vec2(0.159999996, 0.159999996);
    u_xlat15.xy = max(u_xlat0.xy, vec2(0.0, 0.0));
    u_xlat4 = u_xlat0.xxyy + vec4(0.5, 1.0, 0.5, 1.0);
    u_xlat15.xy = (-u_xlat15.xy) * u_xlat15.xy + u_xlat4.yw;
    u_xlat15.xy = u_xlat15.xy + vec2(1.0, 1.0);
    u_xlat5.xy = u_xlat15.xy * vec2(0.159999996, 0.159999996);
    u_xlat6 = u_xlat4.xxzz * u_xlat4.xxzz;
    u_xlat15.xy = vec2(u_xlat4.y * float(0.159999996), u_xlat4.w * float(0.159999996));
    u_xlat0.xy = u_xlat6.xz * vec2(0.5, 0.5) + (-u_xlat0.xy);
    u_xlat2.zw = vec2(u_xlat6.w * float(0.0799999982), u_xlat6.y * float(0.0799999982));
    u_xlat4.xy = u_xlat0.xy * vec2(0.159999996, 0.159999996);
    u_xlat3.z = u_xlat4.y;
    u_xlat3.w = u_xlat15.y;
    u_xlat4.w = u_xlat15.x;
    u_xlat5.zw = u_xlat2.yz;
    u_xlat0.xyw = vec3(u_xlat3.z + u_xlat5.z, u_xlat3.y + u_xlat5.y, u_xlat3.w + u_xlat5.w);
    u_xlat4.z = u_xlat3.x;
    u_xlat3.xyz = vec3(u_xlat5.z / u_xlat0.x, u_xlat5.y / u_xlat0.y, u_xlat5.w / u_xlat0.w);
    u_xlat2.z = u_xlat5.x;
    u_xlat3.xyz = u_xlat3.xyz + vec3(-2.5, -0.5, 1.5);
    u_xlat3.xyz = u_xlat3.xyz * _ShadowMapTexture_TexelSize.yyy;
    u_xlat5.w = u_xlat3.x;
    u_xlat4 = u_xlat2.zwxz + u_xlat4.zwxz;
    u_xlat2.xyz = vec3(u_xlat2.x / u_xlat4.z, u_xlat2.z / u_xlat4.w, u_xlat2.w / u_xlat4.y);
    u_xlat2.xyz = u_xlat2.xyz + vec3(-2.5, -0.5, 1.5);
    u_xlat5.xyz = u_xlat2.yxz * _ShadowMapTexture_TexelSize.xxx;
    u_xlat2 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.ywxw;
    u_xlat15.xy = u_xlat1.xy * _ShadowMapTexture_TexelSize.xy + u_xlat5.zw;
    vec3 txVec0 = vec3(u_xlat15.xy,u_xlat0.z);
    u_xlat10_15 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    vec3 txVec1 = vec3(u_xlat2.xy,u_xlat0.z);
    u_xlat10_22 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec1, 0.0);
    vec3 txVec2 = vec3(u_xlat2.zw,u_xlat0.z);
    u_xlat10_2 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec2, 0.0);
    u_xlat6 = vec4(u_xlat0.x * u_xlat4.z, u_xlat0.x * u_xlat4.w, u_xlat0.x * u_xlat4.y, u_xlat0.y * u_xlat4.z);
    u_xlat0.x = u_xlat10_2 * u_xlat6.y;
    u_xlat0.x = u_xlat6.x * u_xlat10_22 + u_xlat0.x;
    u_xlat0.x = u_xlat6.z * u_xlat10_15 + u_xlat0.x;
    u_xlat3.w = u_xlat5.y;
    u_xlat2 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat3.wywz;
    u_xlat5.yw = u_xlat3.yz;
    vec3 txVec3 = vec3(u_xlat2.xy,u_xlat0.z);
    u_xlat10_15 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec3, 0.0);
    vec3 txVec4 = vec3(u_xlat2.zw,u_xlat0.z);
    u_xlat10_22 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec4, 0.0);
    u_xlat0.x = u_xlat6.w * u_xlat10_15 + u_xlat0.x;
    u_xlat2 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xyzy;
    u_xlat3 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xwzw;
    vec3 txVec5 = vec3(u_xlat2.xy,u_xlat0.z);
    u_xlat10_1 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec5, 0.0);
    vec3 txVec6 = vec3(u_xlat2.zw,u_xlat0.z);
    u_xlat10_8 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec6, 0.0);
    u_xlat2 = vec4(u_xlat0.y * u_xlat4.x, u_xlat0.y * u_xlat4.y, u_xlat0.w * u_xlat4.z, u_xlat0.w * u_xlat4.w);
    u_xlat7 = u_xlat0.w * u_xlat4.y;
    u_xlat0.x = u_xlat2.x * u_xlat10_1 + u_xlat0.x;
    u_xlat0.x = u_xlat2.y * u_xlat10_8 + u_xlat0.x;
    u_xlat0.x = u_xlat2.z * u_xlat10_22 + u_xlat0.x;
    vec3 txVec7 = vec3(u_xlat3.xy,u_xlat0.z);
    u_xlat10_21 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec7, 0.0);
    vec3 txVec8 = vec3(u_xlat3.zw,u_xlat0.z);
    u_xlat10_14 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec8, 0.0);
    u_xlat0.x = u_xlat2.w * u_xlat10_21 + u_xlat0.x;
    u_xlat0.x = u_xlat7 * u_xlat10_14 + u_xlat0.x;
    u_xlat16_7 = (-_LightShadowData.x) + 1.0;
    u_xlat0 = u_xlat0.xxxx * vec4(u_xlat16_7) + _LightShadowData.xxxx;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
in highp vec3 in_TEXCOORD1;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
out highp vec3 vs_TEXCOORD2;
out highp vec3 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
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
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraInvProjection[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraInvProjection[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    vs_TEXCOORD0.zw = u_xlat1.zz + u_xlat1.xw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    vs_TEXCOORD1.xyz = in_TEXCOORD1.xyz;
    u_xlat1.xyz = u_xlat0.xyz + (-hlslcc_mtx4x4unity_CameraInvProjection[2].xyz);
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[2].xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.w = (-u_xlat1.z);
    vs_TEXCOORD2.xyz = u_xlat1.xyw;
    u_xlat0.w = (-u_xlat0.z);
    vs_TEXCOORD3.xyz = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 unity_OrthoParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
in highp vec3 vs_TEXCOORD2;
in highp vec3 vs_TEXCOORD3;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp float u_xlat10_1;
vec4 u_xlat2;
lowp float u_xlat10_2;
vec4 u_xlat3;
vec4 u_xlat4;
vec4 u_xlat5;
vec4 u_xlat6;
float u_xlat7;
mediump float u_xlat16_7;
lowp float u_xlat10_8;
float u_xlat14;
lowp float u_xlat10_14;
vec2 u_xlat15;
lowp float u_xlat10_15;
lowp float u_xlat10_21;
lowp float u_xlat10_22;
void main()
{
    u_xlat0.x = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat7 = _ZBufferParams.x * u_xlat0.x + _ZBufferParams.y;
    u_xlat7 = float(1.0) / u_xlat7;
    u_xlat14 = (-u_xlat7) + u_xlat0.x;
    u_xlat7 = unity_OrthoParams.w * u_xlat14 + u_xlat7;
    u_xlat1.xyz = (-vs_TEXCOORD2.xyz) + vs_TEXCOORD3.xyz;
    u_xlat0.xzw = u_xlat0.xxx * u_xlat1.xyz + vs_TEXCOORD2.xyz;
    u_xlat0.xzw = (-vs_TEXCOORD1.xyz) * vec3(u_xlat7) + u_xlat0.xzw;
    u_xlat1.xyz = vec3(u_xlat7) * vs_TEXCOORD1.xyz;
    u_xlat0.xyz = unity_OrthoParams.www * u_xlat0.xzw + u_xlat1.xyz;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat1.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[3].xyz * u_xlat0.www + u_xlat0.xyz;
    u_xlat1.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + vec2(0.5, 0.5);
    u_xlat1.xy = floor(u_xlat1.xy);
    u_xlat0.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + (-u_xlat1.xy);
    u_xlat15.xy = min(u_xlat0.xy, vec2(0.0, 0.0));
    u_xlat2.xy = (-u_xlat0.xy) + vec2(1.0, 1.0);
    u_xlat15.xy = (-u_xlat15.xy) * u_xlat15.xy + u_xlat2.xy;
    u_xlat2.xy = u_xlat2.xy * vec2(0.159999996, 0.159999996);
    u_xlat15.xy = u_xlat15.xy + vec2(1.0, 1.0);
    u_xlat3.xy = u_xlat15.xy * vec2(0.159999996, 0.159999996);
    u_xlat15.xy = max(u_xlat0.xy, vec2(0.0, 0.0));
    u_xlat4 = u_xlat0.xxyy + vec4(0.5, 1.0, 0.5, 1.0);
    u_xlat15.xy = (-u_xlat15.xy) * u_xlat15.xy + u_xlat4.yw;
    u_xlat15.xy = u_xlat15.xy + vec2(1.0, 1.0);
    u_xlat5.xy = u_xlat15.xy * vec2(0.159999996, 0.159999996);
    u_xlat6 = u_xlat4.xxzz * u_xlat4.xxzz;
    u_xlat15.xy = vec2(u_xlat4.y * float(0.159999996), u_xlat4.w * float(0.159999996));
    u_xlat0.xy = u_xlat6.xz * vec2(0.5, 0.5) + (-u_xlat0.xy);
    u_xlat2.zw = vec2(u_xlat6.w * float(0.0799999982), u_xlat6.y * float(0.0799999982));
    u_xlat4.xy = u_xlat0.xy * vec2(0.159999996, 0.159999996);
    u_xlat3.z = u_xlat4.y;
    u_xlat3.w = u_xlat15.y;
    u_xlat4.w = u_xlat15.x;
    u_xlat5.zw = u_xlat2.yz;
    u_xlat0.xyw = vec3(u_xlat3.z + u_xlat5.z, u_xlat3.y + u_xlat5.y, u_xlat3.w + u_xlat5.w);
    u_xlat4.z = u_xlat3.x;
    u_xlat3.xyz = vec3(u_xlat5.z / u_xlat0.x, u_xlat5.y / u_xlat0.y, u_xlat5.w / u_xlat0.w);
    u_xlat2.z = u_xlat5.x;
    u_xlat3.xyz = u_xlat3.xyz + vec3(-2.5, -0.5, 1.5);
    u_xlat3.xyz = u_xlat3.xyz * _ShadowMapTexture_TexelSize.yyy;
    u_xlat5.w = u_xlat3.x;
    u_xlat4 = u_xlat2.zwxz + u_xlat4.zwxz;
    u_xlat2.xyz = vec3(u_xlat2.x / u_xlat4.z, u_xlat2.z / u_xlat4.w, u_xlat2.w / u_xlat4.y);
    u_xlat2.xyz = u_xlat2.xyz + vec3(-2.5, -0.5, 1.5);
    u_xlat5.xyz = u_xlat2.yxz * _ShadowMapTexture_TexelSize.xxx;
    u_xlat2 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.ywxw;
    u_xlat15.xy = u_xlat1.xy * _ShadowMapTexture_TexelSize.xy + u_xlat5.zw;
    vec3 txVec0 = vec3(u_xlat15.xy,u_xlat0.z);
    u_xlat10_15 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    vec3 txVec1 = vec3(u_xlat2.xy,u_xlat0.z);
    u_xlat10_22 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec1, 0.0);
    vec3 txVec2 = vec3(u_xlat2.zw,u_xlat0.z);
    u_xlat10_2 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec2, 0.0);
    u_xlat6 = vec4(u_xlat0.x * u_xlat4.z, u_xlat0.x * u_xlat4.w, u_xlat0.x * u_xlat4.y, u_xlat0.y * u_xlat4.z);
    u_xlat0.x = u_xlat10_2 * u_xlat6.y;
    u_xlat0.x = u_xlat6.x * u_xlat10_22 + u_xlat0.x;
    u_xlat0.x = u_xlat6.z * u_xlat10_15 + u_xlat0.x;
    u_xlat3.w = u_xlat5.y;
    u_xlat2 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat3.wywz;
    u_xlat5.yw = u_xlat3.yz;
    vec3 txVec3 = vec3(u_xlat2.xy,u_xlat0.z);
    u_xlat10_15 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec3, 0.0);
    vec3 txVec4 = vec3(u_xlat2.zw,u_xlat0.z);
    u_xlat10_22 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec4, 0.0);
    u_xlat0.x = u_xlat6.w * u_xlat10_15 + u_xlat0.x;
    u_xlat2 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xyzy;
    u_xlat3 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xwzw;
    vec3 txVec5 = vec3(u_xlat2.xy,u_xlat0.z);
    u_xlat10_1 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec5, 0.0);
    vec3 txVec6 = vec3(u_xlat2.zw,u_xlat0.z);
    u_xlat10_8 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec6, 0.0);
    u_xlat2 = vec4(u_xlat0.y * u_xlat4.x, u_xlat0.y * u_xlat4.y, u_xlat0.w * u_xlat4.z, u_xlat0.w * u_xlat4.w);
    u_xlat7 = u_xlat0.w * u_xlat4.y;
    u_xlat0.x = u_xlat2.x * u_xlat10_1 + u_xlat0.x;
    u_xlat0.x = u_xlat2.y * u_xlat10_8 + u_xlat0.x;
    u_xlat0.x = u_xlat2.z * u_xlat10_22 + u_xlat0.x;
    vec3 txVec7 = vec3(u_xlat3.xy,u_xlat0.z);
    u_xlat10_21 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec7, 0.0);
    vec3 txVec8 = vec3(u_xlat3.zw,u_xlat0.z);
    u_xlat10_14 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec8, 0.0);
    u_xlat0.x = u_xlat2.w * u_xlat10_21 + u_xlat0.x;
    u_xlat0.x = u_xlat7 * u_xlat10_14 + u_xlat0.x;
    u_xlat16_7 = (-_LightShadowData.x) + 1.0;
    u_xlat0 = u_xlat0.xxxx * vec4(u_xlat16_7) + _LightShadowData.xxxx;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
in highp vec3 in_TEXCOORD1;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
out highp vec3 vs_TEXCOORD2;
out highp vec3 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
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
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraInvProjection[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraInvProjection[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    vs_TEXCOORD0.zw = u_xlat1.zz + u_xlat1.xw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    vs_TEXCOORD1.xyz = in_TEXCOORD1.xyz;
    u_xlat1.xyz = u_xlat0.xyz + (-hlslcc_mtx4x4unity_CameraInvProjection[2].xyz);
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[2].xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.w = (-u_xlat1.z);
    vs_TEXCOORD2.xyz = u_xlat1.xyw;
    u_xlat0.w = (-u_xlat0.z);
    vs_TEXCOORD3.xyz = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 _ZBufferParams;
uniform 	vec4 unity_OrthoParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
in highp vec3 vs_TEXCOORD2;
in highp vec3 vs_TEXCOORD3;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp float u_xlat10_1;
vec4 u_xlat2;
lowp float u_xlat10_2;
vec4 u_xlat3;
vec4 u_xlat4;
vec4 u_xlat5;
vec4 u_xlat6;
float u_xlat7;
mediump float u_xlat16_7;
lowp float u_xlat10_8;
float u_xlat14;
lowp float u_xlat10_14;
vec2 u_xlat15;
lowp float u_xlat10_15;
lowp float u_xlat10_21;
lowp float u_xlat10_22;
void main()
{
    u_xlat0.x = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat7 = _ZBufferParams.x * u_xlat0.x + _ZBufferParams.y;
    u_xlat7 = float(1.0) / u_xlat7;
    u_xlat14 = (-u_xlat7) + u_xlat0.x;
    u_xlat7 = unity_OrthoParams.w * u_xlat14 + u_xlat7;
    u_xlat1.xyz = (-vs_TEXCOORD2.xyz) + vs_TEXCOORD3.xyz;
    u_xlat0.xzw = u_xlat0.xxx * u_xlat1.xyz + vs_TEXCOORD2.xyz;
    u_xlat0.xzw = (-vs_TEXCOORD1.xyz) * vec3(u_xlat7) + u_xlat0.xzw;
    u_xlat1.xyz = vec3(u_xlat7) * vs_TEXCOORD1.xyz;
    u_xlat0.xyz = unity_OrthoParams.www * u_xlat0.xzw + u_xlat1.xyz;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat1.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[3].xyz * u_xlat0.www + u_xlat0.xyz;
    u_xlat1.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + vec2(0.5, 0.5);
    u_xlat1.xy = floor(u_xlat1.xy);
    u_xlat0.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + (-u_xlat1.xy);
    u_xlat15.xy = min(u_xlat0.xy, vec2(0.0, 0.0));
    u_xlat2.xy = (-u_xlat0.xy) + vec2(1.0, 1.0);
    u_xlat15.xy = (-u_xlat15.xy) * u_xlat15.xy + u_xlat2.xy;
    u_xlat2.xy = u_xlat2.xy * vec2(0.159999996, 0.159999996);
    u_xlat15.xy = u_xlat15.xy + vec2(1.0, 1.0);
    u_xlat3.xy = u_xlat15.xy * vec2(0.159999996, 0.159999996);
    u_xlat15.xy = max(u_xlat0.xy, vec2(0.0, 0.0));
    u_xlat4 = u_xlat0.xxyy + vec4(0.5, 1.0, 0.5, 1.0);
    u_xlat15.xy = (-u_xlat15.xy) * u_xlat15.xy + u_xlat4.yw;
    u_xlat15.xy = u_xlat15.xy + vec2(1.0, 1.0);
    u_xlat5.xy = u_xlat15.xy * vec2(0.159999996, 0.159999996);
    u_xlat6 = u_xlat4.xxzz * u_xlat4.xxzz;
    u_xlat15.xy = vec2(u_xlat4.y * float(0.159999996), u_xlat4.w * float(0.159999996));
    u_xlat0.xy = u_xlat6.xz * vec2(0.5, 0.5) + (-u_xlat0.xy);
    u_xlat2.zw = vec2(u_xlat6.w * float(0.0799999982), u_xlat6.y * float(0.0799999982));
    u_xlat4.xy = u_xlat0.xy * vec2(0.159999996, 0.159999996);
    u_xlat3.z = u_xlat4.y;
    u_xlat3.w = u_xlat15.y;
    u_xlat4.w = u_xlat15.x;
    u_xlat5.zw = u_xlat2.yz;
    u_xlat0.xyw = vec3(u_xlat3.z + u_xlat5.z, u_xlat3.y + u_xlat5.y, u_xlat3.w + u_xlat5.w);
    u_xlat4.z = u_xlat3.x;
    u_xlat3.xyz = vec3(u_xlat5.z / u_xlat0.x, u_xlat5.y / u_xlat0.y, u_xlat5.w / u_xlat0.w);
    u_xlat2.z = u_xlat5.x;
    u_xlat3.xyz = u_xlat3.xyz + vec3(-2.5, -0.5, 1.5);
    u_xlat3.xyz = u_xlat3.xyz * _ShadowMapTexture_TexelSize.yyy;
    u_xlat5.w = u_xlat3.x;
    u_xlat4 = u_xlat2.zwxz + u_xlat4.zwxz;
    u_xlat2.xyz = vec3(u_xlat2.x / u_xlat4.z, u_xlat2.z / u_xlat4.w, u_xlat2.w / u_xlat4.y);
    u_xlat2.xyz = u_xlat2.xyz + vec3(-2.5, -0.5, 1.5);
    u_xlat5.xyz = u_xlat2.yxz * _ShadowMapTexture_TexelSize.xxx;
    u_xlat2 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.ywxw;
    u_xlat15.xy = u_xlat1.xy * _ShadowMapTexture_TexelSize.xy + u_xlat5.zw;
    vec3 txVec0 = vec3(u_xlat15.xy,u_xlat0.z);
    u_xlat10_15 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    vec3 txVec1 = vec3(u_xlat2.xy,u_xlat0.z);
    u_xlat10_22 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec1, 0.0);
    vec3 txVec2 = vec3(u_xlat2.zw,u_xlat0.z);
    u_xlat10_2 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec2, 0.0);
    u_xlat6 = vec4(u_xlat0.x * u_xlat4.z, u_xlat0.x * u_xlat4.w, u_xlat0.x * u_xlat4.y, u_xlat0.y * u_xlat4.z);
    u_xlat0.x = u_xlat10_2 * u_xlat6.y;
    u_xlat0.x = u_xlat6.x * u_xlat10_22 + u_xlat0.x;
    u_xlat0.x = u_xlat6.z * u_xlat10_15 + u_xlat0.x;
    u_xlat3.w = u_xlat5.y;
    u_xlat2 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat3.wywz;
    u_xlat5.yw = u_xlat3.yz;
    vec3 txVec3 = vec3(u_xlat2.xy,u_xlat0.z);
    u_xlat10_15 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec3, 0.0);
    vec3 txVec4 = vec3(u_xlat2.zw,u_xlat0.z);
    u_xlat10_22 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec4, 0.0);
    u_xlat0.x = u_xlat6.w * u_xlat10_15 + u_xlat0.x;
    u_xlat2 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xyzy;
    u_xlat3 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xwzw;
    vec3 txVec5 = vec3(u_xlat2.xy,u_xlat0.z);
    u_xlat10_1 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec5, 0.0);
    vec3 txVec6 = vec3(u_xlat2.zw,u_xlat0.z);
    u_xlat10_8 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec6, 0.0);
    u_xlat2 = vec4(u_xlat0.y * u_xlat4.x, u_xlat0.y * u_xlat4.y, u_xlat0.w * u_xlat4.z, u_xlat0.w * u_xlat4.w);
    u_xlat7 = u_xlat0.w * u_xlat4.y;
    u_xlat0.x = u_xlat2.x * u_xlat10_1 + u_xlat0.x;
    u_xlat0.x = u_xlat2.y * u_xlat10_8 + u_xlat0.x;
    u_xlat0.x = u_xlat2.z * u_xlat10_22 + u_xlat0.x;
    vec3 txVec7 = vec3(u_xlat3.xy,u_xlat0.z);
    u_xlat10_21 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec7, 0.0);
    vec3 txVec8 = vec3(u_xlat3.zw,u_xlat0.z);
    u_xlat10_14 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec8, 0.0);
    u_xlat0.x = u_xlat2.w * u_xlat10_21 + u_xlat0.x;
    u_xlat0.x = u_xlat7 * u_xlat10_14 + u_xlat0.x;
    u_xlat16_7 = (-_LightShadowData.x) + 1.0;
    u_xlat0 = u_xlat0.xxxx * vec4(u_xlat16_7) + _LightShadowData.xxxx;
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
SubProgram "gles hw_tier00 " {
Keywords { "SHADOWS_SPLIT_SPHERES" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "SHADOWS_SPLIT_SPHERES" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "SHADOWS_SPLIT_SPHERES" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SHADOWS_SPLIT_SPHERES" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SHADOWS_SPLIT_SPHERES" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SHADOWS_SPLIT_SPHERES" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "SHADOWS_SINGLE_CASCADE" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "SHADOWS_SINGLE_CASCADE" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "SHADOWS_SINGLE_CASCADE" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SHADOWS_SINGLE_CASCADE" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SHADOWS_SINGLE_CASCADE" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SHADOWS_SINGLE_CASCADE" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" }
""
}
}
}
}
SubShader {
 Tags { "ShadowmapFilter" = "PCF_SOFT_FORCE_INV_PROJECTION_IN_PS" }
 Pass {
  Tags { "ShadowmapFilter" = "PCF_SOFT_FORCE_INV_PROJECTION_IN_PS" }
  ZTest Always
  ZWrite Off
  Cull Off
  GpuProgramID 203599
Program "vp" {
SubProgram "gles hw_tier00 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec3 orthoPosFar_1;
  highp vec3 orthoPosNear_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _glesVertex.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  clipPos_3.xzw = tmpvar_5.xzw;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 o_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_5.zw;
  tmpvar_4.zw = o_7.xy;
  clipPos_3.y = (tmpvar_5.y * _ProjectionParams.x);
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(-1.0, 1.0);
  tmpvar_10.xy = clipPos_3.xy;
  highp vec3 tmpvar_11;
  tmpvar_11 = (unity_CameraInvProjection * tmpvar_10).xyz;
  orthoPosNear_2.xy = tmpvar_11.xy;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(1.0, 1.0);
  tmpvar_12.xy = clipPos_3.xy;
  highp vec3 tmpvar_13;
  tmpvar_13 = (unity_CameraInvProjection * tmpvar_12).xyz;
  orthoPosFar_1.xy = tmpvar_13.xy;
  orthoPosNear_2.z = -(tmpvar_11.z);
  orthoPosFar_1.z = -(tmpvar_13.z);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = _glesMultiTexCoord1.xyz;
  xlv_TEXCOORD2 = orthoPosNear_2;
  xlv_TEXCOORD3 = orthoPosFar_1;
}


#endif
#ifdef FRAGMENT
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec4 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 camPos_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xy = xlv_TEXCOORD0.zw;
  tmpvar_4.z = texture2D (_CameraDepthTexture, xlv_TEXCOORD0.xy).x;
  clipPos_3.w = tmpvar_4.w;
  clipPos_3.xyz = ((2.0 * tmpvar_4.xyz) - 1.0);
  highp vec4 tmpvar_5;
  tmpvar_5 = (unity_CameraInvProjection * clipPos_3);
  camPos_2.w = tmpvar_5.w;
  camPos_2.xyz = (tmpvar_5.xyz / tmpvar_5.w);
  camPos_2.z = -(camPos_2.z);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = camPos_2.xyz;
  highp vec4 tmpvar_7;
  tmpvar_7 = (unity_CameraToWorld * tmpvar_6);
  bvec4 tmpvar_8;
  tmpvar_8 = greaterThanEqual (camPos_2.zzzz, _LightSplitsNear);
  bvec4 tmpvar_9;
  tmpvar_9 = lessThan (camPos_2.zzzz, _LightSplitsFar);
  lowp vec4 tmpvar_10;
  tmpvar_10 = (vec4(tmpvar_8) * vec4(tmpvar_9));
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = (((
    ((unity_WorldToShadow[0] * tmpvar_7).xyz * tmpvar_10.x)
   + 
    ((unity_WorldToShadow[1] * tmpvar_7).xyz * tmpvar_10.y)
  ) + (
    (unity_WorldToShadow[2] * tmpvar_7)
  .xyz * tmpvar_10.z)) + ((unity_WorldToShadow[3] * tmpvar_7).xyz * tmpvar_10.w));
  mediump float shadow_12;
  highp vec2 tmpvar_13;
  tmpvar_13 = _ShadowMapTexture_TexelSize.xy;
  shadow_12 = 0.0;
  highp vec3 tmpvar_14;
  tmpvar_14.xy = (tmpvar_11.xy - _ShadowMapTexture_TexelSize.xy);
  tmpvar_14.z = tmpvar_11.z;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_ShadowMapTexture, tmpvar_14.xy);
  mediump float tmpvar_16;
  if ((tmpvar_15.x < tmpvar_11.z)) {
    tmpvar_16 = 0.0;
  } else {
    tmpvar_16 = 1.0;
  };
  shadow_12 = tmpvar_16;
  highp vec2 tmpvar_17;
  tmpvar_17.x = 0.0;
  tmpvar_17.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_18;
  tmpvar_18.xy = (tmpvar_11.xy + tmpvar_17);
  tmpvar_18.z = tmpvar_11.z;
  highp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_ShadowMapTexture, tmpvar_18.xy);
  highp float tmpvar_20;
  if ((tmpvar_19.x < tmpvar_11.z)) {
    tmpvar_20 = 0.0;
  } else {
    tmpvar_20 = 1.0;
  };
  shadow_12 = (tmpvar_16 + tmpvar_20);
  highp vec2 tmpvar_21;
  tmpvar_21.x = tmpvar_13.x;
  tmpvar_21.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_22;
  tmpvar_22.xy = (tmpvar_11.xy + tmpvar_21);
  tmpvar_22.z = tmpvar_11.z;
  highp vec4 tmpvar_23;
  tmpvar_23 = texture2D (_ShadowMapTexture, tmpvar_22.xy);
  highp float tmpvar_24;
  if ((tmpvar_23.x < tmpvar_11.z)) {
    tmpvar_24 = 0.0;
  } else {
    tmpvar_24 = 1.0;
  };
  shadow_12 = (shadow_12 + tmpvar_24);
  highp vec2 tmpvar_25;
  tmpvar_25.y = 0.0;
  tmpvar_25.x = -(_ShadowMapTexture_TexelSize.x);
  highp vec3 tmpvar_26;
  tmpvar_26.xy = (tmpvar_11.xy + tmpvar_25);
  tmpvar_26.z = tmpvar_11.z;
  highp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_ShadowMapTexture, tmpvar_26.xy);
  highp float tmpvar_28;
  if ((tmpvar_27.x < tmpvar_11.z)) {
    tmpvar_28 = 0.0;
  } else {
    tmpvar_28 = 1.0;
  };
  shadow_12 = (shadow_12 + tmpvar_28);
  highp vec4 tmpvar_29;
  tmpvar_29 = texture2D (_ShadowMapTexture, tmpvar_11.xy);
  highp float tmpvar_30;
  if ((tmpvar_29.x < tmpvar_11.z)) {
    tmpvar_30 = 0.0;
  } else {
    tmpvar_30 = 1.0;
  };
  shadow_12 = (shadow_12 + tmpvar_30);
  highp vec2 tmpvar_31;
  tmpvar_31.y = 0.0;
  tmpvar_31.x = tmpvar_13.x;
  highp vec3 tmpvar_32;
  tmpvar_32.xy = (tmpvar_11.xy + tmpvar_31);
  tmpvar_32.z = tmpvar_11.z;
  highp vec4 tmpvar_33;
  tmpvar_33 = texture2D (_ShadowMapTexture, tmpvar_32.xy);
  highp float tmpvar_34;
  if ((tmpvar_33.x < tmpvar_11.z)) {
    tmpvar_34 = 0.0;
  } else {
    tmpvar_34 = 1.0;
  };
  shadow_12 = (shadow_12 + tmpvar_34);
  highp vec2 tmpvar_35;
  tmpvar_35.x = -(_ShadowMapTexture_TexelSize.x);
  tmpvar_35.y = tmpvar_13.y;
  highp vec3 tmpvar_36;
  tmpvar_36.xy = (tmpvar_11.xy + tmpvar_35);
  tmpvar_36.z = tmpvar_11.z;
  highp vec4 tmpvar_37;
  tmpvar_37 = texture2D (_ShadowMapTexture, tmpvar_36.xy);
  highp float tmpvar_38;
  if ((tmpvar_37.x < tmpvar_11.z)) {
    tmpvar_38 = 0.0;
  } else {
    tmpvar_38 = 1.0;
  };
  shadow_12 = (shadow_12 + tmpvar_38);
  highp vec2 tmpvar_39;
  tmpvar_39.x = 0.0;
  tmpvar_39.y = tmpvar_13.y;
  highp vec3 tmpvar_40;
  tmpvar_40.xy = (tmpvar_11.xy + tmpvar_39);
  tmpvar_40.z = tmpvar_11.z;
  highp vec4 tmpvar_41;
  tmpvar_41 = texture2D (_ShadowMapTexture, tmpvar_40.xy);
  highp float tmpvar_42;
  if ((tmpvar_41.x < tmpvar_11.z)) {
    tmpvar_42 = 0.0;
  } else {
    tmpvar_42 = 1.0;
  };
  shadow_12 = (shadow_12 + tmpvar_42);
  highp vec3 tmpvar_43;
  tmpvar_43.xy = (tmpvar_11.xy + _ShadowMapTexture_TexelSize.xy);
  tmpvar_43.z = tmpvar_11.z;
  highp vec4 tmpvar_44;
  tmpvar_44 = texture2D (_ShadowMapTexture, tmpvar_43.xy);
  highp float tmpvar_45;
  if ((tmpvar_44.x < tmpvar_11.z)) {
    tmpvar_45 = 0.0;
  } else {
    tmpvar_45 = 1.0;
  };
  shadow_12 = (shadow_12 + tmpvar_45);
  shadow_12 = (shadow_12 / 9.0);
  mediump vec4 tmpvar_46;
  tmpvar_46 = vec4(mix (_LightShadowData.x, 1.0, shadow_12));
  tmpvar_1 = tmpvar_46;
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
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec3 orthoPosFar_1;
  highp vec3 orthoPosNear_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _glesVertex.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  clipPos_3.xzw = tmpvar_5.xzw;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 o_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_5.zw;
  tmpvar_4.zw = o_7.xy;
  clipPos_3.y = (tmpvar_5.y * _ProjectionParams.x);
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(-1.0, 1.0);
  tmpvar_10.xy = clipPos_3.xy;
  highp vec3 tmpvar_11;
  tmpvar_11 = (unity_CameraInvProjection * tmpvar_10).xyz;
  orthoPosNear_2.xy = tmpvar_11.xy;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(1.0, 1.0);
  tmpvar_12.xy = clipPos_3.xy;
  highp vec3 tmpvar_13;
  tmpvar_13 = (unity_CameraInvProjection * tmpvar_12).xyz;
  orthoPosFar_1.xy = tmpvar_13.xy;
  orthoPosNear_2.z = -(tmpvar_11.z);
  orthoPosFar_1.z = -(tmpvar_13.z);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = _glesMultiTexCoord1.xyz;
  xlv_TEXCOORD2 = orthoPosNear_2;
  xlv_TEXCOORD3 = orthoPosFar_1;
}


#endif
#ifdef FRAGMENT
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec4 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 camPos_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xy = xlv_TEXCOORD0.zw;
  tmpvar_4.z = texture2D (_CameraDepthTexture, xlv_TEXCOORD0.xy).x;
  clipPos_3.w = tmpvar_4.w;
  clipPos_3.xyz = ((2.0 * tmpvar_4.xyz) - 1.0);
  highp vec4 tmpvar_5;
  tmpvar_5 = (unity_CameraInvProjection * clipPos_3);
  camPos_2.w = tmpvar_5.w;
  camPos_2.xyz = (tmpvar_5.xyz / tmpvar_5.w);
  camPos_2.z = -(camPos_2.z);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = camPos_2.xyz;
  highp vec4 tmpvar_7;
  tmpvar_7 = (unity_CameraToWorld * tmpvar_6);
  bvec4 tmpvar_8;
  tmpvar_8 = greaterThanEqual (camPos_2.zzzz, _LightSplitsNear);
  bvec4 tmpvar_9;
  tmpvar_9 = lessThan (camPos_2.zzzz, _LightSplitsFar);
  lowp vec4 tmpvar_10;
  tmpvar_10 = (vec4(tmpvar_8) * vec4(tmpvar_9));
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = (((
    ((unity_WorldToShadow[0] * tmpvar_7).xyz * tmpvar_10.x)
   + 
    ((unity_WorldToShadow[1] * tmpvar_7).xyz * tmpvar_10.y)
  ) + (
    (unity_WorldToShadow[2] * tmpvar_7)
  .xyz * tmpvar_10.z)) + ((unity_WorldToShadow[3] * tmpvar_7).xyz * tmpvar_10.w));
  mediump float shadow_12;
  highp vec2 tmpvar_13;
  tmpvar_13 = _ShadowMapTexture_TexelSize.xy;
  shadow_12 = 0.0;
  highp vec3 tmpvar_14;
  tmpvar_14.xy = (tmpvar_11.xy - _ShadowMapTexture_TexelSize.xy);
  tmpvar_14.z = tmpvar_11.z;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_ShadowMapTexture, tmpvar_14.xy);
  mediump float tmpvar_16;
  if ((tmpvar_15.x < tmpvar_11.z)) {
    tmpvar_16 = 0.0;
  } else {
    tmpvar_16 = 1.0;
  };
  shadow_12 = tmpvar_16;
  highp vec2 tmpvar_17;
  tmpvar_17.x = 0.0;
  tmpvar_17.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_18;
  tmpvar_18.xy = (tmpvar_11.xy + tmpvar_17);
  tmpvar_18.z = tmpvar_11.z;
  highp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_ShadowMapTexture, tmpvar_18.xy);
  highp float tmpvar_20;
  if ((tmpvar_19.x < tmpvar_11.z)) {
    tmpvar_20 = 0.0;
  } else {
    tmpvar_20 = 1.0;
  };
  shadow_12 = (tmpvar_16 + tmpvar_20);
  highp vec2 tmpvar_21;
  tmpvar_21.x = tmpvar_13.x;
  tmpvar_21.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_22;
  tmpvar_22.xy = (tmpvar_11.xy + tmpvar_21);
  tmpvar_22.z = tmpvar_11.z;
  highp vec4 tmpvar_23;
  tmpvar_23 = texture2D (_ShadowMapTexture, tmpvar_22.xy);
  highp float tmpvar_24;
  if ((tmpvar_23.x < tmpvar_11.z)) {
    tmpvar_24 = 0.0;
  } else {
    tmpvar_24 = 1.0;
  };
  shadow_12 = (shadow_12 + tmpvar_24);
  highp vec2 tmpvar_25;
  tmpvar_25.y = 0.0;
  tmpvar_25.x = -(_ShadowMapTexture_TexelSize.x);
  highp vec3 tmpvar_26;
  tmpvar_26.xy = (tmpvar_11.xy + tmpvar_25);
  tmpvar_26.z = tmpvar_11.z;
  highp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_ShadowMapTexture, tmpvar_26.xy);
  highp float tmpvar_28;
  if ((tmpvar_27.x < tmpvar_11.z)) {
    tmpvar_28 = 0.0;
  } else {
    tmpvar_28 = 1.0;
  };
  shadow_12 = (shadow_12 + tmpvar_28);
  highp vec4 tmpvar_29;
  tmpvar_29 = texture2D (_ShadowMapTexture, tmpvar_11.xy);
  highp float tmpvar_30;
  if ((tmpvar_29.x < tmpvar_11.z)) {
    tmpvar_30 = 0.0;
  } else {
    tmpvar_30 = 1.0;
  };
  shadow_12 = (shadow_12 + tmpvar_30);
  highp vec2 tmpvar_31;
  tmpvar_31.y = 0.0;
  tmpvar_31.x = tmpvar_13.x;
  highp vec3 tmpvar_32;
  tmpvar_32.xy = (tmpvar_11.xy + tmpvar_31);
  tmpvar_32.z = tmpvar_11.z;
  highp vec4 tmpvar_33;
  tmpvar_33 = texture2D (_ShadowMapTexture, tmpvar_32.xy);
  highp float tmpvar_34;
  if ((tmpvar_33.x < tmpvar_11.z)) {
    tmpvar_34 = 0.0;
  } else {
    tmpvar_34 = 1.0;
  };
  shadow_12 = (shadow_12 + tmpvar_34);
  highp vec2 tmpvar_35;
  tmpvar_35.x = -(_ShadowMapTexture_TexelSize.x);
  tmpvar_35.y = tmpvar_13.y;
  highp vec3 tmpvar_36;
  tmpvar_36.xy = (tmpvar_11.xy + tmpvar_35);
  tmpvar_36.z = tmpvar_11.z;
  highp vec4 tmpvar_37;
  tmpvar_37 = texture2D (_ShadowMapTexture, tmpvar_36.xy);
  highp float tmpvar_38;
  if ((tmpvar_37.x < tmpvar_11.z)) {
    tmpvar_38 = 0.0;
  } else {
    tmpvar_38 = 1.0;
  };
  shadow_12 = (shadow_12 + tmpvar_38);
  highp vec2 tmpvar_39;
  tmpvar_39.x = 0.0;
  tmpvar_39.y = tmpvar_13.y;
  highp vec3 tmpvar_40;
  tmpvar_40.xy = (tmpvar_11.xy + tmpvar_39);
  tmpvar_40.z = tmpvar_11.z;
  highp vec4 tmpvar_41;
  tmpvar_41 = texture2D (_ShadowMapTexture, tmpvar_40.xy);
  highp float tmpvar_42;
  if ((tmpvar_41.x < tmpvar_11.z)) {
    tmpvar_42 = 0.0;
  } else {
    tmpvar_42 = 1.0;
  };
  shadow_12 = (shadow_12 + tmpvar_42);
  highp vec3 tmpvar_43;
  tmpvar_43.xy = (tmpvar_11.xy + _ShadowMapTexture_TexelSize.xy);
  tmpvar_43.z = tmpvar_11.z;
  highp vec4 tmpvar_44;
  tmpvar_44 = texture2D (_ShadowMapTexture, tmpvar_43.xy);
  highp float tmpvar_45;
  if ((tmpvar_44.x < tmpvar_11.z)) {
    tmpvar_45 = 0.0;
  } else {
    tmpvar_45 = 1.0;
  };
  shadow_12 = (shadow_12 + tmpvar_45);
  shadow_12 = (shadow_12 / 9.0);
  mediump vec4 tmpvar_46;
  tmpvar_46 = vec4(mix (_LightShadowData.x, 1.0, shadow_12));
  tmpvar_1 = tmpvar_46;
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
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec3 orthoPosFar_1;
  highp vec3 orthoPosNear_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _glesVertex.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  clipPos_3.xzw = tmpvar_5.xzw;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 o_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_5.zw;
  tmpvar_4.zw = o_7.xy;
  clipPos_3.y = (tmpvar_5.y * _ProjectionParams.x);
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(-1.0, 1.0);
  tmpvar_10.xy = clipPos_3.xy;
  highp vec3 tmpvar_11;
  tmpvar_11 = (unity_CameraInvProjection * tmpvar_10).xyz;
  orthoPosNear_2.xy = tmpvar_11.xy;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(1.0, 1.0);
  tmpvar_12.xy = clipPos_3.xy;
  highp vec3 tmpvar_13;
  tmpvar_13 = (unity_CameraInvProjection * tmpvar_12).xyz;
  orthoPosFar_1.xy = tmpvar_13.xy;
  orthoPosNear_2.z = -(tmpvar_11.z);
  orthoPosFar_1.z = -(tmpvar_13.z);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = _glesMultiTexCoord1.xyz;
  xlv_TEXCOORD2 = orthoPosNear_2;
  xlv_TEXCOORD3 = orthoPosFar_1;
}


#endif
#ifdef FRAGMENT
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightSplitsNear;
uniform highp vec4 _LightSplitsFar;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec4 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 camPos_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xy = xlv_TEXCOORD0.zw;
  tmpvar_4.z = texture2D (_CameraDepthTexture, xlv_TEXCOORD0.xy).x;
  clipPos_3.w = tmpvar_4.w;
  clipPos_3.xyz = ((2.0 * tmpvar_4.xyz) - 1.0);
  highp vec4 tmpvar_5;
  tmpvar_5 = (unity_CameraInvProjection * clipPos_3);
  camPos_2.w = tmpvar_5.w;
  camPos_2.xyz = (tmpvar_5.xyz / tmpvar_5.w);
  camPos_2.z = -(camPos_2.z);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = camPos_2.xyz;
  highp vec4 tmpvar_7;
  tmpvar_7 = (unity_CameraToWorld * tmpvar_6);
  bvec4 tmpvar_8;
  tmpvar_8 = greaterThanEqual (camPos_2.zzzz, _LightSplitsNear);
  bvec4 tmpvar_9;
  tmpvar_9 = lessThan (camPos_2.zzzz, _LightSplitsFar);
  lowp vec4 tmpvar_10;
  tmpvar_10 = (vec4(tmpvar_8) * vec4(tmpvar_9));
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = (((
    ((unity_WorldToShadow[0] * tmpvar_7).xyz * tmpvar_10.x)
   + 
    ((unity_WorldToShadow[1] * tmpvar_7).xyz * tmpvar_10.y)
  ) + (
    (unity_WorldToShadow[2] * tmpvar_7)
  .xyz * tmpvar_10.z)) + ((unity_WorldToShadow[3] * tmpvar_7).xyz * tmpvar_10.w));
  mediump float shadow_12;
  highp vec2 tmpvar_13;
  tmpvar_13 = _ShadowMapTexture_TexelSize.xy;
  shadow_12 = 0.0;
  highp vec3 tmpvar_14;
  tmpvar_14.xy = (tmpvar_11.xy - _ShadowMapTexture_TexelSize.xy);
  tmpvar_14.z = tmpvar_11.z;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_ShadowMapTexture, tmpvar_14.xy);
  mediump float tmpvar_16;
  if ((tmpvar_15.x < tmpvar_11.z)) {
    tmpvar_16 = 0.0;
  } else {
    tmpvar_16 = 1.0;
  };
  shadow_12 = tmpvar_16;
  highp vec2 tmpvar_17;
  tmpvar_17.x = 0.0;
  tmpvar_17.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_18;
  tmpvar_18.xy = (tmpvar_11.xy + tmpvar_17);
  tmpvar_18.z = tmpvar_11.z;
  highp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_ShadowMapTexture, tmpvar_18.xy);
  highp float tmpvar_20;
  if ((tmpvar_19.x < tmpvar_11.z)) {
    tmpvar_20 = 0.0;
  } else {
    tmpvar_20 = 1.0;
  };
  shadow_12 = (tmpvar_16 + tmpvar_20);
  highp vec2 tmpvar_21;
  tmpvar_21.x = tmpvar_13.x;
  tmpvar_21.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_22;
  tmpvar_22.xy = (tmpvar_11.xy + tmpvar_21);
  tmpvar_22.z = tmpvar_11.z;
  highp vec4 tmpvar_23;
  tmpvar_23 = texture2D (_ShadowMapTexture, tmpvar_22.xy);
  highp float tmpvar_24;
  if ((tmpvar_23.x < tmpvar_11.z)) {
    tmpvar_24 = 0.0;
  } else {
    tmpvar_24 = 1.0;
  };
  shadow_12 = (shadow_12 + tmpvar_24);
  highp vec2 tmpvar_25;
  tmpvar_25.y = 0.0;
  tmpvar_25.x = -(_ShadowMapTexture_TexelSize.x);
  highp vec3 tmpvar_26;
  tmpvar_26.xy = (tmpvar_11.xy + tmpvar_25);
  tmpvar_26.z = tmpvar_11.z;
  highp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_ShadowMapTexture, tmpvar_26.xy);
  highp float tmpvar_28;
  if ((tmpvar_27.x < tmpvar_11.z)) {
    tmpvar_28 = 0.0;
  } else {
    tmpvar_28 = 1.0;
  };
  shadow_12 = (shadow_12 + tmpvar_28);
  highp vec4 tmpvar_29;
  tmpvar_29 = texture2D (_ShadowMapTexture, tmpvar_11.xy);
  highp float tmpvar_30;
  if ((tmpvar_29.x < tmpvar_11.z)) {
    tmpvar_30 = 0.0;
  } else {
    tmpvar_30 = 1.0;
  };
  shadow_12 = (shadow_12 + tmpvar_30);
  highp vec2 tmpvar_31;
  tmpvar_31.y = 0.0;
  tmpvar_31.x = tmpvar_13.x;
  highp vec3 tmpvar_32;
  tmpvar_32.xy = (tmpvar_11.xy + tmpvar_31);
  tmpvar_32.z = tmpvar_11.z;
  highp vec4 tmpvar_33;
  tmpvar_33 = texture2D (_ShadowMapTexture, tmpvar_32.xy);
  highp float tmpvar_34;
  if ((tmpvar_33.x < tmpvar_11.z)) {
    tmpvar_34 = 0.0;
  } else {
    tmpvar_34 = 1.0;
  };
  shadow_12 = (shadow_12 + tmpvar_34);
  highp vec2 tmpvar_35;
  tmpvar_35.x = -(_ShadowMapTexture_TexelSize.x);
  tmpvar_35.y = tmpvar_13.y;
  highp vec3 tmpvar_36;
  tmpvar_36.xy = (tmpvar_11.xy + tmpvar_35);
  tmpvar_36.z = tmpvar_11.z;
  highp vec4 tmpvar_37;
  tmpvar_37 = texture2D (_ShadowMapTexture, tmpvar_36.xy);
  highp float tmpvar_38;
  if ((tmpvar_37.x < tmpvar_11.z)) {
    tmpvar_38 = 0.0;
  } else {
    tmpvar_38 = 1.0;
  };
  shadow_12 = (shadow_12 + tmpvar_38);
  highp vec2 tmpvar_39;
  tmpvar_39.x = 0.0;
  tmpvar_39.y = tmpvar_13.y;
  highp vec3 tmpvar_40;
  tmpvar_40.xy = (tmpvar_11.xy + tmpvar_39);
  tmpvar_40.z = tmpvar_11.z;
  highp vec4 tmpvar_41;
  tmpvar_41 = texture2D (_ShadowMapTexture, tmpvar_40.xy);
  highp float tmpvar_42;
  if ((tmpvar_41.x < tmpvar_11.z)) {
    tmpvar_42 = 0.0;
  } else {
    tmpvar_42 = 1.0;
  };
  shadow_12 = (shadow_12 + tmpvar_42);
  highp vec3 tmpvar_43;
  tmpvar_43.xy = (tmpvar_11.xy + _ShadowMapTexture_TexelSize.xy);
  tmpvar_43.z = tmpvar_11.z;
  highp vec4 tmpvar_44;
  tmpvar_44 = texture2D (_ShadowMapTexture, tmpvar_43.xy);
  highp float tmpvar_45;
  if ((tmpvar_44.x < tmpvar_11.z)) {
    tmpvar_45 = 0.0;
  } else {
    tmpvar_45 = 1.0;
  };
  shadow_12 = (shadow_12 + tmpvar_45);
  shadow_12 = (shadow_12 / 9.0);
  mediump vec4 tmpvar_46;
  tmpvar_46 = vec4(mix (_LightShadowData.x, 1.0, shadow_12));
  tmpvar_1 = tmpvar_46;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
in highp vec3 in_TEXCOORD1;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
out highp vec3 vs_TEXCOORD2;
out highp vec3 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
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
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraInvProjection[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraInvProjection[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    vs_TEXCOORD0.zw = u_xlat1.zz + u_xlat1.xw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    vs_TEXCOORD1.xyz = in_TEXCOORD1.xyz;
    u_xlat1.xyz = u_xlat0.xyz + (-hlslcc_mtx4x4unity_CameraInvProjection[2].xyz);
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[2].xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.w = (-u_xlat1.z);
    vs_TEXCOORD2.xyz = u_xlat1.xyw;
    u_xlat0.w = (-u_xlat0.z);
    vs_TEXCOORD3.xyz = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 _LightSplitsNear;
uniform 	vec4 _LightSplitsFar;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
mediump vec4 u_xlat16_1;
bvec4 u_xlatb1;
vec4 u_xlat2;
lowp float u_xlat10_2;
bvec4 u_xlatb2;
vec4 u_xlat3;
lowp float u_xlat10_3;
vec4 u_xlat4;
vec4 u_xlat5;
vec4 u_xlat6;
float u_xlat7;
mediump float u_xlat16_7;
lowp float u_xlat10_9;
lowp float u_xlat10_14;
vec2 u_xlat16;
lowp float u_xlat10_16;
lowp float u_xlat10_21;
lowp float u_xlat10_23;
void main()
{
    u_xlat0.z = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat0.xy = vs_TEXCOORD0.zw;
    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraInvProjection[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraInvProjection[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraInvProjection[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraInvProjection[3];
    u_xlat0.xyz = u_xlat0.xyz / u_xlat0.www;
    u_xlatb1 = greaterThanEqual((-u_xlat0.zzzz), _LightSplitsNear);
    u_xlat1 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb1));
    u_xlatb2 = lessThan((-u_xlat0.zzzz), _LightSplitsFar);
    u_xlat2 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb2));
    u_xlat16_1 = u_xlat1 * u_xlat2;
    u_xlat2 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat2 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat2;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * (-u_xlat0.zzzz) + u_xlat2;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[5].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[4].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[6].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[7].xyz * u_xlat0.www + u_xlat2.xyz;
    u_xlat2.xyz = u_xlat16_1.yyy * u_xlat2.xyz;
    u_xlat3.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * u_xlat0.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * u_xlat0.zzz + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[3].xyz * u_xlat0.www + u_xlat3.xyz;
    u_xlat2.xyz = u_xlat3.xyz * u_xlat16_1.xxx + u_xlat2.xyz;
    u_xlat3.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[9].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[8].xyz * u_xlat0.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[10].xyz * u_xlat0.zzz + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[11].xyz * u_xlat0.www + u_xlat3.xyz;
    u_xlat2.xyz = u_xlat3.xyz * u_xlat16_1.zzz + u_xlat2.xyz;
    u_xlat3.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[13].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[12].xyz * u_xlat0.xxx + u_xlat3.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[14].xyz * u_xlat0.zzz + u_xlat3.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[15].xyz * u_xlat0.www + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www + u_xlat2.xyz;
    u_xlat2.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + vec2(0.5, 0.5);
    u_xlat2.xy = floor(u_xlat2.xy);
    u_xlat0.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + (-u_xlat2.xy);
    u_xlat16.xy = min(u_xlat0.xy, vec2(0.0, 0.0));
    u_xlat3.xy = (-u_xlat0.xy) + vec2(1.0, 1.0);
    u_xlat16.xy = (-u_xlat16.xy) * u_xlat16.xy + u_xlat3.xy;
    u_xlat1.xy = u_xlat3.xy * vec2(0.159999996, 0.159999996);
    u_xlat16.xy = u_xlat16.xy + vec2(1.0, 1.0);
    u_xlat3.xy = u_xlat16.xy * vec2(0.159999996, 0.159999996);
    u_xlat16.xy = max(u_xlat0.xy, vec2(0.0, 0.0));
    u_xlat4 = u_xlat0.xxyy + vec4(0.5, 1.0, 0.5, 1.0);
    u_xlat16.xy = (-u_xlat16.xy) * u_xlat16.xy + u_xlat4.yw;
    u_xlat16.xy = u_xlat16.xy + vec2(1.0, 1.0);
    u_xlat5.xy = u_xlat16.xy * vec2(0.159999996, 0.159999996);
    u_xlat6 = u_xlat4.xxzz * u_xlat4.xxzz;
    u_xlat16.xy = vec2(u_xlat4.y * float(0.159999996), u_xlat4.w * float(0.159999996));
    u_xlat0.xy = u_xlat6.xz * vec2(0.5, 0.5) + (-u_xlat0.xy);
    u_xlat1.zw = vec2(u_xlat6.w * float(0.0799999982), u_xlat6.y * float(0.0799999982));
    u_xlat4.xy = u_xlat0.xy * vec2(0.159999996, 0.159999996);
    u_xlat3.z = u_xlat4.y;
    u_xlat3.w = u_xlat16.y;
    u_xlat4.w = u_xlat16.x;
    u_xlat5.zw = u_xlat1.yz;
    u_xlat0.xyw = vec3(u_xlat3.z + u_xlat5.z, u_xlat3.y + u_xlat5.y, u_xlat3.w + u_xlat5.w);
    u_xlat4.z = u_xlat3.x;
    u_xlat3.xyz = vec3(u_xlat5.z / u_xlat0.x, u_xlat5.y / u_xlat0.y, u_xlat5.w / u_xlat0.w);
    u_xlat1.z = u_xlat5.x;
    u_xlat3.xyz = u_xlat3.xyz + vec3(-2.5, -0.5, 1.5);
    u_xlat3.xyz = u_xlat3.xyz * _ShadowMapTexture_TexelSize.yyy;
    u_xlat5.w = u_xlat3.x;
    u_xlat4 = u_xlat1.zwxz + u_xlat4.zwxz;
    u_xlat6.xyz = vec3(u_xlat1.x / u_xlat4.z, u_xlat1.z / u_xlat4.w, u_xlat1.w / u_xlat4.y);
    u_xlat6.xyz = u_xlat6.xyz + vec3(-2.5, -0.5, 1.5);
    u_xlat5.xyz = u_xlat6.yxz * _ShadowMapTexture_TexelSize.xxx;
    u_xlat1 = u_xlat2.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.ywxw;
    u_xlat16.xy = u_xlat2.xy * _ShadowMapTexture_TexelSize.xy + u_xlat5.zw;
    vec3 txVec0 = vec3(u_xlat16.xy,u_xlat0.z);
    u_xlat10_16 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    vec3 txVec1 = vec3(u_xlat1.xy,u_xlat0.z);
    u_xlat10_23 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec1, 0.0);
    vec3 txVec2 = vec3(u_xlat1.zw,u_xlat0.z);
    u_xlat10_3 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec2, 0.0);
    u_xlat1 = vec4(u_xlat0.x * u_xlat4.z, u_xlat0.x * u_xlat4.w, u_xlat0.x * u_xlat4.y, u_xlat0.y * u_xlat4.z);
    u_xlat0.x = u_xlat10_3 * u_xlat1.y;
    u_xlat0.x = u_xlat1.x * u_xlat10_23 + u_xlat0.x;
    u_xlat0.x = u_xlat1.z * u_xlat10_16 + u_xlat0.x;
    u_xlat3.w = u_xlat5.y;
    u_xlat6 = u_xlat2.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat3.wywz;
    u_xlat5.yw = u_xlat3.yz;
    vec3 txVec3 = vec3(u_xlat6.xy,u_xlat0.z);
    u_xlat10_16 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec3, 0.0);
    vec3 txVec4 = vec3(u_xlat6.zw,u_xlat0.z);
    u_xlat10_23 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec4, 0.0);
    u_xlat0.x = u_xlat1.w * u_xlat10_16 + u_xlat0.x;
    u_xlat1 = u_xlat2.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xyzy;
    u_xlat3 = u_xlat2.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xwzw;
    vec3 txVec5 = vec3(u_xlat1.xy,u_xlat0.z);
    u_xlat10_2 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec5, 0.0);
    vec3 txVec6 = vec3(u_xlat1.zw,u_xlat0.z);
    u_xlat10_9 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec6, 0.0);
    u_xlat1 = vec4(u_xlat0.y * u_xlat4.x, u_xlat0.y * u_xlat4.y, u_xlat0.w * u_xlat4.z, u_xlat0.w * u_xlat4.w);
    u_xlat7 = u_xlat0.w * u_xlat4.y;
    u_xlat0.x = u_xlat1.x * u_xlat10_2 + u_xlat0.x;
    u_xlat0.x = u_xlat1.y * u_xlat10_9 + u_xlat0.x;
    u_xlat0.x = u_xlat1.z * u_xlat10_23 + u_xlat0.x;
    vec3 txVec7 = vec3(u_xlat3.xy,u_xlat0.z);
    u_xlat10_21 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec7, 0.0);
    vec3 txVec8 = vec3(u_xlat3.zw,u_xlat0.z);
    u_xlat10_14 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec8, 0.0);
    u_xlat0.x = u_xlat1.w * u_xlat10_21 + u_xlat0.x;
    u_xlat0.x = u_xlat7 * u_xlat10_14 + u_xlat0.x;
    u_xlat16_7 = (-_LightShadowData.x) + 1.0;
    u_xlat0 = u_xlat0.xxxx * vec4(u_xlat16_7) + _LightShadowData.xxxx;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
in highp vec3 in_TEXCOORD1;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
out highp vec3 vs_TEXCOORD2;
out highp vec3 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
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
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraInvProjection[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraInvProjection[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    vs_TEXCOORD0.zw = u_xlat1.zz + u_xlat1.xw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    vs_TEXCOORD1.xyz = in_TEXCOORD1.xyz;
    u_xlat1.xyz = u_xlat0.xyz + (-hlslcc_mtx4x4unity_CameraInvProjection[2].xyz);
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[2].xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.w = (-u_xlat1.z);
    vs_TEXCOORD2.xyz = u_xlat1.xyw;
    u_xlat0.w = (-u_xlat0.z);
    vs_TEXCOORD3.xyz = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 _LightSplitsNear;
uniform 	vec4 _LightSplitsFar;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
mediump vec4 u_xlat16_1;
bvec4 u_xlatb1;
vec4 u_xlat2;
lowp float u_xlat10_2;
bvec4 u_xlatb2;
vec4 u_xlat3;
lowp float u_xlat10_3;
vec4 u_xlat4;
vec4 u_xlat5;
vec4 u_xlat6;
float u_xlat7;
mediump float u_xlat16_7;
lowp float u_xlat10_9;
lowp float u_xlat10_14;
vec2 u_xlat16;
lowp float u_xlat10_16;
lowp float u_xlat10_21;
lowp float u_xlat10_23;
void main()
{
    u_xlat0.z = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat0.xy = vs_TEXCOORD0.zw;
    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraInvProjection[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraInvProjection[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraInvProjection[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraInvProjection[3];
    u_xlat0.xyz = u_xlat0.xyz / u_xlat0.www;
    u_xlatb1 = greaterThanEqual((-u_xlat0.zzzz), _LightSplitsNear);
    u_xlat1 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb1));
    u_xlatb2 = lessThan((-u_xlat0.zzzz), _LightSplitsFar);
    u_xlat2 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb2));
    u_xlat16_1 = u_xlat1 * u_xlat2;
    u_xlat2 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat2 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat2;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * (-u_xlat0.zzzz) + u_xlat2;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[5].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[4].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[6].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[7].xyz * u_xlat0.www + u_xlat2.xyz;
    u_xlat2.xyz = u_xlat16_1.yyy * u_xlat2.xyz;
    u_xlat3.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * u_xlat0.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * u_xlat0.zzz + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[3].xyz * u_xlat0.www + u_xlat3.xyz;
    u_xlat2.xyz = u_xlat3.xyz * u_xlat16_1.xxx + u_xlat2.xyz;
    u_xlat3.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[9].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[8].xyz * u_xlat0.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[10].xyz * u_xlat0.zzz + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[11].xyz * u_xlat0.www + u_xlat3.xyz;
    u_xlat2.xyz = u_xlat3.xyz * u_xlat16_1.zzz + u_xlat2.xyz;
    u_xlat3.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[13].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[12].xyz * u_xlat0.xxx + u_xlat3.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[14].xyz * u_xlat0.zzz + u_xlat3.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[15].xyz * u_xlat0.www + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www + u_xlat2.xyz;
    u_xlat2.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + vec2(0.5, 0.5);
    u_xlat2.xy = floor(u_xlat2.xy);
    u_xlat0.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + (-u_xlat2.xy);
    u_xlat16.xy = min(u_xlat0.xy, vec2(0.0, 0.0));
    u_xlat3.xy = (-u_xlat0.xy) + vec2(1.0, 1.0);
    u_xlat16.xy = (-u_xlat16.xy) * u_xlat16.xy + u_xlat3.xy;
    u_xlat1.xy = u_xlat3.xy * vec2(0.159999996, 0.159999996);
    u_xlat16.xy = u_xlat16.xy + vec2(1.0, 1.0);
    u_xlat3.xy = u_xlat16.xy * vec2(0.159999996, 0.159999996);
    u_xlat16.xy = max(u_xlat0.xy, vec2(0.0, 0.0));
    u_xlat4 = u_xlat0.xxyy + vec4(0.5, 1.0, 0.5, 1.0);
    u_xlat16.xy = (-u_xlat16.xy) * u_xlat16.xy + u_xlat4.yw;
    u_xlat16.xy = u_xlat16.xy + vec2(1.0, 1.0);
    u_xlat5.xy = u_xlat16.xy * vec2(0.159999996, 0.159999996);
    u_xlat6 = u_xlat4.xxzz * u_xlat4.xxzz;
    u_xlat16.xy = vec2(u_xlat4.y * float(0.159999996), u_xlat4.w * float(0.159999996));
    u_xlat0.xy = u_xlat6.xz * vec2(0.5, 0.5) + (-u_xlat0.xy);
    u_xlat1.zw = vec2(u_xlat6.w * float(0.0799999982), u_xlat6.y * float(0.0799999982));
    u_xlat4.xy = u_xlat0.xy * vec2(0.159999996, 0.159999996);
    u_xlat3.z = u_xlat4.y;
    u_xlat3.w = u_xlat16.y;
    u_xlat4.w = u_xlat16.x;
    u_xlat5.zw = u_xlat1.yz;
    u_xlat0.xyw = vec3(u_xlat3.z + u_xlat5.z, u_xlat3.y + u_xlat5.y, u_xlat3.w + u_xlat5.w);
    u_xlat4.z = u_xlat3.x;
    u_xlat3.xyz = vec3(u_xlat5.z / u_xlat0.x, u_xlat5.y / u_xlat0.y, u_xlat5.w / u_xlat0.w);
    u_xlat1.z = u_xlat5.x;
    u_xlat3.xyz = u_xlat3.xyz + vec3(-2.5, -0.5, 1.5);
    u_xlat3.xyz = u_xlat3.xyz * _ShadowMapTexture_TexelSize.yyy;
    u_xlat5.w = u_xlat3.x;
    u_xlat4 = u_xlat1.zwxz + u_xlat4.zwxz;
    u_xlat6.xyz = vec3(u_xlat1.x / u_xlat4.z, u_xlat1.z / u_xlat4.w, u_xlat1.w / u_xlat4.y);
    u_xlat6.xyz = u_xlat6.xyz + vec3(-2.5, -0.5, 1.5);
    u_xlat5.xyz = u_xlat6.yxz * _ShadowMapTexture_TexelSize.xxx;
    u_xlat1 = u_xlat2.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.ywxw;
    u_xlat16.xy = u_xlat2.xy * _ShadowMapTexture_TexelSize.xy + u_xlat5.zw;
    vec3 txVec0 = vec3(u_xlat16.xy,u_xlat0.z);
    u_xlat10_16 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    vec3 txVec1 = vec3(u_xlat1.xy,u_xlat0.z);
    u_xlat10_23 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec1, 0.0);
    vec3 txVec2 = vec3(u_xlat1.zw,u_xlat0.z);
    u_xlat10_3 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec2, 0.0);
    u_xlat1 = vec4(u_xlat0.x * u_xlat4.z, u_xlat0.x * u_xlat4.w, u_xlat0.x * u_xlat4.y, u_xlat0.y * u_xlat4.z);
    u_xlat0.x = u_xlat10_3 * u_xlat1.y;
    u_xlat0.x = u_xlat1.x * u_xlat10_23 + u_xlat0.x;
    u_xlat0.x = u_xlat1.z * u_xlat10_16 + u_xlat0.x;
    u_xlat3.w = u_xlat5.y;
    u_xlat6 = u_xlat2.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat3.wywz;
    u_xlat5.yw = u_xlat3.yz;
    vec3 txVec3 = vec3(u_xlat6.xy,u_xlat0.z);
    u_xlat10_16 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec3, 0.0);
    vec3 txVec4 = vec3(u_xlat6.zw,u_xlat0.z);
    u_xlat10_23 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec4, 0.0);
    u_xlat0.x = u_xlat1.w * u_xlat10_16 + u_xlat0.x;
    u_xlat1 = u_xlat2.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xyzy;
    u_xlat3 = u_xlat2.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xwzw;
    vec3 txVec5 = vec3(u_xlat1.xy,u_xlat0.z);
    u_xlat10_2 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec5, 0.0);
    vec3 txVec6 = vec3(u_xlat1.zw,u_xlat0.z);
    u_xlat10_9 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec6, 0.0);
    u_xlat1 = vec4(u_xlat0.y * u_xlat4.x, u_xlat0.y * u_xlat4.y, u_xlat0.w * u_xlat4.z, u_xlat0.w * u_xlat4.w);
    u_xlat7 = u_xlat0.w * u_xlat4.y;
    u_xlat0.x = u_xlat1.x * u_xlat10_2 + u_xlat0.x;
    u_xlat0.x = u_xlat1.y * u_xlat10_9 + u_xlat0.x;
    u_xlat0.x = u_xlat1.z * u_xlat10_23 + u_xlat0.x;
    vec3 txVec7 = vec3(u_xlat3.xy,u_xlat0.z);
    u_xlat10_21 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec7, 0.0);
    vec3 txVec8 = vec3(u_xlat3.zw,u_xlat0.z);
    u_xlat10_14 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec8, 0.0);
    u_xlat0.x = u_xlat1.w * u_xlat10_21 + u_xlat0.x;
    u_xlat0.x = u_xlat7 * u_xlat10_14 + u_xlat0.x;
    u_xlat16_7 = (-_LightShadowData.x) + 1.0;
    u_xlat0 = u_xlat0.xxxx * vec4(u_xlat16_7) + _LightShadowData.xxxx;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
in highp vec3 in_TEXCOORD1;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
out highp vec3 vs_TEXCOORD2;
out highp vec3 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
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
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraInvProjection[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraInvProjection[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    vs_TEXCOORD0.zw = u_xlat1.zz + u_xlat1.xw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    vs_TEXCOORD1.xyz = in_TEXCOORD1.xyz;
    u_xlat1.xyz = u_xlat0.xyz + (-hlslcc_mtx4x4unity_CameraInvProjection[2].xyz);
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[2].xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.w = (-u_xlat1.z);
    vs_TEXCOORD2.xyz = u_xlat1.xyw;
    u_xlat0.w = (-u_xlat0.z);
    vs_TEXCOORD3.xyz = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 _LightSplitsNear;
uniform 	vec4 _LightSplitsFar;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
mediump vec4 u_xlat16_1;
bvec4 u_xlatb1;
vec4 u_xlat2;
lowp float u_xlat10_2;
bvec4 u_xlatb2;
vec4 u_xlat3;
lowp float u_xlat10_3;
vec4 u_xlat4;
vec4 u_xlat5;
vec4 u_xlat6;
float u_xlat7;
mediump float u_xlat16_7;
lowp float u_xlat10_9;
lowp float u_xlat10_14;
vec2 u_xlat16;
lowp float u_xlat10_16;
lowp float u_xlat10_21;
lowp float u_xlat10_23;
void main()
{
    u_xlat0.z = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat0.xy = vs_TEXCOORD0.zw;
    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraInvProjection[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraInvProjection[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraInvProjection[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraInvProjection[3];
    u_xlat0.xyz = u_xlat0.xyz / u_xlat0.www;
    u_xlatb1 = greaterThanEqual((-u_xlat0.zzzz), _LightSplitsNear);
    u_xlat1 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb1));
    u_xlatb2 = lessThan((-u_xlat0.zzzz), _LightSplitsFar);
    u_xlat2 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb2));
    u_xlat16_1 = u_xlat1 * u_xlat2;
    u_xlat2 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat2 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat2;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * (-u_xlat0.zzzz) + u_xlat2;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[5].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[4].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[6].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[7].xyz * u_xlat0.www + u_xlat2.xyz;
    u_xlat2.xyz = u_xlat16_1.yyy * u_xlat2.xyz;
    u_xlat3.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * u_xlat0.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * u_xlat0.zzz + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[3].xyz * u_xlat0.www + u_xlat3.xyz;
    u_xlat2.xyz = u_xlat3.xyz * u_xlat16_1.xxx + u_xlat2.xyz;
    u_xlat3.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[9].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[8].xyz * u_xlat0.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[10].xyz * u_xlat0.zzz + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[11].xyz * u_xlat0.www + u_xlat3.xyz;
    u_xlat2.xyz = u_xlat3.xyz * u_xlat16_1.zzz + u_xlat2.xyz;
    u_xlat3.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[13].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToShadow[12].xyz * u_xlat0.xxx + u_xlat3.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[14].xyz * u_xlat0.zzz + u_xlat3.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[15].xyz * u_xlat0.www + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_1.www + u_xlat2.xyz;
    u_xlat2.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + vec2(0.5, 0.5);
    u_xlat2.xy = floor(u_xlat2.xy);
    u_xlat0.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + (-u_xlat2.xy);
    u_xlat16.xy = min(u_xlat0.xy, vec2(0.0, 0.0));
    u_xlat3.xy = (-u_xlat0.xy) + vec2(1.0, 1.0);
    u_xlat16.xy = (-u_xlat16.xy) * u_xlat16.xy + u_xlat3.xy;
    u_xlat1.xy = u_xlat3.xy * vec2(0.159999996, 0.159999996);
    u_xlat16.xy = u_xlat16.xy + vec2(1.0, 1.0);
    u_xlat3.xy = u_xlat16.xy * vec2(0.159999996, 0.159999996);
    u_xlat16.xy = max(u_xlat0.xy, vec2(0.0, 0.0));
    u_xlat4 = u_xlat0.xxyy + vec4(0.5, 1.0, 0.5, 1.0);
    u_xlat16.xy = (-u_xlat16.xy) * u_xlat16.xy + u_xlat4.yw;
    u_xlat16.xy = u_xlat16.xy + vec2(1.0, 1.0);
    u_xlat5.xy = u_xlat16.xy * vec2(0.159999996, 0.159999996);
    u_xlat6 = u_xlat4.xxzz * u_xlat4.xxzz;
    u_xlat16.xy = vec2(u_xlat4.y * float(0.159999996), u_xlat4.w * float(0.159999996));
    u_xlat0.xy = u_xlat6.xz * vec2(0.5, 0.5) + (-u_xlat0.xy);
    u_xlat1.zw = vec2(u_xlat6.w * float(0.0799999982), u_xlat6.y * float(0.0799999982));
    u_xlat4.xy = u_xlat0.xy * vec2(0.159999996, 0.159999996);
    u_xlat3.z = u_xlat4.y;
    u_xlat3.w = u_xlat16.y;
    u_xlat4.w = u_xlat16.x;
    u_xlat5.zw = u_xlat1.yz;
    u_xlat0.xyw = vec3(u_xlat3.z + u_xlat5.z, u_xlat3.y + u_xlat5.y, u_xlat3.w + u_xlat5.w);
    u_xlat4.z = u_xlat3.x;
    u_xlat3.xyz = vec3(u_xlat5.z / u_xlat0.x, u_xlat5.y / u_xlat0.y, u_xlat5.w / u_xlat0.w);
    u_xlat1.z = u_xlat5.x;
    u_xlat3.xyz = u_xlat3.xyz + vec3(-2.5, -0.5, 1.5);
    u_xlat3.xyz = u_xlat3.xyz * _ShadowMapTexture_TexelSize.yyy;
    u_xlat5.w = u_xlat3.x;
    u_xlat4 = u_xlat1.zwxz + u_xlat4.zwxz;
    u_xlat6.xyz = vec3(u_xlat1.x / u_xlat4.z, u_xlat1.z / u_xlat4.w, u_xlat1.w / u_xlat4.y);
    u_xlat6.xyz = u_xlat6.xyz + vec3(-2.5, -0.5, 1.5);
    u_xlat5.xyz = u_xlat6.yxz * _ShadowMapTexture_TexelSize.xxx;
    u_xlat1 = u_xlat2.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.ywxw;
    u_xlat16.xy = u_xlat2.xy * _ShadowMapTexture_TexelSize.xy + u_xlat5.zw;
    vec3 txVec0 = vec3(u_xlat16.xy,u_xlat0.z);
    u_xlat10_16 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    vec3 txVec1 = vec3(u_xlat1.xy,u_xlat0.z);
    u_xlat10_23 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec1, 0.0);
    vec3 txVec2 = vec3(u_xlat1.zw,u_xlat0.z);
    u_xlat10_3 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec2, 0.0);
    u_xlat1 = vec4(u_xlat0.x * u_xlat4.z, u_xlat0.x * u_xlat4.w, u_xlat0.x * u_xlat4.y, u_xlat0.y * u_xlat4.z);
    u_xlat0.x = u_xlat10_3 * u_xlat1.y;
    u_xlat0.x = u_xlat1.x * u_xlat10_23 + u_xlat0.x;
    u_xlat0.x = u_xlat1.z * u_xlat10_16 + u_xlat0.x;
    u_xlat3.w = u_xlat5.y;
    u_xlat6 = u_xlat2.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat3.wywz;
    u_xlat5.yw = u_xlat3.yz;
    vec3 txVec3 = vec3(u_xlat6.xy,u_xlat0.z);
    u_xlat10_16 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec3, 0.0);
    vec3 txVec4 = vec3(u_xlat6.zw,u_xlat0.z);
    u_xlat10_23 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec4, 0.0);
    u_xlat0.x = u_xlat1.w * u_xlat10_16 + u_xlat0.x;
    u_xlat1 = u_xlat2.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xyzy;
    u_xlat3 = u_xlat2.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xwzw;
    vec3 txVec5 = vec3(u_xlat1.xy,u_xlat0.z);
    u_xlat10_2 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec5, 0.0);
    vec3 txVec6 = vec3(u_xlat1.zw,u_xlat0.z);
    u_xlat10_9 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec6, 0.0);
    u_xlat1 = vec4(u_xlat0.y * u_xlat4.x, u_xlat0.y * u_xlat4.y, u_xlat0.w * u_xlat4.z, u_xlat0.w * u_xlat4.w);
    u_xlat7 = u_xlat0.w * u_xlat4.y;
    u_xlat0.x = u_xlat1.x * u_xlat10_2 + u_xlat0.x;
    u_xlat0.x = u_xlat1.y * u_xlat10_9 + u_xlat0.x;
    u_xlat0.x = u_xlat1.z * u_xlat10_23 + u_xlat0.x;
    vec3 txVec7 = vec3(u_xlat3.xy,u_xlat0.z);
    u_xlat10_21 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec7, 0.0);
    vec3 txVec8 = vec3(u_xlat3.zw,u_xlat0.z);
    u_xlat10_14 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec8, 0.0);
    u_xlat0.x = u_xlat1.w * u_xlat10_21 + u_xlat0.x;
    u_xlat0.x = u_xlat7 * u_xlat10_14 + u_xlat0.x;
    u_xlat16_7 = (-_LightShadowData.x) + 1.0;
    u_xlat0 = u_xlat0.xxxx * vec4(u_xlat16_7) + _LightShadowData.xxxx;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "SHADOWS_SPLIT_SPHERES" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec3 orthoPosFar_1;
  highp vec3 orthoPosNear_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _glesVertex.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  clipPos_3.xzw = tmpvar_5.xzw;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 o_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_5.zw;
  tmpvar_4.zw = o_7.xy;
  clipPos_3.y = (tmpvar_5.y * _ProjectionParams.x);
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(-1.0, 1.0);
  tmpvar_10.xy = clipPos_3.xy;
  highp vec3 tmpvar_11;
  tmpvar_11 = (unity_CameraInvProjection * tmpvar_10).xyz;
  orthoPosNear_2.xy = tmpvar_11.xy;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(1.0, 1.0);
  tmpvar_12.xy = clipPos_3.xy;
  highp vec3 tmpvar_13;
  tmpvar_13 = (unity_CameraInvProjection * tmpvar_12).xyz;
  orthoPosFar_1.xy = tmpvar_13.xy;
  orthoPosNear_2.z = -(tmpvar_11.z);
  orthoPosFar_1.z = -(tmpvar_13.z);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = _glesMultiTexCoord1.xyz;
  xlv_TEXCOORD2 = orthoPosNear_2;
  xlv_TEXCOORD3 = orthoPosFar_1;
}


#endif
#ifdef FRAGMENT
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec4 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 camPos_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xy = xlv_TEXCOORD0.zw;
  tmpvar_4.z = texture2D (_CameraDepthTexture, xlv_TEXCOORD0.xy).x;
  clipPos_3.w = tmpvar_4.w;
  clipPos_3.xyz = ((2.0 * tmpvar_4.xyz) - 1.0);
  highp vec4 tmpvar_5;
  tmpvar_5 = (unity_CameraInvProjection * clipPos_3);
  camPos_2.w = tmpvar_5.w;
  camPos_2.xyz = (tmpvar_5.xyz / tmpvar_5.w);
  camPos_2.z = -(camPos_2.z);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = camPos_2.xyz;
  highp vec4 tmpvar_7;
  tmpvar_7 = (unity_CameraToWorld * tmpvar_6);
  lowp vec4 weights_8;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_7.xyz - unity_ShadowSplitSpheres[0].xyz);
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_7.xyz - unity_ShadowSplitSpheres[1].xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_7.xyz - unity_ShadowSplitSpheres[2].xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_7.xyz - unity_ShadowSplitSpheres[3].xyz);
  highp vec4 tmpvar_13;
  tmpvar_13.x = dot (tmpvar_9, tmpvar_9);
  tmpvar_13.y = dot (tmpvar_10, tmpvar_10);
  tmpvar_13.z = dot (tmpvar_11, tmpvar_11);
  tmpvar_13.w = dot (tmpvar_12, tmpvar_12);
  bvec4 tmpvar_14;
  tmpvar_14 = lessThan (tmpvar_13, unity_ShadowSplitSqRadii);
  lowp vec4 tmpvar_15;
  tmpvar_15 = vec4(tmpvar_14);
  weights_8.x = tmpvar_15.x;
  weights_8.yzw = clamp ((tmpvar_15.yzw - tmpvar_15.xyz), 0.0, 1.0);
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = (((
    ((unity_WorldToShadow[0] * tmpvar_7).xyz * tmpvar_15.x)
   + 
    ((unity_WorldToShadow[1] * tmpvar_7).xyz * weights_8.y)
  ) + (
    (unity_WorldToShadow[2] * tmpvar_7)
  .xyz * weights_8.z)) + ((unity_WorldToShadow[3] * tmpvar_7).xyz * weights_8.w));
  mediump float shadow_17;
  highp vec2 tmpvar_18;
  tmpvar_18 = _ShadowMapTexture_TexelSize.xy;
  shadow_17 = 0.0;
  highp vec3 tmpvar_19;
  tmpvar_19.xy = (tmpvar_16.xy - _ShadowMapTexture_TexelSize.xy);
  tmpvar_19.z = tmpvar_16.z;
  highp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_ShadowMapTexture, tmpvar_19.xy);
  mediump float tmpvar_21;
  if ((tmpvar_20.x < tmpvar_16.z)) {
    tmpvar_21 = 0.0;
  } else {
    tmpvar_21 = 1.0;
  };
  shadow_17 = tmpvar_21;
  highp vec2 tmpvar_22;
  tmpvar_22.x = 0.0;
  tmpvar_22.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_23;
  tmpvar_23.xy = (tmpvar_16.xy + tmpvar_22);
  tmpvar_23.z = tmpvar_16.z;
  highp vec4 tmpvar_24;
  tmpvar_24 = texture2D (_ShadowMapTexture, tmpvar_23.xy);
  highp float tmpvar_25;
  if ((tmpvar_24.x < tmpvar_16.z)) {
    tmpvar_25 = 0.0;
  } else {
    tmpvar_25 = 1.0;
  };
  shadow_17 = (tmpvar_21 + tmpvar_25);
  highp vec2 tmpvar_26;
  tmpvar_26.x = tmpvar_18.x;
  tmpvar_26.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_27;
  tmpvar_27.xy = (tmpvar_16.xy + tmpvar_26);
  tmpvar_27.z = tmpvar_16.z;
  highp vec4 tmpvar_28;
  tmpvar_28 = texture2D (_ShadowMapTexture, tmpvar_27.xy);
  highp float tmpvar_29;
  if ((tmpvar_28.x < tmpvar_16.z)) {
    tmpvar_29 = 0.0;
  } else {
    tmpvar_29 = 1.0;
  };
  shadow_17 = (shadow_17 + tmpvar_29);
  highp vec2 tmpvar_30;
  tmpvar_30.y = 0.0;
  tmpvar_30.x = -(_ShadowMapTexture_TexelSize.x);
  highp vec3 tmpvar_31;
  tmpvar_31.xy = (tmpvar_16.xy + tmpvar_30);
  tmpvar_31.z = tmpvar_16.z;
  highp vec4 tmpvar_32;
  tmpvar_32 = texture2D (_ShadowMapTexture, tmpvar_31.xy);
  highp float tmpvar_33;
  if ((tmpvar_32.x < tmpvar_16.z)) {
    tmpvar_33 = 0.0;
  } else {
    tmpvar_33 = 1.0;
  };
  shadow_17 = (shadow_17 + tmpvar_33);
  highp vec4 tmpvar_34;
  tmpvar_34 = texture2D (_ShadowMapTexture, tmpvar_16.xy);
  highp float tmpvar_35;
  if ((tmpvar_34.x < tmpvar_16.z)) {
    tmpvar_35 = 0.0;
  } else {
    tmpvar_35 = 1.0;
  };
  shadow_17 = (shadow_17 + tmpvar_35);
  highp vec2 tmpvar_36;
  tmpvar_36.y = 0.0;
  tmpvar_36.x = tmpvar_18.x;
  highp vec3 tmpvar_37;
  tmpvar_37.xy = (tmpvar_16.xy + tmpvar_36);
  tmpvar_37.z = tmpvar_16.z;
  highp vec4 tmpvar_38;
  tmpvar_38 = texture2D (_ShadowMapTexture, tmpvar_37.xy);
  highp float tmpvar_39;
  if ((tmpvar_38.x < tmpvar_16.z)) {
    tmpvar_39 = 0.0;
  } else {
    tmpvar_39 = 1.0;
  };
  shadow_17 = (shadow_17 + tmpvar_39);
  highp vec2 tmpvar_40;
  tmpvar_40.x = -(_ShadowMapTexture_TexelSize.x);
  tmpvar_40.y = tmpvar_18.y;
  highp vec3 tmpvar_41;
  tmpvar_41.xy = (tmpvar_16.xy + tmpvar_40);
  tmpvar_41.z = tmpvar_16.z;
  highp vec4 tmpvar_42;
  tmpvar_42 = texture2D (_ShadowMapTexture, tmpvar_41.xy);
  highp float tmpvar_43;
  if ((tmpvar_42.x < tmpvar_16.z)) {
    tmpvar_43 = 0.0;
  } else {
    tmpvar_43 = 1.0;
  };
  shadow_17 = (shadow_17 + tmpvar_43);
  highp vec2 tmpvar_44;
  tmpvar_44.x = 0.0;
  tmpvar_44.y = tmpvar_18.y;
  highp vec3 tmpvar_45;
  tmpvar_45.xy = (tmpvar_16.xy + tmpvar_44);
  tmpvar_45.z = tmpvar_16.z;
  highp vec4 tmpvar_46;
  tmpvar_46 = texture2D (_ShadowMapTexture, tmpvar_45.xy);
  highp float tmpvar_47;
  if ((tmpvar_46.x < tmpvar_16.z)) {
    tmpvar_47 = 0.0;
  } else {
    tmpvar_47 = 1.0;
  };
  shadow_17 = (shadow_17 + tmpvar_47);
  highp vec3 tmpvar_48;
  tmpvar_48.xy = (tmpvar_16.xy + _ShadowMapTexture_TexelSize.xy);
  tmpvar_48.z = tmpvar_16.z;
  highp vec4 tmpvar_49;
  tmpvar_49 = texture2D (_ShadowMapTexture, tmpvar_48.xy);
  highp float tmpvar_50;
  if ((tmpvar_49.x < tmpvar_16.z)) {
    tmpvar_50 = 0.0;
  } else {
    tmpvar_50 = 1.0;
  };
  shadow_17 = (shadow_17 + tmpvar_50);
  shadow_17 = (shadow_17 / 9.0);
  mediump vec4 tmpvar_51;
  tmpvar_51 = vec4(mix (_LightShadowData.x, 1.0, shadow_17));
  tmpvar_1 = tmpvar_51;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "SHADOWS_SPLIT_SPHERES" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec3 orthoPosFar_1;
  highp vec3 orthoPosNear_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _glesVertex.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  clipPos_3.xzw = tmpvar_5.xzw;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 o_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_5.zw;
  tmpvar_4.zw = o_7.xy;
  clipPos_3.y = (tmpvar_5.y * _ProjectionParams.x);
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(-1.0, 1.0);
  tmpvar_10.xy = clipPos_3.xy;
  highp vec3 tmpvar_11;
  tmpvar_11 = (unity_CameraInvProjection * tmpvar_10).xyz;
  orthoPosNear_2.xy = tmpvar_11.xy;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(1.0, 1.0);
  tmpvar_12.xy = clipPos_3.xy;
  highp vec3 tmpvar_13;
  tmpvar_13 = (unity_CameraInvProjection * tmpvar_12).xyz;
  orthoPosFar_1.xy = tmpvar_13.xy;
  orthoPosNear_2.z = -(tmpvar_11.z);
  orthoPosFar_1.z = -(tmpvar_13.z);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = _glesMultiTexCoord1.xyz;
  xlv_TEXCOORD2 = orthoPosNear_2;
  xlv_TEXCOORD3 = orthoPosFar_1;
}


#endif
#ifdef FRAGMENT
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec4 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 camPos_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xy = xlv_TEXCOORD0.zw;
  tmpvar_4.z = texture2D (_CameraDepthTexture, xlv_TEXCOORD0.xy).x;
  clipPos_3.w = tmpvar_4.w;
  clipPos_3.xyz = ((2.0 * tmpvar_4.xyz) - 1.0);
  highp vec4 tmpvar_5;
  tmpvar_5 = (unity_CameraInvProjection * clipPos_3);
  camPos_2.w = tmpvar_5.w;
  camPos_2.xyz = (tmpvar_5.xyz / tmpvar_5.w);
  camPos_2.z = -(camPos_2.z);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = camPos_2.xyz;
  highp vec4 tmpvar_7;
  tmpvar_7 = (unity_CameraToWorld * tmpvar_6);
  lowp vec4 weights_8;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_7.xyz - unity_ShadowSplitSpheres[0].xyz);
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_7.xyz - unity_ShadowSplitSpheres[1].xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_7.xyz - unity_ShadowSplitSpheres[2].xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_7.xyz - unity_ShadowSplitSpheres[3].xyz);
  highp vec4 tmpvar_13;
  tmpvar_13.x = dot (tmpvar_9, tmpvar_9);
  tmpvar_13.y = dot (tmpvar_10, tmpvar_10);
  tmpvar_13.z = dot (tmpvar_11, tmpvar_11);
  tmpvar_13.w = dot (tmpvar_12, tmpvar_12);
  bvec4 tmpvar_14;
  tmpvar_14 = lessThan (tmpvar_13, unity_ShadowSplitSqRadii);
  lowp vec4 tmpvar_15;
  tmpvar_15 = vec4(tmpvar_14);
  weights_8.x = tmpvar_15.x;
  weights_8.yzw = clamp ((tmpvar_15.yzw - tmpvar_15.xyz), 0.0, 1.0);
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = (((
    ((unity_WorldToShadow[0] * tmpvar_7).xyz * tmpvar_15.x)
   + 
    ((unity_WorldToShadow[1] * tmpvar_7).xyz * weights_8.y)
  ) + (
    (unity_WorldToShadow[2] * tmpvar_7)
  .xyz * weights_8.z)) + ((unity_WorldToShadow[3] * tmpvar_7).xyz * weights_8.w));
  mediump float shadow_17;
  highp vec2 tmpvar_18;
  tmpvar_18 = _ShadowMapTexture_TexelSize.xy;
  shadow_17 = 0.0;
  highp vec3 tmpvar_19;
  tmpvar_19.xy = (tmpvar_16.xy - _ShadowMapTexture_TexelSize.xy);
  tmpvar_19.z = tmpvar_16.z;
  highp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_ShadowMapTexture, tmpvar_19.xy);
  mediump float tmpvar_21;
  if ((tmpvar_20.x < tmpvar_16.z)) {
    tmpvar_21 = 0.0;
  } else {
    tmpvar_21 = 1.0;
  };
  shadow_17 = tmpvar_21;
  highp vec2 tmpvar_22;
  tmpvar_22.x = 0.0;
  tmpvar_22.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_23;
  tmpvar_23.xy = (tmpvar_16.xy + tmpvar_22);
  tmpvar_23.z = tmpvar_16.z;
  highp vec4 tmpvar_24;
  tmpvar_24 = texture2D (_ShadowMapTexture, tmpvar_23.xy);
  highp float tmpvar_25;
  if ((tmpvar_24.x < tmpvar_16.z)) {
    tmpvar_25 = 0.0;
  } else {
    tmpvar_25 = 1.0;
  };
  shadow_17 = (tmpvar_21 + tmpvar_25);
  highp vec2 tmpvar_26;
  tmpvar_26.x = tmpvar_18.x;
  tmpvar_26.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_27;
  tmpvar_27.xy = (tmpvar_16.xy + tmpvar_26);
  tmpvar_27.z = tmpvar_16.z;
  highp vec4 tmpvar_28;
  tmpvar_28 = texture2D (_ShadowMapTexture, tmpvar_27.xy);
  highp float tmpvar_29;
  if ((tmpvar_28.x < tmpvar_16.z)) {
    tmpvar_29 = 0.0;
  } else {
    tmpvar_29 = 1.0;
  };
  shadow_17 = (shadow_17 + tmpvar_29);
  highp vec2 tmpvar_30;
  tmpvar_30.y = 0.0;
  tmpvar_30.x = -(_ShadowMapTexture_TexelSize.x);
  highp vec3 tmpvar_31;
  tmpvar_31.xy = (tmpvar_16.xy + tmpvar_30);
  tmpvar_31.z = tmpvar_16.z;
  highp vec4 tmpvar_32;
  tmpvar_32 = texture2D (_ShadowMapTexture, tmpvar_31.xy);
  highp float tmpvar_33;
  if ((tmpvar_32.x < tmpvar_16.z)) {
    tmpvar_33 = 0.0;
  } else {
    tmpvar_33 = 1.0;
  };
  shadow_17 = (shadow_17 + tmpvar_33);
  highp vec4 tmpvar_34;
  tmpvar_34 = texture2D (_ShadowMapTexture, tmpvar_16.xy);
  highp float tmpvar_35;
  if ((tmpvar_34.x < tmpvar_16.z)) {
    tmpvar_35 = 0.0;
  } else {
    tmpvar_35 = 1.0;
  };
  shadow_17 = (shadow_17 + tmpvar_35);
  highp vec2 tmpvar_36;
  tmpvar_36.y = 0.0;
  tmpvar_36.x = tmpvar_18.x;
  highp vec3 tmpvar_37;
  tmpvar_37.xy = (tmpvar_16.xy + tmpvar_36);
  tmpvar_37.z = tmpvar_16.z;
  highp vec4 tmpvar_38;
  tmpvar_38 = texture2D (_ShadowMapTexture, tmpvar_37.xy);
  highp float tmpvar_39;
  if ((tmpvar_38.x < tmpvar_16.z)) {
    tmpvar_39 = 0.0;
  } else {
    tmpvar_39 = 1.0;
  };
  shadow_17 = (shadow_17 + tmpvar_39);
  highp vec2 tmpvar_40;
  tmpvar_40.x = -(_ShadowMapTexture_TexelSize.x);
  tmpvar_40.y = tmpvar_18.y;
  highp vec3 tmpvar_41;
  tmpvar_41.xy = (tmpvar_16.xy + tmpvar_40);
  tmpvar_41.z = tmpvar_16.z;
  highp vec4 tmpvar_42;
  tmpvar_42 = texture2D (_ShadowMapTexture, tmpvar_41.xy);
  highp float tmpvar_43;
  if ((tmpvar_42.x < tmpvar_16.z)) {
    tmpvar_43 = 0.0;
  } else {
    tmpvar_43 = 1.0;
  };
  shadow_17 = (shadow_17 + tmpvar_43);
  highp vec2 tmpvar_44;
  tmpvar_44.x = 0.0;
  tmpvar_44.y = tmpvar_18.y;
  highp vec3 tmpvar_45;
  tmpvar_45.xy = (tmpvar_16.xy + tmpvar_44);
  tmpvar_45.z = tmpvar_16.z;
  highp vec4 tmpvar_46;
  tmpvar_46 = texture2D (_ShadowMapTexture, tmpvar_45.xy);
  highp float tmpvar_47;
  if ((tmpvar_46.x < tmpvar_16.z)) {
    tmpvar_47 = 0.0;
  } else {
    tmpvar_47 = 1.0;
  };
  shadow_17 = (shadow_17 + tmpvar_47);
  highp vec3 tmpvar_48;
  tmpvar_48.xy = (tmpvar_16.xy + _ShadowMapTexture_TexelSize.xy);
  tmpvar_48.z = tmpvar_16.z;
  highp vec4 tmpvar_49;
  tmpvar_49 = texture2D (_ShadowMapTexture, tmpvar_48.xy);
  highp float tmpvar_50;
  if ((tmpvar_49.x < tmpvar_16.z)) {
    tmpvar_50 = 0.0;
  } else {
    tmpvar_50 = 1.0;
  };
  shadow_17 = (shadow_17 + tmpvar_50);
  shadow_17 = (shadow_17 / 9.0);
  mediump vec4 tmpvar_51;
  tmpvar_51 = vec4(mix (_LightShadowData.x, 1.0, shadow_17));
  tmpvar_1 = tmpvar_51;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "SHADOWS_SPLIT_SPHERES" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec3 orthoPosFar_1;
  highp vec3 orthoPosNear_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _glesVertex.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  clipPos_3.xzw = tmpvar_5.xzw;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 o_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_5.zw;
  tmpvar_4.zw = o_7.xy;
  clipPos_3.y = (tmpvar_5.y * _ProjectionParams.x);
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(-1.0, 1.0);
  tmpvar_10.xy = clipPos_3.xy;
  highp vec3 tmpvar_11;
  tmpvar_11 = (unity_CameraInvProjection * tmpvar_10).xyz;
  orthoPosNear_2.xy = tmpvar_11.xy;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(1.0, 1.0);
  tmpvar_12.xy = clipPos_3.xy;
  highp vec3 tmpvar_13;
  tmpvar_13 = (unity_CameraInvProjection * tmpvar_12).xyz;
  orthoPosFar_1.xy = tmpvar_13.xy;
  orthoPosNear_2.z = -(tmpvar_11.z);
  orthoPosFar_1.z = -(tmpvar_13.z);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = _glesMultiTexCoord1.xyz;
  xlv_TEXCOORD2 = orthoPosNear_2;
  xlv_TEXCOORD3 = orthoPosFar_1;
}


#endif
#ifdef FRAGMENT
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowSplitSpheres[4];
uniform highp vec4 unity_ShadowSplitSqRadii;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec4 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 camPos_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xy = xlv_TEXCOORD0.zw;
  tmpvar_4.z = texture2D (_CameraDepthTexture, xlv_TEXCOORD0.xy).x;
  clipPos_3.w = tmpvar_4.w;
  clipPos_3.xyz = ((2.0 * tmpvar_4.xyz) - 1.0);
  highp vec4 tmpvar_5;
  tmpvar_5 = (unity_CameraInvProjection * clipPos_3);
  camPos_2.w = tmpvar_5.w;
  camPos_2.xyz = (tmpvar_5.xyz / tmpvar_5.w);
  camPos_2.z = -(camPos_2.z);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = camPos_2.xyz;
  highp vec4 tmpvar_7;
  tmpvar_7 = (unity_CameraToWorld * tmpvar_6);
  lowp vec4 weights_8;
  highp vec3 tmpvar_9;
  tmpvar_9 = (tmpvar_7.xyz - unity_ShadowSplitSpheres[0].xyz);
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_7.xyz - unity_ShadowSplitSpheres[1].xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_7.xyz - unity_ShadowSplitSpheres[2].xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_7.xyz - unity_ShadowSplitSpheres[3].xyz);
  highp vec4 tmpvar_13;
  tmpvar_13.x = dot (tmpvar_9, tmpvar_9);
  tmpvar_13.y = dot (tmpvar_10, tmpvar_10);
  tmpvar_13.z = dot (tmpvar_11, tmpvar_11);
  tmpvar_13.w = dot (tmpvar_12, tmpvar_12);
  bvec4 tmpvar_14;
  tmpvar_14 = lessThan (tmpvar_13, unity_ShadowSplitSqRadii);
  lowp vec4 tmpvar_15;
  tmpvar_15 = vec4(tmpvar_14);
  weights_8.x = tmpvar_15.x;
  weights_8.yzw = clamp ((tmpvar_15.yzw - tmpvar_15.xyz), 0.0, 1.0);
  highp vec4 tmpvar_16;
  tmpvar_16.w = 1.0;
  tmpvar_16.xyz = (((
    ((unity_WorldToShadow[0] * tmpvar_7).xyz * tmpvar_15.x)
   + 
    ((unity_WorldToShadow[1] * tmpvar_7).xyz * weights_8.y)
  ) + (
    (unity_WorldToShadow[2] * tmpvar_7)
  .xyz * weights_8.z)) + ((unity_WorldToShadow[3] * tmpvar_7).xyz * weights_8.w));
  mediump float shadow_17;
  highp vec2 tmpvar_18;
  tmpvar_18 = _ShadowMapTexture_TexelSize.xy;
  shadow_17 = 0.0;
  highp vec3 tmpvar_19;
  tmpvar_19.xy = (tmpvar_16.xy - _ShadowMapTexture_TexelSize.xy);
  tmpvar_19.z = tmpvar_16.z;
  highp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_ShadowMapTexture, tmpvar_19.xy);
  mediump float tmpvar_21;
  if ((tmpvar_20.x < tmpvar_16.z)) {
    tmpvar_21 = 0.0;
  } else {
    tmpvar_21 = 1.0;
  };
  shadow_17 = tmpvar_21;
  highp vec2 tmpvar_22;
  tmpvar_22.x = 0.0;
  tmpvar_22.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_23;
  tmpvar_23.xy = (tmpvar_16.xy + tmpvar_22);
  tmpvar_23.z = tmpvar_16.z;
  highp vec4 tmpvar_24;
  tmpvar_24 = texture2D (_ShadowMapTexture, tmpvar_23.xy);
  highp float tmpvar_25;
  if ((tmpvar_24.x < tmpvar_16.z)) {
    tmpvar_25 = 0.0;
  } else {
    tmpvar_25 = 1.0;
  };
  shadow_17 = (tmpvar_21 + tmpvar_25);
  highp vec2 tmpvar_26;
  tmpvar_26.x = tmpvar_18.x;
  tmpvar_26.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_27;
  tmpvar_27.xy = (tmpvar_16.xy + tmpvar_26);
  tmpvar_27.z = tmpvar_16.z;
  highp vec4 tmpvar_28;
  tmpvar_28 = texture2D (_ShadowMapTexture, tmpvar_27.xy);
  highp float tmpvar_29;
  if ((tmpvar_28.x < tmpvar_16.z)) {
    tmpvar_29 = 0.0;
  } else {
    tmpvar_29 = 1.0;
  };
  shadow_17 = (shadow_17 + tmpvar_29);
  highp vec2 tmpvar_30;
  tmpvar_30.y = 0.0;
  tmpvar_30.x = -(_ShadowMapTexture_TexelSize.x);
  highp vec3 tmpvar_31;
  tmpvar_31.xy = (tmpvar_16.xy + tmpvar_30);
  tmpvar_31.z = tmpvar_16.z;
  highp vec4 tmpvar_32;
  tmpvar_32 = texture2D (_ShadowMapTexture, tmpvar_31.xy);
  highp float tmpvar_33;
  if ((tmpvar_32.x < tmpvar_16.z)) {
    tmpvar_33 = 0.0;
  } else {
    tmpvar_33 = 1.0;
  };
  shadow_17 = (shadow_17 + tmpvar_33);
  highp vec4 tmpvar_34;
  tmpvar_34 = texture2D (_ShadowMapTexture, tmpvar_16.xy);
  highp float tmpvar_35;
  if ((tmpvar_34.x < tmpvar_16.z)) {
    tmpvar_35 = 0.0;
  } else {
    tmpvar_35 = 1.0;
  };
  shadow_17 = (shadow_17 + tmpvar_35);
  highp vec2 tmpvar_36;
  tmpvar_36.y = 0.0;
  tmpvar_36.x = tmpvar_18.x;
  highp vec3 tmpvar_37;
  tmpvar_37.xy = (tmpvar_16.xy + tmpvar_36);
  tmpvar_37.z = tmpvar_16.z;
  highp vec4 tmpvar_38;
  tmpvar_38 = texture2D (_ShadowMapTexture, tmpvar_37.xy);
  highp float tmpvar_39;
  if ((tmpvar_38.x < tmpvar_16.z)) {
    tmpvar_39 = 0.0;
  } else {
    tmpvar_39 = 1.0;
  };
  shadow_17 = (shadow_17 + tmpvar_39);
  highp vec2 tmpvar_40;
  tmpvar_40.x = -(_ShadowMapTexture_TexelSize.x);
  tmpvar_40.y = tmpvar_18.y;
  highp vec3 tmpvar_41;
  tmpvar_41.xy = (tmpvar_16.xy + tmpvar_40);
  tmpvar_41.z = tmpvar_16.z;
  highp vec4 tmpvar_42;
  tmpvar_42 = texture2D (_ShadowMapTexture, tmpvar_41.xy);
  highp float tmpvar_43;
  if ((tmpvar_42.x < tmpvar_16.z)) {
    tmpvar_43 = 0.0;
  } else {
    tmpvar_43 = 1.0;
  };
  shadow_17 = (shadow_17 + tmpvar_43);
  highp vec2 tmpvar_44;
  tmpvar_44.x = 0.0;
  tmpvar_44.y = tmpvar_18.y;
  highp vec3 tmpvar_45;
  tmpvar_45.xy = (tmpvar_16.xy + tmpvar_44);
  tmpvar_45.z = tmpvar_16.z;
  highp vec4 tmpvar_46;
  tmpvar_46 = texture2D (_ShadowMapTexture, tmpvar_45.xy);
  highp float tmpvar_47;
  if ((tmpvar_46.x < tmpvar_16.z)) {
    tmpvar_47 = 0.0;
  } else {
    tmpvar_47 = 1.0;
  };
  shadow_17 = (shadow_17 + tmpvar_47);
  highp vec3 tmpvar_48;
  tmpvar_48.xy = (tmpvar_16.xy + _ShadowMapTexture_TexelSize.xy);
  tmpvar_48.z = tmpvar_16.z;
  highp vec4 tmpvar_49;
  tmpvar_49 = texture2D (_ShadowMapTexture, tmpvar_48.xy);
  highp float tmpvar_50;
  if ((tmpvar_49.x < tmpvar_16.z)) {
    tmpvar_50 = 0.0;
  } else {
    tmpvar_50 = 1.0;
  };
  shadow_17 = (shadow_17 + tmpvar_50);
  shadow_17 = (shadow_17 / 9.0);
  mediump vec4 tmpvar_51;
  tmpvar_51 = vec4(mix (_LightShadowData.x, 1.0, shadow_17));
  tmpvar_1 = tmpvar_51;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SHADOWS_SPLIT_SPHERES" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
in highp vec3 in_TEXCOORD1;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
out highp vec3 vs_TEXCOORD2;
out highp vec3 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
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
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraInvProjection[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraInvProjection[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    vs_TEXCOORD0.zw = u_xlat1.zz + u_xlat1.xw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    vs_TEXCOORD1.xyz = in_TEXCOORD1.xyz;
    u_xlat1.xyz = u_xlat0.xyz + (-hlslcc_mtx4x4unity_CameraInvProjection[2].xyz);
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[2].xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.w = (-u_xlat1.z);
    vs_TEXCOORD2.xyz = u_xlat1.xyw;
    u_xlat0.w = (-u_xlat0.z);
    vs_TEXCOORD3.xyz = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 unity_ShadowSplitSpheres[4];
uniform 	vec4 unity_ShadowSplitSqRadii;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp float u_xlat10_1;
bvec4 u_xlatb1;
vec4 u_xlat2;
vec4 u_xlat3;
mediump vec3 u_xlat16_3;
vec4 u_xlat4;
lowp float u_xlat10_4;
vec4 u_xlat5;
vec4 u_xlat6;
float u_xlat7;
mediump float u_xlat16_7;
vec3 u_xlat8;
lowp float u_xlat10_8;
lowp float u_xlat10_14;
vec2 u_xlat15;
lowp float u_xlat10_15;
lowp float u_xlat10_21;
lowp float u_xlat10_22;
void main()
{
    u_xlat0.z = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat0.xy = vs_TEXCOORD0.zw;
    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraInvProjection[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraInvProjection[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraInvProjection[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraInvProjection[3];
    u_xlat0.xyz = u_xlat0.xyz / u_xlat0.www;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * (-u_xlat0.zzzz) + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat1.xyz = u_xlat0.xyz + (-unity_ShadowSplitSpheres[0].xyz);
    u_xlat1.x = dot(u_xlat1.xyz, u_xlat1.xyz);
    u_xlat2.xyz = u_xlat0.xyz + (-unity_ShadowSplitSpheres[1].xyz);
    u_xlat1.y = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat2.xyz = u_xlat0.xyz + (-unity_ShadowSplitSpheres[2].xyz);
    u_xlat1.z = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat2.xyz = u_xlat0.xyz + (-unity_ShadowSplitSpheres[3].xyz);
    u_xlat1.w = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlatb1 = lessThan(u_xlat1, unity_ShadowSplitSqRadii);
    u_xlat16_3.x = (u_xlatb1.x) ? float(-1.0) : float(-0.0);
    u_xlat16_3.y = (u_xlatb1.y) ? float(-1.0) : float(-0.0);
    u_xlat16_3.z = (u_xlatb1.z) ? float(-1.0) : float(-0.0);
    u_xlat1 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb1));
    u_xlat16_3.xyz = vec3(u_xlat16_3.x + u_xlat1.y, u_xlat16_3.y + u_xlat1.z, u_xlat16_3.z + u_xlat1.w);
    u_xlat16_3.xyz = max(u_xlat16_3.xyz, vec3(0.0, 0.0, 0.0));
    u_xlat8.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[5].xyz;
    u_xlat8.xyz = hlslcc_mtx4x4unity_WorldToShadow[4].xyz * u_xlat0.xxx + u_xlat8.xyz;
    u_xlat8.xyz = hlslcc_mtx4x4unity_WorldToShadow[6].xyz * u_xlat0.zzz + u_xlat8.xyz;
    u_xlat8.xyz = hlslcc_mtx4x4unity_WorldToShadow[7].xyz * u_xlat0.www + u_xlat8.xyz;
    u_xlat8.xyz = u_xlat16_3.xxx * u_xlat8.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[3].xyz * u_xlat0.www + u_xlat2.xyz;
    u_xlat1.xyz = u_xlat2.xyz * u_xlat1.xxx + u_xlat8.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[9].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[8].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[10].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[11].xyz * u_xlat0.www + u_xlat2.xyz;
    u_xlat1.xyz = u_xlat2.xyz * u_xlat16_3.yyy + u_xlat1.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[13].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[12].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[14].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[15].xyz * u_xlat0.www + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_3.zzz + u_xlat1.xyz;
    u_xlat1.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + vec2(0.5, 0.5);
    u_xlat1.xy = floor(u_xlat1.xy);
    u_xlat0.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + (-u_xlat1.xy);
    u_xlat15.xy = max(u_xlat0.xy, vec2(0.0, 0.0));
    u_xlat2 = u_xlat0.xxyy + vec4(0.5, 1.0, 0.5, 1.0);
    u_xlat15.xy = (-u_xlat15.xy) * u_xlat15.xy + u_xlat2.yw;
    u_xlat15.xy = u_xlat15.xy + vec2(1.0, 1.0);
    u_xlat3.xy = u_xlat15.xy * vec2(0.159999996, 0.159999996);
    u_xlat15.xy = min(u_xlat0.xy, vec2(0.0, 0.0));
    u_xlat4.xy = (-u_xlat0.xy) + vec2(1.0, 1.0);
    u_xlat15.xy = (-u_xlat15.xy) * u_xlat15.xy + u_xlat4.xy;
    u_xlat4.xy = u_xlat4.xy * vec2(0.159999996, 0.159999996);
    u_xlat15.xy = u_xlat15.xy + vec2(1.0, 1.0);
    u_xlat5.xy = u_xlat15.xy * vec2(0.159999996, 0.159999996);
    u_xlat6 = u_xlat2.xxzz * u_xlat2.xxzz;
    u_xlat15.xy = vec2(u_xlat2.y * float(0.159999996), u_xlat2.w * float(0.159999996));
    u_xlat0.xy = u_xlat6.xz * vec2(0.5, 0.5) + (-u_xlat0.xy);
    u_xlat4.zw = vec2(u_xlat6.w * float(0.0799999982), u_xlat6.y * float(0.0799999982));
    u_xlat2.xy = u_xlat0.xy * vec2(0.159999996, 0.159999996);
    u_xlat5.z = u_xlat2.y;
    u_xlat5.w = u_xlat15.y;
    u_xlat2.w = u_xlat15.x;
    u_xlat3.zw = u_xlat4.yz;
    u_xlat0.xyw = vec3(u_xlat3.z + u_xlat5.z, u_xlat3.y + u_xlat5.y, u_xlat3.w + u_xlat5.w);
    u_xlat2.z = u_xlat5.x;
    u_xlat5.xyz = vec3(u_xlat3.z / u_xlat0.x, u_xlat3.y / u_xlat0.y, u_xlat3.w / u_xlat0.w);
    u_xlat4.z = u_xlat3.x;
    u_xlat5.xyz = u_xlat5.xyz + vec3(-2.5, -0.5, 1.5);
    u_xlat3.xyz = u_xlat5.xyz * _ShadowMapTexture_TexelSize.yyy;
    u_xlat5.w = u_xlat3.x;
    u_xlat2 = u_xlat2.zwxz + u_xlat4.zwxz;
    u_xlat4.xyz = vec3(u_xlat4.x / u_xlat2.z, u_xlat4.z / u_xlat2.w, u_xlat4.w / u_xlat2.y);
    u_xlat4.xyz = u_xlat4.xyz + vec3(-2.5, -0.5, 1.5);
    u_xlat5.xyz = u_xlat4.yxz * _ShadowMapTexture_TexelSize.xxx;
    u_xlat4 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.ywxw;
    u_xlat15.xy = u_xlat1.xy * _ShadowMapTexture_TexelSize.xy + u_xlat5.zw;
    vec3 txVec0 = vec3(u_xlat15.xy,u_xlat0.z);
    u_xlat10_15 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    vec3 txVec1 = vec3(u_xlat4.xy,u_xlat0.z);
    u_xlat10_22 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec1, 0.0);
    vec3 txVec2 = vec3(u_xlat4.zw,u_xlat0.z);
    u_xlat10_4 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec2, 0.0);
    u_xlat6 = vec4(u_xlat0.x * u_xlat2.z, u_xlat0.x * u_xlat2.w, u_xlat0.x * u_xlat2.y, u_xlat0.y * u_xlat2.z);
    u_xlat0.x = u_xlat10_4 * u_xlat6.y;
    u_xlat0.x = u_xlat6.x * u_xlat10_22 + u_xlat0.x;
    u_xlat0.x = u_xlat6.z * u_xlat10_15 + u_xlat0.x;
    u_xlat3.w = u_xlat5.y;
    u_xlat4 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat3.wywz;
    u_xlat5.yw = u_xlat3.yz;
    vec3 txVec3 = vec3(u_xlat4.xy,u_xlat0.z);
    u_xlat10_15 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec3, 0.0);
    vec3 txVec4 = vec3(u_xlat4.zw,u_xlat0.z);
    u_xlat10_22 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec4, 0.0);
    u_xlat0.x = u_xlat6.w * u_xlat10_15 + u_xlat0.x;
    u_xlat3 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xyzy;
    u_xlat4 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xwzw;
    vec3 txVec5 = vec3(u_xlat3.xy,u_xlat0.z);
    u_xlat10_1 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec5, 0.0);
    vec3 txVec6 = vec3(u_xlat3.zw,u_xlat0.z);
    u_xlat10_8 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec6, 0.0);
    u_xlat3 = vec4(u_xlat0.y * u_xlat2.x, u_xlat0.y * u_xlat2.y, u_xlat0.w * u_xlat2.z, u_xlat0.w * u_xlat2.w);
    u_xlat7 = u_xlat0.w * u_xlat2.y;
    u_xlat0.x = u_xlat3.x * u_xlat10_1 + u_xlat0.x;
    u_xlat0.x = u_xlat3.y * u_xlat10_8 + u_xlat0.x;
    u_xlat0.x = u_xlat3.z * u_xlat10_22 + u_xlat0.x;
    vec3 txVec7 = vec3(u_xlat4.xy,u_xlat0.z);
    u_xlat10_21 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec7, 0.0);
    vec3 txVec8 = vec3(u_xlat4.zw,u_xlat0.z);
    u_xlat10_14 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec8, 0.0);
    u_xlat0.x = u_xlat3.w * u_xlat10_21 + u_xlat0.x;
    u_xlat0.x = u_xlat7 * u_xlat10_14 + u_xlat0.x;
    u_xlat16_7 = (-_LightShadowData.x) + 1.0;
    u_xlat0 = u_xlat0.xxxx * vec4(u_xlat16_7) + _LightShadowData.xxxx;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SHADOWS_SPLIT_SPHERES" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
in highp vec3 in_TEXCOORD1;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
out highp vec3 vs_TEXCOORD2;
out highp vec3 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
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
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraInvProjection[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraInvProjection[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    vs_TEXCOORD0.zw = u_xlat1.zz + u_xlat1.xw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    vs_TEXCOORD1.xyz = in_TEXCOORD1.xyz;
    u_xlat1.xyz = u_xlat0.xyz + (-hlslcc_mtx4x4unity_CameraInvProjection[2].xyz);
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[2].xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.w = (-u_xlat1.z);
    vs_TEXCOORD2.xyz = u_xlat1.xyw;
    u_xlat0.w = (-u_xlat0.z);
    vs_TEXCOORD3.xyz = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 unity_ShadowSplitSpheres[4];
uniform 	vec4 unity_ShadowSplitSqRadii;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp float u_xlat10_1;
bvec4 u_xlatb1;
vec4 u_xlat2;
vec4 u_xlat3;
mediump vec3 u_xlat16_3;
vec4 u_xlat4;
lowp float u_xlat10_4;
vec4 u_xlat5;
vec4 u_xlat6;
float u_xlat7;
mediump float u_xlat16_7;
vec3 u_xlat8;
lowp float u_xlat10_8;
lowp float u_xlat10_14;
vec2 u_xlat15;
lowp float u_xlat10_15;
lowp float u_xlat10_21;
lowp float u_xlat10_22;
void main()
{
    u_xlat0.z = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat0.xy = vs_TEXCOORD0.zw;
    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraInvProjection[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraInvProjection[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraInvProjection[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraInvProjection[3];
    u_xlat0.xyz = u_xlat0.xyz / u_xlat0.www;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * (-u_xlat0.zzzz) + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat1.xyz = u_xlat0.xyz + (-unity_ShadowSplitSpheres[0].xyz);
    u_xlat1.x = dot(u_xlat1.xyz, u_xlat1.xyz);
    u_xlat2.xyz = u_xlat0.xyz + (-unity_ShadowSplitSpheres[1].xyz);
    u_xlat1.y = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat2.xyz = u_xlat0.xyz + (-unity_ShadowSplitSpheres[2].xyz);
    u_xlat1.z = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat2.xyz = u_xlat0.xyz + (-unity_ShadowSplitSpheres[3].xyz);
    u_xlat1.w = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlatb1 = lessThan(u_xlat1, unity_ShadowSplitSqRadii);
    u_xlat16_3.x = (u_xlatb1.x) ? float(-1.0) : float(-0.0);
    u_xlat16_3.y = (u_xlatb1.y) ? float(-1.0) : float(-0.0);
    u_xlat16_3.z = (u_xlatb1.z) ? float(-1.0) : float(-0.0);
    u_xlat1 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb1));
    u_xlat16_3.xyz = vec3(u_xlat16_3.x + u_xlat1.y, u_xlat16_3.y + u_xlat1.z, u_xlat16_3.z + u_xlat1.w);
    u_xlat16_3.xyz = max(u_xlat16_3.xyz, vec3(0.0, 0.0, 0.0));
    u_xlat8.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[5].xyz;
    u_xlat8.xyz = hlslcc_mtx4x4unity_WorldToShadow[4].xyz * u_xlat0.xxx + u_xlat8.xyz;
    u_xlat8.xyz = hlslcc_mtx4x4unity_WorldToShadow[6].xyz * u_xlat0.zzz + u_xlat8.xyz;
    u_xlat8.xyz = hlslcc_mtx4x4unity_WorldToShadow[7].xyz * u_xlat0.www + u_xlat8.xyz;
    u_xlat8.xyz = u_xlat16_3.xxx * u_xlat8.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[3].xyz * u_xlat0.www + u_xlat2.xyz;
    u_xlat1.xyz = u_xlat2.xyz * u_xlat1.xxx + u_xlat8.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[9].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[8].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[10].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[11].xyz * u_xlat0.www + u_xlat2.xyz;
    u_xlat1.xyz = u_xlat2.xyz * u_xlat16_3.yyy + u_xlat1.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[13].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[12].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[14].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[15].xyz * u_xlat0.www + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_3.zzz + u_xlat1.xyz;
    u_xlat1.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + vec2(0.5, 0.5);
    u_xlat1.xy = floor(u_xlat1.xy);
    u_xlat0.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + (-u_xlat1.xy);
    u_xlat15.xy = max(u_xlat0.xy, vec2(0.0, 0.0));
    u_xlat2 = u_xlat0.xxyy + vec4(0.5, 1.0, 0.5, 1.0);
    u_xlat15.xy = (-u_xlat15.xy) * u_xlat15.xy + u_xlat2.yw;
    u_xlat15.xy = u_xlat15.xy + vec2(1.0, 1.0);
    u_xlat3.xy = u_xlat15.xy * vec2(0.159999996, 0.159999996);
    u_xlat15.xy = min(u_xlat0.xy, vec2(0.0, 0.0));
    u_xlat4.xy = (-u_xlat0.xy) + vec2(1.0, 1.0);
    u_xlat15.xy = (-u_xlat15.xy) * u_xlat15.xy + u_xlat4.xy;
    u_xlat4.xy = u_xlat4.xy * vec2(0.159999996, 0.159999996);
    u_xlat15.xy = u_xlat15.xy + vec2(1.0, 1.0);
    u_xlat5.xy = u_xlat15.xy * vec2(0.159999996, 0.159999996);
    u_xlat6 = u_xlat2.xxzz * u_xlat2.xxzz;
    u_xlat15.xy = vec2(u_xlat2.y * float(0.159999996), u_xlat2.w * float(0.159999996));
    u_xlat0.xy = u_xlat6.xz * vec2(0.5, 0.5) + (-u_xlat0.xy);
    u_xlat4.zw = vec2(u_xlat6.w * float(0.0799999982), u_xlat6.y * float(0.0799999982));
    u_xlat2.xy = u_xlat0.xy * vec2(0.159999996, 0.159999996);
    u_xlat5.z = u_xlat2.y;
    u_xlat5.w = u_xlat15.y;
    u_xlat2.w = u_xlat15.x;
    u_xlat3.zw = u_xlat4.yz;
    u_xlat0.xyw = vec3(u_xlat3.z + u_xlat5.z, u_xlat3.y + u_xlat5.y, u_xlat3.w + u_xlat5.w);
    u_xlat2.z = u_xlat5.x;
    u_xlat5.xyz = vec3(u_xlat3.z / u_xlat0.x, u_xlat3.y / u_xlat0.y, u_xlat3.w / u_xlat0.w);
    u_xlat4.z = u_xlat3.x;
    u_xlat5.xyz = u_xlat5.xyz + vec3(-2.5, -0.5, 1.5);
    u_xlat3.xyz = u_xlat5.xyz * _ShadowMapTexture_TexelSize.yyy;
    u_xlat5.w = u_xlat3.x;
    u_xlat2 = u_xlat2.zwxz + u_xlat4.zwxz;
    u_xlat4.xyz = vec3(u_xlat4.x / u_xlat2.z, u_xlat4.z / u_xlat2.w, u_xlat4.w / u_xlat2.y);
    u_xlat4.xyz = u_xlat4.xyz + vec3(-2.5, -0.5, 1.5);
    u_xlat5.xyz = u_xlat4.yxz * _ShadowMapTexture_TexelSize.xxx;
    u_xlat4 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.ywxw;
    u_xlat15.xy = u_xlat1.xy * _ShadowMapTexture_TexelSize.xy + u_xlat5.zw;
    vec3 txVec0 = vec3(u_xlat15.xy,u_xlat0.z);
    u_xlat10_15 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    vec3 txVec1 = vec3(u_xlat4.xy,u_xlat0.z);
    u_xlat10_22 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec1, 0.0);
    vec3 txVec2 = vec3(u_xlat4.zw,u_xlat0.z);
    u_xlat10_4 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec2, 0.0);
    u_xlat6 = vec4(u_xlat0.x * u_xlat2.z, u_xlat0.x * u_xlat2.w, u_xlat0.x * u_xlat2.y, u_xlat0.y * u_xlat2.z);
    u_xlat0.x = u_xlat10_4 * u_xlat6.y;
    u_xlat0.x = u_xlat6.x * u_xlat10_22 + u_xlat0.x;
    u_xlat0.x = u_xlat6.z * u_xlat10_15 + u_xlat0.x;
    u_xlat3.w = u_xlat5.y;
    u_xlat4 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat3.wywz;
    u_xlat5.yw = u_xlat3.yz;
    vec3 txVec3 = vec3(u_xlat4.xy,u_xlat0.z);
    u_xlat10_15 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec3, 0.0);
    vec3 txVec4 = vec3(u_xlat4.zw,u_xlat0.z);
    u_xlat10_22 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec4, 0.0);
    u_xlat0.x = u_xlat6.w * u_xlat10_15 + u_xlat0.x;
    u_xlat3 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xyzy;
    u_xlat4 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xwzw;
    vec3 txVec5 = vec3(u_xlat3.xy,u_xlat0.z);
    u_xlat10_1 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec5, 0.0);
    vec3 txVec6 = vec3(u_xlat3.zw,u_xlat0.z);
    u_xlat10_8 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec6, 0.0);
    u_xlat3 = vec4(u_xlat0.y * u_xlat2.x, u_xlat0.y * u_xlat2.y, u_xlat0.w * u_xlat2.z, u_xlat0.w * u_xlat2.w);
    u_xlat7 = u_xlat0.w * u_xlat2.y;
    u_xlat0.x = u_xlat3.x * u_xlat10_1 + u_xlat0.x;
    u_xlat0.x = u_xlat3.y * u_xlat10_8 + u_xlat0.x;
    u_xlat0.x = u_xlat3.z * u_xlat10_22 + u_xlat0.x;
    vec3 txVec7 = vec3(u_xlat4.xy,u_xlat0.z);
    u_xlat10_21 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec7, 0.0);
    vec3 txVec8 = vec3(u_xlat4.zw,u_xlat0.z);
    u_xlat10_14 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec8, 0.0);
    u_xlat0.x = u_xlat3.w * u_xlat10_21 + u_xlat0.x;
    u_xlat0.x = u_xlat7 * u_xlat10_14 + u_xlat0.x;
    u_xlat16_7 = (-_LightShadowData.x) + 1.0;
    u_xlat0 = u_xlat0.xxxx * vec4(u_xlat16_7) + _LightShadowData.xxxx;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SHADOWS_SPLIT_SPHERES" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
in highp vec3 in_TEXCOORD1;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
out highp vec3 vs_TEXCOORD2;
out highp vec3 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
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
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraInvProjection[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraInvProjection[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    vs_TEXCOORD0.zw = u_xlat1.zz + u_xlat1.xw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    vs_TEXCOORD1.xyz = in_TEXCOORD1.xyz;
    u_xlat1.xyz = u_xlat0.xyz + (-hlslcc_mtx4x4unity_CameraInvProjection[2].xyz);
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[2].xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.w = (-u_xlat1.z);
    vs_TEXCOORD2.xyz = u_xlat1.xyw;
    u_xlat0.w = (-u_xlat0.z);
    vs_TEXCOORD3.xyz = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 unity_ShadowSplitSpheres[4];
uniform 	vec4 unity_ShadowSplitSqRadii;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp float u_xlat10_1;
bvec4 u_xlatb1;
vec4 u_xlat2;
vec4 u_xlat3;
mediump vec3 u_xlat16_3;
vec4 u_xlat4;
lowp float u_xlat10_4;
vec4 u_xlat5;
vec4 u_xlat6;
float u_xlat7;
mediump float u_xlat16_7;
vec3 u_xlat8;
lowp float u_xlat10_8;
lowp float u_xlat10_14;
vec2 u_xlat15;
lowp float u_xlat10_15;
lowp float u_xlat10_21;
lowp float u_xlat10_22;
void main()
{
    u_xlat0.z = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat0.xy = vs_TEXCOORD0.zw;
    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraInvProjection[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraInvProjection[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraInvProjection[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraInvProjection[3];
    u_xlat0.xyz = u_xlat0.xyz / u_xlat0.www;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * (-u_xlat0.zzzz) + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat1.xyz = u_xlat0.xyz + (-unity_ShadowSplitSpheres[0].xyz);
    u_xlat1.x = dot(u_xlat1.xyz, u_xlat1.xyz);
    u_xlat2.xyz = u_xlat0.xyz + (-unity_ShadowSplitSpheres[1].xyz);
    u_xlat1.y = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat2.xyz = u_xlat0.xyz + (-unity_ShadowSplitSpheres[2].xyz);
    u_xlat1.z = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat2.xyz = u_xlat0.xyz + (-unity_ShadowSplitSpheres[3].xyz);
    u_xlat1.w = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlatb1 = lessThan(u_xlat1, unity_ShadowSplitSqRadii);
    u_xlat16_3.x = (u_xlatb1.x) ? float(-1.0) : float(-0.0);
    u_xlat16_3.y = (u_xlatb1.y) ? float(-1.0) : float(-0.0);
    u_xlat16_3.z = (u_xlatb1.z) ? float(-1.0) : float(-0.0);
    u_xlat1 = mix(vec4(0.0, 0.0, 0.0, 0.0), vec4(1.0, 1.0, 1.0, 1.0), vec4(u_xlatb1));
    u_xlat16_3.xyz = vec3(u_xlat16_3.x + u_xlat1.y, u_xlat16_3.y + u_xlat1.z, u_xlat16_3.z + u_xlat1.w);
    u_xlat16_3.xyz = max(u_xlat16_3.xyz, vec3(0.0, 0.0, 0.0));
    u_xlat8.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[5].xyz;
    u_xlat8.xyz = hlslcc_mtx4x4unity_WorldToShadow[4].xyz * u_xlat0.xxx + u_xlat8.xyz;
    u_xlat8.xyz = hlslcc_mtx4x4unity_WorldToShadow[6].xyz * u_xlat0.zzz + u_xlat8.xyz;
    u_xlat8.xyz = hlslcc_mtx4x4unity_WorldToShadow[7].xyz * u_xlat0.www + u_xlat8.xyz;
    u_xlat8.xyz = u_xlat16_3.xxx * u_xlat8.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[3].xyz * u_xlat0.www + u_xlat2.xyz;
    u_xlat1.xyz = u_xlat2.xyz * u_xlat1.xxx + u_xlat8.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[9].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[8].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[10].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[11].xyz * u_xlat0.www + u_xlat2.xyz;
    u_xlat1.xyz = u_xlat2.xyz * u_xlat16_3.yyy + u_xlat1.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[13].xyz;
    u_xlat2.xyz = hlslcc_mtx4x4unity_WorldToShadow[12].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[14].xyz * u_xlat0.zzz + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[15].xyz * u_xlat0.www + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz * u_xlat16_3.zzz + u_xlat1.xyz;
    u_xlat1.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + vec2(0.5, 0.5);
    u_xlat1.xy = floor(u_xlat1.xy);
    u_xlat0.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + (-u_xlat1.xy);
    u_xlat15.xy = max(u_xlat0.xy, vec2(0.0, 0.0));
    u_xlat2 = u_xlat0.xxyy + vec4(0.5, 1.0, 0.5, 1.0);
    u_xlat15.xy = (-u_xlat15.xy) * u_xlat15.xy + u_xlat2.yw;
    u_xlat15.xy = u_xlat15.xy + vec2(1.0, 1.0);
    u_xlat3.xy = u_xlat15.xy * vec2(0.159999996, 0.159999996);
    u_xlat15.xy = min(u_xlat0.xy, vec2(0.0, 0.0));
    u_xlat4.xy = (-u_xlat0.xy) + vec2(1.0, 1.0);
    u_xlat15.xy = (-u_xlat15.xy) * u_xlat15.xy + u_xlat4.xy;
    u_xlat4.xy = u_xlat4.xy * vec2(0.159999996, 0.159999996);
    u_xlat15.xy = u_xlat15.xy + vec2(1.0, 1.0);
    u_xlat5.xy = u_xlat15.xy * vec2(0.159999996, 0.159999996);
    u_xlat6 = u_xlat2.xxzz * u_xlat2.xxzz;
    u_xlat15.xy = vec2(u_xlat2.y * float(0.159999996), u_xlat2.w * float(0.159999996));
    u_xlat0.xy = u_xlat6.xz * vec2(0.5, 0.5) + (-u_xlat0.xy);
    u_xlat4.zw = vec2(u_xlat6.w * float(0.0799999982), u_xlat6.y * float(0.0799999982));
    u_xlat2.xy = u_xlat0.xy * vec2(0.159999996, 0.159999996);
    u_xlat5.z = u_xlat2.y;
    u_xlat5.w = u_xlat15.y;
    u_xlat2.w = u_xlat15.x;
    u_xlat3.zw = u_xlat4.yz;
    u_xlat0.xyw = vec3(u_xlat3.z + u_xlat5.z, u_xlat3.y + u_xlat5.y, u_xlat3.w + u_xlat5.w);
    u_xlat2.z = u_xlat5.x;
    u_xlat5.xyz = vec3(u_xlat3.z / u_xlat0.x, u_xlat3.y / u_xlat0.y, u_xlat3.w / u_xlat0.w);
    u_xlat4.z = u_xlat3.x;
    u_xlat5.xyz = u_xlat5.xyz + vec3(-2.5, -0.5, 1.5);
    u_xlat3.xyz = u_xlat5.xyz * _ShadowMapTexture_TexelSize.yyy;
    u_xlat5.w = u_xlat3.x;
    u_xlat2 = u_xlat2.zwxz + u_xlat4.zwxz;
    u_xlat4.xyz = vec3(u_xlat4.x / u_xlat2.z, u_xlat4.z / u_xlat2.w, u_xlat4.w / u_xlat2.y);
    u_xlat4.xyz = u_xlat4.xyz + vec3(-2.5, -0.5, 1.5);
    u_xlat5.xyz = u_xlat4.yxz * _ShadowMapTexture_TexelSize.xxx;
    u_xlat4 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.ywxw;
    u_xlat15.xy = u_xlat1.xy * _ShadowMapTexture_TexelSize.xy + u_xlat5.zw;
    vec3 txVec0 = vec3(u_xlat15.xy,u_xlat0.z);
    u_xlat10_15 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    vec3 txVec1 = vec3(u_xlat4.xy,u_xlat0.z);
    u_xlat10_22 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec1, 0.0);
    vec3 txVec2 = vec3(u_xlat4.zw,u_xlat0.z);
    u_xlat10_4 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec2, 0.0);
    u_xlat6 = vec4(u_xlat0.x * u_xlat2.z, u_xlat0.x * u_xlat2.w, u_xlat0.x * u_xlat2.y, u_xlat0.y * u_xlat2.z);
    u_xlat0.x = u_xlat10_4 * u_xlat6.y;
    u_xlat0.x = u_xlat6.x * u_xlat10_22 + u_xlat0.x;
    u_xlat0.x = u_xlat6.z * u_xlat10_15 + u_xlat0.x;
    u_xlat3.w = u_xlat5.y;
    u_xlat4 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat3.wywz;
    u_xlat5.yw = u_xlat3.yz;
    vec3 txVec3 = vec3(u_xlat4.xy,u_xlat0.z);
    u_xlat10_15 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec3, 0.0);
    vec3 txVec4 = vec3(u_xlat4.zw,u_xlat0.z);
    u_xlat10_22 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec4, 0.0);
    u_xlat0.x = u_xlat6.w * u_xlat10_15 + u_xlat0.x;
    u_xlat3 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xyzy;
    u_xlat4 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xwzw;
    vec3 txVec5 = vec3(u_xlat3.xy,u_xlat0.z);
    u_xlat10_1 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec5, 0.0);
    vec3 txVec6 = vec3(u_xlat3.zw,u_xlat0.z);
    u_xlat10_8 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec6, 0.0);
    u_xlat3 = vec4(u_xlat0.y * u_xlat2.x, u_xlat0.y * u_xlat2.y, u_xlat0.w * u_xlat2.z, u_xlat0.w * u_xlat2.w);
    u_xlat7 = u_xlat0.w * u_xlat2.y;
    u_xlat0.x = u_xlat3.x * u_xlat10_1 + u_xlat0.x;
    u_xlat0.x = u_xlat3.y * u_xlat10_8 + u_xlat0.x;
    u_xlat0.x = u_xlat3.z * u_xlat10_22 + u_xlat0.x;
    vec3 txVec7 = vec3(u_xlat4.xy,u_xlat0.z);
    u_xlat10_21 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec7, 0.0);
    vec3 txVec8 = vec3(u_xlat4.zw,u_xlat0.z);
    u_xlat10_14 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec8, 0.0);
    u_xlat0.x = u_xlat3.w * u_xlat10_21 + u_xlat0.x;
    u_xlat0.x = u_xlat7 * u_xlat10_14 + u_xlat0.x;
    u_xlat16_7 = (-_LightShadowData.x) + 1.0;
    u_xlat0 = u_xlat0.xxxx * vec4(u_xlat16_7) + _LightShadowData.xxxx;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "SHADOWS_SINGLE_CASCADE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec3 orthoPosFar_1;
  highp vec3 orthoPosNear_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _glesVertex.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  clipPos_3.xzw = tmpvar_5.xzw;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 o_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_5.zw;
  tmpvar_4.zw = o_7.xy;
  clipPos_3.y = (tmpvar_5.y * _ProjectionParams.x);
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(-1.0, 1.0);
  tmpvar_10.xy = clipPos_3.xy;
  highp vec3 tmpvar_11;
  tmpvar_11 = (unity_CameraInvProjection * tmpvar_10).xyz;
  orthoPosNear_2.xy = tmpvar_11.xy;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(1.0, 1.0);
  tmpvar_12.xy = clipPos_3.xy;
  highp vec3 tmpvar_13;
  tmpvar_13 = (unity_CameraInvProjection * tmpvar_12).xyz;
  orthoPosFar_1.xy = tmpvar_13.xy;
  orthoPosNear_2.z = -(tmpvar_11.z);
  orthoPosFar_1.z = -(tmpvar_13.z);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = _glesMultiTexCoord1.xyz;
  xlv_TEXCOORD2 = orthoPosNear_2;
  xlv_TEXCOORD3 = orthoPosFar_1;
}


#endif
#ifdef FRAGMENT
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec4 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 camPos_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xy = xlv_TEXCOORD0.zw;
  tmpvar_4.z = texture2D (_CameraDepthTexture, xlv_TEXCOORD0.xy).x;
  clipPos_3.w = tmpvar_4.w;
  clipPos_3.xyz = ((2.0 * tmpvar_4.xyz) - 1.0);
  highp vec4 tmpvar_5;
  tmpvar_5 = (unity_CameraInvProjection * clipPos_3);
  camPos_2.w = tmpvar_5.w;
  camPos_2.xyz = (tmpvar_5.xyz / tmpvar_5.w);
  camPos_2.z = -(camPos_2.z);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = camPos_2.xyz;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = (unity_WorldToShadow[0] * (unity_CameraToWorld * tmpvar_6)).xyz;
  mediump float shadow_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = _ShadowMapTexture_TexelSize.xy;
  shadow_8 = 0.0;
  highp vec3 tmpvar_10;
  tmpvar_10.xy = (tmpvar_7.xy - _ShadowMapTexture_TexelSize.xy);
  tmpvar_10.z = tmpvar_7.z;
  highp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_ShadowMapTexture, tmpvar_10.xy);
  mediump float tmpvar_12;
  if ((tmpvar_11.x < tmpvar_7.z)) {
    tmpvar_12 = 0.0;
  } else {
    tmpvar_12 = 1.0;
  };
  shadow_8 = tmpvar_12;
  highp vec2 tmpvar_13;
  tmpvar_13.x = 0.0;
  tmpvar_13.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_14;
  tmpvar_14.xy = (tmpvar_7.xy + tmpvar_13);
  tmpvar_14.z = tmpvar_7.z;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_ShadowMapTexture, tmpvar_14.xy);
  highp float tmpvar_16;
  if ((tmpvar_15.x < tmpvar_7.z)) {
    tmpvar_16 = 0.0;
  } else {
    tmpvar_16 = 1.0;
  };
  shadow_8 = (tmpvar_12 + tmpvar_16);
  highp vec2 tmpvar_17;
  tmpvar_17.x = tmpvar_9.x;
  tmpvar_17.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_18;
  tmpvar_18.xy = (tmpvar_7.xy + tmpvar_17);
  tmpvar_18.z = tmpvar_7.z;
  highp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_ShadowMapTexture, tmpvar_18.xy);
  highp float tmpvar_20;
  if ((tmpvar_19.x < tmpvar_7.z)) {
    tmpvar_20 = 0.0;
  } else {
    tmpvar_20 = 1.0;
  };
  shadow_8 = (shadow_8 + tmpvar_20);
  highp vec2 tmpvar_21;
  tmpvar_21.y = 0.0;
  tmpvar_21.x = -(_ShadowMapTexture_TexelSize.x);
  highp vec3 tmpvar_22;
  tmpvar_22.xy = (tmpvar_7.xy + tmpvar_21);
  tmpvar_22.z = tmpvar_7.z;
  highp vec4 tmpvar_23;
  tmpvar_23 = texture2D (_ShadowMapTexture, tmpvar_22.xy);
  highp float tmpvar_24;
  if ((tmpvar_23.x < tmpvar_7.z)) {
    tmpvar_24 = 0.0;
  } else {
    tmpvar_24 = 1.0;
  };
  shadow_8 = (shadow_8 + tmpvar_24);
  highp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_ShadowMapTexture, tmpvar_7.xy);
  highp float tmpvar_26;
  if ((tmpvar_25.x < tmpvar_7.z)) {
    tmpvar_26 = 0.0;
  } else {
    tmpvar_26 = 1.0;
  };
  shadow_8 = (shadow_8 + tmpvar_26);
  highp vec2 tmpvar_27;
  tmpvar_27.y = 0.0;
  tmpvar_27.x = tmpvar_9.x;
  highp vec3 tmpvar_28;
  tmpvar_28.xy = (tmpvar_7.xy + tmpvar_27);
  tmpvar_28.z = tmpvar_7.z;
  highp vec4 tmpvar_29;
  tmpvar_29 = texture2D (_ShadowMapTexture, tmpvar_28.xy);
  highp float tmpvar_30;
  if ((tmpvar_29.x < tmpvar_7.z)) {
    tmpvar_30 = 0.0;
  } else {
    tmpvar_30 = 1.0;
  };
  shadow_8 = (shadow_8 + tmpvar_30);
  highp vec2 tmpvar_31;
  tmpvar_31.x = -(_ShadowMapTexture_TexelSize.x);
  tmpvar_31.y = tmpvar_9.y;
  highp vec3 tmpvar_32;
  tmpvar_32.xy = (tmpvar_7.xy + tmpvar_31);
  tmpvar_32.z = tmpvar_7.z;
  highp vec4 tmpvar_33;
  tmpvar_33 = texture2D (_ShadowMapTexture, tmpvar_32.xy);
  highp float tmpvar_34;
  if ((tmpvar_33.x < tmpvar_7.z)) {
    tmpvar_34 = 0.0;
  } else {
    tmpvar_34 = 1.0;
  };
  shadow_8 = (shadow_8 + tmpvar_34);
  highp vec2 tmpvar_35;
  tmpvar_35.x = 0.0;
  tmpvar_35.y = tmpvar_9.y;
  highp vec3 tmpvar_36;
  tmpvar_36.xy = (tmpvar_7.xy + tmpvar_35);
  tmpvar_36.z = tmpvar_7.z;
  highp vec4 tmpvar_37;
  tmpvar_37 = texture2D (_ShadowMapTexture, tmpvar_36.xy);
  highp float tmpvar_38;
  if ((tmpvar_37.x < tmpvar_7.z)) {
    tmpvar_38 = 0.0;
  } else {
    tmpvar_38 = 1.0;
  };
  shadow_8 = (shadow_8 + tmpvar_38);
  highp vec3 tmpvar_39;
  tmpvar_39.xy = (tmpvar_7.xy + _ShadowMapTexture_TexelSize.xy);
  tmpvar_39.z = tmpvar_7.z;
  highp vec4 tmpvar_40;
  tmpvar_40 = texture2D (_ShadowMapTexture, tmpvar_39.xy);
  highp float tmpvar_41;
  if ((tmpvar_40.x < tmpvar_7.z)) {
    tmpvar_41 = 0.0;
  } else {
    tmpvar_41 = 1.0;
  };
  shadow_8 = (shadow_8 + tmpvar_41);
  shadow_8 = (shadow_8 / 9.0);
  mediump vec4 tmpvar_42;
  tmpvar_42 = vec4(mix (_LightShadowData.x, 1.0, shadow_8));
  tmpvar_1 = tmpvar_42;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "SHADOWS_SINGLE_CASCADE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec3 orthoPosFar_1;
  highp vec3 orthoPosNear_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _glesVertex.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  clipPos_3.xzw = tmpvar_5.xzw;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 o_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_5.zw;
  tmpvar_4.zw = o_7.xy;
  clipPos_3.y = (tmpvar_5.y * _ProjectionParams.x);
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(-1.0, 1.0);
  tmpvar_10.xy = clipPos_3.xy;
  highp vec3 tmpvar_11;
  tmpvar_11 = (unity_CameraInvProjection * tmpvar_10).xyz;
  orthoPosNear_2.xy = tmpvar_11.xy;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(1.0, 1.0);
  tmpvar_12.xy = clipPos_3.xy;
  highp vec3 tmpvar_13;
  tmpvar_13 = (unity_CameraInvProjection * tmpvar_12).xyz;
  orthoPosFar_1.xy = tmpvar_13.xy;
  orthoPosNear_2.z = -(tmpvar_11.z);
  orthoPosFar_1.z = -(tmpvar_13.z);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = _glesMultiTexCoord1.xyz;
  xlv_TEXCOORD2 = orthoPosNear_2;
  xlv_TEXCOORD3 = orthoPosFar_1;
}


#endif
#ifdef FRAGMENT
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec4 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 camPos_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xy = xlv_TEXCOORD0.zw;
  tmpvar_4.z = texture2D (_CameraDepthTexture, xlv_TEXCOORD0.xy).x;
  clipPos_3.w = tmpvar_4.w;
  clipPos_3.xyz = ((2.0 * tmpvar_4.xyz) - 1.0);
  highp vec4 tmpvar_5;
  tmpvar_5 = (unity_CameraInvProjection * clipPos_3);
  camPos_2.w = tmpvar_5.w;
  camPos_2.xyz = (tmpvar_5.xyz / tmpvar_5.w);
  camPos_2.z = -(camPos_2.z);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = camPos_2.xyz;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = (unity_WorldToShadow[0] * (unity_CameraToWorld * tmpvar_6)).xyz;
  mediump float shadow_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = _ShadowMapTexture_TexelSize.xy;
  shadow_8 = 0.0;
  highp vec3 tmpvar_10;
  tmpvar_10.xy = (tmpvar_7.xy - _ShadowMapTexture_TexelSize.xy);
  tmpvar_10.z = tmpvar_7.z;
  highp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_ShadowMapTexture, tmpvar_10.xy);
  mediump float tmpvar_12;
  if ((tmpvar_11.x < tmpvar_7.z)) {
    tmpvar_12 = 0.0;
  } else {
    tmpvar_12 = 1.0;
  };
  shadow_8 = tmpvar_12;
  highp vec2 tmpvar_13;
  tmpvar_13.x = 0.0;
  tmpvar_13.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_14;
  tmpvar_14.xy = (tmpvar_7.xy + tmpvar_13);
  tmpvar_14.z = tmpvar_7.z;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_ShadowMapTexture, tmpvar_14.xy);
  highp float tmpvar_16;
  if ((tmpvar_15.x < tmpvar_7.z)) {
    tmpvar_16 = 0.0;
  } else {
    tmpvar_16 = 1.0;
  };
  shadow_8 = (tmpvar_12 + tmpvar_16);
  highp vec2 tmpvar_17;
  tmpvar_17.x = tmpvar_9.x;
  tmpvar_17.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_18;
  tmpvar_18.xy = (tmpvar_7.xy + tmpvar_17);
  tmpvar_18.z = tmpvar_7.z;
  highp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_ShadowMapTexture, tmpvar_18.xy);
  highp float tmpvar_20;
  if ((tmpvar_19.x < tmpvar_7.z)) {
    tmpvar_20 = 0.0;
  } else {
    tmpvar_20 = 1.0;
  };
  shadow_8 = (shadow_8 + tmpvar_20);
  highp vec2 tmpvar_21;
  tmpvar_21.y = 0.0;
  tmpvar_21.x = -(_ShadowMapTexture_TexelSize.x);
  highp vec3 tmpvar_22;
  tmpvar_22.xy = (tmpvar_7.xy + tmpvar_21);
  tmpvar_22.z = tmpvar_7.z;
  highp vec4 tmpvar_23;
  tmpvar_23 = texture2D (_ShadowMapTexture, tmpvar_22.xy);
  highp float tmpvar_24;
  if ((tmpvar_23.x < tmpvar_7.z)) {
    tmpvar_24 = 0.0;
  } else {
    tmpvar_24 = 1.0;
  };
  shadow_8 = (shadow_8 + tmpvar_24);
  highp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_ShadowMapTexture, tmpvar_7.xy);
  highp float tmpvar_26;
  if ((tmpvar_25.x < tmpvar_7.z)) {
    tmpvar_26 = 0.0;
  } else {
    tmpvar_26 = 1.0;
  };
  shadow_8 = (shadow_8 + tmpvar_26);
  highp vec2 tmpvar_27;
  tmpvar_27.y = 0.0;
  tmpvar_27.x = tmpvar_9.x;
  highp vec3 tmpvar_28;
  tmpvar_28.xy = (tmpvar_7.xy + tmpvar_27);
  tmpvar_28.z = tmpvar_7.z;
  highp vec4 tmpvar_29;
  tmpvar_29 = texture2D (_ShadowMapTexture, tmpvar_28.xy);
  highp float tmpvar_30;
  if ((tmpvar_29.x < tmpvar_7.z)) {
    tmpvar_30 = 0.0;
  } else {
    tmpvar_30 = 1.0;
  };
  shadow_8 = (shadow_8 + tmpvar_30);
  highp vec2 tmpvar_31;
  tmpvar_31.x = -(_ShadowMapTexture_TexelSize.x);
  tmpvar_31.y = tmpvar_9.y;
  highp vec3 tmpvar_32;
  tmpvar_32.xy = (tmpvar_7.xy + tmpvar_31);
  tmpvar_32.z = tmpvar_7.z;
  highp vec4 tmpvar_33;
  tmpvar_33 = texture2D (_ShadowMapTexture, tmpvar_32.xy);
  highp float tmpvar_34;
  if ((tmpvar_33.x < tmpvar_7.z)) {
    tmpvar_34 = 0.0;
  } else {
    tmpvar_34 = 1.0;
  };
  shadow_8 = (shadow_8 + tmpvar_34);
  highp vec2 tmpvar_35;
  tmpvar_35.x = 0.0;
  tmpvar_35.y = tmpvar_9.y;
  highp vec3 tmpvar_36;
  tmpvar_36.xy = (tmpvar_7.xy + tmpvar_35);
  tmpvar_36.z = tmpvar_7.z;
  highp vec4 tmpvar_37;
  tmpvar_37 = texture2D (_ShadowMapTexture, tmpvar_36.xy);
  highp float tmpvar_38;
  if ((tmpvar_37.x < tmpvar_7.z)) {
    tmpvar_38 = 0.0;
  } else {
    tmpvar_38 = 1.0;
  };
  shadow_8 = (shadow_8 + tmpvar_38);
  highp vec3 tmpvar_39;
  tmpvar_39.xy = (tmpvar_7.xy + _ShadowMapTexture_TexelSize.xy);
  tmpvar_39.z = tmpvar_7.z;
  highp vec4 tmpvar_40;
  tmpvar_40 = texture2D (_ShadowMapTexture, tmpvar_39.xy);
  highp float tmpvar_41;
  if ((tmpvar_40.x < tmpvar_7.z)) {
    tmpvar_41 = 0.0;
  } else {
    tmpvar_41 = 1.0;
  };
  shadow_8 = (shadow_8 + tmpvar_41);
  shadow_8 = (shadow_8 / 9.0);
  mediump vec4 tmpvar_42;
  tmpvar_42 = vec4(mix (_LightShadowData.x, 1.0, shadow_8));
  tmpvar_1 = tmpvar_42;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "SHADOWS_SINGLE_CASCADE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec3 orthoPosFar_1;
  highp vec3 orthoPosNear_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _glesVertex.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  clipPos_3.xzw = tmpvar_5.xzw;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 o_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_5.zw;
  tmpvar_4.zw = o_7.xy;
  clipPos_3.y = (tmpvar_5.y * _ProjectionParams.x);
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(-1.0, 1.0);
  tmpvar_10.xy = clipPos_3.xy;
  highp vec3 tmpvar_11;
  tmpvar_11 = (unity_CameraInvProjection * tmpvar_10).xyz;
  orthoPosNear_2.xy = tmpvar_11.xy;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(1.0, 1.0);
  tmpvar_12.xy = clipPos_3.xy;
  highp vec3 tmpvar_13;
  tmpvar_13 = (unity_CameraInvProjection * tmpvar_12).xyz;
  orthoPosFar_1.xy = tmpvar_13.xy;
  orthoPosNear_2.z = -(tmpvar_11.z);
  orthoPosFar_1.z = -(tmpvar_13.z);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = _glesMultiTexCoord1.xyz;
  xlv_TEXCOORD2 = orthoPosNear_2;
  xlv_TEXCOORD3 = orthoPosFar_1;
}


#endif
#ifdef FRAGMENT
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec4 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 camPos_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xy = xlv_TEXCOORD0.zw;
  tmpvar_4.z = texture2D (_CameraDepthTexture, xlv_TEXCOORD0.xy).x;
  clipPos_3.w = tmpvar_4.w;
  clipPos_3.xyz = ((2.0 * tmpvar_4.xyz) - 1.0);
  highp vec4 tmpvar_5;
  tmpvar_5 = (unity_CameraInvProjection * clipPos_3);
  camPos_2.w = tmpvar_5.w;
  camPos_2.xyz = (tmpvar_5.xyz / tmpvar_5.w);
  camPos_2.z = -(camPos_2.z);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = camPos_2.xyz;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = (unity_WorldToShadow[0] * (unity_CameraToWorld * tmpvar_6)).xyz;
  mediump float shadow_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = _ShadowMapTexture_TexelSize.xy;
  shadow_8 = 0.0;
  highp vec3 tmpvar_10;
  tmpvar_10.xy = (tmpvar_7.xy - _ShadowMapTexture_TexelSize.xy);
  tmpvar_10.z = tmpvar_7.z;
  highp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_ShadowMapTexture, tmpvar_10.xy);
  mediump float tmpvar_12;
  if ((tmpvar_11.x < tmpvar_7.z)) {
    tmpvar_12 = 0.0;
  } else {
    tmpvar_12 = 1.0;
  };
  shadow_8 = tmpvar_12;
  highp vec2 tmpvar_13;
  tmpvar_13.x = 0.0;
  tmpvar_13.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_14;
  tmpvar_14.xy = (tmpvar_7.xy + tmpvar_13);
  tmpvar_14.z = tmpvar_7.z;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_ShadowMapTexture, tmpvar_14.xy);
  highp float tmpvar_16;
  if ((tmpvar_15.x < tmpvar_7.z)) {
    tmpvar_16 = 0.0;
  } else {
    tmpvar_16 = 1.0;
  };
  shadow_8 = (tmpvar_12 + tmpvar_16);
  highp vec2 tmpvar_17;
  tmpvar_17.x = tmpvar_9.x;
  tmpvar_17.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_18;
  tmpvar_18.xy = (tmpvar_7.xy + tmpvar_17);
  tmpvar_18.z = tmpvar_7.z;
  highp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_ShadowMapTexture, tmpvar_18.xy);
  highp float tmpvar_20;
  if ((tmpvar_19.x < tmpvar_7.z)) {
    tmpvar_20 = 0.0;
  } else {
    tmpvar_20 = 1.0;
  };
  shadow_8 = (shadow_8 + tmpvar_20);
  highp vec2 tmpvar_21;
  tmpvar_21.y = 0.0;
  tmpvar_21.x = -(_ShadowMapTexture_TexelSize.x);
  highp vec3 tmpvar_22;
  tmpvar_22.xy = (tmpvar_7.xy + tmpvar_21);
  tmpvar_22.z = tmpvar_7.z;
  highp vec4 tmpvar_23;
  tmpvar_23 = texture2D (_ShadowMapTexture, tmpvar_22.xy);
  highp float tmpvar_24;
  if ((tmpvar_23.x < tmpvar_7.z)) {
    tmpvar_24 = 0.0;
  } else {
    tmpvar_24 = 1.0;
  };
  shadow_8 = (shadow_8 + tmpvar_24);
  highp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_ShadowMapTexture, tmpvar_7.xy);
  highp float tmpvar_26;
  if ((tmpvar_25.x < tmpvar_7.z)) {
    tmpvar_26 = 0.0;
  } else {
    tmpvar_26 = 1.0;
  };
  shadow_8 = (shadow_8 + tmpvar_26);
  highp vec2 tmpvar_27;
  tmpvar_27.y = 0.0;
  tmpvar_27.x = tmpvar_9.x;
  highp vec3 tmpvar_28;
  tmpvar_28.xy = (tmpvar_7.xy + tmpvar_27);
  tmpvar_28.z = tmpvar_7.z;
  highp vec4 tmpvar_29;
  tmpvar_29 = texture2D (_ShadowMapTexture, tmpvar_28.xy);
  highp float tmpvar_30;
  if ((tmpvar_29.x < tmpvar_7.z)) {
    tmpvar_30 = 0.0;
  } else {
    tmpvar_30 = 1.0;
  };
  shadow_8 = (shadow_8 + tmpvar_30);
  highp vec2 tmpvar_31;
  tmpvar_31.x = -(_ShadowMapTexture_TexelSize.x);
  tmpvar_31.y = tmpvar_9.y;
  highp vec3 tmpvar_32;
  tmpvar_32.xy = (tmpvar_7.xy + tmpvar_31);
  tmpvar_32.z = tmpvar_7.z;
  highp vec4 tmpvar_33;
  tmpvar_33 = texture2D (_ShadowMapTexture, tmpvar_32.xy);
  highp float tmpvar_34;
  if ((tmpvar_33.x < tmpvar_7.z)) {
    tmpvar_34 = 0.0;
  } else {
    tmpvar_34 = 1.0;
  };
  shadow_8 = (shadow_8 + tmpvar_34);
  highp vec2 tmpvar_35;
  tmpvar_35.x = 0.0;
  tmpvar_35.y = tmpvar_9.y;
  highp vec3 tmpvar_36;
  tmpvar_36.xy = (tmpvar_7.xy + tmpvar_35);
  tmpvar_36.z = tmpvar_7.z;
  highp vec4 tmpvar_37;
  tmpvar_37 = texture2D (_ShadowMapTexture, tmpvar_36.xy);
  highp float tmpvar_38;
  if ((tmpvar_37.x < tmpvar_7.z)) {
    tmpvar_38 = 0.0;
  } else {
    tmpvar_38 = 1.0;
  };
  shadow_8 = (shadow_8 + tmpvar_38);
  highp vec3 tmpvar_39;
  tmpvar_39.xy = (tmpvar_7.xy + _ShadowMapTexture_TexelSize.xy);
  tmpvar_39.z = tmpvar_7.z;
  highp vec4 tmpvar_40;
  tmpvar_40 = texture2D (_ShadowMapTexture, tmpvar_39.xy);
  highp float tmpvar_41;
  if ((tmpvar_40.x < tmpvar_7.z)) {
    tmpvar_41 = 0.0;
  } else {
    tmpvar_41 = 1.0;
  };
  shadow_8 = (shadow_8 + tmpvar_41);
  shadow_8 = (shadow_8 / 9.0);
  mediump vec4 tmpvar_42;
  tmpvar_42 = vec4(mix (_LightShadowData.x, 1.0, shadow_8));
  tmpvar_1 = tmpvar_42;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SHADOWS_SINGLE_CASCADE" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
in highp vec3 in_TEXCOORD1;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
out highp vec3 vs_TEXCOORD2;
out highp vec3 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
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
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraInvProjection[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraInvProjection[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    vs_TEXCOORD0.zw = u_xlat1.zz + u_xlat1.xw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    vs_TEXCOORD1.xyz = in_TEXCOORD1.xyz;
    u_xlat1.xyz = u_xlat0.xyz + (-hlslcc_mtx4x4unity_CameraInvProjection[2].xyz);
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[2].xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.w = (-u_xlat1.z);
    vs_TEXCOORD2.xyz = u_xlat1.xyw;
    u_xlat0.w = (-u_xlat0.z);
    vs_TEXCOORD3.xyz = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp float u_xlat10_1;
vec4 u_xlat2;
lowp float u_xlat10_2;
vec4 u_xlat3;
vec4 u_xlat4;
vec4 u_xlat5;
vec4 u_xlat6;
float u_xlat7;
mediump float u_xlat16_7;
lowp float u_xlat10_8;
lowp float u_xlat10_14;
vec2 u_xlat15;
lowp float u_xlat10_15;
lowp float u_xlat10_21;
lowp float u_xlat10_22;
void main()
{
    u_xlat0.z = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat0.xy = vs_TEXCOORD0.zw;
    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraInvProjection[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraInvProjection[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraInvProjection[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraInvProjection[3];
    u_xlat0.xyz = u_xlat0.xyz / u_xlat0.www;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * (-u_xlat0.zzzz) + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat1.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[3].xyz * u_xlat0.www + u_xlat0.xyz;
    u_xlat1.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + vec2(0.5, 0.5);
    u_xlat1.xy = floor(u_xlat1.xy);
    u_xlat0.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + (-u_xlat1.xy);
    u_xlat15.xy = min(u_xlat0.xy, vec2(0.0, 0.0));
    u_xlat2.xy = (-u_xlat0.xy) + vec2(1.0, 1.0);
    u_xlat15.xy = (-u_xlat15.xy) * u_xlat15.xy + u_xlat2.xy;
    u_xlat2.xy = u_xlat2.xy * vec2(0.159999996, 0.159999996);
    u_xlat15.xy = u_xlat15.xy + vec2(1.0, 1.0);
    u_xlat3.xy = u_xlat15.xy * vec2(0.159999996, 0.159999996);
    u_xlat15.xy = max(u_xlat0.xy, vec2(0.0, 0.0));
    u_xlat4 = u_xlat0.xxyy + vec4(0.5, 1.0, 0.5, 1.0);
    u_xlat15.xy = (-u_xlat15.xy) * u_xlat15.xy + u_xlat4.yw;
    u_xlat15.xy = u_xlat15.xy + vec2(1.0, 1.0);
    u_xlat5.xy = u_xlat15.xy * vec2(0.159999996, 0.159999996);
    u_xlat6 = u_xlat4.xxzz * u_xlat4.xxzz;
    u_xlat15.xy = vec2(u_xlat4.y * float(0.159999996), u_xlat4.w * float(0.159999996));
    u_xlat0.xy = u_xlat6.xz * vec2(0.5, 0.5) + (-u_xlat0.xy);
    u_xlat2.zw = vec2(u_xlat6.w * float(0.0799999982), u_xlat6.y * float(0.0799999982));
    u_xlat4.xy = u_xlat0.xy * vec2(0.159999996, 0.159999996);
    u_xlat3.z = u_xlat4.y;
    u_xlat3.w = u_xlat15.y;
    u_xlat4.w = u_xlat15.x;
    u_xlat5.zw = u_xlat2.yz;
    u_xlat0.xyw = vec3(u_xlat3.z + u_xlat5.z, u_xlat3.y + u_xlat5.y, u_xlat3.w + u_xlat5.w);
    u_xlat4.z = u_xlat3.x;
    u_xlat3.xyz = vec3(u_xlat5.z / u_xlat0.x, u_xlat5.y / u_xlat0.y, u_xlat5.w / u_xlat0.w);
    u_xlat2.z = u_xlat5.x;
    u_xlat3.xyz = u_xlat3.xyz + vec3(-2.5, -0.5, 1.5);
    u_xlat3.xyz = u_xlat3.xyz * _ShadowMapTexture_TexelSize.yyy;
    u_xlat5.w = u_xlat3.x;
    u_xlat4 = u_xlat2.zwxz + u_xlat4.zwxz;
    u_xlat2.xyz = vec3(u_xlat2.x / u_xlat4.z, u_xlat2.z / u_xlat4.w, u_xlat2.w / u_xlat4.y);
    u_xlat2.xyz = u_xlat2.xyz + vec3(-2.5, -0.5, 1.5);
    u_xlat5.xyz = u_xlat2.yxz * _ShadowMapTexture_TexelSize.xxx;
    u_xlat2 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.ywxw;
    u_xlat15.xy = u_xlat1.xy * _ShadowMapTexture_TexelSize.xy + u_xlat5.zw;
    vec3 txVec0 = vec3(u_xlat15.xy,u_xlat0.z);
    u_xlat10_15 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    vec3 txVec1 = vec3(u_xlat2.xy,u_xlat0.z);
    u_xlat10_22 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec1, 0.0);
    vec3 txVec2 = vec3(u_xlat2.zw,u_xlat0.z);
    u_xlat10_2 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec2, 0.0);
    u_xlat6 = vec4(u_xlat0.x * u_xlat4.z, u_xlat0.x * u_xlat4.w, u_xlat0.x * u_xlat4.y, u_xlat0.y * u_xlat4.z);
    u_xlat0.x = u_xlat10_2 * u_xlat6.y;
    u_xlat0.x = u_xlat6.x * u_xlat10_22 + u_xlat0.x;
    u_xlat0.x = u_xlat6.z * u_xlat10_15 + u_xlat0.x;
    u_xlat3.w = u_xlat5.y;
    u_xlat2 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat3.wywz;
    u_xlat5.yw = u_xlat3.yz;
    vec3 txVec3 = vec3(u_xlat2.xy,u_xlat0.z);
    u_xlat10_15 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec3, 0.0);
    vec3 txVec4 = vec3(u_xlat2.zw,u_xlat0.z);
    u_xlat10_22 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec4, 0.0);
    u_xlat0.x = u_xlat6.w * u_xlat10_15 + u_xlat0.x;
    u_xlat2 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xyzy;
    u_xlat3 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xwzw;
    vec3 txVec5 = vec3(u_xlat2.xy,u_xlat0.z);
    u_xlat10_1 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec5, 0.0);
    vec3 txVec6 = vec3(u_xlat2.zw,u_xlat0.z);
    u_xlat10_8 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec6, 0.0);
    u_xlat2 = vec4(u_xlat0.y * u_xlat4.x, u_xlat0.y * u_xlat4.y, u_xlat0.w * u_xlat4.z, u_xlat0.w * u_xlat4.w);
    u_xlat7 = u_xlat0.w * u_xlat4.y;
    u_xlat0.x = u_xlat2.x * u_xlat10_1 + u_xlat0.x;
    u_xlat0.x = u_xlat2.y * u_xlat10_8 + u_xlat0.x;
    u_xlat0.x = u_xlat2.z * u_xlat10_22 + u_xlat0.x;
    vec3 txVec7 = vec3(u_xlat3.xy,u_xlat0.z);
    u_xlat10_21 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec7, 0.0);
    vec3 txVec8 = vec3(u_xlat3.zw,u_xlat0.z);
    u_xlat10_14 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec8, 0.0);
    u_xlat0.x = u_xlat2.w * u_xlat10_21 + u_xlat0.x;
    u_xlat0.x = u_xlat7 * u_xlat10_14 + u_xlat0.x;
    u_xlat16_7 = (-_LightShadowData.x) + 1.0;
    u_xlat0 = u_xlat0.xxxx * vec4(u_xlat16_7) + _LightShadowData.xxxx;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SHADOWS_SINGLE_CASCADE" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
in highp vec3 in_TEXCOORD1;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
out highp vec3 vs_TEXCOORD2;
out highp vec3 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
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
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraInvProjection[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraInvProjection[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    vs_TEXCOORD0.zw = u_xlat1.zz + u_xlat1.xw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    vs_TEXCOORD1.xyz = in_TEXCOORD1.xyz;
    u_xlat1.xyz = u_xlat0.xyz + (-hlslcc_mtx4x4unity_CameraInvProjection[2].xyz);
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[2].xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.w = (-u_xlat1.z);
    vs_TEXCOORD2.xyz = u_xlat1.xyw;
    u_xlat0.w = (-u_xlat0.z);
    vs_TEXCOORD3.xyz = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp float u_xlat10_1;
vec4 u_xlat2;
lowp float u_xlat10_2;
vec4 u_xlat3;
vec4 u_xlat4;
vec4 u_xlat5;
vec4 u_xlat6;
float u_xlat7;
mediump float u_xlat16_7;
lowp float u_xlat10_8;
lowp float u_xlat10_14;
vec2 u_xlat15;
lowp float u_xlat10_15;
lowp float u_xlat10_21;
lowp float u_xlat10_22;
void main()
{
    u_xlat0.z = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat0.xy = vs_TEXCOORD0.zw;
    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraInvProjection[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraInvProjection[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraInvProjection[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraInvProjection[3];
    u_xlat0.xyz = u_xlat0.xyz / u_xlat0.www;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * (-u_xlat0.zzzz) + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat1.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[3].xyz * u_xlat0.www + u_xlat0.xyz;
    u_xlat1.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + vec2(0.5, 0.5);
    u_xlat1.xy = floor(u_xlat1.xy);
    u_xlat0.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + (-u_xlat1.xy);
    u_xlat15.xy = min(u_xlat0.xy, vec2(0.0, 0.0));
    u_xlat2.xy = (-u_xlat0.xy) + vec2(1.0, 1.0);
    u_xlat15.xy = (-u_xlat15.xy) * u_xlat15.xy + u_xlat2.xy;
    u_xlat2.xy = u_xlat2.xy * vec2(0.159999996, 0.159999996);
    u_xlat15.xy = u_xlat15.xy + vec2(1.0, 1.0);
    u_xlat3.xy = u_xlat15.xy * vec2(0.159999996, 0.159999996);
    u_xlat15.xy = max(u_xlat0.xy, vec2(0.0, 0.0));
    u_xlat4 = u_xlat0.xxyy + vec4(0.5, 1.0, 0.5, 1.0);
    u_xlat15.xy = (-u_xlat15.xy) * u_xlat15.xy + u_xlat4.yw;
    u_xlat15.xy = u_xlat15.xy + vec2(1.0, 1.0);
    u_xlat5.xy = u_xlat15.xy * vec2(0.159999996, 0.159999996);
    u_xlat6 = u_xlat4.xxzz * u_xlat4.xxzz;
    u_xlat15.xy = vec2(u_xlat4.y * float(0.159999996), u_xlat4.w * float(0.159999996));
    u_xlat0.xy = u_xlat6.xz * vec2(0.5, 0.5) + (-u_xlat0.xy);
    u_xlat2.zw = vec2(u_xlat6.w * float(0.0799999982), u_xlat6.y * float(0.0799999982));
    u_xlat4.xy = u_xlat0.xy * vec2(0.159999996, 0.159999996);
    u_xlat3.z = u_xlat4.y;
    u_xlat3.w = u_xlat15.y;
    u_xlat4.w = u_xlat15.x;
    u_xlat5.zw = u_xlat2.yz;
    u_xlat0.xyw = vec3(u_xlat3.z + u_xlat5.z, u_xlat3.y + u_xlat5.y, u_xlat3.w + u_xlat5.w);
    u_xlat4.z = u_xlat3.x;
    u_xlat3.xyz = vec3(u_xlat5.z / u_xlat0.x, u_xlat5.y / u_xlat0.y, u_xlat5.w / u_xlat0.w);
    u_xlat2.z = u_xlat5.x;
    u_xlat3.xyz = u_xlat3.xyz + vec3(-2.5, -0.5, 1.5);
    u_xlat3.xyz = u_xlat3.xyz * _ShadowMapTexture_TexelSize.yyy;
    u_xlat5.w = u_xlat3.x;
    u_xlat4 = u_xlat2.zwxz + u_xlat4.zwxz;
    u_xlat2.xyz = vec3(u_xlat2.x / u_xlat4.z, u_xlat2.z / u_xlat4.w, u_xlat2.w / u_xlat4.y);
    u_xlat2.xyz = u_xlat2.xyz + vec3(-2.5, -0.5, 1.5);
    u_xlat5.xyz = u_xlat2.yxz * _ShadowMapTexture_TexelSize.xxx;
    u_xlat2 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.ywxw;
    u_xlat15.xy = u_xlat1.xy * _ShadowMapTexture_TexelSize.xy + u_xlat5.zw;
    vec3 txVec0 = vec3(u_xlat15.xy,u_xlat0.z);
    u_xlat10_15 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    vec3 txVec1 = vec3(u_xlat2.xy,u_xlat0.z);
    u_xlat10_22 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec1, 0.0);
    vec3 txVec2 = vec3(u_xlat2.zw,u_xlat0.z);
    u_xlat10_2 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec2, 0.0);
    u_xlat6 = vec4(u_xlat0.x * u_xlat4.z, u_xlat0.x * u_xlat4.w, u_xlat0.x * u_xlat4.y, u_xlat0.y * u_xlat4.z);
    u_xlat0.x = u_xlat10_2 * u_xlat6.y;
    u_xlat0.x = u_xlat6.x * u_xlat10_22 + u_xlat0.x;
    u_xlat0.x = u_xlat6.z * u_xlat10_15 + u_xlat0.x;
    u_xlat3.w = u_xlat5.y;
    u_xlat2 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat3.wywz;
    u_xlat5.yw = u_xlat3.yz;
    vec3 txVec3 = vec3(u_xlat2.xy,u_xlat0.z);
    u_xlat10_15 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec3, 0.0);
    vec3 txVec4 = vec3(u_xlat2.zw,u_xlat0.z);
    u_xlat10_22 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec4, 0.0);
    u_xlat0.x = u_xlat6.w * u_xlat10_15 + u_xlat0.x;
    u_xlat2 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xyzy;
    u_xlat3 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xwzw;
    vec3 txVec5 = vec3(u_xlat2.xy,u_xlat0.z);
    u_xlat10_1 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec5, 0.0);
    vec3 txVec6 = vec3(u_xlat2.zw,u_xlat0.z);
    u_xlat10_8 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec6, 0.0);
    u_xlat2 = vec4(u_xlat0.y * u_xlat4.x, u_xlat0.y * u_xlat4.y, u_xlat0.w * u_xlat4.z, u_xlat0.w * u_xlat4.w);
    u_xlat7 = u_xlat0.w * u_xlat4.y;
    u_xlat0.x = u_xlat2.x * u_xlat10_1 + u_xlat0.x;
    u_xlat0.x = u_xlat2.y * u_xlat10_8 + u_xlat0.x;
    u_xlat0.x = u_xlat2.z * u_xlat10_22 + u_xlat0.x;
    vec3 txVec7 = vec3(u_xlat3.xy,u_xlat0.z);
    u_xlat10_21 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec7, 0.0);
    vec3 txVec8 = vec3(u_xlat3.zw,u_xlat0.z);
    u_xlat10_14 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec8, 0.0);
    u_xlat0.x = u_xlat2.w * u_xlat10_21 + u_xlat0.x;
    u_xlat0.x = u_xlat7 * u_xlat10_14 + u_xlat0.x;
    u_xlat16_7 = (-_LightShadowData.x) + 1.0;
    u_xlat0 = u_xlat0.xxxx * vec4(u_xlat16_7) + _LightShadowData.xxxx;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SHADOWS_SINGLE_CASCADE" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
in highp vec3 in_TEXCOORD1;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
out highp vec3 vs_TEXCOORD2;
out highp vec3 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
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
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraInvProjection[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraInvProjection[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    vs_TEXCOORD0.zw = u_xlat1.zz + u_xlat1.xw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    vs_TEXCOORD1.xyz = in_TEXCOORD1.xyz;
    u_xlat1.xyz = u_xlat0.xyz + (-hlslcc_mtx4x4unity_CameraInvProjection[2].xyz);
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[2].xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.w = (-u_xlat1.z);
    vs_TEXCOORD2.xyz = u_xlat1.xyw;
    u_xlat0.w = (-u_xlat0.z);
    vs_TEXCOORD3.xyz = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp float u_xlat10_1;
vec4 u_xlat2;
lowp float u_xlat10_2;
vec4 u_xlat3;
vec4 u_xlat4;
vec4 u_xlat5;
vec4 u_xlat6;
float u_xlat7;
mediump float u_xlat16_7;
lowp float u_xlat10_8;
lowp float u_xlat10_14;
vec2 u_xlat15;
lowp float u_xlat10_15;
lowp float u_xlat10_21;
lowp float u_xlat10_22;
void main()
{
    u_xlat0.z = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat0.xy = vs_TEXCOORD0.zw;
    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraInvProjection[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraInvProjection[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraInvProjection[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraInvProjection[3];
    u_xlat0.xyz = u_xlat0.xyz / u_xlat0.www;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * (-u_xlat0.zzzz) + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat1.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[3].xyz * u_xlat0.www + u_xlat0.xyz;
    u_xlat1.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + vec2(0.5, 0.5);
    u_xlat1.xy = floor(u_xlat1.xy);
    u_xlat0.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + (-u_xlat1.xy);
    u_xlat15.xy = min(u_xlat0.xy, vec2(0.0, 0.0));
    u_xlat2.xy = (-u_xlat0.xy) + vec2(1.0, 1.0);
    u_xlat15.xy = (-u_xlat15.xy) * u_xlat15.xy + u_xlat2.xy;
    u_xlat2.xy = u_xlat2.xy * vec2(0.159999996, 0.159999996);
    u_xlat15.xy = u_xlat15.xy + vec2(1.0, 1.0);
    u_xlat3.xy = u_xlat15.xy * vec2(0.159999996, 0.159999996);
    u_xlat15.xy = max(u_xlat0.xy, vec2(0.0, 0.0));
    u_xlat4 = u_xlat0.xxyy + vec4(0.5, 1.0, 0.5, 1.0);
    u_xlat15.xy = (-u_xlat15.xy) * u_xlat15.xy + u_xlat4.yw;
    u_xlat15.xy = u_xlat15.xy + vec2(1.0, 1.0);
    u_xlat5.xy = u_xlat15.xy * vec2(0.159999996, 0.159999996);
    u_xlat6 = u_xlat4.xxzz * u_xlat4.xxzz;
    u_xlat15.xy = vec2(u_xlat4.y * float(0.159999996), u_xlat4.w * float(0.159999996));
    u_xlat0.xy = u_xlat6.xz * vec2(0.5, 0.5) + (-u_xlat0.xy);
    u_xlat2.zw = vec2(u_xlat6.w * float(0.0799999982), u_xlat6.y * float(0.0799999982));
    u_xlat4.xy = u_xlat0.xy * vec2(0.159999996, 0.159999996);
    u_xlat3.z = u_xlat4.y;
    u_xlat3.w = u_xlat15.y;
    u_xlat4.w = u_xlat15.x;
    u_xlat5.zw = u_xlat2.yz;
    u_xlat0.xyw = vec3(u_xlat3.z + u_xlat5.z, u_xlat3.y + u_xlat5.y, u_xlat3.w + u_xlat5.w);
    u_xlat4.z = u_xlat3.x;
    u_xlat3.xyz = vec3(u_xlat5.z / u_xlat0.x, u_xlat5.y / u_xlat0.y, u_xlat5.w / u_xlat0.w);
    u_xlat2.z = u_xlat5.x;
    u_xlat3.xyz = u_xlat3.xyz + vec3(-2.5, -0.5, 1.5);
    u_xlat3.xyz = u_xlat3.xyz * _ShadowMapTexture_TexelSize.yyy;
    u_xlat5.w = u_xlat3.x;
    u_xlat4 = u_xlat2.zwxz + u_xlat4.zwxz;
    u_xlat2.xyz = vec3(u_xlat2.x / u_xlat4.z, u_xlat2.z / u_xlat4.w, u_xlat2.w / u_xlat4.y);
    u_xlat2.xyz = u_xlat2.xyz + vec3(-2.5, -0.5, 1.5);
    u_xlat5.xyz = u_xlat2.yxz * _ShadowMapTexture_TexelSize.xxx;
    u_xlat2 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.ywxw;
    u_xlat15.xy = u_xlat1.xy * _ShadowMapTexture_TexelSize.xy + u_xlat5.zw;
    vec3 txVec0 = vec3(u_xlat15.xy,u_xlat0.z);
    u_xlat10_15 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    vec3 txVec1 = vec3(u_xlat2.xy,u_xlat0.z);
    u_xlat10_22 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec1, 0.0);
    vec3 txVec2 = vec3(u_xlat2.zw,u_xlat0.z);
    u_xlat10_2 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec2, 0.0);
    u_xlat6 = vec4(u_xlat0.x * u_xlat4.z, u_xlat0.x * u_xlat4.w, u_xlat0.x * u_xlat4.y, u_xlat0.y * u_xlat4.z);
    u_xlat0.x = u_xlat10_2 * u_xlat6.y;
    u_xlat0.x = u_xlat6.x * u_xlat10_22 + u_xlat0.x;
    u_xlat0.x = u_xlat6.z * u_xlat10_15 + u_xlat0.x;
    u_xlat3.w = u_xlat5.y;
    u_xlat2 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat3.wywz;
    u_xlat5.yw = u_xlat3.yz;
    vec3 txVec3 = vec3(u_xlat2.xy,u_xlat0.z);
    u_xlat10_15 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec3, 0.0);
    vec3 txVec4 = vec3(u_xlat2.zw,u_xlat0.z);
    u_xlat10_22 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec4, 0.0);
    u_xlat0.x = u_xlat6.w * u_xlat10_15 + u_xlat0.x;
    u_xlat2 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xyzy;
    u_xlat3 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xwzw;
    vec3 txVec5 = vec3(u_xlat2.xy,u_xlat0.z);
    u_xlat10_1 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec5, 0.0);
    vec3 txVec6 = vec3(u_xlat2.zw,u_xlat0.z);
    u_xlat10_8 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec6, 0.0);
    u_xlat2 = vec4(u_xlat0.y * u_xlat4.x, u_xlat0.y * u_xlat4.y, u_xlat0.w * u_xlat4.z, u_xlat0.w * u_xlat4.w);
    u_xlat7 = u_xlat0.w * u_xlat4.y;
    u_xlat0.x = u_xlat2.x * u_xlat10_1 + u_xlat0.x;
    u_xlat0.x = u_xlat2.y * u_xlat10_8 + u_xlat0.x;
    u_xlat0.x = u_xlat2.z * u_xlat10_22 + u_xlat0.x;
    vec3 txVec7 = vec3(u_xlat3.xy,u_xlat0.z);
    u_xlat10_21 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec7, 0.0);
    vec3 txVec8 = vec3(u_xlat3.zw,u_xlat0.z);
    u_xlat10_14 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec8, 0.0);
    u_xlat0.x = u_xlat2.w * u_xlat10_21 + u_xlat0.x;
    u_xlat0.x = u_xlat7 * u_xlat10_14 + u_xlat0.x;
    u_xlat16_7 = (-_LightShadowData.x) + 1.0;
    u_xlat0 = u_xlat0.xxxx * vec4(u_xlat16_7) + _LightShadowData.xxxx;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec3 orthoPosFar_1;
  highp vec3 orthoPosNear_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _glesVertex.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  clipPos_3.xzw = tmpvar_5.xzw;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 o_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_5.zw;
  tmpvar_4.zw = o_7.xy;
  clipPos_3.y = (tmpvar_5.y * _ProjectionParams.x);
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(-1.0, 1.0);
  tmpvar_10.xy = clipPos_3.xy;
  highp vec3 tmpvar_11;
  tmpvar_11 = (unity_CameraInvProjection * tmpvar_10).xyz;
  orthoPosNear_2.xy = tmpvar_11.xy;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(1.0, 1.0);
  tmpvar_12.xy = clipPos_3.xy;
  highp vec3 tmpvar_13;
  tmpvar_13 = (unity_CameraInvProjection * tmpvar_12).xyz;
  orthoPosFar_1.xy = tmpvar_13.xy;
  orthoPosNear_2.z = -(tmpvar_11.z);
  orthoPosFar_1.z = -(tmpvar_13.z);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = _glesMultiTexCoord1.xyz;
  xlv_TEXCOORD2 = orthoPosNear_2;
  xlv_TEXCOORD3 = orthoPosFar_1;
}


#endif
#ifdef FRAGMENT
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec4 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 camPos_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xy = xlv_TEXCOORD0.zw;
  tmpvar_4.z = texture2D (_CameraDepthTexture, xlv_TEXCOORD0.xy).x;
  clipPos_3.w = tmpvar_4.w;
  clipPos_3.xyz = ((2.0 * tmpvar_4.xyz) - 1.0);
  highp vec4 tmpvar_5;
  tmpvar_5 = (unity_CameraInvProjection * clipPos_3);
  camPos_2.w = tmpvar_5.w;
  camPos_2.xyz = (tmpvar_5.xyz / tmpvar_5.w);
  camPos_2.z = -(camPos_2.z);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = camPos_2.xyz;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = (unity_WorldToShadow[0] * (unity_CameraToWorld * tmpvar_6)).xyz;
  mediump float shadow_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = _ShadowMapTexture_TexelSize.xy;
  shadow_8 = 0.0;
  highp vec3 tmpvar_10;
  tmpvar_10.xy = (tmpvar_7.xy - _ShadowMapTexture_TexelSize.xy);
  tmpvar_10.z = tmpvar_7.z;
  highp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_ShadowMapTexture, tmpvar_10.xy);
  mediump float tmpvar_12;
  if ((tmpvar_11.x < tmpvar_7.z)) {
    tmpvar_12 = 0.0;
  } else {
    tmpvar_12 = 1.0;
  };
  shadow_8 = tmpvar_12;
  highp vec2 tmpvar_13;
  tmpvar_13.x = 0.0;
  tmpvar_13.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_14;
  tmpvar_14.xy = (tmpvar_7.xy + tmpvar_13);
  tmpvar_14.z = tmpvar_7.z;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_ShadowMapTexture, tmpvar_14.xy);
  highp float tmpvar_16;
  if ((tmpvar_15.x < tmpvar_7.z)) {
    tmpvar_16 = 0.0;
  } else {
    tmpvar_16 = 1.0;
  };
  shadow_8 = (tmpvar_12 + tmpvar_16);
  highp vec2 tmpvar_17;
  tmpvar_17.x = tmpvar_9.x;
  tmpvar_17.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_18;
  tmpvar_18.xy = (tmpvar_7.xy + tmpvar_17);
  tmpvar_18.z = tmpvar_7.z;
  highp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_ShadowMapTexture, tmpvar_18.xy);
  highp float tmpvar_20;
  if ((tmpvar_19.x < tmpvar_7.z)) {
    tmpvar_20 = 0.0;
  } else {
    tmpvar_20 = 1.0;
  };
  shadow_8 = (shadow_8 + tmpvar_20);
  highp vec2 tmpvar_21;
  tmpvar_21.y = 0.0;
  tmpvar_21.x = -(_ShadowMapTexture_TexelSize.x);
  highp vec3 tmpvar_22;
  tmpvar_22.xy = (tmpvar_7.xy + tmpvar_21);
  tmpvar_22.z = tmpvar_7.z;
  highp vec4 tmpvar_23;
  tmpvar_23 = texture2D (_ShadowMapTexture, tmpvar_22.xy);
  highp float tmpvar_24;
  if ((tmpvar_23.x < tmpvar_7.z)) {
    tmpvar_24 = 0.0;
  } else {
    tmpvar_24 = 1.0;
  };
  shadow_8 = (shadow_8 + tmpvar_24);
  highp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_ShadowMapTexture, tmpvar_7.xy);
  highp float tmpvar_26;
  if ((tmpvar_25.x < tmpvar_7.z)) {
    tmpvar_26 = 0.0;
  } else {
    tmpvar_26 = 1.0;
  };
  shadow_8 = (shadow_8 + tmpvar_26);
  highp vec2 tmpvar_27;
  tmpvar_27.y = 0.0;
  tmpvar_27.x = tmpvar_9.x;
  highp vec3 tmpvar_28;
  tmpvar_28.xy = (tmpvar_7.xy + tmpvar_27);
  tmpvar_28.z = tmpvar_7.z;
  highp vec4 tmpvar_29;
  tmpvar_29 = texture2D (_ShadowMapTexture, tmpvar_28.xy);
  highp float tmpvar_30;
  if ((tmpvar_29.x < tmpvar_7.z)) {
    tmpvar_30 = 0.0;
  } else {
    tmpvar_30 = 1.0;
  };
  shadow_8 = (shadow_8 + tmpvar_30);
  highp vec2 tmpvar_31;
  tmpvar_31.x = -(_ShadowMapTexture_TexelSize.x);
  tmpvar_31.y = tmpvar_9.y;
  highp vec3 tmpvar_32;
  tmpvar_32.xy = (tmpvar_7.xy + tmpvar_31);
  tmpvar_32.z = tmpvar_7.z;
  highp vec4 tmpvar_33;
  tmpvar_33 = texture2D (_ShadowMapTexture, tmpvar_32.xy);
  highp float tmpvar_34;
  if ((tmpvar_33.x < tmpvar_7.z)) {
    tmpvar_34 = 0.0;
  } else {
    tmpvar_34 = 1.0;
  };
  shadow_8 = (shadow_8 + tmpvar_34);
  highp vec2 tmpvar_35;
  tmpvar_35.x = 0.0;
  tmpvar_35.y = tmpvar_9.y;
  highp vec3 tmpvar_36;
  tmpvar_36.xy = (tmpvar_7.xy + tmpvar_35);
  tmpvar_36.z = tmpvar_7.z;
  highp vec4 tmpvar_37;
  tmpvar_37 = texture2D (_ShadowMapTexture, tmpvar_36.xy);
  highp float tmpvar_38;
  if ((tmpvar_37.x < tmpvar_7.z)) {
    tmpvar_38 = 0.0;
  } else {
    tmpvar_38 = 1.0;
  };
  shadow_8 = (shadow_8 + tmpvar_38);
  highp vec3 tmpvar_39;
  tmpvar_39.xy = (tmpvar_7.xy + _ShadowMapTexture_TexelSize.xy);
  tmpvar_39.z = tmpvar_7.z;
  highp vec4 tmpvar_40;
  tmpvar_40 = texture2D (_ShadowMapTexture, tmpvar_39.xy);
  highp float tmpvar_41;
  if ((tmpvar_40.x < tmpvar_7.z)) {
    tmpvar_41 = 0.0;
  } else {
    tmpvar_41 = 1.0;
  };
  shadow_8 = (shadow_8 + tmpvar_41);
  shadow_8 = (shadow_8 / 9.0);
  mediump vec4 tmpvar_42;
  tmpvar_42 = vec4(mix (_LightShadowData.x, 1.0, shadow_8));
  tmpvar_1 = tmpvar_42;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec3 orthoPosFar_1;
  highp vec3 orthoPosNear_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _glesVertex.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  clipPos_3.xzw = tmpvar_5.xzw;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 o_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_5.zw;
  tmpvar_4.zw = o_7.xy;
  clipPos_3.y = (tmpvar_5.y * _ProjectionParams.x);
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(-1.0, 1.0);
  tmpvar_10.xy = clipPos_3.xy;
  highp vec3 tmpvar_11;
  tmpvar_11 = (unity_CameraInvProjection * tmpvar_10).xyz;
  orthoPosNear_2.xy = tmpvar_11.xy;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(1.0, 1.0);
  tmpvar_12.xy = clipPos_3.xy;
  highp vec3 tmpvar_13;
  tmpvar_13 = (unity_CameraInvProjection * tmpvar_12).xyz;
  orthoPosFar_1.xy = tmpvar_13.xy;
  orthoPosNear_2.z = -(tmpvar_11.z);
  orthoPosFar_1.z = -(tmpvar_13.z);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = _glesMultiTexCoord1.xyz;
  xlv_TEXCOORD2 = orthoPosNear_2;
  xlv_TEXCOORD3 = orthoPosFar_1;
}


#endif
#ifdef FRAGMENT
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec4 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 camPos_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xy = xlv_TEXCOORD0.zw;
  tmpvar_4.z = texture2D (_CameraDepthTexture, xlv_TEXCOORD0.xy).x;
  clipPos_3.w = tmpvar_4.w;
  clipPos_3.xyz = ((2.0 * tmpvar_4.xyz) - 1.0);
  highp vec4 tmpvar_5;
  tmpvar_5 = (unity_CameraInvProjection * clipPos_3);
  camPos_2.w = tmpvar_5.w;
  camPos_2.xyz = (tmpvar_5.xyz / tmpvar_5.w);
  camPos_2.z = -(camPos_2.z);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = camPos_2.xyz;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = (unity_WorldToShadow[0] * (unity_CameraToWorld * tmpvar_6)).xyz;
  mediump float shadow_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = _ShadowMapTexture_TexelSize.xy;
  shadow_8 = 0.0;
  highp vec3 tmpvar_10;
  tmpvar_10.xy = (tmpvar_7.xy - _ShadowMapTexture_TexelSize.xy);
  tmpvar_10.z = tmpvar_7.z;
  highp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_ShadowMapTexture, tmpvar_10.xy);
  mediump float tmpvar_12;
  if ((tmpvar_11.x < tmpvar_7.z)) {
    tmpvar_12 = 0.0;
  } else {
    tmpvar_12 = 1.0;
  };
  shadow_8 = tmpvar_12;
  highp vec2 tmpvar_13;
  tmpvar_13.x = 0.0;
  tmpvar_13.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_14;
  tmpvar_14.xy = (tmpvar_7.xy + tmpvar_13);
  tmpvar_14.z = tmpvar_7.z;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_ShadowMapTexture, tmpvar_14.xy);
  highp float tmpvar_16;
  if ((tmpvar_15.x < tmpvar_7.z)) {
    tmpvar_16 = 0.0;
  } else {
    tmpvar_16 = 1.0;
  };
  shadow_8 = (tmpvar_12 + tmpvar_16);
  highp vec2 tmpvar_17;
  tmpvar_17.x = tmpvar_9.x;
  tmpvar_17.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_18;
  tmpvar_18.xy = (tmpvar_7.xy + tmpvar_17);
  tmpvar_18.z = tmpvar_7.z;
  highp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_ShadowMapTexture, tmpvar_18.xy);
  highp float tmpvar_20;
  if ((tmpvar_19.x < tmpvar_7.z)) {
    tmpvar_20 = 0.0;
  } else {
    tmpvar_20 = 1.0;
  };
  shadow_8 = (shadow_8 + tmpvar_20);
  highp vec2 tmpvar_21;
  tmpvar_21.y = 0.0;
  tmpvar_21.x = -(_ShadowMapTexture_TexelSize.x);
  highp vec3 tmpvar_22;
  tmpvar_22.xy = (tmpvar_7.xy + tmpvar_21);
  tmpvar_22.z = tmpvar_7.z;
  highp vec4 tmpvar_23;
  tmpvar_23 = texture2D (_ShadowMapTexture, tmpvar_22.xy);
  highp float tmpvar_24;
  if ((tmpvar_23.x < tmpvar_7.z)) {
    tmpvar_24 = 0.0;
  } else {
    tmpvar_24 = 1.0;
  };
  shadow_8 = (shadow_8 + tmpvar_24);
  highp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_ShadowMapTexture, tmpvar_7.xy);
  highp float tmpvar_26;
  if ((tmpvar_25.x < tmpvar_7.z)) {
    tmpvar_26 = 0.0;
  } else {
    tmpvar_26 = 1.0;
  };
  shadow_8 = (shadow_8 + tmpvar_26);
  highp vec2 tmpvar_27;
  tmpvar_27.y = 0.0;
  tmpvar_27.x = tmpvar_9.x;
  highp vec3 tmpvar_28;
  tmpvar_28.xy = (tmpvar_7.xy + tmpvar_27);
  tmpvar_28.z = tmpvar_7.z;
  highp vec4 tmpvar_29;
  tmpvar_29 = texture2D (_ShadowMapTexture, tmpvar_28.xy);
  highp float tmpvar_30;
  if ((tmpvar_29.x < tmpvar_7.z)) {
    tmpvar_30 = 0.0;
  } else {
    tmpvar_30 = 1.0;
  };
  shadow_8 = (shadow_8 + tmpvar_30);
  highp vec2 tmpvar_31;
  tmpvar_31.x = -(_ShadowMapTexture_TexelSize.x);
  tmpvar_31.y = tmpvar_9.y;
  highp vec3 tmpvar_32;
  tmpvar_32.xy = (tmpvar_7.xy + tmpvar_31);
  tmpvar_32.z = tmpvar_7.z;
  highp vec4 tmpvar_33;
  tmpvar_33 = texture2D (_ShadowMapTexture, tmpvar_32.xy);
  highp float tmpvar_34;
  if ((tmpvar_33.x < tmpvar_7.z)) {
    tmpvar_34 = 0.0;
  } else {
    tmpvar_34 = 1.0;
  };
  shadow_8 = (shadow_8 + tmpvar_34);
  highp vec2 tmpvar_35;
  tmpvar_35.x = 0.0;
  tmpvar_35.y = tmpvar_9.y;
  highp vec3 tmpvar_36;
  tmpvar_36.xy = (tmpvar_7.xy + tmpvar_35);
  tmpvar_36.z = tmpvar_7.z;
  highp vec4 tmpvar_37;
  tmpvar_37 = texture2D (_ShadowMapTexture, tmpvar_36.xy);
  highp float tmpvar_38;
  if ((tmpvar_37.x < tmpvar_7.z)) {
    tmpvar_38 = 0.0;
  } else {
    tmpvar_38 = 1.0;
  };
  shadow_8 = (shadow_8 + tmpvar_38);
  highp vec3 tmpvar_39;
  tmpvar_39.xy = (tmpvar_7.xy + _ShadowMapTexture_TexelSize.xy);
  tmpvar_39.z = tmpvar_7.z;
  highp vec4 tmpvar_40;
  tmpvar_40 = texture2D (_ShadowMapTexture, tmpvar_39.xy);
  highp float tmpvar_41;
  if ((tmpvar_40.x < tmpvar_7.z)) {
    tmpvar_41 = 0.0;
  } else {
    tmpvar_41 = 1.0;
  };
  shadow_8 = (shadow_8 + tmpvar_41);
  shadow_8 = (shadow_8 / 9.0);
  mediump vec4 tmpvar_42;
  tmpvar_42 = vec4(mix (_LightShadowData.x, 1.0, shadow_8));
  tmpvar_1 = tmpvar_42;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
attribute vec4 _glesMultiTexCoord1;
uniform highp vec4 _ProjectionParams;
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
varying highp vec3 xlv_TEXCOORD2;
varying highp vec3 xlv_TEXCOORD3;
void main ()
{
  highp vec3 orthoPosFar_1;
  highp vec3 orthoPosNear_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  highp vec4 tmpvar_5;
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = _glesVertex.xyz;
  tmpvar_5 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_6));
  clipPos_3.xzw = tmpvar_5.xzw;
  tmpvar_4.xy = _glesMultiTexCoord0.xy;
  highp vec4 o_7;
  highp vec4 tmpvar_8;
  tmpvar_8 = (tmpvar_5 * 0.5);
  highp vec2 tmpvar_9;
  tmpvar_9.x = tmpvar_8.x;
  tmpvar_9.y = (tmpvar_8.y * _ProjectionParams.x);
  o_7.xy = (tmpvar_9 + tmpvar_8.w);
  o_7.zw = tmpvar_5.zw;
  tmpvar_4.zw = o_7.xy;
  clipPos_3.y = (tmpvar_5.y * _ProjectionParams.x);
  highp vec4 tmpvar_10;
  tmpvar_10.zw = vec2(-1.0, 1.0);
  tmpvar_10.xy = clipPos_3.xy;
  highp vec3 tmpvar_11;
  tmpvar_11 = (unity_CameraInvProjection * tmpvar_10).xyz;
  orthoPosNear_2.xy = tmpvar_11.xy;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(1.0, 1.0);
  tmpvar_12.xy = clipPos_3.xy;
  highp vec3 tmpvar_13;
  tmpvar_13 = (unity_CameraInvProjection * tmpvar_12).xyz;
  orthoPosFar_1.xy = tmpvar_13.xy;
  orthoPosNear_2.z = -(tmpvar_11.z);
  orthoPosFar_1.z = -(tmpvar_13.z);
  gl_Position = tmpvar_5;
  xlv_TEXCOORD0 = tmpvar_4;
  xlv_TEXCOORD1 = _glesMultiTexCoord1.xyz;
  xlv_TEXCOORD2 = orthoPosNear_2;
  xlv_TEXCOORD3 = orthoPosFar_1;
}


#endif
#ifdef FRAGMENT
uniform highp mat4 unity_CameraInvProjection;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
varying highp vec4 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec4 camPos_2;
  highp vec4 clipPos_3;
  highp vec4 tmpvar_4;
  tmpvar_4.w = 1.0;
  tmpvar_4.xy = xlv_TEXCOORD0.zw;
  tmpvar_4.z = texture2D (_CameraDepthTexture, xlv_TEXCOORD0.xy).x;
  clipPos_3.w = tmpvar_4.w;
  clipPos_3.xyz = ((2.0 * tmpvar_4.xyz) - 1.0);
  highp vec4 tmpvar_5;
  tmpvar_5 = (unity_CameraInvProjection * clipPos_3);
  camPos_2.w = tmpvar_5.w;
  camPos_2.xyz = (tmpvar_5.xyz / tmpvar_5.w);
  camPos_2.z = -(camPos_2.z);
  highp vec4 tmpvar_6;
  tmpvar_6.w = 1.0;
  tmpvar_6.xyz = camPos_2.xyz;
  highp vec4 tmpvar_7;
  tmpvar_7.w = 0.0;
  tmpvar_7.xyz = (unity_WorldToShadow[0] * (unity_CameraToWorld * tmpvar_6)).xyz;
  mediump float shadow_8;
  highp vec2 tmpvar_9;
  tmpvar_9 = _ShadowMapTexture_TexelSize.xy;
  shadow_8 = 0.0;
  highp vec3 tmpvar_10;
  tmpvar_10.xy = (tmpvar_7.xy - _ShadowMapTexture_TexelSize.xy);
  tmpvar_10.z = tmpvar_7.z;
  highp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_ShadowMapTexture, tmpvar_10.xy);
  mediump float tmpvar_12;
  if ((tmpvar_11.x < tmpvar_7.z)) {
    tmpvar_12 = 0.0;
  } else {
    tmpvar_12 = 1.0;
  };
  shadow_8 = tmpvar_12;
  highp vec2 tmpvar_13;
  tmpvar_13.x = 0.0;
  tmpvar_13.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_14;
  tmpvar_14.xy = (tmpvar_7.xy + tmpvar_13);
  tmpvar_14.z = tmpvar_7.z;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_ShadowMapTexture, tmpvar_14.xy);
  highp float tmpvar_16;
  if ((tmpvar_15.x < tmpvar_7.z)) {
    tmpvar_16 = 0.0;
  } else {
    tmpvar_16 = 1.0;
  };
  shadow_8 = (tmpvar_12 + tmpvar_16);
  highp vec2 tmpvar_17;
  tmpvar_17.x = tmpvar_9.x;
  tmpvar_17.y = -(_ShadowMapTexture_TexelSize.y);
  highp vec3 tmpvar_18;
  tmpvar_18.xy = (tmpvar_7.xy + tmpvar_17);
  tmpvar_18.z = tmpvar_7.z;
  highp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_ShadowMapTexture, tmpvar_18.xy);
  highp float tmpvar_20;
  if ((tmpvar_19.x < tmpvar_7.z)) {
    tmpvar_20 = 0.0;
  } else {
    tmpvar_20 = 1.0;
  };
  shadow_8 = (shadow_8 + tmpvar_20);
  highp vec2 tmpvar_21;
  tmpvar_21.y = 0.0;
  tmpvar_21.x = -(_ShadowMapTexture_TexelSize.x);
  highp vec3 tmpvar_22;
  tmpvar_22.xy = (tmpvar_7.xy + tmpvar_21);
  tmpvar_22.z = tmpvar_7.z;
  highp vec4 tmpvar_23;
  tmpvar_23 = texture2D (_ShadowMapTexture, tmpvar_22.xy);
  highp float tmpvar_24;
  if ((tmpvar_23.x < tmpvar_7.z)) {
    tmpvar_24 = 0.0;
  } else {
    tmpvar_24 = 1.0;
  };
  shadow_8 = (shadow_8 + tmpvar_24);
  highp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_ShadowMapTexture, tmpvar_7.xy);
  highp float tmpvar_26;
  if ((tmpvar_25.x < tmpvar_7.z)) {
    tmpvar_26 = 0.0;
  } else {
    tmpvar_26 = 1.0;
  };
  shadow_8 = (shadow_8 + tmpvar_26);
  highp vec2 tmpvar_27;
  tmpvar_27.y = 0.0;
  tmpvar_27.x = tmpvar_9.x;
  highp vec3 tmpvar_28;
  tmpvar_28.xy = (tmpvar_7.xy + tmpvar_27);
  tmpvar_28.z = tmpvar_7.z;
  highp vec4 tmpvar_29;
  tmpvar_29 = texture2D (_ShadowMapTexture, tmpvar_28.xy);
  highp float tmpvar_30;
  if ((tmpvar_29.x < tmpvar_7.z)) {
    tmpvar_30 = 0.0;
  } else {
    tmpvar_30 = 1.0;
  };
  shadow_8 = (shadow_8 + tmpvar_30);
  highp vec2 tmpvar_31;
  tmpvar_31.x = -(_ShadowMapTexture_TexelSize.x);
  tmpvar_31.y = tmpvar_9.y;
  highp vec3 tmpvar_32;
  tmpvar_32.xy = (tmpvar_7.xy + tmpvar_31);
  tmpvar_32.z = tmpvar_7.z;
  highp vec4 tmpvar_33;
  tmpvar_33 = texture2D (_ShadowMapTexture, tmpvar_32.xy);
  highp float tmpvar_34;
  if ((tmpvar_33.x < tmpvar_7.z)) {
    tmpvar_34 = 0.0;
  } else {
    tmpvar_34 = 1.0;
  };
  shadow_8 = (shadow_8 + tmpvar_34);
  highp vec2 tmpvar_35;
  tmpvar_35.x = 0.0;
  tmpvar_35.y = tmpvar_9.y;
  highp vec3 tmpvar_36;
  tmpvar_36.xy = (tmpvar_7.xy + tmpvar_35);
  tmpvar_36.z = tmpvar_7.z;
  highp vec4 tmpvar_37;
  tmpvar_37 = texture2D (_ShadowMapTexture, tmpvar_36.xy);
  highp float tmpvar_38;
  if ((tmpvar_37.x < tmpvar_7.z)) {
    tmpvar_38 = 0.0;
  } else {
    tmpvar_38 = 1.0;
  };
  shadow_8 = (shadow_8 + tmpvar_38);
  highp vec3 tmpvar_39;
  tmpvar_39.xy = (tmpvar_7.xy + _ShadowMapTexture_TexelSize.xy);
  tmpvar_39.z = tmpvar_7.z;
  highp vec4 tmpvar_40;
  tmpvar_40 = texture2D (_ShadowMapTexture, tmpvar_39.xy);
  highp float tmpvar_41;
  if ((tmpvar_40.x < tmpvar_7.z)) {
    tmpvar_41 = 0.0;
  } else {
    tmpvar_41 = 1.0;
  };
  shadow_8 = (shadow_8 + tmpvar_41);
  shadow_8 = (shadow_8 / 9.0);
  mediump vec4 tmpvar_42;
  tmpvar_42 = vec4(mix (_LightShadowData.x, 1.0, shadow_8));
  tmpvar_1 = tmpvar_42;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
in highp vec3 in_TEXCOORD1;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
out highp vec3 vs_TEXCOORD2;
out highp vec3 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
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
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraInvProjection[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraInvProjection[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    vs_TEXCOORD0.zw = u_xlat1.zz + u_xlat1.xw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    vs_TEXCOORD1.xyz = in_TEXCOORD1.xyz;
    u_xlat1.xyz = u_xlat0.xyz + (-hlslcc_mtx4x4unity_CameraInvProjection[2].xyz);
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[2].xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.w = (-u_xlat1.z);
    vs_TEXCOORD2.xyz = u_xlat1.xyw;
    u_xlat0.w = (-u_xlat0.z);
    vs_TEXCOORD3.xyz = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp float u_xlat10_1;
vec4 u_xlat2;
lowp float u_xlat10_2;
vec4 u_xlat3;
vec4 u_xlat4;
vec4 u_xlat5;
vec4 u_xlat6;
float u_xlat7;
mediump float u_xlat16_7;
lowp float u_xlat10_8;
lowp float u_xlat10_14;
vec2 u_xlat15;
lowp float u_xlat10_15;
lowp float u_xlat10_21;
lowp float u_xlat10_22;
void main()
{
    u_xlat0.z = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat0.xy = vs_TEXCOORD0.zw;
    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraInvProjection[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraInvProjection[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraInvProjection[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraInvProjection[3];
    u_xlat0.xyz = u_xlat0.xyz / u_xlat0.www;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * (-u_xlat0.zzzz) + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat1.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[3].xyz * u_xlat0.www + u_xlat0.xyz;
    u_xlat1.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + vec2(0.5, 0.5);
    u_xlat1.xy = floor(u_xlat1.xy);
    u_xlat0.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + (-u_xlat1.xy);
    u_xlat15.xy = min(u_xlat0.xy, vec2(0.0, 0.0));
    u_xlat2.xy = (-u_xlat0.xy) + vec2(1.0, 1.0);
    u_xlat15.xy = (-u_xlat15.xy) * u_xlat15.xy + u_xlat2.xy;
    u_xlat2.xy = u_xlat2.xy * vec2(0.159999996, 0.159999996);
    u_xlat15.xy = u_xlat15.xy + vec2(1.0, 1.0);
    u_xlat3.xy = u_xlat15.xy * vec2(0.159999996, 0.159999996);
    u_xlat15.xy = max(u_xlat0.xy, vec2(0.0, 0.0));
    u_xlat4 = u_xlat0.xxyy + vec4(0.5, 1.0, 0.5, 1.0);
    u_xlat15.xy = (-u_xlat15.xy) * u_xlat15.xy + u_xlat4.yw;
    u_xlat15.xy = u_xlat15.xy + vec2(1.0, 1.0);
    u_xlat5.xy = u_xlat15.xy * vec2(0.159999996, 0.159999996);
    u_xlat6 = u_xlat4.xxzz * u_xlat4.xxzz;
    u_xlat15.xy = vec2(u_xlat4.y * float(0.159999996), u_xlat4.w * float(0.159999996));
    u_xlat0.xy = u_xlat6.xz * vec2(0.5, 0.5) + (-u_xlat0.xy);
    u_xlat2.zw = vec2(u_xlat6.w * float(0.0799999982), u_xlat6.y * float(0.0799999982));
    u_xlat4.xy = u_xlat0.xy * vec2(0.159999996, 0.159999996);
    u_xlat3.z = u_xlat4.y;
    u_xlat3.w = u_xlat15.y;
    u_xlat4.w = u_xlat15.x;
    u_xlat5.zw = u_xlat2.yz;
    u_xlat0.xyw = vec3(u_xlat3.z + u_xlat5.z, u_xlat3.y + u_xlat5.y, u_xlat3.w + u_xlat5.w);
    u_xlat4.z = u_xlat3.x;
    u_xlat3.xyz = vec3(u_xlat5.z / u_xlat0.x, u_xlat5.y / u_xlat0.y, u_xlat5.w / u_xlat0.w);
    u_xlat2.z = u_xlat5.x;
    u_xlat3.xyz = u_xlat3.xyz + vec3(-2.5, -0.5, 1.5);
    u_xlat3.xyz = u_xlat3.xyz * _ShadowMapTexture_TexelSize.yyy;
    u_xlat5.w = u_xlat3.x;
    u_xlat4 = u_xlat2.zwxz + u_xlat4.zwxz;
    u_xlat2.xyz = vec3(u_xlat2.x / u_xlat4.z, u_xlat2.z / u_xlat4.w, u_xlat2.w / u_xlat4.y);
    u_xlat2.xyz = u_xlat2.xyz + vec3(-2.5, -0.5, 1.5);
    u_xlat5.xyz = u_xlat2.yxz * _ShadowMapTexture_TexelSize.xxx;
    u_xlat2 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.ywxw;
    u_xlat15.xy = u_xlat1.xy * _ShadowMapTexture_TexelSize.xy + u_xlat5.zw;
    vec3 txVec0 = vec3(u_xlat15.xy,u_xlat0.z);
    u_xlat10_15 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    vec3 txVec1 = vec3(u_xlat2.xy,u_xlat0.z);
    u_xlat10_22 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec1, 0.0);
    vec3 txVec2 = vec3(u_xlat2.zw,u_xlat0.z);
    u_xlat10_2 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec2, 0.0);
    u_xlat6 = vec4(u_xlat0.x * u_xlat4.z, u_xlat0.x * u_xlat4.w, u_xlat0.x * u_xlat4.y, u_xlat0.y * u_xlat4.z);
    u_xlat0.x = u_xlat10_2 * u_xlat6.y;
    u_xlat0.x = u_xlat6.x * u_xlat10_22 + u_xlat0.x;
    u_xlat0.x = u_xlat6.z * u_xlat10_15 + u_xlat0.x;
    u_xlat3.w = u_xlat5.y;
    u_xlat2 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat3.wywz;
    u_xlat5.yw = u_xlat3.yz;
    vec3 txVec3 = vec3(u_xlat2.xy,u_xlat0.z);
    u_xlat10_15 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec3, 0.0);
    vec3 txVec4 = vec3(u_xlat2.zw,u_xlat0.z);
    u_xlat10_22 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec4, 0.0);
    u_xlat0.x = u_xlat6.w * u_xlat10_15 + u_xlat0.x;
    u_xlat2 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xyzy;
    u_xlat3 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xwzw;
    vec3 txVec5 = vec3(u_xlat2.xy,u_xlat0.z);
    u_xlat10_1 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec5, 0.0);
    vec3 txVec6 = vec3(u_xlat2.zw,u_xlat0.z);
    u_xlat10_8 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec6, 0.0);
    u_xlat2 = vec4(u_xlat0.y * u_xlat4.x, u_xlat0.y * u_xlat4.y, u_xlat0.w * u_xlat4.z, u_xlat0.w * u_xlat4.w);
    u_xlat7 = u_xlat0.w * u_xlat4.y;
    u_xlat0.x = u_xlat2.x * u_xlat10_1 + u_xlat0.x;
    u_xlat0.x = u_xlat2.y * u_xlat10_8 + u_xlat0.x;
    u_xlat0.x = u_xlat2.z * u_xlat10_22 + u_xlat0.x;
    vec3 txVec7 = vec3(u_xlat3.xy,u_xlat0.z);
    u_xlat10_21 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec7, 0.0);
    vec3 txVec8 = vec3(u_xlat3.zw,u_xlat0.z);
    u_xlat10_14 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec8, 0.0);
    u_xlat0.x = u_xlat2.w * u_xlat10_21 + u_xlat0.x;
    u_xlat0.x = u_xlat7 * u_xlat10_14 + u_xlat0.x;
    u_xlat16_7 = (-_LightShadowData.x) + 1.0;
    u_xlat0 = u_xlat0.xxxx * vec4(u_xlat16_7) + _LightShadowData.xxxx;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
in highp vec3 in_TEXCOORD1;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
out highp vec3 vs_TEXCOORD2;
out highp vec3 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
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
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraInvProjection[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraInvProjection[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    vs_TEXCOORD0.zw = u_xlat1.zz + u_xlat1.xw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    vs_TEXCOORD1.xyz = in_TEXCOORD1.xyz;
    u_xlat1.xyz = u_xlat0.xyz + (-hlslcc_mtx4x4unity_CameraInvProjection[2].xyz);
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[2].xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.w = (-u_xlat1.z);
    vs_TEXCOORD2.xyz = u_xlat1.xyw;
    u_xlat0.w = (-u_xlat0.z);
    vs_TEXCOORD3.xyz = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp float u_xlat10_1;
vec4 u_xlat2;
lowp float u_xlat10_2;
vec4 u_xlat3;
vec4 u_xlat4;
vec4 u_xlat5;
vec4 u_xlat6;
float u_xlat7;
mediump float u_xlat16_7;
lowp float u_xlat10_8;
lowp float u_xlat10_14;
vec2 u_xlat15;
lowp float u_xlat10_15;
lowp float u_xlat10_21;
lowp float u_xlat10_22;
void main()
{
    u_xlat0.z = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat0.xy = vs_TEXCOORD0.zw;
    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraInvProjection[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraInvProjection[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraInvProjection[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraInvProjection[3];
    u_xlat0.xyz = u_xlat0.xyz / u_xlat0.www;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * (-u_xlat0.zzzz) + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat1.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[3].xyz * u_xlat0.www + u_xlat0.xyz;
    u_xlat1.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + vec2(0.5, 0.5);
    u_xlat1.xy = floor(u_xlat1.xy);
    u_xlat0.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + (-u_xlat1.xy);
    u_xlat15.xy = min(u_xlat0.xy, vec2(0.0, 0.0));
    u_xlat2.xy = (-u_xlat0.xy) + vec2(1.0, 1.0);
    u_xlat15.xy = (-u_xlat15.xy) * u_xlat15.xy + u_xlat2.xy;
    u_xlat2.xy = u_xlat2.xy * vec2(0.159999996, 0.159999996);
    u_xlat15.xy = u_xlat15.xy + vec2(1.0, 1.0);
    u_xlat3.xy = u_xlat15.xy * vec2(0.159999996, 0.159999996);
    u_xlat15.xy = max(u_xlat0.xy, vec2(0.0, 0.0));
    u_xlat4 = u_xlat0.xxyy + vec4(0.5, 1.0, 0.5, 1.0);
    u_xlat15.xy = (-u_xlat15.xy) * u_xlat15.xy + u_xlat4.yw;
    u_xlat15.xy = u_xlat15.xy + vec2(1.0, 1.0);
    u_xlat5.xy = u_xlat15.xy * vec2(0.159999996, 0.159999996);
    u_xlat6 = u_xlat4.xxzz * u_xlat4.xxzz;
    u_xlat15.xy = vec2(u_xlat4.y * float(0.159999996), u_xlat4.w * float(0.159999996));
    u_xlat0.xy = u_xlat6.xz * vec2(0.5, 0.5) + (-u_xlat0.xy);
    u_xlat2.zw = vec2(u_xlat6.w * float(0.0799999982), u_xlat6.y * float(0.0799999982));
    u_xlat4.xy = u_xlat0.xy * vec2(0.159999996, 0.159999996);
    u_xlat3.z = u_xlat4.y;
    u_xlat3.w = u_xlat15.y;
    u_xlat4.w = u_xlat15.x;
    u_xlat5.zw = u_xlat2.yz;
    u_xlat0.xyw = vec3(u_xlat3.z + u_xlat5.z, u_xlat3.y + u_xlat5.y, u_xlat3.w + u_xlat5.w);
    u_xlat4.z = u_xlat3.x;
    u_xlat3.xyz = vec3(u_xlat5.z / u_xlat0.x, u_xlat5.y / u_xlat0.y, u_xlat5.w / u_xlat0.w);
    u_xlat2.z = u_xlat5.x;
    u_xlat3.xyz = u_xlat3.xyz + vec3(-2.5, -0.5, 1.5);
    u_xlat3.xyz = u_xlat3.xyz * _ShadowMapTexture_TexelSize.yyy;
    u_xlat5.w = u_xlat3.x;
    u_xlat4 = u_xlat2.zwxz + u_xlat4.zwxz;
    u_xlat2.xyz = vec3(u_xlat2.x / u_xlat4.z, u_xlat2.z / u_xlat4.w, u_xlat2.w / u_xlat4.y);
    u_xlat2.xyz = u_xlat2.xyz + vec3(-2.5, -0.5, 1.5);
    u_xlat5.xyz = u_xlat2.yxz * _ShadowMapTexture_TexelSize.xxx;
    u_xlat2 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.ywxw;
    u_xlat15.xy = u_xlat1.xy * _ShadowMapTexture_TexelSize.xy + u_xlat5.zw;
    vec3 txVec0 = vec3(u_xlat15.xy,u_xlat0.z);
    u_xlat10_15 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    vec3 txVec1 = vec3(u_xlat2.xy,u_xlat0.z);
    u_xlat10_22 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec1, 0.0);
    vec3 txVec2 = vec3(u_xlat2.zw,u_xlat0.z);
    u_xlat10_2 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec2, 0.0);
    u_xlat6 = vec4(u_xlat0.x * u_xlat4.z, u_xlat0.x * u_xlat4.w, u_xlat0.x * u_xlat4.y, u_xlat0.y * u_xlat4.z);
    u_xlat0.x = u_xlat10_2 * u_xlat6.y;
    u_xlat0.x = u_xlat6.x * u_xlat10_22 + u_xlat0.x;
    u_xlat0.x = u_xlat6.z * u_xlat10_15 + u_xlat0.x;
    u_xlat3.w = u_xlat5.y;
    u_xlat2 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat3.wywz;
    u_xlat5.yw = u_xlat3.yz;
    vec3 txVec3 = vec3(u_xlat2.xy,u_xlat0.z);
    u_xlat10_15 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec3, 0.0);
    vec3 txVec4 = vec3(u_xlat2.zw,u_xlat0.z);
    u_xlat10_22 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec4, 0.0);
    u_xlat0.x = u_xlat6.w * u_xlat10_15 + u_xlat0.x;
    u_xlat2 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xyzy;
    u_xlat3 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xwzw;
    vec3 txVec5 = vec3(u_xlat2.xy,u_xlat0.z);
    u_xlat10_1 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec5, 0.0);
    vec3 txVec6 = vec3(u_xlat2.zw,u_xlat0.z);
    u_xlat10_8 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec6, 0.0);
    u_xlat2 = vec4(u_xlat0.y * u_xlat4.x, u_xlat0.y * u_xlat4.y, u_xlat0.w * u_xlat4.z, u_xlat0.w * u_xlat4.w);
    u_xlat7 = u_xlat0.w * u_xlat4.y;
    u_xlat0.x = u_xlat2.x * u_xlat10_1 + u_xlat0.x;
    u_xlat0.x = u_xlat2.y * u_xlat10_8 + u_xlat0.x;
    u_xlat0.x = u_xlat2.z * u_xlat10_22 + u_xlat0.x;
    vec3 txVec7 = vec3(u_xlat3.xy,u_xlat0.z);
    u_xlat10_21 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec7, 0.0);
    vec3 txVec8 = vec3(u_xlat3.zw,u_xlat0.z);
    u_xlat10_14 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec8, 0.0);
    u_xlat0.x = u_xlat2.w * u_xlat10_21 + u_xlat0.x;
    u_xlat0.x = u_xlat7 * u_xlat10_14 + u_xlat0.x;
    u_xlat16_7 = (-_LightShadowData.x) + 1.0;
    u_xlat0 = u_xlat0.xxxx * vec4(u_xlat16_7) + _LightShadowData.xxxx;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ProjectionParams;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in highp vec2 in_TEXCOORD0;
in highp vec3 in_TEXCOORD1;
out highp vec4 vs_TEXCOORD0;
out highp vec3 vs_TEXCOORD1;
out highp vec3 vs_TEXCOORD2;
out highp vec3 vs_TEXCOORD3;
vec4 u_xlat0;
vec4 u_xlat1;
vec3 u_xlat2;
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
    u_xlat0.y = u_xlat0.y * _ProjectionParams.x;
    u_xlat1.xzw = u_xlat0.xwy * vec3(0.5, 0.5, 0.5);
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraInvProjection[1].xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraInvProjection[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    vs_TEXCOORD0.zw = u_xlat1.zz + u_xlat1.xw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    vs_TEXCOORD1.xyz = in_TEXCOORD1.xyz;
    u_xlat1.xyz = u_xlat0.xyz + (-hlslcc_mtx4x4unity_CameraInvProjection[2].xyz);
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[2].xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_CameraInvProjection[3].xyz;
    u_xlat1.w = (-u_xlat1.z);
    vs_TEXCOORD2.xyz = u_xlat1.xyw;
    u_xlat0.w = (-u_xlat0.z);
    vs_TEXCOORD3.xyz = u_xlat0.xyw;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	vec4 hlslcc_mtx4x4unity_CameraInvProjection[4];
uniform 	vec4 hlslcc_mtx4x4unity_CameraToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 _ShadowMapTexture_TexelSize;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp float u_xlat10_1;
vec4 u_xlat2;
lowp float u_xlat10_2;
vec4 u_xlat3;
vec4 u_xlat4;
vec4 u_xlat5;
vec4 u_xlat6;
float u_xlat7;
mediump float u_xlat16_7;
lowp float u_xlat10_8;
lowp float u_xlat10_14;
vec2 u_xlat15;
lowp float u_xlat10_15;
lowp float u_xlat10_21;
lowp float u_xlat10_22;
void main()
{
    u_xlat0.z = texture(_CameraDepthTexture, vs_TEXCOORD0.xy).x;
    u_xlat0.xy = vs_TEXCOORD0.zw;
    u_xlat0.xyz = u_xlat0.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraInvProjection[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraInvProjection[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraInvProjection[2] * u_xlat0.zzzz + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraInvProjection[3];
    u_xlat0.xyz = u_xlat0.xyz / u_xlat0.www;
    u_xlat1 = u_xlat0.yyyy * hlslcc_mtx4x4unity_CameraToWorld[1];
    u_xlat1 = hlslcc_mtx4x4unity_CameraToWorld[0] * u_xlat0.xxxx + u_xlat1;
    u_xlat0 = hlslcc_mtx4x4unity_CameraToWorld[2] * (-u_xlat0.zzzz) + u_xlat1;
    u_xlat0 = u_xlat0 + hlslcc_mtx4x4unity_CameraToWorld[3];
    u_xlat1.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToShadow[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToShadow[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToShadow[3].xyz * u_xlat0.www + u_xlat0.xyz;
    u_xlat1.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + vec2(0.5, 0.5);
    u_xlat1.xy = floor(u_xlat1.xy);
    u_xlat0.xy = u_xlat0.xy * _ShadowMapTexture_TexelSize.zw + (-u_xlat1.xy);
    u_xlat15.xy = min(u_xlat0.xy, vec2(0.0, 0.0));
    u_xlat2.xy = (-u_xlat0.xy) + vec2(1.0, 1.0);
    u_xlat15.xy = (-u_xlat15.xy) * u_xlat15.xy + u_xlat2.xy;
    u_xlat2.xy = u_xlat2.xy * vec2(0.159999996, 0.159999996);
    u_xlat15.xy = u_xlat15.xy + vec2(1.0, 1.0);
    u_xlat3.xy = u_xlat15.xy * vec2(0.159999996, 0.159999996);
    u_xlat15.xy = max(u_xlat0.xy, vec2(0.0, 0.0));
    u_xlat4 = u_xlat0.xxyy + vec4(0.5, 1.0, 0.5, 1.0);
    u_xlat15.xy = (-u_xlat15.xy) * u_xlat15.xy + u_xlat4.yw;
    u_xlat15.xy = u_xlat15.xy + vec2(1.0, 1.0);
    u_xlat5.xy = u_xlat15.xy * vec2(0.159999996, 0.159999996);
    u_xlat6 = u_xlat4.xxzz * u_xlat4.xxzz;
    u_xlat15.xy = vec2(u_xlat4.y * float(0.159999996), u_xlat4.w * float(0.159999996));
    u_xlat0.xy = u_xlat6.xz * vec2(0.5, 0.5) + (-u_xlat0.xy);
    u_xlat2.zw = vec2(u_xlat6.w * float(0.0799999982), u_xlat6.y * float(0.0799999982));
    u_xlat4.xy = u_xlat0.xy * vec2(0.159999996, 0.159999996);
    u_xlat3.z = u_xlat4.y;
    u_xlat3.w = u_xlat15.y;
    u_xlat4.w = u_xlat15.x;
    u_xlat5.zw = u_xlat2.yz;
    u_xlat0.xyw = vec3(u_xlat3.z + u_xlat5.z, u_xlat3.y + u_xlat5.y, u_xlat3.w + u_xlat5.w);
    u_xlat4.z = u_xlat3.x;
    u_xlat3.xyz = vec3(u_xlat5.z / u_xlat0.x, u_xlat5.y / u_xlat0.y, u_xlat5.w / u_xlat0.w);
    u_xlat2.z = u_xlat5.x;
    u_xlat3.xyz = u_xlat3.xyz + vec3(-2.5, -0.5, 1.5);
    u_xlat3.xyz = u_xlat3.xyz * _ShadowMapTexture_TexelSize.yyy;
    u_xlat5.w = u_xlat3.x;
    u_xlat4 = u_xlat2.zwxz + u_xlat4.zwxz;
    u_xlat2.xyz = vec3(u_xlat2.x / u_xlat4.z, u_xlat2.z / u_xlat4.w, u_xlat2.w / u_xlat4.y);
    u_xlat2.xyz = u_xlat2.xyz + vec3(-2.5, -0.5, 1.5);
    u_xlat5.xyz = u_xlat2.yxz * _ShadowMapTexture_TexelSize.xxx;
    u_xlat2 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.ywxw;
    u_xlat15.xy = u_xlat1.xy * _ShadowMapTexture_TexelSize.xy + u_xlat5.zw;
    vec3 txVec0 = vec3(u_xlat15.xy,u_xlat0.z);
    u_xlat10_15 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    vec3 txVec1 = vec3(u_xlat2.xy,u_xlat0.z);
    u_xlat10_22 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec1, 0.0);
    vec3 txVec2 = vec3(u_xlat2.zw,u_xlat0.z);
    u_xlat10_2 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec2, 0.0);
    u_xlat6 = vec4(u_xlat0.x * u_xlat4.z, u_xlat0.x * u_xlat4.w, u_xlat0.x * u_xlat4.y, u_xlat0.y * u_xlat4.z);
    u_xlat0.x = u_xlat10_2 * u_xlat6.y;
    u_xlat0.x = u_xlat6.x * u_xlat10_22 + u_xlat0.x;
    u_xlat0.x = u_xlat6.z * u_xlat10_15 + u_xlat0.x;
    u_xlat3.w = u_xlat5.y;
    u_xlat2 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat3.wywz;
    u_xlat5.yw = u_xlat3.yz;
    vec3 txVec3 = vec3(u_xlat2.xy,u_xlat0.z);
    u_xlat10_15 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec3, 0.0);
    vec3 txVec4 = vec3(u_xlat2.zw,u_xlat0.z);
    u_xlat10_22 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec4, 0.0);
    u_xlat0.x = u_xlat6.w * u_xlat10_15 + u_xlat0.x;
    u_xlat2 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xyzy;
    u_xlat3 = u_xlat1.xyxy * _ShadowMapTexture_TexelSize.xyxy + u_xlat5.xwzw;
    vec3 txVec5 = vec3(u_xlat2.xy,u_xlat0.z);
    u_xlat10_1 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec5, 0.0);
    vec3 txVec6 = vec3(u_xlat2.zw,u_xlat0.z);
    u_xlat10_8 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec6, 0.0);
    u_xlat2 = vec4(u_xlat0.y * u_xlat4.x, u_xlat0.y * u_xlat4.y, u_xlat0.w * u_xlat4.z, u_xlat0.w * u_xlat4.w);
    u_xlat7 = u_xlat0.w * u_xlat4.y;
    u_xlat0.x = u_xlat2.x * u_xlat10_1 + u_xlat0.x;
    u_xlat0.x = u_xlat2.y * u_xlat10_8 + u_xlat0.x;
    u_xlat0.x = u_xlat2.z * u_xlat10_22 + u_xlat0.x;
    vec3 txVec7 = vec3(u_xlat3.xy,u_xlat0.z);
    u_xlat10_21 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec7, 0.0);
    vec3 txVec8 = vec3(u_xlat3.zw,u_xlat0.z);
    u_xlat10_14 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec8, 0.0);
    u_xlat0.x = u_xlat2.w * u_xlat10_21 + u_xlat0.x;
    u_xlat0.x = u_xlat7 * u_xlat10_14 + u_xlat0.x;
    u_xlat16_7 = (-_LightShadowData.x) + 1.0;
    u_xlat0 = u_xlat0.xxxx * vec4(u_xlat16_7) + _LightShadowData.xxxx;
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
SubProgram "gles hw_tier00 " {
Keywords { "SHADOWS_SPLIT_SPHERES" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "SHADOWS_SPLIT_SPHERES" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "SHADOWS_SPLIT_SPHERES" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SHADOWS_SPLIT_SPHERES" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SHADOWS_SPLIT_SPHERES" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SHADOWS_SPLIT_SPHERES" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "SHADOWS_SINGLE_CASCADE" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "SHADOWS_SINGLE_CASCADE" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "SHADOWS_SINGLE_CASCADE" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SHADOWS_SINGLE_CASCADE" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SHADOWS_SINGLE_CASCADE" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SHADOWS_SINGLE_CASCADE" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SHADOWS_SPLIT_SPHERES" "SHADOWS_SINGLE_CASCADE" }
""
}
}
}
}
}