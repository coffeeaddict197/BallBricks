//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Hidden/Internal-PrePassLighting" {
Properties {
_LightTexture0 ("", any) = "" { }
_LightTextureB0 ("", 2D) = "" { }
_ShadowMapTexture ("", any) = "" { }
}
SubShader {
 Pass {
  Tags { "SHADOWSUPPORT" = "true" }
  ZWrite Off
  GpuProgramID 60282
Program "vp" {
SubProgram "gles hw_tier00 " {
Keywords { "POINT" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp sampler2D _LightTextureB0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(normalize(tmpvar_12));
  lightDir_7 = tmpvar_13;
  atten_6 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w))).w;
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_14 = texture2D (_CameraNormalsTexture, P_15);
  nspec_5 = tmpvar_14;
  mediump vec3 tmpvar_16;
  tmpvar_16 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_17;
  tmpvar_17 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = pow (max (0.0, dot (h_4, tmpvar_16)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_18;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_16)
  ) * atten_6));
  mediump vec3 rgb_19;
  rgb_19 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_19, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_20;
  tmpvar_20 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_20);
  mediump vec4 tmpvar_21;
  tmpvar_21 = exp2(-(res_2));
  tmpvar_1 = tmpvar_21;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp sampler2D _LightTextureB0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(normalize(tmpvar_12));
  lightDir_7 = tmpvar_13;
  atten_6 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w))).w;
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_14 = texture2D (_CameraNormalsTexture, P_15);
  nspec_5 = tmpvar_14;
  mediump vec3 tmpvar_16;
  tmpvar_16 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_17;
  tmpvar_17 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = pow (max (0.0, dot (h_4, tmpvar_16)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_18;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_16)
  ) * atten_6));
  mediump vec3 rgb_19;
  rgb_19 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_19, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_20;
  tmpvar_20 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_20);
  mediump vec4 tmpvar_21;
  tmpvar_21 = exp2(-(res_2));
  tmpvar_1 = tmpvar_21;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp sampler2D _LightTextureB0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(normalize(tmpvar_12));
  lightDir_7 = tmpvar_13;
  atten_6 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w))).w;
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_14 = texture2D (_CameraNormalsTexture, P_15);
  nspec_5 = tmpvar_14;
  mediump vec3 tmpvar_16;
  tmpvar_16 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_17;
  tmpvar_17 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = pow (max (0.0, dot (h_4, tmpvar_16)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_18;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_16)
  ) * atten_6));
  mediump vec3 rgb_19;
  rgb_19 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_19, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_20;
  tmpvar_20 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_20);
  mediump vec4 tmpvar_21;
  tmpvar_21 = exp2(-(res_2));
  tmpvar_1 = tmpvar_21;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "POINT" }
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec3 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
float u_xlat14;
float u_xlat21;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat4.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat14 = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat14 = sqrt(u_xlat14);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat14;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat21 = inversesqrt(u_xlat14);
    u_xlat14 = u_xlat14 * _LightPos.w;
    u_xlat14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat4.xyz;
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat7.xxx + (-u_xlat2.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat3.xyz = u_xlat7.xxx * u_xlat3.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat3.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot((-u_xlat2.xyz), u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat7.x = u_xlat14 * u_xlat16_5.x;
    u_xlat14 = u_xlat14;
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat1.xyz = u_xlat7.xxx * _LightColor.xyz;
    u_xlat16_5.x = max(u_xlat16_6, 0.0);
    u_xlat16_5.x = log2(u_xlat16_5.x);
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_26;
    u_xlat16_5.x = exp2(u_xlat16_5.x);
    u_xlat7.x = u_xlat14 * u_xlat16_5.x;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat7.x * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = exp2((-u_xlat0));
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT" }
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec3 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
float u_xlat14;
float u_xlat21;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat4.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat14 = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat14 = sqrt(u_xlat14);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat14;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat21 = inversesqrt(u_xlat14);
    u_xlat14 = u_xlat14 * _LightPos.w;
    u_xlat14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat4.xyz;
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat7.xxx + (-u_xlat2.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat3.xyz = u_xlat7.xxx * u_xlat3.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat3.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot((-u_xlat2.xyz), u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat7.x = u_xlat14 * u_xlat16_5.x;
    u_xlat14 = u_xlat14;
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat1.xyz = u_xlat7.xxx * _LightColor.xyz;
    u_xlat16_5.x = max(u_xlat16_6, 0.0);
    u_xlat16_5.x = log2(u_xlat16_5.x);
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_26;
    u_xlat16_5.x = exp2(u_xlat16_5.x);
    u_xlat7.x = u_xlat14 * u_xlat16_5.x;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat7.x * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = exp2((-u_xlat0));
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT" }
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec3 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
float u_xlat14;
float u_xlat21;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat4.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat14 = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat14 = sqrt(u_xlat14);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat14;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat21 = inversesqrt(u_xlat14);
    u_xlat14 = u_xlat14 * _LightPos.w;
    u_xlat14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat4.xyz;
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat7.xxx + (-u_xlat2.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat3.xyz = u_xlat7.xxx * u_xlat3.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat3.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot((-u_xlat2.xyz), u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat7.x = u_xlat14 * u_xlat16_5.x;
    u_xlat14 = u_xlat14;
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat1.xyz = u_xlat7.xxx * _LightColor.xyz;
    u_xlat16_5.x = max(u_xlat16_6, 0.0);
    u_xlat16_5.x = log2(u_xlat16_5.x);
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_26;
    u_xlat16_5.x = exp2(u_xlat16_5.x);
    u_xlat7.x = u_xlat14 * u_xlat16_5.x;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat7.x * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = exp2((-u_xlat0));
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "DIRECTIONAL" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_11;
  lowp vec4 tmpvar_12;
  highp vec2 P_13;
  P_13 = ((tmpvar_7 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_12 = texture2D (_CameraNormalsTexture, P_13);
  nspec_5 = tmpvar_12;
  mediump vec3 tmpvar_14;
  tmpvar_14 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize((lightDir_6 - normalize(
    (tmpvar_9 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_15;
  mediump float tmpvar_16;
  tmpvar_16 = pow (max (0.0, dot (h_4, tmpvar_14)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_16;
  spec_3 = (spec_3 * clamp (1.0, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * max (0.0, dot (lightDir_6, tmpvar_14)));
  mediump vec3 rgb_17;
  rgb_17 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_17, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_18;
  tmpvar_18 = clamp ((1.0 - (
    (mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_18);
  mediump vec4 tmpvar_19;
  tmpvar_19 = exp2(-(res_2));
  tmpvar_1 = tmpvar_19;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_11;
  lowp vec4 tmpvar_12;
  highp vec2 P_13;
  P_13 = ((tmpvar_7 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_12 = texture2D (_CameraNormalsTexture, P_13);
  nspec_5 = tmpvar_12;
  mediump vec3 tmpvar_14;
  tmpvar_14 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize((lightDir_6 - normalize(
    (tmpvar_9 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_15;
  mediump float tmpvar_16;
  tmpvar_16 = pow (max (0.0, dot (h_4, tmpvar_14)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_16;
  spec_3 = (spec_3 * clamp (1.0, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * max (0.0, dot (lightDir_6, tmpvar_14)));
  mediump vec3 rgb_17;
  rgb_17 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_17, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_18;
  tmpvar_18 = clamp ((1.0 - (
    (mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_18);
  mediump vec4 tmpvar_19;
  tmpvar_19 = exp2(-(res_2));
  tmpvar_1 = tmpvar_19;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_11;
  lowp vec4 tmpvar_12;
  highp vec2 P_13;
  P_13 = ((tmpvar_7 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_12 = texture2D (_CameraNormalsTexture, P_13);
  nspec_5 = tmpvar_12;
  mediump vec3 tmpvar_14;
  tmpvar_14 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize((lightDir_6 - normalize(
    (tmpvar_9 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_15;
  mediump float tmpvar_16;
  tmpvar_16 = pow (max (0.0, dot (h_4, tmpvar_14)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_16;
  spec_3 = (spec_3 * clamp (1.0, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * max (0.0, dot (lightDir_6, tmpvar_14)));
  mediump vec3 rgb_17;
  rgb_17 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_17, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_18;
  tmpvar_18 = clamp ((1.0 - (
    (mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_18);
  mediump vec4 tmpvar_19;
  tmpvar_19 = exp2(-(res_2));
  tmpvar_1 = tmpvar_19;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "DIRECTIONAL" }
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump float u_xlat16_5;
vec3 u_xlat6;
mediump float u_xlat16_10;
float u_xlat12;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat12 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat12 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat6.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat6.xyz = u_xlat6.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat6.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = sqrt(u_xlat6.x);
    u_xlat0.x = (-u_xlat6.z) * u_xlat0.x + u_xlat6.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat6.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat6.xyz = (-u_xlat2.xyw) * u_xlat6.xxx + (-_LightDir.xyz);
    u_xlat2.x = dot(u_xlat6.xyz, u_xlat6.xyz);
    u_xlat2.x = inversesqrt(u_xlat2.x);
    u_xlat6.xyz = u_xlat6.xyz * u_xlat2.xxx;
    u_xlat16_4.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = u_xlat10_1.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat6.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
    u_xlat16_4.x = max(u_xlat16_4.x, 0.0);
    u_xlat1.xyz = u_xlat16_4.xxx * _LightColor.xyz;
    u_xlat16_4.x = max(u_xlat16_5, 0.0);
    u_xlat16_4.x = log2(u_xlat16_4.x);
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_22;
    u_xlat16_4.x = exp2(u_xlat16_4.x);
    u_xlat16_10 = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_10 * u_xlat16_4.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = exp2((-u_xlat0));
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "DIRECTIONAL" }
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump float u_xlat16_5;
vec3 u_xlat6;
mediump float u_xlat16_10;
float u_xlat12;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat12 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat12 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat6.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat6.xyz = u_xlat6.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat6.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = sqrt(u_xlat6.x);
    u_xlat0.x = (-u_xlat6.z) * u_xlat0.x + u_xlat6.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat6.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat6.xyz = (-u_xlat2.xyw) * u_xlat6.xxx + (-_LightDir.xyz);
    u_xlat2.x = dot(u_xlat6.xyz, u_xlat6.xyz);
    u_xlat2.x = inversesqrt(u_xlat2.x);
    u_xlat6.xyz = u_xlat6.xyz * u_xlat2.xxx;
    u_xlat16_4.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = u_xlat10_1.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat6.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
    u_xlat16_4.x = max(u_xlat16_4.x, 0.0);
    u_xlat1.xyz = u_xlat16_4.xxx * _LightColor.xyz;
    u_xlat16_4.x = max(u_xlat16_5, 0.0);
    u_xlat16_4.x = log2(u_xlat16_4.x);
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_22;
    u_xlat16_4.x = exp2(u_xlat16_4.x);
    u_xlat16_10 = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_10 * u_xlat16_4.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = exp2((-u_xlat0));
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "DIRECTIONAL" }
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump float u_xlat16_5;
vec3 u_xlat6;
mediump float u_xlat16_10;
float u_xlat12;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat12 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat12 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat6.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat6.xyz = u_xlat6.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat6.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = sqrt(u_xlat6.x);
    u_xlat0.x = (-u_xlat6.z) * u_xlat0.x + u_xlat6.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat6.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat6.xyz = (-u_xlat2.xyw) * u_xlat6.xxx + (-_LightDir.xyz);
    u_xlat2.x = dot(u_xlat6.xyz, u_xlat6.xyz);
    u_xlat2.x = inversesqrt(u_xlat2.x);
    u_xlat6.xyz = u_xlat6.xyz * u_xlat2.xxx;
    u_xlat16_4.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = u_xlat10_1.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat6.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
    u_xlat16_4.x = max(u_xlat16_4.x, 0.0);
    u_xlat1.xyz = u_xlat16_4.xxx * _LightColor.xyz;
    u_xlat16_4.x = max(u_xlat16_5, 0.0);
    u_xlat16_4.x = log2(u_xlat16_4.x);
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_22;
    u_xlat16_4.x = exp2(u_xlat16_4.x);
    u_xlat16_10 = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_10 * u_xlat16_4.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = exp2((-u_xlat0));
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "SPOT" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize(tmpvar_12);
  lightDir_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = tmpvar_10;
  highp vec4 tmpvar_15;
  tmpvar_15 = (unity_WorldToLight * tmpvar_14);
  highp vec4 tmpvar_16;
  tmpvar_16.zw = vec2(0.0, -8.0);
  tmpvar_16.xy = (tmpvar_15.xy / tmpvar_15.w);
  atten_6 = (texture2D (_LightTexture0, tmpvar_16.xy, -8.0).w * float((tmpvar_15.w < 0.0)));
  atten_6 = (atten_6 * texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w))).w);
  lowp vec4 tmpvar_17;
  highp vec2 P_18;
  P_18 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_17 = texture2D (_CameraNormalsTexture, P_18);
  nspec_5 = tmpvar_17;
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = pow (max (0.0, dot (h_4, tmpvar_19)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_21;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_19)
  ) * atten_6));
  mediump vec3 rgb_22;
  rgb_22 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_22, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_23;
  tmpvar_23 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_23);
  mediump vec4 tmpvar_24;
  tmpvar_24 = exp2(-(res_2));
  tmpvar_1 = tmpvar_24;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "SPOT" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize(tmpvar_12);
  lightDir_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = tmpvar_10;
  highp vec4 tmpvar_15;
  tmpvar_15 = (unity_WorldToLight * tmpvar_14);
  highp vec4 tmpvar_16;
  tmpvar_16.zw = vec2(0.0, -8.0);
  tmpvar_16.xy = (tmpvar_15.xy / tmpvar_15.w);
  atten_6 = (texture2D (_LightTexture0, tmpvar_16.xy, -8.0).w * float((tmpvar_15.w < 0.0)));
  atten_6 = (atten_6 * texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w))).w);
  lowp vec4 tmpvar_17;
  highp vec2 P_18;
  P_18 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_17 = texture2D (_CameraNormalsTexture, P_18);
  nspec_5 = tmpvar_17;
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = pow (max (0.0, dot (h_4, tmpvar_19)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_21;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_19)
  ) * atten_6));
  mediump vec3 rgb_22;
  rgb_22 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_22, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_23;
  tmpvar_23 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_23);
  mediump vec4 tmpvar_24;
  tmpvar_24 = exp2(-(res_2));
  tmpvar_1 = tmpvar_24;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "SPOT" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize(tmpvar_12);
  lightDir_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = tmpvar_10;
  highp vec4 tmpvar_15;
  tmpvar_15 = (unity_WorldToLight * tmpvar_14);
  highp vec4 tmpvar_16;
  tmpvar_16.zw = vec2(0.0, -8.0);
  tmpvar_16.xy = (tmpvar_15.xy / tmpvar_15.w);
  atten_6 = (texture2D (_LightTexture0, tmpvar_16.xy, -8.0).w * float((tmpvar_15.w < 0.0)));
  atten_6 = (atten_6 * texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w))).w);
  lowp vec4 tmpvar_17;
  highp vec2 P_18;
  P_18 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_17 = texture2D (_CameraNormalsTexture, P_18);
  nspec_5 = tmpvar_17;
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = pow (max (0.0, dot (h_4, tmpvar_19)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_21;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_19)
  ) * atten_6));
  mediump vec3 rgb_22;
  rgb_22 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_22, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_23;
  tmpvar_23 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_23);
  mediump vec4 tmpvar_24;
  tmpvar_24 = exp2(-(res_2));
  tmpvar_1 = tmpvar_24;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SPOT" }
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
bool u_xlatb1;
vec4 u_xlat2;
vec3 u_xlat3;
vec3 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_12;
float u_xlat14;
float u_xlat24;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat4.xyz = (-u_xlat2.xyw) + _LightPos.xyz;
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat24 = inversesqrt(u_xlat14);
    u_xlat14 = u_xlat14 * _LightPos.w;
    u_xlat14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat4.xyz = vec3(u_xlat24) * u_xlat4.xyz;
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat7.xxx + u_xlat4.xyz;
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat3.xyz = u_xlat7.xxx * u_xlat3.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat3.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot(u_xlat4.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat16_12 = max(u_xlat16_6, 0.0);
    u_xlat16_12 = log2(u_xlat16_12);
    u_xlat16_12 = u_xlat16_12 * u_xlat16_26;
    u_xlat16_12 = exp2(u_xlat16_12);
    u_xlat1.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat2.xxx + u_xlat1.xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat2.www + u_xlat1.xyz;
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat7.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat7.xz = u_xlat1.xy / u_xlat1.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb1 = !!(u_xlat1.z<0.0);
#else
    u_xlatb1 = u_xlat1.z<0.0;
#endif
    u_xlat1.x = u_xlatb1 ? 1.0 : float(0.0);
    u_xlat7.x = texture(_LightTexture0, u_xlat7.xz, -8.0).w;
    u_xlat7.x = u_xlat1.x * u_xlat7.x;
    u_xlat7.x = u_xlat14 * u_xlat7.x;
    u_xlat14 = u_xlat7.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat7.x = u_xlat7.x * u_xlat16_5.x;
    u_xlat1.xyz = u_xlat7.xxx * _LightColor.xyz;
    u_xlat7.x = u_xlat14 * u_xlat16_12;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat7.x * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = exp2((-u_xlat0));
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SPOT" }
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
bool u_xlatb1;
vec4 u_xlat2;
vec3 u_xlat3;
vec3 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_12;
float u_xlat14;
float u_xlat24;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat4.xyz = (-u_xlat2.xyw) + _LightPos.xyz;
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat24 = inversesqrt(u_xlat14);
    u_xlat14 = u_xlat14 * _LightPos.w;
    u_xlat14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat4.xyz = vec3(u_xlat24) * u_xlat4.xyz;
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat7.xxx + u_xlat4.xyz;
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat3.xyz = u_xlat7.xxx * u_xlat3.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat3.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot(u_xlat4.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat16_12 = max(u_xlat16_6, 0.0);
    u_xlat16_12 = log2(u_xlat16_12);
    u_xlat16_12 = u_xlat16_12 * u_xlat16_26;
    u_xlat16_12 = exp2(u_xlat16_12);
    u_xlat1.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat2.xxx + u_xlat1.xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat2.www + u_xlat1.xyz;
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat7.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat7.xz = u_xlat1.xy / u_xlat1.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb1 = !!(u_xlat1.z<0.0);
#else
    u_xlatb1 = u_xlat1.z<0.0;
#endif
    u_xlat1.x = u_xlatb1 ? 1.0 : float(0.0);
    u_xlat7.x = texture(_LightTexture0, u_xlat7.xz, -8.0).w;
    u_xlat7.x = u_xlat1.x * u_xlat7.x;
    u_xlat7.x = u_xlat14 * u_xlat7.x;
    u_xlat14 = u_xlat7.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat7.x = u_xlat7.x * u_xlat16_5.x;
    u_xlat1.xyz = u_xlat7.xxx * _LightColor.xyz;
    u_xlat7.x = u_xlat14 * u_xlat16_12;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat7.x * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = exp2((-u_xlat0));
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SPOT" }
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
bool u_xlatb1;
vec4 u_xlat2;
vec3 u_xlat3;
vec3 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_12;
float u_xlat14;
float u_xlat24;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat4.xyz = (-u_xlat2.xyw) + _LightPos.xyz;
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat24 = inversesqrt(u_xlat14);
    u_xlat14 = u_xlat14 * _LightPos.w;
    u_xlat14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat4.xyz = vec3(u_xlat24) * u_xlat4.xyz;
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat7.xxx + u_xlat4.xyz;
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat3.xyz = u_xlat7.xxx * u_xlat3.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat3.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot(u_xlat4.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat16_12 = max(u_xlat16_6, 0.0);
    u_xlat16_12 = log2(u_xlat16_12);
    u_xlat16_12 = u_xlat16_12 * u_xlat16_26;
    u_xlat16_12 = exp2(u_xlat16_12);
    u_xlat1.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat2.xxx + u_xlat1.xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat2.www + u_xlat1.xyz;
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat7.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat7.xz = u_xlat1.xy / u_xlat1.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb1 = !!(u_xlat1.z<0.0);
#else
    u_xlatb1 = u_xlat1.z<0.0;
#endif
    u_xlat1.x = u_xlatb1 ? 1.0 : float(0.0);
    u_xlat7.x = texture(_LightTexture0, u_xlat7.xz, -8.0).w;
    u_xlat7.x = u_xlat1.x * u_xlat7.x;
    u_xlat7.x = u_xlat14 * u_xlat7.x;
    u_xlat14 = u_xlat7.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat7.x = u_xlat7.x * u_xlat16_5.x;
    u_xlat1.xyz = u_xlat7.xxx * _LightColor.xyz;
    u_xlat7.x = u_xlat14 * u_xlat16_12;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat7.x * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = exp2((-u_xlat0));
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT_COOKIE" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(normalize(tmpvar_12));
  lightDir_7 = tmpvar_13;
  atten_6 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w))).w;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = tmpvar_10;
  highp vec4 tmpvar_15;
  tmpvar_15.w = -8.0;
  tmpvar_15.xyz = (unity_WorldToLight * tmpvar_14).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_15.xyz, -8.0).w);
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_16 = texture2D (_CameraNormalsTexture, P_17);
  nspec_5 = tmpvar_16;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = pow (max (0.0, dot (h_4, tmpvar_18)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_20;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_18)
  ) * atten_6));
  mediump vec3 rgb_21;
  rgb_21 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_21, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_22;
  tmpvar_22 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_22);
  mediump vec4 tmpvar_23;
  tmpvar_23 = exp2(-(res_2));
  tmpvar_1 = tmpvar_23;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT_COOKIE" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(normalize(tmpvar_12));
  lightDir_7 = tmpvar_13;
  atten_6 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w))).w;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = tmpvar_10;
  highp vec4 tmpvar_15;
  tmpvar_15.w = -8.0;
  tmpvar_15.xyz = (unity_WorldToLight * tmpvar_14).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_15.xyz, -8.0).w);
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_16 = texture2D (_CameraNormalsTexture, P_17);
  nspec_5 = tmpvar_16;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = pow (max (0.0, dot (h_4, tmpvar_18)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_20;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_18)
  ) * atten_6));
  mediump vec3 rgb_21;
  rgb_21 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_21, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_22;
  tmpvar_22 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_22);
  mediump vec4 tmpvar_23;
  tmpvar_23 = exp2(-(res_2));
  tmpvar_1 = tmpvar_23;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT_COOKIE" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(normalize(tmpvar_12));
  lightDir_7 = tmpvar_13;
  atten_6 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w))).w;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = tmpvar_10;
  highp vec4 tmpvar_15;
  tmpvar_15.w = -8.0;
  tmpvar_15.xyz = (unity_WorldToLight * tmpvar_14).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_15.xyz, -8.0).w);
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_16 = texture2D (_CameraNormalsTexture, P_17);
  nspec_5 = tmpvar_16;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = pow (max (0.0, dot (h_4, tmpvar_18)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_20;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_18)
  ) * atten_6));
  mediump vec3 rgb_21;
  rgb_21 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_21, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_22;
  tmpvar_22 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_22);
  mediump vec4 tmpvar_23;
  tmpvar_23 = exp2(-(res_2));
  tmpvar_1 = tmpvar_23;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "POINT_COOKIE" }
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec3 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_12;
float u_xlat14;
float u_xlat24;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat4.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat24 = inversesqrt(u_xlat14);
    u_xlat14 = u_xlat14 * _LightPos.w;
    u_xlat14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat4.xyz = vec3(u_xlat24) * u_xlat4.xyz;
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat7.xxx + (-u_xlat4.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat3.xyz = u_xlat7.xxx * u_xlat3.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat3.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot((-u_xlat4.xyz), u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat16_12 = max(u_xlat16_6, 0.0);
    u_xlat16_12 = log2(u_xlat16_12);
    u_xlat16_12 = u_xlat16_12 * u_xlat16_26;
    u_xlat16_12 = exp2(u_xlat16_12);
    u_xlat1.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat1.xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat1.xyz;
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat7.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat7.x = texture(_LightTexture0, u_xlat1.xyz, -8.0).w;
    u_xlat7.x = u_xlat7.x * u_xlat14;
    u_xlat14 = u_xlat7.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat7.x = u_xlat7.x * u_xlat16_5.x;
    u_xlat1.xyz = u_xlat7.xxx * _LightColor.xyz;
    u_xlat7.x = u_xlat14 * u_xlat16_12;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat7.x * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = exp2((-u_xlat0));
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT_COOKIE" }
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec3 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_12;
float u_xlat14;
float u_xlat24;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat4.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat24 = inversesqrt(u_xlat14);
    u_xlat14 = u_xlat14 * _LightPos.w;
    u_xlat14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat4.xyz = vec3(u_xlat24) * u_xlat4.xyz;
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat7.xxx + (-u_xlat4.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat3.xyz = u_xlat7.xxx * u_xlat3.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat3.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot((-u_xlat4.xyz), u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat16_12 = max(u_xlat16_6, 0.0);
    u_xlat16_12 = log2(u_xlat16_12);
    u_xlat16_12 = u_xlat16_12 * u_xlat16_26;
    u_xlat16_12 = exp2(u_xlat16_12);
    u_xlat1.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat1.xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat1.xyz;
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat7.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat7.x = texture(_LightTexture0, u_xlat1.xyz, -8.0).w;
    u_xlat7.x = u_xlat7.x * u_xlat14;
    u_xlat14 = u_xlat7.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat7.x = u_xlat7.x * u_xlat16_5.x;
    u_xlat1.xyz = u_xlat7.xxx * _LightColor.xyz;
    u_xlat7.x = u_xlat14 * u_xlat16_12;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat7.x * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = exp2((-u_xlat0));
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT_COOKIE" }
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec3 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_12;
float u_xlat14;
float u_xlat24;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat4.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat24 = inversesqrt(u_xlat14);
    u_xlat14 = u_xlat14 * _LightPos.w;
    u_xlat14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat4.xyz = vec3(u_xlat24) * u_xlat4.xyz;
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat7.xxx + (-u_xlat4.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat3.xyz = u_xlat7.xxx * u_xlat3.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat3.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot((-u_xlat4.xyz), u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat16_12 = max(u_xlat16_6, 0.0);
    u_xlat16_12 = log2(u_xlat16_12);
    u_xlat16_12 = u_xlat16_12 * u_xlat16_26;
    u_xlat16_12 = exp2(u_xlat16_12);
    u_xlat1.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat1.xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat1.xyz;
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat7.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat7.x = texture(_LightTexture0, u_xlat1.xyz, -8.0).w;
    u_xlat7.x = u_xlat7.x * u_xlat14;
    u_xlat14 = u_xlat7.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat7.x = u_xlat7.x * u_xlat16_5.x;
    u_xlat1.xyz = u_xlat7.xxx * _LightColor.xyz;
    u_xlat7.x = u_xlat14 * u_xlat16_12;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat7.x * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = exp2((-u_xlat0));
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "DIRECTIONAL_COOKIE" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_10;
  highp vec4 tmpvar_14;
  tmpvar_14.zw = vec2(0.0, -8.0);
  tmpvar_14.xy = (unity_WorldToLight * tmpvar_13).xy;
  atten_6 = texture2D (_LightTexture0, tmpvar_14.xy, -8.0).w;
  lowp vec4 tmpvar_15;
  highp vec2 P_16;
  P_16 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_15 = texture2D (_CameraNormalsTexture, P_16);
  nspec_5 = tmpvar_15;
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_18;
  mediump float tmpvar_19;
  tmpvar_19 = pow (max (0.0, dot (h_4, tmpvar_17)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_19;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_17)
  ) * atten_6));
  mediump vec3 rgb_20;
  rgb_20 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_20, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_21;
  tmpvar_21 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_21);
  mediump vec4 tmpvar_22;
  tmpvar_22 = exp2(-(res_2));
  tmpvar_1 = tmpvar_22;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_10;
  highp vec4 tmpvar_14;
  tmpvar_14.zw = vec2(0.0, -8.0);
  tmpvar_14.xy = (unity_WorldToLight * tmpvar_13).xy;
  atten_6 = texture2D (_LightTexture0, tmpvar_14.xy, -8.0).w;
  lowp vec4 tmpvar_15;
  highp vec2 P_16;
  P_16 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_15 = texture2D (_CameraNormalsTexture, P_16);
  nspec_5 = tmpvar_15;
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_18;
  mediump float tmpvar_19;
  tmpvar_19 = pow (max (0.0, dot (h_4, tmpvar_17)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_19;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_17)
  ) * atten_6));
  mediump vec3 rgb_20;
  rgb_20 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_20, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_21;
  tmpvar_21 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_21);
  mediump vec4 tmpvar_22;
  tmpvar_22 = exp2(-(res_2));
  tmpvar_1 = tmpvar_22;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_10;
  highp vec4 tmpvar_14;
  tmpvar_14.zw = vec2(0.0, -8.0);
  tmpvar_14.xy = (unity_WorldToLight * tmpvar_13).xy;
  atten_6 = texture2D (_LightTexture0, tmpvar_14.xy, -8.0).w;
  lowp vec4 tmpvar_15;
  highp vec2 P_16;
  P_16 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_15 = texture2D (_CameraNormalsTexture, P_16);
  nspec_5 = tmpvar_15;
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_18;
  mediump float tmpvar_19;
  tmpvar_19 = pow (max (0.0, dot (h_4, tmpvar_17)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_19;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_17)
  ) * atten_6));
  mediump vec3 rgb_20;
  rgb_20 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_20, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_21;
  tmpvar_21 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_21);
  mediump vec4 tmpvar_22;
  tmpvar_22 = exp2(-(res_2));
  tmpvar_1 = tmpvar_22;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "DIRECTIONAL_COOKIE" }
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump float u_xlat16_5;
vec3 u_xlat6;
mediump float u_xlat16_10;
float u_xlat12;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat12 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat12 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat6.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat6.xyz = u_xlat6.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat6.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat6.xxx + (-_LightDir.xyz);
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat3.xyz = u_xlat6.xxx * u_xlat3.xyz;
    u_xlat16_4.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = u_xlat10_1.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat3.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
    u_xlat16_4.x = max(u_xlat16_4.x, 0.0);
    u_xlat16_10 = max(u_xlat16_5, 0.0);
    u_xlat16_10 = log2(u_xlat16_10);
    u_xlat16_10 = u_xlat16_10 * u_xlat16_22;
    u_xlat16_10 = exp2(u_xlat16_10);
    u_xlat6.xy = u_xlat2.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat6.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat2.xx + u_xlat6.xy;
    u_xlat6.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat2.ww + u_xlat6.xy;
    u_xlat1.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat1.x = dot(u_xlat1.xyz, u_xlat1.xyz);
    u_xlat1.x = sqrt(u_xlat1.x);
    u_xlat0.x = (-u_xlat6.z) * u_xlat0.x + u_xlat1.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat6.xy = u_xlat6.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat6.x = texture(_LightTexture0, u_xlat6.xy, -8.0).w;
    u_xlat12 = u_xlat6.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat12 = min(max(u_xlat12, 0.0), 1.0);
#else
    u_xlat12 = clamp(u_xlat12, 0.0, 1.0);
#endif
    u_xlat6.x = u_xlat6.x * u_xlat16_4.x;
    u_xlat1.xyz = u_xlat6.xxx * _LightColor.xyz;
    u_xlat6.x = u_xlat12 * u_xlat16_10;
    u_xlat16_4.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat6.x * u_xlat16_4.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = exp2((-u_xlat0));
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" }
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump float u_xlat16_5;
vec3 u_xlat6;
mediump float u_xlat16_10;
float u_xlat12;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat12 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat12 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat6.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat6.xyz = u_xlat6.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat6.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat6.xxx + (-_LightDir.xyz);
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat3.xyz = u_xlat6.xxx * u_xlat3.xyz;
    u_xlat16_4.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = u_xlat10_1.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat3.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
    u_xlat16_4.x = max(u_xlat16_4.x, 0.0);
    u_xlat16_10 = max(u_xlat16_5, 0.0);
    u_xlat16_10 = log2(u_xlat16_10);
    u_xlat16_10 = u_xlat16_10 * u_xlat16_22;
    u_xlat16_10 = exp2(u_xlat16_10);
    u_xlat6.xy = u_xlat2.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat6.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat2.xx + u_xlat6.xy;
    u_xlat6.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat2.ww + u_xlat6.xy;
    u_xlat1.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat1.x = dot(u_xlat1.xyz, u_xlat1.xyz);
    u_xlat1.x = sqrt(u_xlat1.x);
    u_xlat0.x = (-u_xlat6.z) * u_xlat0.x + u_xlat1.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat6.xy = u_xlat6.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat6.x = texture(_LightTexture0, u_xlat6.xy, -8.0).w;
    u_xlat12 = u_xlat6.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat12 = min(max(u_xlat12, 0.0), 1.0);
#else
    u_xlat12 = clamp(u_xlat12, 0.0, 1.0);
#endif
    u_xlat6.x = u_xlat6.x * u_xlat16_4.x;
    u_xlat1.xyz = u_xlat6.xxx * _LightColor.xyz;
    u_xlat6.x = u_xlat12 * u_xlat16_10;
    u_xlat16_4.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat6.x * u_xlat16_4.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = exp2((-u_xlat0));
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" }
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump float u_xlat16_5;
vec3 u_xlat6;
mediump float u_xlat16_10;
float u_xlat12;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat12 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat12 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat6.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat6.xyz = u_xlat6.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat6.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat6.xxx + (-_LightDir.xyz);
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat3.xyz = u_xlat6.xxx * u_xlat3.xyz;
    u_xlat16_4.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = u_xlat10_1.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat3.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
    u_xlat16_4.x = max(u_xlat16_4.x, 0.0);
    u_xlat16_10 = max(u_xlat16_5, 0.0);
    u_xlat16_10 = log2(u_xlat16_10);
    u_xlat16_10 = u_xlat16_10 * u_xlat16_22;
    u_xlat16_10 = exp2(u_xlat16_10);
    u_xlat6.xy = u_xlat2.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat6.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat2.xx + u_xlat6.xy;
    u_xlat6.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat2.ww + u_xlat6.xy;
    u_xlat1.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat1.x = dot(u_xlat1.xyz, u_xlat1.xyz);
    u_xlat1.x = sqrt(u_xlat1.x);
    u_xlat0.x = (-u_xlat6.z) * u_xlat0.x + u_xlat1.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat6.xy = u_xlat6.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat6.x = texture(_LightTexture0, u_xlat6.xy, -8.0).w;
    u_xlat12 = u_xlat6.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat12 = min(max(u_xlat12, 0.0), 1.0);
#else
    u_xlat12 = clamp(u_xlat12, 0.0, 1.0);
#endif
    u_xlat6.x = u_xlat6.x * u_xlat16_4.x;
    u_xlat1.xyz = u_xlat6.xxx * _LightColor.xyz;
    u_xlat6.x = u_xlat12 * u_xlat16_10;
    u_xlat16_4.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat6.x * u_xlat16_4.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = exp2((-u_xlat0));
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_13);
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  highp vec4 tmpvar_16;
  tmpvar_16 = (unity_WorldToLight * tmpvar_15);
  highp vec4 tmpvar_17;
  tmpvar_17.zw = vec2(0.0, -8.0);
  tmpvar_17.xy = (tmpvar_16.xy / tmpvar_16.w);
  atten_6 = (texture2D (_LightTexture0, tmpvar_17.xy, -8.0).w * float((tmpvar_16.w < 0.0)));
  atten_6 = (atten_6 * texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w))).w);
  mediump float tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_18 = tmpvar_19;
  mediump float shadowAttenuation_20;
  shadowAttenuation_20 = 1.0;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = tmpvar_10;
  highp vec4 tmpvar_22;
  tmpvar_22 = (unity_WorldToShadow[0] * tmpvar_21);
  lowp float tmpvar_23;
  highp vec4 tmpvar_24;
  tmpvar_24 = texture2DProj (_ShadowMapTexture, tmpvar_22);
  mediump float tmpvar_25;
  if ((tmpvar_24.x < (tmpvar_22.z / tmpvar_22.w))) {
    tmpvar_25 = _LightShadowData.x;
  } else {
    tmpvar_25 = 1.0;
  };
  tmpvar_23 = tmpvar_25;
  shadowAttenuation_20 = tmpvar_23;
  mediump float tmpvar_26;
  tmpvar_26 = clamp ((shadowAttenuation_20 + tmpvar_18), 0.0, 1.0);
  atten_6 = (atten_6 * tmpvar_26);
  lowp vec4 tmpvar_27;
  highp vec2 P_28;
  P_28 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_27 = texture2D (_CameraNormalsTexture, P_28);
  nspec_5 = tmpvar_27;
  mediump vec3 tmpvar_29;
  tmpvar_29 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_30;
  tmpvar_30 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = pow (max (0.0, dot (h_4, tmpvar_29)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_31;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_29)
  ) * atten_6));
  mediump vec3 rgb_32;
  rgb_32 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_32, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_33;
  tmpvar_33 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_33);
  mediump vec4 tmpvar_34;
  tmpvar_34 = exp2(-(res_2));
  tmpvar_1 = tmpvar_34;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_13);
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  highp vec4 tmpvar_16;
  tmpvar_16 = (unity_WorldToLight * tmpvar_15);
  highp vec4 tmpvar_17;
  tmpvar_17.zw = vec2(0.0, -8.0);
  tmpvar_17.xy = (tmpvar_16.xy / tmpvar_16.w);
  atten_6 = (texture2D (_LightTexture0, tmpvar_17.xy, -8.0).w * float((tmpvar_16.w < 0.0)));
  atten_6 = (atten_6 * texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w))).w);
  mediump float tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_18 = tmpvar_19;
  mediump float shadowAttenuation_20;
  shadowAttenuation_20 = 1.0;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = tmpvar_10;
  highp vec4 tmpvar_22;
  tmpvar_22 = (unity_WorldToShadow[0] * tmpvar_21);
  lowp float tmpvar_23;
  highp vec4 tmpvar_24;
  tmpvar_24 = texture2DProj (_ShadowMapTexture, tmpvar_22);
  mediump float tmpvar_25;
  if ((tmpvar_24.x < (tmpvar_22.z / tmpvar_22.w))) {
    tmpvar_25 = _LightShadowData.x;
  } else {
    tmpvar_25 = 1.0;
  };
  tmpvar_23 = tmpvar_25;
  shadowAttenuation_20 = tmpvar_23;
  mediump float tmpvar_26;
  tmpvar_26 = clamp ((shadowAttenuation_20 + tmpvar_18), 0.0, 1.0);
  atten_6 = (atten_6 * tmpvar_26);
  lowp vec4 tmpvar_27;
  highp vec2 P_28;
  P_28 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_27 = texture2D (_CameraNormalsTexture, P_28);
  nspec_5 = tmpvar_27;
  mediump vec3 tmpvar_29;
  tmpvar_29 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_30;
  tmpvar_30 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = pow (max (0.0, dot (h_4, tmpvar_29)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_31;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_29)
  ) * atten_6));
  mediump vec3 rgb_32;
  rgb_32 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_32, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_33;
  tmpvar_33 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_33);
  mediump vec4 tmpvar_34;
  tmpvar_34 = exp2(-(res_2));
  tmpvar_1 = tmpvar_34;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_13);
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  highp vec4 tmpvar_16;
  tmpvar_16 = (unity_WorldToLight * tmpvar_15);
  highp vec4 tmpvar_17;
  tmpvar_17.zw = vec2(0.0, -8.0);
  tmpvar_17.xy = (tmpvar_16.xy / tmpvar_16.w);
  atten_6 = (texture2D (_LightTexture0, tmpvar_17.xy, -8.0).w * float((tmpvar_16.w < 0.0)));
  atten_6 = (atten_6 * texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w))).w);
  mediump float tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_18 = tmpvar_19;
  mediump float shadowAttenuation_20;
  shadowAttenuation_20 = 1.0;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = tmpvar_10;
  highp vec4 tmpvar_22;
  tmpvar_22 = (unity_WorldToShadow[0] * tmpvar_21);
  lowp float tmpvar_23;
  highp vec4 tmpvar_24;
  tmpvar_24 = texture2DProj (_ShadowMapTexture, tmpvar_22);
  mediump float tmpvar_25;
  if ((tmpvar_24.x < (tmpvar_22.z / tmpvar_22.w))) {
    tmpvar_25 = _LightShadowData.x;
  } else {
    tmpvar_25 = 1.0;
  };
  tmpvar_23 = tmpvar_25;
  shadowAttenuation_20 = tmpvar_23;
  mediump float tmpvar_26;
  tmpvar_26 = clamp ((shadowAttenuation_20 + tmpvar_18), 0.0, 1.0);
  atten_6 = (atten_6 * tmpvar_26);
  lowp vec4 tmpvar_27;
  highp vec2 P_28;
  P_28 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_27 = texture2D (_CameraNormalsTexture, P_28);
  nspec_5 = tmpvar_27;
  mediump vec3 tmpvar_29;
  tmpvar_29 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_30;
  tmpvar_30 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = pow (max (0.0, dot (h_4, tmpvar_29)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_31;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_29)
  ) * atten_6));
  mediump vec3 rgb_32;
  rgb_32 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_32, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_33;
  tmpvar_33 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_33);
  mediump vec4 tmpvar_34;
  tmpvar_34 = exp2(-(res_2));
  tmpvar_1 = tmpvar_34;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump float u_xlat16_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec4 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec2 u_xlat7;
float u_xlat14;
lowp float u_xlat10_14;
float u_xlat21;
bool u_xlatb21;
mediump float u_xlat16_26;
void main()
{
    u_xlat16_0 = (-_LightShadowData.x) + 1.0;
    u_xlat7.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat7.xy).x;
    u_xlat7.xy = u_xlat7.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat7.xy);
    u_xlat7.x = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat7.x = float(1.0) / u_xlat7.x;
    u_xlat14 = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat2.xyz = vec3(u_xlat14) * vs_TEXCOORD1.xyz;
    u_xlat2.xyw = u_xlat7.xxx * u_xlat2.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.www + u_xlat3.xyz;
    u_xlat3.xyz = u_xlat3.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat4 = u_xlat3.yyyy * hlslcc_mtx4x4unity_WorldToShadow[1];
    u_xlat4 = hlslcc_mtx4x4unity_WorldToShadow[0] * u_xlat3.xxxx + u_xlat4;
    u_xlat4 = hlslcc_mtx4x4unity_WorldToShadow[2] * u_xlat3.zzzz + u_xlat4;
    u_xlat4 = u_xlat4 + hlslcc_mtx4x4unity_WorldToShadow[3];
    u_xlat4.xyz = u_xlat4.xyz / u_xlat4.www;
    vec3 txVec0 = vec3(u_xlat4.xy,u_xlat4.z);
    u_xlat10_14 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_0 = u_xlat10_14 * u_xlat16_0 + _LightShadowData.x;
    u_xlat4.xyz = u_xlat3.xyz + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat14 = sqrt(u_xlat14);
    u_xlat7.x = (-u_xlat2.z) * u_xlat7.x + u_xlat14;
    u_xlat7.x = unity_ShadowFadeCenterAndType.w * u_xlat7.x + u_xlat2.w;
    u_xlat14 = u_xlat7.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat7.x = u_xlat7.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat7.x = (-u_xlat7.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat7.x = min(max(u_xlat7.x, 0.0), 1.0);
#else
    u_xlat7.x = clamp(u_xlat7.x, 0.0, 1.0);
#endif
    u_xlat16_5.x = u_xlat14 + u_xlat16_0;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat0.xzw = u_xlat3.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat0.xzw = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat3.xxx + u_xlat0.xzw;
    u_xlat0.xzw = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat3.zzz + u_xlat0.xzw;
    u_xlat0.xzw = u_xlat0.xzw + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat0.xz = u_xlat0.xz / u_xlat0.ww;
#ifdef UNITY_ADRENO_ES3
    u_xlatb21 = !!(u_xlat0.w<0.0);
#else
    u_xlatb21 = u_xlat0.w<0.0;
#endif
    u_xlat21 = u_xlatb21 ? 1.0 : float(0.0);
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xz, -8.0).w;
    u_xlat0.x = u_xlat21 * u_xlat0.x;
    u_xlat2.xyz = (-u_xlat3.xyz) + _LightPos.xyz;
    u_xlat3.xyz = u_xlat3.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat14 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = u_xlat14 * _LightPos.w;
    u_xlat14 = inversesqrt(u_xlat14);
    u_xlat2.xyz = vec3(u_xlat14) * u_xlat2.xyz;
    u_xlat14 = texture(_LightTextureB0, vec2(u_xlat21)).w;
    u_xlat0.x = u_xlat14 * u_xlat0.x;
    u_xlat0.x = u_xlat16_5.x * u_xlat0.x;
    u_xlat14 = u_xlat0.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat21 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat3.xyz = (-u_xlat3.xyz) * vec3(u_xlat21) + u_xlat2.xyz;
    u_xlat21 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat3.xyz = vec3(u_xlat21) * u_xlat3.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat3.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot(u_xlat2.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat0.x = u_xlat0.x * u_xlat16_5.x;
    u_xlat1.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat16_5.x = max(u_xlat16_6, 0.0);
    u_xlat16_5.x = log2(u_xlat16_5.x);
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_26;
    u_xlat16_5.x = exp2(u_xlat16_5.x);
    u_xlat0.x = u_xlat14 * u_xlat16_5.x;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat0.x * u_xlat16_5.x;
    u_xlat0 = u_xlat7.xxxx * u_xlat1;
    SV_Target0 = exp2((-u_xlat0));
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump float u_xlat16_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec4 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec2 u_xlat7;
float u_xlat14;
lowp float u_xlat10_14;
float u_xlat21;
bool u_xlatb21;
mediump float u_xlat16_26;
void main()
{
    u_xlat16_0 = (-_LightShadowData.x) + 1.0;
    u_xlat7.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat7.xy).x;
    u_xlat7.xy = u_xlat7.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat7.xy);
    u_xlat7.x = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat7.x = float(1.0) / u_xlat7.x;
    u_xlat14 = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat2.xyz = vec3(u_xlat14) * vs_TEXCOORD1.xyz;
    u_xlat2.xyw = u_xlat7.xxx * u_xlat2.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.www + u_xlat3.xyz;
    u_xlat3.xyz = u_xlat3.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat4 = u_xlat3.yyyy * hlslcc_mtx4x4unity_WorldToShadow[1];
    u_xlat4 = hlslcc_mtx4x4unity_WorldToShadow[0] * u_xlat3.xxxx + u_xlat4;
    u_xlat4 = hlslcc_mtx4x4unity_WorldToShadow[2] * u_xlat3.zzzz + u_xlat4;
    u_xlat4 = u_xlat4 + hlslcc_mtx4x4unity_WorldToShadow[3];
    u_xlat4.xyz = u_xlat4.xyz / u_xlat4.www;
    vec3 txVec0 = vec3(u_xlat4.xy,u_xlat4.z);
    u_xlat10_14 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_0 = u_xlat10_14 * u_xlat16_0 + _LightShadowData.x;
    u_xlat4.xyz = u_xlat3.xyz + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat14 = sqrt(u_xlat14);
    u_xlat7.x = (-u_xlat2.z) * u_xlat7.x + u_xlat14;
    u_xlat7.x = unity_ShadowFadeCenterAndType.w * u_xlat7.x + u_xlat2.w;
    u_xlat14 = u_xlat7.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat7.x = u_xlat7.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat7.x = (-u_xlat7.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat7.x = min(max(u_xlat7.x, 0.0), 1.0);
#else
    u_xlat7.x = clamp(u_xlat7.x, 0.0, 1.0);
#endif
    u_xlat16_5.x = u_xlat14 + u_xlat16_0;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat0.xzw = u_xlat3.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat0.xzw = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat3.xxx + u_xlat0.xzw;
    u_xlat0.xzw = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat3.zzz + u_xlat0.xzw;
    u_xlat0.xzw = u_xlat0.xzw + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat0.xz = u_xlat0.xz / u_xlat0.ww;
#ifdef UNITY_ADRENO_ES3
    u_xlatb21 = !!(u_xlat0.w<0.0);
#else
    u_xlatb21 = u_xlat0.w<0.0;
#endif
    u_xlat21 = u_xlatb21 ? 1.0 : float(0.0);
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xz, -8.0).w;
    u_xlat0.x = u_xlat21 * u_xlat0.x;
    u_xlat2.xyz = (-u_xlat3.xyz) + _LightPos.xyz;
    u_xlat3.xyz = u_xlat3.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat14 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = u_xlat14 * _LightPos.w;
    u_xlat14 = inversesqrt(u_xlat14);
    u_xlat2.xyz = vec3(u_xlat14) * u_xlat2.xyz;
    u_xlat14 = texture(_LightTextureB0, vec2(u_xlat21)).w;
    u_xlat0.x = u_xlat14 * u_xlat0.x;
    u_xlat0.x = u_xlat16_5.x * u_xlat0.x;
    u_xlat14 = u_xlat0.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat21 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat3.xyz = (-u_xlat3.xyz) * vec3(u_xlat21) + u_xlat2.xyz;
    u_xlat21 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat3.xyz = vec3(u_xlat21) * u_xlat3.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat3.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot(u_xlat2.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat0.x = u_xlat0.x * u_xlat16_5.x;
    u_xlat1.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat16_5.x = max(u_xlat16_6, 0.0);
    u_xlat16_5.x = log2(u_xlat16_5.x);
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_26;
    u_xlat16_5.x = exp2(u_xlat16_5.x);
    u_xlat0.x = u_xlat14 * u_xlat16_5.x;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat0.x * u_xlat16_5.x;
    u_xlat0 = u_xlat7.xxxx * u_xlat1;
    SV_Target0 = exp2((-u_xlat0));
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump float u_xlat16_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec4 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec2 u_xlat7;
float u_xlat14;
lowp float u_xlat10_14;
float u_xlat21;
bool u_xlatb21;
mediump float u_xlat16_26;
void main()
{
    u_xlat16_0 = (-_LightShadowData.x) + 1.0;
    u_xlat7.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat7.xy).x;
    u_xlat7.xy = u_xlat7.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat7.xy);
    u_xlat7.x = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat7.x = float(1.0) / u_xlat7.x;
    u_xlat14 = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat2.xyz = vec3(u_xlat14) * vs_TEXCOORD1.xyz;
    u_xlat2.xyw = u_xlat7.xxx * u_xlat2.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.www + u_xlat3.xyz;
    u_xlat3.xyz = u_xlat3.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat4 = u_xlat3.yyyy * hlslcc_mtx4x4unity_WorldToShadow[1];
    u_xlat4 = hlslcc_mtx4x4unity_WorldToShadow[0] * u_xlat3.xxxx + u_xlat4;
    u_xlat4 = hlslcc_mtx4x4unity_WorldToShadow[2] * u_xlat3.zzzz + u_xlat4;
    u_xlat4 = u_xlat4 + hlslcc_mtx4x4unity_WorldToShadow[3];
    u_xlat4.xyz = u_xlat4.xyz / u_xlat4.www;
    vec3 txVec0 = vec3(u_xlat4.xy,u_xlat4.z);
    u_xlat10_14 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_0 = u_xlat10_14 * u_xlat16_0 + _LightShadowData.x;
    u_xlat4.xyz = u_xlat3.xyz + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat14 = sqrt(u_xlat14);
    u_xlat7.x = (-u_xlat2.z) * u_xlat7.x + u_xlat14;
    u_xlat7.x = unity_ShadowFadeCenterAndType.w * u_xlat7.x + u_xlat2.w;
    u_xlat14 = u_xlat7.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat7.x = u_xlat7.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat7.x = (-u_xlat7.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat7.x = min(max(u_xlat7.x, 0.0), 1.0);
#else
    u_xlat7.x = clamp(u_xlat7.x, 0.0, 1.0);
#endif
    u_xlat16_5.x = u_xlat14 + u_xlat16_0;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat0.xzw = u_xlat3.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat0.xzw = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat3.xxx + u_xlat0.xzw;
    u_xlat0.xzw = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat3.zzz + u_xlat0.xzw;
    u_xlat0.xzw = u_xlat0.xzw + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat0.xz = u_xlat0.xz / u_xlat0.ww;
#ifdef UNITY_ADRENO_ES3
    u_xlatb21 = !!(u_xlat0.w<0.0);
#else
    u_xlatb21 = u_xlat0.w<0.0;
#endif
    u_xlat21 = u_xlatb21 ? 1.0 : float(0.0);
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xz, -8.0).w;
    u_xlat0.x = u_xlat21 * u_xlat0.x;
    u_xlat2.xyz = (-u_xlat3.xyz) + _LightPos.xyz;
    u_xlat3.xyz = u_xlat3.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat14 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = u_xlat14 * _LightPos.w;
    u_xlat14 = inversesqrt(u_xlat14);
    u_xlat2.xyz = vec3(u_xlat14) * u_xlat2.xyz;
    u_xlat14 = texture(_LightTextureB0, vec2(u_xlat21)).w;
    u_xlat0.x = u_xlat14 * u_xlat0.x;
    u_xlat0.x = u_xlat16_5.x * u_xlat0.x;
    u_xlat14 = u_xlat0.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat21 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat3.xyz = (-u_xlat3.xyz) * vec3(u_xlat21) + u_xlat2.xyz;
    u_xlat21 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat3.xyz = vec3(u_xlat21) * u_xlat3.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat3.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot(u_xlat2.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat0.x = u_xlat0.x * u_xlat16_5.x;
    u_xlat1.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat16_5.x = max(u_xlat16_6, 0.0);
    u_xlat16_5.x = log2(u_xlat16_5.x);
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_26;
    u_xlat16_5.x = exp2(u_xlat16_5.x);
    u_xlat0.x = u_xlat14 * u_xlat16_5.x;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat0.x * u_xlat16_5.x;
    u_xlat0 = u_xlat7.xxxx * u_xlat1;
    SV_Target0 = exp2((-u_xlat0));
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_13);
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  highp vec4 tmpvar_16;
  tmpvar_16 = (unity_WorldToLight * tmpvar_15);
  highp vec4 tmpvar_17;
  tmpvar_17.zw = vec2(0.0, -8.0);
  tmpvar_17.xy = (tmpvar_16.xy / tmpvar_16.w);
  atten_6 = (texture2D (_LightTexture0, tmpvar_17.xy, -8.0).w * float((tmpvar_16.w < 0.0)));
  atten_6 = (atten_6 * texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w))).w);
  mediump float tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_18 = tmpvar_19;
  mediump float shadowAttenuation_20;
  shadowAttenuation_20 = 1.0;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = tmpvar_10;
  highp vec4 tmpvar_22;
  tmpvar_22 = (unity_WorldToShadow[0] * tmpvar_21);
  lowp float tmpvar_23;
  highp vec4 shadowVals_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = (tmpvar_22.xyz / tmpvar_22.w);
  shadowVals_24.x = texture2D (_ShadowMapTexture, (tmpvar_25.xy + _ShadowOffsets[0].xy)).x;
  shadowVals_24.y = texture2D (_ShadowMapTexture, (tmpvar_25.xy + _ShadowOffsets[1].xy)).x;
  shadowVals_24.z = texture2D (_ShadowMapTexture, (tmpvar_25.xy + _ShadowOffsets[2].xy)).x;
  shadowVals_24.w = texture2D (_ShadowMapTexture, (tmpvar_25.xy + _ShadowOffsets[3].xy)).x;
  bvec4 tmpvar_26;
  tmpvar_26 = lessThan (shadowVals_24, tmpvar_25.zzzz);
  mediump vec4 tmpvar_27;
  tmpvar_27 = _LightShadowData.xxxx;
  mediump float tmpvar_28;
  if (tmpvar_26.x) {
    tmpvar_28 = tmpvar_27.x;
  } else {
    tmpvar_28 = 1.0;
  };
  mediump float tmpvar_29;
  if (tmpvar_26.y) {
    tmpvar_29 = tmpvar_27.y;
  } else {
    tmpvar_29 = 1.0;
  };
  mediump float tmpvar_30;
  if (tmpvar_26.z) {
    tmpvar_30 = tmpvar_27.z;
  } else {
    tmpvar_30 = 1.0;
  };
  mediump float tmpvar_31;
  if (tmpvar_26.w) {
    tmpvar_31 = tmpvar_27.w;
  } else {
    tmpvar_31 = 1.0;
  };
  mediump vec4 tmpvar_32;
  tmpvar_32.x = tmpvar_28;
  tmpvar_32.y = tmpvar_29;
  tmpvar_32.z = tmpvar_30;
  tmpvar_32.w = tmpvar_31;
  mediump float tmpvar_33;
  tmpvar_33 = dot (tmpvar_32, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_23 = tmpvar_33;
  shadowAttenuation_20 = tmpvar_23;
  mediump float tmpvar_34;
  tmpvar_34 = clamp ((shadowAttenuation_20 + tmpvar_18), 0.0, 1.0);
  atten_6 = (atten_6 * tmpvar_34);
  lowp vec4 tmpvar_35;
  highp vec2 P_36;
  P_36 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_35 = texture2D (_CameraNormalsTexture, P_36);
  nspec_5 = tmpvar_35;
  mediump vec3 tmpvar_37;
  tmpvar_37 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_38;
  tmpvar_38 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_38;
  mediump float tmpvar_39;
  tmpvar_39 = pow (max (0.0, dot (h_4, tmpvar_37)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_39;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_37)
  ) * atten_6));
  mediump vec3 rgb_40;
  rgb_40 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_40, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_41;
  tmpvar_41 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_41);
  mediump vec4 tmpvar_42;
  tmpvar_42 = exp2(-(res_2));
  tmpvar_1 = tmpvar_42;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_13);
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  highp vec4 tmpvar_16;
  tmpvar_16 = (unity_WorldToLight * tmpvar_15);
  highp vec4 tmpvar_17;
  tmpvar_17.zw = vec2(0.0, -8.0);
  tmpvar_17.xy = (tmpvar_16.xy / tmpvar_16.w);
  atten_6 = (texture2D (_LightTexture0, tmpvar_17.xy, -8.0).w * float((tmpvar_16.w < 0.0)));
  atten_6 = (atten_6 * texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w))).w);
  mediump float tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_18 = tmpvar_19;
  mediump float shadowAttenuation_20;
  shadowAttenuation_20 = 1.0;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = tmpvar_10;
  highp vec4 tmpvar_22;
  tmpvar_22 = (unity_WorldToShadow[0] * tmpvar_21);
  lowp float tmpvar_23;
  highp vec4 shadowVals_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = (tmpvar_22.xyz / tmpvar_22.w);
  shadowVals_24.x = texture2D (_ShadowMapTexture, (tmpvar_25.xy + _ShadowOffsets[0].xy)).x;
  shadowVals_24.y = texture2D (_ShadowMapTexture, (tmpvar_25.xy + _ShadowOffsets[1].xy)).x;
  shadowVals_24.z = texture2D (_ShadowMapTexture, (tmpvar_25.xy + _ShadowOffsets[2].xy)).x;
  shadowVals_24.w = texture2D (_ShadowMapTexture, (tmpvar_25.xy + _ShadowOffsets[3].xy)).x;
  bvec4 tmpvar_26;
  tmpvar_26 = lessThan (shadowVals_24, tmpvar_25.zzzz);
  mediump vec4 tmpvar_27;
  tmpvar_27 = _LightShadowData.xxxx;
  mediump float tmpvar_28;
  if (tmpvar_26.x) {
    tmpvar_28 = tmpvar_27.x;
  } else {
    tmpvar_28 = 1.0;
  };
  mediump float tmpvar_29;
  if (tmpvar_26.y) {
    tmpvar_29 = tmpvar_27.y;
  } else {
    tmpvar_29 = 1.0;
  };
  mediump float tmpvar_30;
  if (tmpvar_26.z) {
    tmpvar_30 = tmpvar_27.z;
  } else {
    tmpvar_30 = 1.0;
  };
  mediump float tmpvar_31;
  if (tmpvar_26.w) {
    tmpvar_31 = tmpvar_27.w;
  } else {
    tmpvar_31 = 1.0;
  };
  mediump vec4 tmpvar_32;
  tmpvar_32.x = tmpvar_28;
  tmpvar_32.y = tmpvar_29;
  tmpvar_32.z = tmpvar_30;
  tmpvar_32.w = tmpvar_31;
  mediump float tmpvar_33;
  tmpvar_33 = dot (tmpvar_32, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_23 = tmpvar_33;
  shadowAttenuation_20 = tmpvar_23;
  mediump float tmpvar_34;
  tmpvar_34 = clamp ((shadowAttenuation_20 + tmpvar_18), 0.0, 1.0);
  atten_6 = (atten_6 * tmpvar_34);
  lowp vec4 tmpvar_35;
  highp vec2 P_36;
  P_36 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_35 = texture2D (_CameraNormalsTexture, P_36);
  nspec_5 = tmpvar_35;
  mediump vec3 tmpvar_37;
  tmpvar_37 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_38;
  tmpvar_38 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_38;
  mediump float tmpvar_39;
  tmpvar_39 = pow (max (0.0, dot (h_4, tmpvar_37)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_39;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_37)
  ) * atten_6));
  mediump vec3 rgb_40;
  rgb_40 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_40, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_41;
  tmpvar_41 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_41);
  mediump vec4 tmpvar_42;
  tmpvar_42 = exp2(-(res_2));
  tmpvar_1 = tmpvar_42;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_13);
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  highp vec4 tmpvar_16;
  tmpvar_16 = (unity_WorldToLight * tmpvar_15);
  highp vec4 tmpvar_17;
  tmpvar_17.zw = vec2(0.0, -8.0);
  tmpvar_17.xy = (tmpvar_16.xy / tmpvar_16.w);
  atten_6 = (texture2D (_LightTexture0, tmpvar_17.xy, -8.0).w * float((tmpvar_16.w < 0.0)));
  atten_6 = (atten_6 * texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w))).w);
  mediump float tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_18 = tmpvar_19;
  mediump float shadowAttenuation_20;
  shadowAttenuation_20 = 1.0;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = tmpvar_10;
  highp vec4 tmpvar_22;
  tmpvar_22 = (unity_WorldToShadow[0] * tmpvar_21);
  lowp float tmpvar_23;
  highp vec4 shadowVals_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = (tmpvar_22.xyz / tmpvar_22.w);
  shadowVals_24.x = texture2D (_ShadowMapTexture, (tmpvar_25.xy + _ShadowOffsets[0].xy)).x;
  shadowVals_24.y = texture2D (_ShadowMapTexture, (tmpvar_25.xy + _ShadowOffsets[1].xy)).x;
  shadowVals_24.z = texture2D (_ShadowMapTexture, (tmpvar_25.xy + _ShadowOffsets[2].xy)).x;
  shadowVals_24.w = texture2D (_ShadowMapTexture, (tmpvar_25.xy + _ShadowOffsets[3].xy)).x;
  bvec4 tmpvar_26;
  tmpvar_26 = lessThan (shadowVals_24, tmpvar_25.zzzz);
  mediump vec4 tmpvar_27;
  tmpvar_27 = _LightShadowData.xxxx;
  mediump float tmpvar_28;
  if (tmpvar_26.x) {
    tmpvar_28 = tmpvar_27.x;
  } else {
    tmpvar_28 = 1.0;
  };
  mediump float tmpvar_29;
  if (tmpvar_26.y) {
    tmpvar_29 = tmpvar_27.y;
  } else {
    tmpvar_29 = 1.0;
  };
  mediump float tmpvar_30;
  if (tmpvar_26.z) {
    tmpvar_30 = tmpvar_27.z;
  } else {
    tmpvar_30 = 1.0;
  };
  mediump float tmpvar_31;
  if (tmpvar_26.w) {
    tmpvar_31 = tmpvar_27.w;
  } else {
    tmpvar_31 = 1.0;
  };
  mediump vec4 tmpvar_32;
  tmpvar_32.x = tmpvar_28;
  tmpvar_32.y = tmpvar_29;
  tmpvar_32.z = tmpvar_30;
  tmpvar_32.w = tmpvar_31;
  mediump float tmpvar_33;
  tmpvar_33 = dot (tmpvar_32, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_23 = tmpvar_33;
  shadowAttenuation_20 = tmpvar_23;
  mediump float tmpvar_34;
  tmpvar_34 = clamp ((shadowAttenuation_20 + tmpvar_18), 0.0, 1.0);
  atten_6 = (atten_6 * tmpvar_34);
  lowp vec4 tmpvar_35;
  highp vec2 P_36;
  P_36 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_35 = texture2D (_CameraNormalsTexture, P_36);
  nspec_5 = tmpvar_35;
  mediump vec3 tmpvar_37;
  tmpvar_37 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_38;
  tmpvar_38 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_38;
  mediump float tmpvar_39;
  tmpvar_39 = pow (max (0.0, dot (h_4, tmpvar_37)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_39;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_37)
  ) * atten_6));
  mediump vec3 rgb_40;
  rgb_40 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_40, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_41;
  tmpvar_41 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_41);
  mediump vec4 tmpvar_42;
  tmpvar_42 = exp2(-(res_2));
  tmpvar_1 = tmpvar_42;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _ShadowOffsets[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec4 u_xlat3;
vec4 u_xlat4;
vec3 u_xlat5;
mediump vec3 u_xlat16_6;
mediump float u_xlat16_7;
vec3 u_xlat8;
float u_xlat16;
mediump float u_xlat16_16;
float u_xlat24;
bool u_xlatb24;
mediump float u_xlat16_30;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat16 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat16 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat8.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat8.xyz = u_xlat8.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat8.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3 = u_xlat2.yyyy * hlslcc_mtx4x4unity_WorldToShadow[1];
    u_xlat3 = hlslcc_mtx4x4unity_WorldToShadow[0] * u_xlat2.xxxx + u_xlat3;
    u_xlat3 = hlslcc_mtx4x4unity_WorldToShadow[2] * u_xlat2.wwww + u_xlat3;
    u_xlat3 = u_xlat3 + hlslcc_mtx4x4unity_WorldToShadow[3];
    u_xlat3.xyz = u_xlat3.xyz / u_xlat3.www;
    u_xlat4.xyz = u_xlat3.xyz + _ShadowOffsets[0].xyz;
    vec3 txVec0 = vec3(u_xlat4.xy,u_xlat4.z);
    u_xlat4.x = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat5.xyz = u_xlat3.xyz + _ShadowOffsets[1].xyz;
    vec3 txVec1 = vec3(u_xlat5.xy,u_xlat5.z);
    u_xlat4.y = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec1, 0.0);
    u_xlat5.xyz = u_xlat3.xyz + _ShadowOffsets[2].xyz;
    u_xlat3.xyz = u_xlat3.xyz + _ShadowOffsets[3].xyz;
    vec3 txVec2 = vec3(u_xlat3.xy,u_xlat3.z);
    u_xlat4.w = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec2, 0.0);
    vec3 txVec3 = vec3(u_xlat5.xy,u_xlat5.z);
    u_xlat4.z = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec3, 0.0);
    u_xlat8.x = dot(u_xlat4, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat16_16 = (-_LightShadowData.x) + 1.0;
    u_xlat8.x = u_xlat8.x * u_xlat16_16 + _LightShadowData.x;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat16 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat16 = sqrt(u_xlat16);
    u_xlat0.x = (-u_xlat8.z) * u_xlat0.x + u_xlat16;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat16 = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat16 = min(max(u_xlat16, 0.0), 1.0);
#else
    u_xlat16 = clamp(u_xlat16, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat16_6.x = u_xlat16 + u_xlat8.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_6.x = min(max(u_xlat16_6.x, 0.0), 1.0);
#else
    u_xlat16_6.x = clamp(u_xlat16_6.x, 0.0, 1.0);
#endif
    u_xlat8.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat8.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat2.xxx + u_xlat8.xyz;
    u_xlat8.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat2.www + u_xlat8.xyz;
    u_xlat8.xyz = u_xlat8.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat8.xy = u_xlat8.xy / u_xlat8.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb24 = !!(u_xlat8.z<0.0);
#else
    u_xlatb24 = u_xlat8.z<0.0;
#endif
    u_xlat24 = u_xlatb24 ? 1.0 : float(0.0);
    u_xlat8.x = texture(_LightTexture0, u_xlat8.xy, -8.0).w;
    u_xlat8.x = u_xlat24 * u_xlat8.x;
    u_xlat3.xyz = (-u_xlat2.xyw) + _LightPos.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat16 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat24 = u_xlat16 * _LightPos.w;
    u_xlat16 = inversesqrt(u_xlat16);
    u_xlat3.xyz = vec3(u_xlat16) * u_xlat3.xyz;
    u_xlat16 = texture(_LightTextureB0, vec2(u_xlat24)).w;
    u_xlat8.x = u_xlat16 * u_xlat8.x;
    u_xlat8.x = u_xlat16_6.x * u_xlat8.x;
    u_xlat16 = u_xlat8.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16 = min(max(u_xlat16, 0.0), 1.0);
#else
    u_xlat16 = clamp(u_xlat16, 0.0, 1.0);
#endif
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = (-u_xlat2.xyz) * vec3(u_xlat24) + u_xlat3.xyz;
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat2.xyz;
    u_xlat16_6.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_30 = u_xlat10_1.w * 128.0;
    u_xlat16_7 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_7 = inversesqrt(u_xlat16_7);
    u_xlat16_6.xyz = u_xlat16_6.xyz * vec3(u_xlat16_7);
    u_xlat16_7 = dot(u_xlat2.xyz, u_xlat16_6.xyz);
    u_xlat16_6.x = dot(u_xlat3.xyz, u_xlat16_6.xyz);
    u_xlat16_6.x = max(u_xlat16_6.x, 0.0);
    u_xlat8.x = u_xlat8.x * u_xlat16_6.x;
    u_xlat1.xyz = u_xlat8.xxx * _LightColor.xyz;
    u_xlat16_6.x = max(u_xlat16_7, 0.0);
    u_xlat16_6.x = log2(u_xlat16_6.x);
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_30;
    u_xlat16_6.x = exp2(u_xlat16_6.x);
    u_xlat8.x = u_xlat16 * u_xlat16_6.x;
    u_xlat16_6.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat8.x * u_xlat16_6.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = exp2((-u_xlat0));
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _ShadowOffsets[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec4 u_xlat3;
vec4 u_xlat4;
vec3 u_xlat5;
mediump vec3 u_xlat16_6;
mediump float u_xlat16_7;
vec3 u_xlat8;
float u_xlat16;
mediump float u_xlat16_16;
float u_xlat24;
bool u_xlatb24;
mediump float u_xlat16_30;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat16 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat16 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat8.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat8.xyz = u_xlat8.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat8.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3 = u_xlat2.yyyy * hlslcc_mtx4x4unity_WorldToShadow[1];
    u_xlat3 = hlslcc_mtx4x4unity_WorldToShadow[0] * u_xlat2.xxxx + u_xlat3;
    u_xlat3 = hlslcc_mtx4x4unity_WorldToShadow[2] * u_xlat2.wwww + u_xlat3;
    u_xlat3 = u_xlat3 + hlslcc_mtx4x4unity_WorldToShadow[3];
    u_xlat3.xyz = u_xlat3.xyz / u_xlat3.www;
    u_xlat4.xyz = u_xlat3.xyz + _ShadowOffsets[0].xyz;
    vec3 txVec0 = vec3(u_xlat4.xy,u_xlat4.z);
    u_xlat4.x = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat5.xyz = u_xlat3.xyz + _ShadowOffsets[1].xyz;
    vec3 txVec1 = vec3(u_xlat5.xy,u_xlat5.z);
    u_xlat4.y = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec1, 0.0);
    u_xlat5.xyz = u_xlat3.xyz + _ShadowOffsets[2].xyz;
    u_xlat3.xyz = u_xlat3.xyz + _ShadowOffsets[3].xyz;
    vec3 txVec2 = vec3(u_xlat3.xy,u_xlat3.z);
    u_xlat4.w = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec2, 0.0);
    vec3 txVec3 = vec3(u_xlat5.xy,u_xlat5.z);
    u_xlat4.z = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec3, 0.0);
    u_xlat8.x = dot(u_xlat4, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat16_16 = (-_LightShadowData.x) + 1.0;
    u_xlat8.x = u_xlat8.x * u_xlat16_16 + _LightShadowData.x;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat16 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat16 = sqrt(u_xlat16);
    u_xlat0.x = (-u_xlat8.z) * u_xlat0.x + u_xlat16;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat16 = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat16 = min(max(u_xlat16, 0.0), 1.0);
#else
    u_xlat16 = clamp(u_xlat16, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat16_6.x = u_xlat16 + u_xlat8.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_6.x = min(max(u_xlat16_6.x, 0.0), 1.0);
#else
    u_xlat16_6.x = clamp(u_xlat16_6.x, 0.0, 1.0);
#endif
    u_xlat8.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat8.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat2.xxx + u_xlat8.xyz;
    u_xlat8.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat2.www + u_xlat8.xyz;
    u_xlat8.xyz = u_xlat8.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat8.xy = u_xlat8.xy / u_xlat8.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb24 = !!(u_xlat8.z<0.0);
#else
    u_xlatb24 = u_xlat8.z<0.0;
#endif
    u_xlat24 = u_xlatb24 ? 1.0 : float(0.0);
    u_xlat8.x = texture(_LightTexture0, u_xlat8.xy, -8.0).w;
    u_xlat8.x = u_xlat24 * u_xlat8.x;
    u_xlat3.xyz = (-u_xlat2.xyw) + _LightPos.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat16 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat24 = u_xlat16 * _LightPos.w;
    u_xlat16 = inversesqrt(u_xlat16);
    u_xlat3.xyz = vec3(u_xlat16) * u_xlat3.xyz;
    u_xlat16 = texture(_LightTextureB0, vec2(u_xlat24)).w;
    u_xlat8.x = u_xlat16 * u_xlat8.x;
    u_xlat8.x = u_xlat16_6.x * u_xlat8.x;
    u_xlat16 = u_xlat8.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16 = min(max(u_xlat16, 0.0), 1.0);
#else
    u_xlat16 = clamp(u_xlat16, 0.0, 1.0);
#endif
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = (-u_xlat2.xyz) * vec3(u_xlat24) + u_xlat3.xyz;
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat2.xyz;
    u_xlat16_6.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_30 = u_xlat10_1.w * 128.0;
    u_xlat16_7 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_7 = inversesqrt(u_xlat16_7);
    u_xlat16_6.xyz = u_xlat16_6.xyz * vec3(u_xlat16_7);
    u_xlat16_7 = dot(u_xlat2.xyz, u_xlat16_6.xyz);
    u_xlat16_6.x = dot(u_xlat3.xyz, u_xlat16_6.xyz);
    u_xlat16_6.x = max(u_xlat16_6.x, 0.0);
    u_xlat8.x = u_xlat8.x * u_xlat16_6.x;
    u_xlat1.xyz = u_xlat8.xxx * _LightColor.xyz;
    u_xlat16_6.x = max(u_xlat16_7, 0.0);
    u_xlat16_6.x = log2(u_xlat16_6.x);
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_30;
    u_xlat16_6.x = exp2(u_xlat16_6.x);
    u_xlat8.x = u_xlat16 * u_xlat16_6.x;
    u_xlat16_6.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat8.x * u_xlat16_6.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = exp2((-u_xlat0));
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _ShadowOffsets[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec4 u_xlat3;
vec4 u_xlat4;
vec3 u_xlat5;
mediump vec3 u_xlat16_6;
mediump float u_xlat16_7;
vec3 u_xlat8;
float u_xlat16;
mediump float u_xlat16_16;
float u_xlat24;
bool u_xlatb24;
mediump float u_xlat16_30;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat16 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat16 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat8.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat8.xyz = u_xlat8.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat8.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3 = u_xlat2.yyyy * hlslcc_mtx4x4unity_WorldToShadow[1];
    u_xlat3 = hlslcc_mtx4x4unity_WorldToShadow[0] * u_xlat2.xxxx + u_xlat3;
    u_xlat3 = hlslcc_mtx4x4unity_WorldToShadow[2] * u_xlat2.wwww + u_xlat3;
    u_xlat3 = u_xlat3 + hlslcc_mtx4x4unity_WorldToShadow[3];
    u_xlat3.xyz = u_xlat3.xyz / u_xlat3.www;
    u_xlat4.xyz = u_xlat3.xyz + _ShadowOffsets[0].xyz;
    vec3 txVec0 = vec3(u_xlat4.xy,u_xlat4.z);
    u_xlat4.x = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat5.xyz = u_xlat3.xyz + _ShadowOffsets[1].xyz;
    vec3 txVec1 = vec3(u_xlat5.xy,u_xlat5.z);
    u_xlat4.y = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec1, 0.0);
    u_xlat5.xyz = u_xlat3.xyz + _ShadowOffsets[2].xyz;
    u_xlat3.xyz = u_xlat3.xyz + _ShadowOffsets[3].xyz;
    vec3 txVec2 = vec3(u_xlat3.xy,u_xlat3.z);
    u_xlat4.w = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec2, 0.0);
    vec3 txVec3 = vec3(u_xlat5.xy,u_xlat5.z);
    u_xlat4.z = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec3, 0.0);
    u_xlat8.x = dot(u_xlat4, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat16_16 = (-_LightShadowData.x) + 1.0;
    u_xlat8.x = u_xlat8.x * u_xlat16_16 + _LightShadowData.x;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat16 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat16 = sqrt(u_xlat16);
    u_xlat0.x = (-u_xlat8.z) * u_xlat0.x + u_xlat16;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat16 = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat16 = min(max(u_xlat16, 0.0), 1.0);
#else
    u_xlat16 = clamp(u_xlat16, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat16_6.x = u_xlat16 + u_xlat8.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_6.x = min(max(u_xlat16_6.x, 0.0), 1.0);
#else
    u_xlat16_6.x = clamp(u_xlat16_6.x, 0.0, 1.0);
#endif
    u_xlat8.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat8.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat2.xxx + u_xlat8.xyz;
    u_xlat8.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat2.www + u_xlat8.xyz;
    u_xlat8.xyz = u_xlat8.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat8.xy = u_xlat8.xy / u_xlat8.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb24 = !!(u_xlat8.z<0.0);
#else
    u_xlatb24 = u_xlat8.z<0.0;
#endif
    u_xlat24 = u_xlatb24 ? 1.0 : float(0.0);
    u_xlat8.x = texture(_LightTexture0, u_xlat8.xy, -8.0).w;
    u_xlat8.x = u_xlat24 * u_xlat8.x;
    u_xlat3.xyz = (-u_xlat2.xyw) + _LightPos.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat16 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat24 = u_xlat16 * _LightPos.w;
    u_xlat16 = inversesqrt(u_xlat16);
    u_xlat3.xyz = vec3(u_xlat16) * u_xlat3.xyz;
    u_xlat16 = texture(_LightTextureB0, vec2(u_xlat24)).w;
    u_xlat8.x = u_xlat16 * u_xlat8.x;
    u_xlat8.x = u_xlat16_6.x * u_xlat8.x;
    u_xlat16 = u_xlat8.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16 = min(max(u_xlat16, 0.0), 1.0);
#else
    u_xlat16 = clamp(u_xlat16, 0.0, 1.0);
#endif
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = (-u_xlat2.xyz) * vec3(u_xlat24) + u_xlat3.xyz;
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat2.xyz;
    u_xlat16_6.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_30 = u_xlat10_1.w * 128.0;
    u_xlat16_7 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_7 = inversesqrt(u_xlat16_7);
    u_xlat16_6.xyz = u_xlat16_6.xyz * vec3(u_xlat16_7);
    u_xlat16_7 = dot(u_xlat2.xyz, u_xlat16_6.xyz);
    u_xlat16_6.x = dot(u_xlat3.xyz, u_xlat16_6.xyz);
    u_xlat16_6.x = max(u_xlat16_6.x, 0.0);
    u_xlat8.x = u_xlat8.x * u_xlat16_6.x;
    u_xlat1.xyz = u_xlat8.xxx * _LightColor.xyz;
    u_xlat16_6.x = max(u_xlat16_7, 0.0);
    u_xlat16_6.x = log2(u_xlat16_6.x);
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_30;
    u_xlat16_6.x = exp2(u_xlat16_6.x);
    u_xlat8.x = u_xlat16 * u_xlat16_6.x;
    u_xlat16_6.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat8.x * u_xlat16_6.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = exp2((-u_xlat0));
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_13;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  mediump float shadowAttenuation_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_ShadowMapTexture, tmpvar_8);
  shadowAttenuation_16 = tmpvar_17.x;
  mediump float tmpvar_18;
  tmpvar_18 = clamp ((shadowAttenuation_16 + tmpvar_14), 0.0, 1.0);
  atten_6 = tmpvar_18;
  lowp vec4 tmpvar_19;
  highp vec2 P_20;
  P_20 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_19 = texture2D (_CameraNormalsTexture, P_20);
  nspec_5 = tmpvar_19;
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = pow (max (0.0, dot (h_4, tmpvar_21)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_23;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_21)
  ) * atten_6));
  mediump vec3 rgb_24;
  rgb_24 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_24, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_25;
  tmpvar_25 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_25);
  mediump vec4 tmpvar_26;
  tmpvar_26 = exp2(-(res_2));
  tmpvar_1 = tmpvar_26;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_13;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  mediump float shadowAttenuation_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_ShadowMapTexture, tmpvar_8);
  shadowAttenuation_16 = tmpvar_17.x;
  mediump float tmpvar_18;
  tmpvar_18 = clamp ((shadowAttenuation_16 + tmpvar_14), 0.0, 1.0);
  atten_6 = tmpvar_18;
  lowp vec4 tmpvar_19;
  highp vec2 P_20;
  P_20 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_19 = texture2D (_CameraNormalsTexture, P_20);
  nspec_5 = tmpvar_19;
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = pow (max (0.0, dot (h_4, tmpvar_21)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_23;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_21)
  ) * atten_6));
  mediump vec3 rgb_24;
  rgb_24 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_24, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_25;
  tmpvar_25 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_25);
  mediump vec4 tmpvar_26;
  tmpvar_26 = exp2(-(res_2));
  tmpvar_1 = tmpvar_26;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_13;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  mediump float shadowAttenuation_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_ShadowMapTexture, tmpvar_8);
  shadowAttenuation_16 = tmpvar_17.x;
  mediump float tmpvar_18;
  tmpvar_18 = clamp ((shadowAttenuation_16 + tmpvar_14), 0.0, 1.0);
  atten_6 = tmpvar_18;
  lowp vec4 tmpvar_19;
  highp vec2 P_20;
  P_20 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_19 = texture2D (_CameraNormalsTexture, P_20);
  nspec_5 = tmpvar_19;
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = pow (max (0.0, dot (h_4, tmpvar_21)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_23;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_21)
  ) * atten_6));
  mediump vec3 rgb_24;
  rgb_24 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_24, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_25;
  tmpvar_25 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_25);
  mediump vec4 tmpvar_26;
  tmpvar_26 = exp2(-(res_2));
  tmpvar_1 = tmpvar_26;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
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
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp float u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump float u_xlat16_5;
vec3 u_xlat6;
mediump vec2 u_xlat16_6;
mediump float u_xlat16_10;
vec2 u_xlat13;
mediump float u_xlat16_16;
float u_xlat18;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat18 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat18 = _ZBufferParams.x * u_xlat18 + _ZBufferParams.y;
    u_xlat18 = float(1.0) / u_xlat18;
    u_xlat2.xyz = vec3(u_xlat18) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat18 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat6.xyz = (-u_xlat3.xyz) * u_xlat6.xxx + (-_LightDir.xyz);
    u_xlat13.x = dot(u_xlat6.xyz, u_xlat6.xyz);
    u_xlat13.x = inversesqrt(u_xlat13.x);
    u_xlat6.xyz = u_xlat6.xyz * u_xlat13.xxx;
    u_xlat13.xy = u_xlat1.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat10_2 = texture(_CameraNormalsTexture, u_xlat13.xy);
    u_xlat16_4.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = u_xlat10_2.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat6.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
    u_xlat16_4.x = max(u_xlat16_4.x, 0.0);
    u_xlat16_10 = max(u_xlat16_5, 0.0);
    u_xlat16_10 = log2(u_xlat16_10);
    u_xlat16_10 = u_xlat16_10 * u_xlat16_22;
    u_xlat16_4.y = exp2(u_xlat16_10);
    u_xlat6.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat6.x = min(max(u_xlat6.x, 0.0), 1.0);
#else
    u_xlat6.x = clamp(u_xlat6.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat16_16 = u_xlat6.x + u_xlat10_1;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_16 = min(max(u_xlat16_16, 0.0), 1.0);
#else
    u_xlat16_16 = clamp(u_xlat16_16, 0.0, 1.0);
#endif
    u_xlat16_6.xy = vec2(u_xlat16_16) * u_xlat16_4.yx;
    u_xlat1.xyz = u_xlat16_6.yyy * _LightColor.xyz;
    u_xlat16_4.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_6.x * u_xlat16_4.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = exp2((-u_xlat0));
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
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
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp float u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump float u_xlat16_5;
vec3 u_xlat6;
mediump vec2 u_xlat16_6;
mediump float u_xlat16_10;
vec2 u_xlat13;
mediump float u_xlat16_16;
float u_xlat18;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat18 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat18 = _ZBufferParams.x * u_xlat18 + _ZBufferParams.y;
    u_xlat18 = float(1.0) / u_xlat18;
    u_xlat2.xyz = vec3(u_xlat18) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat18 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat6.xyz = (-u_xlat3.xyz) * u_xlat6.xxx + (-_LightDir.xyz);
    u_xlat13.x = dot(u_xlat6.xyz, u_xlat6.xyz);
    u_xlat13.x = inversesqrt(u_xlat13.x);
    u_xlat6.xyz = u_xlat6.xyz * u_xlat13.xxx;
    u_xlat13.xy = u_xlat1.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat10_2 = texture(_CameraNormalsTexture, u_xlat13.xy);
    u_xlat16_4.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = u_xlat10_2.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat6.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
    u_xlat16_4.x = max(u_xlat16_4.x, 0.0);
    u_xlat16_10 = max(u_xlat16_5, 0.0);
    u_xlat16_10 = log2(u_xlat16_10);
    u_xlat16_10 = u_xlat16_10 * u_xlat16_22;
    u_xlat16_4.y = exp2(u_xlat16_10);
    u_xlat6.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat6.x = min(max(u_xlat6.x, 0.0), 1.0);
#else
    u_xlat6.x = clamp(u_xlat6.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat16_16 = u_xlat6.x + u_xlat10_1;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_16 = min(max(u_xlat16_16, 0.0), 1.0);
#else
    u_xlat16_16 = clamp(u_xlat16_16, 0.0, 1.0);
#endif
    u_xlat16_6.xy = vec2(u_xlat16_16) * u_xlat16_4.yx;
    u_xlat1.xyz = u_xlat16_6.yyy * _LightColor.xyz;
    u_xlat16_4.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_6.x * u_xlat16_4.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = exp2((-u_xlat0));
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
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
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp float u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump float u_xlat16_5;
vec3 u_xlat6;
mediump vec2 u_xlat16_6;
mediump float u_xlat16_10;
vec2 u_xlat13;
mediump float u_xlat16_16;
float u_xlat18;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat18 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat18 = _ZBufferParams.x * u_xlat18 + _ZBufferParams.y;
    u_xlat18 = float(1.0) / u_xlat18;
    u_xlat2.xyz = vec3(u_xlat18) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat18 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat6.xyz = (-u_xlat3.xyz) * u_xlat6.xxx + (-_LightDir.xyz);
    u_xlat13.x = dot(u_xlat6.xyz, u_xlat6.xyz);
    u_xlat13.x = inversesqrt(u_xlat13.x);
    u_xlat6.xyz = u_xlat6.xyz * u_xlat13.xxx;
    u_xlat13.xy = u_xlat1.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat10_2 = texture(_CameraNormalsTexture, u_xlat13.xy);
    u_xlat16_4.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = u_xlat10_2.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat6.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
    u_xlat16_4.x = max(u_xlat16_4.x, 0.0);
    u_xlat16_10 = max(u_xlat16_5, 0.0);
    u_xlat16_10 = log2(u_xlat16_10);
    u_xlat16_10 = u_xlat16_10 * u_xlat16_22;
    u_xlat16_4.y = exp2(u_xlat16_10);
    u_xlat6.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat6.x = min(max(u_xlat6.x, 0.0), 1.0);
#else
    u_xlat6.x = clamp(u_xlat6.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat16_16 = u_xlat6.x + u_xlat10_1;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_16 = min(max(u_xlat16_16, 0.0), 1.0);
#else
    u_xlat16_16 = clamp(u_xlat16_16, 0.0, 1.0);
#endif
    u_xlat16_6.xy = vec2(u_xlat16_16) * u_xlat16_4.yx;
    u_xlat1.xyz = u_xlat16_6.yyy * _LightColor.xyz;
    u_xlat16_4.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_6.x * u_xlat16_4.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = exp2((-u_xlat0));
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_13;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  mediump float shadowAttenuation_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_ShadowMapTexture, tmpvar_8);
  shadowAttenuation_16 = tmpvar_17.x;
  mediump float tmpvar_18;
  tmpvar_18 = clamp ((shadowAttenuation_16 + tmpvar_14), 0.0, 1.0);
  atten_6 = tmpvar_18;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = tmpvar_10;
  highp vec4 tmpvar_20;
  tmpvar_20.zw = vec2(0.0, -8.0);
  tmpvar_20.xy = (unity_WorldToLight * tmpvar_19).xy;
  atten_6 = (atten_6 * texture2D (_LightTexture0, tmpvar_20.xy, -8.0).w);
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_21 = texture2D (_CameraNormalsTexture, P_22);
  nspec_5 = tmpvar_21;
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = pow (max (0.0, dot (h_4, tmpvar_23)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_25;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_23)
  ) * atten_6));
  mediump vec3 rgb_26;
  rgb_26 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_26, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_27;
  tmpvar_27 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_27);
  mediump vec4 tmpvar_28;
  tmpvar_28 = exp2(-(res_2));
  tmpvar_1 = tmpvar_28;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_13;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  mediump float shadowAttenuation_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_ShadowMapTexture, tmpvar_8);
  shadowAttenuation_16 = tmpvar_17.x;
  mediump float tmpvar_18;
  tmpvar_18 = clamp ((shadowAttenuation_16 + tmpvar_14), 0.0, 1.0);
  atten_6 = tmpvar_18;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = tmpvar_10;
  highp vec4 tmpvar_20;
  tmpvar_20.zw = vec2(0.0, -8.0);
  tmpvar_20.xy = (unity_WorldToLight * tmpvar_19).xy;
  atten_6 = (atten_6 * texture2D (_LightTexture0, tmpvar_20.xy, -8.0).w);
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_21 = texture2D (_CameraNormalsTexture, P_22);
  nspec_5 = tmpvar_21;
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = pow (max (0.0, dot (h_4, tmpvar_23)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_25;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_23)
  ) * atten_6));
  mediump vec3 rgb_26;
  rgb_26 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_26, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_27;
  tmpvar_27 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_27);
  mediump vec4 tmpvar_28;
  tmpvar_28 = exp2(-(res_2));
  tmpvar_1 = tmpvar_28;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_13;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  mediump float shadowAttenuation_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_ShadowMapTexture, tmpvar_8);
  shadowAttenuation_16 = tmpvar_17.x;
  mediump float tmpvar_18;
  tmpvar_18 = clamp ((shadowAttenuation_16 + tmpvar_14), 0.0, 1.0);
  atten_6 = tmpvar_18;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = tmpvar_10;
  highp vec4 tmpvar_20;
  tmpvar_20.zw = vec2(0.0, -8.0);
  tmpvar_20.xy = (unity_WorldToLight * tmpvar_19).xy;
  atten_6 = (atten_6 * texture2D (_LightTexture0, tmpvar_20.xy, -8.0).w);
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_21 = texture2D (_CameraNormalsTexture, P_22);
  nspec_5 = tmpvar_21;
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = pow (max (0.0, dot (h_4, tmpvar_23)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_25;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_23)
  ) * atten_6));
  mediump vec3 rgb_26;
  rgb_26 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_26, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_27;
  tmpvar_27 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_27);
  mediump vec4 tmpvar_28;
  tmpvar_28 = exp2(-(res_2));
  tmpvar_1 = tmpvar_28;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
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
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform highp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump float u_xlat16_5;
vec2 u_xlat6;
float u_xlat12;
lowp float u_xlat10_12;
float u_xlat18;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat18 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat18 = _ZBufferParams.x * u_xlat18 + _ZBufferParams.y;
    u_xlat18 = float(1.0) / u_xlat18;
    u_xlat2.xyz = vec3(u_xlat18) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat18 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat6.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat6.x = min(max(u_xlat6.x, 0.0), 1.0);
#else
    u_xlat6.x = clamp(u_xlat6.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat10_12 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat1.xy = u_xlat1.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat1.xy);
    u_xlat16_4.x = u_xlat6.x + u_xlat10_12;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat6.xy = u_xlat2.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat6.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat2.xx + u_xlat6.xy;
    u_xlat6.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat2.ww + u_xlat6.xy;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat6.xy = u_xlat6.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat6.x = texture(_LightTexture0, u_xlat6.xy, -8.0).w;
    u_xlat6.x = u_xlat6.x * u_xlat16_4.x;
    u_xlat12 = u_xlat6.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat12 = min(max(u_xlat12, 0.0), 1.0);
#else
    u_xlat12 = clamp(u_xlat12, 0.0, 1.0);
#endif
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat18 = inversesqrt(u_xlat18);
    u_xlat2.xyz = (-u_xlat2.xyz) * vec3(u_xlat18) + (-_LightDir.xyz);
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat18 = inversesqrt(u_xlat18);
    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
    u_xlat16_4.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = u_xlat10_1.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat2.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
    u_xlat16_4.x = max(u_xlat16_4.x, 0.0);
    u_xlat6.x = u_xlat6.x * u_xlat16_4.x;
    u_xlat1.xyz = u_xlat6.xxx * _LightColor.xyz;
    u_xlat16_4.x = max(u_xlat16_5, 0.0);
    u_xlat16_4.x = log2(u_xlat16_4.x);
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_22;
    u_xlat16_4.x = exp2(u_xlat16_4.x);
    u_xlat6.x = u_xlat12 * u_xlat16_4.x;
    u_xlat16_4.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat6.x * u_xlat16_4.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = exp2((-u_xlat0));
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
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
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform highp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump float u_xlat16_5;
vec2 u_xlat6;
float u_xlat12;
lowp float u_xlat10_12;
float u_xlat18;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat18 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat18 = _ZBufferParams.x * u_xlat18 + _ZBufferParams.y;
    u_xlat18 = float(1.0) / u_xlat18;
    u_xlat2.xyz = vec3(u_xlat18) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat18 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat6.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat6.x = min(max(u_xlat6.x, 0.0), 1.0);
#else
    u_xlat6.x = clamp(u_xlat6.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat10_12 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat1.xy = u_xlat1.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat1.xy);
    u_xlat16_4.x = u_xlat6.x + u_xlat10_12;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat6.xy = u_xlat2.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat6.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat2.xx + u_xlat6.xy;
    u_xlat6.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat2.ww + u_xlat6.xy;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat6.xy = u_xlat6.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat6.x = texture(_LightTexture0, u_xlat6.xy, -8.0).w;
    u_xlat6.x = u_xlat6.x * u_xlat16_4.x;
    u_xlat12 = u_xlat6.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat12 = min(max(u_xlat12, 0.0), 1.0);
#else
    u_xlat12 = clamp(u_xlat12, 0.0, 1.0);
#endif
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat18 = inversesqrt(u_xlat18);
    u_xlat2.xyz = (-u_xlat2.xyz) * vec3(u_xlat18) + (-_LightDir.xyz);
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat18 = inversesqrt(u_xlat18);
    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
    u_xlat16_4.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = u_xlat10_1.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat2.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
    u_xlat16_4.x = max(u_xlat16_4.x, 0.0);
    u_xlat6.x = u_xlat6.x * u_xlat16_4.x;
    u_xlat1.xyz = u_xlat6.xxx * _LightColor.xyz;
    u_xlat16_4.x = max(u_xlat16_5, 0.0);
    u_xlat16_4.x = log2(u_xlat16_4.x);
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_22;
    u_xlat16_4.x = exp2(u_xlat16_4.x);
    u_xlat6.x = u_xlat12 * u_xlat16_4.x;
    u_xlat16_4.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat6.x * u_xlat16_4.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = exp2((-u_xlat0));
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
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
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform highp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump float u_xlat16_5;
vec2 u_xlat6;
float u_xlat12;
lowp float u_xlat10_12;
float u_xlat18;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat18 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat18 = _ZBufferParams.x * u_xlat18 + _ZBufferParams.y;
    u_xlat18 = float(1.0) / u_xlat18;
    u_xlat2.xyz = vec3(u_xlat18) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat18 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat6.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat6.x = min(max(u_xlat6.x, 0.0), 1.0);
#else
    u_xlat6.x = clamp(u_xlat6.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat10_12 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat1.xy = u_xlat1.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat1.xy);
    u_xlat16_4.x = u_xlat6.x + u_xlat10_12;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat6.xy = u_xlat2.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat6.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat2.xx + u_xlat6.xy;
    u_xlat6.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat2.ww + u_xlat6.xy;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat6.xy = u_xlat6.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat6.x = texture(_LightTexture0, u_xlat6.xy, -8.0).w;
    u_xlat6.x = u_xlat6.x * u_xlat16_4.x;
    u_xlat12 = u_xlat6.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat12 = min(max(u_xlat12, 0.0), 1.0);
#else
    u_xlat12 = clamp(u_xlat12, 0.0, 1.0);
#endif
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat18 = inversesqrt(u_xlat18);
    u_xlat2.xyz = (-u_xlat2.xyz) * vec3(u_xlat18) + (-_LightDir.xyz);
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat18 = inversesqrt(u_xlat18);
    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
    u_xlat16_4.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = u_xlat10_1.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat2.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
    u_xlat16_4.x = max(u_xlat16_4.x, 0.0);
    u_xlat6.x = u_xlat6.x * u_xlat16_4.x;
    u_xlat1.xyz = u_xlat6.xxx * _LightColor.xyz;
    u_xlat16_4.x = max(u_xlat16_5, 0.0);
    u_xlat16_4.x = log2(u_xlat16_4.x);
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_22;
    u_xlat16_4.x = exp2(u_xlat16_4.x);
    u_xlat6.x = u_xlat12 * u_xlat16_4.x;
    u_xlat16_4.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat6.x * u_xlat16_4.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = exp2((-u_xlat0));
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT" "SHADOWS_CUBE" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w)));
  atten_6 = tmpvar_15.w;
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  mediump float shadowVal_18;
  highp float mydist_19;
  mydist_19 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_ShadowMapTexture, tmpvar_13);
  highp vec4 vals_21;
  vals_21 = tmpvar_20;
  highp float tmpvar_22;
  tmpvar_22 = dot (vals_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVal_18 = tmpvar_22;
  mediump float tmpvar_23;
  if ((shadowVal_18 < mydist_19)) {
    tmpvar_23 = _LightShadowData.x;
  } else {
    tmpvar_23 = 1.0;
  };
  mediump float tmpvar_24;
  tmpvar_24 = clamp ((tmpvar_23 + tmpvar_16), 0.0, 1.0);
  atten_6 = (tmpvar_15.w * tmpvar_24);
  lowp vec4 tmpvar_25;
  highp vec2 P_26;
  P_26 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_25 = texture2D (_CameraNormalsTexture, P_26);
  nspec_5 = tmpvar_25;
  mediump vec3 tmpvar_27;
  tmpvar_27 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_28;
  tmpvar_28 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = pow (max (0.0, dot (h_4, tmpvar_27)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_29;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_27)
  ) * atten_6));
  mediump vec3 rgb_30;
  rgb_30 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_30, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_31;
  tmpvar_31 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_31);
  mediump vec4 tmpvar_32;
  tmpvar_32 = exp2(-(res_2));
  tmpvar_1 = tmpvar_32;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w)));
  atten_6 = tmpvar_15.w;
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  mediump float shadowVal_18;
  highp float mydist_19;
  mydist_19 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_ShadowMapTexture, tmpvar_13);
  highp vec4 vals_21;
  vals_21 = tmpvar_20;
  highp float tmpvar_22;
  tmpvar_22 = dot (vals_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVal_18 = tmpvar_22;
  mediump float tmpvar_23;
  if ((shadowVal_18 < mydist_19)) {
    tmpvar_23 = _LightShadowData.x;
  } else {
    tmpvar_23 = 1.0;
  };
  mediump float tmpvar_24;
  tmpvar_24 = clamp ((tmpvar_23 + tmpvar_16), 0.0, 1.0);
  atten_6 = (tmpvar_15.w * tmpvar_24);
  lowp vec4 tmpvar_25;
  highp vec2 P_26;
  P_26 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_25 = texture2D (_CameraNormalsTexture, P_26);
  nspec_5 = tmpvar_25;
  mediump vec3 tmpvar_27;
  tmpvar_27 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_28;
  tmpvar_28 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = pow (max (0.0, dot (h_4, tmpvar_27)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_29;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_27)
  ) * atten_6));
  mediump vec3 rgb_30;
  rgb_30 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_30, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_31;
  tmpvar_31 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_31);
  mediump vec4 tmpvar_32;
  tmpvar_32 = exp2(-(res_2));
  tmpvar_1 = tmpvar_32;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w)));
  atten_6 = tmpvar_15.w;
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  mediump float shadowVal_18;
  highp float mydist_19;
  mydist_19 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_ShadowMapTexture, tmpvar_13);
  highp vec4 vals_21;
  vals_21 = tmpvar_20;
  highp float tmpvar_22;
  tmpvar_22 = dot (vals_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVal_18 = tmpvar_22;
  mediump float tmpvar_23;
  if ((shadowVal_18 < mydist_19)) {
    tmpvar_23 = _LightShadowData.x;
  } else {
    tmpvar_23 = 1.0;
  };
  mediump float tmpvar_24;
  tmpvar_24 = clamp ((tmpvar_23 + tmpvar_16), 0.0, 1.0);
  atten_6 = (tmpvar_15.w * tmpvar_24);
  lowp vec4 tmpvar_25;
  highp vec2 P_26;
  P_26 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_25 = texture2D (_CameraNormalsTexture, P_26);
  nspec_5 = tmpvar_25;
  mediump vec3 tmpvar_27;
  tmpvar_27 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_28;
  tmpvar_28 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = pow (max (0.0, dot (h_4, tmpvar_27)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_29;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_27)
  ) * atten_6));
  mediump vec3 rgb_30;
  rgb_30 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_30, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_31;
  tmpvar_31 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_31);
  mediump vec4 tmpvar_32;
  tmpvar_32 = exp2(-(res_2));
  tmpvar_1 = tmpvar_32;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "POINT" "SHADOWS_CUBE" }
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
uniform 	vec4 _LightPositionRange;
uniform 	vec4 _LightProjectionParams;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
lowp vec4 u_xlat10_4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
float u_xlat14;
bool u_xlatb14;
float u_xlat21;
float u_xlat23;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat7.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat7.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat7.x = min(max(u_xlat7.x, 0.0), 1.0);
#else
    u_xlat7.x = clamp(u_xlat7.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat3.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat10_4 = texture(_ShadowMapTexture, u_xlat3.xyz);
    u_xlat14 = dot(u_xlat10_4, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat21 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat23 = sqrt(u_xlat21);
    u_xlat23 = u_xlat23 * _LightPositionRange.w;
    u_xlat23 = u_xlat23 * _LightProjectionParams.w;
#ifdef UNITY_ADRENO_ES3
    u_xlatb14 = !!(u_xlat14<u_xlat23);
#else
    u_xlatb14 = u_xlat14<u_xlat23;
#endif
    u_xlat16_5.x = (u_xlatb14) ? _LightShadowData.x : 1.0;
    u_xlat16_5.x = u_xlat7.x + u_xlat16_5.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat7.x = u_xlat21 * _LightPos.w;
    u_xlat14 = inversesqrt(u_xlat21);
    u_xlat3.xyz = vec3(u_xlat14) * u_xlat3.xyz;
    u_xlat7.x = texture(_LightTextureB0, u_xlat7.xx).w;
    u_xlat7.x = u_xlat16_5.x * u_xlat7.x;
    u_xlat14 = u_xlat7.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat2.xyz = (-u_xlat2.xyz) * vec3(u_xlat21) + (-u_xlat3.xyz);
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat2.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat2.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot((-u_xlat3.xyz), u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat7.x = u_xlat7.x * u_xlat16_5.x;
    u_xlat1.xyz = u_xlat7.xxx * _LightColor.xyz;
    u_xlat16_5.x = max(u_xlat16_6, 0.0);
    u_xlat16_5.x = log2(u_xlat16_5.x);
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_26;
    u_xlat16_5.x = exp2(u_xlat16_5.x);
    u_xlat7.x = u_xlat14 * u_xlat16_5.x;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat7.x * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = exp2((-u_xlat0));
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" }
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
uniform 	vec4 _LightPositionRange;
uniform 	vec4 _LightProjectionParams;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
lowp vec4 u_xlat10_4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
float u_xlat14;
bool u_xlatb14;
float u_xlat21;
float u_xlat23;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat7.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat7.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat7.x = min(max(u_xlat7.x, 0.0), 1.0);
#else
    u_xlat7.x = clamp(u_xlat7.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat3.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat10_4 = texture(_ShadowMapTexture, u_xlat3.xyz);
    u_xlat14 = dot(u_xlat10_4, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat21 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat23 = sqrt(u_xlat21);
    u_xlat23 = u_xlat23 * _LightPositionRange.w;
    u_xlat23 = u_xlat23 * _LightProjectionParams.w;
#ifdef UNITY_ADRENO_ES3
    u_xlatb14 = !!(u_xlat14<u_xlat23);
#else
    u_xlatb14 = u_xlat14<u_xlat23;
#endif
    u_xlat16_5.x = (u_xlatb14) ? _LightShadowData.x : 1.0;
    u_xlat16_5.x = u_xlat7.x + u_xlat16_5.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat7.x = u_xlat21 * _LightPos.w;
    u_xlat14 = inversesqrt(u_xlat21);
    u_xlat3.xyz = vec3(u_xlat14) * u_xlat3.xyz;
    u_xlat7.x = texture(_LightTextureB0, u_xlat7.xx).w;
    u_xlat7.x = u_xlat16_5.x * u_xlat7.x;
    u_xlat14 = u_xlat7.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat2.xyz = (-u_xlat2.xyz) * vec3(u_xlat21) + (-u_xlat3.xyz);
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat2.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat2.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot((-u_xlat3.xyz), u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat7.x = u_xlat7.x * u_xlat16_5.x;
    u_xlat1.xyz = u_xlat7.xxx * _LightColor.xyz;
    u_xlat16_5.x = max(u_xlat16_6, 0.0);
    u_xlat16_5.x = log2(u_xlat16_5.x);
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_26;
    u_xlat16_5.x = exp2(u_xlat16_5.x);
    u_xlat7.x = u_xlat14 * u_xlat16_5.x;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat7.x * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = exp2((-u_xlat0));
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" }
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
uniform 	vec4 _LightPositionRange;
uniform 	vec4 _LightProjectionParams;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
lowp vec4 u_xlat10_4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
float u_xlat14;
bool u_xlatb14;
float u_xlat21;
float u_xlat23;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat7.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat7.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat7.x = min(max(u_xlat7.x, 0.0), 1.0);
#else
    u_xlat7.x = clamp(u_xlat7.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat3.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat10_4 = texture(_ShadowMapTexture, u_xlat3.xyz);
    u_xlat14 = dot(u_xlat10_4, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat21 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat23 = sqrt(u_xlat21);
    u_xlat23 = u_xlat23 * _LightPositionRange.w;
    u_xlat23 = u_xlat23 * _LightProjectionParams.w;
#ifdef UNITY_ADRENO_ES3
    u_xlatb14 = !!(u_xlat14<u_xlat23);
#else
    u_xlatb14 = u_xlat14<u_xlat23;
#endif
    u_xlat16_5.x = (u_xlatb14) ? _LightShadowData.x : 1.0;
    u_xlat16_5.x = u_xlat7.x + u_xlat16_5.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat7.x = u_xlat21 * _LightPos.w;
    u_xlat14 = inversesqrt(u_xlat21);
    u_xlat3.xyz = vec3(u_xlat14) * u_xlat3.xyz;
    u_xlat7.x = texture(_LightTextureB0, u_xlat7.xx).w;
    u_xlat7.x = u_xlat16_5.x * u_xlat7.x;
    u_xlat14 = u_xlat7.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat2.xyz = (-u_xlat2.xyz) * vec3(u_xlat21) + (-u_xlat3.xyz);
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat2.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat2.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot((-u_xlat3.xyz), u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat7.x = u_xlat7.x * u_xlat16_5.x;
    u_xlat1.xyz = u_xlat7.xxx * _LightColor.xyz;
    u_xlat16_5.x = max(u_xlat16_6, 0.0);
    u_xlat16_5.x = log2(u_xlat16_5.x);
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_26;
    u_xlat16_5.x = exp2(u_xlat16_5.x);
    u_xlat7.x = u_xlat14 * u_xlat16_5.x;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat7.x * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = exp2((-u_xlat0));
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
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
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w)));
  atten_6 = tmpvar_15.w;
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  highp vec4 shadowVals_18;
  highp float mydist_19;
  mydist_19 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_20;
  tmpvar_20.w = 0.0;
  tmpvar_20.xyz = (tmpvar_13 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_20.xyz, 0.0);
  tmpvar_21 = tmpvar_22;
  shadowVals_18.x = dot (tmpvar_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_23;
  tmpvar_23.w = 0.0;
  tmpvar_23.xyz = (tmpvar_13 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_23.xyz, 0.0);
  tmpvar_24 = tmpvar_25;
  shadowVals_18.y = dot (tmpvar_24, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_26;
  tmpvar_26.w = 0.0;
  tmpvar_26.xyz = (tmpvar_13 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_26.xyz, 0.0);
  tmpvar_27 = tmpvar_28;
  shadowVals_18.z = dot (tmpvar_27, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_29;
  tmpvar_29.w = 0.0;
  tmpvar_29.xyz = (tmpvar_13 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_30;
  lowp vec4 tmpvar_31;
  tmpvar_31 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_29.xyz, 0.0);
  tmpvar_30 = tmpvar_31;
  shadowVals_18.w = dot (tmpvar_30, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_32;
  tmpvar_32 = lessThan (shadowVals_18, vec4(mydist_19));
  mediump vec4 tmpvar_33;
  tmpvar_33 = _LightShadowData.xxxx;
  mediump float tmpvar_34;
  if (tmpvar_32.x) {
    tmpvar_34 = tmpvar_33.x;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_32.y) {
    tmpvar_35 = tmpvar_33.y;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump float tmpvar_36;
  if (tmpvar_32.z) {
    tmpvar_36 = tmpvar_33.z;
  } else {
    tmpvar_36 = 1.0;
  };
  mediump float tmpvar_37;
  if (tmpvar_32.w) {
    tmpvar_37 = tmpvar_33.w;
  } else {
    tmpvar_37 = 1.0;
  };
  mediump vec4 tmpvar_38;
  tmpvar_38.x = tmpvar_34;
  tmpvar_38.y = tmpvar_35;
  tmpvar_38.z = tmpvar_36;
  tmpvar_38.w = tmpvar_37;
  mediump float tmpvar_39;
  tmpvar_39 = clamp ((dot (tmpvar_38, vec4(0.25, 0.25, 0.25, 0.25)) + tmpvar_16), 0.0, 1.0);
  atten_6 = (tmpvar_15.w * tmpvar_39);
  lowp vec4 tmpvar_40;
  highp vec2 P_41;
  P_41 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_40 = texture2D (_CameraNormalsTexture, P_41);
  nspec_5 = tmpvar_40;
  mediump vec3 tmpvar_42;
  tmpvar_42 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_43;
  tmpvar_43 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_43;
  mediump float tmpvar_44;
  tmpvar_44 = pow (max (0.0, dot (h_4, tmpvar_42)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_44;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_42)
  ) * atten_6));
  mediump vec3 rgb_45;
  rgb_45 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_45, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_46;
  tmpvar_46 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_46);
  mediump vec4 tmpvar_47;
  tmpvar_47 = exp2(-(res_2));
  tmpvar_1 = tmpvar_47;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
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
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w)));
  atten_6 = tmpvar_15.w;
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  highp vec4 shadowVals_18;
  highp float mydist_19;
  mydist_19 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_20;
  tmpvar_20.w = 0.0;
  tmpvar_20.xyz = (tmpvar_13 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_20.xyz, 0.0);
  tmpvar_21 = tmpvar_22;
  shadowVals_18.x = dot (tmpvar_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_23;
  tmpvar_23.w = 0.0;
  tmpvar_23.xyz = (tmpvar_13 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_23.xyz, 0.0);
  tmpvar_24 = tmpvar_25;
  shadowVals_18.y = dot (tmpvar_24, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_26;
  tmpvar_26.w = 0.0;
  tmpvar_26.xyz = (tmpvar_13 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_26.xyz, 0.0);
  tmpvar_27 = tmpvar_28;
  shadowVals_18.z = dot (tmpvar_27, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_29;
  tmpvar_29.w = 0.0;
  tmpvar_29.xyz = (tmpvar_13 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_30;
  lowp vec4 tmpvar_31;
  tmpvar_31 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_29.xyz, 0.0);
  tmpvar_30 = tmpvar_31;
  shadowVals_18.w = dot (tmpvar_30, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_32;
  tmpvar_32 = lessThan (shadowVals_18, vec4(mydist_19));
  mediump vec4 tmpvar_33;
  tmpvar_33 = _LightShadowData.xxxx;
  mediump float tmpvar_34;
  if (tmpvar_32.x) {
    tmpvar_34 = tmpvar_33.x;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_32.y) {
    tmpvar_35 = tmpvar_33.y;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump float tmpvar_36;
  if (tmpvar_32.z) {
    tmpvar_36 = tmpvar_33.z;
  } else {
    tmpvar_36 = 1.0;
  };
  mediump float tmpvar_37;
  if (tmpvar_32.w) {
    tmpvar_37 = tmpvar_33.w;
  } else {
    tmpvar_37 = 1.0;
  };
  mediump vec4 tmpvar_38;
  tmpvar_38.x = tmpvar_34;
  tmpvar_38.y = tmpvar_35;
  tmpvar_38.z = tmpvar_36;
  tmpvar_38.w = tmpvar_37;
  mediump float tmpvar_39;
  tmpvar_39 = clamp ((dot (tmpvar_38, vec4(0.25, 0.25, 0.25, 0.25)) + tmpvar_16), 0.0, 1.0);
  atten_6 = (tmpvar_15.w * tmpvar_39);
  lowp vec4 tmpvar_40;
  highp vec2 P_41;
  P_41 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_40 = texture2D (_CameraNormalsTexture, P_41);
  nspec_5 = tmpvar_40;
  mediump vec3 tmpvar_42;
  tmpvar_42 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_43;
  tmpvar_43 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_43;
  mediump float tmpvar_44;
  tmpvar_44 = pow (max (0.0, dot (h_4, tmpvar_42)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_44;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_42)
  ) * atten_6));
  mediump vec3 rgb_45;
  rgb_45 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_45, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_46;
  tmpvar_46 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_46);
  mediump vec4 tmpvar_47;
  tmpvar_47 = exp2(-(res_2));
  tmpvar_1 = tmpvar_47;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
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
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w)));
  atten_6 = tmpvar_15.w;
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  highp vec4 shadowVals_18;
  highp float mydist_19;
  mydist_19 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_20;
  tmpvar_20.w = 0.0;
  tmpvar_20.xyz = (tmpvar_13 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_20.xyz, 0.0);
  tmpvar_21 = tmpvar_22;
  shadowVals_18.x = dot (tmpvar_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_23;
  tmpvar_23.w = 0.0;
  tmpvar_23.xyz = (tmpvar_13 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_23.xyz, 0.0);
  tmpvar_24 = tmpvar_25;
  shadowVals_18.y = dot (tmpvar_24, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_26;
  tmpvar_26.w = 0.0;
  tmpvar_26.xyz = (tmpvar_13 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_26.xyz, 0.0);
  tmpvar_27 = tmpvar_28;
  shadowVals_18.z = dot (tmpvar_27, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_29;
  tmpvar_29.w = 0.0;
  tmpvar_29.xyz = (tmpvar_13 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_30;
  lowp vec4 tmpvar_31;
  tmpvar_31 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_29.xyz, 0.0);
  tmpvar_30 = tmpvar_31;
  shadowVals_18.w = dot (tmpvar_30, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_32;
  tmpvar_32 = lessThan (shadowVals_18, vec4(mydist_19));
  mediump vec4 tmpvar_33;
  tmpvar_33 = _LightShadowData.xxxx;
  mediump float tmpvar_34;
  if (tmpvar_32.x) {
    tmpvar_34 = tmpvar_33.x;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_32.y) {
    tmpvar_35 = tmpvar_33.y;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump float tmpvar_36;
  if (tmpvar_32.z) {
    tmpvar_36 = tmpvar_33.z;
  } else {
    tmpvar_36 = 1.0;
  };
  mediump float tmpvar_37;
  if (tmpvar_32.w) {
    tmpvar_37 = tmpvar_33.w;
  } else {
    tmpvar_37 = 1.0;
  };
  mediump vec4 tmpvar_38;
  tmpvar_38.x = tmpvar_34;
  tmpvar_38.y = tmpvar_35;
  tmpvar_38.z = tmpvar_36;
  tmpvar_38.w = tmpvar_37;
  mediump float tmpvar_39;
  tmpvar_39 = clamp ((dot (tmpvar_38, vec4(0.25, 0.25, 0.25, 0.25)) + tmpvar_16), 0.0, 1.0);
  atten_6 = (tmpvar_15.w * tmpvar_39);
  lowp vec4 tmpvar_40;
  highp vec2 P_41;
  P_41 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_40 = texture2D (_CameraNormalsTexture, P_41);
  nspec_5 = tmpvar_40;
  mediump vec3 tmpvar_42;
  tmpvar_42 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_43;
  tmpvar_43 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_43;
  mediump float tmpvar_44;
  tmpvar_44 = pow (max (0.0, dot (h_4, tmpvar_42)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_44;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_42)
  ) * atten_6));
  mediump vec3 rgb_45;
  rgb_45 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_45, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_46;
  tmpvar_46 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_46);
  mediump vec4 tmpvar_47;
  tmpvar_47 = exp2(-(res_2));
  tmpvar_1 = tmpvar_47;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
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
uniform 	vec4 _LightPositionRange;
uniform 	vec4 _LightProjectionParams;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec4 u_xlat4;
lowp vec4 u_xlat10_4;
bvec4 u_xlatb4;
vec3 u_xlat5;
lowp vec4 u_xlat10_5;
mediump vec3 u_xlat16_6;
mediump float u_xlat16_7;
vec3 u_xlat8;
float u_xlat16;
float u_xlat24;
mediump float u_xlat16_30;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat16 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat16 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat8.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat8.xyz = u_xlat8.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat8.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat8.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat8.x = sqrt(u_xlat8.x);
    u_xlat0.x = (-u_xlat8.z) * u_xlat0.x + u_xlat8.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat8.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat8.x = min(max(u_xlat8.x, 0.0), 1.0);
#else
    u_xlat8.x = clamp(u_xlat8.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat3.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat4.xyz = u_xlat3.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
    u_xlat10_4 = textureLod(_ShadowMapTexture, u_xlat4.xyz, 0.0);
    u_xlat4.x = dot(u_xlat10_4, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat5.xyz = u_xlat3.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
    u_xlat10_5 = textureLod(_ShadowMapTexture, u_xlat5.xyz, 0.0);
    u_xlat4.y = dot(u_xlat10_5, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat5.xyz = u_xlat3.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
    u_xlat10_5 = textureLod(_ShadowMapTexture, u_xlat5.xyz, 0.0);
    u_xlat4.z = dot(u_xlat10_5, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat5.xyz = u_xlat3.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
    u_xlat10_5 = textureLod(_ShadowMapTexture, u_xlat5.xyz, 0.0);
    u_xlat4.w = dot(u_xlat10_5, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat16 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat24 = sqrt(u_xlat16);
    u_xlat24 = u_xlat24 * _LightPositionRange.w;
    u_xlat24 = u_xlat24 * _LightProjectionParams.w;
    u_xlatb4 = lessThan(u_xlat4, vec4(u_xlat24));
    u_xlat4.x = (u_xlatb4.x) ? _LightShadowData.x : float(1.0);
    u_xlat4.y = (u_xlatb4.y) ? _LightShadowData.x : float(1.0);
    u_xlat4.z = (u_xlatb4.z) ? _LightShadowData.x : float(1.0);
    u_xlat4.w = (u_xlatb4.w) ? _LightShadowData.x : float(1.0);
    u_xlat16_6.x = dot(u_xlat4, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat16_6.x = u_xlat8.x + u_xlat16_6.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_6.x = min(max(u_xlat16_6.x, 0.0), 1.0);
#else
    u_xlat16_6.x = clamp(u_xlat16_6.x, 0.0, 1.0);
#endif
    u_xlat8.x = u_xlat16 * _LightPos.w;
    u_xlat16 = inversesqrt(u_xlat16);
    u_xlat3.xyz = vec3(u_xlat16) * u_xlat3.xyz;
    u_xlat8.x = texture(_LightTextureB0, u_xlat8.xx).w;
    u_xlat8.x = u_xlat16_6.x * u_xlat8.x;
    u_xlat16 = u_xlat8.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16 = min(max(u_xlat16, 0.0), 1.0);
#else
    u_xlat16 = clamp(u_xlat16, 0.0, 1.0);
#endif
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = (-u_xlat2.xyz) * vec3(u_xlat24) + (-u_xlat3.xyz);
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat2.xyz;
    u_xlat16_6.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_30 = u_xlat10_1.w * 128.0;
    u_xlat16_7 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_7 = inversesqrt(u_xlat16_7);
    u_xlat16_6.xyz = u_xlat16_6.xyz * vec3(u_xlat16_7);
    u_xlat16_7 = dot(u_xlat2.xyz, u_xlat16_6.xyz);
    u_xlat16_6.x = dot((-u_xlat3.xyz), u_xlat16_6.xyz);
    u_xlat16_6.x = max(u_xlat16_6.x, 0.0);
    u_xlat8.x = u_xlat8.x * u_xlat16_6.x;
    u_xlat1.xyz = u_xlat8.xxx * _LightColor.xyz;
    u_xlat16_6.x = max(u_xlat16_7, 0.0);
    u_xlat16_6.x = log2(u_xlat16_6.x);
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_30;
    u_xlat16_6.x = exp2(u_xlat16_6.x);
    u_xlat8.x = u_xlat16 * u_xlat16_6.x;
    u_xlat16_6.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat8.x * u_xlat16_6.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = exp2((-u_xlat0));
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
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
uniform 	vec4 _LightPositionRange;
uniform 	vec4 _LightProjectionParams;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec4 u_xlat4;
lowp vec4 u_xlat10_4;
bvec4 u_xlatb4;
vec3 u_xlat5;
lowp vec4 u_xlat10_5;
mediump vec3 u_xlat16_6;
mediump float u_xlat16_7;
vec3 u_xlat8;
float u_xlat16;
float u_xlat24;
mediump float u_xlat16_30;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat16 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat16 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat8.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat8.xyz = u_xlat8.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat8.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat8.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat8.x = sqrt(u_xlat8.x);
    u_xlat0.x = (-u_xlat8.z) * u_xlat0.x + u_xlat8.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat8.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat8.x = min(max(u_xlat8.x, 0.0), 1.0);
#else
    u_xlat8.x = clamp(u_xlat8.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat3.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat4.xyz = u_xlat3.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
    u_xlat10_4 = textureLod(_ShadowMapTexture, u_xlat4.xyz, 0.0);
    u_xlat4.x = dot(u_xlat10_4, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat5.xyz = u_xlat3.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
    u_xlat10_5 = textureLod(_ShadowMapTexture, u_xlat5.xyz, 0.0);
    u_xlat4.y = dot(u_xlat10_5, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat5.xyz = u_xlat3.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
    u_xlat10_5 = textureLod(_ShadowMapTexture, u_xlat5.xyz, 0.0);
    u_xlat4.z = dot(u_xlat10_5, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat5.xyz = u_xlat3.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
    u_xlat10_5 = textureLod(_ShadowMapTexture, u_xlat5.xyz, 0.0);
    u_xlat4.w = dot(u_xlat10_5, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat16 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat24 = sqrt(u_xlat16);
    u_xlat24 = u_xlat24 * _LightPositionRange.w;
    u_xlat24 = u_xlat24 * _LightProjectionParams.w;
    u_xlatb4 = lessThan(u_xlat4, vec4(u_xlat24));
    u_xlat4.x = (u_xlatb4.x) ? _LightShadowData.x : float(1.0);
    u_xlat4.y = (u_xlatb4.y) ? _LightShadowData.x : float(1.0);
    u_xlat4.z = (u_xlatb4.z) ? _LightShadowData.x : float(1.0);
    u_xlat4.w = (u_xlatb4.w) ? _LightShadowData.x : float(1.0);
    u_xlat16_6.x = dot(u_xlat4, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat16_6.x = u_xlat8.x + u_xlat16_6.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_6.x = min(max(u_xlat16_6.x, 0.0), 1.0);
#else
    u_xlat16_6.x = clamp(u_xlat16_6.x, 0.0, 1.0);
#endif
    u_xlat8.x = u_xlat16 * _LightPos.w;
    u_xlat16 = inversesqrt(u_xlat16);
    u_xlat3.xyz = vec3(u_xlat16) * u_xlat3.xyz;
    u_xlat8.x = texture(_LightTextureB0, u_xlat8.xx).w;
    u_xlat8.x = u_xlat16_6.x * u_xlat8.x;
    u_xlat16 = u_xlat8.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16 = min(max(u_xlat16, 0.0), 1.0);
#else
    u_xlat16 = clamp(u_xlat16, 0.0, 1.0);
#endif
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = (-u_xlat2.xyz) * vec3(u_xlat24) + (-u_xlat3.xyz);
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat2.xyz;
    u_xlat16_6.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_30 = u_xlat10_1.w * 128.0;
    u_xlat16_7 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_7 = inversesqrt(u_xlat16_7);
    u_xlat16_6.xyz = u_xlat16_6.xyz * vec3(u_xlat16_7);
    u_xlat16_7 = dot(u_xlat2.xyz, u_xlat16_6.xyz);
    u_xlat16_6.x = dot((-u_xlat3.xyz), u_xlat16_6.xyz);
    u_xlat16_6.x = max(u_xlat16_6.x, 0.0);
    u_xlat8.x = u_xlat8.x * u_xlat16_6.x;
    u_xlat1.xyz = u_xlat8.xxx * _LightColor.xyz;
    u_xlat16_6.x = max(u_xlat16_7, 0.0);
    u_xlat16_6.x = log2(u_xlat16_6.x);
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_30;
    u_xlat16_6.x = exp2(u_xlat16_6.x);
    u_xlat8.x = u_xlat16 * u_xlat16_6.x;
    u_xlat16_6.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat8.x * u_xlat16_6.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = exp2((-u_xlat0));
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
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
uniform 	vec4 _LightPositionRange;
uniform 	vec4 _LightProjectionParams;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec4 u_xlat4;
lowp vec4 u_xlat10_4;
bvec4 u_xlatb4;
vec3 u_xlat5;
lowp vec4 u_xlat10_5;
mediump vec3 u_xlat16_6;
mediump float u_xlat16_7;
vec3 u_xlat8;
float u_xlat16;
float u_xlat24;
mediump float u_xlat16_30;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat16 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat16 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat8.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat8.xyz = u_xlat8.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat8.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat8.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat8.x = sqrt(u_xlat8.x);
    u_xlat0.x = (-u_xlat8.z) * u_xlat0.x + u_xlat8.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat8.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat8.x = min(max(u_xlat8.x, 0.0), 1.0);
#else
    u_xlat8.x = clamp(u_xlat8.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat3.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat4.xyz = u_xlat3.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
    u_xlat10_4 = textureLod(_ShadowMapTexture, u_xlat4.xyz, 0.0);
    u_xlat4.x = dot(u_xlat10_4, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat5.xyz = u_xlat3.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
    u_xlat10_5 = textureLod(_ShadowMapTexture, u_xlat5.xyz, 0.0);
    u_xlat4.y = dot(u_xlat10_5, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat5.xyz = u_xlat3.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
    u_xlat10_5 = textureLod(_ShadowMapTexture, u_xlat5.xyz, 0.0);
    u_xlat4.z = dot(u_xlat10_5, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat5.xyz = u_xlat3.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
    u_xlat10_5 = textureLod(_ShadowMapTexture, u_xlat5.xyz, 0.0);
    u_xlat4.w = dot(u_xlat10_5, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat16 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat24 = sqrt(u_xlat16);
    u_xlat24 = u_xlat24 * _LightPositionRange.w;
    u_xlat24 = u_xlat24 * _LightProjectionParams.w;
    u_xlatb4 = lessThan(u_xlat4, vec4(u_xlat24));
    u_xlat4.x = (u_xlatb4.x) ? _LightShadowData.x : float(1.0);
    u_xlat4.y = (u_xlatb4.y) ? _LightShadowData.x : float(1.0);
    u_xlat4.z = (u_xlatb4.z) ? _LightShadowData.x : float(1.0);
    u_xlat4.w = (u_xlatb4.w) ? _LightShadowData.x : float(1.0);
    u_xlat16_6.x = dot(u_xlat4, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat16_6.x = u_xlat8.x + u_xlat16_6.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_6.x = min(max(u_xlat16_6.x, 0.0), 1.0);
#else
    u_xlat16_6.x = clamp(u_xlat16_6.x, 0.0, 1.0);
#endif
    u_xlat8.x = u_xlat16 * _LightPos.w;
    u_xlat16 = inversesqrt(u_xlat16);
    u_xlat3.xyz = vec3(u_xlat16) * u_xlat3.xyz;
    u_xlat8.x = texture(_LightTextureB0, u_xlat8.xx).w;
    u_xlat8.x = u_xlat16_6.x * u_xlat8.x;
    u_xlat16 = u_xlat8.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16 = min(max(u_xlat16, 0.0), 1.0);
#else
    u_xlat16 = clamp(u_xlat16, 0.0, 1.0);
#endif
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = (-u_xlat2.xyz) * vec3(u_xlat24) + (-u_xlat3.xyz);
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat2.xyz;
    u_xlat16_6.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_30 = u_xlat10_1.w * 128.0;
    u_xlat16_7 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_7 = inversesqrt(u_xlat16_7);
    u_xlat16_6.xyz = u_xlat16_6.xyz * vec3(u_xlat16_7);
    u_xlat16_7 = dot(u_xlat2.xyz, u_xlat16_6.xyz);
    u_xlat16_6.x = dot((-u_xlat3.xyz), u_xlat16_6.xyz);
    u_xlat16_6.x = max(u_xlat16_6.x, 0.0);
    u_xlat8.x = u_xlat8.x * u_xlat16_6.x;
    u_xlat1.xyz = u_xlat8.xxx * _LightColor.xyz;
    u_xlat16_6.x = max(u_xlat16_7, 0.0);
    u_xlat16_6.x = log2(u_xlat16_6.x);
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_30;
    u_xlat16_6.x = exp2(u_xlat16_6.x);
    u_xlat8.x = u_xlat16 * u_xlat16_6.x;
    u_xlat16_6.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat8.x * u_xlat16_6.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = exp2((-u_xlat0));
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w)));
  atten_6 = tmpvar_15.w;
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  mediump float shadowVal_18;
  highp float mydist_19;
  mydist_19 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_ShadowMapTexture, tmpvar_13);
  highp vec4 vals_21;
  vals_21 = tmpvar_20;
  highp float tmpvar_22;
  tmpvar_22 = dot (vals_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVal_18 = tmpvar_22;
  mediump float tmpvar_23;
  if ((shadowVal_18 < mydist_19)) {
    tmpvar_23 = _LightShadowData.x;
  } else {
    tmpvar_23 = 1.0;
  };
  mediump float tmpvar_24;
  tmpvar_24 = clamp ((tmpvar_23 + tmpvar_16), 0.0, 1.0);
  atten_6 = (tmpvar_15.w * tmpvar_24);
  highp vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.xyz = tmpvar_10;
  highp vec4 tmpvar_26;
  tmpvar_26.w = -8.0;
  tmpvar_26.xyz = (unity_WorldToLight * tmpvar_25).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_26.xyz, -8.0).w);
  lowp vec4 tmpvar_27;
  highp vec2 P_28;
  P_28 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_27 = texture2D (_CameraNormalsTexture, P_28);
  nspec_5 = tmpvar_27;
  mediump vec3 tmpvar_29;
  tmpvar_29 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_30;
  tmpvar_30 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = pow (max (0.0, dot (h_4, tmpvar_29)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_31;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_29)
  ) * atten_6));
  mediump vec3 rgb_32;
  rgb_32 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_32, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_33;
  tmpvar_33 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_33);
  mediump vec4 tmpvar_34;
  tmpvar_34 = exp2(-(res_2));
  tmpvar_1 = tmpvar_34;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w)));
  atten_6 = tmpvar_15.w;
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  mediump float shadowVal_18;
  highp float mydist_19;
  mydist_19 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_ShadowMapTexture, tmpvar_13);
  highp vec4 vals_21;
  vals_21 = tmpvar_20;
  highp float tmpvar_22;
  tmpvar_22 = dot (vals_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVal_18 = tmpvar_22;
  mediump float tmpvar_23;
  if ((shadowVal_18 < mydist_19)) {
    tmpvar_23 = _LightShadowData.x;
  } else {
    tmpvar_23 = 1.0;
  };
  mediump float tmpvar_24;
  tmpvar_24 = clamp ((tmpvar_23 + tmpvar_16), 0.0, 1.0);
  atten_6 = (tmpvar_15.w * tmpvar_24);
  highp vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.xyz = tmpvar_10;
  highp vec4 tmpvar_26;
  tmpvar_26.w = -8.0;
  tmpvar_26.xyz = (unity_WorldToLight * tmpvar_25).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_26.xyz, -8.0).w);
  lowp vec4 tmpvar_27;
  highp vec2 P_28;
  P_28 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_27 = texture2D (_CameraNormalsTexture, P_28);
  nspec_5 = tmpvar_27;
  mediump vec3 tmpvar_29;
  tmpvar_29 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_30;
  tmpvar_30 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = pow (max (0.0, dot (h_4, tmpvar_29)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_31;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_29)
  ) * atten_6));
  mediump vec3 rgb_32;
  rgb_32 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_32, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_33;
  tmpvar_33 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_33);
  mediump vec4 tmpvar_34;
  tmpvar_34 = exp2(-(res_2));
  tmpvar_1 = tmpvar_34;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w)));
  atten_6 = tmpvar_15.w;
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  mediump float shadowVal_18;
  highp float mydist_19;
  mydist_19 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_ShadowMapTexture, tmpvar_13);
  highp vec4 vals_21;
  vals_21 = tmpvar_20;
  highp float tmpvar_22;
  tmpvar_22 = dot (vals_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVal_18 = tmpvar_22;
  mediump float tmpvar_23;
  if ((shadowVal_18 < mydist_19)) {
    tmpvar_23 = _LightShadowData.x;
  } else {
    tmpvar_23 = 1.0;
  };
  mediump float tmpvar_24;
  tmpvar_24 = clamp ((tmpvar_23 + tmpvar_16), 0.0, 1.0);
  atten_6 = (tmpvar_15.w * tmpvar_24);
  highp vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.xyz = tmpvar_10;
  highp vec4 tmpvar_26;
  tmpvar_26.w = -8.0;
  tmpvar_26.xyz = (unity_WorldToLight * tmpvar_25).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_26.xyz, -8.0).w);
  lowp vec4 tmpvar_27;
  highp vec2 P_28;
  P_28 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_27 = texture2D (_CameraNormalsTexture, P_28);
  nspec_5 = tmpvar_27;
  mediump vec3 tmpvar_29;
  tmpvar_29 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_30;
  tmpvar_30 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = pow (max (0.0, dot (h_4, tmpvar_29)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_31;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_29)
  ) * atten_6));
  mediump vec3 rgb_32;
  rgb_32 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_32, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_33;
  tmpvar_33 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_33);
  mediump vec4 tmpvar_34;
  tmpvar_34 = exp2(-(res_2));
  tmpvar_1 = tmpvar_34;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
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
uniform 	vec4 _LightPositionRange;
uniform 	vec4 _LightProjectionParams;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec3 u_xlat4;
lowp vec4 u_xlat10_4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
float u_xlat14;
bool u_xlatb14;
float u_xlat16;
float u_xlat21;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat7.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat7.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat7.x = min(max(u_xlat7.x, 0.0), 1.0);
#else
    u_xlat7.x = clamp(u_xlat7.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat3.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat10_4 = texture(_ShadowMapTexture, u_xlat3.xyz);
    u_xlat14 = dot(u_xlat10_4, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat21 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat16 = sqrt(u_xlat21);
    u_xlat16 = u_xlat16 * _LightPositionRange.w;
    u_xlat16 = u_xlat16 * _LightProjectionParams.w;
#ifdef UNITY_ADRENO_ES3
    u_xlatb14 = !!(u_xlat14<u_xlat16);
#else
    u_xlatb14 = u_xlat14<u_xlat16;
#endif
    u_xlat16_5.x = (u_xlatb14) ? _LightShadowData.x : 1.0;
    u_xlat16_5.x = u_xlat7.x + u_xlat16_5.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat7.x = u_xlat21 * _LightPos.w;
    u_xlat14 = inversesqrt(u_xlat21);
    u_xlat3.xyz = vec3(u_xlat14) * u_xlat3.xyz;
    u_xlat7.x = texture(_LightTextureB0, u_xlat7.xx).w;
    u_xlat7.x = u_xlat16_5.x * u_xlat7.x;
    u_xlat4.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat4.xyz;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat4.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat4.xyz = u_xlat4.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat14 = texture(_LightTexture0, u_xlat4.xyz, -8.0).w;
    u_xlat7.x = u_xlat14 * u_xlat7.x;
    u_xlat14 = u_xlat7.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat2.xyz = (-u_xlat2.xyz) * vec3(u_xlat21) + (-u_xlat3.xyz);
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat2.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat2.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot((-u_xlat3.xyz), u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat7.x = u_xlat7.x * u_xlat16_5.x;
    u_xlat1.xyz = u_xlat7.xxx * _LightColor.xyz;
    u_xlat16_5.x = max(u_xlat16_6, 0.0);
    u_xlat16_5.x = log2(u_xlat16_5.x);
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_26;
    u_xlat16_5.x = exp2(u_xlat16_5.x);
    u_xlat7.x = u_xlat14 * u_xlat16_5.x;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat7.x * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = exp2((-u_xlat0));
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
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
uniform 	vec4 _LightPositionRange;
uniform 	vec4 _LightProjectionParams;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec3 u_xlat4;
lowp vec4 u_xlat10_4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
float u_xlat14;
bool u_xlatb14;
float u_xlat16;
float u_xlat21;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat7.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat7.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat7.x = min(max(u_xlat7.x, 0.0), 1.0);
#else
    u_xlat7.x = clamp(u_xlat7.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat3.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat10_4 = texture(_ShadowMapTexture, u_xlat3.xyz);
    u_xlat14 = dot(u_xlat10_4, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat21 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat16 = sqrt(u_xlat21);
    u_xlat16 = u_xlat16 * _LightPositionRange.w;
    u_xlat16 = u_xlat16 * _LightProjectionParams.w;
#ifdef UNITY_ADRENO_ES3
    u_xlatb14 = !!(u_xlat14<u_xlat16);
#else
    u_xlatb14 = u_xlat14<u_xlat16;
#endif
    u_xlat16_5.x = (u_xlatb14) ? _LightShadowData.x : 1.0;
    u_xlat16_5.x = u_xlat7.x + u_xlat16_5.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat7.x = u_xlat21 * _LightPos.w;
    u_xlat14 = inversesqrt(u_xlat21);
    u_xlat3.xyz = vec3(u_xlat14) * u_xlat3.xyz;
    u_xlat7.x = texture(_LightTextureB0, u_xlat7.xx).w;
    u_xlat7.x = u_xlat16_5.x * u_xlat7.x;
    u_xlat4.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat4.xyz;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat4.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat4.xyz = u_xlat4.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat14 = texture(_LightTexture0, u_xlat4.xyz, -8.0).w;
    u_xlat7.x = u_xlat14 * u_xlat7.x;
    u_xlat14 = u_xlat7.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat2.xyz = (-u_xlat2.xyz) * vec3(u_xlat21) + (-u_xlat3.xyz);
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat2.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat2.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot((-u_xlat3.xyz), u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat7.x = u_xlat7.x * u_xlat16_5.x;
    u_xlat1.xyz = u_xlat7.xxx * _LightColor.xyz;
    u_xlat16_5.x = max(u_xlat16_6, 0.0);
    u_xlat16_5.x = log2(u_xlat16_5.x);
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_26;
    u_xlat16_5.x = exp2(u_xlat16_5.x);
    u_xlat7.x = u_xlat14 * u_xlat16_5.x;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat7.x * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = exp2((-u_xlat0));
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
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
uniform 	vec4 _LightPositionRange;
uniform 	vec4 _LightProjectionParams;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec3 u_xlat4;
lowp vec4 u_xlat10_4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
float u_xlat14;
bool u_xlatb14;
float u_xlat16;
float u_xlat21;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat7.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat7.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat7.x = min(max(u_xlat7.x, 0.0), 1.0);
#else
    u_xlat7.x = clamp(u_xlat7.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat3.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat10_4 = texture(_ShadowMapTexture, u_xlat3.xyz);
    u_xlat14 = dot(u_xlat10_4, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat21 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat16 = sqrt(u_xlat21);
    u_xlat16 = u_xlat16 * _LightPositionRange.w;
    u_xlat16 = u_xlat16 * _LightProjectionParams.w;
#ifdef UNITY_ADRENO_ES3
    u_xlatb14 = !!(u_xlat14<u_xlat16);
#else
    u_xlatb14 = u_xlat14<u_xlat16;
#endif
    u_xlat16_5.x = (u_xlatb14) ? _LightShadowData.x : 1.0;
    u_xlat16_5.x = u_xlat7.x + u_xlat16_5.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat7.x = u_xlat21 * _LightPos.w;
    u_xlat14 = inversesqrt(u_xlat21);
    u_xlat3.xyz = vec3(u_xlat14) * u_xlat3.xyz;
    u_xlat7.x = texture(_LightTextureB0, u_xlat7.xx).w;
    u_xlat7.x = u_xlat16_5.x * u_xlat7.x;
    u_xlat4.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat4.xyz;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat4.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat4.xyz = u_xlat4.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat14 = texture(_LightTexture0, u_xlat4.xyz, -8.0).w;
    u_xlat7.x = u_xlat14 * u_xlat7.x;
    u_xlat14 = u_xlat7.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat2.xyz = (-u_xlat2.xyz) * vec3(u_xlat21) + (-u_xlat3.xyz);
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat2.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat2.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot((-u_xlat3.xyz), u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat7.x = u_xlat7.x * u_xlat16_5.x;
    u_xlat1.xyz = u_xlat7.xxx * _LightColor.xyz;
    u_xlat16_5.x = max(u_xlat16_6, 0.0);
    u_xlat16_5.x = log2(u_xlat16_5.x);
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_26;
    u_xlat16_5.x = exp2(u_xlat16_5.x);
    u_xlat7.x = u_xlat14 * u_xlat16_5.x;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat7.x * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = exp2((-u_xlat0));
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
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
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w)));
  atten_6 = tmpvar_15.w;
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  highp vec4 shadowVals_18;
  highp float mydist_19;
  mydist_19 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_20;
  tmpvar_20.w = 0.0;
  tmpvar_20.xyz = (tmpvar_13 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_20.xyz, 0.0);
  tmpvar_21 = tmpvar_22;
  shadowVals_18.x = dot (tmpvar_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_23;
  tmpvar_23.w = 0.0;
  tmpvar_23.xyz = (tmpvar_13 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_23.xyz, 0.0);
  tmpvar_24 = tmpvar_25;
  shadowVals_18.y = dot (tmpvar_24, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_26;
  tmpvar_26.w = 0.0;
  tmpvar_26.xyz = (tmpvar_13 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_26.xyz, 0.0);
  tmpvar_27 = tmpvar_28;
  shadowVals_18.z = dot (tmpvar_27, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_29;
  tmpvar_29.w = 0.0;
  tmpvar_29.xyz = (tmpvar_13 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_30;
  lowp vec4 tmpvar_31;
  tmpvar_31 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_29.xyz, 0.0);
  tmpvar_30 = tmpvar_31;
  shadowVals_18.w = dot (tmpvar_30, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_32;
  tmpvar_32 = lessThan (shadowVals_18, vec4(mydist_19));
  mediump vec4 tmpvar_33;
  tmpvar_33 = _LightShadowData.xxxx;
  mediump float tmpvar_34;
  if (tmpvar_32.x) {
    tmpvar_34 = tmpvar_33.x;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_32.y) {
    tmpvar_35 = tmpvar_33.y;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump float tmpvar_36;
  if (tmpvar_32.z) {
    tmpvar_36 = tmpvar_33.z;
  } else {
    tmpvar_36 = 1.0;
  };
  mediump float tmpvar_37;
  if (tmpvar_32.w) {
    tmpvar_37 = tmpvar_33.w;
  } else {
    tmpvar_37 = 1.0;
  };
  mediump vec4 tmpvar_38;
  tmpvar_38.x = tmpvar_34;
  tmpvar_38.y = tmpvar_35;
  tmpvar_38.z = tmpvar_36;
  tmpvar_38.w = tmpvar_37;
  mediump float tmpvar_39;
  tmpvar_39 = clamp ((dot (tmpvar_38, vec4(0.25, 0.25, 0.25, 0.25)) + tmpvar_16), 0.0, 1.0);
  atten_6 = (tmpvar_15.w * tmpvar_39);
  highp vec4 tmpvar_40;
  tmpvar_40.w = 1.0;
  tmpvar_40.xyz = tmpvar_10;
  highp vec4 tmpvar_41;
  tmpvar_41.w = -8.0;
  tmpvar_41.xyz = (unity_WorldToLight * tmpvar_40).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_41.xyz, -8.0).w);
  lowp vec4 tmpvar_42;
  highp vec2 P_43;
  P_43 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_42 = texture2D (_CameraNormalsTexture, P_43);
  nspec_5 = tmpvar_42;
  mediump vec3 tmpvar_44;
  tmpvar_44 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_45;
  tmpvar_45 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_45;
  mediump float tmpvar_46;
  tmpvar_46 = pow (max (0.0, dot (h_4, tmpvar_44)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_46;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_44)
  ) * atten_6));
  mediump vec3 rgb_47;
  rgb_47 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_47, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_48;
  tmpvar_48 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_48);
  mediump vec4 tmpvar_49;
  tmpvar_49 = exp2(-(res_2));
  tmpvar_1 = tmpvar_49;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
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
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w)));
  atten_6 = tmpvar_15.w;
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  highp vec4 shadowVals_18;
  highp float mydist_19;
  mydist_19 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_20;
  tmpvar_20.w = 0.0;
  tmpvar_20.xyz = (tmpvar_13 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_20.xyz, 0.0);
  tmpvar_21 = tmpvar_22;
  shadowVals_18.x = dot (tmpvar_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_23;
  tmpvar_23.w = 0.0;
  tmpvar_23.xyz = (tmpvar_13 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_23.xyz, 0.0);
  tmpvar_24 = tmpvar_25;
  shadowVals_18.y = dot (tmpvar_24, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_26;
  tmpvar_26.w = 0.0;
  tmpvar_26.xyz = (tmpvar_13 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_26.xyz, 0.0);
  tmpvar_27 = tmpvar_28;
  shadowVals_18.z = dot (tmpvar_27, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_29;
  tmpvar_29.w = 0.0;
  tmpvar_29.xyz = (tmpvar_13 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_30;
  lowp vec4 tmpvar_31;
  tmpvar_31 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_29.xyz, 0.0);
  tmpvar_30 = tmpvar_31;
  shadowVals_18.w = dot (tmpvar_30, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_32;
  tmpvar_32 = lessThan (shadowVals_18, vec4(mydist_19));
  mediump vec4 tmpvar_33;
  tmpvar_33 = _LightShadowData.xxxx;
  mediump float tmpvar_34;
  if (tmpvar_32.x) {
    tmpvar_34 = tmpvar_33.x;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_32.y) {
    tmpvar_35 = tmpvar_33.y;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump float tmpvar_36;
  if (tmpvar_32.z) {
    tmpvar_36 = tmpvar_33.z;
  } else {
    tmpvar_36 = 1.0;
  };
  mediump float tmpvar_37;
  if (tmpvar_32.w) {
    tmpvar_37 = tmpvar_33.w;
  } else {
    tmpvar_37 = 1.0;
  };
  mediump vec4 tmpvar_38;
  tmpvar_38.x = tmpvar_34;
  tmpvar_38.y = tmpvar_35;
  tmpvar_38.z = tmpvar_36;
  tmpvar_38.w = tmpvar_37;
  mediump float tmpvar_39;
  tmpvar_39 = clamp ((dot (tmpvar_38, vec4(0.25, 0.25, 0.25, 0.25)) + tmpvar_16), 0.0, 1.0);
  atten_6 = (tmpvar_15.w * tmpvar_39);
  highp vec4 tmpvar_40;
  tmpvar_40.w = 1.0;
  tmpvar_40.xyz = tmpvar_10;
  highp vec4 tmpvar_41;
  tmpvar_41.w = -8.0;
  tmpvar_41.xyz = (unity_WorldToLight * tmpvar_40).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_41.xyz, -8.0).w);
  lowp vec4 tmpvar_42;
  highp vec2 P_43;
  P_43 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_42 = texture2D (_CameraNormalsTexture, P_43);
  nspec_5 = tmpvar_42;
  mediump vec3 tmpvar_44;
  tmpvar_44 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_45;
  tmpvar_45 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_45;
  mediump float tmpvar_46;
  tmpvar_46 = pow (max (0.0, dot (h_4, tmpvar_44)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_46;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_44)
  ) * atten_6));
  mediump vec3 rgb_47;
  rgb_47 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_47, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_48;
  tmpvar_48 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_48);
  mediump vec4 tmpvar_49;
  tmpvar_49 = exp2(-(res_2));
  tmpvar_1 = tmpvar_49;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
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
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w)));
  atten_6 = tmpvar_15.w;
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  highp vec4 shadowVals_18;
  highp float mydist_19;
  mydist_19 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_20;
  tmpvar_20.w = 0.0;
  tmpvar_20.xyz = (tmpvar_13 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_20.xyz, 0.0);
  tmpvar_21 = tmpvar_22;
  shadowVals_18.x = dot (tmpvar_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_23;
  tmpvar_23.w = 0.0;
  tmpvar_23.xyz = (tmpvar_13 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_23.xyz, 0.0);
  tmpvar_24 = tmpvar_25;
  shadowVals_18.y = dot (tmpvar_24, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_26;
  tmpvar_26.w = 0.0;
  tmpvar_26.xyz = (tmpvar_13 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_26.xyz, 0.0);
  tmpvar_27 = tmpvar_28;
  shadowVals_18.z = dot (tmpvar_27, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_29;
  tmpvar_29.w = 0.0;
  tmpvar_29.xyz = (tmpvar_13 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_30;
  lowp vec4 tmpvar_31;
  tmpvar_31 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_29.xyz, 0.0);
  tmpvar_30 = tmpvar_31;
  shadowVals_18.w = dot (tmpvar_30, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_32;
  tmpvar_32 = lessThan (shadowVals_18, vec4(mydist_19));
  mediump vec4 tmpvar_33;
  tmpvar_33 = _LightShadowData.xxxx;
  mediump float tmpvar_34;
  if (tmpvar_32.x) {
    tmpvar_34 = tmpvar_33.x;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_32.y) {
    tmpvar_35 = tmpvar_33.y;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump float tmpvar_36;
  if (tmpvar_32.z) {
    tmpvar_36 = tmpvar_33.z;
  } else {
    tmpvar_36 = 1.0;
  };
  mediump float tmpvar_37;
  if (tmpvar_32.w) {
    tmpvar_37 = tmpvar_33.w;
  } else {
    tmpvar_37 = 1.0;
  };
  mediump vec4 tmpvar_38;
  tmpvar_38.x = tmpvar_34;
  tmpvar_38.y = tmpvar_35;
  tmpvar_38.z = tmpvar_36;
  tmpvar_38.w = tmpvar_37;
  mediump float tmpvar_39;
  tmpvar_39 = clamp ((dot (tmpvar_38, vec4(0.25, 0.25, 0.25, 0.25)) + tmpvar_16), 0.0, 1.0);
  atten_6 = (tmpvar_15.w * tmpvar_39);
  highp vec4 tmpvar_40;
  tmpvar_40.w = 1.0;
  tmpvar_40.xyz = tmpvar_10;
  highp vec4 tmpvar_41;
  tmpvar_41.w = -8.0;
  tmpvar_41.xyz = (unity_WorldToLight * tmpvar_40).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_41.xyz, -8.0).w);
  lowp vec4 tmpvar_42;
  highp vec2 P_43;
  P_43 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_42 = texture2D (_CameraNormalsTexture, P_43);
  nspec_5 = tmpvar_42;
  mediump vec3 tmpvar_44;
  tmpvar_44 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_45;
  tmpvar_45 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_45;
  mediump float tmpvar_46;
  tmpvar_46 = pow (max (0.0, dot (h_4, tmpvar_44)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_46;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_44)
  ) * atten_6));
  mediump vec3 rgb_47;
  rgb_47 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_47, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_48;
  tmpvar_48 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_48);
  mediump vec4 tmpvar_49;
  tmpvar_49 = exp2(-(res_2));
  tmpvar_1 = tmpvar_49;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
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
uniform 	vec4 _LightPositionRange;
uniform 	vec4 _LightProjectionParams;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec4 u_xlat4;
lowp vec4 u_xlat10_4;
bvec4 u_xlatb4;
vec3 u_xlat5;
lowp vec4 u_xlat10_5;
mediump vec3 u_xlat16_6;
mediump float u_xlat16_7;
vec3 u_xlat8;
float u_xlat16;
float u_xlat24;
mediump float u_xlat16_30;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat16 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat16 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat8.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat8.xyz = u_xlat8.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat8.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat4.xyz = u_xlat3.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
    u_xlat10_4 = textureLod(_ShadowMapTexture, u_xlat4.xyz, 0.0);
    u_xlat4.x = dot(u_xlat10_4, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat5.xyz = u_xlat3.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
    u_xlat10_5 = textureLod(_ShadowMapTexture, u_xlat5.xyz, 0.0);
    u_xlat4.y = dot(u_xlat10_5, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat5.xyz = u_xlat3.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
    u_xlat10_5 = textureLod(_ShadowMapTexture, u_xlat5.xyz, 0.0);
    u_xlat4.z = dot(u_xlat10_5, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat5.xyz = u_xlat3.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
    u_xlat10_5 = textureLod(_ShadowMapTexture, u_xlat5.xyz, 0.0);
    u_xlat4.w = dot(u_xlat10_5, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat8.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat16 = sqrt(u_xlat8.x);
    u_xlat16 = u_xlat16 * _LightPositionRange.w;
    u_xlat16 = u_xlat16 * _LightProjectionParams.w;
    u_xlatb4 = lessThan(u_xlat4, vec4(u_xlat16));
    u_xlat4.x = (u_xlatb4.x) ? _LightShadowData.x : float(1.0);
    u_xlat4.y = (u_xlatb4.y) ? _LightShadowData.x : float(1.0);
    u_xlat4.z = (u_xlatb4.z) ? _LightShadowData.x : float(1.0);
    u_xlat4.w = (u_xlatb4.w) ? _LightShadowData.x : float(1.0);
    u_xlat16_6.x = dot(u_xlat4, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat4.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat16 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat16 = sqrt(u_xlat16);
    u_xlat0.x = (-u_xlat8.z) * u_xlat0.x + u_xlat16;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat16 = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat16 = min(max(u_xlat16, 0.0), 1.0);
#else
    u_xlat16 = clamp(u_xlat16, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat16_6.x = u_xlat16 + u_xlat16_6.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_6.x = min(max(u_xlat16_6.x, 0.0), 1.0);
#else
    u_xlat16_6.x = clamp(u_xlat16_6.x, 0.0, 1.0);
#endif
    u_xlat16 = u_xlat8.x * _LightPos.w;
    u_xlat8.x = inversesqrt(u_xlat8.x);
    u_xlat3.xyz = u_xlat8.xxx * u_xlat3.xyz;
    u_xlat8.x = texture(_LightTextureB0, vec2(u_xlat16)).w;
    u_xlat8.x = u_xlat16_6.x * u_xlat8.x;
    u_xlat4.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat4.xyz;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat4.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat4.xyz = u_xlat4.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat16 = texture(_LightTexture0, u_xlat4.xyz, -8.0).w;
    u_xlat8.x = u_xlat16 * u_xlat8.x;
    u_xlat16 = u_xlat8.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16 = min(max(u_xlat16, 0.0), 1.0);
#else
    u_xlat16 = clamp(u_xlat16, 0.0, 1.0);
#endif
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = (-u_xlat2.xyz) * vec3(u_xlat24) + (-u_xlat3.xyz);
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat2.xyz;
    u_xlat16_6.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_30 = u_xlat10_1.w * 128.0;
    u_xlat16_7 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_7 = inversesqrt(u_xlat16_7);
    u_xlat16_6.xyz = u_xlat16_6.xyz * vec3(u_xlat16_7);
    u_xlat16_7 = dot(u_xlat2.xyz, u_xlat16_6.xyz);
    u_xlat16_6.x = dot((-u_xlat3.xyz), u_xlat16_6.xyz);
    u_xlat16_6.x = max(u_xlat16_6.x, 0.0);
    u_xlat8.x = u_xlat8.x * u_xlat16_6.x;
    u_xlat1.xyz = u_xlat8.xxx * _LightColor.xyz;
    u_xlat16_6.x = max(u_xlat16_7, 0.0);
    u_xlat16_6.x = log2(u_xlat16_6.x);
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_30;
    u_xlat16_6.x = exp2(u_xlat16_6.x);
    u_xlat8.x = u_xlat16 * u_xlat16_6.x;
    u_xlat16_6.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat8.x * u_xlat16_6.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = exp2((-u_xlat0));
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
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
uniform 	vec4 _LightPositionRange;
uniform 	vec4 _LightProjectionParams;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec4 u_xlat4;
lowp vec4 u_xlat10_4;
bvec4 u_xlatb4;
vec3 u_xlat5;
lowp vec4 u_xlat10_5;
mediump vec3 u_xlat16_6;
mediump float u_xlat16_7;
vec3 u_xlat8;
float u_xlat16;
float u_xlat24;
mediump float u_xlat16_30;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat16 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat16 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat8.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat8.xyz = u_xlat8.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat8.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat4.xyz = u_xlat3.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
    u_xlat10_4 = textureLod(_ShadowMapTexture, u_xlat4.xyz, 0.0);
    u_xlat4.x = dot(u_xlat10_4, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat5.xyz = u_xlat3.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
    u_xlat10_5 = textureLod(_ShadowMapTexture, u_xlat5.xyz, 0.0);
    u_xlat4.y = dot(u_xlat10_5, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat5.xyz = u_xlat3.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
    u_xlat10_5 = textureLod(_ShadowMapTexture, u_xlat5.xyz, 0.0);
    u_xlat4.z = dot(u_xlat10_5, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat5.xyz = u_xlat3.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
    u_xlat10_5 = textureLod(_ShadowMapTexture, u_xlat5.xyz, 0.0);
    u_xlat4.w = dot(u_xlat10_5, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat8.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat16 = sqrt(u_xlat8.x);
    u_xlat16 = u_xlat16 * _LightPositionRange.w;
    u_xlat16 = u_xlat16 * _LightProjectionParams.w;
    u_xlatb4 = lessThan(u_xlat4, vec4(u_xlat16));
    u_xlat4.x = (u_xlatb4.x) ? _LightShadowData.x : float(1.0);
    u_xlat4.y = (u_xlatb4.y) ? _LightShadowData.x : float(1.0);
    u_xlat4.z = (u_xlatb4.z) ? _LightShadowData.x : float(1.0);
    u_xlat4.w = (u_xlatb4.w) ? _LightShadowData.x : float(1.0);
    u_xlat16_6.x = dot(u_xlat4, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat4.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat16 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat16 = sqrt(u_xlat16);
    u_xlat0.x = (-u_xlat8.z) * u_xlat0.x + u_xlat16;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat16 = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat16 = min(max(u_xlat16, 0.0), 1.0);
#else
    u_xlat16 = clamp(u_xlat16, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat16_6.x = u_xlat16 + u_xlat16_6.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_6.x = min(max(u_xlat16_6.x, 0.0), 1.0);
#else
    u_xlat16_6.x = clamp(u_xlat16_6.x, 0.0, 1.0);
#endif
    u_xlat16 = u_xlat8.x * _LightPos.w;
    u_xlat8.x = inversesqrt(u_xlat8.x);
    u_xlat3.xyz = u_xlat8.xxx * u_xlat3.xyz;
    u_xlat8.x = texture(_LightTextureB0, vec2(u_xlat16)).w;
    u_xlat8.x = u_xlat16_6.x * u_xlat8.x;
    u_xlat4.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat4.xyz;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat4.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat4.xyz = u_xlat4.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat16 = texture(_LightTexture0, u_xlat4.xyz, -8.0).w;
    u_xlat8.x = u_xlat16 * u_xlat8.x;
    u_xlat16 = u_xlat8.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16 = min(max(u_xlat16, 0.0), 1.0);
#else
    u_xlat16 = clamp(u_xlat16, 0.0, 1.0);
#endif
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = (-u_xlat2.xyz) * vec3(u_xlat24) + (-u_xlat3.xyz);
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat2.xyz;
    u_xlat16_6.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_30 = u_xlat10_1.w * 128.0;
    u_xlat16_7 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_7 = inversesqrt(u_xlat16_7);
    u_xlat16_6.xyz = u_xlat16_6.xyz * vec3(u_xlat16_7);
    u_xlat16_7 = dot(u_xlat2.xyz, u_xlat16_6.xyz);
    u_xlat16_6.x = dot((-u_xlat3.xyz), u_xlat16_6.xyz);
    u_xlat16_6.x = max(u_xlat16_6.x, 0.0);
    u_xlat8.x = u_xlat8.x * u_xlat16_6.x;
    u_xlat1.xyz = u_xlat8.xxx * _LightColor.xyz;
    u_xlat16_6.x = max(u_xlat16_7, 0.0);
    u_xlat16_6.x = log2(u_xlat16_6.x);
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_30;
    u_xlat16_6.x = exp2(u_xlat16_6.x);
    u_xlat8.x = u_xlat16 * u_xlat16_6.x;
    u_xlat16_6.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat8.x * u_xlat16_6.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = exp2((-u_xlat0));
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
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
uniform 	vec4 _LightPositionRange;
uniform 	vec4 _LightProjectionParams;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec4 u_xlat4;
lowp vec4 u_xlat10_4;
bvec4 u_xlatb4;
vec3 u_xlat5;
lowp vec4 u_xlat10_5;
mediump vec3 u_xlat16_6;
mediump float u_xlat16_7;
vec3 u_xlat8;
float u_xlat16;
float u_xlat24;
mediump float u_xlat16_30;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat16 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat16 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat8.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat8.xyz = u_xlat8.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat8.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat4.xyz = u_xlat3.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
    u_xlat10_4 = textureLod(_ShadowMapTexture, u_xlat4.xyz, 0.0);
    u_xlat4.x = dot(u_xlat10_4, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat5.xyz = u_xlat3.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
    u_xlat10_5 = textureLod(_ShadowMapTexture, u_xlat5.xyz, 0.0);
    u_xlat4.y = dot(u_xlat10_5, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat5.xyz = u_xlat3.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
    u_xlat10_5 = textureLod(_ShadowMapTexture, u_xlat5.xyz, 0.0);
    u_xlat4.z = dot(u_xlat10_5, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat5.xyz = u_xlat3.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
    u_xlat10_5 = textureLod(_ShadowMapTexture, u_xlat5.xyz, 0.0);
    u_xlat4.w = dot(u_xlat10_5, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat8.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat16 = sqrt(u_xlat8.x);
    u_xlat16 = u_xlat16 * _LightPositionRange.w;
    u_xlat16 = u_xlat16 * _LightProjectionParams.w;
    u_xlatb4 = lessThan(u_xlat4, vec4(u_xlat16));
    u_xlat4.x = (u_xlatb4.x) ? _LightShadowData.x : float(1.0);
    u_xlat4.y = (u_xlatb4.y) ? _LightShadowData.x : float(1.0);
    u_xlat4.z = (u_xlatb4.z) ? _LightShadowData.x : float(1.0);
    u_xlat4.w = (u_xlatb4.w) ? _LightShadowData.x : float(1.0);
    u_xlat16_6.x = dot(u_xlat4, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat4.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat16 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat16 = sqrt(u_xlat16);
    u_xlat0.x = (-u_xlat8.z) * u_xlat0.x + u_xlat16;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat16 = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat16 = min(max(u_xlat16, 0.0), 1.0);
#else
    u_xlat16 = clamp(u_xlat16, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat16_6.x = u_xlat16 + u_xlat16_6.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_6.x = min(max(u_xlat16_6.x, 0.0), 1.0);
#else
    u_xlat16_6.x = clamp(u_xlat16_6.x, 0.0, 1.0);
#endif
    u_xlat16 = u_xlat8.x * _LightPos.w;
    u_xlat8.x = inversesqrt(u_xlat8.x);
    u_xlat3.xyz = u_xlat8.xxx * u_xlat3.xyz;
    u_xlat8.x = texture(_LightTextureB0, vec2(u_xlat16)).w;
    u_xlat8.x = u_xlat16_6.x * u_xlat8.x;
    u_xlat4.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat4.xyz;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat4.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat4.xyz = u_xlat4.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat16 = texture(_LightTexture0, u_xlat4.xyz, -8.0).w;
    u_xlat8.x = u_xlat16 * u_xlat8.x;
    u_xlat16 = u_xlat8.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16 = min(max(u_xlat16, 0.0), 1.0);
#else
    u_xlat16 = clamp(u_xlat16, 0.0, 1.0);
#endif
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = (-u_xlat2.xyz) * vec3(u_xlat24) + (-u_xlat3.xyz);
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat2.xyz;
    u_xlat16_6.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_30 = u_xlat10_1.w * 128.0;
    u_xlat16_7 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_7 = inversesqrt(u_xlat16_7);
    u_xlat16_6.xyz = u_xlat16_6.xyz * vec3(u_xlat16_7);
    u_xlat16_7 = dot(u_xlat2.xyz, u_xlat16_6.xyz);
    u_xlat16_6.x = dot((-u_xlat3.xyz), u_xlat16_6.xyz);
    u_xlat16_6.x = max(u_xlat16_6.x, 0.0);
    u_xlat8.x = u_xlat8.x * u_xlat16_6.x;
    u_xlat1.xyz = u_xlat8.xxx * _LightColor.xyz;
    u_xlat16_6.x = max(u_xlat16_7, 0.0);
    u_xlat16_6.x = log2(u_xlat16_6.x);
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_30;
    u_xlat16_6.x = exp2(u_xlat16_6.x);
    u_xlat8.x = u_xlat16 * u_xlat16_6.x;
    u_xlat16_6.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat8.x * u_xlat16_6.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = exp2((-u_xlat0));
    return;
}

#endif
"
}
}
Program "fp" {
SubProgram "gles hw_tier00 " {
Keywords { "POINT" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "POINT" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "DIRECTIONAL" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "DIRECTIONAL" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "DIRECTIONAL" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "DIRECTIONAL" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "SPOT" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "SPOT" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "SPOT" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SPOT" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SPOT" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SPOT" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT_COOKIE" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT_COOKIE" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT_COOKIE" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "POINT_COOKIE" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT_COOKIE" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT_COOKIE" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "DIRECTIONAL_COOKIE" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "DIRECTIONAL_COOKIE" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT" "SHADOWS_CUBE" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "POINT" "SHADOWS_CUBE" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
}
}
 Pass {
  Tags { "SHADOWSUPPORT" = "true" }
  ZWrite Off
  GpuProgramID 127399
Program "vp" {
SubProgram "gles hw_tier00 " {
Keywords { "POINT" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp sampler2D _LightTextureB0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(normalize(tmpvar_12));
  lightDir_7 = tmpvar_13;
  atten_6 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w))).w;
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_14 = texture2D (_CameraNormalsTexture, P_15);
  nspec_5 = tmpvar_14;
  mediump vec3 tmpvar_16;
  tmpvar_16 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_17;
  tmpvar_17 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = pow (max (0.0, dot (h_4, tmpvar_16)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_18;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_16)
  ) * atten_6));
  mediump vec3 rgb_19;
  rgb_19 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_19, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_20;
  tmpvar_20 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_20);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp sampler2D _LightTextureB0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(normalize(tmpvar_12));
  lightDir_7 = tmpvar_13;
  atten_6 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w))).w;
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_14 = texture2D (_CameraNormalsTexture, P_15);
  nspec_5 = tmpvar_14;
  mediump vec3 tmpvar_16;
  tmpvar_16 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_17;
  tmpvar_17 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = pow (max (0.0, dot (h_4, tmpvar_16)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_18;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_16)
  ) * atten_6));
  mediump vec3 rgb_19;
  rgb_19 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_19, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_20;
  tmpvar_20 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_20);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp sampler2D _LightTextureB0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(normalize(tmpvar_12));
  lightDir_7 = tmpvar_13;
  atten_6 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w))).w;
  lowp vec4 tmpvar_14;
  highp vec2 P_15;
  P_15 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_14 = texture2D (_CameraNormalsTexture, P_15);
  nspec_5 = tmpvar_14;
  mediump vec3 tmpvar_16;
  tmpvar_16 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_17;
  tmpvar_17 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_17;
  mediump float tmpvar_18;
  tmpvar_18 = pow (max (0.0, dot (h_4, tmpvar_16)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_18;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_16)
  ) * atten_6));
  mediump vec3 rgb_19;
  rgb_19 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_19, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_20;
  tmpvar_20 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_20);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "POINT" }
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec3 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
float u_xlat14;
float u_xlat21;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat4.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat14 = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat14 = sqrt(u_xlat14);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat14;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat21 = inversesqrt(u_xlat14);
    u_xlat14 = u_xlat14 * _LightPos.w;
    u_xlat14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat4.xyz;
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat7.xxx + (-u_xlat2.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat3.xyz = u_xlat7.xxx * u_xlat3.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat3.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot((-u_xlat2.xyz), u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat7.x = u_xlat14 * u_xlat16_5.x;
    u_xlat14 = u_xlat14;
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat1.xyz = u_xlat7.xxx * _LightColor.xyz;
    u_xlat16_5.x = max(u_xlat16_6, 0.0);
    u_xlat16_5.x = log2(u_xlat16_5.x);
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_26;
    u_xlat16_5.x = exp2(u_xlat16_5.x);
    u_xlat7.x = u_xlat14 * u_xlat16_5.x;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat7.x * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT" }
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec3 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
float u_xlat14;
float u_xlat21;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat4.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat14 = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat14 = sqrt(u_xlat14);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat14;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat21 = inversesqrt(u_xlat14);
    u_xlat14 = u_xlat14 * _LightPos.w;
    u_xlat14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat4.xyz;
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat7.xxx + (-u_xlat2.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat3.xyz = u_xlat7.xxx * u_xlat3.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat3.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot((-u_xlat2.xyz), u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat7.x = u_xlat14 * u_xlat16_5.x;
    u_xlat14 = u_xlat14;
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat1.xyz = u_xlat7.xxx * _LightColor.xyz;
    u_xlat16_5.x = max(u_xlat16_6, 0.0);
    u_xlat16_5.x = log2(u_xlat16_5.x);
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_26;
    u_xlat16_5.x = exp2(u_xlat16_5.x);
    u_xlat7.x = u_xlat14 * u_xlat16_5.x;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat7.x * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT" }
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec3 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
float u_xlat14;
float u_xlat21;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat4.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat14 = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat14 = sqrt(u_xlat14);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat14;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat21 = inversesqrt(u_xlat14);
    u_xlat14 = u_xlat14 * _LightPos.w;
    u_xlat14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat4.xyz;
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat7.xxx + (-u_xlat2.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat3.xyz = u_xlat7.xxx * u_xlat3.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat3.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot((-u_xlat2.xyz), u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat7.x = u_xlat14 * u_xlat16_5.x;
    u_xlat14 = u_xlat14;
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat1.xyz = u_xlat7.xxx * _LightColor.xyz;
    u_xlat16_5.x = max(u_xlat16_6, 0.0);
    u_xlat16_5.x = log2(u_xlat16_5.x);
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_26;
    u_xlat16_5.x = exp2(u_xlat16_5.x);
    u_xlat7.x = u_xlat14 * u_xlat16_5.x;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat7.x * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "DIRECTIONAL" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_11;
  lowp vec4 tmpvar_12;
  highp vec2 P_13;
  P_13 = ((tmpvar_7 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_12 = texture2D (_CameraNormalsTexture, P_13);
  nspec_5 = tmpvar_12;
  mediump vec3 tmpvar_14;
  tmpvar_14 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize((lightDir_6 - normalize(
    (tmpvar_9 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_15;
  mediump float tmpvar_16;
  tmpvar_16 = pow (max (0.0, dot (h_4, tmpvar_14)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_16;
  spec_3 = (spec_3 * clamp (1.0, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * max (0.0, dot (lightDir_6, tmpvar_14)));
  mediump vec3 rgb_17;
  rgb_17 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_17, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_18;
  tmpvar_18 = clamp ((1.0 - (
    (mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_18);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_11;
  lowp vec4 tmpvar_12;
  highp vec2 P_13;
  P_13 = ((tmpvar_7 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_12 = texture2D (_CameraNormalsTexture, P_13);
  nspec_5 = tmpvar_12;
  mediump vec3 tmpvar_14;
  tmpvar_14 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize((lightDir_6 - normalize(
    (tmpvar_9 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_15;
  mediump float tmpvar_16;
  tmpvar_16 = pow (max (0.0, dot (h_4, tmpvar_14)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_16;
  spec_3 = (spec_3 * clamp (1.0, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * max (0.0, dot (lightDir_6, tmpvar_14)));
  mediump vec3 rgb_17;
  rgb_17 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_17, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_18;
  tmpvar_18 = clamp ((1.0 - (
    (mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_18);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = (unity_CameraToWorld * tmpvar_8).xyz;
  highp vec3 tmpvar_10;
  tmpvar_10 = (tmpvar_9 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_11;
  lowp vec4 tmpvar_12;
  highp vec2 P_13;
  P_13 = ((tmpvar_7 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_12 = texture2D (_CameraNormalsTexture, P_13);
  nspec_5 = tmpvar_12;
  mediump vec3 tmpvar_14;
  tmpvar_14 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_15;
  tmpvar_15 = normalize((lightDir_6 - normalize(
    (tmpvar_9 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_15;
  mediump float tmpvar_16;
  tmpvar_16 = pow (max (0.0, dot (h_4, tmpvar_14)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_16;
  spec_3 = (spec_3 * clamp (1.0, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * max (0.0, dot (lightDir_6, tmpvar_14)));
  mediump vec3 rgb_17;
  rgb_17 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_17, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_18;
  tmpvar_18 = clamp ((1.0 - (
    (mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_18);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "DIRECTIONAL" }
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump float u_xlat16_5;
vec3 u_xlat6;
mediump float u_xlat16_10;
float u_xlat12;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat12 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat12 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat6.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat6.xyz = u_xlat6.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat6.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = sqrt(u_xlat6.x);
    u_xlat0.x = (-u_xlat6.z) * u_xlat0.x + u_xlat6.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat6.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat6.xyz = (-u_xlat2.xyw) * u_xlat6.xxx + (-_LightDir.xyz);
    u_xlat2.x = dot(u_xlat6.xyz, u_xlat6.xyz);
    u_xlat2.x = inversesqrt(u_xlat2.x);
    u_xlat6.xyz = u_xlat6.xyz * u_xlat2.xxx;
    u_xlat16_4.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = u_xlat10_1.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat6.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
    u_xlat16_4.x = max(u_xlat16_4.x, 0.0);
    u_xlat1.xyz = u_xlat16_4.xxx * _LightColor.xyz;
    u_xlat16_4.x = max(u_xlat16_5, 0.0);
    u_xlat16_4.x = log2(u_xlat16_4.x);
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_22;
    u_xlat16_4.x = exp2(u_xlat16_4.x);
    u_xlat16_10 = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_10 * u_xlat16_4.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "DIRECTIONAL" }
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump float u_xlat16_5;
vec3 u_xlat6;
mediump float u_xlat16_10;
float u_xlat12;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat12 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat12 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat6.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat6.xyz = u_xlat6.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat6.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = sqrt(u_xlat6.x);
    u_xlat0.x = (-u_xlat6.z) * u_xlat0.x + u_xlat6.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat6.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat6.xyz = (-u_xlat2.xyw) * u_xlat6.xxx + (-_LightDir.xyz);
    u_xlat2.x = dot(u_xlat6.xyz, u_xlat6.xyz);
    u_xlat2.x = inversesqrt(u_xlat2.x);
    u_xlat6.xyz = u_xlat6.xyz * u_xlat2.xxx;
    u_xlat16_4.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = u_xlat10_1.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat6.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
    u_xlat16_4.x = max(u_xlat16_4.x, 0.0);
    u_xlat1.xyz = u_xlat16_4.xxx * _LightColor.xyz;
    u_xlat16_4.x = max(u_xlat16_5, 0.0);
    u_xlat16_4.x = log2(u_xlat16_4.x);
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_22;
    u_xlat16_4.x = exp2(u_xlat16_4.x);
    u_xlat16_10 = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_10 * u_xlat16_4.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "DIRECTIONAL" }
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump float u_xlat16_5;
vec3 u_xlat6;
mediump float u_xlat16_10;
float u_xlat12;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat12 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat12 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat6.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat6.xyz = u_xlat6.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat6.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = sqrt(u_xlat6.x);
    u_xlat0.x = (-u_xlat6.z) * u_xlat0.x + u_xlat6.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat6.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat6.xyz = (-u_xlat2.xyw) * u_xlat6.xxx + (-_LightDir.xyz);
    u_xlat2.x = dot(u_xlat6.xyz, u_xlat6.xyz);
    u_xlat2.x = inversesqrt(u_xlat2.x);
    u_xlat6.xyz = u_xlat6.xyz * u_xlat2.xxx;
    u_xlat16_4.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = u_xlat10_1.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat6.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
    u_xlat16_4.x = max(u_xlat16_4.x, 0.0);
    u_xlat1.xyz = u_xlat16_4.xxx * _LightColor.xyz;
    u_xlat16_4.x = max(u_xlat16_5, 0.0);
    u_xlat16_4.x = log2(u_xlat16_4.x);
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_22;
    u_xlat16_4.x = exp2(u_xlat16_4.x);
    u_xlat16_10 = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_10 * u_xlat16_4.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "SPOT" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize(tmpvar_12);
  lightDir_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = tmpvar_10;
  highp vec4 tmpvar_15;
  tmpvar_15 = (unity_WorldToLight * tmpvar_14);
  highp vec4 tmpvar_16;
  tmpvar_16.zw = vec2(0.0, -8.0);
  tmpvar_16.xy = (tmpvar_15.xy / tmpvar_15.w);
  atten_6 = (texture2D (_LightTexture0, tmpvar_16.xy, -8.0).w * float((tmpvar_15.w < 0.0)));
  atten_6 = (atten_6 * texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w))).w);
  lowp vec4 tmpvar_17;
  highp vec2 P_18;
  P_18 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_17 = texture2D (_CameraNormalsTexture, P_18);
  nspec_5 = tmpvar_17;
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = pow (max (0.0, dot (h_4, tmpvar_19)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_21;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_19)
  ) * atten_6));
  mediump vec3 rgb_22;
  rgb_22 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_22, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_23;
  tmpvar_23 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_23);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "SPOT" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize(tmpvar_12);
  lightDir_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = tmpvar_10;
  highp vec4 tmpvar_15;
  tmpvar_15 = (unity_WorldToLight * tmpvar_14);
  highp vec4 tmpvar_16;
  tmpvar_16.zw = vec2(0.0, -8.0);
  tmpvar_16.xy = (tmpvar_15.xy / tmpvar_15.w);
  atten_6 = (texture2D (_LightTexture0, tmpvar_16.xy, -8.0).w * float((tmpvar_15.w < 0.0)));
  atten_6 = (atten_6 * texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w))).w);
  lowp vec4 tmpvar_17;
  highp vec2 P_18;
  P_18 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_17 = texture2D (_CameraNormalsTexture, P_18);
  nspec_5 = tmpvar_17;
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = pow (max (0.0, dot (h_4, tmpvar_19)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_21;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_19)
  ) * atten_6));
  mediump vec3 rgb_22;
  rgb_22 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_22, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_23;
  tmpvar_23 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_23);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "SPOT" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize(tmpvar_12);
  lightDir_7 = tmpvar_13;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = tmpvar_10;
  highp vec4 tmpvar_15;
  tmpvar_15 = (unity_WorldToLight * tmpvar_14);
  highp vec4 tmpvar_16;
  tmpvar_16.zw = vec2(0.0, -8.0);
  tmpvar_16.xy = (tmpvar_15.xy / tmpvar_15.w);
  atten_6 = (texture2D (_LightTexture0, tmpvar_16.xy, -8.0).w * float((tmpvar_15.w < 0.0)));
  atten_6 = (atten_6 * texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w))).w);
  lowp vec4 tmpvar_17;
  highp vec2 P_18;
  P_18 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_17 = texture2D (_CameraNormalsTexture, P_18);
  nspec_5 = tmpvar_17;
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_20;
  mediump float tmpvar_21;
  tmpvar_21 = pow (max (0.0, dot (h_4, tmpvar_19)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_21;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_19)
  ) * atten_6));
  mediump vec3 rgb_22;
  rgb_22 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_22, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_23;
  tmpvar_23 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_23);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SPOT" }
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
bool u_xlatb1;
vec4 u_xlat2;
vec3 u_xlat3;
vec3 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_12;
float u_xlat14;
float u_xlat24;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat4.xyz = (-u_xlat2.xyw) + _LightPos.xyz;
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat24 = inversesqrt(u_xlat14);
    u_xlat14 = u_xlat14 * _LightPos.w;
    u_xlat14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat4.xyz = vec3(u_xlat24) * u_xlat4.xyz;
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat7.xxx + u_xlat4.xyz;
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat3.xyz = u_xlat7.xxx * u_xlat3.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat3.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot(u_xlat4.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat16_12 = max(u_xlat16_6, 0.0);
    u_xlat16_12 = log2(u_xlat16_12);
    u_xlat16_12 = u_xlat16_12 * u_xlat16_26;
    u_xlat16_12 = exp2(u_xlat16_12);
    u_xlat1.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat2.xxx + u_xlat1.xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat2.www + u_xlat1.xyz;
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat7.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat7.xz = u_xlat1.xy / u_xlat1.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb1 = !!(u_xlat1.z<0.0);
#else
    u_xlatb1 = u_xlat1.z<0.0;
#endif
    u_xlat1.x = u_xlatb1 ? 1.0 : float(0.0);
    u_xlat7.x = texture(_LightTexture0, u_xlat7.xz, -8.0).w;
    u_xlat7.x = u_xlat1.x * u_xlat7.x;
    u_xlat7.x = u_xlat14 * u_xlat7.x;
    u_xlat14 = u_xlat7.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat7.x = u_xlat7.x * u_xlat16_5.x;
    u_xlat1.xyz = u_xlat7.xxx * _LightColor.xyz;
    u_xlat7.x = u_xlat14 * u_xlat16_12;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat7.x * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SPOT" }
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
bool u_xlatb1;
vec4 u_xlat2;
vec3 u_xlat3;
vec3 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_12;
float u_xlat14;
float u_xlat24;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat4.xyz = (-u_xlat2.xyw) + _LightPos.xyz;
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat24 = inversesqrt(u_xlat14);
    u_xlat14 = u_xlat14 * _LightPos.w;
    u_xlat14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat4.xyz = vec3(u_xlat24) * u_xlat4.xyz;
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat7.xxx + u_xlat4.xyz;
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat3.xyz = u_xlat7.xxx * u_xlat3.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat3.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot(u_xlat4.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat16_12 = max(u_xlat16_6, 0.0);
    u_xlat16_12 = log2(u_xlat16_12);
    u_xlat16_12 = u_xlat16_12 * u_xlat16_26;
    u_xlat16_12 = exp2(u_xlat16_12);
    u_xlat1.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat2.xxx + u_xlat1.xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat2.www + u_xlat1.xyz;
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat7.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat7.xz = u_xlat1.xy / u_xlat1.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb1 = !!(u_xlat1.z<0.0);
#else
    u_xlatb1 = u_xlat1.z<0.0;
#endif
    u_xlat1.x = u_xlatb1 ? 1.0 : float(0.0);
    u_xlat7.x = texture(_LightTexture0, u_xlat7.xz, -8.0).w;
    u_xlat7.x = u_xlat1.x * u_xlat7.x;
    u_xlat7.x = u_xlat14 * u_xlat7.x;
    u_xlat14 = u_xlat7.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat7.x = u_xlat7.x * u_xlat16_5.x;
    u_xlat1.xyz = u_xlat7.xxx * _LightColor.xyz;
    u_xlat7.x = u_xlat14 * u_xlat16_12;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat7.x * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SPOT" }
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
bool u_xlatb1;
vec4 u_xlat2;
vec3 u_xlat3;
vec3 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_12;
float u_xlat14;
float u_xlat24;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat4.xyz = (-u_xlat2.xyw) + _LightPos.xyz;
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat24 = inversesqrt(u_xlat14);
    u_xlat14 = u_xlat14 * _LightPos.w;
    u_xlat14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat4.xyz = vec3(u_xlat24) * u_xlat4.xyz;
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat7.xxx + u_xlat4.xyz;
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat3.xyz = u_xlat7.xxx * u_xlat3.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat3.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot(u_xlat4.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat16_12 = max(u_xlat16_6, 0.0);
    u_xlat16_12 = log2(u_xlat16_12);
    u_xlat16_12 = u_xlat16_12 * u_xlat16_26;
    u_xlat16_12 = exp2(u_xlat16_12);
    u_xlat1.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat2.xxx + u_xlat1.xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat2.www + u_xlat1.xyz;
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat7.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat7.xz = u_xlat1.xy / u_xlat1.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb1 = !!(u_xlat1.z<0.0);
#else
    u_xlatb1 = u_xlat1.z<0.0;
#endif
    u_xlat1.x = u_xlatb1 ? 1.0 : float(0.0);
    u_xlat7.x = texture(_LightTexture0, u_xlat7.xz, -8.0).w;
    u_xlat7.x = u_xlat1.x * u_xlat7.x;
    u_xlat7.x = u_xlat14 * u_xlat7.x;
    u_xlat14 = u_xlat7.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat7.x = u_xlat7.x * u_xlat16_5.x;
    u_xlat1.xyz = u_xlat7.xxx * _LightColor.xyz;
    u_xlat7.x = u_xlat14 * u_xlat16_12;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat7.x * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT_COOKIE" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(normalize(tmpvar_12));
  lightDir_7 = tmpvar_13;
  atten_6 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w))).w;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = tmpvar_10;
  highp vec4 tmpvar_15;
  tmpvar_15.w = -8.0;
  tmpvar_15.xyz = (unity_WorldToLight * tmpvar_14).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_15.xyz, -8.0).w);
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_16 = texture2D (_CameraNormalsTexture, P_17);
  nspec_5 = tmpvar_16;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = pow (max (0.0, dot (h_4, tmpvar_18)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_20;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_18)
  ) * atten_6));
  mediump vec3 rgb_21;
  rgb_21 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_21, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_22;
  tmpvar_22 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_22);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT_COOKIE" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(normalize(tmpvar_12));
  lightDir_7 = tmpvar_13;
  atten_6 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w))).w;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = tmpvar_10;
  highp vec4 tmpvar_15;
  tmpvar_15.w = -8.0;
  tmpvar_15.xyz = (unity_WorldToLight * tmpvar_14).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_15.xyz, -8.0).w);
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_16 = texture2D (_CameraNormalsTexture, P_17);
  nspec_5 = tmpvar_16;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = pow (max (0.0, dot (h_4, tmpvar_18)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_20;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_18)
  ) * atten_6));
  mediump vec3 rgb_21;
  rgb_21 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_21, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_22;
  tmpvar_22 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_22);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT_COOKIE" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(normalize(tmpvar_12));
  lightDir_7 = tmpvar_13;
  atten_6 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w))).w;
  highp vec4 tmpvar_14;
  tmpvar_14.w = 1.0;
  tmpvar_14.xyz = tmpvar_10;
  highp vec4 tmpvar_15;
  tmpvar_15.w = -8.0;
  tmpvar_15.xyz = (unity_WorldToLight * tmpvar_14).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_15.xyz, -8.0).w);
  lowp vec4 tmpvar_16;
  highp vec2 P_17;
  P_17 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_16 = texture2D (_CameraNormalsTexture, P_17);
  nspec_5 = tmpvar_16;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_19;
  mediump float tmpvar_20;
  tmpvar_20 = pow (max (0.0, dot (h_4, tmpvar_18)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_20;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_18)
  ) * atten_6));
  mediump vec3 rgb_21;
  rgb_21 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_21, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_22;
  tmpvar_22 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_22);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "POINT_COOKIE" }
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec3 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_12;
float u_xlat14;
float u_xlat24;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat4.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat24 = inversesqrt(u_xlat14);
    u_xlat14 = u_xlat14 * _LightPos.w;
    u_xlat14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat4.xyz = vec3(u_xlat24) * u_xlat4.xyz;
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat7.xxx + (-u_xlat4.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat3.xyz = u_xlat7.xxx * u_xlat3.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat3.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot((-u_xlat4.xyz), u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat16_12 = max(u_xlat16_6, 0.0);
    u_xlat16_12 = log2(u_xlat16_12);
    u_xlat16_12 = u_xlat16_12 * u_xlat16_26;
    u_xlat16_12 = exp2(u_xlat16_12);
    u_xlat1.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat1.xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat1.xyz;
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat7.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat7.x = texture(_LightTexture0, u_xlat1.xyz, -8.0).w;
    u_xlat7.x = u_xlat7.x * u_xlat14;
    u_xlat14 = u_xlat7.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat7.x = u_xlat7.x * u_xlat16_5.x;
    u_xlat1.xyz = u_xlat7.xxx * _LightColor.xyz;
    u_xlat7.x = u_xlat14 * u_xlat16_12;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat7.x * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT_COOKIE" }
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec3 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_12;
float u_xlat14;
float u_xlat24;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat4.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat24 = inversesqrt(u_xlat14);
    u_xlat14 = u_xlat14 * _LightPos.w;
    u_xlat14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat4.xyz = vec3(u_xlat24) * u_xlat4.xyz;
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat7.xxx + (-u_xlat4.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat3.xyz = u_xlat7.xxx * u_xlat3.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat3.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot((-u_xlat4.xyz), u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat16_12 = max(u_xlat16_6, 0.0);
    u_xlat16_12 = log2(u_xlat16_12);
    u_xlat16_12 = u_xlat16_12 * u_xlat16_26;
    u_xlat16_12 = exp2(u_xlat16_12);
    u_xlat1.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat1.xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat1.xyz;
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat7.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat7.x = texture(_LightTexture0, u_xlat1.xyz, -8.0).w;
    u_xlat7.x = u_xlat7.x * u_xlat14;
    u_xlat14 = u_xlat7.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat7.x = u_xlat7.x * u_xlat16_5.x;
    u_xlat1.xyz = u_xlat7.xxx * _LightColor.xyz;
    u_xlat7.x = u_xlat14 * u_xlat16_12;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat7.x * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT_COOKIE" }
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec3 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_12;
float u_xlat14;
float u_xlat24;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat4.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat24 = inversesqrt(u_xlat14);
    u_xlat14 = u_xlat14 * _LightPos.w;
    u_xlat14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat4.xyz = vec3(u_xlat24) * u_xlat4.xyz;
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat7.xxx + (-u_xlat4.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = inversesqrt(u_xlat7.x);
    u_xlat3.xyz = u_xlat7.xxx * u_xlat3.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat3.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot((-u_xlat4.xyz), u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat16_12 = max(u_xlat16_6, 0.0);
    u_xlat16_12 = log2(u_xlat16_12);
    u_xlat16_12 = u_xlat16_12 * u_xlat16_26;
    u_xlat16_12 = exp2(u_xlat16_12);
    u_xlat1.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat1.xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat1.xyz;
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat7.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat1.xyz = u_xlat1.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat7.x = texture(_LightTexture0, u_xlat1.xyz, -8.0).w;
    u_xlat7.x = u_xlat7.x * u_xlat14;
    u_xlat14 = u_xlat7.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat7.x = u_xlat7.x * u_xlat16_5.x;
    u_xlat1.xyz = u_xlat7.xxx * _LightColor.xyz;
    u_xlat7.x = u_xlat14 * u_xlat16_12;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat7.x * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "DIRECTIONAL_COOKIE" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_10;
  highp vec4 tmpvar_14;
  tmpvar_14.zw = vec2(0.0, -8.0);
  tmpvar_14.xy = (unity_WorldToLight * tmpvar_13).xy;
  atten_6 = texture2D (_LightTexture0, tmpvar_14.xy, -8.0).w;
  lowp vec4 tmpvar_15;
  highp vec2 P_16;
  P_16 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_15 = texture2D (_CameraNormalsTexture, P_16);
  nspec_5 = tmpvar_15;
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_18;
  mediump float tmpvar_19;
  tmpvar_19 = pow (max (0.0, dot (h_4, tmpvar_17)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_19;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_17)
  ) * atten_6));
  mediump vec3 rgb_20;
  rgb_20 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_20, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_21;
  tmpvar_21 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_21);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_10;
  highp vec4 tmpvar_14;
  tmpvar_14.zw = vec2(0.0, -8.0);
  tmpvar_14.xy = (unity_WorldToLight * tmpvar_13).xy;
  atten_6 = texture2D (_LightTexture0, tmpvar_14.xy, -8.0).w;
  lowp vec4 tmpvar_15;
  highp vec2 P_16;
  P_16 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_15 = texture2D (_CameraNormalsTexture, P_16);
  nspec_5 = tmpvar_15;
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_18;
  mediump float tmpvar_19;
  tmpvar_19 = pow (max (0.0, dot (h_4, tmpvar_17)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_19;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_17)
  ) * atten_6));
  mediump vec3 rgb_20;
  rgb_20 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_20, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_21;
  tmpvar_21 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_21);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_10;
  highp vec4 tmpvar_14;
  tmpvar_14.zw = vec2(0.0, -8.0);
  tmpvar_14.xy = (unity_WorldToLight * tmpvar_13).xy;
  atten_6 = texture2D (_LightTexture0, tmpvar_14.xy, -8.0).w;
  lowp vec4 tmpvar_15;
  highp vec2 P_16;
  P_16 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_15 = texture2D (_CameraNormalsTexture, P_16);
  nspec_5 = tmpvar_15;
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_18;
  mediump float tmpvar_19;
  tmpvar_19 = pow (max (0.0, dot (h_4, tmpvar_17)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_19;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_17)
  ) * atten_6));
  mediump vec3 rgb_20;
  rgb_20 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_20, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_21;
  tmpvar_21 = clamp ((1.0 - (
    (mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w) * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_21);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "DIRECTIONAL_COOKIE" }
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump float u_xlat16_5;
vec3 u_xlat6;
mediump float u_xlat16_10;
float u_xlat12;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat12 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat12 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat6.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat6.xyz = u_xlat6.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat6.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat6.xxx + (-_LightDir.xyz);
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat3.xyz = u_xlat6.xxx * u_xlat3.xyz;
    u_xlat16_4.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = u_xlat10_1.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat3.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
    u_xlat16_4.x = max(u_xlat16_4.x, 0.0);
    u_xlat16_10 = max(u_xlat16_5, 0.0);
    u_xlat16_10 = log2(u_xlat16_10);
    u_xlat16_10 = u_xlat16_10 * u_xlat16_22;
    u_xlat16_10 = exp2(u_xlat16_10);
    u_xlat6.xy = u_xlat2.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat6.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat2.xx + u_xlat6.xy;
    u_xlat6.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat2.ww + u_xlat6.xy;
    u_xlat1.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat1.x = dot(u_xlat1.xyz, u_xlat1.xyz);
    u_xlat1.x = sqrt(u_xlat1.x);
    u_xlat0.x = (-u_xlat6.z) * u_xlat0.x + u_xlat1.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat6.xy = u_xlat6.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat6.x = texture(_LightTexture0, u_xlat6.xy, -8.0).w;
    u_xlat12 = u_xlat6.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat12 = min(max(u_xlat12, 0.0), 1.0);
#else
    u_xlat12 = clamp(u_xlat12, 0.0, 1.0);
#endif
    u_xlat6.x = u_xlat6.x * u_xlat16_4.x;
    u_xlat1.xyz = u_xlat6.xxx * _LightColor.xyz;
    u_xlat6.x = u_xlat12 * u_xlat16_10;
    u_xlat16_4.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat6.x * u_xlat16_4.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" }
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump float u_xlat16_5;
vec3 u_xlat6;
mediump float u_xlat16_10;
float u_xlat12;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat12 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat12 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat6.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat6.xyz = u_xlat6.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat6.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat6.xxx + (-_LightDir.xyz);
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat3.xyz = u_xlat6.xxx * u_xlat3.xyz;
    u_xlat16_4.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = u_xlat10_1.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat3.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
    u_xlat16_4.x = max(u_xlat16_4.x, 0.0);
    u_xlat16_10 = max(u_xlat16_5, 0.0);
    u_xlat16_10 = log2(u_xlat16_10);
    u_xlat16_10 = u_xlat16_10 * u_xlat16_22;
    u_xlat16_10 = exp2(u_xlat16_10);
    u_xlat6.xy = u_xlat2.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat6.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat2.xx + u_xlat6.xy;
    u_xlat6.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat2.ww + u_xlat6.xy;
    u_xlat1.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat1.x = dot(u_xlat1.xyz, u_xlat1.xyz);
    u_xlat1.x = sqrt(u_xlat1.x);
    u_xlat0.x = (-u_xlat6.z) * u_xlat0.x + u_xlat1.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat6.xy = u_xlat6.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat6.x = texture(_LightTexture0, u_xlat6.xy, -8.0).w;
    u_xlat12 = u_xlat6.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat12 = min(max(u_xlat12, 0.0), 1.0);
#else
    u_xlat12 = clamp(u_xlat12, 0.0, 1.0);
#endif
    u_xlat6.x = u_xlat6.x * u_xlat16_4.x;
    u_xlat1.xyz = u_xlat6.xxx * _LightColor.xyz;
    u_xlat6.x = u_xlat12 * u_xlat16_10;
    u_xlat16_4.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat6.x * u_xlat16_4.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" }
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
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump float u_xlat16_5;
vec3 u_xlat6;
mediump float u_xlat16_10;
float u_xlat12;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat12 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat12 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat6.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat6.xyz = u_xlat6.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat6.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat3.xyz = (-u_xlat3.xyz) * u_xlat6.xxx + (-_LightDir.xyz);
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat3.xyz = u_xlat6.xxx * u_xlat3.xyz;
    u_xlat16_4.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = u_xlat10_1.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat3.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
    u_xlat16_4.x = max(u_xlat16_4.x, 0.0);
    u_xlat16_10 = max(u_xlat16_5, 0.0);
    u_xlat16_10 = log2(u_xlat16_10);
    u_xlat16_10 = u_xlat16_10 * u_xlat16_22;
    u_xlat16_10 = exp2(u_xlat16_10);
    u_xlat6.xy = u_xlat2.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat6.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat2.xx + u_xlat6.xy;
    u_xlat6.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat2.ww + u_xlat6.xy;
    u_xlat1.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat1.x = dot(u_xlat1.xyz, u_xlat1.xyz);
    u_xlat1.x = sqrt(u_xlat1.x);
    u_xlat0.x = (-u_xlat6.z) * u_xlat0.x + u_xlat1.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat6.xy = u_xlat6.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat6.x = texture(_LightTexture0, u_xlat6.xy, -8.0).w;
    u_xlat12 = u_xlat6.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat12 = min(max(u_xlat12, 0.0), 1.0);
#else
    u_xlat12 = clamp(u_xlat12, 0.0, 1.0);
#endif
    u_xlat6.x = u_xlat6.x * u_xlat16_4.x;
    u_xlat1.xyz = u_xlat6.xxx * _LightColor.xyz;
    u_xlat6.x = u_xlat12 * u_xlat16_10;
    u_xlat16_4.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat6.x * u_xlat16_4.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_13);
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  highp vec4 tmpvar_16;
  tmpvar_16 = (unity_WorldToLight * tmpvar_15);
  highp vec4 tmpvar_17;
  tmpvar_17.zw = vec2(0.0, -8.0);
  tmpvar_17.xy = (tmpvar_16.xy / tmpvar_16.w);
  atten_6 = (texture2D (_LightTexture0, tmpvar_17.xy, -8.0).w * float((tmpvar_16.w < 0.0)));
  atten_6 = (atten_6 * texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w))).w);
  mediump float tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_18 = tmpvar_19;
  mediump float shadowAttenuation_20;
  shadowAttenuation_20 = 1.0;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = tmpvar_10;
  highp vec4 tmpvar_22;
  tmpvar_22 = (unity_WorldToShadow[0] * tmpvar_21);
  lowp float tmpvar_23;
  highp vec4 tmpvar_24;
  tmpvar_24 = texture2DProj (_ShadowMapTexture, tmpvar_22);
  mediump float tmpvar_25;
  if ((tmpvar_24.x < (tmpvar_22.z / tmpvar_22.w))) {
    tmpvar_25 = _LightShadowData.x;
  } else {
    tmpvar_25 = 1.0;
  };
  tmpvar_23 = tmpvar_25;
  shadowAttenuation_20 = tmpvar_23;
  mediump float tmpvar_26;
  tmpvar_26 = clamp ((shadowAttenuation_20 + tmpvar_18), 0.0, 1.0);
  atten_6 = (atten_6 * tmpvar_26);
  lowp vec4 tmpvar_27;
  highp vec2 P_28;
  P_28 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_27 = texture2D (_CameraNormalsTexture, P_28);
  nspec_5 = tmpvar_27;
  mediump vec3 tmpvar_29;
  tmpvar_29 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_30;
  tmpvar_30 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = pow (max (0.0, dot (h_4, tmpvar_29)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_31;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_29)
  ) * atten_6));
  mediump vec3 rgb_32;
  rgb_32 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_32, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_33;
  tmpvar_33 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_33);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_13);
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  highp vec4 tmpvar_16;
  tmpvar_16 = (unity_WorldToLight * tmpvar_15);
  highp vec4 tmpvar_17;
  tmpvar_17.zw = vec2(0.0, -8.0);
  tmpvar_17.xy = (tmpvar_16.xy / tmpvar_16.w);
  atten_6 = (texture2D (_LightTexture0, tmpvar_17.xy, -8.0).w * float((tmpvar_16.w < 0.0)));
  atten_6 = (atten_6 * texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w))).w);
  mediump float tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_18 = tmpvar_19;
  mediump float shadowAttenuation_20;
  shadowAttenuation_20 = 1.0;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = tmpvar_10;
  highp vec4 tmpvar_22;
  tmpvar_22 = (unity_WorldToShadow[0] * tmpvar_21);
  lowp float tmpvar_23;
  highp vec4 tmpvar_24;
  tmpvar_24 = texture2DProj (_ShadowMapTexture, tmpvar_22);
  mediump float tmpvar_25;
  if ((tmpvar_24.x < (tmpvar_22.z / tmpvar_22.w))) {
    tmpvar_25 = _LightShadowData.x;
  } else {
    tmpvar_25 = 1.0;
  };
  tmpvar_23 = tmpvar_25;
  shadowAttenuation_20 = tmpvar_23;
  mediump float tmpvar_26;
  tmpvar_26 = clamp ((shadowAttenuation_20 + tmpvar_18), 0.0, 1.0);
  atten_6 = (atten_6 * tmpvar_26);
  lowp vec4 tmpvar_27;
  highp vec2 P_28;
  P_28 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_27 = texture2D (_CameraNormalsTexture, P_28);
  nspec_5 = tmpvar_27;
  mediump vec3 tmpvar_29;
  tmpvar_29 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_30;
  tmpvar_30 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = pow (max (0.0, dot (h_4, tmpvar_29)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_31;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_29)
  ) * atten_6));
  mediump vec3 rgb_32;
  rgb_32 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_32, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_33;
  tmpvar_33 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_33);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_13);
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  highp vec4 tmpvar_16;
  tmpvar_16 = (unity_WorldToLight * tmpvar_15);
  highp vec4 tmpvar_17;
  tmpvar_17.zw = vec2(0.0, -8.0);
  tmpvar_17.xy = (tmpvar_16.xy / tmpvar_16.w);
  atten_6 = (texture2D (_LightTexture0, tmpvar_17.xy, -8.0).w * float((tmpvar_16.w < 0.0)));
  atten_6 = (atten_6 * texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w))).w);
  mediump float tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_18 = tmpvar_19;
  mediump float shadowAttenuation_20;
  shadowAttenuation_20 = 1.0;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = tmpvar_10;
  highp vec4 tmpvar_22;
  tmpvar_22 = (unity_WorldToShadow[0] * tmpvar_21);
  lowp float tmpvar_23;
  highp vec4 tmpvar_24;
  tmpvar_24 = texture2DProj (_ShadowMapTexture, tmpvar_22);
  mediump float tmpvar_25;
  if ((tmpvar_24.x < (tmpvar_22.z / tmpvar_22.w))) {
    tmpvar_25 = _LightShadowData.x;
  } else {
    tmpvar_25 = 1.0;
  };
  tmpvar_23 = tmpvar_25;
  shadowAttenuation_20 = tmpvar_23;
  mediump float tmpvar_26;
  tmpvar_26 = clamp ((shadowAttenuation_20 + tmpvar_18), 0.0, 1.0);
  atten_6 = (atten_6 * tmpvar_26);
  lowp vec4 tmpvar_27;
  highp vec2 P_28;
  P_28 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_27 = texture2D (_CameraNormalsTexture, P_28);
  nspec_5 = tmpvar_27;
  mediump vec3 tmpvar_29;
  tmpvar_29 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_30;
  tmpvar_30 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = pow (max (0.0, dot (h_4, tmpvar_29)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_31;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_29)
  ) * atten_6));
  mediump vec3 rgb_32;
  rgb_32 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_32, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_33;
  tmpvar_33 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_33);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump float u_xlat16_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec4 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec2 u_xlat7;
float u_xlat14;
lowp float u_xlat10_14;
float u_xlat21;
bool u_xlatb21;
mediump float u_xlat16_26;
void main()
{
    u_xlat16_0 = (-_LightShadowData.x) + 1.0;
    u_xlat7.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat7.xy).x;
    u_xlat7.xy = u_xlat7.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat7.xy);
    u_xlat7.x = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat7.x = float(1.0) / u_xlat7.x;
    u_xlat14 = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat2.xyz = vec3(u_xlat14) * vs_TEXCOORD1.xyz;
    u_xlat2.xyw = u_xlat7.xxx * u_xlat2.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.www + u_xlat3.xyz;
    u_xlat3.xyz = u_xlat3.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat4 = u_xlat3.yyyy * hlslcc_mtx4x4unity_WorldToShadow[1];
    u_xlat4 = hlslcc_mtx4x4unity_WorldToShadow[0] * u_xlat3.xxxx + u_xlat4;
    u_xlat4 = hlslcc_mtx4x4unity_WorldToShadow[2] * u_xlat3.zzzz + u_xlat4;
    u_xlat4 = u_xlat4 + hlslcc_mtx4x4unity_WorldToShadow[3];
    u_xlat4.xyz = u_xlat4.xyz / u_xlat4.www;
    vec3 txVec0 = vec3(u_xlat4.xy,u_xlat4.z);
    u_xlat10_14 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_0 = u_xlat10_14 * u_xlat16_0 + _LightShadowData.x;
    u_xlat4.xyz = u_xlat3.xyz + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat14 = sqrt(u_xlat14);
    u_xlat7.x = (-u_xlat2.z) * u_xlat7.x + u_xlat14;
    u_xlat7.x = unity_ShadowFadeCenterAndType.w * u_xlat7.x + u_xlat2.w;
    u_xlat14 = u_xlat7.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat7.x = u_xlat7.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat7.x = (-u_xlat7.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat7.x = min(max(u_xlat7.x, 0.0), 1.0);
#else
    u_xlat7.x = clamp(u_xlat7.x, 0.0, 1.0);
#endif
    u_xlat16_5.x = u_xlat14 + u_xlat16_0;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat0.xzw = u_xlat3.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat0.xzw = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat3.xxx + u_xlat0.xzw;
    u_xlat0.xzw = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat3.zzz + u_xlat0.xzw;
    u_xlat0.xzw = u_xlat0.xzw + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat0.xz = u_xlat0.xz / u_xlat0.ww;
#ifdef UNITY_ADRENO_ES3
    u_xlatb21 = !!(u_xlat0.w<0.0);
#else
    u_xlatb21 = u_xlat0.w<0.0;
#endif
    u_xlat21 = u_xlatb21 ? 1.0 : float(0.0);
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xz, -8.0).w;
    u_xlat0.x = u_xlat21 * u_xlat0.x;
    u_xlat2.xyz = (-u_xlat3.xyz) + _LightPos.xyz;
    u_xlat3.xyz = u_xlat3.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat14 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = u_xlat14 * _LightPos.w;
    u_xlat14 = inversesqrt(u_xlat14);
    u_xlat2.xyz = vec3(u_xlat14) * u_xlat2.xyz;
    u_xlat14 = texture(_LightTextureB0, vec2(u_xlat21)).w;
    u_xlat0.x = u_xlat14 * u_xlat0.x;
    u_xlat0.x = u_xlat16_5.x * u_xlat0.x;
    u_xlat14 = u_xlat0.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat21 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat3.xyz = (-u_xlat3.xyz) * vec3(u_xlat21) + u_xlat2.xyz;
    u_xlat21 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat3.xyz = vec3(u_xlat21) * u_xlat3.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat3.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot(u_xlat2.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat0.x = u_xlat0.x * u_xlat16_5.x;
    u_xlat1.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat16_5.x = max(u_xlat16_6, 0.0);
    u_xlat16_5.x = log2(u_xlat16_5.x);
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_26;
    u_xlat16_5.x = exp2(u_xlat16_5.x);
    u_xlat0.x = u_xlat14 * u_xlat16_5.x;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat0.x * u_xlat16_5.x;
    u_xlat0 = u_xlat7.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump float u_xlat16_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec4 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec2 u_xlat7;
float u_xlat14;
lowp float u_xlat10_14;
float u_xlat21;
bool u_xlatb21;
mediump float u_xlat16_26;
void main()
{
    u_xlat16_0 = (-_LightShadowData.x) + 1.0;
    u_xlat7.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat7.xy).x;
    u_xlat7.xy = u_xlat7.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat7.xy);
    u_xlat7.x = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat7.x = float(1.0) / u_xlat7.x;
    u_xlat14 = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat2.xyz = vec3(u_xlat14) * vs_TEXCOORD1.xyz;
    u_xlat2.xyw = u_xlat7.xxx * u_xlat2.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.www + u_xlat3.xyz;
    u_xlat3.xyz = u_xlat3.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat4 = u_xlat3.yyyy * hlslcc_mtx4x4unity_WorldToShadow[1];
    u_xlat4 = hlslcc_mtx4x4unity_WorldToShadow[0] * u_xlat3.xxxx + u_xlat4;
    u_xlat4 = hlslcc_mtx4x4unity_WorldToShadow[2] * u_xlat3.zzzz + u_xlat4;
    u_xlat4 = u_xlat4 + hlslcc_mtx4x4unity_WorldToShadow[3];
    u_xlat4.xyz = u_xlat4.xyz / u_xlat4.www;
    vec3 txVec0 = vec3(u_xlat4.xy,u_xlat4.z);
    u_xlat10_14 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_0 = u_xlat10_14 * u_xlat16_0 + _LightShadowData.x;
    u_xlat4.xyz = u_xlat3.xyz + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat14 = sqrt(u_xlat14);
    u_xlat7.x = (-u_xlat2.z) * u_xlat7.x + u_xlat14;
    u_xlat7.x = unity_ShadowFadeCenterAndType.w * u_xlat7.x + u_xlat2.w;
    u_xlat14 = u_xlat7.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat7.x = u_xlat7.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat7.x = (-u_xlat7.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat7.x = min(max(u_xlat7.x, 0.0), 1.0);
#else
    u_xlat7.x = clamp(u_xlat7.x, 0.0, 1.0);
#endif
    u_xlat16_5.x = u_xlat14 + u_xlat16_0;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat0.xzw = u_xlat3.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat0.xzw = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat3.xxx + u_xlat0.xzw;
    u_xlat0.xzw = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat3.zzz + u_xlat0.xzw;
    u_xlat0.xzw = u_xlat0.xzw + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat0.xz = u_xlat0.xz / u_xlat0.ww;
#ifdef UNITY_ADRENO_ES3
    u_xlatb21 = !!(u_xlat0.w<0.0);
#else
    u_xlatb21 = u_xlat0.w<0.0;
#endif
    u_xlat21 = u_xlatb21 ? 1.0 : float(0.0);
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xz, -8.0).w;
    u_xlat0.x = u_xlat21 * u_xlat0.x;
    u_xlat2.xyz = (-u_xlat3.xyz) + _LightPos.xyz;
    u_xlat3.xyz = u_xlat3.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat14 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = u_xlat14 * _LightPos.w;
    u_xlat14 = inversesqrt(u_xlat14);
    u_xlat2.xyz = vec3(u_xlat14) * u_xlat2.xyz;
    u_xlat14 = texture(_LightTextureB0, vec2(u_xlat21)).w;
    u_xlat0.x = u_xlat14 * u_xlat0.x;
    u_xlat0.x = u_xlat16_5.x * u_xlat0.x;
    u_xlat14 = u_xlat0.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat21 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat3.xyz = (-u_xlat3.xyz) * vec3(u_xlat21) + u_xlat2.xyz;
    u_xlat21 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat3.xyz = vec3(u_xlat21) * u_xlat3.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat3.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot(u_xlat2.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat0.x = u_xlat0.x * u_xlat16_5.x;
    u_xlat1.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat16_5.x = max(u_xlat16_6, 0.0);
    u_xlat16_5.x = log2(u_xlat16_5.x);
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_26;
    u_xlat16_5.x = exp2(u_xlat16_5.x);
    u_xlat0.x = u_xlat14 * u_xlat16_5.x;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat0.x * u_xlat16_5.x;
    u_xlat0 = u_xlat7.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump float u_xlat16_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec4 u_xlat4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec2 u_xlat7;
float u_xlat14;
lowp float u_xlat10_14;
float u_xlat21;
bool u_xlatb21;
mediump float u_xlat16_26;
void main()
{
    u_xlat16_0 = (-_LightShadowData.x) + 1.0;
    u_xlat7.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat7.xy).x;
    u_xlat7.xy = u_xlat7.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat7.xy);
    u_xlat7.x = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat7.x = float(1.0) / u_xlat7.x;
    u_xlat14 = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat2.xyz = vec3(u_xlat14) * vs_TEXCOORD1.xyz;
    u_xlat2.xyw = u_xlat7.xxx * u_xlat2.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.www + u_xlat3.xyz;
    u_xlat3.xyz = u_xlat3.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat4 = u_xlat3.yyyy * hlslcc_mtx4x4unity_WorldToShadow[1];
    u_xlat4 = hlslcc_mtx4x4unity_WorldToShadow[0] * u_xlat3.xxxx + u_xlat4;
    u_xlat4 = hlslcc_mtx4x4unity_WorldToShadow[2] * u_xlat3.zzzz + u_xlat4;
    u_xlat4 = u_xlat4 + hlslcc_mtx4x4unity_WorldToShadow[3];
    u_xlat4.xyz = u_xlat4.xyz / u_xlat4.www;
    vec3 txVec0 = vec3(u_xlat4.xy,u_xlat4.z);
    u_xlat10_14 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_0 = u_xlat10_14 * u_xlat16_0 + _LightShadowData.x;
    u_xlat4.xyz = u_xlat3.xyz + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat14 = sqrt(u_xlat14);
    u_xlat7.x = (-u_xlat2.z) * u_xlat7.x + u_xlat14;
    u_xlat7.x = unity_ShadowFadeCenterAndType.w * u_xlat7.x + u_xlat2.w;
    u_xlat14 = u_xlat7.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat7.x = u_xlat7.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat7.x = (-u_xlat7.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat7.x = min(max(u_xlat7.x, 0.0), 1.0);
#else
    u_xlat7.x = clamp(u_xlat7.x, 0.0, 1.0);
#endif
    u_xlat16_5.x = u_xlat14 + u_xlat16_0;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat0.xzw = u_xlat3.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat0.xzw = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat3.xxx + u_xlat0.xzw;
    u_xlat0.xzw = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat3.zzz + u_xlat0.xzw;
    u_xlat0.xzw = u_xlat0.xzw + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat0.xz = u_xlat0.xz / u_xlat0.ww;
#ifdef UNITY_ADRENO_ES3
    u_xlatb21 = !!(u_xlat0.w<0.0);
#else
    u_xlatb21 = u_xlat0.w<0.0;
#endif
    u_xlat21 = u_xlatb21 ? 1.0 : float(0.0);
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xz, -8.0).w;
    u_xlat0.x = u_xlat21 * u_xlat0.x;
    u_xlat2.xyz = (-u_xlat3.xyz) + _LightPos.xyz;
    u_xlat3.xyz = u_xlat3.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat14 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = u_xlat14 * _LightPos.w;
    u_xlat14 = inversesqrt(u_xlat14);
    u_xlat2.xyz = vec3(u_xlat14) * u_xlat2.xyz;
    u_xlat14 = texture(_LightTextureB0, vec2(u_xlat21)).w;
    u_xlat0.x = u_xlat14 * u_xlat0.x;
    u_xlat0.x = u_xlat16_5.x * u_xlat0.x;
    u_xlat14 = u_xlat0.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat21 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat3.xyz = (-u_xlat3.xyz) * vec3(u_xlat21) + u_xlat2.xyz;
    u_xlat21 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat3.xyz = vec3(u_xlat21) * u_xlat3.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat3.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot(u_xlat2.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat0.x = u_xlat0.x * u_xlat16_5.x;
    u_xlat1.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat16_5.x = max(u_xlat16_6, 0.0);
    u_xlat16_5.x = log2(u_xlat16_5.x);
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_26;
    u_xlat16_5.x = exp2(u_xlat16_5.x);
    u_xlat0.x = u_xlat14 * u_xlat16_5.x;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat0.x * u_xlat16_5.x;
    u_xlat0 = u_xlat7.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_13);
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  highp vec4 tmpvar_16;
  tmpvar_16 = (unity_WorldToLight * tmpvar_15);
  highp vec4 tmpvar_17;
  tmpvar_17.zw = vec2(0.0, -8.0);
  tmpvar_17.xy = (tmpvar_16.xy / tmpvar_16.w);
  atten_6 = (texture2D (_LightTexture0, tmpvar_17.xy, -8.0).w * float((tmpvar_16.w < 0.0)));
  atten_6 = (atten_6 * texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w))).w);
  mediump float tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_18 = tmpvar_19;
  mediump float shadowAttenuation_20;
  shadowAttenuation_20 = 1.0;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = tmpvar_10;
  highp vec4 tmpvar_22;
  tmpvar_22 = (unity_WorldToShadow[0] * tmpvar_21);
  lowp float tmpvar_23;
  highp vec4 shadowVals_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = (tmpvar_22.xyz / tmpvar_22.w);
  shadowVals_24.x = texture2D (_ShadowMapTexture, (tmpvar_25.xy + _ShadowOffsets[0].xy)).x;
  shadowVals_24.y = texture2D (_ShadowMapTexture, (tmpvar_25.xy + _ShadowOffsets[1].xy)).x;
  shadowVals_24.z = texture2D (_ShadowMapTexture, (tmpvar_25.xy + _ShadowOffsets[2].xy)).x;
  shadowVals_24.w = texture2D (_ShadowMapTexture, (tmpvar_25.xy + _ShadowOffsets[3].xy)).x;
  bvec4 tmpvar_26;
  tmpvar_26 = lessThan (shadowVals_24, tmpvar_25.zzzz);
  mediump vec4 tmpvar_27;
  tmpvar_27 = _LightShadowData.xxxx;
  mediump float tmpvar_28;
  if (tmpvar_26.x) {
    tmpvar_28 = tmpvar_27.x;
  } else {
    tmpvar_28 = 1.0;
  };
  mediump float tmpvar_29;
  if (tmpvar_26.y) {
    tmpvar_29 = tmpvar_27.y;
  } else {
    tmpvar_29 = 1.0;
  };
  mediump float tmpvar_30;
  if (tmpvar_26.z) {
    tmpvar_30 = tmpvar_27.z;
  } else {
    tmpvar_30 = 1.0;
  };
  mediump float tmpvar_31;
  if (tmpvar_26.w) {
    tmpvar_31 = tmpvar_27.w;
  } else {
    tmpvar_31 = 1.0;
  };
  mediump vec4 tmpvar_32;
  tmpvar_32.x = tmpvar_28;
  tmpvar_32.y = tmpvar_29;
  tmpvar_32.z = tmpvar_30;
  tmpvar_32.w = tmpvar_31;
  mediump float tmpvar_33;
  tmpvar_33 = dot (tmpvar_32, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_23 = tmpvar_33;
  shadowAttenuation_20 = tmpvar_23;
  mediump float tmpvar_34;
  tmpvar_34 = clamp ((shadowAttenuation_20 + tmpvar_18), 0.0, 1.0);
  atten_6 = (atten_6 * tmpvar_34);
  lowp vec4 tmpvar_35;
  highp vec2 P_36;
  P_36 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_35 = texture2D (_CameraNormalsTexture, P_36);
  nspec_5 = tmpvar_35;
  mediump vec3 tmpvar_37;
  tmpvar_37 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_38;
  tmpvar_38 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_38;
  mediump float tmpvar_39;
  tmpvar_39 = pow (max (0.0, dot (h_4, tmpvar_37)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_39;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_37)
  ) * atten_6));
  mediump vec3 rgb_40;
  rgb_40 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_40, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_41;
  tmpvar_41 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_41);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_13);
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  highp vec4 tmpvar_16;
  tmpvar_16 = (unity_WorldToLight * tmpvar_15);
  highp vec4 tmpvar_17;
  tmpvar_17.zw = vec2(0.0, -8.0);
  tmpvar_17.xy = (tmpvar_16.xy / tmpvar_16.w);
  atten_6 = (texture2D (_LightTexture0, tmpvar_17.xy, -8.0).w * float((tmpvar_16.w < 0.0)));
  atten_6 = (atten_6 * texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w))).w);
  mediump float tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_18 = tmpvar_19;
  mediump float shadowAttenuation_20;
  shadowAttenuation_20 = 1.0;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = tmpvar_10;
  highp vec4 tmpvar_22;
  tmpvar_22 = (unity_WorldToShadow[0] * tmpvar_21);
  lowp float tmpvar_23;
  highp vec4 shadowVals_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = (tmpvar_22.xyz / tmpvar_22.w);
  shadowVals_24.x = texture2D (_ShadowMapTexture, (tmpvar_25.xy + _ShadowOffsets[0].xy)).x;
  shadowVals_24.y = texture2D (_ShadowMapTexture, (tmpvar_25.xy + _ShadowOffsets[1].xy)).x;
  shadowVals_24.z = texture2D (_ShadowMapTexture, (tmpvar_25.xy + _ShadowOffsets[2].xy)).x;
  shadowVals_24.w = texture2D (_ShadowMapTexture, (tmpvar_25.xy + _ShadowOffsets[3].xy)).x;
  bvec4 tmpvar_26;
  tmpvar_26 = lessThan (shadowVals_24, tmpvar_25.zzzz);
  mediump vec4 tmpvar_27;
  tmpvar_27 = _LightShadowData.xxxx;
  mediump float tmpvar_28;
  if (tmpvar_26.x) {
    tmpvar_28 = tmpvar_27.x;
  } else {
    tmpvar_28 = 1.0;
  };
  mediump float tmpvar_29;
  if (tmpvar_26.y) {
    tmpvar_29 = tmpvar_27.y;
  } else {
    tmpvar_29 = 1.0;
  };
  mediump float tmpvar_30;
  if (tmpvar_26.z) {
    tmpvar_30 = tmpvar_27.z;
  } else {
    tmpvar_30 = 1.0;
  };
  mediump float tmpvar_31;
  if (tmpvar_26.w) {
    tmpvar_31 = tmpvar_27.w;
  } else {
    tmpvar_31 = 1.0;
  };
  mediump vec4 tmpvar_32;
  tmpvar_32.x = tmpvar_28;
  tmpvar_32.y = tmpvar_29;
  tmpvar_32.z = tmpvar_30;
  tmpvar_32.w = tmpvar_31;
  mediump float tmpvar_33;
  tmpvar_33 = dot (tmpvar_32, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_23 = tmpvar_33;
  shadowAttenuation_20 = tmpvar_23;
  mediump float tmpvar_34;
  tmpvar_34 = clamp ((shadowAttenuation_20 + tmpvar_18), 0.0, 1.0);
  atten_6 = (atten_6 * tmpvar_34);
  lowp vec4 tmpvar_35;
  highp vec2 P_36;
  P_36 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_35 = texture2D (_CameraNormalsTexture, P_36);
  nspec_5 = tmpvar_35;
  mediump vec3 tmpvar_37;
  tmpvar_37 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_38;
  tmpvar_38 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_38;
  mediump float tmpvar_39;
  tmpvar_39 = pow (max (0.0, dot (h_4, tmpvar_37)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_39;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_37)
  ) * atten_6));
  mediump vec3 rgb_40;
  rgb_40 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_40, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_41;
  tmpvar_41 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_41);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp mat4 unity_WorldToShadow[4];
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(tmpvar_13);
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15.w = 1.0;
  tmpvar_15.xyz = tmpvar_10;
  highp vec4 tmpvar_16;
  tmpvar_16 = (unity_WorldToLight * tmpvar_15);
  highp vec4 tmpvar_17;
  tmpvar_17.zw = vec2(0.0, -8.0);
  tmpvar_17.xy = (tmpvar_16.xy / tmpvar_16.w);
  atten_6 = (texture2D (_LightTexture0, tmpvar_17.xy, -8.0).w * float((tmpvar_16.w < 0.0)));
  atten_6 = (atten_6 * texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w))).w);
  mediump float tmpvar_18;
  highp float tmpvar_19;
  tmpvar_19 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_18 = tmpvar_19;
  mediump float shadowAttenuation_20;
  shadowAttenuation_20 = 1.0;
  highp vec4 tmpvar_21;
  tmpvar_21.w = 1.0;
  tmpvar_21.xyz = tmpvar_10;
  highp vec4 tmpvar_22;
  tmpvar_22 = (unity_WorldToShadow[0] * tmpvar_21);
  lowp float tmpvar_23;
  highp vec4 shadowVals_24;
  highp vec3 tmpvar_25;
  tmpvar_25 = (tmpvar_22.xyz / tmpvar_22.w);
  shadowVals_24.x = texture2D (_ShadowMapTexture, (tmpvar_25.xy + _ShadowOffsets[0].xy)).x;
  shadowVals_24.y = texture2D (_ShadowMapTexture, (tmpvar_25.xy + _ShadowOffsets[1].xy)).x;
  shadowVals_24.z = texture2D (_ShadowMapTexture, (tmpvar_25.xy + _ShadowOffsets[2].xy)).x;
  shadowVals_24.w = texture2D (_ShadowMapTexture, (tmpvar_25.xy + _ShadowOffsets[3].xy)).x;
  bvec4 tmpvar_26;
  tmpvar_26 = lessThan (shadowVals_24, tmpvar_25.zzzz);
  mediump vec4 tmpvar_27;
  tmpvar_27 = _LightShadowData.xxxx;
  mediump float tmpvar_28;
  if (tmpvar_26.x) {
    tmpvar_28 = tmpvar_27.x;
  } else {
    tmpvar_28 = 1.0;
  };
  mediump float tmpvar_29;
  if (tmpvar_26.y) {
    tmpvar_29 = tmpvar_27.y;
  } else {
    tmpvar_29 = 1.0;
  };
  mediump float tmpvar_30;
  if (tmpvar_26.z) {
    tmpvar_30 = tmpvar_27.z;
  } else {
    tmpvar_30 = 1.0;
  };
  mediump float tmpvar_31;
  if (tmpvar_26.w) {
    tmpvar_31 = tmpvar_27.w;
  } else {
    tmpvar_31 = 1.0;
  };
  mediump vec4 tmpvar_32;
  tmpvar_32.x = tmpvar_28;
  tmpvar_32.y = tmpvar_29;
  tmpvar_32.z = tmpvar_30;
  tmpvar_32.w = tmpvar_31;
  mediump float tmpvar_33;
  tmpvar_33 = dot (tmpvar_32, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_23 = tmpvar_33;
  shadowAttenuation_20 = tmpvar_23;
  mediump float tmpvar_34;
  tmpvar_34 = clamp ((shadowAttenuation_20 + tmpvar_18), 0.0, 1.0);
  atten_6 = (atten_6 * tmpvar_34);
  lowp vec4 tmpvar_35;
  highp vec2 P_36;
  P_36 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_35 = texture2D (_CameraNormalsTexture, P_36);
  nspec_5 = tmpvar_35;
  mediump vec3 tmpvar_37;
  tmpvar_37 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_38;
  tmpvar_38 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_38;
  mediump float tmpvar_39;
  tmpvar_39 = pow (max (0.0, dot (h_4, tmpvar_37)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_39;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_37)
  ) * atten_6));
  mediump vec3 rgb_40;
  rgb_40 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_40, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_41;
  tmpvar_41 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_41);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _ShadowOffsets[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec4 u_xlat3;
vec4 u_xlat4;
vec3 u_xlat5;
mediump vec3 u_xlat16_6;
mediump float u_xlat16_7;
vec3 u_xlat8;
float u_xlat16;
mediump float u_xlat16_16;
float u_xlat24;
bool u_xlatb24;
mediump float u_xlat16_30;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat16 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat16 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat8.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat8.xyz = u_xlat8.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat8.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3 = u_xlat2.yyyy * hlslcc_mtx4x4unity_WorldToShadow[1];
    u_xlat3 = hlslcc_mtx4x4unity_WorldToShadow[0] * u_xlat2.xxxx + u_xlat3;
    u_xlat3 = hlslcc_mtx4x4unity_WorldToShadow[2] * u_xlat2.wwww + u_xlat3;
    u_xlat3 = u_xlat3 + hlslcc_mtx4x4unity_WorldToShadow[3];
    u_xlat3.xyz = u_xlat3.xyz / u_xlat3.www;
    u_xlat4.xyz = u_xlat3.xyz + _ShadowOffsets[0].xyz;
    vec3 txVec0 = vec3(u_xlat4.xy,u_xlat4.z);
    u_xlat4.x = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat5.xyz = u_xlat3.xyz + _ShadowOffsets[1].xyz;
    vec3 txVec1 = vec3(u_xlat5.xy,u_xlat5.z);
    u_xlat4.y = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec1, 0.0);
    u_xlat5.xyz = u_xlat3.xyz + _ShadowOffsets[2].xyz;
    u_xlat3.xyz = u_xlat3.xyz + _ShadowOffsets[3].xyz;
    vec3 txVec2 = vec3(u_xlat3.xy,u_xlat3.z);
    u_xlat4.w = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec2, 0.0);
    vec3 txVec3 = vec3(u_xlat5.xy,u_xlat5.z);
    u_xlat4.z = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec3, 0.0);
    u_xlat8.x = dot(u_xlat4, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat16_16 = (-_LightShadowData.x) + 1.0;
    u_xlat8.x = u_xlat8.x * u_xlat16_16 + _LightShadowData.x;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat16 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat16 = sqrt(u_xlat16);
    u_xlat0.x = (-u_xlat8.z) * u_xlat0.x + u_xlat16;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat16 = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat16 = min(max(u_xlat16, 0.0), 1.0);
#else
    u_xlat16 = clamp(u_xlat16, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat16_6.x = u_xlat16 + u_xlat8.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_6.x = min(max(u_xlat16_6.x, 0.0), 1.0);
#else
    u_xlat16_6.x = clamp(u_xlat16_6.x, 0.0, 1.0);
#endif
    u_xlat8.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat8.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat2.xxx + u_xlat8.xyz;
    u_xlat8.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat2.www + u_xlat8.xyz;
    u_xlat8.xyz = u_xlat8.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat8.xy = u_xlat8.xy / u_xlat8.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb24 = !!(u_xlat8.z<0.0);
#else
    u_xlatb24 = u_xlat8.z<0.0;
#endif
    u_xlat24 = u_xlatb24 ? 1.0 : float(0.0);
    u_xlat8.x = texture(_LightTexture0, u_xlat8.xy, -8.0).w;
    u_xlat8.x = u_xlat24 * u_xlat8.x;
    u_xlat3.xyz = (-u_xlat2.xyw) + _LightPos.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat16 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat24 = u_xlat16 * _LightPos.w;
    u_xlat16 = inversesqrt(u_xlat16);
    u_xlat3.xyz = vec3(u_xlat16) * u_xlat3.xyz;
    u_xlat16 = texture(_LightTextureB0, vec2(u_xlat24)).w;
    u_xlat8.x = u_xlat16 * u_xlat8.x;
    u_xlat8.x = u_xlat16_6.x * u_xlat8.x;
    u_xlat16 = u_xlat8.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16 = min(max(u_xlat16, 0.0), 1.0);
#else
    u_xlat16 = clamp(u_xlat16, 0.0, 1.0);
#endif
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = (-u_xlat2.xyz) * vec3(u_xlat24) + u_xlat3.xyz;
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat2.xyz;
    u_xlat16_6.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_30 = u_xlat10_1.w * 128.0;
    u_xlat16_7 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_7 = inversesqrt(u_xlat16_7);
    u_xlat16_6.xyz = u_xlat16_6.xyz * vec3(u_xlat16_7);
    u_xlat16_7 = dot(u_xlat2.xyz, u_xlat16_6.xyz);
    u_xlat16_6.x = dot(u_xlat3.xyz, u_xlat16_6.xyz);
    u_xlat16_6.x = max(u_xlat16_6.x, 0.0);
    u_xlat8.x = u_xlat8.x * u_xlat16_6.x;
    u_xlat1.xyz = u_xlat8.xxx * _LightColor.xyz;
    u_xlat16_6.x = max(u_xlat16_7, 0.0);
    u_xlat16_6.x = log2(u_xlat16_6.x);
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_30;
    u_xlat16_6.x = exp2(u_xlat16_6.x);
    u_xlat8.x = u_xlat16 * u_xlat16_6.x;
    u_xlat16_6.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat8.x * u_xlat16_6.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _ShadowOffsets[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec4 u_xlat3;
vec4 u_xlat4;
vec3 u_xlat5;
mediump vec3 u_xlat16_6;
mediump float u_xlat16_7;
vec3 u_xlat8;
float u_xlat16;
mediump float u_xlat16_16;
float u_xlat24;
bool u_xlatb24;
mediump float u_xlat16_30;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat16 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat16 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat8.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat8.xyz = u_xlat8.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat8.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3 = u_xlat2.yyyy * hlslcc_mtx4x4unity_WorldToShadow[1];
    u_xlat3 = hlslcc_mtx4x4unity_WorldToShadow[0] * u_xlat2.xxxx + u_xlat3;
    u_xlat3 = hlslcc_mtx4x4unity_WorldToShadow[2] * u_xlat2.wwww + u_xlat3;
    u_xlat3 = u_xlat3 + hlslcc_mtx4x4unity_WorldToShadow[3];
    u_xlat3.xyz = u_xlat3.xyz / u_xlat3.www;
    u_xlat4.xyz = u_xlat3.xyz + _ShadowOffsets[0].xyz;
    vec3 txVec0 = vec3(u_xlat4.xy,u_xlat4.z);
    u_xlat4.x = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat5.xyz = u_xlat3.xyz + _ShadowOffsets[1].xyz;
    vec3 txVec1 = vec3(u_xlat5.xy,u_xlat5.z);
    u_xlat4.y = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec1, 0.0);
    u_xlat5.xyz = u_xlat3.xyz + _ShadowOffsets[2].xyz;
    u_xlat3.xyz = u_xlat3.xyz + _ShadowOffsets[3].xyz;
    vec3 txVec2 = vec3(u_xlat3.xy,u_xlat3.z);
    u_xlat4.w = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec2, 0.0);
    vec3 txVec3 = vec3(u_xlat5.xy,u_xlat5.z);
    u_xlat4.z = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec3, 0.0);
    u_xlat8.x = dot(u_xlat4, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat16_16 = (-_LightShadowData.x) + 1.0;
    u_xlat8.x = u_xlat8.x * u_xlat16_16 + _LightShadowData.x;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat16 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat16 = sqrt(u_xlat16);
    u_xlat0.x = (-u_xlat8.z) * u_xlat0.x + u_xlat16;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat16 = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat16 = min(max(u_xlat16, 0.0), 1.0);
#else
    u_xlat16 = clamp(u_xlat16, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat16_6.x = u_xlat16 + u_xlat8.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_6.x = min(max(u_xlat16_6.x, 0.0), 1.0);
#else
    u_xlat16_6.x = clamp(u_xlat16_6.x, 0.0, 1.0);
#endif
    u_xlat8.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat8.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat2.xxx + u_xlat8.xyz;
    u_xlat8.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat2.www + u_xlat8.xyz;
    u_xlat8.xyz = u_xlat8.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat8.xy = u_xlat8.xy / u_xlat8.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb24 = !!(u_xlat8.z<0.0);
#else
    u_xlatb24 = u_xlat8.z<0.0;
#endif
    u_xlat24 = u_xlatb24 ? 1.0 : float(0.0);
    u_xlat8.x = texture(_LightTexture0, u_xlat8.xy, -8.0).w;
    u_xlat8.x = u_xlat24 * u_xlat8.x;
    u_xlat3.xyz = (-u_xlat2.xyw) + _LightPos.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat16 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat24 = u_xlat16 * _LightPos.w;
    u_xlat16 = inversesqrt(u_xlat16);
    u_xlat3.xyz = vec3(u_xlat16) * u_xlat3.xyz;
    u_xlat16 = texture(_LightTextureB0, vec2(u_xlat24)).w;
    u_xlat8.x = u_xlat16 * u_xlat8.x;
    u_xlat8.x = u_xlat16_6.x * u_xlat8.x;
    u_xlat16 = u_xlat8.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16 = min(max(u_xlat16, 0.0), 1.0);
#else
    u_xlat16 = clamp(u_xlat16, 0.0, 1.0);
#endif
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = (-u_xlat2.xyz) * vec3(u_xlat24) + u_xlat3.xyz;
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat2.xyz;
    u_xlat16_6.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_30 = u_xlat10_1.w * 128.0;
    u_xlat16_7 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_7 = inversesqrt(u_xlat16_7);
    u_xlat16_6.xyz = u_xlat16_6.xyz * vec3(u_xlat16_7);
    u_xlat16_7 = dot(u_xlat2.xyz, u_xlat16_6.xyz);
    u_xlat16_6.x = dot(u_xlat3.xyz, u_xlat16_6.xyz);
    u_xlat16_6.x = max(u_xlat16_6.x, 0.0);
    u_xlat8.x = u_xlat8.x * u_xlat16_6.x;
    u_xlat1.xyz = u_xlat8.xxx * _LightColor.xyz;
    u_xlat16_6.x = max(u_xlat16_7, 0.0);
    u_xlat16_6.x = log2(u_xlat16_6.x);
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_30;
    u_xlat16_6.x = exp2(u_xlat16_6.x);
    u_xlat8.x = u_xlat16 * u_xlat16_6.x;
    u_xlat16_6.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat8.x * u_xlat16_6.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToShadow[16];
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _ShadowOffsets[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec4 u_xlat3;
vec4 u_xlat4;
vec3 u_xlat5;
mediump vec3 u_xlat16_6;
mediump float u_xlat16_7;
vec3 u_xlat8;
float u_xlat16;
mediump float u_xlat16_16;
float u_xlat24;
bool u_xlatb24;
mediump float u_xlat16_30;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat16 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat16 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat8.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat8.xyz = u_xlat8.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat8.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3 = u_xlat2.yyyy * hlslcc_mtx4x4unity_WorldToShadow[1];
    u_xlat3 = hlslcc_mtx4x4unity_WorldToShadow[0] * u_xlat2.xxxx + u_xlat3;
    u_xlat3 = hlslcc_mtx4x4unity_WorldToShadow[2] * u_xlat2.wwww + u_xlat3;
    u_xlat3 = u_xlat3 + hlslcc_mtx4x4unity_WorldToShadow[3];
    u_xlat3.xyz = u_xlat3.xyz / u_xlat3.www;
    u_xlat4.xyz = u_xlat3.xyz + _ShadowOffsets[0].xyz;
    vec3 txVec0 = vec3(u_xlat4.xy,u_xlat4.z);
    u_xlat4.x = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat5.xyz = u_xlat3.xyz + _ShadowOffsets[1].xyz;
    vec3 txVec1 = vec3(u_xlat5.xy,u_xlat5.z);
    u_xlat4.y = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec1, 0.0);
    u_xlat5.xyz = u_xlat3.xyz + _ShadowOffsets[2].xyz;
    u_xlat3.xyz = u_xlat3.xyz + _ShadowOffsets[3].xyz;
    vec3 txVec2 = vec3(u_xlat3.xy,u_xlat3.z);
    u_xlat4.w = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec2, 0.0);
    vec3 txVec3 = vec3(u_xlat5.xy,u_xlat5.z);
    u_xlat4.z = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec3, 0.0);
    u_xlat8.x = dot(u_xlat4, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat16_16 = (-_LightShadowData.x) + 1.0;
    u_xlat8.x = u_xlat8.x * u_xlat16_16 + _LightShadowData.x;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat16 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat16 = sqrt(u_xlat16);
    u_xlat0.x = (-u_xlat8.z) * u_xlat0.x + u_xlat16;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat16 = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat16 = min(max(u_xlat16, 0.0), 1.0);
#else
    u_xlat16 = clamp(u_xlat16, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat16_6.x = u_xlat16 + u_xlat8.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_6.x = min(max(u_xlat16_6.x, 0.0), 1.0);
#else
    u_xlat16_6.x = clamp(u_xlat16_6.x, 0.0, 1.0);
#endif
    u_xlat8.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat8.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat2.xxx + u_xlat8.xyz;
    u_xlat8.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat2.www + u_xlat8.xyz;
    u_xlat8.xyz = u_xlat8.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat8.xy = u_xlat8.xy / u_xlat8.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb24 = !!(u_xlat8.z<0.0);
#else
    u_xlatb24 = u_xlat8.z<0.0;
#endif
    u_xlat24 = u_xlatb24 ? 1.0 : float(0.0);
    u_xlat8.x = texture(_LightTexture0, u_xlat8.xy, -8.0).w;
    u_xlat8.x = u_xlat24 * u_xlat8.x;
    u_xlat3.xyz = (-u_xlat2.xyw) + _LightPos.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat16 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat24 = u_xlat16 * _LightPos.w;
    u_xlat16 = inversesqrt(u_xlat16);
    u_xlat3.xyz = vec3(u_xlat16) * u_xlat3.xyz;
    u_xlat16 = texture(_LightTextureB0, vec2(u_xlat24)).w;
    u_xlat8.x = u_xlat16 * u_xlat8.x;
    u_xlat8.x = u_xlat16_6.x * u_xlat8.x;
    u_xlat16 = u_xlat8.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16 = min(max(u_xlat16, 0.0), 1.0);
#else
    u_xlat16 = clamp(u_xlat16, 0.0, 1.0);
#endif
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = (-u_xlat2.xyz) * vec3(u_xlat24) + u_xlat3.xyz;
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat2.xyz;
    u_xlat16_6.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_30 = u_xlat10_1.w * 128.0;
    u_xlat16_7 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_7 = inversesqrt(u_xlat16_7);
    u_xlat16_6.xyz = u_xlat16_6.xyz * vec3(u_xlat16_7);
    u_xlat16_7 = dot(u_xlat2.xyz, u_xlat16_6.xyz);
    u_xlat16_6.x = dot(u_xlat3.xyz, u_xlat16_6.xyz);
    u_xlat16_6.x = max(u_xlat16_6.x, 0.0);
    u_xlat8.x = u_xlat8.x * u_xlat16_6.x;
    u_xlat1.xyz = u_xlat8.xxx * _LightColor.xyz;
    u_xlat16_6.x = max(u_xlat16_7, 0.0);
    u_xlat16_6.x = log2(u_xlat16_6.x);
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_30;
    u_xlat16_6.x = exp2(u_xlat16_6.x);
    u_xlat8.x = u_xlat16 * u_xlat16_6.x;
    u_xlat16_6.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat8.x * u_xlat16_6.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_13;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  mediump float shadowAttenuation_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_ShadowMapTexture, tmpvar_8);
  shadowAttenuation_16 = tmpvar_17.x;
  mediump float tmpvar_18;
  tmpvar_18 = clamp ((shadowAttenuation_16 + tmpvar_14), 0.0, 1.0);
  atten_6 = tmpvar_18;
  lowp vec4 tmpvar_19;
  highp vec2 P_20;
  P_20 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_19 = texture2D (_CameraNormalsTexture, P_20);
  nspec_5 = tmpvar_19;
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = pow (max (0.0, dot (h_4, tmpvar_21)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_23;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_21)
  ) * atten_6));
  mediump vec3 rgb_24;
  rgb_24 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_24, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_25;
  tmpvar_25 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_25);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_13;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  mediump float shadowAttenuation_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_ShadowMapTexture, tmpvar_8);
  shadowAttenuation_16 = tmpvar_17.x;
  mediump float tmpvar_18;
  tmpvar_18 = clamp ((shadowAttenuation_16 + tmpvar_14), 0.0, 1.0);
  atten_6 = tmpvar_18;
  lowp vec4 tmpvar_19;
  highp vec2 P_20;
  P_20 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_19 = texture2D (_CameraNormalsTexture, P_20);
  nspec_5 = tmpvar_19;
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = pow (max (0.0, dot (h_4, tmpvar_21)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_23;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_21)
  ) * atten_6));
  mediump vec3 rgb_24;
  rgb_24 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_24, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_25;
  tmpvar_25 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_25);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_13;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  mediump float shadowAttenuation_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_ShadowMapTexture, tmpvar_8);
  shadowAttenuation_16 = tmpvar_17.x;
  mediump float tmpvar_18;
  tmpvar_18 = clamp ((shadowAttenuation_16 + tmpvar_14), 0.0, 1.0);
  atten_6 = tmpvar_18;
  lowp vec4 tmpvar_19;
  highp vec2 P_20;
  P_20 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_19 = texture2D (_CameraNormalsTexture, P_20);
  nspec_5 = tmpvar_19;
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_22;
  mediump float tmpvar_23;
  tmpvar_23 = pow (max (0.0, dot (h_4, tmpvar_21)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_23;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_21)
  ) * atten_6));
  mediump vec3 rgb_24;
  rgb_24 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_24, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_25;
  tmpvar_25 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_25);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
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
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp float u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump float u_xlat16_5;
vec3 u_xlat6;
mediump vec2 u_xlat16_6;
mediump float u_xlat16_10;
vec2 u_xlat13;
mediump float u_xlat16_16;
float u_xlat18;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat18 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat18 = _ZBufferParams.x * u_xlat18 + _ZBufferParams.y;
    u_xlat18 = float(1.0) / u_xlat18;
    u_xlat2.xyz = vec3(u_xlat18) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat18 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat6.xyz = (-u_xlat3.xyz) * u_xlat6.xxx + (-_LightDir.xyz);
    u_xlat13.x = dot(u_xlat6.xyz, u_xlat6.xyz);
    u_xlat13.x = inversesqrt(u_xlat13.x);
    u_xlat6.xyz = u_xlat6.xyz * u_xlat13.xxx;
    u_xlat13.xy = u_xlat1.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat10_2 = texture(_CameraNormalsTexture, u_xlat13.xy);
    u_xlat16_4.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = u_xlat10_2.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat6.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
    u_xlat16_4.x = max(u_xlat16_4.x, 0.0);
    u_xlat16_10 = max(u_xlat16_5, 0.0);
    u_xlat16_10 = log2(u_xlat16_10);
    u_xlat16_10 = u_xlat16_10 * u_xlat16_22;
    u_xlat16_4.y = exp2(u_xlat16_10);
    u_xlat6.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat6.x = min(max(u_xlat6.x, 0.0), 1.0);
#else
    u_xlat6.x = clamp(u_xlat6.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat16_16 = u_xlat6.x + u_xlat10_1;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_16 = min(max(u_xlat16_16, 0.0), 1.0);
#else
    u_xlat16_16 = clamp(u_xlat16_16, 0.0, 1.0);
#endif
    u_xlat16_6.xy = vec2(u_xlat16_16) * u_xlat16_4.yx;
    u_xlat1.xyz = u_xlat16_6.yyy * _LightColor.xyz;
    u_xlat16_4.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_6.x * u_xlat16_4.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
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
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp float u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump float u_xlat16_5;
vec3 u_xlat6;
mediump vec2 u_xlat16_6;
mediump float u_xlat16_10;
vec2 u_xlat13;
mediump float u_xlat16_16;
float u_xlat18;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat18 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat18 = _ZBufferParams.x * u_xlat18 + _ZBufferParams.y;
    u_xlat18 = float(1.0) / u_xlat18;
    u_xlat2.xyz = vec3(u_xlat18) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat18 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat6.xyz = (-u_xlat3.xyz) * u_xlat6.xxx + (-_LightDir.xyz);
    u_xlat13.x = dot(u_xlat6.xyz, u_xlat6.xyz);
    u_xlat13.x = inversesqrt(u_xlat13.x);
    u_xlat6.xyz = u_xlat6.xyz * u_xlat13.xxx;
    u_xlat13.xy = u_xlat1.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat10_2 = texture(_CameraNormalsTexture, u_xlat13.xy);
    u_xlat16_4.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = u_xlat10_2.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat6.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
    u_xlat16_4.x = max(u_xlat16_4.x, 0.0);
    u_xlat16_10 = max(u_xlat16_5, 0.0);
    u_xlat16_10 = log2(u_xlat16_10);
    u_xlat16_10 = u_xlat16_10 * u_xlat16_22;
    u_xlat16_4.y = exp2(u_xlat16_10);
    u_xlat6.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat6.x = min(max(u_xlat6.x, 0.0), 1.0);
#else
    u_xlat6.x = clamp(u_xlat6.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat16_16 = u_xlat6.x + u_xlat10_1;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_16 = min(max(u_xlat16_16, 0.0), 1.0);
#else
    u_xlat16_16 = clamp(u_xlat16_16, 0.0, 1.0);
#endif
    u_xlat16_6.xy = vec2(u_xlat16_16) * u_xlat16_4.yx;
    u_xlat1.xyz = u_xlat16_6.yyy * _LightColor.xyz;
    u_xlat16_4.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_6.x * u_xlat16_4.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
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
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp float u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump float u_xlat16_5;
vec3 u_xlat6;
mediump vec2 u_xlat16_6;
mediump float u_xlat16_10;
vec2 u_xlat13;
mediump float u_xlat16_16;
float u_xlat18;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat18 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat18 = _ZBufferParams.x * u_xlat18 + _ZBufferParams.y;
    u_xlat18 = float(1.0) / u_xlat18;
    u_xlat2.xyz = vec3(u_xlat18) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat18 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat6.xyz = (-u_xlat3.xyz) * u_xlat6.xxx + (-_LightDir.xyz);
    u_xlat13.x = dot(u_xlat6.xyz, u_xlat6.xyz);
    u_xlat13.x = inversesqrt(u_xlat13.x);
    u_xlat6.xyz = u_xlat6.xyz * u_xlat13.xxx;
    u_xlat13.xy = u_xlat1.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat10_2 = texture(_CameraNormalsTexture, u_xlat13.xy);
    u_xlat16_4.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = u_xlat10_2.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat6.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
    u_xlat16_4.x = max(u_xlat16_4.x, 0.0);
    u_xlat16_10 = max(u_xlat16_5, 0.0);
    u_xlat16_10 = log2(u_xlat16_10);
    u_xlat16_10 = u_xlat16_10 * u_xlat16_22;
    u_xlat16_4.y = exp2(u_xlat16_10);
    u_xlat6.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat6.x = min(max(u_xlat6.x, 0.0), 1.0);
#else
    u_xlat6.x = clamp(u_xlat6.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat16_16 = u_xlat6.x + u_xlat10_1;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_16 = min(max(u_xlat16_16, 0.0), 1.0);
#else
    u_xlat16_16 = clamp(u_xlat16_16, 0.0, 1.0);
#endif
    u_xlat16_6.xy = vec2(u_xlat16_16) * u_xlat16_4.yx;
    u_xlat1.xyz = u_xlat16_6.yyy * _LightColor.xyz;
    u_xlat16_4.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat16_6.x * u_xlat16_4.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_13;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  mediump float shadowAttenuation_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_ShadowMapTexture, tmpvar_8);
  shadowAttenuation_16 = tmpvar_17.x;
  mediump float tmpvar_18;
  tmpvar_18 = clamp ((shadowAttenuation_16 + tmpvar_14), 0.0, 1.0);
  atten_6 = tmpvar_18;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = tmpvar_10;
  highp vec4 tmpvar_20;
  tmpvar_20.zw = vec2(0.0, -8.0);
  tmpvar_20.xy = (unity_WorldToLight * tmpvar_19).xy;
  atten_6 = (atten_6 * texture2D (_LightTexture0, tmpvar_20.xy, -8.0).w);
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_21 = texture2D (_CameraNormalsTexture, P_22);
  nspec_5 = tmpvar_21;
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = pow (max (0.0, dot (h_4, tmpvar_23)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_25;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_23)
  ) * atten_6));
  mediump vec3 rgb_26;
  rgb_26 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_26, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_27;
  tmpvar_27 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_27);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_13;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  mediump float shadowAttenuation_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_ShadowMapTexture, tmpvar_8);
  shadowAttenuation_16 = tmpvar_17.x;
  mediump float tmpvar_18;
  tmpvar_18 = clamp ((shadowAttenuation_16 + tmpvar_14), 0.0, 1.0);
  atten_6 = tmpvar_18;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = tmpvar_10;
  highp vec4 tmpvar_20;
  tmpvar_20.zw = vec2(0.0, -8.0);
  tmpvar_20.xy = (unity_WorldToLight * tmpvar_19).xy;
  atten_6 = (atten_6 * texture2D (_LightTexture0, tmpvar_20.xy, -8.0).w);
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_21 = texture2D (_CameraNormalsTexture, P_22);
  nspec_5 = tmpvar_21;
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = pow (max (0.0, dot (h_4, tmpvar_23)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_25;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_23)
  ) * atten_6));
  mediump vec3 rgb_26;
  rgb_26 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_26, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_27;
  tmpvar_27 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_27);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_13;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  mediump float shadowAttenuation_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_ShadowMapTexture, tmpvar_8);
  shadowAttenuation_16 = tmpvar_17.x;
  mediump float tmpvar_18;
  tmpvar_18 = clamp ((shadowAttenuation_16 + tmpvar_14), 0.0, 1.0);
  atten_6 = tmpvar_18;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = tmpvar_10;
  highp vec4 tmpvar_20;
  tmpvar_20.zw = vec2(0.0, -8.0);
  tmpvar_20.xy = (unity_WorldToLight * tmpvar_19).xy;
  atten_6 = (atten_6 * texture2D (_LightTexture0, tmpvar_20.xy, -8.0).w);
  lowp vec4 tmpvar_21;
  highp vec2 P_22;
  P_22 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_21 = texture2D (_CameraNormalsTexture, P_22);
  nspec_5 = tmpvar_21;
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_24;
  mediump float tmpvar_25;
  tmpvar_25 = pow (max (0.0, dot (h_4, tmpvar_23)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_25;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_23)
  ) * atten_6));
  mediump vec3 rgb_26;
  rgb_26 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_26, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_27;
  tmpvar_27 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_27);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
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
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform highp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump float u_xlat16_5;
vec2 u_xlat6;
float u_xlat12;
lowp float u_xlat10_12;
float u_xlat18;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat18 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat18 = _ZBufferParams.x * u_xlat18 + _ZBufferParams.y;
    u_xlat18 = float(1.0) / u_xlat18;
    u_xlat2.xyz = vec3(u_xlat18) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat18 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat6.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat6.x = min(max(u_xlat6.x, 0.0), 1.0);
#else
    u_xlat6.x = clamp(u_xlat6.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat10_12 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat1.xy = u_xlat1.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat1.xy);
    u_xlat16_4.x = u_xlat6.x + u_xlat10_12;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat6.xy = u_xlat2.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat6.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat2.xx + u_xlat6.xy;
    u_xlat6.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat2.ww + u_xlat6.xy;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat6.xy = u_xlat6.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat6.x = texture(_LightTexture0, u_xlat6.xy, -8.0).w;
    u_xlat6.x = u_xlat6.x * u_xlat16_4.x;
    u_xlat12 = u_xlat6.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat12 = min(max(u_xlat12, 0.0), 1.0);
#else
    u_xlat12 = clamp(u_xlat12, 0.0, 1.0);
#endif
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat18 = inversesqrt(u_xlat18);
    u_xlat2.xyz = (-u_xlat2.xyz) * vec3(u_xlat18) + (-_LightDir.xyz);
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat18 = inversesqrt(u_xlat18);
    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
    u_xlat16_4.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = u_xlat10_1.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat2.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
    u_xlat16_4.x = max(u_xlat16_4.x, 0.0);
    u_xlat6.x = u_xlat6.x * u_xlat16_4.x;
    u_xlat1.xyz = u_xlat6.xxx * _LightColor.xyz;
    u_xlat16_4.x = max(u_xlat16_5, 0.0);
    u_xlat16_4.x = log2(u_xlat16_4.x);
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_22;
    u_xlat16_4.x = exp2(u_xlat16_4.x);
    u_xlat6.x = u_xlat12 * u_xlat16_4.x;
    u_xlat16_4.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat6.x * u_xlat16_4.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
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
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform highp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump float u_xlat16_5;
vec2 u_xlat6;
float u_xlat12;
lowp float u_xlat10_12;
float u_xlat18;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat18 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat18 = _ZBufferParams.x * u_xlat18 + _ZBufferParams.y;
    u_xlat18 = float(1.0) / u_xlat18;
    u_xlat2.xyz = vec3(u_xlat18) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat18 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat6.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat6.x = min(max(u_xlat6.x, 0.0), 1.0);
#else
    u_xlat6.x = clamp(u_xlat6.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat10_12 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat1.xy = u_xlat1.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat1.xy);
    u_xlat16_4.x = u_xlat6.x + u_xlat10_12;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat6.xy = u_xlat2.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat6.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat2.xx + u_xlat6.xy;
    u_xlat6.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat2.ww + u_xlat6.xy;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat6.xy = u_xlat6.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat6.x = texture(_LightTexture0, u_xlat6.xy, -8.0).w;
    u_xlat6.x = u_xlat6.x * u_xlat16_4.x;
    u_xlat12 = u_xlat6.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat12 = min(max(u_xlat12, 0.0), 1.0);
#else
    u_xlat12 = clamp(u_xlat12, 0.0, 1.0);
#endif
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat18 = inversesqrt(u_xlat18);
    u_xlat2.xyz = (-u_xlat2.xyz) * vec3(u_xlat18) + (-_LightDir.xyz);
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat18 = inversesqrt(u_xlat18);
    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
    u_xlat16_4.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = u_xlat10_1.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat2.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
    u_xlat16_4.x = max(u_xlat16_4.x, 0.0);
    u_xlat6.x = u_xlat6.x * u_xlat16_4.x;
    u_xlat1.xyz = u_xlat6.xxx * _LightColor.xyz;
    u_xlat16_4.x = max(u_xlat16_5, 0.0);
    u_xlat16_4.x = log2(u_xlat16_4.x);
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_22;
    u_xlat16_4.x = exp2(u_xlat16_4.x);
    u_xlat6.x = u_xlat12 * u_xlat16_4.x;
    u_xlat16_4.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat6.x * u_xlat16_4.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
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
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform highp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump float u_xlat16_5;
vec2 u_xlat6;
float u_xlat12;
lowp float u_xlat10_12;
float u_xlat18;
mediump float u_xlat16_22;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat18 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat18 = _ZBufferParams.x * u_xlat18 + _ZBufferParams.y;
    u_xlat18 = float(1.0) / u_xlat18;
    u_xlat2.xyz = vec3(u_xlat18) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat18 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat6.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat6.x = min(max(u_xlat6.x, 0.0), 1.0);
#else
    u_xlat6.x = clamp(u_xlat6.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat10_12 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat1.xy = u_xlat1.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat1.xy);
    u_xlat16_4.x = u_xlat6.x + u_xlat10_12;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat6.xy = u_xlat2.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat6.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat2.xx + u_xlat6.xy;
    u_xlat6.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat2.ww + u_xlat6.xy;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat6.xy = u_xlat6.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat6.x = texture(_LightTexture0, u_xlat6.xy, -8.0).w;
    u_xlat6.x = u_xlat6.x * u_xlat16_4.x;
    u_xlat12 = u_xlat6.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat12 = min(max(u_xlat12, 0.0), 1.0);
#else
    u_xlat12 = clamp(u_xlat12, 0.0, 1.0);
#endif
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat18 = inversesqrt(u_xlat18);
    u_xlat2.xyz = (-u_xlat2.xyz) * vec3(u_xlat18) + (-_LightDir.xyz);
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat18 = inversesqrt(u_xlat18);
    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
    u_xlat16_4.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = u_xlat10_1.w * 128.0;
    u_xlat16_5 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_5 = inversesqrt(u_xlat16_5);
    u_xlat16_4.xyz = u_xlat16_4.xyz * vec3(u_xlat16_5);
    u_xlat16_5 = dot(u_xlat2.xyz, u_xlat16_4.xyz);
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
    u_xlat16_4.x = max(u_xlat16_4.x, 0.0);
    u_xlat6.x = u_xlat6.x * u_xlat16_4.x;
    u_xlat1.xyz = u_xlat6.xxx * _LightColor.xyz;
    u_xlat16_4.x = max(u_xlat16_5, 0.0);
    u_xlat16_4.x = log2(u_xlat16_4.x);
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_22;
    u_xlat16_4.x = exp2(u_xlat16_4.x);
    u_xlat6.x = u_xlat12 * u_xlat16_4.x;
    u_xlat16_4.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat6.x * u_xlat16_4.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT" "SHADOWS_CUBE" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w)));
  atten_6 = tmpvar_15.w;
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  mediump float shadowVal_18;
  highp float mydist_19;
  mydist_19 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_ShadowMapTexture, tmpvar_13);
  highp vec4 vals_21;
  vals_21 = tmpvar_20;
  highp float tmpvar_22;
  tmpvar_22 = dot (vals_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVal_18 = tmpvar_22;
  mediump float tmpvar_23;
  if ((shadowVal_18 < mydist_19)) {
    tmpvar_23 = _LightShadowData.x;
  } else {
    tmpvar_23 = 1.0;
  };
  mediump float tmpvar_24;
  tmpvar_24 = clamp ((tmpvar_23 + tmpvar_16), 0.0, 1.0);
  atten_6 = (tmpvar_15.w * tmpvar_24);
  lowp vec4 tmpvar_25;
  highp vec2 P_26;
  P_26 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_25 = texture2D (_CameraNormalsTexture, P_26);
  nspec_5 = tmpvar_25;
  mediump vec3 tmpvar_27;
  tmpvar_27 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_28;
  tmpvar_28 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = pow (max (0.0, dot (h_4, tmpvar_27)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_29;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_27)
  ) * atten_6));
  mediump vec3 rgb_30;
  rgb_30 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_30, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_31;
  tmpvar_31 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_31);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w)));
  atten_6 = tmpvar_15.w;
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  mediump float shadowVal_18;
  highp float mydist_19;
  mydist_19 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_ShadowMapTexture, tmpvar_13);
  highp vec4 vals_21;
  vals_21 = tmpvar_20;
  highp float tmpvar_22;
  tmpvar_22 = dot (vals_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVal_18 = tmpvar_22;
  mediump float tmpvar_23;
  if ((shadowVal_18 < mydist_19)) {
    tmpvar_23 = _LightShadowData.x;
  } else {
    tmpvar_23 = 1.0;
  };
  mediump float tmpvar_24;
  tmpvar_24 = clamp ((tmpvar_23 + tmpvar_16), 0.0, 1.0);
  atten_6 = (tmpvar_15.w * tmpvar_24);
  lowp vec4 tmpvar_25;
  highp vec2 P_26;
  P_26 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_25 = texture2D (_CameraNormalsTexture, P_26);
  nspec_5 = tmpvar_25;
  mediump vec3 tmpvar_27;
  tmpvar_27 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_28;
  tmpvar_28 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = pow (max (0.0, dot (h_4, tmpvar_27)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_29;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_27)
  ) * atten_6));
  mediump vec3 rgb_30;
  rgb_30 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_30, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_31;
  tmpvar_31 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_31);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w)));
  atten_6 = tmpvar_15.w;
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  mediump float shadowVal_18;
  highp float mydist_19;
  mydist_19 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_ShadowMapTexture, tmpvar_13);
  highp vec4 vals_21;
  vals_21 = tmpvar_20;
  highp float tmpvar_22;
  tmpvar_22 = dot (vals_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVal_18 = tmpvar_22;
  mediump float tmpvar_23;
  if ((shadowVal_18 < mydist_19)) {
    tmpvar_23 = _LightShadowData.x;
  } else {
    tmpvar_23 = 1.0;
  };
  mediump float tmpvar_24;
  tmpvar_24 = clamp ((tmpvar_23 + tmpvar_16), 0.0, 1.0);
  atten_6 = (tmpvar_15.w * tmpvar_24);
  lowp vec4 tmpvar_25;
  highp vec2 P_26;
  P_26 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_25 = texture2D (_CameraNormalsTexture, P_26);
  nspec_5 = tmpvar_25;
  mediump vec3 tmpvar_27;
  tmpvar_27 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_28;
  tmpvar_28 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_28;
  mediump float tmpvar_29;
  tmpvar_29 = pow (max (0.0, dot (h_4, tmpvar_27)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_29;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_27)
  ) * atten_6));
  mediump vec3 rgb_30;
  rgb_30 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_30, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_31;
  tmpvar_31 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_31);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "POINT" "SHADOWS_CUBE" }
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
uniform 	vec4 _LightPositionRange;
uniform 	vec4 _LightProjectionParams;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
lowp vec4 u_xlat10_4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
float u_xlat14;
bool u_xlatb14;
float u_xlat21;
float u_xlat23;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat7.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat7.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat7.x = min(max(u_xlat7.x, 0.0), 1.0);
#else
    u_xlat7.x = clamp(u_xlat7.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat3.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat10_4 = texture(_ShadowMapTexture, u_xlat3.xyz);
    u_xlat14 = dot(u_xlat10_4, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat21 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat23 = sqrt(u_xlat21);
    u_xlat23 = u_xlat23 * _LightPositionRange.w;
    u_xlat23 = u_xlat23 * _LightProjectionParams.w;
#ifdef UNITY_ADRENO_ES3
    u_xlatb14 = !!(u_xlat14<u_xlat23);
#else
    u_xlatb14 = u_xlat14<u_xlat23;
#endif
    u_xlat16_5.x = (u_xlatb14) ? _LightShadowData.x : 1.0;
    u_xlat16_5.x = u_xlat7.x + u_xlat16_5.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat7.x = u_xlat21 * _LightPos.w;
    u_xlat14 = inversesqrt(u_xlat21);
    u_xlat3.xyz = vec3(u_xlat14) * u_xlat3.xyz;
    u_xlat7.x = texture(_LightTextureB0, u_xlat7.xx).w;
    u_xlat7.x = u_xlat16_5.x * u_xlat7.x;
    u_xlat14 = u_xlat7.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat2.xyz = (-u_xlat2.xyz) * vec3(u_xlat21) + (-u_xlat3.xyz);
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat2.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat2.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot((-u_xlat3.xyz), u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat7.x = u_xlat7.x * u_xlat16_5.x;
    u_xlat1.xyz = u_xlat7.xxx * _LightColor.xyz;
    u_xlat16_5.x = max(u_xlat16_6, 0.0);
    u_xlat16_5.x = log2(u_xlat16_5.x);
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_26;
    u_xlat16_5.x = exp2(u_xlat16_5.x);
    u_xlat7.x = u_xlat14 * u_xlat16_5.x;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat7.x * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" }
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
uniform 	vec4 _LightPositionRange;
uniform 	vec4 _LightProjectionParams;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
lowp vec4 u_xlat10_4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
float u_xlat14;
bool u_xlatb14;
float u_xlat21;
float u_xlat23;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat7.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat7.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat7.x = min(max(u_xlat7.x, 0.0), 1.0);
#else
    u_xlat7.x = clamp(u_xlat7.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat3.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat10_4 = texture(_ShadowMapTexture, u_xlat3.xyz);
    u_xlat14 = dot(u_xlat10_4, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat21 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat23 = sqrt(u_xlat21);
    u_xlat23 = u_xlat23 * _LightPositionRange.w;
    u_xlat23 = u_xlat23 * _LightProjectionParams.w;
#ifdef UNITY_ADRENO_ES3
    u_xlatb14 = !!(u_xlat14<u_xlat23);
#else
    u_xlatb14 = u_xlat14<u_xlat23;
#endif
    u_xlat16_5.x = (u_xlatb14) ? _LightShadowData.x : 1.0;
    u_xlat16_5.x = u_xlat7.x + u_xlat16_5.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat7.x = u_xlat21 * _LightPos.w;
    u_xlat14 = inversesqrt(u_xlat21);
    u_xlat3.xyz = vec3(u_xlat14) * u_xlat3.xyz;
    u_xlat7.x = texture(_LightTextureB0, u_xlat7.xx).w;
    u_xlat7.x = u_xlat16_5.x * u_xlat7.x;
    u_xlat14 = u_xlat7.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat2.xyz = (-u_xlat2.xyz) * vec3(u_xlat21) + (-u_xlat3.xyz);
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat2.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat2.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot((-u_xlat3.xyz), u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat7.x = u_xlat7.x * u_xlat16_5.x;
    u_xlat1.xyz = u_xlat7.xxx * _LightColor.xyz;
    u_xlat16_5.x = max(u_xlat16_6, 0.0);
    u_xlat16_5.x = log2(u_xlat16_5.x);
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_26;
    u_xlat16_5.x = exp2(u_xlat16_5.x);
    u_xlat7.x = u_xlat14 * u_xlat16_5.x;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat7.x * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" }
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
uniform 	vec4 _LightPositionRange;
uniform 	vec4 _LightProjectionParams;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
lowp vec4 u_xlat10_4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
float u_xlat14;
bool u_xlatb14;
float u_xlat21;
float u_xlat23;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat7.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat7.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat7.x = min(max(u_xlat7.x, 0.0), 1.0);
#else
    u_xlat7.x = clamp(u_xlat7.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat3.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat10_4 = texture(_ShadowMapTexture, u_xlat3.xyz);
    u_xlat14 = dot(u_xlat10_4, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat21 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat23 = sqrt(u_xlat21);
    u_xlat23 = u_xlat23 * _LightPositionRange.w;
    u_xlat23 = u_xlat23 * _LightProjectionParams.w;
#ifdef UNITY_ADRENO_ES3
    u_xlatb14 = !!(u_xlat14<u_xlat23);
#else
    u_xlatb14 = u_xlat14<u_xlat23;
#endif
    u_xlat16_5.x = (u_xlatb14) ? _LightShadowData.x : 1.0;
    u_xlat16_5.x = u_xlat7.x + u_xlat16_5.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat7.x = u_xlat21 * _LightPos.w;
    u_xlat14 = inversesqrt(u_xlat21);
    u_xlat3.xyz = vec3(u_xlat14) * u_xlat3.xyz;
    u_xlat7.x = texture(_LightTextureB0, u_xlat7.xx).w;
    u_xlat7.x = u_xlat16_5.x * u_xlat7.x;
    u_xlat14 = u_xlat7.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat2.xyz = (-u_xlat2.xyz) * vec3(u_xlat21) + (-u_xlat3.xyz);
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat2.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat2.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot((-u_xlat3.xyz), u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat7.x = u_xlat7.x * u_xlat16_5.x;
    u_xlat1.xyz = u_xlat7.xxx * _LightColor.xyz;
    u_xlat16_5.x = max(u_xlat16_6, 0.0);
    u_xlat16_5.x = log2(u_xlat16_5.x);
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_26;
    u_xlat16_5.x = exp2(u_xlat16_5.x);
    u_xlat7.x = u_xlat14 * u_xlat16_5.x;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat7.x * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
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
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w)));
  atten_6 = tmpvar_15.w;
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  highp vec4 shadowVals_18;
  highp float mydist_19;
  mydist_19 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_20;
  tmpvar_20.w = 0.0;
  tmpvar_20.xyz = (tmpvar_13 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_20.xyz, 0.0);
  tmpvar_21 = tmpvar_22;
  shadowVals_18.x = dot (tmpvar_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_23;
  tmpvar_23.w = 0.0;
  tmpvar_23.xyz = (tmpvar_13 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_23.xyz, 0.0);
  tmpvar_24 = tmpvar_25;
  shadowVals_18.y = dot (tmpvar_24, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_26;
  tmpvar_26.w = 0.0;
  tmpvar_26.xyz = (tmpvar_13 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_26.xyz, 0.0);
  tmpvar_27 = tmpvar_28;
  shadowVals_18.z = dot (tmpvar_27, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_29;
  tmpvar_29.w = 0.0;
  tmpvar_29.xyz = (tmpvar_13 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_30;
  lowp vec4 tmpvar_31;
  tmpvar_31 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_29.xyz, 0.0);
  tmpvar_30 = tmpvar_31;
  shadowVals_18.w = dot (tmpvar_30, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_32;
  tmpvar_32 = lessThan (shadowVals_18, vec4(mydist_19));
  mediump vec4 tmpvar_33;
  tmpvar_33 = _LightShadowData.xxxx;
  mediump float tmpvar_34;
  if (tmpvar_32.x) {
    tmpvar_34 = tmpvar_33.x;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_32.y) {
    tmpvar_35 = tmpvar_33.y;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump float tmpvar_36;
  if (tmpvar_32.z) {
    tmpvar_36 = tmpvar_33.z;
  } else {
    tmpvar_36 = 1.0;
  };
  mediump float tmpvar_37;
  if (tmpvar_32.w) {
    tmpvar_37 = tmpvar_33.w;
  } else {
    tmpvar_37 = 1.0;
  };
  mediump vec4 tmpvar_38;
  tmpvar_38.x = tmpvar_34;
  tmpvar_38.y = tmpvar_35;
  tmpvar_38.z = tmpvar_36;
  tmpvar_38.w = tmpvar_37;
  mediump float tmpvar_39;
  tmpvar_39 = clamp ((dot (tmpvar_38, vec4(0.25, 0.25, 0.25, 0.25)) + tmpvar_16), 0.0, 1.0);
  atten_6 = (tmpvar_15.w * tmpvar_39);
  lowp vec4 tmpvar_40;
  highp vec2 P_41;
  P_41 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_40 = texture2D (_CameraNormalsTexture, P_41);
  nspec_5 = tmpvar_40;
  mediump vec3 tmpvar_42;
  tmpvar_42 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_43;
  tmpvar_43 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_43;
  mediump float tmpvar_44;
  tmpvar_44 = pow (max (0.0, dot (h_4, tmpvar_42)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_44;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_42)
  ) * atten_6));
  mediump vec3 rgb_45;
  rgb_45 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_45, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_46;
  tmpvar_46 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_46);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
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
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w)));
  atten_6 = tmpvar_15.w;
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  highp vec4 shadowVals_18;
  highp float mydist_19;
  mydist_19 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_20;
  tmpvar_20.w = 0.0;
  tmpvar_20.xyz = (tmpvar_13 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_20.xyz, 0.0);
  tmpvar_21 = tmpvar_22;
  shadowVals_18.x = dot (tmpvar_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_23;
  tmpvar_23.w = 0.0;
  tmpvar_23.xyz = (tmpvar_13 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_23.xyz, 0.0);
  tmpvar_24 = tmpvar_25;
  shadowVals_18.y = dot (tmpvar_24, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_26;
  tmpvar_26.w = 0.0;
  tmpvar_26.xyz = (tmpvar_13 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_26.xyz, 0.0);
  tmpvar_27 = tmpvar_28;
  shadowVals_18.z = dot (tmpvar_27, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_29;
  tmpvar_29.w = 0.0;
  tmpvar_29.xyz = (tmpvar_13 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_30;
  lowp vec4 tmpvar_31;
  tmpvar_31 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_29.xyz, 0.0);
  tmpvar_30 = tmpvar_31;
  shadowVals_18.w = dot (tmpvar_30, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_32;
  tmpvar_32 = lessThan (shadowVals_18, vec4(mydist_19));
  mediump vec4 tmpvar_33;
  tmpvar_33 = _LightShadowData.xxxx;
  mediump float tmpvar_34;
  if (tmpvar_32.x) {
    tmpvar_34 = tmpvar_33.x;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_32.y) {
    tmpvar_35 = tmpvar_33.y;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump float tmpvar_36;
  if (tmpvar_32.z) {
    tmpvar_36 = tmpvar_33.z;
  } else {
    tmpvar_36 = 1.0;
  };
  mediump float tmpvar_37;
  if (tmpvar_32.w) {
    tmpvar_37 = tmpvar_33.w;
  } else {
    tmpvar_37 = 1.0;
  };
  mediump vec4 tmpvar_38;
  tmpvar_38.x = tmpvar_34;
  tmpvar_38.y = tmpvar_35;
  tmpvar_38.z = tmpvar_36;
  tmpvar_38.w = tmpvar_37;
  mediump float tmpvar_39;
  tmpvar_39 = clamp ((dot (tmpvar_38, vec4(0.25, 0.25, 0.25, 0.25)) + tmpvar_16), 0.0, 1.0);
  atten_6 = (tmpvar_15.w * tmpvar_39);
  lowp vec4 tmpvar_40;
  highp vec2 P_41;
  P_41 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_40 = texture2D (_CameraNormalsTexture, P_41);
  nspec_5 = tmpvar_40;
  mediump vec3 tmpvar_42;
  tmpvar_42 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_43;
  tmpvar_43 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_43;
  mediump float tmpvar_44;
  tmpvar_44 = pow (max (0.0, dot (h_4, tmpvar_42)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_44;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_42)
  ) * atten_6));
  mediump vec3 rgb_45;
  rgb_45 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_45, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_46;
  tmpvar_46 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_46);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
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
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w)));
  atten_6 = tmpvar_15.w;
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  highp vec4 shadowVals_18;
  highp float mydist_19;
  mydist_19 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_20;
  tmpvar_20.w = 0.0;
  tmpvar_20.xyz = (tmpvar_13 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_20.xyz, 0.0);
  tmpvar_21 = tmpvar_22;
  shadowVals_18.x = dot (tmpvar_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_23;
  tmpvar_23.w = 0.0;
  tmpvar_23.xyz = (tmpvar_13 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_23.xyz, 0.0);
  tmpvar_24 = tmpvar_25;
  shadowVals_18.y = dot (tmpvar_24, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_26;
  tmpvar_26.w = 0.0;
  tmpvar_26.xyz = (tmpvar_13 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_26.xyz, 0.0);
  tmpvar_27 = tmpvar_28;
  shadowVals_18.z = dot (tmpvar_27, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_29;
  tmpvar_29.w = 0.0;
  tmpvar_29.xyz = (tmpvar_13 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_30;
  lowp vec4 tmpvar_31;
  tmpvar_31 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_29.xyz, 0.0);
  tmpvar_30 = tmpvar_31;
  shadowVals_18.w = dot (tmpvar_30, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_32;
  tmpvar_32 = lessThan (shadowVals_18, vec4(mydist_19));
  mediump vec4 tmpvar_33;
  tmpvar_33 = _LightShadowData.xxxx;
  mediump float tmpvar_34;
  if (tmpvar_32.x) {
    tmpvar_34 = tmpvar_33.x;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_32.y) {
    tmpvar_35 = tmpvar_33.y;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump float tmpvar_36;
  if (tmpvar_32.z) {
    tmpvar_36 = tmpvar_33.z;
  } else {
    tmpvar_36 = 1.0;
  };
  mediump float tmpvar_37;
  if (tmpvar_32.w) {
    tmpvar_37 = tmpvar_33.w;
  } else {
    tmpvar_37 = 1.0;
  };
  mediump vec4 tmpvar_38;
  tmpvar_38.x = tmpvar_34;
  tmpvar_38.y = tmpvar_35;
  tmpvar_38.z = tmpvar_36;
  tmpvar_38.w = tmpvar_37;
  mediump float tmpvar_39;
  tmpvar_39 = clamp ((dot (tmpvar_38, vec4(0.25, 0.25, 0.25, 0.25)) + tmpvar_16), 0.0, 1.0);
  atten_6 = (tmpvar_15.w * tmpvar_39);
  lowp vec4 tmpvar_40;
  highp vec2 P_41;
  P_41 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_40 = texture2D (_CameraNormalsTexture, P_41);
  nspec_5 = tmpvar_40;
  mediump vec3 tmpvar_42;
  tmpvar_42 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_43;
  tmpvar_43 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_43;
  mediump float tmpvar_44;
  tmpvar_44 = pow (max (0.0, dot (h_4, tmpvar_42)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_44;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_42)
  ) * atten_6));
  mediump vec3 rgb_45;
  rgb_45 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_45, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_46;
  tmpvar_46 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_46);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
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
uniform 	vec4 _LightPositionRange;
uniform 	vec4 _LightProjectionParams;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec4 u_xlat4;
lowp vec4 u_xlat10_4;
bvec4 u_xlatb4;
vec3 u_xlat5;
lowp vec4 u_xlat10_5;
mediump vec3 u_xlat16_6;
mediump float u_xlat16_7;
vec3 u_xlat8;
float u_xlat16;
float u_xlat24;
mediump float u_xlat16_30;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat16 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat16 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat8.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat8.xyz = u_xlat8.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat8.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat8.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat8.x = sqrt(u_xlat8.x);
    u_xlat0.x = (-u_xlat8.z) * u_xlat0.x + u_xlat8.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat8.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat8.x = min(max(u_xlat8.x, 0.0), 1.0);
#else
    u_xlat8.x = clamp(u_xlat8.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat3.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat4.xyz = u_xlat3.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
    u_xlat10_4 = textureLod(_ShadowMapTexture, u_xlat4.xyz, 0.0);
    u_xlat4.x = dot(u_xlat10_4, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat5.xyz = u_xlat3.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
    u_xlat10_5 = textureLod(_ShadowMapTexture, u_xlat5.xyz, 0.0);
    u_xlat4.y = dot(u_xlat10_5, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat5.xyz = u_xlat3.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
    u_xlat10_5 = textureLod(_ShadowMapTexture, u_xlat5.xyz, 0.0);
    u_xlat4.z = dot(u_xlat10_5, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat5.xyz = u_xlat3.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
    u_xlat10_5 = textureLod(_ShadowMapTexture, u_xlat5.xyz, 0.0);
    u_xlat4.w = dot(u_xlat10_5, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat16 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat24 = sqrt(u_xlat16);
    u_xlat24 = u_xlat24 * _LightPositionRange.w;
    u_xlat24 = u_xlat24 * _LightProjectionParams.w;
    u_xlatb4 = lessThan(u_xlat4, vec4(u_xlat24));
    u_xlat4.x = (u_xlatb4.x) ? _LightShadowData.x : float(1.0);
    u_xlat4.y = (u_xlatb4.y) ? _LightShadowData.x : float(1.0);
    u_xlat4.z = (u_xlatb4.z) ? _LightShadowData.x : float(1.0);
    u_xlat4.w = (u_xlatb4.w) ? _LightShadowData.x : float(1.0);
    u_xlat16_6.x = dot(u_xlat4, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat16_6.x = u_xlat8.x + u_xlat16_6.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_6.x = min(max(u_xlat16_6.x, 0.0), 1.0);
#else
    u_xlat16_6.x = clamp(u_xlat16_6.x, 0.0, 1.0);
#endif
    u_xlat8.x = u_xlat16 * _LightPos.w;
    u_xlat16 = inversesqrt(u_xlat16);
    u_xlat3.xyz = vec3(u_xlat16) * u_xlat3.xyz;
    u_xlat8.x = texture(_LightTextureB0, u_xlat8.xx).w;
    u_xlat8.x = u_xlat16_6.x * u_xlat8.x;
    u_xlat16 = u_xlat8.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16 = min(max(u_xlat16, 0.0), 1.0);
#else
    u_xlat16 = clamp(u_xlat16, 0.0, 1.0);
#endif
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = (-u_xlat2.xyz) * vec3(u_xlat24) + (-u_xlat3.xyz);
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat2.xyz;
    u_xlat16_6.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_30 = u_xlat10_1.w * 128.0;
    u_xlat16_7 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_7 = inversesqrt(u_xlat16_7);
    u_xlat16_6.xyz = u_xlat16_6.xyz * vec3(u_xlat16_7);
    u_xlat16_7 = dot(u_xlat2.xyz, u_xlat16_6.xyz);
    u_xlat16_6.x = dot((-u_xlat3.xyz), u_xlat16_6.xyz);
    u_xlat16_6.x = max(u_xlat16_6.x, 0.0);
    u_xlat8.x = u_xlat8.x * u_xlat16_6.x;
    u_xlat1.xyz = u_xlat8.xxx * _LightColor.xyz;
    u_xlat16_6.x = max(u_xlat16_7, 0.0);
    u_xlat16_6.x = log2(u_xlat16_6.x);
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_30;
    u_xlat16_6.x = exp2(u_xlat16_6.x);
    u_xlat8.x = u_xlat16 * u_xlat16_6.x;
    u_xlat16_6.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat8.x * u_xlat16_6.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
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
uniform 	vec4 _LightPositionRange;
uniform 	vec4 _LightProjectionParams;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec4 u_xlat4;
lowp vec4 u_xlat10_4;
bvec4 u_xlatb4;
vec3 u_xlat5;
lowp vec4 u_xlat10_5;
mediump vec3 u_xlat16_6;
mediump float u_xlat16_7;
vec3 u_xlat8;
float u_xlat16;
float u_xlat24;
mediump float u_xlat16_30;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat16 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat16 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat8.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat8.xyz = u_xlat8.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat8.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat8.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat8.x = sqrt(u_xlat8.x);
    u_xlat0.x = (-u_xlat8.z) * u_xlat0.x + u_xlat8.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat8.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat8.x = min(max(u_xlat8.x, 0.0), 1.0);
#else
    u_xlat8.x = clamp(u_xlat8.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat3.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat4.xyz = u_xlat3.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
    u_xlat10_4 = textureLod(_ShadowMapTexture, u_xlat4.xyz, 0.0);
    u_xlat4.x = dot(u_xlat10_4, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat5.xyz = u_xlat3.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
    u_xlat10_5 = textureLod(_ShadowMapTexture, u_xlat5.xyz, 0.0);
    u_xlat4.y = dot(u_xlat10_5, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat5.xyz = u_xlat3.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
    u_xlat10_5 = textureLod(_ShadowMapTexture, u_xlat5.xyz, 0.0);
    u_xlat4.z = dot(u_xlat10_5, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat5.xyz = u_xlat3.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
    u_xlat10_5 = textureLod(_ShadowMapTexture, u_xlat5.xyz, 0.0);
    u_xlat4.w = dot(u_xlat10_5, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat16 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat24 = sqrt(u_xlat16);
    u_xlat24 = u_xlat24 * _LightPositionRange.w;
    u_xlat24 = u_xlat24 * _LightProjectionParams.w;
    u_xlatb4 = lessThan(u_xlat4, vec4(u_xlat24));
    u_xlat4.x = (u_xlatb4.x) ? _LightShadowData.x : float(1.0);
    u_xlat4.y = (u_xlatb4.y) ? _LightShadowData.x : float(1.0);
    u_xlat4.z = (u_xlatb4.z) ? _LightShadowData.x : float(1.0);
    u_xlat4.w = (u_xlatb4.w) ? _LightShadowData.x : float(1.0);
    u_xlat16_6.x = dot(u_xlat4, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat16_6.x = u_xlat8.x + u_xlat16_6.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_6.x = min(max(u_xlat16_6.x, 0.0), 1.0);
#else
    u_xlat16_6.x = clamp(u_xlat16_6.x, 0.0, 1.0);
#endif
    u_xlat8.x = u_xlat16 * _LightPos.w;
    u_xlat16 = inversesqrt(u_xlat16);
    u_xlat3.xyz = vec3(u_xlat16) * u_xlat3.xyz;
    u_xlat8.x = texture(_LightTextureB0, u_xlat8.xx).w;
    u_xlat8.x = u_xlat16_6.x * u_xlat8.x;
    u_xlat16 = u_xlat8.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16 = min(max(u_xlat16, 0.0), 1.0);
#else
    u_xlat16 = clamp(u_xlat16, 0.0, 1.0);
#endif
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = (-u_xlat2.xyz) * vec3(u_xlat24) + (-u_xlat3.xyz);
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat2.xyz;
    u_xlat16_6.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_30 = u_xlat10_1.w * 128.0;
    u_xlat16_7 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_7 = inversesqrt(u_xlat16_7);
    u_xlat16_6.xyz = u_xlat16_6.xyz * vec3(u_xlat16_7);
    u_xlat16_7 = dot(u_xlat2.xyz, u_xlat16_6.xyz);
    u_xlat16_6.x = dot((-u_xlat3.xyz), u_xlat16_6.xyz);
    u_xlat16_6.x = max(u_xlat16_6.x, 0.0);
    u_xlat8.x = u_xlat8.x * u_xlat16_6.x;
    u_xlat1.xyz = u_xlat8.xxx * _LightColor.xyz;
    u_xlat16_6.x = max(u_xlat16_7, 0.0);
    u_xlat16_6.x = log2(u_xlat16_6.x);
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_30;
    u_xlat16_6.x = exp2(u_xlat16_6.x);
    u_xlat8.x = u_xlat16 * u_xlat16_6.x;
    u_xlat16_6.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat8.x * u_xlat16_6.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
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
uniform 	vec4 _LightPositionRange;
uniform 	vec4 _LightProjectionParams;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec4 u_xlat4;
lowp vec4 u_xlat10_4;
bvec4 u_xlatb4;
vec3 u_xlat5;
lowp vec4 u_xlat10_5;
mediump vec3 u_xlat16_6;
mediump float u_xlat16_7;
vec3 u_xlat8;
float u_xlat16;
float u_xlat24;
mediump float u_xlat16_30;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat16 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat16 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat8.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat8.xyz = u_xlat8.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat8.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat8.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat8.x = sqrt(u_xlat8.x);
    u_xlat0.x = (-u_xlat8.z) * u_xlat0.x + u_xlat8.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat8.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat8.x = min(max(u_xlat8.x, 0.0), 1.0);
#else
    u_xlat8.x = clamp(u_xlat8.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat3.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat4.xyz = u_xlat3.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
    u_xlat10_4 = textureLod(_ShadowMapTexture, u_xlat4.xyz, 0.0);
    u_xlat4.x = dot(u_xlat10_4, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat5.xyz = u_xlat3.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
    u_xlat10_5 = textureLod(_ShadowMapTexture, u_xlat5.xyz, 0.0);
    u_xlat4.y = dot(u_xlat10_5, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat5.xyz = u_xlat3.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
    u_xlat10_5 = textureLod(_ShadowMapTexture, u_xlat5.xyz, 0.0);
    u_xlat4.z = dot(u_xlat10_5, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat5.xyz = u_xlat3.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
    u_xlat10_5 = textureLod(_ShadowMapTexture, u_xlat5.xyz, 0.0);
    u_xlat4.w = dot(u_xlat10_5, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat16 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat24 = sqrt(u_xlat16);
    u_xlat24 = u_xlat24 * _LightPositionRange.w;
    u_xlat24 = u_xlat24 * _LightProjectionParams.w;
    u_xlatb4 = lessThan(u_xlat4, vec4(u_xlat24));
    u_xlat4.x = (u_xlatb4.x) ? _LightShadowData.x : float(1.0);
    u_xlat4.y = (u_xlatb4.y) ? _LightShadowData.x : float(1.0);
    u_xlat4.z = (u_xlatb4.z) ? _LightShadowData.x : float(1.0);
    u_xlat4.w = (u_xlatb4.w) ? _LightShadowData.x : float(1.0);
    u_xlat16_6.x = dot(u_xlat4, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat16_6.x = u_xlat8.x + u_xlat16_6.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_6.x = min(max(u_xlat16_6.x, 0.0), 1.0);
#else
    u_xlat16_6.x = clamp(u_xlat16_6.x, 0.0, 1.0);
#endif
    u_xlat8.x = u_xlat16 * _LightPos.w;
    u_xlat16 = inversesqrt(u_xlat16);
    u_xlat3.xyz = vec3(u_xlat16) * u_xlat3.xyz;
    u_xlat8.x = texture(_LightTextureB0, u_xlat8.xx).w;
    u_xlat8.x = u_xlat16_6.x * u_xlat8.x;
    u_xlat16 = u_xlat8.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16 = min(max(u_xlat16, 0.0), 1.0);
#else
    u_xlat16 = clamp(u_xlat16, 0.0, 1.0);
#endif
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = (-u_xlat2.xyz) * vec3(u_xlat24) + (-u_xlat3.xyz);
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat2.xyz;
    u_xlat16_6.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_30 = u_xlat10_1.w * 128.0;
    u_xlat16_7 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_7 = inversesqrt(u_xlat16_7);
    u_xlat16_6.xyz = u_xlat16_6.xyz * vec3(u_xlat16_7);
    u_xlat16_7 = dot(u_xlat2.xyz, u_xlat16_6.xyz);
    u_xlat16_6.x = dot((-u_xlat3.xyz), u_xlat16_6.xyz);
    u_xlat16_6.x = max(u_xlat16_6.x, 0.0);
    u_xlat8.x = u_xlat8.x * u_xlat16_6.x;
    u_xlat1.xyz = u_xlat8.xxx * _LightColor.xyz;
    u_xlat16_6.x = max(u_xlat16_7, 0.0);
    u_xlat16_6.x = log2(u_xlat16_6.x);
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_30;
    u_xlat16_6.x = exp2(u_xlat16_6.x);
    u_xlat8.x = u_xlat16 * u_xlat16_6.x;
    u_xlat16_6.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat8.x * u_xlat16_6.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w)));
  atten_6 = tmpvar_15.w;
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  mediump float shadowVal_18;
  highp float mydist_19;
  mydist_19 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_ShadowMapTexture, tmpvar_13);
  highp vec4 vals_21;
  vals_21 = tmpvar_20;
  highp float tmpvar_22;
  tmpvar_22 = dot (vals_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVal_18 = tmpvar_22;
  mediump float tmpvar_23;
  if ((shadowVal_18 < mydist_19)) {
    tmpvar_23 = _LightShadowData.x;
  } else {
    tmpvar_23 = 1.0;
  };
  mediump float tmpvar_24;
  tmpvar_24 = clamp ((tmpvar_23 + tmpvar_16), 0.0, 1.0);
  atten_6 = (tmpvar_15.w * tmpvar_24);
  highp vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.xyz = tmpvar_10;
  highp vec4 tmpvar_26;
  tmpvar_26.w = -8.0;
  tmpvar_26.xyz = (unity_WorldToLight * tmpvar_25).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_26.xyz, -8.0).w);
  lowp vec4 tmpvar_27;
  highp vec2 P_28;
  P_28 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_27 = texture2D (_CameraNormalsTexture, P_28);
  nspec_5 = tmpvar_27;
  mediump vec3 tmpvar_29;
  tmpvar_29 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_30;
  tmpvar_30 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = pow (max (0.0, dot (h_4, tmpvar_29)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_31;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_29)
  ) * atten_6));
  mediump vec3 rgb_32;
  rgb_32 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_32, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_33;
  tmpvar_33 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_33);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w)));
  atten_6 = tmpvar_15.w;
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  mediump float shadowVal_18;
  highp float mydist_19;
  mydist_19 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_ShadowMapTexture, tmpvar_13);
  highp vec4 vals_21;
  vals_21 = tmpvar_20;
  highp float tmpvar_22;
  tmpvar_22 = dot (vals_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVal_18 = tmpvar_22;
  mediump float tmpvar_23;
  if ((shadowVal_18 < mydist_19)) {
    tmpvar_23 = _LightShadowData.x;
  } else {
    tmpvar_23 = 1.0;
  };
  mediump float tmpvar_24;
  tmpvar_24 = clamp ((tmpvar_23 + tmpvar_16), 0.0, 1.0);
  atten_6 = (tmpvar_15.w * tmpvar_24);
  highp vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.xyz = tmpvar_10;
  highp vec4 tmpvar_26;
  tmpvar_26.w = -8.0;
  tmpvar_26.xyz = (unity_WorldToLight * tmpvar_25).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_26.xyz, -8.0).w);
  lowp vec4 tmpvar_27;
  highp vec2 P_28;
  P_28 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_27 = texture2D (_CameraNormalsTexture, P_28);
  nspec_5 = tmpvar_27;
  mediump vec3 tmpvar_29;
  tmpvar_29 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_30;
  tmpvar_30 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = pow (max (0.0, dot (h_4, tmpvar_29)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_31;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_29)
  ) * atten_6));
  mediump vec3 rgb_32;
  rgb_32 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_32, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_33;
  tmpvar_33 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_33);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
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
uniform highp vec3 _WorldSpaceCameraPos;
uniform highp vec4 _ProjectionParams;
uniform highp vec4 _ZBufferParams;
uniform highp mat4 unity_CameraToWorld;
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w)));
  atten_6 = tmpvar_15.w;
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  mediump float shadowVal_18;
  highp float mydist_19;
  mydist_19 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_20;
  tmpvar_20 = textureCube (_ShadowMapTexture, tmpvar_13);
  highp vec4 vals_21;
  vals_21 = tmpvar_20;
  highp float tmpvar_22;
  tmpvar_22 = dot (vals_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVal_18 = tmpvar_22;
  mediump float tmpvar_23;
  if ((shadowVal_18 < mydist_19)) {
    tmpvar_23 = _LightShadowData.x;
  } else {
    tmpvar_23 = 1.0;
  };
  mediump float tmpvar_24;
  tmpvar_24 = clamp ((tmpvar_23 + tmpvar_16), 0.0, 1.0);
  atten_6 = (tmpvar_15.w * tmpvar_24);
  highp vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.xyz = tmpvar_10;
  highp vec4 tmpvar_26;
  tmpvar_26.w = -8.0;
  tmpvar_26.xyz = (unity_WorldToLight * tmpvar_25).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_26.xyz, -8.0).w);
  lowp vec4 tmpvar_27;
  highp vec2 P_28;
  P_28 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_27 = texture2D (_CameraNormalsTexture, P_28);
  nspec_5 = tmpvar_27;
  mediump vec3 tmpvar_29;
  tmpvar_29 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_30;
  tmpvar_30 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_30;
  mediump float tmpvar_31;
  tmpvar_31 = pow (max (0.0, dot (h_4, tmpvar_29)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_31;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_29)
  ) * atten_6));
  mediump vec3 rgb_32;
  rgb_32 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_32, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_33;
  tmpvar_33 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_33);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
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
uniform 	vec4 _LightPositionRange;
uniform 	vec4 _LightProjectionParams;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec3 u_xlat4;
lowp vec4 u_xlat10_4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
float u_xlat14;
bool u_xlatb14;
float u_xlat16;
float u_xlat21;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat7.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat7.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat7.x = min(max(u_xlat7.x, 0.0), 1.0);
#else
    u_xlat7.x = clamp(u_xlat7.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat3.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat10_4 = texture(_ShadowMapTexture, u_xlat3.xyz);
    u_xlat14 = dot(u_xlat10_4, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat21 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat16 = sqrt(u_xlat21);
    u_xlat16 = u_xlat16 * _LightPositionRange.w;
    u_xlat16 = u_xlat16 * _LightProjectionParams.w;
#ifdef UNITY_ADRENO_ES3
    u_xlatb14 = !!(u_xlat14<u_xlat16);
#else
    u_xlatb14 = u_xlat14<u_xlat16;
#endif
    u_xlat16_5.x = (u_xlatb14) ? _LightShadowData.x : 1.0;
    u_xlat16_5.x = u_xlat7.x + u_xlat16_5.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat7.x = u_xlat21 * _LightPos.w;
    u_xlat14 = inversesqrt(u_xlat21);
    u_xlat3.xyz = vec3(u_xlat14) * u_xlat3.xyz;
    u_xlat7.x = texture(_LightTextureB0, u_xlat7.xx).w;
    u_xlat7.x = u_xlat16_5.x * u_xlat7.x;
    u_xlat4.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat4.xyz;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat4.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat4.xyz = u_xlat4.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat14 = texture(_LightTexture0, u_xlat4.xyz, -8.0).w;
    u_xlat7.x = u_xlat14 * u_xlat7.x;
    u_xlat14 = u_xlat7.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat2.xyz = (-u_xlat2.xyz) * vec3(u_xlat21) + (-u_xlat3.xyz);
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat2.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat2.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot((-u_xlat3.xyz), u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat7.x = u_xlat7.x * u_xlat16_5.x;
    u_xlat1.xyz = u_xlat7.xxx * _LightColor.xyz;
    u_xlat16_5.x = max(u_xlat16_6, 0.0);
    u_xlat16_5.x = log2(u_xlat16_5.x);
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_26;
    u_xlat16_5.x = exp2(u_xlat16_5.x);
    u_xlat7.x = u_xlat14 * u_xlat16_5.x;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat7.x * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
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
uniform 	vec4 _LightPositionRange;
uniform 	vec4 _LightProjectionParams;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec3 u_xlat4;
lowp vec4 u_xlat10_4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
float u_xlat14;
bool u_xlatb14;
float u_xlat16;
float u_xlat21;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat7.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat7.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat7.x = min(max(u_xlat7.x, 0.0), 1.0);
#else
    u_xlat7.x = clamp(u_xlat7.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat3.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat10_4 = texture(_ShadowMapTexture, u_xlat3.xyz);
    u_xlat14 = dot(u_xlat10_4, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat21 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat16 = sqrt(u_xlat21);
    u_xlat16 = u_xlat16 * _LightPositionRange.w;
    u_xlat16 = u_xlat16 * _LightProjectionParams.w;
#ifdef UNITY_ADRENO_ES3
    u_xlatb14 = !!(u_xlat14<u_xlat16);
#else
    u_xlatb14 = u_xlat14<u_xlat16;
#endif
    u_xlat16_5.x = (u_xlatb14) ? _LightShadowData.x : 1.0;
    u_xlat16_5.x = u_xlat7.x + u_xlat16_5.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat7.x = u_xlat21 * _LightPos.w;
    u_xlat14 = inversesqrt(u_xlat21);
    u_xlat3.xyz = vec3(u_xlat14) * u_xlat3.xyz;
    u_xlat7.x = texture(_LightTextureB0, u_xlat7.xx).w;
    u_xlat7.x = u_xlat16_5.x * u_xlat7.x;
    u_xlat4.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat4.xyz;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat4.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat4.xyz = u_xlat4.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat14 = texture(_LightTexture0, u_xlat4.xyz, -8.0).w;
    u_xlat7.x = u_xlat14 * u_xlat7.x;
    u_xlat14 = u_xlat7.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat2.xyz = (-u_xlat2.xyz) * vec3(u_xlat21) + (-u_xlat3.xyz);
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat2.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat2.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot((-u_xlat3.xyz), u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat7.x = u_xlat7.x * u_xlat16_5.x;
    u_xlat1.xyz = u_xlat7.xxx * _LightColor.xyz;
    u_xlat16_5.x = max(u_xlat16_6, 0.0);
    u_xlat16_5.x = log2(u_xlat16_5.x);
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_26;
    u_xlat16_5.x = exp2(u_xlat16_5.x);
    u_xlat7.x = u_xlat14 * u_xlat16_5.x;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat7.x * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
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
uniform 	vec4 _LightPositionRange;
uniform 	vec4 _LightProjectionParams;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec3 u_xlat4;
lowp vec4 u_xlat10_4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_6;
vec3 u_xlat7;
float u_xlat14;
bool u_xlatb14;
float u_xlat16;
float u_xlat21;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat14 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat14 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat7.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat0.x = (-u_xlat7.z) * u_xlat0.x + u_xlat7.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat7.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat7.x = min(max(u_xlat7.x, 0.0), 1.0);
#else
    u_xlat7.x = clamp(u_xlat7.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat3.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat10_4 = texture(_ShadowMapTexture, u_xlat3.xyz);
    u_xlat14 = dot(u_xlat10_4, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat21 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat16 = sqrt(u_xlat21);
    u_xlat16 = u_xlat16 * _LightPositionRange.w;
    u_xlat16 = u_xlat16 * _LightProjectionParams.w;
#ifdef UNITY_ADRENO_ES3
    u_xlatb14 = !!(u_xlat14<u_xlat16);
#else
    u_xlatb14 = u_xlat14<u_xlat16;
#endif
    u_xlat16_5.x = (u_xlatb14) ? _LightShadowData.x : 1.0;
    u_xlat16_5.x = u_xlat7.x + u_xlat16_5.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat7.x = u_xlat21 * _LightPos.w;
    u_xlat14 = inversesqrt(u_xlat21);
    u_xlat3.xyz = vec3(u_xlat14) * u_xlat3.xyz;
    u_xlat7.x = texture(_LightTextureB0, u_xlat7.xx).w;
    u_xlat7.x = u_xlat16_5.x * u_xlat7.x;
    u_xlat4.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat4.xyz;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat4.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat4.xyz = u_xlat4.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat14 = texture(_LightTexture0, u_xlat4.xyz, -8.0).w;
    u_xlat7.x = u_xlat14 * u_xlat7.x;
    u_xlat14 = u_xlat7.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat14 = min(max(u_xlat14, 0.0), 1.0);
#else
    u_xlat14 = clamp(u_xlat14, 0.0, 1.0);
#endif
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat2.xyz = (-u_xlat2.xyz) * vec3(u_xlat21) + (-u_xlat3.xyz);
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat2.xyz;
    u_xlat16_5.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = u_xlat10_1.w * 128.0;
    u_xlat16_6 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_6 = inversesqrt(u_xlat16_6);
    u_xlat16_5.xyz = u_xlat16_5.xyz * vec3(u_xlat16_6);
    u_xlat16_6 = dot(u_xlat2.xyz, u_xlat16_5.xyz);
    u_xlat16_5.x = dot((-u_xlat3.xyz), u_xlat16_5.xyz);
    u_xlat16_5.x = max(u_xlat16_5.x, 0.0);
    u_xlat7.x = u_xlat7.x * u_xlat16_5.x;
    u_xlat1.xyz = u_xlat7.xxx * _LightColor.xyz;
    u_xlat16_5.x = max(u_xlat16_6, 0.0);
    u_xlat16_5.x = log2(u_xlat16_5.x);
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_26;
    u_xlat16_5.x = exp2(u_xlat16_5.x);
    u_xlat7.x = u_xlat14 * u_xlat16_5.x;
    u_xlat16_5.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat7.x * u_xlat16_5.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
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
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w)));
  atten_6 = tmpvar_15.w;
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  highp vec4 shadowVals_18;
  highp float mydist_19;
  mydist_19 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_20;
  tmpvar_20.w = 0.0;
  tmpvar_20.xyz = (tmpvar_13 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_20.xyz, 0.0);
  tmpvar_21 = tmpvar_22;
  shadowVals_18.x = dot (tmpvar_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_23;
  tmpvar_23.w = 0.0;
  tmpvar_23.xyz = (tmpvar_13 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_23.xyz, 0.0);
  tmpvar_24 = tmpvar_25;
  shadowVals_18.y = dot (tmpvar_24, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_26;
  tmpvar_26.w = 0.0;
  tmpvar_26.xyz = (tmpvar_13 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_26.xyz, 0.0);
  tmpvar_27 = tmpvar_28;
  shadowVals_18.z = dot (tmpvar_27, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_29;
  tmpvar_29.w = 0.0;
  tmpvar_29.xyz = (tmpvar_13 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_30;
  lowp vec4 tmpvar_31;
  tmpvar_31 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_29.xyz, 0.0);
  tmpvar_30 = tmpvar_31;
  shadowVals_18.w = dot (tmpvar_30, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_32;
  tmpvar_32 = lessThan (shadowVals_18, vec4(mydist_19));
  mediump vec4 tmpvar_33;
  tmpvar_33 = _LightShadowData.xxxx;
  mediump float tmpvar_34;
  if (tmpvar_32.x) {
    tmpvar_34 = tmpvar_33.x;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_32.y) {
    tmpvar_35 = tmpvar_33.y;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump float tmpvar_36;
  if (tmpvar_32.z) {
    tmpvar_36 = tmpvar_33.z;
  } else {
    tmpvar_36 = 1.0;
  };
  mediump float tmpvar_37;
  if (tmpvar_32.w) {
    tmpvar_37 = tmpvar_33.w;
  } else {
    tmpvar_37 = 1.0;
  };
  mediump vec4 tmpvar_38;
  tmpvar_38.x = tmpvar_34;
  tmpvar_38.y = tmpvar_35;
  tmpvar_38.z = tmpvar_36;
  tmpvar_38.w = tmpvar_37;
  mediump float tmpvar_39;
  tmpvar_39 = clamp ((dot (tmpvar_38, vec4(0.25, 0.25, 0.25, 0.25)) + tmpvar_16), 0.0, 1.0);
  atten_6 = (tmpvar_15.w * tmpvar_39);
  highp vec4 tmpvar_40;
  tmpvar_40.w = 1.0;
  tmpvar_40.xyz = tmpvar_10;
  highp vec4 tmpvar_41;
  tmpvar_41.w = -8.0;
  tmpvar_41.xyz = (unity_WorldToLight * tmpvar_40).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_41.xyz, -8.0).w);
  lowp vec4 tmpvar_42;
  highp vec2 P_43;
  P_43 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_42 = texture2D (_CameraNormalsTexture, P_43);
  nspec_5 = tmpvar_42;
  mediump vec3 tmpvar_44;
  tmpvar_44 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_45;
  tmpvar_45 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_45;
  mediump float tmpvar_46;
  tmpvar_46 = pow (max (0.0, dot (h_4, tmpvar_44)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_46;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_44)
  ) * atten_6));
  mediump vec3 rgb_47;
  rgb_47 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_47, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_48;
  tmpvar_48 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_48);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
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
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w)));
  atten_6 = tmpvar_15.w;
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  highp vec4 shadowVals_18;
  highp float mydist_19;
  mydist_19 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_20;
  tmpvar_20.w = 0.0;
  tmpvar_20.xyz = (tmpvar_13 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_20.xyz, 0.0);
  tmpvar_21 = tmpvar_22;
  shadowVals_18.x = dot (tmpvar_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_23;
  tmpvar_23.w = 0.0;
  tmpvar_23.xyz = (tmpvar_13 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_23.xyz, 0.0);
  tmpvar_24 = tmpvar_25;
  shadowVals_18.y = dot (tmpvar_24, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_26;
  tmpvar_26.w = 0.0;
  tmpvar_26.xyz = (tmpvar_13 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_26.xyz, 0.0);
  tmpvar_27 = tmpvar_28;
  shadowVals_18.z = dot (tmpvar_27, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_29;
  tmpvar_29.w = 0.0;
  tmpvar_29.xyz = (tmpvar_13 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_30;
  lowp vec4 tmpvar_31;
  tmpvar_31 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_29.xyz, 0.0);
  tmpvar_30 = tmpvar_31;
  shadowVals_18.w = dot (tmpvar_30, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_32;
  tmpvar_32 = lessThan (shadowVals_18, vec4(mydist_19));
  mediump vec4 tmpvar_33;
  tmpvar_33 = _LightShadowData.xxxx;
  mediump float tmpvar_34;
  if (tmpvar_32.x) {
    tmpvar_34 = tmpvar_33.x;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_32.y) {
    tmpvar_35 = tmpvar_33.y;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump float tmpvar_36;
  if (tmpvar_32.z) {
    tmpvar_36 = tmpvar_33.z;
  } else {
    tmpvar_36 = 1.0;
  };
  mediump float tmpvar_37;
  if (tmpvar_32.w) {
    tmpvar_37 = tmpvar_33.w;
  } else {
    tmpvar_37 = 1.0;
  };
  mediump vec4 tmpvar_38;
  tmpvar_38.x = tmpvar_34;
  tmpvar_38.y = tmpvar_35;
  tmpvar_38.z = tmpvar_36;
  tmpvar_38.w = tmpvar_37;
  mediump float tmpvar_39;
  tmpvar_39 = clamp ((dot (tmpvar_38, vec4(0.25, 0.25, 0.25, 0.25)) + tmpvar_16), 0.0, 1.0);
  atten_6 = (tmpvar_15.w * tmpvar_39);
  highp vec4 tmpvar_40;
  tmpvar_40.w = 1.0;
  tmpvar_40.xyz = tmpvar_10;
  highp vec4 tmpvar_41;
  tmpvar_41.w = -8.0;
  tmpvar_41.xyz = (unity_WorldToLight * tmpvar_40).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_41.xyz, -8.0).w);
  lowp vec4 tmpvar_42;
  highp vec2 P_43;
  P_43 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_42 = texture2D (_CameraNormalsTexture, P_43);
  nspec_5 = tmpvar_42;
  mediump vec3 tmpvar_44;
  tmpvar_44 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_45;
  tmpvar_45 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_45;
  mediump float tmpvar_46;
  tmpvar_46 = pow (max (0.0, dot (h_4, tmpvar_44)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_46;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_44)
  ) * atten_6));
  mediump vec3 rgb_47;
  rgb_47 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_47, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_48;
  tmpvar_48 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_48);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
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
uniform highp vec4 _LightPositionRange;
uniform highp vec4 _LightProjectionParams;
uniform mediump vec4 _LightShadowData;
uniform highp vec4 unity_ShadowFadeCenterAndType;
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp vec4 unity_LightmapFade;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraNormalsTexture;
uniform highp vec4 _CameraNormalsTexture_ST;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 res_2;
  highp float spec_3;
  mediump vec3 h_4;
  mediump vec4 nspec_5;
  highp float atten_6;
  mediump vec3 lightDir_7;
  highp vec2 tmpvar_8;
  tmpvar_8 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_8).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_10;
  tmpvar_10 = (unity_CameraToWorld * tmpvar_9).xyz;
  highp vec3 tmpvar_11;
  tmpvar_11 = (tmpvar_10 - unity_ShadowFadeCenterAndType.xyz);
  highp float tmpvar_12;
  tmpvar_12 = mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w);
  highp vec3 tmpvar_13;
  tmpvar_13 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_14;
  tmpvar_14 = -(normalize(tmpvar_13));
  lightDir_7 = tmpvar_14;
  highp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_LightTextureB0, vec2((dot (tmpvar_13, tmpvar_13) * _LightPos.w)));
  atten_6 = tmpvar_15.w;
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((tmpvar_12 * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  highp vec4 shadowVals_18;
  highp float mydist_19;
  mydist_19 = ((sqrt(
    dot (tmpvar_13, tmpvar_13)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_20;
  tmpvar_20.w = 0.0;
  tmpvar_20.xyz = (tmpvar_13 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_20.xyz, 0.0);
  tmpvar_21 = tmpvar_22;
  shadowVals_18.x = dot (tmpvar_21, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_23;
  tmpvar_23.w = 0.0;
  tmpvar_23.xyz = (tmpvar_13 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_23.xyz, 0.0);
  tmpvar_24 = tmpvar_25;
  shadowVals_18.y = dot (tmpvar_24, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_26;
  tmpvar_26.w = 0.0;
  tmpvar_26.xyz = (tmpvar_13 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_26.xyz, 0.0);
  tmpvar_27 = tmpvar_28;
  shadowVals_18.z = dot (tmpvar_27, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_29;
  tmpvar_29.w = 0.0;
  tmpvar_29.xyz = (tmpvar_13 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_30;
  lowp vec4 tmpvar_31;
  tmpvar_31 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_29.xyz, 0.0);
  tmpvar_30 = tmpvar_31;
  shadowVals_18.w = dot (tmpvar_30, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_32;
  tmpvar_32 = lessThan (shadowVals_18, vec4(mydist_19));
  mediump vec4 tmpvar_33;
  tmpvar_33 = _LightShadowData.xxxx;
  mediump float tmpvar_34;
  if (tmpvar_32.x) {
    tmpvar_34 = tmpvar_33.x;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_32.y) {
    tmpvar_35 = tmpvar_33.y;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump float tmpvar_36;
  if (tmpvar_32.z) {
    tmpvar_36 = tmpvar_33.z;
  } else {
    tmpvar_36 = 1.0;
  };
  mediump float tmpvar_37;
  if (tmpvar_32.w) {
    tmpvar_37 = tmpvar_33.w;
  } else {
    tmpvar_37 = 1.0;
  };
  mediump vec4 tmpvar_38;
  tmpvar_38.x = tmpvar_34;
  tmpvar_38.y = tmpvar_35;
  tmpvar_38.z = tmpvar_36;
  tmpvar_38.w = tmpvar_37;
  mediump float tmpvar_39;
  tmpvar_39 = clamp ((dot (tmpvar_38, vec4(0.25, 0.25, 0.25, 0.25)) + tmpvar_16), 0.0, 1.0);
  atten_6 = (tmpvar_15.w * tmpvar_39);
  highp vec4 tmpvar_40;
  tmpvar_40.w = 1.0;
  tmpvar_40.xyz = tmpvar_10;
  highp vec4 tmpvar_41;
  tmpvar_41.w = -8.0;
  tmpvar_41.xyz = (unity_WorldToLight * tmpvar_40).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_41.xyz, -8.0).w);
  lowp vec4 tmpvar_42;
  highp vec2 P_43;
  P_43 = ((tmpvar_8 * _CameraNormalsTexture_ST.xy) + _CameraNormalsTexture_ST.zw);
  tmpvar_42 = texture2D (_CameraNormalsTexture, P_43);
  nspec_5 = tmpvar_42;
  mediump vec3 tmpvar_44;
  tmpvar_44 = normalize(((nspec_5.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_45;
  tmpvar_45 = normalize((lightDir_7 - normalize(
    (tmpvar_10 - _WorldSpaceCameraPos)
  )));
  h_4 = tmpvar_45;
  mediump float tmpvar_46;
  tmpvar_46 = pow (max (0.0, dot (h_4, tmpvar_44)), (nspec_5.w * 128.0));
  spec_3 = tmpvar_46;
  spec_3 = (spec_3 * clamp (atten_6, 0.0, 1.0));
  res_2.xyz = (_LightColor.xyz * (max (0.0, 
    dot (lightDir_7, tmpvar_44)
  ) * atten_6));
  mediump vec3 rgb_47;
  rgb_47 = _LightColor.xyz;
  res_2.w = (spec_3 * dot (rgb_47, vec3(0.22, 0.707, 0.071)));
  highp float tmpvar_48;
  tmpvar_48 = clamp ((1.0 - (
    (tmpvar_12 * unity_LightmapFade.z)
   + unity_LightmapFade.w)), 0.0, 1.0);
  res_2 = (res_2 * tmpvar_48);
  tmpvar_1 = res_2;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
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
uniform 	vec4 _LightPositionRange;
uniform 	vec4 _LightProjectionParams;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec4 u_xlat4;
lowp vec4 u_xlat10_4;
bvec4 u_xlatb4;
vec3 u_xlat5;
lowp vec4 u_xlat10_5;
mediump vec3 u_xlat16_6;
mediump float u_xlat16_7;
vec3 u_xlat8;
float u_xlat16;
float u_xlat24;
mediump float u_xlat16_30;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat16 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat16 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat8.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat8.xyz = u_xlat8.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat8.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat4.xyz = u_xlat3.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
    u_xlat10_4 = textureLod(_ShadowMapTexture, u_xlat4.xyz, 0.0);
    u_xlat4.x = dot(u_xlat10_4, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat5.xyz = u_xlat3.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
    u_xlat10_5 = textureLod(_ShadowMapTexture, u_xlat5.xyz, 0.0);
    u_xlat4.y = dot(u_xlat10_5, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat5.xyz = u_xlat3.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
    u_xlat10_5 = textureLod(_ShadowMapTexture, u_xlat5.xyz, 0.0);
    u_xlat4.z = dot(u_xlat10_5, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat5.xyz = u_xlat3.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
    u_xlat10_5 = textureLod(_ShadowMapTexture, u_xlat5.xyz, 0.0);
    u_xlat4.w = dot(u_xlat10_5, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat8.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat16 = sqrt(u_xlat8.x);
    u_xlat16 = u_xlat16 * _LightPositionRange.w;
    u_xlat16 = u_xlat16 * _LightProjectionParams.w;
    u_xlatb4 = lessThan(u_xlat4, vec4(u_xlat16));
    u_xlat4.x = (u_xlatb4.x) ? _LightShadowData.x : float(1.0);
    u_xlat4.y = (u_xlatb4.y) ? _LightShadowData.x : float(1.0);
    u_xlat4.z = (u_xlatb4.z) ? _LightShadowData.x : float(1.0);
    u_xlat4.w = (u_xlatb4.w) ? _LightShadowData.x : float(1.0);
    u_xlat16_6.x = dot(u_xlat4, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat4.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat16 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat16 = sqrt(u_xlat16);
    u_xlat0.x = (-u_xlat8.z) * u_xlat0.x + u_xlat16;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat16 = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat16 = min(max(u_xlat16, 0.0), 1.0);
#else
    u_xlat16 = clamp(u_xlat16, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat16_6.x = u_xlat16 + u_xlat16_6.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_6.x = min(max(u_xlat16_6.x, 0.0), 1.0);
#else
    u_xlat16_6.x = clamp(u_xlat16_6.x, 0.0, 1.0);
#endif
    u_xlat16 = u_xlat8.x * _LightPos.w;
    u_xlat8.x = inversesqrt(u_xlat8.x);
    u_xlat3.xyz = u_xlat8.xxx * u_xlat3.xyz;
    u_xlat8.x = texture(_LightTextureB0, vec2(u_xlat16)).w;
    u_xlat8.x = u_xlat16_6.x * u_xlat8.x;
    u_xlat4.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat4.xyz;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat4.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat4.xyz = u_xlat4.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat16 = texture(_LightTexture0, u_xlat4.xyz, -8.0).w;
    u_xlat8.x = u_xlat16 * u_xlat8.x;
    u_xlat16 = u_xlat8.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16 = min(max(u_xlat16, 0.0), 1.0);
#else
    u_xlat16 = clamp(u_xlat16, 0.0, 1.0);
#endif
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = (-u_xlat2.xyz) * vec3(u_xlat24) + (-u_xlat3.xyz);
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat2.xyz;
    u_xlat16_6.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_30 = u_xlat10_1.w * 128.0;
    u_xlat16_7 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_7 = inversesqrt(u_xlat16_7);
    u_xlat16_6.xyz = u_xlat16_6.xyz * vec3(u_xlat16_7);
    u_xlat16_7 = dot(u_xlat2.xyz, u_xlat16_6.xyz);
    u_xlat16_6.x = dot((-u_xlat3.xyz), u_xlat16_6.xyz);
    u_xlat16_6.x = max(u_xlat16_6.x, 0.0);
    u_xlat8.x = u_xlat8.x * u_xlat16_6.x;
    u_xlat1.xyz = u_xlat8.xxx * _LightColor.xyz;
    u_xlat16_6.x = max(u_xlat16_7, 0.0);
    u_xlat16_6.x = log2(u_xlat16_6.x);
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_30;
    u_xlat16_6.x = exp2(u_xlat16_6.x);
    u_xlat8.x = u_xlat16 * u_xlat16_6.x;
    u_xlat16_6.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat8.x * u_xlat16_6.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
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
uniform 	vec4 _LightPositionRange;
uniform 	vec4 _LightProjectionParams;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec4 u_xlat4;
lowp vec4 u_xlat10_4;
bvec4 u_xlatb4;
vec3 u_xlat5;
lowp vec4 u_xlat10_5;
mediump vec3 u_xlat16_6;
mediump float u_xlat16_7;
vec3 u_xlat8;
float u_xlat16;
float u_xlat24;
mediump float u_xlat16_30;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat16 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat16 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat8.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat8.xyz = u_xlat8.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat8.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat4.xyz = u_xlat3.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
    u_xlat10_4 = textureLod(_ShadowMapTexture, u_xlat4.xyz, 0.0);
    u_xlat4.x = dot(u_xlat10_4, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat5.xyz = u_xlat3.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
    u_xlat10_5 = textureLod(_ShadowMapTexture, u_xlat5.xyz, 0.0);
    u_xlat4.y = dot(u_xlat10_5, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat5.xyz = u_xlat3.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
    u_xlat10_5 = textureLod(_ShadowMapTexture, u_xlat5.xyz, 0.0);
    u_xlat4.z = dot(u_xlat10_5, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat5.xyz = u_xlat3.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
    u_xlat10_5 = textureLod(_ShadowMapTexture, u_xlat5.xyz, 0.0);
    u_xlat4.w = dot(u_xlat10_5, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat8.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat16 = sqrt(u_xlat8.x);
    u_xlat16 = u_xlat16 * _LightPositionRange.w;
    u_xlat16 = u_xlat16 * _LightProjectionParams.w;
    u_xlatb4 = lessThan(u_xlat4, vec4(u_xlat16));
    u_xlat4.x = (u_xlatb4.x) ? _LightShadowData.x : float(1.0);
    u_xlat4.y = (u_xlatb4.y) ? _LightShadowData.x : float(1.0);
    u_xlat4.z = (u_xlatb4.z) ? _LightShadowData.x : float(1.0);
    u_xlat4.w = (u_xlatb4.w) ? _LightShadowData.x : float(1.0);
    u_xlat16_6.x = dot(u_xlat4, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat4.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat16 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat16 = sqrt(u_xlat16);
    u_xlat0.x = (-u_xlat8.z) * u_xlat0.x + u_xlat16;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat16 = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat16 = min(max(u_xlat16, 0.0), 1.0);
#else
    u_xlat16 = clamp(u_xlat16, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat16_6.x = u_xlat16 + u_xlat16_6.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_6.x = min(max(u_xlat16_6.x, 0.0), 1.0);
#else
    u_xlat16_6.x = clamp(u_xlat16_6.x, 0.0, 1.0);
#endif
    u_xlat16 = u_xlat8.x * _LightPos.w;
    u_xlat8.x = inversesqrt(u_xlat8.x);
    u_xlat3.xyz = u_xlat8.xxx * u_xlat3.xyz;
    u_xlat8.x = texture(_LightTextureB0, vec2(u_xlat16)).w;
    u_xlat8.x = u_xlat16_6.x * u_xlat8.x;
    u_xlat4.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat4.xyz;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat4.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat4.xyz = u_xlat4.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat16 = texture(_LightTexture0, u_xlat4.xyz, -8.0).w;
    u_xlat8.x = u_xlat16 * u_xlat8.x;
    u_xlat16 = u_xlat8.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16 = min(max(u_xlat16, 0.0), 1.0);
#else
    u_xlat16 = clamp(u_xlat16, 0.0, 1.0);
#endif
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = (-u_xlat2.xyz) * vec3(u_xlat24) + (-u_xlat3.xyz);
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat2.xyz;
    u_xlat16_6.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_30 = u_xlat10_1.w * 128.0;
    u_xlat16_7 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_7 = inversesqrt(u_xlat16_7);
    u_xlat16_6.xyz = u_xlat16_6.xyz * vec3(u_xlat16_7);
    u_xlat16_7 = dot(u_xlat2.xyz, u_xlat16_6.xyz);
    u_xlat16_6.x = dot((-u_xlat3.xyz), u_xlat16_6.xyz);
    u_xlat16_6.x = max(u_xlat16_6.x, 0.0);
    u_xlat8.x = u_xlat8.x * u_xlat16_6.x;
    u_xlat1.xyz = u_xlat8.xxx * _LightColor.xyz;
    u_xlat16_6.x = max(u_xlat16_7, 0.0);
    u_xlat16_6.x = log2(u_xlat16_6.x);
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_30;
    u_xlat16_6.x = exp2(u_xlat16_6.x);
    u_xlat8.x = u_xlat16 * u_xlat16_6.x;
    u_xlat16_6.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat8.x * u_xlat16_6.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
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
uniform 	vec4 _LightPositionRange;
uniform 	vec4 _LightProjectionParams;
uniform 	mediump vec4 _LightShadowData;
uniform 	vec4 unity_ShadowFadeCenterAndType;
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 unity_LightmapFade;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _CameraNormalsTexture_ST;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraNormalsTexture;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec4 u_xlat4;
lowp vec4 u_xlat10_4;
bvec4 u_xlatb4;
vec3 u_xlat5;
lowp vec4 u_xlat10_5;
mediump vec3 u_xlat16_6;
mediump float u_xlat16_7;
vec3 u_xlat8;
float u_xlat16;
float u_xlat24;
mediump float u_xlat16_30;
void main()
{
    u_xlat0.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat16 = texture(_CameraDepthTexture, u_xlat0.xy).x;
    u_xlat0.xy = u_xlat0.xy * _CameraNormalsTexture_ST.xy + _CameraNormalsTexture_ST.zw;
    u_xlat10_1 = texture(_CameraNormalsTexture, u_xlat0.xy);
    u_xlat0.x = _ZBufferParams.x * u_xlat16 + _ZBufferParams.y;
    u_xlat0.x = float(1.0) / u_xlat0.x;
    u_xlat8.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat8.xyz = u_xlat8.xxx * vs_TEXCOORD1.xyz;
    u_xlat2.xyz = u_xlat0.xxx * u_xlat8.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat4.xyz = u_xlat3.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
    u_xlat10_4 = textureLod(_ShadowMapTexture, u_xlat4.xyz, 0.0);
    u_xlat4.x = dot(u_xlat10_4, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat5.xyz = u_xlat3.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
    u_xlat10_5 = textureLod(_ShadowMapTexture, u_xlat5.xyz, 0.0);
    u_xlat4.y = dot(u_xlat10_5, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat5.xyz = u_xlat3.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
    u_xlat10_5 = textureLod(_ShadowMapTexture, u_xlat5.xyz, 0.0);
    u_xlat4.z = dot(u_xlat10_5, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat5.xyz = u_xlat3.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
    u_xlat10_5 = textureLod(_ShadowMapTexture, u_xlat5.xyz, 0.0);
    u_xlat4.w = dot(u_xlat10_5, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat8.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat16 = sqrt(u_xlat8.x);
    u_xlat16 = u_xlat16 * _LightPositionRange.w;
    u_xlat16 = u_xlat16 * _LightProjectionParams.w;
    u_xlatb4 = lessThan(u_xlat4, vec4(u_xlat16));
    u_xlat4.x = (u_xlatb4.x) ? _LightShadowData.x : float(1.0);
    u_xlat4.y = (u_xlatb4.y) ? _LightShadowData.x : float(1.0);
    u_xlat4.z = (u_xlatb4.z) ? _LightShadowData.x : float(1.0);
    u_xlat4.w = (u_xlatb4.w) ? _LightShadowData.x : float(1.0);
    u_xlat16_6.x = dot(u_xlat4, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat4.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat16 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat16 = sqrt(u_xlat16);
    u_xlat0.x = (-u_xlat8.z) * u_xlat0.x + u_xlat16;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat16 = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat16 = min(max(u_xlat16, 0.0), 1.0);
#else
    u_xlat16 = clamp(u_xlat16, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat0.x * unity_LightmapFade.z + unity_LightmapFade.w;
    u_xlat0.x = (-u_xlat0.x) + 1.0;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat16_6.x = u_xlat16 + u_xlat16_6.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_6.x = min(max(u_xlat16_6.x, 0.0), 1.0);
#else
    u_xlat16_6.x = clamp(u_xlat16_6.x, 0.0, 1.0);
#endif
    u_xlat16 = u_xlat8.x * _LightPos.w;
    u_xlat8.x = inversesqrt(u_xlat8.x);
    u_xlat3.xyz = u_xlat8.xxx * u_xlat3.xyz;
    u_xlat8.x = texture(_LightTextureB0, vec2(u_xlat16)).w;
    u_xlat8.x = u_xlat16_6.x * u_xlat8.x;
    u_xlat4.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat4.xyz;
    u_xlat4.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat4.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat4.xyz = u_xlat4.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat16 = texture(_LightTexture0, u_xlat4.xyz, -8.0).w;
    u_xlat8.x = u_xlat16 * u_xlat8.x;
    u_xlat16 = u_xlat8.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16 = min(max(u_xlat16, 0.0), 1.0);
#else
    u_xlat16 = clamp(u_xlat16, 0.0, 1.0);
#endif
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = (-u_xlat2.xyz) * vec3(u_xlat24) + (-u_xlat3.xyz);
    u_xlat24 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat24 = inversesqrt(u_xlat24);
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat2.xyz;
    u_xlat16_6.xyz = u_xlat10_1.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_30 = u_xlat10_1.w * 128.0;
    u_xlat16_7 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_7 = inversesqrt(u_xlat16_7);
    u_xlat16_6.xyz = u_xlat16_6.xyz * vec3(u_xlat16_7);
    u_xlat16_7 = dot(u_xlat2.xyz, u_xlat16_6.xyz);
    u_xlat16_6.x = dot((-u_xlat3.xyz), u_xlat16_6.xyz);
    u_xlat16_6.x = max(u_xlat16_6.x, 0.0);
    u_xlat8.x = u_xlat8.x * u_xlat16_6.x;
    u_xlat1.xyz = u_xlat8.xxx * _LightColor.xyz;
    u_xlat16_6.x = max(u_xlat16_7, 0.0);
    u_xlat16_6.x = log2(u_xlat16_6.x);
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_30;
    u_xlat16_6.x = exp2(u_xlat16_6.x);
    u_xlat8.x = u_xlat16 * u_xlat16_6.x;
    u_xlat16_6.x = dot(_LightColor.xyz, vec3(0.219999999, 0.707000017, 0.0710000023));
    u_xlat1.w = u_xlat8.x * u_xlat16_6.x;
    u_xlat0 = u_xlat0.xxxx * u_xlat1;
    SV_Target0 = u_xlat0;
    return;
}

#endif
"
}
}
Program "fp" {
SubProgram "gles hw_tier00 " {
Keywords { "POINT" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "POINT" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "DIRECTIONAL" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "DIRECTIONAL" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "DIRECTIONAL" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "DIRECTIONAL" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "SPOT" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "SPOT" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "SPOT" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SPOT" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SPOT" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SPOT" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT_COOKIE" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT_COOKIE" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT_COOKIE" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "POINT_COOKIE" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT_COOKIE" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT_COOKIE" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "DIRECTIONAL_COOKIE" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "DIRECTIONAL_COOKIE" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT" "SHADOWS_CUBE" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "POINT" "SHADOWS_CUBE" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" }
""
}
}
}
}
}