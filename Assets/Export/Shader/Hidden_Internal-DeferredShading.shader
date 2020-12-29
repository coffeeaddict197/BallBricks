//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Hidden/Internal-DeferredShading" {
Properties {
_LightTexture0 ("", any) = "" { }
_LightTextureB0 ("", 2D) = "" { }
_ShadowMapTexture ("", any) = "" { }
_SrcBlend ("", Float) = 1
_DstBlend ("", Float) = 1
}
SubShader {
 Pass {
  Tags { "SHADOWSUPPORT" = "true" }
  ZWrite Off
  GpuProgramID 293
Program "vp" {
SubProgram "gles " {
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  tmpvar_11 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_7 = tmpvar_12;
  atten_6 = texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w))).w;
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_15;
  mediump vec3 tmpvar_16;
  tmpvar_16 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_17;
  tmpvar_17 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_18;
  viewDir_18 = -(tmpvar_17);
  mediump vec2 tmpvar_19;
  tmpvar_19.x = dot ((viewDir_18 - (2.0 * 
    (dot (tmpvar_16, viewDir_18) * tmpvar_16)
  )), lightDir_7);
  tmpvar_19.y = (1.0 - clamp (dot (tmpvar_16, viewDir_18), 0.0, 1.0));
  mediump float specular_20;
  mediump vec2 tmpvar_21;
  tmpvar_21.x = ((tmpvar_19 * tmpvar_19) * (tmpvar_19 * tmpvar_19)).x;
  tmpvar_21.y = (1.0 - gbuffer1_3.w);
  highp float tmpvar_22;
  tmpvar_22 = (texture2D (unity_NHxRoughness, tmpvar_21).w * 16.0);
  specular_20 = tmpvar_22;
  mediump vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = ((gbuffer0_4.xyz + (specular_20 * gbuffer1_3.xyz)) * (tmpvar_5 * clamp (
    dot (tmpvar_16, lightDir_7)
  , 0.0, 1.0)));
  mediump vec4 tmpvar_24;
  tmpvar_24 = exp2(-(tmpvar_23));
  tmpvar_1 = tmpvar_24;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 " {
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
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform highp sampler2D unity_NHxRoughness;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
lowp vec4 u_xlat10_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
lowp vec3 u_xlat10_3;
mediump vec3 u_xlat16_4;
mediump vec3 u_xlat16_5;
float u_xlat13;
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
    u_xlat0.xyz = vec3(u_xlat18) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat0.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat18 = inversesqrt(u_xlat18);
    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
    u_xlat10_3.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_4.xyz = u_xlat10_3.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat16_22 = dot((-u_xlat2.xyz), u_xlat16_4.xyz);
    u_xlat16_22 = u_xlat16_22 + u_xlat16_22;
    u_xlat16_5.xyz = u_xlat16_4.xyz * (-vec3(u_xlat16_22)) + (-u_xlat2.xyz);
    u_xlat18 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat13 = inversesqrt(u_xlat18);
    u_xlat18 = u_xlat18 * _LightPos.w;
    u_xlat18 = texture(_LightTextureB0, vec2(u_xlat18)).w;
    u_xlat2.xyz = vec3(u_xlat18) * _LightColor.xyz;
    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat13);
    u_xlat16_22 = dot(u_xlat16_5.xyz, (-u_xlat0.xyz));
    u_xlat16_4.x = dot(u_xlat16_4.xyz, (-u_xlat0.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_4.xyz = u_xlat2.xyz * u_xlat16_4.xxx;
    u_xlat16_22 = u_xlat16_22 * u_xlat16_22;
    u_xlat16_5.x = u_xlat16_22 * u_xlat16_22;
    u_xlat10_0 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_5.y = (-u_xlat10_0.w) + 1.0;
    u_xlat18 = texture(unity_NHxRoughness, u_xlat16_5.xy).w;
    u_xlat18 = u_xlat18 * 16.0;
    u_xlat16_5.xyz = vec3(u_xlat18) * u_xlat10_0.xyz + u_xlat10_1.xyz;
    u_xlat16_0.xyz = u_xlat16_4.xyz * u_xlat16_5.xyz;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
    return;
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp sampler2D _LightTextureB0;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  tmpvar_11 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_7 = tmpvar_12;
  atten_6 = texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w))).w;
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_15;
  mediump vec3 tmpvar_16;
  tmpvar_16 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_17;
  tmpvar_17 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_18;
  viewDir_18 = -(tmpvar_17);
  mediump float specularTerm_19;
  mediump vec3 tmpvar_20;
  mediump vec3 inVec_21;
  inVec_21 = (lightDir_7 + viewDir_18);
  tmpvar_20 = (inVec_21 * inversesqrt(max (0.001, 
    dot (inVec_21, inVec_21)
  )));
  mediump float tmpvar_22;
  tmpvar_22 = clamp (dot (tmpvar_16, tmpvar_20), 0.0, 1.0);
  mediump float tmpvar_23;
  tmpvar_23 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_24;
  tmpvar_24 = (tmpvar_23 * tmpvar_23);
  specularTerm_19 = ((tmpvar_24 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_20), 0.0, 1.0)) * (1.5 + tmpvar_24))
   * 
    (((tmpvar_22 * tmpvar_22) * ((tmpvar_24 * tmpvar_24) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_25;
  tmpvar_25 = clamp (specularTerm_19, 0.0, 100.0);
  specularTerm_19 = tmpvar_25;
  mediump vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_25 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_16, lightDir_7), 0.0, 1.0));
  mediump vec4 tmpvar_27;
  tmpvar_27 = exp2(-(tmpvar_26));
  tmpvar_1 = tmpvar_27;
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp sampler2D _LightTextureB0;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  tmpvar_11 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_7 = tmpvar_12;
  atten_6 = texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w))).w;
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_15;
  mediump vec3 tmpvar_16;
  tmpvar_16 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_17;
  tmpvar_17 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_18;
  viewDir_18 = -(tmpvar_17);
  mediump float specularTerm_19;
  mediump vec3 tmpvar_20;
  mediump vec3 inVec_21;
  inVec_21 = (lightDir_7 + viewDir_18);
  tmpvar_20 = (inVec_21 * inversesqrt(max (0.001, 
    dot (inVec_21, inVec_21)
  )));
  mediump float tmpvar_22;
  tmpvar_22 = clamp (dot (tmpvar_16, tmpvar_20), 0.0, 1.0);
  mediump float tmpvar_23;
  tmpvar_23 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_24;
  tmpvar_24 = (tmpvar_23 * tmpvar_23);
  specularTerm_19 = ((tmpvar_24 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_20), 0.0, 1.0)) * (1.5 + tmpvar_24))
   * 
    (((tmpvar_22 * tmpvar_22) * ((tmpvar_24 * tmpvar_24) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_25;
  tmpvar_25 = clamp (specularTerm_19, 0.0, 100.0);
  specularTerm_19 = tmpvar_25;
  mediump vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_25 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_16, lightDir_7), 0.0, 1.0));
  mediump vec4 tmpvar_27;
  tmpvar_27 = exp2(-(tmpvar_26));
  tmpvar_1 = tmpvar_27;
  gl_FragData[0] = tmpvar_1;
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
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec4 u_xlat16_4;
lowp vec3 u_xlat10_5;
mediump vec3 u_xlat16_6;
mediump float u_xlat16_11;
float u_xlat15;
mediump float u_xlat16_15;
float u_xlat21;
mediump float u_xlat16_21;
float u_xlat22;
mediump float u_xlat16_25;
mediump float u_xlat16_27;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat21 = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat21 = float(1.0) / u_xlat21;
    u_xlat0.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat0.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat22 = inversesqrt(u_xlat15);
    u_xlat15 = u_xlat15 * _LightPos.w;
    u_xlat15 = texture(_LightTextureB0, vec2(u_xlat15)).w;
    u_xlat3.xyz = vec3(u_xlat15) * _LightColor.xyz;
    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat22);
    u_xlat16_4.xyz = (-u_xlat2.xyz) * vec3(u_xlat21) + (-u_xlat0.xyz);
    u_xlat16_25 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_21 = max(u_xlat16_25, 0.00100000005);
    u_xlat16_25 = inversesqrt(u_xlat16_21);
    u_xlat16_4.xyz = vec3(u_xlat16_25) * u_xlat16_4.xyz;
    u_xlat16_25 = dot((-u_xlat0.xyz), u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_25 = min(max(u_xlat16_25, 0.0), 1.0);
#else
    u_xlat16_25 = clamp(u_xlat16_25, 0.0, 1.0);
#endif
    u_xlat16_21 = max(u_xlat16_25, 0.319999993);
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat16_25 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_15 = u_xlat16_25 * u_xlat16_25 + 1.5;
    u_xlat16_25 = u_xlat16_25 * u_xlat16_25;
    u_xlat16_21 = u_xlat16_21 * u_xlat16_15;
    u_xlat10_5.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_5.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_27 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_27 = inversesqrt(u_xlat16_27);
    u_xlat16_6.xyz = vec3(u_xlat16_27) * u_xlat16_6.xyz;
    u_xlat16_4.x = dot(u_xlat16_6.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_11 = dot(u_xlat16_6.xyz, (-u_xlat0.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_11 = min(max(u_xlat16_11, 0.0), 1.0);
#else
    u_xlat16_11 = clamp(u_xlat16_11, 0.0, 1.0);
#endif
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_4.x;
    u_xlat16_0.x = u_xlat16_25 * u_xlat16_25 + -1.0;
    u_xlat16_0.x = u_xlat16_4.x * u_xlat16_0.x + 1.00001001;
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_21;
    u_xlat16_0.x = u_xlat16_25 / u_xlat16_0.x;
    u_xlat16_0.x = u_xlat16_0.x + -9.99999975e-05;
    u_xlat16_4.x = max(u_xlat16_0.x, 0.0);
    u_xlat16_4.x = min(u_xlat16_4.x, 100.0);
    u_xlat16_4.xzw = u_xlat16_4.xxx * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat16_4.xzw = u_xlat3.xyz * u_xlat16_4.xzw;
    u_xlat16_0.xyz = vec3(u_xlat16_11) * u_xlat16_4.xzw;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
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
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec4 u_xlat16_4;
lowp vec3 u_xlat10_5;
mediump vec3 u_xlat16_6;
mediump float u_xlat16_11;
float u_xlat15;
mediump float u_xlat16_15;
float u_xlat21;
mediump float u_xlat16_21;
float u_xlat22;
mediump float u_xlat16_25;
mediump float u_xlat16_27;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat21 = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat21 = float(1.0) / u_xlat21;
    u_xlat0.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat0.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat22 = inversesqrt(u_xlat15);
    u_xlat15 = u_xlat15 * _LightPos.w;
    u_xlat15 = texture(_LightTextureB0, vec2(u_xlat15)).w;
    u_xlat3.xyz = vec3(u_xlat15) * _LightColor.xyz;
    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat22);
    u_xlat16_4.xyz = (-u_xlat2.xyz) * vec3(u_xlat21) + (-u_xlat0.xyz);
    u_xlat16_25 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_21 = max(u_xlat16_25, 0.00100000005);
    u_xlat16_25 = inversesqrt(u_xlat16_21);
    u_xlat16_4.xyz = vec3(u_xlat16_25) * u_xlat16_4.xyz;
    u_xlat16_25 = dot((-u_xlat0.xyz), u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_25 = min(max(u_xlat16_25, 0.0), 1.0);
#else
    u_xlat16_25 = clamp(u_xlat16_25, 0.0, 1.0);
#endif
    u_xlat16_21 = max(u_xlat16_25, 0.319999993);
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat16_25 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_15 = u_xlat16_25 * u_xlat16_25 + 1.5;
    u_xlat16_25 = u_xlat16_25 * u_xlat16_25;
    u_xlat16_21 = u_xlat16_21 * u_xlat16_15;
    u_xlat10_5.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_5.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_27 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_27 = inversesqrt(u_xlat16_27);
    u_xlat16_6.xyz = vec3(u_xlat16_27) * u_xlat16_6.xyz;
    u_xlat16_4.x = dot(u_xlat16_6.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_11 = dot(u_xlat16_6.xyz, (-u_xlat0.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_11 = min(max(u_xlat16_11, 0.0), 1.0);
#else
    u_xlat16_11 = clamp(u_xlat16_11, 0.0, 1.0);
#endif
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_4.x;
    u_xlat16_0.x = u_xlat16_25 * u_xlat16_25 + -1.0;
    u_xlat16_0.x = u_xlat16_4.x * u_xlat16_0.x + 1.00001001;
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_21;
    u_xlat16_0.x = u_xlat16_25 / u_xlat16_0.x;
    u_xlat16_0.x = u_xlat16_0.x + -9.99999975e-05;
    u_xlat16_4.x = max(u_xlat16_0.x, 0.0);
    u_xlat16_4.x = min(u_xlat16_4.x, 100.0);
    u_xlat16_4.xzw = u_xlat16_4.xxx * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat16_4.xzw = u_xlat3.xyz * u_xlat16_4.xzw;
    u_xlat16_0.xyz = vec3(u_xlat16_11) * u_xlat16_4.xzw;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
    return;
}

#endif
"
}
SubProgram "gles " {
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_9;
  tmpvar_5 = _LightColor.xyz;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_4 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_3 = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_2 = tmpvar_12;
  mediump vec3 tmpvar_13;
  tmpvar_13 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(((unity_CameraToWorld * tmpvar_8).xyz - _WorldSpaceCameraPos));
  mediump vec3 viewDir_15;
  viewDir_15 = -(tmpvar_14);
  mediump vec2 tmpvar_16;
  tmpvar_16.x = dot ((viewDir_15 - (2.0 * 
    (dot (tmpvar_13, viewDir_15) * tmpvar_13)
  )), lightDir_6);
  tmpvar_16.y = (1.0 - clamp (dot (tmpvar_13, viewDir_15), 0.0, 1.0));
  mediump float specular_17;
  mediump vec2 tmpvar_18;
  tmpvar_18.x = ((tmpvar_16 * tmpvar_16) * (tmpvar_16 * tmpvar_16)).x;
  tmpvar_18.y = (1.0 - gbuffer1_3.w);
  highp float tmpvar_19;
  tmpvar_19 = (texture2D (unity_NHxRoughness, tmpvar_18).w * 16.0);
  specular_17 = tmpvar_19;
  mediump vec4 tmpvar_20;
  tmpvar_20.w = 1.0;
  tmpvar_20.xyz = ((gbuffer0_4.xyz + (specular_17 * gbuffer1_3.xyz)) * (tmpvar_5 * clamp (
    dot (tmpvar_13, lightDir_6)
  , 0.0, 1.0)));
  mediump vec4 tmpvar_21;
  tmpvar_21 = exp2(-(tmpvar_20));
  tmpvar_1 = tmpvar_21;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 " {
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
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform highp sampler2D unity_NHxRoughness;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
lowp vec4 u_xlat10_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
lowp vec3 u_xlat10_2;
mediump vec3 u_xlat16_3;
mediump vec3 u_xlat16_4;
float u_xlat15;
mediump float u_xlat16_18;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat15 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat15 = _ZBufferParams.x * u_xlat15 + _ZBufferParams.y;
    u_xlat15 = float(1.0) / u_xlat15;
    u_xlat0.xyz = vec3(u_xlat15) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat0.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat15 = inversesqrt(u_xlat15);
    u_xlat0.xyz = vec3(u_xlat15) * u_xlat0.xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_3.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_18 = dot(u_xlat16_3.xyz, u_xlat16_3.xyz);
    u_xlat16_18 = inversesqrt(u_xlat16_18);
    u_xlat16_3.xyz = vec3(u_xlat16_18) * u_xlat16_3.xyz;
    u_xlat16_18 = dot((-u_xlat0.xyz), u_xlat16_3.xyz);
    u_xlat16_18 = u_xlat16_18 + u_xlat16_18;
    u_xlat16_4.xyz = u_xlat16_3.xyz * (-vec3(u_xlat16_18)) + (-u_xlat0.xyz);
    u_xlat16_3.x = dot(u_xlat16_3.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.x = min(max(u_xlat16_3.x, 0.0), 1.0);
#else
    u_xlat16_3.x = clamp(u_xlat16_3.x, 0.0, 1.0);
#endif
    u_xlat16_3.xyz = u_xlat16_3.xxx * _LightColor.xyz;
    u_xlat16_18 = dot(u_xlat16_4.xyz, (-_LightDir.xyz));
    u_xlat16_18 = u_xlat16_18 * u_xlat16_18;
    u_xlat16_4.x = u_xlat16_18 * u_xlat16_18;
    u_xlat10_0 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_4.y = (-u_xlat10_0.w) + 1.0;
    u_xlat15 = texture(unity_NHxRoughness, u_xlat16_4.xy).w;
    u_xlat15 = u_xlat15 * 16.0;
    u_xlat16_4.xyz = vec3(u_xlat15) * u_xlat10_0.xyz + u_xlat10_1.xyz;
    u_xlat16_0.xyz = u_xlat16_3.xyz * u_xlat16_4.xyz;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
    return;
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_9;
  tmpvar_5 = _LightColor.xyz;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_4 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_3 = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_2 = tmpvar_12;
  mediump vec3 tmpvar_13;
  tmpvar_13 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(((unity_CameraToWorld * tmpvar_8).xyz - _WorldSpaceCameraPos));
  mediump vec3 viewDir_15;
  viewDir_15 = -(tmpvar_14);
  mediump float specularTerm_16;
  mediump vec3 tmpvar_17;
  mediump vec3 inVec_18;
  inVec_18 = (lightDir_6 + viewDir_15);
  tmpvar_17 = (inVec_18 * inversesqrt(max (0.001, 
    dot (inVec_18, inVec_18)
  )));
  mediump float tmpvar_19;
  tmpvar_19 = clamp (dot (tmpvar_13, tmpvar_17), 0.0, 1.0);
  mediump float tmpvar_20;
  tmpvar_20 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_21;
  tmpvar_21 = (tmpvar_20 * tmpvar_20);
  specularTerm_16 = ((tmpvar_21 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_17), 0.0, 1.0)) * (1.5 + tmpvar_21))
   * 
    (((tmpvar_19 * tmpvar_19) * ((tmpvar_21 * tmpvar_21) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_22;
  tmpvar_22 = clamp (specularTerm_16, 0.0, 100.0);
  specularTerm_16 = tmpvar_22;
  mediump vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_22 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_13, lightDir_6), 0.0, 1.0));
  mediump vec4 tmpvar_24;
  tmpvar_24 = exp2(-(tmpvar_23));
  tmpvar_1 = tmpvar_24;
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
  mediump vec3 lightDir_6;
  highp vec2 tmpvar_7;
  tmpvar_7 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_8;
  tmpvar_8.w = 1.0;
  tmpvar_8.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_7).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_9;
  tmpvar_9 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_9;
  tmpvar_5 = _LightColor.xyz;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_4 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_3 = tmpvar_11;
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_2 = tmpvar_12;
  mediump vec3 tmpvar_13;
  tmpvar_13 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_14;
  tmpvar_14 = normalize(((unity_CameraToWorld * tmpvar_8).xyz - _WorldSpaceCameraPos));
  mediump vec3 viewDir_15;
  viewDir_15 = -(tmpvar_14);
  mediump float specularTerm_16;
  mediump vec3 tmpvar_17;
  mediump vec3 inVec_18;
  inVec_18 = (lightDir_6 + viewDir_15);
  tmpvar_17 = (inVec_18 * inversesqrt(max (0.001, 
    dot (inVec_18, inVec_18)
  )));
  mediump float tmpvar_19;
  tmpvar_19 = clamp (dot (tmpvar_13, tmpvar_17), 0.0, 1.0);
  mediump float tmpvar_20;
  tmpvar_20 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_21;
  tmpvar_21 = (tmpvar_20 * tmpvar_20);
  specularTerm_16 = ((tmpvar_21 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_17), 0.0, 1.0)) * (1.5 + tmpvar_21))
   * 
    (((tmpvar_19 * tmpvar_19) * ((tmpvar_21 * tmpvar_21) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_22;
  tmpvar_22 = clamp (specularTerm_16, 0.0, 100.0);
  specularTerm_16 = tmpvar_22;
  mediump vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_22 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_13, lightDir_6), 0.0, 1.0));
  mediump vec4 tmpvar_24;
  tmpvar_24 = exp2(-(tmpvar_23));
  tmpvar_1 = tmpvar_24;
  gl_FragData[0] = tmpvar_1;
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
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
lowp vec3 u_xlat10_0;
vec2 u_xlat1;
mediump float u_xlat16_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
mediump vec3 u_xlat16_3;
mediump vec3 u_xlat16_4;
lowp vec3 u_xlat10_5;
mediump vec3 u_xlat16_8;
mediump float u_xlat16_13;
float u_xlat15;
mediump float u_xlat16_18;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat15 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat15 = _ZBufferParams.x * u_xlat15 + _ZBufferParams.y;
    u_xlat15 = float(1.0) / u_xlat15;
    u_xlat0.xyz = vec3(u_xlat15) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat0.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat15 = inversesqrt(u_xlat15);
    u_xlat16_3.xyz = (-u_xlat0.xyz) * vec3(u_xlat15) + (-_LightDir.xyz);
    u_xlat16_18 = dot(u_xlat16_3.xyz, u_xlat16_3.xyz);
    u_xlat16_0.x = max(u_xlat16_18, 0.00100000005);
    u_xlat16_18 = inversesqrt(u_xlat16_0.x);
    u_xlat16_3.xyz = vec3(u_xlat16_18) * u_xlat16_3.xyz;
    u_xlat10_0.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_4.xyz = u_xlat10_0.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_18 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_18 = inversesqrt(u_xlat16_18);
    u_xlat16_4.xyz = vec3(u_xlat16_18) * u_xlat16_4.xyz;
    u_xlat16_18 = dot(u_xlat16_4.xyz, u_xlat16_3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_18 = min(max(u_xlat16_18, 0.0), 1.0);
#else
    u_xlat16_18 = clamp(u_xlat16_18, 0.0, 1.0);
#endif
    u_xlat16_3.x = dot((-_LightDir.xyz), u_xlat16_3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.x = min(max(u_xlat16_3.x, 0.0), 1.0);
#else
    u_xlat16_3.x = clamp(u_xlat16_3.x, 0.0, 1.0);
#endif
    u_xlat16_0.x = max(u_xlat16_3.x, 0.319999993);
    u_xlat16_3.x = dot(u_xlat16_4.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.x = min(max(u_xlat16_3.x, 0.0), 1.0);
#else
    u_xlat16_3.x = clamp(u_xlat16_3.x, 0.0, 1.0);
#endif
    u_xlat16_8.x = u_xlat16_18 * u_xlat16_18;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_5.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_13 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_18 = u_xlat16_13 * u_xlat16_13;
    u_xlat16_1 = u_xlat16_13 * u_xlat16_13 + 1.5;
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_1;
    u_xlat16_1 = u_xlat16_18 * u_xlat16_18 + -1.0;
    u_xlat16_1 = u_xlat16_8.x * u_xlat16_1 + 1.00001001;
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_1;
    u_xlat16_0.x = u_xlat16_18 / u_xlat16_0.x;
    u_xlat16_0.x = u_xlat16_0.x + -9.99999975e-05;
    u_xlat16_8.x = max(u_xlat16_0.x, 0.0);
    u_xlat16_8.x = min(u_xlat16_8.x, 100.0);
    u_xlat16_8.xyz = u_xlat16_8.xxx * u_xlat10_2.xyz + u_xlat10_5.xyz;
    u_xlat16_8.xyz = u_xlat16_8.xyz * _LightColor.xyz;
    u_xlat16_0.xyz = u_xlat16_3.xxx * u_xlat16_8.xyz;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
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
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
lowp vec3 u_xlat10_0;
vec2 u_xlat1;
mediump float u_xlat16_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
mediump vec3 u_xlat16_3;
mediump vec3 u_xlat16_4;
lowp vec3 u_xlat10_5;
mediump vec3 u_xlat16_8;
mediump float u_xlat16_13;
float u_xlat15;
mediump float u_xlat16_18;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat15 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat15 = _ZBufferParams.x * u_xlat15 + _ZBufferParams.y;
    u_xlat15 = float(1.0) / u_xlat15;
    u_xlat0.xyz = vec3(u_xlat15) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat0.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat15 = inversesqrt(u_xlat15);
    u_xlat16_3.xyz = (-u_xlat0.xyz) * vec3(u_xlat15) + (-_LightDir.xyz);
    u_xlat16_18 = dot(u_xlat16_3.xyz, u_xlat16_3.xyz);
    u_xlat16_0.x = max(u_xlat16_18, 0.00100000005);
    u_xlat16_18 = inversesqrt(u_xlat16_0.x);
    u_xlat16_3.xyz = vec3(u_xlat16_18) * u_xlat16_3.xyz;
    u_xlat10_0.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_4.xyz = u_xlat10_0.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_18 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_18 = inversesqrt(u_xlat16_18);
    u_xlat16_4.xyz = vec3(u_xlat16_18) * u_xlat16_4.xyz;
    u_xlat16_18 = dot(u_xlat16_4.xyz, u_xlat16_3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_18 = min(max(u_xlat16_18, 0.0), 1.0);
#else
    u_xlat16_18 = clamp(u_xlat16_18, 0.0, 1.0);
#endif
    u_xlat16_3.x = dot((-_LightDir.xyz), u_xlat16_3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.x = min(max(u_xlat16_3.x, 0.0), 1.0);
#else
    u_xlat16_3.x = clamp(u_xlat16_3.x, 0.0, 1.0);
#endif
    u_xlat16_0.x = max(u_xlat16_3.x, 0.319999993);
    u_xlat16_3.x = dot(u_xlat16_4.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.x = min(max(u_xlat16_3.x, 0.0), 1.0);
#else
    u_xlat16_3.x = clamp(u_xlat16_3.x, 0.0, 1.0);
#endif
    u_xlat16_8.x = u_xlat16_18 * u_xlat16_18;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_5.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_13 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_18 = u_xlat16_13 * u_xlat16_13;
    u_xlat16_1 = u_xlat16_13 * u_xlat16_13 + 1.5;
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_1;
    u_xlat16_1 = u_xlat16_18 * u_xlat16_18 + -1.0;
    u_xlat16_1 = u_xlat16_8.x * u_xlat16_1 + 1.00001001;
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_1;
    u_xlat16_0.x = u_xlat16_18 / u_xlat16_0.x;
    u_xlat16_0.x = u_xlat16_0.x + -9.99999975e-05;
    u_xlat16_8.x = max(u_xlat16_0.x, 0.0);
    u_xlat16_8.x = min(u_xlat16_8.x, 100.0);
    u_xlat16_8.xyz = u_xlat16_8.xxx * u_xlat10_2.xyz + u_xlat10_5.xyz;
    u_xlat16_8.xyz = u_xlat16_8.xyz * _LightColor.xyz;
    u_xlat16_0.xyz = u_xlat16_3.xxx * u_xlat16_8.xyz;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
    return;
}

#endif
"
}
SubProgram "gles " {
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  tmpvar_11 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize(tmpvar_11);
  lightDir_7 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_10;
  highp vec4 tmpvar_14;
  tmpvar_14 = (unity_WorldToLight * tmpvar_13);
  highp vec4 tmpvar_15;
  tmpvar_15.zw = vec2(0.0, -8.0);
  tmpvar_15.xy = (tmpvar_14.xy / tmpvar_14.w);
  atten_6 = (texture2D (_LightTexture0, tmpvar_15.xy, -8.0).w * float((tmpvar_14.w < 0.0)));
  atten_6 = (atten_6 * texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w))).w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_18;
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_21;
  viewDir_21 = -(tmpvar_20);
  mediump vec2 tmpvar_22;
  tmpvar_22.x = dot ((viewDir_21 - (2.0 * 
    (dot (tmpvar_19, viewDir_21) * tmpvar_19)
  )), lightDir_7);
  tmpvar_22.y = (1.0 - clamp (dot (tmpvar_19, viewDir_21), 0.0, 1.0));
  mediump float specular_23;
  mediump vec2 tmpvar_24;
  tmpvar_24.x = ((tmpvar_22 * tmpvar_22) * (tmpvar_22 * tmpvar_22)).x;
  tmpvar_24.y = (1.0 - gbuffer1_3.w);
  highp float tmpvar_25;
  tmpvar_25 = (texture2D (unity_NHxRoughness, tmpvar_24).w * 16.0);
  specular_23 = tmpvar_25;
  mediump vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = ((gbuffer0_4.xyz + (specular_23 * gbuffer1_3.xyz)) * (tmpvar_5 * clamp (
    dot (tmpvar_19, lightDir_7)
  , 0.0, 1.0)));
  mediump vec4 tmpvar_27;
  tmpvar_27 = exp2(-(tmpvar_26));
  tmpvar_1 = tmpvar_27;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 " {
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
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform highp sampler2D unity_NHxRoughness;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec3 u_xlat1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
lowp vec3 u_xlat10_3;
mediump vec3 u_xlat16_4;
mediump vec3 u_xlat16_5;
mediump vec3 u_xlat16_10;
float u_xlat12;
bool u_xlatb12;
float u_xlat13;
float u_xlat18;
float u_xlat19;
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
    u_xlat16_22 = dot((-u_xlat2.xyz), u_xlat16_4.xyz);
    u_xlat16_22 = u_xlat16_22 + u_xlat16_22;
    u_xlat16_5.xyz = u_xlat16_4.xyz * (-vec3(u_xlat16_22)) + (-u_xlat2.xyz);
    u_xlat2.xyz = (-u_xlat0.xyz) + _LightPos.xyz;
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat13 = inversesqrt(u_xlat18);
    u_xlat18 = u_xlat18 * _LightPos.w;
    u_xlat18 = texture(_LightTextureB0, vec2(u_xlat18)).w;
    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat2.xyz);
    u_xlat16_4.x = dot(u_xlat16_4.xyz, u_xlat2.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10.x = u_xlat16_22 * u_xlat16_22;
    u_xlat16_5.x = u_xlat16_10.x * u_xlat16_10.x;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_5.y = (-u_xlat10_2.w) + 1.0;
    u_xlat19 = texture(unity_NHxRoughness, u_xlat16_5.xy).w;
    u_xlat19 = u_xlat19 * 16.0;
    u_xlat16_10.xyz = vec3(u_xlat19) * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat1.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat0.xxx + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat0.zzz + u_xlat1.xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat0.xy = u_xlat0.xy / u_xlat0.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb12 = !!(u_xlat0.z<0.0);
#else
    u_xlatb12 = u_xlat0.z<0.0;
#endif
    u_xlat12 = u_xlatb12 ? 1.0 : float(0.0);
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.x = u_xlat12 * u_xlat0.x;
    u_xlat0.x = u_xlat18 * u_xlat0.x;
    u_xlat0.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat16_5.xyz = u_xlat16_4.xxx * u_xlat0.xyz;
    u_xlat16_0.xyz = u_xlat16_10.xyz * u_xlat16_5.xyz;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
    return;
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  tmpvar_11 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize(tmpvar_11);
  lightDir_7 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_10;
  highp vec4 tmpvar_14;
  tmpvar_14 = (unity_WorldToLight * tmpvar_13);
  highp vec4 tmpvar_15;
  tmpvar_15.zw = vec2(0.0, -8.0);
  tmpvar_15.xy = (tmpvar_14.xy / tmpvar_14.w);
  atten_6 = (texture2D (_LightTexture0, tmpvar_15.xy, -8.0).w * float((tmpvar_14.w < 0.0)));
  atten_6 = (atten_6 * texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w))).w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_18;
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_21;
  viewDir_21 = -(tmpvar_20);
  mediump float specularTerm_22;
  mediump vec3 tmpvar_23;
  mediump vec3 inVec_24;
  inVec_24 = (lightDir_7 + viewDir_21);
  tmpvar_23 = (inVec_24 * inversesqrt(max (0.001, 
    dot (inVec_24, inVec_24)
  )));
  mediump float tmpvar_25;
  tmpvar_25 = clamp (dot (tmpvar_19, tmpvar_23), 0.0, 1.0);
  mediump float tmpvar_26;
  tmpvar_26 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_27;
  tmpvar_27 = (tmpvar_26 * tmpvar_26);
  specularTerm_22 = ((tmpvar_27 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_23), 0.0, 1.0)) * (1.5 + tmpvar_27))
   * 
    (((tmpvar_25 * tmpvar_25) * ((tmpvar_27 * tmpvar_27) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_28;
  tmpvar_28 = clamp (specularTerm_22, 0.0, 100.0);
  specularTerm_22 = tmpvar_28;
  mediump vec4 tmpvar_29;
  tmpvar_29.w = 1.0;
  tmpvar_29.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_28 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_19, lightDir_7), 0.0, 1.0));
  mediump vec4 tmpvar_30;
  tmpvar_30 = exp2(-(tmpvar_29));
  tmpvar_1 = tmpvar_30;
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  tmpvar_11 = (_LightPos.xyz - tmpvar_10);
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize(tmpvar_11);
  lightDir_7 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_10;
  highp vec4 tmpvar_14;
  tmpvar_14 = (unity_WorldToLight * tmpvar_13);
  highp vec4 tmpvar_15;
  tmpvar_15.zw = vec2(0.0, -8.0);
  tmpvar_15.xy = (tmpvar_14.xy / tmpvar_14.w);
  atten_6 = (texture2D (_LightTexture0, tmpvar_15.xy, -8.0).w * float((tmpvar_14.w < 0.0)));
  atten_6 = (atten_6 * texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w))).w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_18;
  mediump vec3 tmpvar_19;
  tmpvar_19 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_20;
  tmpvar_20 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_21;
  viewDir_21 = -(tmpvar_20);
  mediump float specularTerm_22;
  mediump vec3 tmpvar_23;
  mediump vec3 inVec_24;
  inVec_24 = (lightDir_7 + viewDir_21);
  tmpvar_23 = (inVec_24 * inversesqrt(max (0.001, 
    dot (inVec_24, inVec_24)
  )));
  mediump float tmpvar_25;
  tmpvar_25 = clamp (dot (tmpvar_19, tmpvar_23), 0.0, 1.0);
  mediump float tmpvar_26;
  tmpvar_26 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_27;
  tmpvar_27 = (tmpvar_26 * tmpvar_26);
  specularTerm_22 = ((tmpvar_27 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_23), 0.0, 1.0)) * (1.5 + tmpvar_27))
   * 
    (((tmpvar_25 * tmpvar_25) * ((tmpvar_27 * tmpvar_27) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_28;
  tmpvar_28 = clamp (specularTerm_22, 0.0, 100.0);
  specularTerm_22 = tmpvar_28;
  mediump vec4 tmpvar_29;
  tmpvar_29.w = 1.0;
  tmpvar_29.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_28 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_19, lightDir_7), 0.0, 1.0));
  mediump vec4 tmpvar_30;
  tmpvar_30 = exp2(-(tmpvar_29));
  tmpvar_1 = tmpvar_30;
  gl_FragData[0] = tmpvar_1;
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
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec4 u_xlat16_4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_10;
float u_xlat12;
bool u_xlatb12;
float u_xlat13;
mediump float u_xlat16_16;
float u_xlat18;
mediump float u_xlat16_18;
float u_xlat19;
mediump float u_xlat16_20;
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
    u_xlat3.xyz = (-u_xlat0.xyz) + _LightPos.xyz;
    u_xlat13 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat19 = inversesqrt(u_xlat13);
    u_xlat13 = u_xlat13 * _LightPos.w;
    u_xlat13 = texture(_LightTextureB0, vec2(u_xlat13)).w;
    u_xlat3.xyz = vec3(u_xlat19) * u_xlat3.xyz;
    u_xlat16_4.xyz = (-u_xlat2.xyz) * vec3(u_xlat18) + u_xlat3.xyz;
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_18 = max(u_xlat16_22, 0.00100000005);
    u_xlat16_22 = inversesqrt(u_xlat16_18);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_5.xyz = vec3(u_xlat16_22) * u_xlat16_5.xyz;
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_22 = min(max(u_xlat16_22, 0.0), 1.0);
#else
    u_xlat16_22 = clamp(u_xlat16_22, 0.0, 1.0);
#endif
    u_xlat16_4.x = dot(u_xlat3.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10 = dot(u_xlat16_5.xyz, u_xlat3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_10 = min(max(u_xlat16_10, 0.0), 1.0);
#else
    u_xlat16_10 = clamp(u_xlat16_10, 0.0, 1.0);
#endif
    u_xlat16_18 = max(u_xlat16_4.x, 0.319999993);
    u_xlat16_4.x = u_xlat16_22 * u_xlat16_22;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyw = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_16 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_22 = u_xlat16_16 * u_xlat16_16;
    u_xlat16_20 = u_xlat16_16 * u_xlat16_16 + 1.5;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_20;
    u_xlat16_20 = u_xlat16_22 * u_xlat16_22 + -1.0;
    u_xlat16_20 = u_xlat16_4.x * u_xlat16_20 + 1.00001001;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_20;
    u_xlat16_18 = u_xlat16_22 / u_xlat16_18;
    u_xlat16_18 = u_xlat16_18 + -9.99999975e-05;
    u_xlat16_4.x = max(u_xlat16_18, 0.0);
    u_xlat16_4.x = min(u_xlat16_4.x, 100.0);
    u_xlat16_4.xzw = u_xlat16_4.xxx * u_xlat10_2.xyz + u_xlat10_1.xyw;
    u_xlat1.xyw = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat0.xyw = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat0.xxx + u_xlat1.xyw;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat0.xy = u_xlat0.xy / u_xlat0.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb12 = !!(u_xlat0.z<0.0);
#else
    u_xlatb12 = u_xlat0.z<0.0;
#endif
    u_xlat12 = u_xlatb12 ? 1.0 : float(0.0);
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.x = u_xlat12 * u_xlat0.x;
    u_xlat0.x = u_xlat13 * u_xlat0.x;
    u_xlat0.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat16_4.xzw = u_xlat0.xyz * u_xlat16_4.xzw;
    u_xlat16_0.xyz = vec3(u_xlat16_10) * u_xlat16_4.xzw;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
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
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec4 u_xlat16_4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_10;
float u_xlat12;
bool u_xlatb12;
float u_xlat13;
mediump float u_xlat16_16;
float u_xlat18;
mediump float u_xlat16_18;
float u_xlat19;
mediump float u_xlat16_20;
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
    u_xlat3.xyz = (-u_xlat0.xyz) + _LightPos.xyz;
    u_xlat13 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat19 = inversesqrt(u_xlat13);
    u_xlat13 = u_xlat13 * _LightPos.w;
    u_xlat13 = texture(_LightTextureB0, vec2(u_xlat13)).w;
    u_xlat3.xyz = vec3(u_xlat19) * u_xlat3.xyz;
    u_xlat16_4.xyz = (-u_xlat2.xyz) * vec3(u_xlat18) + u_xlat3.xyz;
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_18 = max(u_xlat16_22, 0.00100000005);
    u_xlat16_22 = inversesqrt(u_xlat16_18);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_5.xyz = vec3(u_xlat16_22) * u_xlat16_5.xyz;
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_22 = min(max(u_xlat16_22, 0.0), 1.0);
#else
    u_xlat16_22 = clamp(u_xlat16_22, 0.0, 1.0);
#endif
    u_xlat16_4.x = dot(u_xlat3.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10 = dot(u_xlat16_5.xyz, u_xlat3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_10 = min(max(u_xlat16_10, 0.0), 1.0);
#else
    u_xlat16_10 = clamp(u_xlat16_10, 0.0, 1.0);
#endif
    u_xlat16_18 = max(u_xlat16_4.x, 0.319999993);
    u_xlat16_4.x = u_xlat16_22 * u_xlat16_22;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyw = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_16 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_22 = u_xlat16_16 * u_xlat16_16;
    u_xlat16_20 = u_xlat16_16 * u_xlat16_16 + 1.5;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_20;
    u_xlat16_20 = u_xlat16_22 * u_xlat16_22 + -1.0;
    u_xlat16_20 = u_xlat16_4.x * u_xlat16_20 + 1.00001001;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_20;
    u_xlat16_18 = u_xlat16_22 / u_xlat16_18;
    u_xlat16_18 = u_xlat16_18 + -9.99999975e-05;
    u_xlat16_4.x = max(u_xlat16_18, 0.0);
    u_xlat16_4.x = min(u_xlat16_4.x, 100.0);
    u_xlat16_4.xzw = u_xlat16_4.xxx * u_xlat10_2.xyz + u_xlat10_1.xyw;
    u_xlat1.xyw = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat0.xyw = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat0.xxx + u_xlat1.xyw;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat0.xy = u_xlat0.xy / u_xlat0.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb12 = !!(u_xlat0.z<0.0);
#else
    u_xlatb12 = u_xlat0.z<0.0;
#endif
    u_xlat12 = u_xlatb12 ? 1.0 : float(0.0);
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.x = u_xlat12 * u_xlat0.x;
    u_xlat0.x = u_xlat13 * u_xlat0.x;
    u_xlat0.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat16_4.xzw = u_xlat0.xyz * u_xlat16_4.xzw;
    u_xlat16_0.xyz = vec3(u_xlat16_10) * u_xlat16_4.xzw;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
    return;
}

#endif
"
}
SubProgram "gles " {
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  tmpvar_11 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_7 = tmpvar_12;
  atten_6 = texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w))).w;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_10;
  highp vec4 tmpvar_14;
  tmpvar_14.w = -8.0;
  tmpvar_14.xyz = (unity_WorldToLight * tmpvar_13).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_14.xyz, -8.0).w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_17;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_20;
  viewDir_20 = -(tmpvar_19);
  mediump vec2 tmpvar_21;
  tmpvar_21.x = dot ((viewDir_20 - (2.0 * 
    (dot (tmpvar_18, viewDir_20) * tmpvar_18)
  )), lightDir_7);
  tmpvar_21.y = (1.0 - clamp (dot (tmpvar_18, viewDir_20), 0.0, 1.0));
  mediump float specular_22;
  mediump vec2 tmpvar_23;
  tmpvar_23.x = ((tmpvar_21 * tmpvar_21) * (tmpvar_21 * tmpvar_21)).x;
  tmpvar_23.y = (1.0 - gbuffer1_3.w);
  highp float tmpvar_24;
  tmpvar_24 = (texture2D (unity_NHxRoughness, tmpvar_23).w * 16.0);
  specular_22 = tmpvar_24;
  mediump vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.xyz = ((gbuffer0_4.xyz + (specular_22 * gbuffer1_3.xyz)) * (tmpvar_5 * clamp (
    dot (tmpvar_18, lightDir_7)
  , 0.0, 1.0)));
  mediump vec4 tmpvar_26;
  tmpvar_26 = exp2(-(tmpvar_25));
  tmpvar_1 = tmpvar_26;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 " {
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
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform highp sampler2D unity_NHxRoughness;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec3 u_xlat1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
lowp vec3 u_xlat10_3;
mediump vec3 u_xlat16_4;
mediump vec3 u_xlat16_5;
mediump vec3 u_xlat16_10;
float u_xlat13;
float u_xlat18;
float u_xlat19;
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
    u_xlat16_22 = dot((-u_xlat2.xyz), u_xlat16_4.xyz);
    u_xlat16_22 = u_xlat16_22 + u_xlat16_22;
    u_xlat16_5.xyz = u_xlat16_4.xyz * (-vec3(u_xlat16_22)) + (-u_xlat2.xyz);
    u_xlat2.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat13 = inversesqrt(u_xlat18);
    u_xlat18 = u_xlat18 * _LightPos.w;
    u_xlat18 = texture(_LightTextureB0, vec2(u_xlat18)).w;
    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
    u_xlat16_22 = dot(u_xlat16_5.xyz, (-u_xlat2.xyz));
    u_xlat16_4.x = dot(u_xlat16_4.xyz, (-u_xlat2.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10.x = u_xlat16_22 * u_xlat16_22;
    u_xlat16_5.x = u_xlat16_10.x * u_xlat16_10.x;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_5.y = (-u_xlat10_2.w) + 1.0;
    u_xlat19 = texture(unity_NHxRoughness, u_xlat16_5.xy).w;
    u_xlat19 = u_xlat19 * 16.0;
    u_xlat16_10.xyz = vec3(u_xlat19) * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat1.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xyz, -8.0).w;
    u_xlat0.x = u_xlat0.x * u_xlat18;
    u_xlat0.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat16_5.xyz = u_xlat16_4.xxx * u_xlat0.xyz;
    u_xlat16_0.xyz = u_xlat16_10.xyz * u_xlat16_5.xyz;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
    return;
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  tmpvar_11 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_7 = tmpvar_12;
  atten_6 = texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w))).w;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_10;
  highp vec4 tmpvar_14;
  tmpvar_14.w = -8.0;
  tmpvar_14.xyz = (unity_WorldToLight * tmpvar_13).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_14.xyz, -8.0).w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_17;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_20;
  viewDir_20 = -(tmpvar_19);
  mediump float specularTerm_21;
  mediump vec3 tmpvar_22;
  mediump vec3 inVec_23;
  inVec_23 = (lightDir_7 + viewDir_20);
  tmpvar_22 = (inVec_23 * inversesqrt(max (0.001, 
    dot (inVec_23, inVec_23)
  )));
  mediump float tmpvar_24;
  tmpvar_24 = clamp (dot (tmpvar_18, tmpvar_22), 0.0, 1.0);
  mediump float tmpvar_25;
  tmpvar_25 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_26;
  tmpvar_26 = (tmpvar_25 * tmpvar_25);
  specularTerm_21 = ((tmpvar_26 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_22), 0.0, 1.0)) * (1.5 + tmpvar_26))
   * 
    (((tmpvar_24 * tmpvar_24) * ((tmpvar_26 * tmpvar_26) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_27;
  tmpvar_27 = clamp (specularTerm_21, 0.0, 100.0);
  specularTerm_21 = tmpvar_27;
  mediump vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_27 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_18, lightDir_7), 0.0, 1.0));
  mediump vec4 tmpvar_29;
  tmpvar_29 = exp2(-(tmpvar_28));
  tmpvar_1 = tmpvar_29;
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  tmpvar_11 = (tmpvar_10 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_7 = tmpvar_12;
  atten_6 = texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w))).w;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_10;
  highp vec4 tmpvar_14;
  tmpvar_14.w = -8.0;
  tmpvar_14.xyz = (unity_WorldToLight * tmpvar_13).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_14.xyz, -8.0).w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_17;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_20;
  viewDir_20 = -(tmpvar_19);
  mediump float specularTerm_21;
  mediump vec3 tmpvar_22;
  mediump vec3 inVec_23;
  inVec_23 = (lightDir_7 + viewDir_20);
  tmpvar_22 = (inVec_23 * inversesqrt(max (0.001, 
    dot (inVec_23, inVec_23)
  )));
  mediump float tmpvar_24;
  tmpvar_24 = clamp (dot (tmpvar_18, tmpvar_22), 0.0, 1.0);
  mediump float tmpvar_25;
  tmpvar_25 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_26;
  tmpvar_26 = (tmpvar_25 * tmpvar_25);
  specularTerm_21 = ((tmpvar_26 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_22), 0.0, 1.0)) * (1.5 + tmpvar_26))
   * 
    (((tmpvar_24 * tmpvar_24) * ((tmpvar_26 * tmpvar_26) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_27;
  tmpvar_27 = clamp (specularTerm_21, 0.0, 100.0);
  specularTerm_21 = tmpvar_27;
  mediump vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_27 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_18, lightDir_7), 0.0, 1.0));
  mediump vec4 tmpvar_29;
  tmpvar_29 = exp2(-(tmpvar_28));
  tmpvar_1 = tmpvar_29;
  gl_FragData[0] = tmpvar_1;
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
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec4 u_xlat16_4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_10;
float u_xlat13;
mediump float u_xlat16_16;
float u_xlat18;
mediump float u_xlat16_18;
float u_xlat19;
mediump float u_xlat16_20;
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
    u_xlat3.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat13 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat19 = inversesqrt(u_xlat13);
    u_xlat13 = u_xlat13 * _LightPos.w;
    u_xlat13 = texture(_LightTextureB0, vec2(u_xlat13)).w;
    u_xlat3.xyz = vec3(u_xlat19) * u_xlat3.xyz;
    u_xlat16_4.xyz = (-u_xlat2.xyz) * vec3(u_xlat18) + (-u_xlat3.xyz);
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_18 = max(u_xlat16_22, 0.00100000005);
    u_xlat16_22 = inversesqrt(u_xlat16_18);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_5.xyz = vec3(u_xlat16_22) * u_xlat16_5.xyz;
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_22 = min(max(u_xlat16_22, 0.0), 1.0);
#else
    u_xlat16_22 = clamp(u_xlat16_22, 0.0, 1.0);
#endif
    u_xlat16_4.x = dot((-u_xlat3.xyz), u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10 = dot(u_xlat16_5.xyz, (-u_xlat3.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_10 = min(max(u_xlat16_10, 0.0), 1.0);
#else
    u_xlat16_10 = clamp(u_xlat16_10, 0.0, 1.0);
#endif
    u_xlat16_18 = max(u_xlat16_4.x, 0.319999993);
    u_xlat16_4.x = u_xlat16_22 * u_xlat16_22;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyw = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_16 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_22 = u_xlat16_16 * u_xlat16_16;
    u_xlat16_20 = u_xlat16_16 * u_xlat16_16 + 1.5;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_20;
    u_xlat16_20 = u_xlat16_22 * u_xlat16_22 + -1.0;
    u_xlat16_20 = u_xlat16_4.x * u_xlat16_20 + 1.00001001;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_20;
    u_xlat16_18 = u_xlat16_22 / u_xlat16_18;
    u_xlat16_18 = u_xlat16_18 + -9.99999975e-05;
    u_xlat16_4.x = max(u_xlat16_18, 0.0);
    u_xlat16_4.x = min(u_xlat16_4.x, 100.0);
    u_xlat16_4.xzw = u_xlat16_4.xxx * u_xlat10_2.xyz + u_xlat10_1.xyw;
    u_xlat1.xyw = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat0.xxx + u_xlat1.xyw;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xyz, -8.0).w;
    u_xlat0.x = u_xlat0.x * u_xlat13;
    u_xlat0.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat16_4.xzw = u_xlat0.xyz * u_xlat16_4.xzw;
    u_xlat16_0.xyz = vec3(u_xlat16_10) * u_xlat16_4.xzw;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
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
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec4 u_xlat16_4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_10;
float u_xlat13;
mediump float u_xlat16_16;
float u_xlat18;
mediump float u_xlat16_18;
float u_xlat19;
mediump float u_xlat16_20;
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
    u_xlat3.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat13 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat19 = inversesqrt(u_xlat13);
    u_xlat13 = u_xlat13 * _LightPos.w;
    u_xlat13 = texture(_LightTextureB0, vec2(u_xlat13)).w;
    u_xlat3.xyz = vec3(u_xlat19) * u_xlat3.xyz;
    u_xlat16_4.xyz = (-u_xlat2.xyz) * vec3(u_xlat18) + (-u_xlat3.xyz);
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_18 = max(u_xlat16_22, 0.00100000005);
    u_xlat16_22 = inversesqrt(u_xlat16_18);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_5.xyz = vec3(u_xlat16_22) * u_xlat16_5.xyz;
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_22 = min(max(u_xlat16_22, 0.0), 1.0);
#else
    u_xlat16_22 = clamp(u_xlat16_22, 0.0, 1.0);
#endif
    u_xlat16_4.x = dot((-u_xlat3.xyz), u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10 = dot(u_xlat16_5.xyz, (-u_xlat3.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_10 = min(max(u_xlat16_10, 0.0), 1.0);
#else
    u_xlat16_10 = clamp(u_xlat16_10, 0.0, 1.0);
#endif
    u_xlat16_18 = max(u_xlat16_4.x, 0.319999993);
    u_xlat16_4.x = u_xlat16_22 * u_xlat16_22;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyw = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_16 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_22 = u_xlat16_16 * u_xlat16_16;
    u_xlat16_20 = u_xlat16_16 * u_xlat16_16 + 1.5;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_20;
    u_xlat16_20 = u_xlat16_22 * u_xlat16_22 + -1.0;
    u_xlat16_20 = u_xlat16_4.x * u_xlat16_20 + 1.00001001;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_20;
    u_xlat16_18 = u_xlat16_22 / u_xlat16_18;
    u_xlat16_18 = u_xlat16_18 + -9.99999975e-05;
    u_xlat16_4.x = max(u_xlat16_18, 0.0);
    u_xlat16_4.x = min(u_xlat16_4.x, 100.0);
    u_xlat16_4.xzw = u_xlat16_4.xxx * u_xlat10_2.xyz + u_xlat10_1.xyw;
    u_xlat1.xyw = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat0.xxx + u_xlat1.xyw;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xyz, -8.0).w;
    u_xlat0.x = u_xlat0.x * u_xlat13;
    u_xlat0.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat16_4.xzw = u_xlat0.xyz * u_xlat16_4.xzw;
    u_xlat16_0.xyz = vec3(u_xlat16_10) * u_xlat16_4.xzw;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
    return;
}

#endif
"
}
SubProgram "gles " {
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  tmpvar_11 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_10;
  highp vec4 tmpvar_13;
  tmpvar_13.zw = vec2(0.0, -8.0);
  tmpvar_13.xy = (unity_WorldToLight * tmpvar_12).xy;
  atten_6 = texture2D (_LightTexture0, tmpvar_13.xy, -8.0).w;
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_16;
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_19;
  viewDir_19 = -(tmpvar_18);
  mediump vec2 tmpvar_20;
  tmpvar_20.x = dot ((viewDir_19 - (2.0 * 
    (dot (tmpvar_17, viewDir_19) * tmpvar_17)
  )), lightDir_7);
  tmpvar_20.y = (1.0 - clamp (dot (tmpvar_17, viewDir_19), 0.0, 1.0));
  mediump float specular_21;
  mediump vec2 tmpvar_22;
  tmpvar_22.x = ((tmpvar_20 * tmpvar_20) * (tmpvar_20 * tmpvar_20)).x;
  tmpvar_22.y = (1.0 - gbuffer1_3.w);
  highp float tmpvar_23;
  tmpvar_23 = (texture2D (unity_NHxRoughness, tmpvar_22).w * 16.0);
  specular_21 = tmpvar_23;
  mediump vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = ((gbuffer0_4.xyz + (specular_21 * gbuffer1_3.xyz)) * (tmpvar_5 * clamp (
    dot (tmpvar_17, lightDir_7)
  , 0.0, 1.0)));
  mediump vec4 tmpvar_25;
  tmpvar_25 = exp2(-(tmpvar_24));
  tmpvar_1 = tmpvar_25;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 " {
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
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform highp sampler2D unity_NHxRoughness;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
lowp vec3 u_xlat10_3;
mediump vec3 u_xlat16_4;
mediump vec3 u_xlat16_5;
vec3 u_xlat6;
mediump vec3 u_xlat16_10;
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
    u_xlat16_22 = dot((-u_xlat2.xyz), u_xlat16_4.xyz);
    u_xlat16_22 = u_xlat16_22 + u_xlat16_22;
    u_xlat16_5.xyz = u_xlat16_4.xyz * (-vec3(u_xlat16_22)) + (-u_xlat2.xyz);
    u_xlat16_4.x = dot(u_xlat16_4.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10.x = dot(u_xlat16_5.xyz, (-_LightDir.xyz));
    u_xlat16_10.x = u_xlat16_10.x * u_xlat16_10.x;
    u_xlat16_5.x = u_xlat16_10.x * u_xlat16_10.x;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_5.y = (-u_xlat10_2.w) + 1.0;
    u_xlat18 = texture(unity_NHxRoughness, u_xlat16_5.xy).w;
    u_xlat18 = u_xlat18 * 16.0;
    u_xlat16_10.xyz = vec3(u_xlat18) * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat6.xz = u_xlat0.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat0.xx + u_xlat6.xz;
    u_xlat0.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat0.zz + u_xlat0.xy;
    u_xlat0.xy = u_xlat0.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat16_5.xyz = u_xlat16_4.xxx * u_xlat0.xyz;
    u_xlat16_0.xyz = u_xlat16_10.xyz * u_xlat16_5.xyz;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
    return;
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  tmpvar_11 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_10;
  highp vec4 tmpvar_13;
  tmpvar_13.zw = vec2(0.0, -8.0);
  tmpvar_13.xy = (unity_WorldToLight * tmpvar_12).xy;
  atten_6 = texture2D (_LightTexture0, tmpvar_13.xy, -8.0).w;
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_16;
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_19;
  viewDir_19 = -(tmpvar_18);
  mediump float specularTerm_20;
  mediump vec3 tmpvar_21;
  mediump vec3 inVec_22;
  inVec_22 = (lightDir_7 + viewDir_19);
  tmpvar_21 = (inVec_22 * inversesqrt(max (0.001, 
    dot (inVec_22, inVec_22)
  )));
  mediump float tmpvar_23;
  tmpvar_23 = clamp (dot (tmpvar_17, tmpvar_21), 0.0, 1.0);
  mediump float tmpvar_24;
  tmpvar_24 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_25;
  tmpvar_25 = (tmpvar_24 * tmpvar_24);
  specularTerm_20 = ((tmpvar_25 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_21), 0.0, 1.0)) * (1.5 + tmpvar_25))
   * 
    (((tmpvar_23 * tmpvar_23) * ((tmpvar_25 * tmpvar_25) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_26;
  tmpvar_26 = clamp (specularTerm_20, 0.0, 100.0);
  specularTerm_20 = tmpvar_26;
  mediump vec4 tmpvar_27;
  tmpvar_27.w = 1.0;
  tmpvar_27.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_26 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_17, lightDir_7), 0.0, 1.0));
  mediump vec4 tmpvar_28;
  tmpvar_28 = exp2(-(tmpvar_27));
  tmpvar_1 = tmpvar_28;
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  tmpvar_11 = -(_LightDir.xyz);
  lightDir_7 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_10;
  highp vec4 tmpvar_13;
  tmpvar_13.zw = vec2(0.0, -8.0);
  tmpvar_13.xy = (unity_WorldToLight * tmpvar_12).xy;
  atten_6 = texture2D (_LightTexture0, tmpvar_13.xy, -8.0).w;
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_16;
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_19;
  viewDir_19 = -(tmpvar_18);
  mediump float specularTerm_20;
  mediump vec3 tmpvar_21;
  mediump vec3 inVec_22;
  inVec_22 = (lightDir_7 + viewDir_19);
  tmpvar_21 = (inVec_22 * inversesqrt(max (0.001, 
    dot (inVec_22, inVec_22)
  )));
  mediump float tmpvar_23;
  tmpvar_23 = clamp (dot (tmpvar_17, tmpvar_21), 0.0, 1.0);
  mediump float tmpvar_24;
  tmpvar_24 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_25;
  tmpvar_25 = (tmpvar_24 * tmpvar_24);
  specularTerm_20 = ((tmpvar_25 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_21), 0.0, 1.0)) * (1.5 + tmpvar_25))
   * 
    (((tmpvar_23 * tmpvar_23) * ((tmpvar_25 * tmpvar_25) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_26;
  tmpvar_26 = clamp (specularTerm_20, 0.0, 100.0);
  specularTerm_20 = tmpvar_26;
  mediump vec4 tmpvar_27;
  tmpvar_27.w = 1.0;
  tmpvar_27.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_26 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_17, lightDir_7), 0.0, 1.0));
  mediump vec4 tmpvar_28;
  tmpvar_28 = exp2(-(tmpvar_27));
  tmpvar_1 = tmpvar_28;
  gl_FragData[0] = tmpvar_1;
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
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
mediump vec3 u_xlat16_3;
mediump vec3 u_xlat16_4;
vec3 u_xlat5;
mediump vec3 u_xlat16_8;
mediump float u_xlat16_13;
float u_xlat15;
mediump float u_xlat16_15;
mediump float u_xlat16_16;
mediump float u_xlat16_18;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat15 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat15 = _ZBufferParams.x * u_xlat15 + _ZBufferParams.y;
    u_xlat15 = float(1.0) / u_xlat15;
    u_xlat0.xyz = vec3(u_xlat15) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat15 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat15 = inversesqrt(u_xlat15);
    u_xlat16_3.xyz = (-u_xlat2.xyz) * vec3(u_xlat15) + (-_LightDir.xyz);
    u_xlat16_18 = dot(u_xlat16_3.xyz, u_xlat16_3.xyz);
    u_xlat16_15 = max(u_xlat16_18, 0.00100000005);
    u_xlat16_18 = inversesqrt(u_xlat16_15);
    u_xlat16_3.xyz = vec3(u_xlat16_18) * u_xlat16_3.xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_4.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_18 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_18 = inversesqrt(u_xlat16_18);
    u_xlat16_4.xyz = vec3(u_xlat16_18) * u_xlat16_4.xyz;
    u_xlat16_18 = dot(u_xlat16_4.xyz, u_xlat16_3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_18 = min(max(u_xlat16_18, 0.0), 1.0);
#else
    u_xlat16_18 = clamp(u_xlat16_18, 0.0, 1.0);
#endif
    u_xlat16_3.x = dot((-_LightDir.xyz), u_xlat16_3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.x = min(max(u_xlat16_3.x, 0.0), 1.0);
#else
    u_xlat16_3.x = clamp(u_xlat16_3.x, 0.0, 1.0);
#endif
    u_xlat16_15 = max(u_xlat16_3.x, 0.319999993);
    u_xlat16_3.x = dot(u_xlat16_4.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.x = min(max(u_xlat16_3.x, 0.0), 1.0);
#else
    u_xlat16_3.x = clamp(u_xlat16_3.x, 0.0, 1.0);
#endif
    u_xlat16_8.x = u_xlat16_18 * u_xlat16_18;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_13 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_18 = u_xlat16_13 * u_xlat16_13;
    u_xlat16_16 = u_xlat16_13 * u_xlat16_13 + 1.5;
    u_xlat16_15 = u_xlat16_15 * u_xlat16_16;
    u_xlat16_16 = u_xlat16_18 * u_xlat16_18 + -1.0;
    u_xlat16_16 = u_xlat16_8.x * u_xlat16_16 + 1.00001001;
    u_xlat16_15 = u_xlat16_15 * u_xlat16_16;
    u_xlat16_15 = u_xlat16_18 / u_xlat16_15;
    u_xlat16_15 = u_xlat16_15 + -9.99999975e-05;
    u_xlat16_8.x = max(u_xlat16_15, 0.0);
    u_xlat16_8.x = min(u_xlat16_8.x, 100.0);
    u_xlat16_8.xyz = u_xlat16_8.xxx * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat5.xz = u_xlat0.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat0.xx + u_xlat5.xz;
    u_xlat0.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat0.zz + u_xlat0.xy;
    u_xlat0.xy = u_xlat0.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat16_8.xyz = u_xlat0.xyz * u_xlat16_8.xyz;
    u_xlat16_0.xyz = u_xlat16_3.xxx * u_xlat16_8.xyz;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
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
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
mediump vec3 u_xlat16_3;
mediump vec3 u_xlat16_4;
vec3 u_xlat5;
mediump vec3 u_xlat16_8;
mediump float u_xlat16_13;
float u_xlat15;
mediump float u_xlat16_15;
mediump float u_xlat16_16;
mediump float u_xlat16_18;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat15 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat15 = _ZBufferParams.x * u_xlat15 + _ZBufferParams.y;
    u_xlat15 = float(1.0) / u_xlat15;
    u_xlat0.xyz = vec3(u_xlat15) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat15 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat15 = inversesqrt(u_xlat15);
    u_xlat16_3.xyz = (-u_xlat2.xyz) * vec3(u_xlat15) + (-_LightDir.xyz);
    u_xlat16_18 = dot(u_xlat16_3.xyz, u_xlat16_3.xyz);
    u_xlat16_15 = max(u_xlat16_18, 0.00100000005);
    u_xlat16_18 = inversesqrt(u_xlat16_15);
    u_xlat16_3.xyz = vec3(u_xlat16_18) * u_xlat16_3.xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_4.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_18 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_18 = inversesqrt(u_xlat16_18);
    u_xlat16_4.xyz = vec3(u_xlat16_18) * u_xlat16_4.xyz;
    u_xlat16_18 = dot(u_xlat16_4.xyz, u_xlat16_3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_18 = min(max(u_xlat16_18, 0.0), 1.0);
#else
    u_xlat16_18 = clamp(u_xlat16_18, 0.0, 1.0);
#endif
    u_xlat16_3.x = dot((-_LightDir.xyz), u_xlat16_3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.x = min(max(u_xlat16_3.x, 0.0), 1.0);
#else
    u_xlat16_3.x = clamp(u_xlat16_3.x, 0.0, 1.0);
#endif
    u_xlat16_15 = max(u_xlat16_3.x, 0.319999993);
    u_xlat16_3.x = dot(u_xlat16_4.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.x = min(max(u_xlat16_3.x, 0.0), 1.0);
#else
    u_xlat16_3.x = clamp(u_xlat16_3.x, 0.0, 1.0);
#endif
    u_xlat16_8.x = u_xlat16_18 * u_xlat16_18;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_13 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_18 = u_xlat16_13 * u_xlat16_13;
    u_xlat16_16 = u_xlat16_13 * u_xlat16_13 + 1.5;
    u_xlat16_15 = u_xlat16_15 * u_xlat16_16;
    u_xlat16_16 = u_xlat16_18 * u_xlat16_18 + -1.0;
    u_xlat16_16 = u_xlat16_8.x * u_xlat16_16 + 1.00001001;
    u_xlat16_15 = u_xlat16_15 * u_xlat16_16;
    u_xlat16_15 = u_xlat16_18 / u_xlat16_15;
    u_xlat16_15 = u_xlat16_15 + -9.99999975e-05;
    u_xlat16_8.x = max(u_xlat16_15, 0.0);
    u_xlat16_8.x = min(u_xlat16_8.x, 100.0);
    u_xlat16_8.xyz = u_xlat16_8.xxx * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat5.xz = u_xlat0.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat0.xx + u_xlat5.xz;
    u_xlat0.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat0.zz + u_xlat0.xy;
    u_xlat0.xy = u_xlat0.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat16_8.xyz = u_xlat0.xyz * u_xlat16_8.xyz;
    u_xlat16_0.xyz = u_xlat16_3.xxx * u_xlat16_8.xyz;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
    return;
}

#endif
"
}
SubProgram "gles " {
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  mediump float tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_17 = tmpvar_18;
  mediump float shadowAttenuation_19;
  shadowAttenuation_19 = 1.0;
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.0;
  tmpvar_20.xyz = tmpvar_10;
  highp vec4 tmpvar_21;
  tmpvar_21 = (unity_WorldToShadow[0] * tmpvar_20);
  lowp float tmpvar_22;
  highp vec4 tmpvar_23;
  tmpvar_23 = texture2DProj (_ShadowMapTexture, tmpvar_21);
  mediump float tmpvar_24;
  if ((tmpvar_23.x < (tmpvar_21.z / tmpvar_21.w))) {
    tmpvar_24 = _LightShadowData.x;
  } else {
    tmpvar_24 = 1.0;
  };
  tmpvar_22 = tmpvar_24;
  shadowAttenuation_19 = tmpvar_22;
  mediump float tmpvar_25;
  tmpvar_25 = clamp ((shadowAttenuation_19 + tmpvar_17), 0.0, 1.0);
  atten_6 = (atten_6 * tmpvar_25);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_28;
  mediump vec3 tmpvar_29;
  tmpvar_29 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_30;
  tmpvar_30 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_31;
  viewDir_31 = -(tmpvar_30);
  mediump vec2 tmpvar_32;
  tmpvar_32.x = dot ((viewDir_31 - (2.0 * 
    (dot (tmpvar_29, viewDir_31) * tmpvar_29)
  )), lightDir_7);
  tmpvar_32.y = (1.0 - clamp (dot (tmpvar_29, viewDir_31), 0.0, 1.0));
  mediump float specular_33;
  mediump vec2 tmpvar_34;
  tmpvar_34.x = ((tmpvar_32 * tmpvar_32) * (tmpvar_32 * tmpvar_32)).x;
  tmpvar_34.y = (1.0 - gbuffer1_3.w);
  highp float tmpvar_35;
  tmpvar_35 = (texture2D (unity_NHxRoughness, tmpvar_34).w * 16.0);
  specular_33 = tmpvar_35;
  mediump vec4 tmpvar_36;
  tmpvar_36.w = 1.0;
  tmpvar_36.xyz = ((gbuffer0_4.xyz + (specular_33 * gbuffer1_3.xyz)) * (tmpvar_5 * clamp (
    dot (tmpvar_29, lightDir_7)
  , 0.0, 1.0)));
  mediump vec4 tmpvar_37;
  tmpvar_37 = exp2(-(tmpvar_36));
  tmpvar_1 = tmpvar_37;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 " {
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform highp sampler2D unity_NHxRoughness;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
mediump vec4 u_xlat16_0;
lowp vec4 u_xlat10_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
vec4 u_xlat3;
mediump vec3 u_xlat16_4;
lowp vec3 u_xlat10_5;
mediump vec3 u_xlat16_6;
vec3 u_xlat7;
lowp float u_xlat10_7;
float u_xlat14;
bool u_xlatb14;
float u_xlat15;
float u_xlat21;
float u_xlat22;
mediump float u_xlat16_25;
void main()
{
    u_xlat16_0.x = (-_LightShadowData.x) + 1.0;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat15 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat15 = _ZBufferParams.x * u_xlat15 + _ZBufferParams.y;
    u_xlat15 = float(1.0) / u_xlat15;
    u_xlat2.xyz = u_xlat7.xyz * vec3(u_xlat15);
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3 = u_xlat2.yyyy * hlslcc_mtx4x4unity_WorldToShadow[1];
    u_xlat3 = hlslcc_mtx4x4unity_WorldToShadow[0] * u_xlat2.xxxx + u_xlat3;
    u_xlat3 = hlslcc_mtx4x4unity_WorldToShadow[2] * u_xlat2.wwww + u_xlat3;
    u_xlat3 = u_xlat3 + hlslcc_mtx4x4unity_WorldToShadow[3];
    u_xlat3.xyz = u_xlat3.xyz / u_xlat3.www;
    vec3 txVec0 = vec3(u_xlat3.xy,u_xlat3.z);
    u_xlat10_7 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_0.x = u_xlat10_7 * u_xlat16_0.x + _LightShadowData.x;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat7.x = (-u_xlat7.z) * u_xlat15 + u_xlat7.x;
    u_xlat7.x = unity_ShadowFadeCenterAndType.w * u_xlat7.x + u_xlat2.z;
    u_xlat7.x = u_xlat7.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat7.x = min(max(u_xlat7.x, 0.0), 1.0);
#else
    u_xlat7.x = clamp(u_xlat7.x, 0.0, 1.0);
#endif
    u_xlat16_4.x = u_xlat7.x + u_xlat16_0.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat0.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat2.xxx + u_xlat0.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat2.www + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat0.xy = u_xlat0.xy / u_xlat0.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb14 = !!(u_xlat0.z<0.0);
#else
    u_xlatb14 = u_xlat0.z<0.0;
#endif
    u_xlat14 = u_xlatb14 ? 1.0 : float(0.0);
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.x = u_xlat14 * u_xlat0.x;
    u_xlat7.xyz = (-u_xlat2.xyw) + _LightPos.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat15 = dot(u_xlat7.xyz, u_xlat7.xyz);
    u_xlat22 = u_xlat15 * _LightPos.w;
    u_xlat15 = inversesqrt(u_xlat15);
    u_xlat7.xyz = u_xlat7.xyz * vec3(u_xlat15);
    u_xlat15 = texture(_LightTextureB0, vec2(u_xlat22)).w;
    u_xlat0.x = u_xlat0.x * u_xlat15;
    u_xlat0.x = u_xlat16_4.x * u_xlat0.x;
    u_xlat3.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat10_5.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_4.xyz = u_xlat10_5.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_25 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_25 = inversesqrt(u_xlat16_25);
    u_xlat16_4.xyz = vec3(u_xlat16_25) * u_xlat16_4.xyz;
    u_xlat16_25 = dot(u_xlat16_4.xyz, u_xlat7.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_25 = min(max(u_xlat16_25, 0.0), 1.0);
#else
    u_xlat16_25 = clamp(u_xlat16_25, 0.0, 1.0);
#endif
    u_xlat16_6.xyz = u_xlat3.xyz * vec3(u_xlat16_25);
    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat2.xyz = u_xlat0.xxx * u_xlat2.xyz;
    u_xlat16_25 = dot((-u_xlat2.xyz), u_xlat16_4.xyz);
    u_xlat16_25 = u_xlat16_25 + u_xlat16_25;
    u_xlat16_4.xyz = u_xlat16_4.xyz * (-vec3(u_xlat16_25)) + (-u_xlat2.xyz);
    u_xlat16_4.x = dot(u_xlat16_4.xyz, u_xlat7.xyz);
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_4.x;
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_4.x;
    u_xlat10_0 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_4.y = (-u_xlat10_0.w) + 1.0;
    u_xlat21 = texture(unity_NHxRoughness, u_xlat16_4.xy).w;
    u_xlat21 = u_xlat21 * 16.0;
    u_xlat16_4.xyz = vec3(u_xlat21) * u_xlat10_0.xyz + u_xlat10_1.xyz;
    u_xlat16_0.xyz = u_xlat16_6.xyz * u_xlat16_4.xyz;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
    return;
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  mediump float tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_17 = tmpvar_18;
  mediump float shadowAttenuation_19;
  shadowAttenuation_19 = 1.0;
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.0;
  tmpvar_20.xyz = tmpvar_10;
  highp vec4 tmpvar_21;
  tmpvar_21 = (unity_WorldToShadow[0] * tmpvar_20);
  lowp float tmpvar_22;
  highp vec4 tmpvar_23;
  tmpvar_23 = texture2DProj (_ShadowMapTexture, tmpvar_21);
  mediump float tmpvar_24;
  if ((tmpvar_23.x < (tmpvar_21.z / tmpvar_21.w))) {
    tmpvar_24 = _LightShadowData.x;
  } else {
    tmpvar_24 = 1.0;
  };
  tmpvar_22 = tmpvar_24;
  shadowAttenuation_19 = tmpvar_22;
  mediump float tmpvar_25;
  tmpvar_25 = clamp ((shadowAttenuation_19 + tmpvar_17), 0.0, 1.0);
  atten_6 = (atten_6 * tmpvar_25);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_28;
  mediump vec3 tmpvar_29;
  tmpvar_29 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_30;
  tmpvar_30 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_31;
  viewDir_31 = -(tmpvar_30);
  mediump float specularTerm_32;
  mediump vec3 tmpvar_33;
  mediump vec3 inVec_34;
  inVec_34 = (lightDir_7 + viewDir_31);
  tmpvar_33 = (inVec_34 * inversesqrt(max (0.001, 
    dot (inVec_34, inVec_34)
  )));
  mediump float tmpvar_35;
  tmpvar_35 = clamp (dot (tmpvar_29, tmpvar_33), 0.0, 1.0);
  mediump float tmpvar_36;
  tmpvar_36 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_37;
  tmpvar_37 = (tmpvar_36 * tmpvar_36);
  specularTerm_32 = ((tmpvar_37 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_33), 0.0, 1.0)) * (1.5 + tmpvar_37))
   * 
    (((tmpvar_35 * tmpvar_35) * ((tmpvar_37 * tmpvar_37) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_38;
  tmpvar_38 = clamp (specularTerm_32, 0.0, 100.0);
  specularTerm_32 = tmpvar_38;
  mediump vec4 tmpvar_39;
  tmpvar_39.w = 1.0;
  tmpvar_39.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_38 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_29, lightDir_7), 0.0, 1.0));
  mediump vec4 tmpvar_40;
  tmpvar_40 = exp2(-(tmpvar_39));
  tmpvar_1 = tmpvar_40;
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  mediump float tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_17 = tmpvar_18;
  mediump float shadowAttenuation_19;
  shadowAttenuation_19 = 1.0;
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.0;
  tmpvar_20.xyz = tmpvar_10;
  highp vec4 tmpvar_21;
  tmpvar_21 = (unity_WorldToShadow[0] * tmpvar_20);
  lowp float tmpvar_22;
  highp vec4 tmpvar_23;
  tmpvar_23 = texture2DProj (_ShadowMapTexture, tmpvar_21);
  mediump float tmpvar_24;
  if ((tmpvar_23.x < (tmpvar_21.z / tmpvar_21.w))) {
    tmpvar_24 = _LightShadowData.x;
  } else {
    tmpvar_24 = 1.0;
  };
  tmpvar_22 = tmpvar_24;
  shadowAttenuation_19 = tmpvar_22;
  mediump float tmpvar_25;
  tmpvar_25 = clamp ((shadowAttenuation_19 + tmpvar_17), 0.0, 1.0);
  atten_6 = (atten_6 * tmpvar_25);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_28;
  mediump vec3 tmpvar_29;
  tmpvar_29 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_30;
  tmpvar_30 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_31;
  viewDir_31 = -(tmpvar_30);
  mediump float specularTerm_32;
  mediump vec3 tmpvar_33;
  mediump vec3 inVec_34;
  inVec_34 = (lightDir_7 + viewDir_31);
  tmpvar_33 = (inVec_34 * inversesqrt(max (0.001, 
    dot (inVec_34, inVec_34)
  )));
  mediump float tmpvar_35;
  tmpvar_35 = clamp (dot (tmpvar_29, tmpvar_33), 0.0, 1.0);
  mediump float tmpvar_36;
  tmpvar_36 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_37;
  tmpvar_37 = (tmpvar_36 * tmpvar_36);
  specularTerm_32 = ((tmpvar_37 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_33), 0.0, 1.0)) * (1.5 + tmpvar_37))
   * 
    (((tmpvar_35 * tmpvar_35) * ((tmpvar_37 * tmpvar_37) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_38;
  tmpvar_38 = clamp (specularTerm_32, 0.0, 100.0);
  specularTerm_32 = tmpvar_38;
  mediump vec4 tmpvar_39;
  tmpvar_39.w = 1.0;
  tmpvar_39.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_38 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_29, lightDir_7), 0.0, 1.0));
  mediump vec4 tmpvar_40;
  tmpvar_40 = exp2(-(tmpvar_39));
  tmpvar_1 = tmpvar_40;
  gl_FragData[0] = tmpvar_1;
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
mediump vec4 u_xlat16_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec4 u_xlat3;
mediump vec4 u_xlat16_4;
lowp vec3 u_xlat10_5;
mediump vec3 u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_7;
lowp float u_xlat10_7;
mediump float u_xlat16_11;
float u_xlat14;
bool u_xlatb14;
float u_xlat15;
mediump float u_xlat16_15;
float u_xlat22;
mediump float u_xlat16_25;
mediump float u_xlat16_27;
void main()
{
    u_xlat16_0.x = (-_LightShadowData.x) + 1.0;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat15 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat15 = _ZBufferParams.x * u_xlat15 + _ZBufferParams.y;
    u_xlat15 = float(1.0) / u_xlat15;
    u_xlat2.xyz = u_xlat7.xyz * vec3(u_xlat15);
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3 = u_xlat2.yyyy * hlslcc_mtx4x4unity_WorldToShadow[1];
    u_xlat3 = hlslcc_mtx4x4unity_WorldToShadow[0] * u_xlat2.xxxx + u_xlat3;
    u_xlat3 = hlslcc_mtx4x4unity_WorldToShadow[2] * u_xlat2.wwww + u_xlat3;
    u_xlat3 = u_xlat3 + hlslcc_mtx4x4unity_WorldToShadow[3];
    u_xlat3.xyz = u_xlat3.xyz / u_xlat3.www;
    vec3 txVec0 = vec3(u_xlat3.xy,u_xlat3.z);
    u_xlat10_7 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_0.x = u_xlat10_7 * u_xlat16_0.x + _LightShadowData.x;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat7.x = (-u_xlat7.z) * u_xlat15 + u_xlat7.x;
    u_xlat7.x = unity_ShadowFadeCenterAndType.w * u_xlat7.x + u_xlat2.z;
    u_xlat7.x = u_xlat7.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat7.x = min(max(u_xlat7.x, 0.0), 1.0);
#else
    u_xlat7.x = clamp(u_xlat7.x, 0.0, 1.0);
#endif
    u_xlat16_4.x = u_xlat7.x + u_xlat16_0.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat0.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat2.xxx + u_xlat0.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat2.www + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat0.xy = u_xlat0.xy / u_xlat0.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb14 = !!(u_xlat0.z<0.0);
#else
    u_xlatb14 = u_xlat0.z<0.0;
#endif
    u_xlat14 = u_xlatb14 ? 1.0 : float(0.0);
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.x = u_xlat14 * u_xlat0.x;
    u_xlat7.xyz = (-u_xlat2.xyw) + _LightPos.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat15 = dot(u_xlat7.xyz, u_xlat7.xyz);
    u_xlat22 = u_xlat15 * _LightPos.w;
    u_xlat15 = inversesqrt(u_xlat15);
    u_xlat7.xyz = u_xlat7.xyz * vec3(u_xlat15);
    u_xlat15 = texture(_LightTextureB0, vec2(u_xlat22)).w;
    u_xlat0.x = u_xlat0.x * u_xlat15;
    u_xlat0.x = u_xlat16_4.x * u_xlat0.x;
    u_xlat3.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat16_4.xyz = (-u_xlat2.xyz) * u_xlat0.xxx + u_xlat7.xyz;
    u_xlat16_25 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_0.x = max(u_xlat16_25, 0.00100000005);
    u_xlat16_25 = inversesqrt(u_xlat16_0.x);
    u_xlat16_4.xyz = vec3(u_xlat16_25) * u_xlat16_4.xyz;
    u_xlat16_25 = dot(u_xlat7.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_25 = min(max(u_xlat16_25, 0.0), 1.0);
#else
    u_xlat16_25 = clamp(u_xlat16_25, 0.0, 1.0);
#endif
    u_xlat16_0.x = max(u_xlat16_25, 0.319999993);
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat16_25 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_15 = u_xlat16_25 * u_xlat16_25 + 1.5;
    u_xlat16_25 = u_xlat16_25 * u_xlat16_25;
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_15;
    u_xlat10_5.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_5.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_27 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_27 = inversesqrt(u_xlat16_27);
    u_xlat16_6.xyz = vec3(u_xlat16_27) * u_xlat16_6.xyz;
    u_xlat16_4.x = dot(u_xlat16_6.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_11 = dot(u_xlat16_6.xyz, u_xlat7.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_11 = min(max(u_xlat16_11, 0.0), 1.0);
#else
    u_xlat16_11 = clamp(u_xlat16_11, 0.0, 1.0);
#endif
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_4.x;
    u_xlat16_7 = u_xlat16_25 * u_xlat16_25 + -1.0;
    u_xlat16_7 = u_xlat16_4.x * u_xlat16_7 + 1.00001001;
    u_xlat16_0.x = u_xlat16_7 * u_xlat16_0.x;
    u_xlat16_0.x = u_xlat16_25 / u_xlat16_0.x;
    u_xlat16_0.x = u_xlat16_0.x + -9.99999975e-05;
    u_xlat16_4.x = max(u_xlat16_0.x, 0.0);
    u_xlat16_4.x = min(u_xlat16_4.x, 100.0);
    u_xlat16_4.xzw = u_xlat16_4.xxx * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat16_4.xzw = u_xlat3.xyz * u_xlat16_4.xzw;
    u_xlat16_0.xyz = vec3(u_xlat16_11) * u_xlat16_4.xzw;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
mediump vec4 u_xlat16_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec4 u_xlat3;
mediump vec4 u_xlat16_4;
lowp vec3 u_xlat10_5;
mediump vec3 u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_7;
lowp float u_xlat10_7;
mediump float u_xlat16_11;
float u_xlat14;
bool u_xlatb14;
float u_xlat15;
mediump float u_xlat16_15;
float u_xlat22;
mediump float u_xlat16_25;
mediump float u_xlat16_27;
void main()
{
    u_xlat16_0.x = (-_LightShadowData.x) + 1.0;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat15 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat15 = _ZBufferParams.x * u_xlat15 + _ZBufferParams.y;
    u_xlat15 = float(1.0) / u_xlat15;
    u_xlat2.xyz = u_xlat7.xyz * vec3(u_xlat15);
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3 = u_xlat2.yyyy * hlslcc_mtx4x4unity_WorldToShadow[1];
    u_xlat3 = hlslcc_mtx4x4unity_WorldToShadow[0] * u_xlat2.xxxx + u_xlat3;
    u_xlat3 = hlslcc_mtx4x4unity_WorldToShadow[2] * u_xlat2.wwww + u_xlat3;
    u_xlat3 = u_xlat3 + hlslcc_mtx4x4unity_WorldToShadow[3];
    u_xlat3.xyz = u_xlat3.xyz / u_xlat3.www;
    vec3 txVec0 = vec3(u_xlat3.xy,u_xlat3.z);
    u_xlat10_7 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_0.x = u_xlat10_7 * u_xlat16_0.x + _LightShadowData.x;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat7.x = (-u_xlat7.z) * u_xlat15 + u_xlat7.x;
    u_xlat7.x = unity_ShadowFadeCenterAndType.w * u_xlat7.x + u_xlat2.z;
    u_xlat7.x = u_xlat7.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat7.x = min(max(u_xlat7.x, 0.0), 1.0);
#else
    u_xlat7.x = clamp(u_xlat7.x, 0.0, 1.0);
#endif
    u_xlat16_4.x = u_xlat7.x + u_xlat16_0.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat0.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat2.xxx + u_xlat0.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat2.www + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat0.xy = u_xlat0.xy / u_xlat0.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb14 = !!(u_xlat0.z<0.0);
#else
    u_xlatb14 = u_xlat0.z<0.0;
#endif
    u_xlat14 = u_xlatb14 ? 1.0 : float(0.0);
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.x = u_xlat14 * u_xlat0.x;
    u_xlat7.xyz = (-u_xlat2.xyw) + _LightPos.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat15 = dot(u_xlat7.xyz, u_xlat7.xyz);
    u_xlat22 = u_xlat15 * _LightPos.w;
    u_xlat15 = inversesqrt(u_xlat15);
    u_xlat7.xyz = u_xlat7.xyz * vec3(u_xlat15);
    u_xlat15 = texture(_LightTextureB0, vec2(u_xlat22)).w;
    u_xlat0.x = u_xlat0.x * u_xlat15;
    u_xlat0.x = u_xlat16_4.x * u_xlat0.x;
    u_xlat3.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat16_4.xyz = (-u_xlat2.xyz) * u_xlat0.xxx + u_xlat7.xyz;
    u_xlat16_25 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_0.x = max(u_xlat16_25, 0.00100000005);
    u_xlat16_25 = inversesqrt(u_xlat16_0.x);
    u_xlat16_4.xyz = vec3(u_xlat16_25) * u_xlat16_4.xyz;
    u_xlat16_25 = dot(u_xlat7.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_25 = min(max(u_xlat16_25, 0.0), 1.0);
#else
    u_xlat16_25 = clamp(u_xlat16_25, 0.0, 1.0);
#endif
    u_xlat16_0.x = max(u_xlat16_25, 0.319999993);
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat16_25 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_15 = u_xlat16_25 * u_xlat16_25 + 1.5;
    u_xlat16_25 = u_xlat16_25 * u_xlat16_25;
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_15;
    u_xlat10_5.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_5.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_27 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_27 = inversesqrt(u_xlat16_27);
    u_xlat16_6.xyz = vec3(u_xlat16_27) * u_xlat16_6.xyz;
    u_xlat16_4.x = dot(u_xlat16_6.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_11 = dot(u_xlat16_6.xyz, u_xlat7.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_11 = min(max(u_xlat16_11, 0.0), 1.0);
#else
    u_xlat16_11 = clamp(u_xlat16_11, 0.0, 1.0);
#endif
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_4.x;
    u_xlat16_7 = u_xlat16_25 * u_xlat16_25 + -1.0;
    u_xlat16_7 = u_xlat16_4.x * u_xlat16_7 + 1.00001001;
    u_xlat16_0.x = u_xlat16_7 * u_xlat16_0.x;
    u_xlat16_0.x = u_xlat16_25 / u_xlat16_0.x;
    u_xlat16_0.x = u_xlat16_0.x + -9.99999975e-05;
    u_xlat16_4.x = max(u_xlat16_0.x, 0.0);
    u_xlat16_4.x = min(u_xlat16_4.x, 100.0);
    u_xlat16_4.xzw = u_xlat16_4.xxx * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat16_4.xzw = u_xlat3.xyz * u_xlat16_4.xzw;
    u_xlat16_0.xyz = vec3(u_xlat16_11) * u_xlat16_4.xzw;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
    return;
}

#endif
"
}
SubProgram "gles " {
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  mediump float tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_17 = tmpvar_18;
  mediump float shadowAttenuation_19;
  shadowAttenuation_19 = 1.0;
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.0;
  tmpvar_20.xyz = tmpvar_10;
  highp vec4 tmpvar_21;
  tmpvar_21 = (unity_WorldToShadow[0] * tmpvar_20);
  lowp float tmpvar_22;
  highp vec4 shadowVals_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = (tmpvar_21.xyz / tmpvar_21.w);
  shadowVals_23.x = texture2D (_ShadowMapTexture, (tmpvar_24.xy + _ShadowOffsets[0].xy)).x;
  shadowVals_23.y = texture2D (_ShadowMapTexture, (tmpvar_24.xy + _ShadowOffsets[1].xy)).x;
  shadowVals_23.z = texture2D (_ShadowMapTexture, (tmpvar_24.xy + _ShadowOffsets[2].xy)).x;
  shadowVals_23.w = texture2D (_ShadowMapTexture, (tmpvar_24.xy + _ShadowOffsets[3].xy)).x;
  bvec4 tmpvar_25;
  tmpvar_25 = lessThan (shadowVals_23, tmpvar_24.zzzz);
  mediump vec4 tmpvar_26;
  tmpvar_26 = _LightShadowData.xxxx;
  mediump float tmpvar_27;
  if (tmpvar_25.x) {
    tmpvar_27 = tmpvar_26.x;
  } else {
    tmpvar_27 = 1.0;
  };
  mediump float tmpvar_28;
  if (tmpvar_25.y) {
    tmpvar_28 = tmpvar_26.y;
  } else {
    tmpvar_28 = 1.0;
  };
  mediump float tmpvar_29;
  if (tmpvar_25.z) {
    tmpvar_29 = tmpvar_26.z;
  } else {
    tmpvar_29 = 1.0;
  };
  mediump float tmpvar_30;
  if (tmpvar_25.w) {
    tmpvar_30 = tmpvar_26.w;
  } else {
    tmpvar_30 = 1.0;
  };
  mediump vec4 tmpvar_31;
  tmpvar_31.x = tmpvar_27;
  tmpvar_31.y = tmpvar_28;
  tmpvar_31.z = tmpvar_29;
  tmpvar_31.w = tmpvar_30;
  mediump float tmpvar_32;
  tmpvar_32 = dot (tmpvar_31, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_22 = tmpvar_32;
  shadowAttenuation_19 = tmpvar_22;
  mediump float tmpvar_33;
  tmpvar_33 = clamp ((shadowAttenuation_19 + tmpvar_17), 0.0, 1.0);
  atten_6 = (atten_6 * tmpvar_33);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_34;
  tmpvar_34 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_34;
  lowp vec4 tmpvar_35;
  tmpvar_35 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_35;
  lowp vec4 tmpvar_36;
  tmpvar_36 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_36;
  mediump vec3 tmpvar_37;
  tmpvar_37 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_38;
  tmpvar_38 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_39;
  viewDir_39 = -(tmpvar_38);
  mediump vec2 tmpvar_40;
  tmpvar_40.x = dot ((viewDir_39 - (2.0 * 
    (dot (tmpvar_37, viewDir_39) * tmpvar_37)
  )), lightDir_7);
  tmpvar_40.y = (1.0 - clamp (dot (tmpvar_37, viewDir_39), 0.0, 1.0));
  mediump float specular_41;
  mediump vec2 tmpvar_42;
  tmpvar_42.x = ((tmpvar_40 * tmpvar_40) * (tmpvar_40 * tmpvar_40)).x;
  tmpvar_42.y = (1.0 - gbuffer1_3.w);
  highp float tmpvar_43;
  tmpvar_43 = (texture2D (unity_NHxRoughness, tmpvar_42).w * 16.0);
  specular_41 = tmpvar_43;
  mediump vec4 tmpvar_44;
  tmpvar_44.w = 1.0;
  tmpvar_44.xyz = ((gbuffer0_4.xyz + (specular_41 * gbuffer1_3.xyz)) * (tmpvar_5 * clamp (
    dot (tmpvar_37, lightDir_7)
  , 0.0, 1.0)));
  mediump vec4 tmpvar_45;
  tmpvar_45 = exp2(-(tmpvar_44));
  tmpvar_1 = tmpvar_45;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 " {
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _ShadowOffsets[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform highp sampler2D unity_NHxRoughness;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
mediump vec4 u_xlat16_0;
lowp vec4 u_xlat10_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
vec4 u_xlat3;
vec4 u_xlat4;
lowp vec3 u_xlat10_4;
vec3 u_xlat5;
mediump vec3 u_xlat16_6;
mediump vec3 u_xlat16_7;
vec3 u_xlat8;
mediump float u_xlat16_8;
float u_xlat16;
bool u_xlatb16;
float u_xlat17;
float u_xlat24;
float u_xlat25;
mediump float u_xlat16_30;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat24 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat24 = _ZBufferParams.x * u_xlat24 + _ZBufferParams.y;
    u_xlat24 = float(1.0) / u_xlat24;
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat0.xyz;
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
    u_xlat0.x = dot(u_xlat4, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat16_8 = (-_LightShadowData.x) + 1.0;
    u_xlat0.x = u_xlat0.x * u_xlat16_8 + _LightShadowData.x;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat8.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat8.x = sqrt(u_xlat8.x);
    u_xlat8.x = (-u_xlat0.z) * u_xlat24 + u_xlat8.x;
    u_xlat8.x = unity_ShadowFadeCenterAndType.w * u_xlat8.x + u_xlat2.z;
    u_xlat8.x = u_xlat8.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat8.x = min(max(u_xlat8.x, 0.0), 1.0);
#else
    u_xlat8.x = clamp(u_xlat8.x, 0.0, 1.0);
#endif
    u_xlat16_6.x = u_xlat8.x + u_xlat0.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_6.x = min(max(u_xlat16_6.x, 0.0), 1.0);
#else
    u_xlat16_6.x = clamp(u_xlat16_6.x, 0.0, 1.0);
#endif
    u_xlat0.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat2.xxx + u_xlat0.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat2.www + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat0.xy = u_xlat0.xy / u_xlat0.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb16 = !!(u_xlat0.z<0.0);
#else
    u_xlatb16 = u_xlat0.z<0.0;
#endif
    u_xlat16 = u_xlatb16 ? 1.0 : float(0.0);
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.x = u_xlat16 * u_xlat0.x;
    u_xlat8.xyz = (-u_xlat2.xyw) + _LightPos.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat17 = dot(u_xlat8.xyz, u_xlat8.xyz);
    u_xlat25 = u_xlat17 * _LightPos.w;
    u_xlat17 = inversesqrt(u_xlat17);
    u_xlat8.xyz = u_xlat8.xyz * vec3(u_xlat17);
    u_xlat17 = texture(_LightTextureB0, vec2(u_xlat25)).w;
    u_xlat0.x = u_xlat0.x * u_xlat17;
    u_xlat0.x = u_xlat16_6.x * u_xlat0.x;
    u_xlat3.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat10_4.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_4.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_30 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_30 = inversesqrt(u_xlat16_30);
    u_xlat16_6.xyz = vec3(u_xlat16_30) * u_xlat16_6.xyz;
    u_xlat16_30 = dot(u_xlat16_6.xyz, u_xlat8.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_30 = min(max(u_xlat16_30, 0.0), 1.0);
#else
    u_xlat16_30 = clamp(u_xlat16_30, 0.0, 1.0);
#endif
    u_xlat16_7.xyz = u_xlat3.xyz * vec3(u_xlat16_30);
    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat2.xyz = u_xlat0.xxx * u_xlat2.xyz;
    u_xlat16_30 = dot((-u_xlat2.xyz), u_xlat16_6.xyz);
    u_xlat16_30 = u_xlat16_30 + u_xlat16_30;
    u_xlat16_6.xyz = u_xlat16_6.xyz * (-vec3(u_xlat16_30)) + (-u_xlat2.xyz);
    u_xlat16_6.x = dot(u_xlat16_6.xyz, u_xlat8.xyz);
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_6.x;
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_6.x;
    u_xlat10_0 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_6.y = (-u_xlat10_0.w) + 1.0;
    u_xlat24 = texture(unity_NHxRoughness, u_xlat16_6.xy).w;
    u_xlat24 = u_xlat24 * 16.0;
    u_xlat16_6.xyz = vec3(u_xlat24) * u_xlat10_0.xyz + u_xlat10_1.xyz;
    u_xlat16_0.xyz = u_xlat16_7.xyz * u_xlat16_6.xyz;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
    return;
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  mediump float tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_17 = tmpvar_18;
  mediump float shadowAttenuation_19;
  shadowAttenuation_19 = 1.0;
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.0;
  tmpvar_20.xyz = tmpvar_10;
  highp vec4 tmpvar_21;
  tmpvar_21 = (unity_WorldToShadow[0] * tmpvar_20);
  lowp float tmpvar_22;
  highp vec4 shadowVals_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = (tmpvar_21.xyz / tmpvar_21.w);
  shadowVals_23.x = texture2D (_ShadowMapTexture, (tmpvar_24.xy + _ShadowOffsets[0].xy)).x;
  shadowVals_23.y = texture2D (_ShadowMapTexture, (tmpvar_24.xy + _ShadowOffsets[1].xy)).x;
  shadowVals_23.z = texture2D (_ShadowMapTexture, (tmpvar_24.xy + _ShadowOffsets[2].xy)).x;
  shadowVals_23.w = texture2D (_ShadowMapTexture, (tmpvar_24.xy + _ShadowOffsets[3].xy)).x;
  bvec4 tmpvar_25;
  tmpvar_25 = lessThan (shadowVals_23, tmpvar_24.zzzz);
  mediump vec4 tmpvar_26;
  tmpvar_26 = _LightShadowData.xxxx;
  mediump float tmpvar_27;
  if (tmpvar_25.x) {
    tmpvar_27 = tmpvar_26.x;
  } else {
    tmpvar_27 = 1.0;
  };
  mediump float tmpvar_28;
  if (tmpvar_25.y) {
    tmpvar_28 = tmpvar_26.y;
  } else {
    tmpvar_28 = 1.0;
  };
  mediump float tmpvar_29;
  if (tmpvar_25.z) {
    tmpvar_29 = tmpvar_26.z;
  } else {
    tmpvar_29 = 1.0;
  };
  mediump float tmpvar_30;
  if (tmpvar_25.w) {
    tmpvar_30 = tmpvar_26.w;
  } else {
    tmpvar_30 = 1.0;
  };
  mediump vec4 tmpvar_31;
  tmpvar_31.x = tmpvar_27;
  tmpvar_31.y = tmpvar_28;
  tmpvar_31.z = tmpvar_29;
  tmpvar_31.w = tmpvar_30;
  mediump float tmpvar_32;
  tmpvar_32 = dot (tmpvar_31, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_22 = tmpvar_32;
  shadowAttenuation_19 = tmpvar_22;
  mediump float tmpvar_33;
  tmpvar_33 = clamp ((shadowAttenuation_19 + tmpvar_17), 0.0, 1.0);
  atten_6 = (atten_6 * tmpvar_33);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_34;
  tmpvar_34 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_34;
  lowp vec4 tmpvar_35;
  tmpvar_35 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_35;
  lowp vec4 tmpvar_36;
  tmpvar_36 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_36;
  mediump vec3 tmpvar_37;
  tmpvar_37 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_38;
  tmpvar_38 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_39;
  viewDir_39 = -(tmpvar_38);
  mediump float specularTerm_40;
  mediump vec3 tmpvar_41;
  mediump vec3 inVec_42;
  inVec_42 = (lightDir_7 + viewDir_39);
  tmpvar_41 = (inVec_42 * inversesqrt(max (0.001, 
    dot (inVec_42, inVec_42)
  )));
  mediump float tmpvar_43;
  tmpvar_43 = clamp (dot (tmpvar_37, tmpvar_41), 0.0, 1.0);
  mediump float tmpvar_44;
  tmpvar_44 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_45;
  tmpvar_45 = (tmpvar_44 * tmpvar_44);
  specularTerm_40 = ((tmpvar_45 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_41), 0.0, 1.0)) * (1.5 + tmpvar_45))
   * 
    (((tmpvar_43 * tmpvar_43) * ((tmpvar_45 * tmpvar_45) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_46;
  tmpvar_46 = clamp (specularTerm_40, 0.0, 100.0);
  specularTerm_40 = tmpvar_46;
  mediump vec4 tmpvar_47;
  tmpvar_47.w = 1.0;
  tmpvar_47.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_46 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_37, lightDir_7), 0.0, 1.0));
  mediump vec4 tmpvar_48;
  tmpvar_48 = exp2(-(tmpvar_47));
  tmpvar_1 = tmpvar_48;
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  mediump float tmpvar_17;
  highp float tmpvar_18;
  tmpvar_18 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_17 = tmpvar_18;
  mediump float shadowAttenuation_19;
  shadowAttenuation_19 = 1.0;
  highp vec4 tmpvar_20;
  tmpvar_20.w = 1.0;
  tmpvar_20.xyz = tmpvar_10;
  highp vec4 tmpvar_21;
  tmpvar_21 = (unity_WorldToShadow[0] * tmpvar_20);
  lowp float tmpvar_22;
  highp vec4 shadowVals_23;
  highp vec3 tmpvar_24;
  tmpvar_24 = (tmpvar_21.xyz / tmpvar_21.w);
  shadowVals_23.x = texture2D (_ShadowMapTexture, (tmpvar_24.xy + _ShadowOffsets[0].xy)).x;
  shadowVals_23.y = texture2D (_ShadowMapTexture, (tmpvar_24.xy + _ShadowOffsets[1].xy)).x;
  shadowVals_23.z = texture2D (_ShadowMapTexture, (tmpvar_24.xy + _ShadowOffsets[2].xy)).x;
  shadowVals_23.w = texture2D (_ShadowMapTexture, (tmpvar_24.xy + _ShadowOffsets[3].xy)).x;
  bvec4 tmpvar_25;
  tmpvar_25 = lessThan (shadowVals_23, tmpvar_24.zzzz);
  mediump vec4 tmpvar_26;
  tmpvar_26 = _LightShadowData.xxxx;
  mediump float tmpvar_27;
  if (tmpvar_25.x) {
    tmpvar_27 = tmpvar_26.x;
  } else {
    tmpvar_27 = 1.0;
  };
  mediump float tmpvar_28;
  if (tmpvar_25.y) {
    tmpvar_28 = tmpvar_26.y;
  } else {
    tmpvar_28 = 1.0;
  };
  mediump float tmpvar_29;
  if (tmpvar_25.z) {
    tmpvar_29 = tmpvar_26.z;
  } else {
    tmpvar_29 = 1.0;
  };
  mediump float tmpvar_30;
  if (tmpvar_25.w) {
    tmpvar_30 = tmpvar_26.w;
  } else {
    tmpvar_30 = 1.0;
  };
  mediump vec4 tmpvar_31;
  tmpvar_31.x = tmpvar_27;
  tmpvar_31.y = tmpvar_28;
  tmpvar_31.z = tmpvar_29;
  tmpvar_31.w = tmpvar_30;
  mediump float tmpvar_32;
  tmpvar_32 = dot (tmpvar_31, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_22 = tmpvar_32;
  shadowAttenuation_19 = tmpvar_22;
  mediump float tmpvar_33;
  tmpvar_33 = clamp ((shadowAttenuation_19 + tmpvar_17), 0.0, 1.0);
  atten_6 = (atten_6 * tmpvar_33);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_34;
  tmpvar_34 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_34;
  lowp vec4 tmpvar_35;
  tmpvar_35 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_35;
  lowp vec4 tmpvar_36;
  tmpvar_36 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_36;
  mediump vec3 tmpvar_37;
  tmpvar_37 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_38;
  tmpvar_38 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_39;
  viewDir_39 = -(tmpvar_38);
  mediump float specularTerm_40;
  mediump vec3 tmpvar_41;
  mediump vec3 inVec_42;
  inVec_42 = (lightDir_7 + viewDir_39);
  tmpvar_41 = (inVec_42 * inversesqrt(max (0.001, 
    dot (inVec_42, inVec_42)
  )));
  mediump float tmpvar_43;
  tmpvar_43 = clamp (dot (tmpvar_37, tmpvar_41), 0.0, 1.0);
  mediump float tmpvar_44;
  tmpvar_44 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_45;
  tmpvar_45 = (tmpvar_44 * tmpvar_44);
  specularTerm_40 = ((tmpvar_45 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_41), 0.0, 1.0)) * (1.5 + tmpvar_45))
   * 
    (((tmpvar_43 * tmpvar_43) * ((tmpvar_45 * tmpvar_45) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_46;
  tmpvar_46 = clamp (specularTerm_40, 0.0, 100.0);
  specularTerm_40 = tmpvar_46;
  mediump vec4 tmpvar_47;
  tmpvar_47.w = 1.0;
  tmpvar_47.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_46 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_37, lightDir_7), 0.0, 1.0));
  mediump vec4 tmpvar_48;
  tmpvar_48 = exp2(-(tmpvar_47));
  tmpvar_1 = tmpvar_48;
  gl_FragData[0] = tmpvar_1;
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _ShadowOffsets[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
mediump vec4 u_xlat16_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec4 u_xlat3;
vec4 u_xlat4;
lowp vec3 u_xlat10_4;
vec3 u_xlat5;
mediump vec4 u_xlat16_6;
mediump vec3 u_xlat16_7;
vec3 u_xlat8;
mediump float u_xlat16_8;
mediump float u_xlat16_14;
float u_xlat16;
bool u_xlatb16;
float u_xlat17;
mediump float u_xlat16_17;
float u_xlat24;
float u_xlat25;
mediump float u_xlat16_30;
mediump float u_xlat16_31;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat24 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat24 = _ZBufferParams.x * u_xlat24 + _ZBufferParams.y;
    u_xlat24 = float(1.0) / u_xlat24;
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat0.xyz;
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
    u_xlat0.x = dot(u_xlat4, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat16_8 = (-_LightShadowData.x) + 1.0;
    u_xlat0.x = u_xlat0.x * u_xlat16_8 + _LightShadowData.x;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat8.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat8.x = sqrt(u_xlat8.x);
    u_xlat8.x = (-u_xlat0.z) * u_xlat24 + u_xlat8.x;
    u_xlat8.x = unity_ShadowFadeCenterAndType.w * u_xlat8.x + u_xlat2.z;
    u_xlat8.x = u_xlat8.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat8.x = min(max(u_xlat8.x, 0.0), 1.0);
#else
    u_xlat8.x = clamp(u_xlat8.x, 0.0, 1.0);
#endif
    u_xlat16_6.x = u_xlat8.x + u_xlat0.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_6.x = min(max(u_xlat16_6.x, 0.0), 1.0);
#else
    u_xlat16_6.x = clamp(u_xlat16_6.x, 0.0, 1.0);
#endif
    u_xlat0.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat2.xxx + u_xlat0.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat2.www + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat0.xy = u_xlat0.xy / u_xlat0.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb16 = !!(u_xlat0.z<0.0);
#else
    u_xlatb16 = u_xlat0.z<0.0;
#endif
    u_xlat16 = u_xlatb16 ? 1.0 : float(0.0);
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.x = u_xlat16 * u_xlat0.x;
    u_xlat8.xyz = (-u_xlat2.xyw) + _LightPos.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat17 = dot(u_xlat8.xyz, u_xlat8.xyz);
    u_xlat25 = u_xlat17 * _LightPos.w;
    u_xlat17 = inversesqrt(u_xlat17);
    u_xlat8.xyz = u_xlat8.xyz * vec3(u_xlat17);
    u_xlat17 = texture(_LightTextureB0, vec2(u_xlat25)).w;
    u_xlat0.x = u_xlat0.x * u_xlat17;
    u_xlat0.x = u_xlat16_6.x * u_xlat0.x;
    u_xlat3.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat16_6.xyz = (-u_xlat2.xyz) * u_xlat0.xxx + u_xlat8.xyz;
    u_xlat16_30 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_0.x = max(u_xlat16_30, 0.00100000005);
    u_xlat16_30 = inversesqrt(u_xlat16_0.x);
    u_xlat16_6.xyz = vec3(u_xlat16_30) * u_xlat16_6.xyz;
    u_xlat16_30 = dot(u_xlat8.xyz, u_xlat16_6.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_30 = min(max(u_xlat16_30, 0.0), 1.0);
#else
    u_xlat16_30 = clamp(u_xlat16_30, 0.0, 1.0);
#endif
    u_xlat16_0.x = max(u_xlat16_30, 0.319999993);
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat16_30 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_17 = u_xlat16_30 * u_xlat16_30 + 1.5;
    u_xlat16_30 = u_xlat16_30 * u_xlat16_30;
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_17;
    u_xlat10_4.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_7.xyz = u_xlat10_4.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_31 = dot(u_xlat16_7.xyz, u_xlat16_7.xyz);
    u_xlat16_31 = inversesqrt(u_xlat16_31);
    u_xlat16_7.xyz = vec3(u_xlat16_31) * u_xlat16_7.xyz;
    u_xlat16_6.x = dot(u_xlat16_7.xyz, u_xlat16_6.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_6.x = min(max(u_xlat16_6.x, 0.0), 1.0);
#else
    u_xlat16_6.x = clamp(u_xlat16_6.x, 0.0, 1.0);
#endif
    u_xlat16_14 = dot(u_xlat16_7.xyz, u_xlat8.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_14 = min(max(u_xlat16_14, 0.0), 1.0);
#else
    u_xlat16_14 = clamp(u_xlat16_14, 0.0, 1.0);
#endif
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_6.x;
    u_xlat16_8 = u_xlat16_30 * u_xlat16_30 + -1.0;
    u_xlat16_8 = u_xlat16_6.x * u_xlat16_8 + 1.00001001;
    u_xlat16_0.x = u_xlat16_8 * u_xlat16_0.x;
    u_xlat16_0.x = u_xlat16_30 / u_xlat16_0.x;
    u_xlat16_0.x = u_xlat16_0.x + -9.99999975e-05;
    u_xlat16_6.x = max(u_xlat16_0.x, 0.0);
    u_xlat16_6.x = min(u_xlat16_6.x, 100.0);
    u_xlat16_6.xzw = u_xlat16_6.xxx * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat16_6.xzw = u_xlat3.xyz * u_xlat16_6.xzw;
    u_xlat16_0.xyz = vec3(u_xlat16_14) * u_xlat16_6.xzw;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _ShadowOffsets[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
mediump vec4 u_xlat16_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec4 u_xlat3;
vec4 u_xlat4;
lowp vec3 u_xlat10_4;
vec3 u_xlat5;
mediump vec4 u_xlat16_6;
mediump vec3 u_xlat16_7;
vec3 u_xlat8;
mediump float u_xlat16_8;
mediump float u_xlat16_14;
float u_xlat16;
bool u_xlatb16;
float u_xlat17;
mediump float u_xlat16_17;
float u_xlat24;
float u_xlat25;
mediump float u_xlat16_30;
mediump float u_xlat16_31;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat24 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat24 = _ZBufferParams.x * u_xlat24 + _ZBufferParams.y;
    u_xlat24 = float(1.0) / u_xlat24;
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat0.xyz;
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
    u_xlat0.x = dot(u_xlat4, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat16_8 = (-_LightShadowData.x) + 1.0;
    u_xlat0.x = u_xlat0.x * u_xlat16_8 + _LightShadowData.x;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat8.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat8.x = sqrt(u_xlat8.x);
    u_xlat8.x = (-u_xlat0.z) * u_xlat24 + u_xlat8.x;
    u_xlat8.x = unity_ShadowFadeCenterAndType.w * u_xlat8.x + u_xlat2.z;
    u_xlat8.x = u_xlat8.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat8.x = min(max(u_xlat8.x, 0.0), 1.0);
#else
    u_xlat8.x = clamp(u_xlat8.x, 0.0, 1.0);
#endif
    u_xlat16_6.x = u_xlat8.x + u_xlat0.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_6.x = min(max(u_xlat16_6.x, 0.0), 1.0);
#else
    u_xlat16_6.x = clamp(u_xlat16_6.x, 0.0, 1.0);
#endif
    u_xlat0.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat2.xxx + u_xlat0.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat2.www + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat0.xy = u_xlat0.xy / u_xlat0.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb16 = !!(u_xlat0.z<0.0);
#else
    u_xlatb16 = u_xlat0.z<0.0;
#endif
    u_xlat16 = u_xlatb16 ? 1.0 : float(0.0);
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.x = u_xlat16 * u_xlat0.x;
    u_xlat8.xyz = (-u_xlat2.xyw) + _LightPos.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat17 = dot(u_xlat8.xyz, u_xlat8.xyz);
    u_xlat25 = u_xlat17 * _LightPos.w;
    u_xlat17 = inversesqrt(u_xlat17);
    u_xlat8.xyz = u_xlat8.xyz * vec3(u_xlat17);
    u_xlat17 = texture(_LightTextureB0, vec2(u_xlat25)).w;
    u_xlat0.x = u_xlat0.x * u_xlat17;
    u_xlat0.x = u_xlat16_6.x * u_xlat0.x;
    u_xlat3.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat16_6.xyz = (-u_xlat2.xyz) * u_xlat0.xxx + u_xlat8.xyz;
    u_xlat16_30 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_0.x = max(u_xlat16_30, 0.00100000005);
    u_xlat16_30 = inversesqrt(u_xlat16_0.x);
    u_xlat16_6.xyz = vec3(u_xlat16_30) * u_xlat16_6.xyz;
    u_xlat16_30 = dot(u_xlat8.xyz, u_xlat16_6.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_30 = min(max(u_xlat16_30, 0.0), 1.0);
#else
    u_xlat16_30 = clamp(u_xlat16_30, 0.0, 1.0);
#endif
    u_xlat16_0.x = max(u_xlat16_30, 0.319999993);
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat16_30 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_17 = u_xlat16_30 * u_xlat16_30 + 1.5;
    u_xlat16_30 = u_xlat16_30 * u_xlat16_30;
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_17;
    u_xlat10_4.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_7.xyz = u_xlat10_4.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_31 = dot(u_xlat16_7.xyz, u_xlat16_7.xyz);
    u_xlat16_31 = inversesqrt(u_xlat16_31);
    u_xlat16_7.xyz = vec3(u_xlat16_31) * u_xlat16_7.xyz;
    u_xlat16_6.x = dot(u_xlat16_7.xyz, u_xlat16_6.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_6.x = min(max(u_xlat16_6.x, 0.0), 1.0);
#else
    u_xlat16_6.x = clamp(u_xlat16_6.x, 0.0, 1.0);
#endif
    u_xlat16_14 = dot(u_xlat16_7.xyz, u_xlat8.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_14 = min(max(u_xlat16_14, 0.0), 1.0);
#else
    u_xlat16_14 = clamp(u_xlat16_14, 0.0, 1.0);
#endif
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_6.x;
    u_xlat16_8 = u_xlat16_30 * u_xlat16_30 + -1.0;
    u_xlat16_8 = u_xlat16_6.x * u_xlat16_8 + 1.00001001;
    u_xlat16_0.x = u_xlat16_8 * u_xlat16_0.x;
    u_xlat16_0.x = u_xlat16_30 / u_xlat16_0.x;
    u_xlat16_0.x = u_xlat16_0.x + -9.99999975e-05;
    u_xlat16_6.x = max(u_xlat16_0.x, 0.0);
    u_xlat16_6.x = min(u_xlat16_6.x, 100.0);
    u_xlat16_6.xzw = u_xlat16_6.xxx * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat16_6.xzw = u_xlat3.xyz * u_xlat16_6.xzw;
    u_xlat16_0.xyz = vec3(u_xlat16_14) * u_xlat16_6.xzw;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
    return;
}

#endif
"
}
SubProgram "gles " {
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
uniform sampler2D _ShadowMapTexture;
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  mediump float tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_13 = tmpvar_14;
  mediump float shadowAttenuation_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_ShadowMapTexture, tmpvar_8);
  shadowAttenuation_15 = tmpvar_16.x;
  mediump float tmpvar_17;
  tmpvar_17 = clamp ((shadowAttenuation_15 + tmpvar_13), 0.0, 1.0);
  atten_6 = tmpvar_17;
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_20;
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_23;
  viewDir_23 = -(tmpvar_22);
  mediump vec2 tmpvar_24;
  tmpvar_24.x = dot ((viewDir_23 - (2.0 * 
    (dot (tmpvar_21, viewDir_23) * tmpvar_21)
  )), lightDir_7);
  tmpvar_24.y = (1.0 - clamp (dot (tmpvar_21, viewDir_23), 0.0, 1.0));
  mediump float specular_25;
  mediump vec2 tmpvar_26;
  tmpvar_26.x = ((tmpvar_24 * tmpvar_24) * (tmpvar_24 * tmpvar_24)).x;
  tmpvar_26.y = (1.0 - gbuffer1_3.w);
  highp float tmpvar_27;
  tmpvar_27 = (texture2D (unity_NHxRoughness, tmpvar_26).w * 16.0);
  specular_25 = tmpvar_27;
  mediump vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = ((gbuffer0_4.xyz + (specular_25 * gbuffer1_3.xyz)) * (tmpvar_5 * clamp (
    dot (tmpvar_21, lightDir_7)
  , 0.0, 1.0)));
  mediump vec4 tmpvar_29;
  tmpvar_29 = exp2(-(tmpvar_28));
  tmpvar_1 = tmpvar_29;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 " {
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
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform highp sampler2D unity_NHxRoughness;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec2 u_xlat1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
lowp vec3 u_xlat10_3;
mediump vec3 u_xlat16_4;
mediump vec3 u_xlat16_5;
vec3 u_xlat6;
mediump float u_xlat16_10;
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
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat18 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat6.xyz = u_xlat6.xxx * u_xlat3.xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_4.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat16_22 = dot((-u_xlat6.xyz), u_xlat16_4.xyz);
    u_xlat16_22 = u_xlat16_22 + u_xlat16_22;
    u_xlat16_5.xyz = u_xlat16_4.xyz * (-vec3(u_xlat16_22)) + (-u_xlat6.xyz);
    u_xlat16_4.x = dot(u_xlat16_4.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10 = dot(u_xlat16_5.xyz, (-_LightDir.xyz));
    u_xlat16_10 = u_xlat16_10 * u_xlat16_10;
    u_xlat16_5.x = u_xlat16_10 * u_xlat16_10;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat16_5.y = (-u_xlat10_2.w) + 1.0;
    u_xlat6.x = texture(unity_NHxRoughness, u_xlat16_5.xy).w;
    u_xlat6.x = u_xlat6.x * 16.0;
    u_xlat10_3.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat10_12 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat16_10 = u_xlat0.x + u_xlat10_12;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_10 = min(max(u_xlat16_10, 0.0), 1.0);
#else
    u_xlat16_10 = clamp(u_xlat16_10, 0.0, 1.0);
#endif
    u_xlat0.xzw = vec3(u_xlat16_10) * _LightColor.xyz;
    u_xlat16_4.xyz = u_xlat16_4.xxx * u_xlat0.xzw;
    u_xlat16_5.xyz = u_xlat6.xxx * u_xlat10_2.xyz + u_xlat10_3.xyz;
    u_xlat16_0.xyz = u_xlat16_4.xyz * u_xlat16_5.xyz;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
    return;
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
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  mediump float tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_13 = tmpvar_14;
  mediump float shadowAttenuation_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_ShadowMapTexture, tmpvar_8);
  shadowAttenuation_15 = tmpvar_16.x;
  mediump float tmpvar_17;
  tmpvar_17 = clamp ((shadowAttenuation_15 + tmpvar_13), 0.0, 1.0);
  atten_6 = tmpvar_17;
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_20;
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_23;
  viewDir_23 = -(tmpvar_22);
  mediump float specularTerm_24;
  mediump vec3 tmpvar_25;
  mediump vec3 inVec_26;
  inVec_26 = (lightDir_7 + viewDir_23);
  tmpvar_25 = (inVec_26 * inversesqrt(max (0.001, 
    dot (inVec_26, inVec_26)
  )));
  mediump float tmpvar_27;
  tmpvar_27 = clamp (dot (tmpvar_21, tmpvar_25), 0.0, 1.0);
  mediump float tmpvar_28;
  tmpvar_28 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_29;
  tmpvar_29 = (tmpvar_28 * tmpvar_28);
  specularTerm_24 = ((tmpvar_29 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_25), 0.0, 1.0)) * (1.5 + tmpvar_29))
   * 
    (((tmpvar_27 * tmpvar_27) * ((tmpvar_29 * tmpvar_29) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_30;
  tmpvar_30 = clamp (specularTerm_24, 0.0, 100.0);
  specularTerm_24 = tmpvar_30;
  mediump vec4 tmpvar_31;
  tmpvar_31.w = 1.0;
  tmpvar_31.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_30 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_21, lightDir_7), 0.0, 1.0));
  mediump vec4 tmpvar_32;
  tmpvar_32 = exp2(-(tmpvar_31));
  tmpvar_1 = tmpvar_32;
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
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  mediump float tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_13 = tmpvar_14;
  mediump float shadowAttenuation_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_ShadowMapTexture, tmpvar_8);
  shadowAttenuation_15 = tmpvar_16.x;
  mediump float tmpvar_17;
  tmpvar_17 = clamp ((shadowAttenuation_15 + tmpvar_13), 0.0, 1.0);
  atten_6 = tmpvar_17;
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_20;
  mediump vec3 tmpvar_21;
  tmpvar_21 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_22;
  tmpvar_22 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_23;
  viewDir_23 = -(tmpvar_22);
  mediump float specularTerm_24;
  mediump vec3 tmpvar_25;
  mediump vec3 inVec_26;
  inVec_26 = (lightDir_7 + viewDir_23);
  tmpvar_25 = (inVec_26 * inversesqrt(max (0.001, 
    dot (inVec_26, inVec_26)
  )));
  mediump float tmpvar_27;
  tmpvar_27 = clamp (dot (tmpvar_21, tmpvar_25), 0.0, 1.0);
  mediump float tmpvar_28;
  tmpvar_28 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_29;
  tmpvar_29 = (tmpvar_28 * tmpvar_28);
  specularTerm_24 = ((tmpvar_29 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_25), 0.0, 1.0)) * (1.5 + tmpvar_29))
   * 
    (((tmpvar_27 * tmpvar_27) * ((tmpvar_29 * tmpvar_29) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_30;
  tmpvar_30 = clamp (specularTerm_24, 0.0, 100.0);
  specularTerm_24 = tmpvar_30;
  mediump vec4 tmpvar_31;
  tmpvar_31.w = 1.0;
  tmpvar_31.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_30 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_21, lightDir_7), 0.0, 1.0));
  mediump vec4 tmpvar_32;
  tmpvar_32 = exp2(-(tmpvar_31));
  tmpvar_1 = tmpvar_32;
  gl_FragData[0] = tmpvar_1;
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
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
mediump vec4 u_xlat16_0;
vec3 u_xlat1;
lowp float u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump vec3 u_xlat16_5;
float u_xlat6;
mediump float u_xlat16_6;
lowp vec3 u_xlat10_6;
mediump vec3 u_xlat16_10;
mediump float u_xlat16_12;
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
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat6 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6 = inversesqrt(u_xlat6);
    u_xlat16_4.xyz = (-u_xlat3.xyz) * vec3(u_xlat6) + (-_LightDir.xyz);
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_6 = max(u_xlat16_22, 0.00100000005);
    u_xlat16_22 = inversesqrt(u_xlat16_6);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat10_6.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_6.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_5.xyz = vec3(u_xlat16_22) * u_xlat16_5.xyz;
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_22 = min(max(u_xlat16_22, 0.0), 1.0);
#else
    u_xlat16_22 = clamp(u_xlat16_22, 0.0, 1.0);
#endif
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_6 = max(u_xlat16_4.x, 0.319999993);
    u_xlat16_4.x = dot(u_xlat16_5.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10.x = u_xlat16_22 * u_xlat16_22;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat16_16 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_22 = u_xlat16_16 * u_xlat16_16;
    u_xlat16_12 = u_xlat16_16 * u_xlat16_16 + 1.5;
    u_xlat16_6 = u_xlat16_12 * u_xlat16_6;
    u_xlat16_12 = u_xlat16_22 * u_xlat16_22 + -1.0;
    u_xlat16_12 = u_xlat16_10.x * u_xlat16_12 + 1.00001001;
    u_xlat16_6 = u_xlat16_12 * u_xlat16_6;
    u_xlat16_6 = u_xlat16_22 / u_xlat16_6;
    u_xlat16_6 = u_xlat16_6 + -9.99999975e-05;
    u_xlat16_10.x = max(u_xlat16_6, 0.0);
    u_xlat16_10.x = min(u_xlat16_10.x, 100.0);
    u_xlat10_6.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat10_1 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat16_16 = u_xlat0.x + u_xlat10_1;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_16 = min(max(u_xlat16_16, 0.0), 1.0);
#else
    u_xlat16_16 = clamp(u_xlat16_16, 0.0, 1.0);
#endif
    u_xlat1.xyz = vec3(u_xlat16_16) * _LightColor.xyz;
    u_xlat16_10.xyz = u_xlat16_10.xxx * u_xlat10_2.xyz + u_xlat10_6.xyz;
    u_xlat16_10.xyz = u_xlat1.xyz * u_xlat16_10.xyz;
    u_xlat16_0.xyz = u_xlat16_4.xxx * u_xlat16_10.xyz;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
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
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
mediump vec4 u_xlat16_0;
vec3 u_xlat1;
lowp float u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump vec3 u_xlat16_5;
float u_xlat6;
mediump float u_xlat16_6;
lowp vec3 u_xlat10_6;
mediump vec3 u_xlat16_10;
mediump float u_xlat16_12;
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
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat6 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6 = inversesqrt(u_xlat6);
    u_xlat16_4.xyz = (-u_xlat3.xyz) * vec3(u_xlat6) + (-_LightDir.xyz);
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_6 = max(u_xlat16_22, 0.00100000005);
    u_xlat16_22 = inversesqrt(u_xlat16_6);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat10_6.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_6.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_5.xyz = vec3(u_xlat16_22) * u_xlat16_5.xyz;
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_22 = min(max(u_xlat16_22, 0.0), 1.0);
#else
    u_xlat16_22 = clamp(u_xlat16_22, 0.0, 1.0);
#endif
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_6 = max(u_xlat16_4.x, 0.319999993);
    u_xlat16_4.x = dot(u_xlat16_5.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10.x = u_xlat16_22 * u_xlat16_22;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat16_16 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_22 = u_xlat16_16 * u_xlat16_16;
    u_xlat16_12 = u_xlat16_16 * u_xlat16_16 + 1.5;
    u_xlat16_6 = u_xlat16_12 * u_xlat16_6;
    u_xlat16_12 = u_xlat16_22 * u_xlat16_22 + -1.0;
    u_xlat16_12 = u_xlat16_10.x * u_xlat16_12 + 1.00001001;
    u_xlat16_6 = u_xlat16_12 * u_xlat16_6;
    u_xlat16_6 = u_xlat16_22 / u_xlat16_6;
    u_xlat16_6 = u_xlat16_6 + -9.99999975e-05;
    u_xlat16_10.x = max(u_xlat16_6, 0.0);
    u_xlat16_10.x = min(u_xlat16_10.x, 100.0);
    u_xlat10_6.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat10_1 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat16_16 = u_xlat0.x + u_xlat10_1;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_16 = min(max(u_xlat16_16, 0.0), 1.0);
#else
    u_xlat16_16 = clamp(u_xlat16_16, 0.0, 1.0);
#endif
    u_xlat1.xyz = vec3(u_xlat16_16) * _LightColor.xyz;
    u_xlat16_10.xyz = u_xlat16_10.xxx * u_xlat10_2.xyz + u_xlat10_6.xyz;
    u_xlat16_10.xyz = u_xlat1.xyz * u_xlat16_10.xyz;
    u_xlat16_0.xyz = u_xlat16_4.xxx * u_xlat16_10.xyz;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
    return;
}

#endif
"
}
SubProgram "gles " {
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  mediump float tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_13 = tmpvar_14;
  mediump float shadowAttenuation_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_ShadowMapTexture, tmpvar_8);
  shadowAttenuation_15 = tmpvar_16.x;
  mediump float tmpvar_17;
  tmpvar_17 = clamp ((shadowAttenuation_15 + tmpvar_13), 0.0, 1.0);
  atten_6 = tmpvar_17;
  highp vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.xyz = tmpvar_10;
  highp vec4 tmpvar_19;
  tmpvar_19.zw = vec2(0.0, -8.0);
  tmpvar_19.xy = (unity_WorldToLight * tmpvar_18).xy;
  atten_6 = (atten_6 * texture2D (_LightTexture0, tmpvar_19.xy, -8.0).w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_22;
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_25;
  viewDir_25 = -(tmpvar_24);
  mediump vec2 tmpvar_26;
  tmpvar_26.x = dot ((viewDir_25 - (2.0 * 
    (dot (tmpvar_23, viewDir_25) * tmpvar_23)
  )), lightDir_7);
  tmpvar_26.y = (1.0 - clamp (dot (tmpvar_23, viewDir_25), 0.0, 1.0));
  mediump float specular_27;
  mediump vec2 tmpvar_28;
  tmpvar_28.x = ((tmpvar_26 * tmpvar_26) * (tmpvar_26 * tmpvar_26)).x;
  tmpvar_28.y = (1.0 - gbuffer1_3.w);
  highp float tmpvar_29;
  tmpvar_29 = (texture2D (unity_NHxRoughness, tmpvar_28).w * 16.0);
  specular_27 = tmpvar_29;
  mediump vec4 tmpvar_30;
  tmpvar_30.w = 1.0;
  tmpvar_30.xyz = ((gbuffer0_4.xyz + (specular_27 * gbuffer1_3.xyz)) * (tmpvar_5 * clamp (
    dot (tmpvar_23, lightDir_7)
  , 0.0, 1.0)));
  mediump vec4 tmpvar_31;
  tmpvar_31 = exp2(-(tmpvar_30));
  tmpvar_1 = tmpvar_31;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 " {
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform highp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform highp sampler2D unity_NHxRoughness;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
mediump vec4 u_xlat16_0;
lowp vec4 u_xlat10_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
lowp vec3 u_xlat10_3;
mediump vec3 u_xlat16_4;
mediump vec3 u_xlat16_5;
lowp float u_xlat10_6;
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
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat10_6 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat16_4.x = u_xlat0.x + u_xlat10_6;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat0.xy = u_xlat2.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat2.xx + u_xlat0.xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat2.ww + u_xlat0.xy;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat0.xy = u_xlat0.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.x = u_xlat0.x * u_xlat16_4.x;
    u_xlat0.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat10_3.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_4.xyz = u_xlat10_3.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat16_22 = dot(u_xlat16_4.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_22 = min(max(u_xlat16_22, 0.0), 1.0);
#else
    u_xlat16_22 = clamp(u_xlat16_22, 0.0, 1.0);
#endif
    u_xlat16_5.xyz = u_xlat0.xyz * vec3(u_xlat16_22);
    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat0.xyz = u_xlat0.xxx * u_xlat2.xyz;
    u_xlat16_22 = dot((-u_xlat0.xyz), u_xlat16_4.xyz);
    u_xlat16_22 = u_xlat16_22 + u_xlat16_22;
    u_xlat16_4.xyz = u_xlat16_4.xyz * (-vec3(u_xlat16_22)) + (-u_xlat0.xyz);
    u_xlat16_4.x = dot(u_xlat16_4.xyz, (-_LightDir.xyz));
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_4.x;
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_4.x;
    u_xlat10_0 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_4.y = (-u_xlat10_0.w) + 1.0;
    u_xlat18 = texture(unity_NHxRoughness, u_xlat16_4.xy).w;
    u_xlat18 = u_xlat18 * 16.0;
    u_xlat16_4.xyz = vec3(u_xlat18) * u_xlat10_0.xyz + u_xlat10_1.xyz;
    u_xlat16_0.xyz = u_xlat16_5.xyz * u_xlat16_4.xyz;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
    return;
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  mediump float tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_13 = tmpvar_14;
  mediump float shadowAttenuation_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_ShadowMapTexture, tmpvar_8);
  shadowAttenuation_15 = tmpvar_16.x;
  mediump float tmpvar_17;
  tmpvar_17 = clamp ((shadowAttenuation_15 + tmpvar_13), 0.0, 1.0);
  atten_6 = tmpvar_17;
  highp vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.xyz = tmpvar_10;
  highp vec4 tmpvar_19;
  tmpvar_19.zw = vec2(0.0, -8.0);
  tmpvar_19.xy = (unity_WorldToLight * tmpvar_18).xy;
  atten_6 = (atten_6 * texture2D (_LightTexture0, tmpvar_19.xy, -8.0).w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_22;
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_25;
  viewDir_25 = -(tmpvar_24);
  mediump float specularTerm_26;
  mediump vec3 tmpvar_27;
  mediump vec3 inVec_28;
  inVec_28 = (lightDir_7 + viewDir_25);
  tmpvar_27 = (inVec_28 * inversesqrt(max (0.001, 
    dot (inVec_28, inVec_28)
  )));
  mediump float tmpvar_29;
  tmpvar_29 = clamp (dot (tmpvar_23, tmpvar_27), 0.0, 1.0);
  mediump float tmpvar_30;
  tmpvar_30 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_31;
  tmpvar_31 = (tmpvar_30 * tmpvar_30);
  specularTerm_26 = ((tmpvar_31 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_27), 0.0, 1.0)) * (1.5 + tmpvar_31))
   * 
    (((tmpvar_29 * tmpvar_29) * ((tmpvar_31 * tmpvar_31) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_32;
  tmpvar_32 = clamp (specularTerm_26, 0.0, 100.0);
  specularTerm_26 = tmpvar_32;
  mediump vec4 tmpvar_33;
  tmpvar_33.w = 1.0;
  tmpvar_33.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_32 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_23, lightDir_7), 0.0, 1.0));
  mediump vec4 tmpvar_34;
  tmpvar_34 = exp2(-(tmpvar_33));
  tmpvar_1 = tmpvar_34;
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  mediump float tmpvar_13;
  highp float tmpvar_14;
  tmpvar_14 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_13 = tmpvar_14;
  mediump float shadowAttenuation_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_ShadowMapTexture, tmpvar_8);
  shadowAttenuation_15 = tmpvar_16.x;
  mediump float tmpvar_17;
  tmpvar_17 = clamp ((shadowAttenuation_15 + tmpvar_13), 0.0, 1.0);
  atten_6 = tmpvar_17;
  highp vec4 tmpvar_18;
  tmpvar_18.w = 1.0;
  tmpvar_18.xyz = tmpvar_10;
  highp vec4 tmpvar_19;
  tmpvar_19.zw = vec2(0.0, -8.0);
  tmpvar_19.xy = (unity_WorldToLight * tmpvar_18).xy;
  atten_6 = (atten_6 * texture2D (_LightTexture0, tmpvar_19.xy, -8.0).w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_21;
  lowp vec4 tmpvar_22;
  tmpvar_22 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_22;
  mediump vec3 tmpvar_23;
  tmpvar_23 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_24;
  tmpvar_24 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_25;
  viewDir_25 = -(tmpvar_24);
  mediump float specularTerm_26;
  mediump vec3 tmpvar_27;
  mediump vec3 inVec_28;
  inVec_28 = (lightDir_7 + viewDir_25);
  tmpvar_27 = (inVec_28 * inversesqrt(max (0.001, 
    dot (inVec_28, inVec_28)
  )));
  mediump float tmpvar_29;
  tmpvar_29 = clamp (dot (tmpvar_23, tmpvar_27), 0.0, 1.0);
  mediump float tmpvar_30;
  tmpvar_30 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_31;
  tmpvar_31 = (tmpvar_30 * tmpvar_30);
  specularTerm_26 = ((tmpvar_31 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_27), 0.0, 1.0)) * (1.5 + tmpvar_31))
   * 
    (((tmpvar_29 * tmpvar_29) * ((tmpvar_31 * tmpvar_31) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_32;
  tmpvar_32 = clamp (specularTerm_26, 0.0, 100.0);
  specularTerm_26 = tmpvar_32;
  mediump vec4 tmpvar_33;
  tmpvar_33.w = 1.0;
  tmpvar_33.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_32 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_23, lightDir_7), 0.0, 1.0));
  mediump vec4 tmpvar_34;
  tmpvar_34 = exp2(-(tmpvar_33));
  tmpvar_1 = tmpvar_34;
  gl_FragData[0] = tmpvar_1;
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform highp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
mediump vec4 u_xlat16_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump vec3 u_xlat16_5;
lowp float u_xlat10_6;
mediump vec3 u_xlat16_10;
mediump float u_xlat16_16;
float u_xlat18;
mediump float u_xlat16_18;
mediump float u_xlat16_19;
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
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat10_6 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat16_4.x = u_xlat0.x + u_xlat10_6;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat0.xy = u_xlat2.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat2.xx + u_xlat0.xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat2.ww + u_xlat0.xy;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat0.xy = u_xlat0.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.x = u_xlat0.x * u_xlat16_4.x;
    u_xlat0.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat18 = inversesqrt(u_xlat18);
    u_xlat16_4.xyz = (-u_xlat2.xyz) * vec3(u_xlat18) + (-_LightDir.xyz);
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_18 = max(u_xlat16_22, 0.00100000005);
    u_xlat16_22 = inversesqrt(u_xlat16_18);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_5.xyz = vec3(u_xlat16_22) * u_xlat16_5.xyz;
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_22 = min(max(u_xlat16_22, 0.0), 1.0);
#else
    u_xlat16_22 = clamp(u_xlat16_22, 0.0, 1.0);
#endif
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_18 = max(u_xlat16_4.x, 0.319999993);
    u_xlat16_4.x = dot(u_xlat16_5.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10.x = u_xlat16_22 * u_xlat16_22;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_16 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_22 = u_xlat16_16 * u_xlat16_16;
    u_xlat16_19 = u_xlat16_16 * u_xlat16_16 + 1.5;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_19;
    u_xlat16_19 = u_xlat16_22 * u_xlat16_22 + -1.0;
    u_xlat16_19 = u_xlat16_10.x * u_xlat16_19 + 1.00001001;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_19;
    u_xlat16_18 = u_xlat16_22 / u_xlat16_18;
    u_xlat16_18 = u_xlat16_18 + -9.99999975e-05;
    u_xlat16_10.x = max(u_xlat16_18, 0.0);
    u_xlat16_10.x = min(u_xlat16_10.x, 100.0);
    u_xlat16_10.xyz = u_xlat16_10.xxx * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat16_10.xyz = u_xlat0.xyz * u_xlat16_10.xyz;
    u_xlat16_0.xyz = u_xlat16_4.xxx * u_xlat16_10.xyz;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform highp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
mediump vec4 u_xlat16_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump vec3 u_xlat16_5;
lowp float u_xlat10_6;
mediump vec3 u_xlat16_10;
mediump float u_xlat16_16;
float u_xlat18;
mediump float u_xlat16_18;
mediump float u_xlat16_19;
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
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat10_6 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat16_4.x = u_xlat0.x + u_xlat10_6;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat0.xy = u_xlat2.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat2.xx + u_xlat0.xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat2.ww + u_xlat0.xy;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat0.xy = u_xlat0.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.x = u_xlat0.x * u_xlat16_4.x;
    u_xlat0.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat18 = inversesqrt(u_xlat18);
    u_xlat16_4.xyz = (-u_xlat2.xyz) * vec3(u_xlat18) + (-_LightDir.xyz);
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_18 = max(u_xlat16_22, 0.00100000005);
    u_xlat16_22 = inversesqrt(u_xlat16_18);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_5.xyz = vec3(u_xlat16_22) * u_xlat16_5.xyz;
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_22 = min(max(u_xlat16_22, 0.0), 1.0);
#else
    u_xlat16_22 = clamp(u_xlat16_22, 0.0, 1.0);
#endif
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_18 = max(u_xlat16_4.x, 0.319999993);
    u_xlat16_4.x = dot(u_xlat16_5.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10.x = u_xlat16_22 * u_xlat16_22;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_16 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_22 = u_xlat16_16 * u_xlat16_16;
    u_xlat16_19 = u_xlat16_16 * u_xlat16_16 + 1.5;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_19;
    u_xlat16_19 = u_xlat16_22 * u_xlat16_22 + -1.0;
    u_xlat16_19 = u_xlat16_10.x * u_xlat16_19 + 1.00001001;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_19;
    u_xlat16_18 = u_xlat16_22 / u_xlat16_18;
    u_xlat16_18 = u_xlat16_18 + -9.99999975e-05;
    u_xlat16_10.x = max(u_xlat16_18, 0.0);
    u_xlat16_10.x = min(u_xlat16_10.x, 100.0);
    u_xlat16_10.xyz = u_xlat16_10.xxx * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat16_10.xyz = u_xlat0.xyz * u_xlat16_10.xyz;
    u_xlat16_0.xyz = u_xlat16_4.xxx * u_xlat16_10.xyz;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
    return;
}

#endif
"
}
SubProgram "gles " {
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
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  highp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w)));
  atten_6 = tmpvar_14.w;
  mediump float tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_15 = tmpvar_16;
  mediump float shadowVal_17;
  highp float mydist_18;
  mydist_18 = ((sqrt(
    dot (tmpvar_12, tmpvar_12)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_19;
  tmpvar_19 = textureCube (_ShadowMapTexture, tmpvar_12);
  highp vec4 vals_20;
  vals_20 = tmpvar_19;
  highp float tmpvar_21;
  tmpvar_21 = dot (vals_20, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVal_17 = tmpvar_21;
  mediump float tmpvar_22;
  if ((shadowVal_17 < mydist_18)) {
    tmpvar_22 = _LightShadowData.x;
  } else {
    tmpvar_22 = 1.0;
  };
  mediump float tmpvar_23;
  tmpvar_23 = clamp ((tmpvar_22 + tmpvar_15), 0.0, 1.0);
  atten_6 = (tmpvar_14.w * tmpvar_23);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_24;
  tmpvar_24 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_26;
  mediump vec3 tmpvar_27;
  tmpvar_27 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_28;
  tmpvar_28 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_29;
  viewDir_29 = -(tmpvar_28);
  mediump vec2 tmpvar_30;
  tmpvar_30.x = dot ((viewDir_29 - (2.0 * 
    (dot (tmpvar_27, viewDir_29) * tmpvar_27)
  )), lightDir_7);
  tmpvar_30.y = (1.0 - clamp (dot (tmpvar_27, viewDir_29), 0.0, 1.0));
  mediump float specular_31;
  mediump vec2 tmpvar_32;
  tmpvar_32.x = ((tmpvar_30 * tmpvar_30) * (tmpvar_30 * tmpvar_30)).x;
  tmpvar_32.y = (1.0 - gbuffer1_3.w);
  highp float tmpvar_33;
  tmpvar_33 = (texture2D (unity_NHxRoughness, tmpvar_32).w * 16.0);
  specular_31 = tmpvar_33;
  mediump vec4 tmpvar_34;
  tmpvar_34.w = 1.0;
  tmpvar_34.xyz = ((gbuffer0_4.xyz + (specular_31 * gbuffer1_3.xyz)) * (tmpvar_5 * clamp (
    dot (tmpvar_27, lightDir_7)
  , 0.0, 1.0)));
  mediump vec4 tmpvar_35;
  tmpvar_35 = exp2(-(tmpvar_34));
  tmpvar_1 = tmpvar_35;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 " {
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform highp sampler2D unity_NHxRoughness;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
mediump vec4 u_xlat16_0;
lowp vec4 u_xlat10_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
lowp vec4 u_xlat10_3;
mediump vec3 u_xlat16_4;
lowp vec3 u_xlat10_5;
mediump vec3 u_xlat16_6;
vec3 u_xlat7;
float u_xlat15;
bool u_xlatb15;
float u_xlat21;
float u_xlat22;
float u_xlat23;
mediump float u_xlat16_25;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat21 = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat21 = float(1.0) / u_xlat21;
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat21 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat7.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat10_3 = texture(_ShadowMapTexture, u_xlat7.xyz);
    u_xlat15 = dot(u_xlat10_3, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat22 = dot(u_xlat7.xyz, u_xlat7.xyz);
    u_xlat23 = sqrt(u_xlat22);
    u_xlat23 = u_xlat23 * _LightPositionRange.w;
    u_xlat23 = u_xlat23 * _LightProjectionParams.w;
#ifdef UNITY_ADRENO_ES3
    u_xlatb15 = !!(u_xlat15<u_xlat23);
#else
    u_xlatb15 = u_xlat15<u_xlat23;
#endif
    u_xlat16_4.x = (u_xlatb15) ? _LightShadowData.x : 1.0;
    u_xlat16_4.x = u_xlat0.x + u_xlat16_4.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat22 * _LightPos.w;
    u_xlat15 = inversesqrt(u_xlat22);
    u_xlat7.xyz = u_xlat7.xyz * vec3(u_xlat15);
    u_xlat0.x = texture(_LightTextureB0, u_xlat0.xx).w;
    u_xlat0.x = u_xlat16_4.x * u_xlat0.x;
    u_xlat3.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat10_5.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_4.xyz = u_xlat10_5.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_25 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_25 = inversesqrt(u_xlat16_25);
    u_xlat16_4.xyz = vec3(u_xlat16_25) * u_xlat16_4.xyz;
    u_xlat16_25 = dot(u_xlat16_4.xyz, (-u_xlat7.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_25 = min(max(u_xlat16_25, 0.0), 1.0);
#else
    u_xlat16_25 = clamp(u_xlat16_25, 0.0, 1.0);
#endif
    u_xlat16_6.xyz = u_xlat3.xyz * vec3(u_xlat16_25);
    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat2.xyz = u_xlat0.xxx * u_xlat2.xyz;
    u_xlat16_25 = dot((-u_xlat2.xyz), u_xlat16_4.xyz);
    u_xlat16_25 = u_xlat16_25 + u_xlat16_25;
    u_xlat16_4.xyz = u_xlat16_4.xyz * (-vec3(u_xlat16_25)) + (-u_xlat2.xyz);
    u_xlat16_4.x = dot(u_xlat16_4.xyz, (-u_xlat7.xyz));
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_4.x;
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_4.x;
    u_xlat10_0 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_4.y = (-u_xlat10_0.w) + 1.0;
    u_xlat21 = texture(unity_NHxRoughness, u_xlat16_4.xy).w;
    u_xlat21 = u_xlat21 * 16.0;
    u_xlat16_4.xyz = vec3(u_xlat21) * u_xlat10_0.xyz + u_xlat10_1.xyz;
    u_xlat16_0.xyz = u_xlat16_6.xyz * u_xlat16_4.xyz;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
    return;
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
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  highp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w)));
  atten_6 = tmpvar_14.w;
  mediump float tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_15 = tmpvar_16;
  mediump float shadowVal_17;
  highp float mydist_18;
  mydist_18 = ((sqrt(
    dot (tmpvar_12, tmpvar_12)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_19;
  tmpvar_19 = textureCube (_ShadowMapTexture, tmpvar_12);
  highp vec4 vals_20;
  vals_20 = tmpvar_19;
  highp float tmpvar_21;
  tmpvar_21 = dot (vals_20, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVal_17 = tmpvar_21;
  mediump float tmpvar_22;
  if ((shadowVal_17 < mydist_18)) {
    tmpvar_22 = _LightShadowData.x;
  } else {
    tmpvar_22 = 1.0;
  };
  mediump float tmpvar_23;
  tmpvar_23 = clamp ((tmpvar_22 + tmpvar_15), 0.0, 1.0);
  atten_6 = (tmpvar_14.w * tmpvar_23);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_24;
  tmpvar_24 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_26;
  mediump vec3 tmpvar_27;
  tmpvar_27 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_28;
  tmpvar_28 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_29;
  viewDir_29 = -(tmpvar_28);
  mediump float specularTerm_30;
  mediump vec3 tmpvar_31;
  mediump vec3 inVec_32;
  inVec_32 = (lightDir_7 + viewDir_29);
  tmpvar_31 = (inVec_32 * inversesqrt(max (0.001, 
    dot (inVec_32, inVec_32)
  )));
  mediump float tmpvar_33;
  tmpvar_33 = clamp (dot (tmpvar_27, tmpvar_31), 0.0, 1.0);
  mediump float tmpvar_34;
  tmpvar_34 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_35;
  tmpvar_35 = (tmpvar_34 * tmpvar_34);
  specularTerm_30 = ((tmpvar_35 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_31), 0.0, 1.0)) * (1.5 + tmpvar_35))
   * 
    (((tmpvar_33 * tmpvar_33) * ((tmpvar_35 * tmpvar_35) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_36;
  tmpvar_36 = clamp (specularTerm_30, 0.0, 100.0);
  specularTerm_30 = tmpvar_36;
  mediump vec4 tmpvar_37;
  tmpvar_37.w = 1.0;
  tmpvar_37.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_36 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_27, lightDir_7), 0.0, 1.0));
  mediump vec4 tmpvar_38;
  tmpvar_38 = exp2(-(tmpvar_37));
  tmpvar_1 = tmpvar_38;
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
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  highp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w)));
  atten_6 = tmpvar_14.w;
  mediump float tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_15 = tmpvar_16;
  mediump float shadowVal_17;
  highp float mydist_18;
  mydist_18 = ((sqrt(
    dot (tmpvar_12, tmpvar_12)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_19;
  tmpvar_19 = textureCube (_ShadowMapTexture, tmpvar_12);
  highp vec4 vals_20;
  vals_20 = tmpvar_19;
  highp float tmpvar_21;
  tmpvar_21 = dot (vals_20, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVal_17 = tmpvar_21;
  mediump float tmpvar_22;
  if ((shadowVal_17 < mydist_18)) {
    tmpvar_22 = _LightShadowData.x;
  } else {
    tmpvar_22 = 1.0;
  };
  mediump float tmpvar_23;
  tmpvar_23 = clamp ((tmpvar_22 + tmpvar_15), 0.0, 1.0);
  atten_6 = (tmpvar_14.w * tmpvar_23);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_24;
  tmpvar_24 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_26;
  mediump vec3 tmpvar_27;
  tmpvar_27 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_28;
  tmpvar_28 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_29;
  viewDir_29 = -(tmpvar_28);
  mediump float specularTerm_30;
  mediump vec3 tmpvar_31;
  mediump vec3 inVec_32;
  inVec_32 = (lightDir_7 + viewDir_29);
  tmpvar_31 = (inVec_32 * inversesqrt(max (0.001, 
    dot (inVec_32, inVec_32)
  )));
  mediump float tmpvar_33;
  tmpvar_33 = clamp (dot (tmpvar_27, tmpvar_31), 0.0, 1.0);
  mediump float tmpvar_34;
  tmpvar_34 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_35;
  tmpvar_35 = (tmpvar_34 * tmpvar_34);
  specularTerm_30 = ((tmpvar_35 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_31), 0.0, 1.0)) * (1.5 + tmpvar_35))
   * 
    (((tmpvar_33 * tmpvar_33) * ((tmpvar_35 * tmpvar_35) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_36;
  tmpvar_36 = clamp (specularTerm_30, 0.0, 100.0);
  specularTerm_30 = tmpvar_36;
  mediump vec4 tmpvar_37;
  tmpvar_37.w = 1.0;
  tmpvar_37.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_36 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_27, lightDir_7), 0.0, 1.0));
  mediump vec4 tmpvar_38;
  tmpvar_38 = exp2(-(tmpvar_37));
  tmpvar_1 = tmpvar_38;
  gl_FragData[0] = tmpvar_1;
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
mediump vec4 u_xlat16_0;
bool u_xlatb0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
lowp vec3 u_xlat10_3;
vec3 u_xlat4;
lowp vec4 u_xlat10_4;
mediump vec4 u_xlat16_5;
mediump vec3 u_xlat16_6;
float u_xlat7;
mediump float u_xlat16_12;
float u_xlat14;
mediump float u_xlat16_19;
float u_xlat21;
mediump float u_xlat16_22;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat21 = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat21 = float(1.0) / u_xlat21;
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat4.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7 = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat7 = sqrt(u_xlat7);
    u_xlat7 = (-u_xlat0.z) * u_xlat21 + u_xlat7;
    u_xlat7 = unity_ShadowFadeCenterAndType.w * u_xlat7 + u_xlat2.z;
    u_xlat7 = u_xlat7 * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat7 = min(max(u_xlat7, 0.0), 1.0);
#else
    u_xlat7 = clamp(u_xlat7, 0.0, 1.0);
#endif
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat21 = inversesqrt(u_xlat14);
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat4.xyz;
    u_xlat10_4 = texture(_ShadowMapTexture, u_xlat4.xyz);
    u_xlat21 = dot(u_xlat10_4, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat16_5.xyz = (-u_xlat3.xyz) * u_xlat0.xxx + (-u_xlat2.xyz);
    u_xlat16_26 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_0.x = max(u_xlat16_26, 0.00100000005);
    u_xlat16_26 = inversesqrt(u_xlat16_0.x);
    u_xlat16_5.xyz = vec3(u_xlat16_26) * u_xlat16_5.xyz;
    u_xlat10_3.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_3.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_26 = inversesqrt(u_xlat16_26);
    u_xlat16_6.xyz = vec3(u_xlat16_26) * u_xlat16_6.xyz;
    u_xlat16_26 = dot(u_xlat16_6.xyz, u_xlat16_5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_26 = min(max(u_xlat16_26, 0.0), 1.0);
#else
    u_xlat16_26 = clamp(u_xlat16_26, 0.0, 1.0);
#endif
    u_xlat16_5.x = dot((-u_xlat2.xyz), u_xlat16_5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat16_12 = dot(u_xlat16_6.xyz, (-u_xlat2.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_12 = min(max(u_xlat16_12, 0.0), 1.0);
#else
    u_xlat16_12 = clamp(u_xlat16_12, 0.0, 1.0);
#endif
    u_xlat16_0.x = max(u_xlat16_5.x, 0.319999993);
    u_xlat16_5.x = u_xlat16_26 * u_xlat16_26;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_19 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_26 = u_xlat16_19 * u_xlat16_19;
    u_xlat16_22 = u_xlat16_19 * u_xlat16_19 + 1.5;
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_22;
    u_xlat16_22 = u_xlat16_26 * u_xlat16_26 + -1.0;
    u_xlat16_22 = u_xlat16_5.x * u_xlat16_22 + 1.00001001;
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_22;
    u_xlat16_0.x = u_xlat16_26 / u_xlat16_0.x;
    u_xlat16_0.x = u_xlat16_0.x + -9.99999975e-05;
    u_xlat16_5.x = max(u_xlat16_0.x, 0.0);
    u_xlat16_5.x = min(u_xlat16_5.x, 100.0);
    u_xlat16_5.xzw = u_xlat16_5.xxx * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat0.x = sqrt(u_xlat14);
    u_xlat14 = u_xlat14 * _LightPos.w;
    u_xlat14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat0.x = u_xlat0.x * _LightPositionRange.w;
    u_xlat0.x = u_xlat0.x * _LightProjectionParams.w;
#ifdef UNITY_ADRENO_ES3
    u_xlatb0 = !!(u_xlat21<u_xlat0.x);
#else
    u_xlatb0 = u_xlat21<u_xlat0.x;
#endif
    u_xlat16_6.x = (u_xlatb0) ? _LightShadowData.x : 1.0;
    u_xlat16_6.x = u_xlat7 + u_xlat16_6.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_6.x = min(max(u_xlat16_6.x, 0.0), 1.0);
#else
    u_xlat16_6.x = clamp(u_xlat16_6.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat14 * u_xlat16_6.x;
    u_xlat0.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat16_5.xzw = u_xlat0.xyz * u_xlat16_5.xzw;
    u_xlat16_0.xyz = vec3(u_xlat16_12) * u_xlat16_5.xzw;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
mediump vec4 u_xlat16_0;
bool u_xlatb0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
lowp vec3 u_xlat10_3;
vec3 u_xlat4;
lowp vec4 u_xlat10_4;
mediump vec4 u_xlat16_5;
mediump vec3 u_xlat16_6;
float u_xlat7;
mediump float u_xlat16_12;
float u_xlat14;
mediump float u_xlat16_19;
float u_xlat21;
mediump float u_xlat16_22;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat21 = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat21 = float(1.0) / u_xlat21;
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat4.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7 = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat7 = sqrt(u_xlat7);
    u_xlat7 = (-u_xlat0.z) * u_xlat21 + u_xlat7;
    u_xlat7 = unity_ShadowFadeCenterAndType.w * u_xlat7 + u_xlat2.z;
    u_xlat7 = u_xlat7 * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat7 = min(max(u_xlat7, 0.0), 1.0);
#else
    u_xlat7 = clamp(u_xlat7, 0.0, 1.0);
#endif
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat21 = inversesqrt(u_xlat14);
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat4.xyz;
    u_xlat10_4 = texture(_ShadowMapTexture, u_xlat4.xyz);
    u_xlat21 = dot(u_xlat10_4, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat16_5.xyz = (-u_xlat3.xyz) * u_xlat0.xxx + (-u_xlat2.xyz);
    u_xlat16_26 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_0.x = max(u_xlat16_26, 0.00100000005);
    u_xlat16_26 = inversesqrt(u_xlat16_0.x);
    u_xlat16_5.xyz = vec3(u_xlat16_26) * u_xlat16_5.xyz;
    u_xlat10_3.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_3.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_26 = inversesqrt(u_xlat16_26);
    u_xlat16_6.xyz = vec3(u_xlat16_26) * u_xlat16_6.xyz;
    u_xlat16_26 = dot(u_xlat16_6.xyz, u_xlat16_5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_26 = min(max(u_xlat16_26, 0.0), 1.0);
#else
    u_xlat16_26 = clamp(u_xlat16_26, 0.0, 1.0);
#endif
    u_xlat16_5.x = dot((-u_xlat2.xyz), u_xlat16_5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat16_12 = dot(u_xlat16_6.xyz, (-u_xlat2.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_12 = min(max(u_xlat16_12, 0.0), 1.0);
#else
    u_xlat16_12 = clamp(u_xlat16_12, 0.0, 1.0);
#endif
    u_xlat16_0.x = max(u_xlat16_5.x, 0.319999993);
    u_xlat16_5.x = u_xlat16_26 * u_xlat16_26;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_19 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_26 = u_xlat16_19 * u_xlat16_19;
    u_xlat16_22 = u_xlat16_19 * u_xlat16_19 + 1.5;
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_22;
    u_xlat16_22 = u_xlat16_26 * u_xlat16_26 + -1.0;
    u_xlat16_22 = u_xlat16_5.x * u_xlat16_22 + 1.00001001;
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_22;
    u_xlat16_0.x = u_xlat16_26 / u_xlat16_0.x;
    u_xlat16_0.x = u_xlat16_0.x + -9.99999975e-05;
    u_xlat16_5.x = max(u_xlat16_0.x, 0.0);
    u_xlat16_5.x = min(u_xlat16_5.x, 100.0);
    u_xlat16_5.xzw = u_xlat16_5.xxx * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat0.x = sqrt(u_xlat14);
    u_xlat14 = u_xlat14 * _LightPos.w;
    u_xlat14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat0.x = u_xlat0.x * _LightPositionRange.w;
    u_xlat0.x = u_xlat0.x * _LightProjectionParams.w;
#ifdef UNITY_ADRENO_ES3
    u_xlatb0 = !!(u_xlat21<u_xlat0.x);
#else
    u_xlatb0 = u_xlat21<u_xlat0.x;
#endif
    u_xlat16_6.x = (u_xlatb0) ? _LightShadowData.x : 1.0;
    u_xlat16_6.x = u_xlat7 + u_xlat16_6.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_6.x = min(max(u_xlat16_6.x, 0.0), 1.0);
#else
    u_xlat16_6.x = clamp(u_xlat16_6.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat14 * u_xlat16_6.x;
    u_xlat0.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat16_5.xzw = u_xlat0.xyz * u_xlat16_5.xzw;
    u_xlat16_0.xyz = vec3(u_xlat16_12) * u_xlat16_5.xzw;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
    return;
}

#endif
"
}
SubProgram "gles " {
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
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  highp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w)));
  atten_6 = tmpvar_14.w;
  mediump float tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_15 = tmpvar_16;
  highp vec4 shadowVals_17;
  highp float mydist_18;
  mydist_18 = ((sqrt(
    dot (tmpvar_12, tmpvar_12)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_19;
  tmpvar_19.w = 0.0;
  tmpvar_19.xyz = (tmpvar_12 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_19.xyz, 0.0);
  tmpvar_20 = tmpvar_21;
  shadowVals_17.x = dot (tmpvar_20, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_22;
  tmpvar_22.w = 0.0;
  tmpvar_22.xyz = (tmpvar_12 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_22.xyz, 0.0);
  tmpvar_23 = tmpvar_24;
  shadowVals_17.y = dot (tmpvar_23, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_25;
  tmpvar_25.w = 0.0;
  tmpvar_25.xyz = (tmpvar_12 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_25.xyz, 0.0);
  tmpvar_26 = tmpvar_27;
  shadowVals_17.z = dot (tmpvar_26, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_28;
  tmpvar_28.w = 0.0;
  tmpvar_28.xyz = (tmpvar_12 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_28.xyz, 0.0);
  tmpvar_29 = tmpvar_30;
  shadowVals_17.w = dot (tmpvar_29, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_31;
  tmpvar_31 = lessThan (shadowVals_17, vec4(mydist_18));
  mediump vec4 tmpvar_32;
  tmpvar_32 = _LightShadowData.xxxx;
  mediump float tmpvar_33;
  if (tmpvar_31.x) {
    tmpvar_33 = tmpvar_32.x;
  } else {
    tmpvar_33 = 1.0;
  };
  mediump float tmpvar_34;
  if (tmpvar_31.y) {
    tmpvar_34 = tmpvar_32.y;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_31.z) {
    tmpvar_35 = tmpvar_32.z;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump float tmpvar_36;
  if (tmpvar_31.w) {
    tmpvar_36 = tmpvar_32.w;
  } else {
    tmpvar_36 = 1.0;
  };
  mediump vec4 tmpvar_37;
  tmpvar_37.x = tmpvar_33;
  tmpvar_37.y = tmpvar_34;
  tmpvar_37.z = tmpvar_35;
  tmpvar_37.w = tmpvar_36;
  mediump float tmpvar_38;
  tmpvar_38 = clamp ((dot (tmpvar_37, vec4(0.25, 0.25, 0.25, 0.25)) + tmpvar_15), 0.0, 1.0);
  atten_6 = (tmpvar_14.w * tmpvar_38);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_39;
  tmpvar_39 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_39;
  lowp vec4 tmpvar_40;
  tmpvar_40 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_40;
  lowp vec4 tmpvar_41;
  tmpvar_41 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_41;
  mediump vec3 tmpvar_42;
  tmpvar_42 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_43;
  tmpvar_43 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_44;
  viewDir_44 = -(tmpvar_43);
  mediump vec2 tmpvar_45;
  tmpvar_45.x = dot ((viewDir_44 - (2.0 * 
    (dot (tmpvar_42, viewDir_44) * tmpvar_42)
  )), lightDir_7);
  tmpvar_45.y = (1.0 - clamp (dot (tmpvar_42, viewDir_44), 0.0, 1.0));
  mediump float specular_46;
  mediump vec2 tmpvar_47;
  tmpvar_47.x = ((tmpvar_45 * tmpvar_45) * (tmpvar_45 * tmpvar_45)).x;
  tmpvar_47.y = (1.0 - gbuffer1_3.w);
  highp float tmpvar_48;
  tmpvar_48 = (texture2D (unity_NHxRoughness, tmpvar_47).w * 16.0);
  specular_46 = tmpvar_48;
  mediump vec4 tmpvar_49;
  tmpvar_49.w = 1.0;
  tmpvar_49.xyz = ((gbuffer0_4.xyz + (specular_46 * gbuffer1_3.xyz)) * (tmpvar_5 * clamp (
    dot (tmpvar_42, lightDir_7)
  , 0.0, 1.0)));
  mediump vec4 tmpvar_50;
  tmpvar_50 = exp2(-(tmpvar_49));
  tmpvar_1 = tmpvar_50;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 " {
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform highp sampler2D unity_NHxRoughness;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
mediump vec4 u_xlat16_0;
lowp vec4 u_xlat10_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
vec4 u_xlat3;
lowp vec4 u_xlat10_3;
bvec4 u_xlatb3;
vec3 u_xlat4;
lowp vec4 u_xlat10_4;
mediump vec3 u_xlat16_5;
mediump vec3 u_xlat16_6;
vec3 u_xlat7;
float u_xlat15;
float u_xlat21;
float u_xlat22;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat21 = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat21 = float(1.0) / u_xlat21;
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat21 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat7.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat3.xyz = u_xlat7.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
    u_xlat10_3 = textureLod(_ShadowMapTexture, u_xlat3.xyz, 0.0);
    u_xlat3.x = dot(u_xlat10_3, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat4.xyz = u_xlat7.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
    u_xlat10_4 = textureLod(_ShadowMapTexture, u_xlat4.xyz, 0.0);
    u_xlat3.y = dot(u_xlat10_4, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat4.xyz = u_xlat7.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
    u_xlat10_4 = textureLod(_ShadowMapTexture, u_xlat4.xyz, 0.0);
    u_xlat3.z = dot(u_xlat10_4, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat4.xyz = u_xlat7.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
    u_xlat10_4 = textureLod(_ShadowMapTexture, u_xlat4.xyz, 0.0);
    u_xlat3.w = dot(u_xlat10_4, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat15 = dot(u_xlat7.xyz, u_xlat7.xyz);
    u_xlat22 = sqrt(u_xlat15);
    u_xlat22 = u_xlat22 * _LightPositionRange.w;
    u_xlat22 = u_xlat22 * _LightProjectionParams.w;
    u_xlatb3 = lessThan(u_xlat3, vec4(u_xlat22));
    u_xlat3.x = (u_xlatb3.x) ? _LightShadowData.x : float(1.0);
    u_xlat3.y = (u_xlatb3.y) ? _LightShadowData.x : float(1.0);
    u_xlat3.z = (u_xlatb3.z) ? _LightShadowData.x : float(1.0);
    u_xlat3.w = (u_xlatb3.w) ? _LightShadowData.x : float(1.0);
    u_xlat16_5.x = dot(u_xlat3, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat16_5.x = u_xlat0.x + u_xlat16_5.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat15 * _LightPos.w;
    u_xlat15 = inversesqrt(u_xlat15);
    u_xlat7.xyz = u_xlat7.xyz * vec3(u_xlat15);
    u_xlat0.x = texture(_LightTextureB0, u_xlat0.xx).w;
    u_xlat0.x = u_xlat16_5.x * u_xlat0.x;
    u_xlat3.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat10_4.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_4.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_26 = inversesqrt(u_xlat16_26);
    u_xlat16_5.xyz = vec3(u_xlat16_26) * u_xlat16_5.xyz;
    u_xlat16_26 = dot(u_xlat16_5.xyz, (-u_xlat7.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_26 = min(max(u_xlat16_26, 0.0), 1.0);
#else
    u_xlat16_26 = clamp(u_xlat16_26, 0.0, 1.0);
#endif
    u_xlat16_6.xyz = u_xlat3.xyz * vec3(u_xlat16_26);
    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat2.xyz = u_xlat0.xxx * u_xlat2.xyz;
    u_xlat16_26 = dot((-u_xlat2.xyz), u_xlat16_5.xyz);
    u_xlat16_26 = u_xlat16_26 + u_xlat16_26;
    u_xlat16_5.xyz = u_xlat16_5.xyz * (-vec3(u_xlat16_26)) + (-u_xlat2.xyz);
    u_xlat16_5.x = dot(u_xlat16_5.xyz, (-u_xlat7.xyz));
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_5.x;
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_5.x;
    u_xlat10_0 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_5.y = (-u_xlat10_0.w) + 1.0;
    u_xlat21 = texture(unity_NHxRoughness, u_xlat16_5.xy).w;
    u_xlat21 = u_xlat21 * 16.0;
    u_xlat16_5.xyz = vec3(u_xlat21) * u_xlat10_0.xyz + u_xlat10_1.xyz;
    u_xlat16_0.xyz = u_xlat16_6.xyz * u_xlat16_5.xyz;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
    return;
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
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  highp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w)));
  atten_6 = tmpvar_14.w;
  mediump float tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_15 = tmpvar_16;
  highp vec4 shadowVals_17;
  highp float mydist_18;
  mydist_18 = ((sqrt(
    dot (tmpvar_12, tmpvar_12)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_19;
  tmpvar_19.w = 0.0;
  tmpvar_19.xyz = (tmpvar_12 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_19.xyz, 0.0);
  tmpvar_20 = tmpvar_21;
  shadowVals_17.x = dot (tmpvar_20, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_22;
  tmpvar_22.w = 0.0;
  tmpvar_22.xyz = (tmpvar_12 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_22.xyz, 0.0);
  tmpvar_23 = tmpvar_24;
  shadowVals_17.y = dot (tmpvar_23, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_25;
  tmpvar_25.w = 0.0;
  tmpvar_25.xyz = (tmpvar_12 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_25.xyz, 0.0);
  tmpvar_26 = tmpvar_27;
  shadowVals_17.z = dot (tmpvar_26, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_28;
  tmpvar_28.w = 0.0;
  tmpvar_28.xyz = (tmpvar_12 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_28.xyz, 0.0);
  tmpvar_29 = tmpvar_30;
  shadowVals_17.w = dot (tmpvar_29, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_31;
  tmpvar_31 = lessThan (shadowVals_17, vec4(mydist_18));
  mediump vec4 tmpvar_32;
  tmpvar_32 = _LightShadowData.xxxx;
  mediump float tmpvar_33;
  if (tmpvar_31.x) {
    tmpvar_33 = tmpvar_32.x;
  } else {
    tmpvar_33 = 1.0;
  };
  mediump float tmpvar_34;
  if (tmpvar_31.y) {
    tmpvar_34 = tmpvar_32.y;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_31.z) {
    tmpvar_35 = tmpvar_32.z;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump float tmpvar_36;
  if (tmpvar_31.w) {
    tmpvar_36 = tmpvar_32.w;
  } else {
    tmpvar_36 = 1.0;
  };
  mediump vec4 tmpvar_37;
  tmpvar_37.x = tmpvar_33;
  tmpvar_37.y = tmpvar_34;
  tmpvar_37.z = tmpvar_35;
  tmpvar_37.w = tmpvar_36;
  mediump float tmpvar_38;
  tmpvar_38 = clamp ((dot (tmpvar_37, vec4(0.25, 0.25, 0.25, 0.25)) + tmpvar_15), 0.0, 1.0);
  atten_6 = (tmpvar_14.w * tmpvar_38);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_39;
  tmpvar_39 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_39;
  lowp vec4 tmpvar_40;
  tmpvar_40 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_40;
  lowp vec4 tmpvar_41;
  tmpvar_41 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_41;
  mediump vec3 tmpvar_42;
  tmpvar_42 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_43;
  tmpvar_43 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_44;
  viewDir_44 = -(tmpvar_43);
  mediump float specularTerm_45;
  mediump vec3 tmpvar_46;
  mediump vec3 inVec_47;
  inVec_47 = (lightDir_7 + viewDir_44);
  tmpvar_46 = (inVec_47 * inversesqrt(max (0.001, 
    dot (inVec_47, inVec_47)
  )));
  mediump float tmpvar_48;
  tmpvar_48 = clamp (dot (tmpvar_42, tmpvar_46), 0.0, 1.0);
  mediump float tmpvar_49;
  tmpvar_49 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_50;
  tmpvar_50 = (tmpvar_49 * tmpvar_49);
  specularTerm_45 = ((tmpvar_50 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_46), 0.0, 1.0)) * (1.5 + tmpvar_50))
   * 
    (((tmpvar_48 * tmpvar_48) * ((tmpvar_50 * tmpvar_50) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_51;
  tmpvar_51 = clamp (specularTerm_45, 0.0, 100.0);
  specularTerm_45 = tmpvar_51;
  mediump vec4 tmpvar_52;
  tmpvar_52.w = 1.0;
  tmpvar_52.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_51 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_42, lightDir_7), 0.0, 1.0));
  mediump vec4 tmpvar_53;
  tmpvar_53 = exp2(-(tmpvar_52));
  tmpvar_1 = tmpvar_53;
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
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  highp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w)));
  atten_6 = tmpvar_14.w;
  mediump float tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_15 = tmpvar_16;
  highp vec4 shadowVals_17;
  highp float mydist_18;
  mydist_18 = ((sqrt(
    dot (tmpvar_12, tmpvar_12)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_19;
  tmpvar_19.w = 0.0;
  tmpvar_19.xyz = (tmpvar_12 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_19.xyz, 0.0);
  tmpvar_20 = tmpvar_21;
  shadowVals_17.x = dot (tmpvar_20, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_22;
  tmpvar_22.w = 0.0;
  tmpvar_22.xyz = (tmpvar_12 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_22.xyz, 0.0);
  tmpvar_23 = tmpvar_24;
  shadowVals_17.y = dot (tmpvar_23, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_25;
  tmpvar_25.w = 0.0;
  tmpvar_25.xyz = (tmpvar_12 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_25.xyz, 0.0);
  tmpvar_26 = tmpvar_27;
  shadowVals_17.z = dot (tmpvar_26, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_28;
  tmpvar_28.w = 0.0;
  tmpvar_28.xyz = (tmpvar_12 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_28.xyz, 0.0);
  tmpvar_29 = tmpvar_30;
  shadowVals_17.w = dot (tmpvar_29, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_31;
  tmpvar_31 = lessThan (shadowVals_17, vec4(mydist_18));
  mediump vec4 tmpvar_32;
  tmpvar_32 = _LightShadowData.xxxx;
  mediump float tmpvar_33;
  if (tmpvar_31.x) {
    tmpvar_33 = tmpvar_32.x;
  } else {
    tmpvar_33 = 1.0;
  };
  mediump float tmpvar_34;
  if (tmpvar_31.y) {
    tmpvar_34 = tmpvar_32.y;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_31.z) {
    tmpvar_35 = tmpvar_32.z;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump float tmpvar_36;
  if (tmpvar_31.w) {
    tmpvar_36 = tmpvar_32.w;
  } else {
    tmpvar_36 = 1.0;
  };
  mediump vec4 tmpvar_37;
  tmpvar_37.x = tmpvar_33;
  tmpvar_37.y = tmpvar_34;
  tmpvar_37.z = tmpvar_35;
  tmpvar_37.w = tmpvar_36;
  mediump float tmpvar_38;
  tmpvar_38 = clamp ((dot (tmpvar_37, vec4(0.25, 0.25, 0.25, 0.25)) + tmpvar_15), 0.0, 1.0);
  atten_6 = (tmpvar_14.w * tmpvar_38);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_39;
  tmpvar_39 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_39;
  lowp vec4 tmpvar_40;
  tmpvar_40 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_40;
  lowp vec4 tmpvar_41;
  tmpvar_41 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_41;
  mediump vec3 tmpvar_42;
  tmpvar_42 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_43;
  tmpvar_43 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_44;
  viewDir_44 = -(tmpvar_43);
  mediump float specularTerm_45;
  mediump vec3 tmpvar_46;
  mediump vec3 inVec_47;
  inVec_47 = (lightDir_7 + viewDir_44);
  tmpvar_46 = (inVec_47 * inversesqrt(max (0.001, 
    dot (inVec_47, inVec_47)
  )));
  mediump float tmpvar_48;
  tmpvar_48 = clamp (dot (tmpvar_42, tmpvar_46), 0.0, 1.0);
  mediump float tmpvar_49;
  tmpvar_49 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_50;
  tmpvar_50 = (tmpvar_49 * tmpvar_49);
  specularTerm_45 = ((tmpvar_50 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_46), 0.0, 1.0)) * (1.5 + tmpvar_50))
   * 
    (((tmpvar_48 * tmpvar_48) * ((tmpvar_50 * tmpvar_50) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_51;
  tmpvar_51 = clamp (specularTerm_45, 0.0, 100.0);
  specularTerm_45 = tmpvar_51;
  mediump vec4 tmpvar_52;
  tmpvar_52.w = 1.0;
  tmpvar_52.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_51 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_42, lightDir_7), 0.0, 1.0));
  mediump vec4 tmpvar_53;
  tmpvar_53 = exp2(-(tmpvar_52));
  tmpvar_1 = tmpvar_53;
  gl_FragData[0] = tmpvar_1;
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
mediump vec4 u_xlat16_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec4 u_xlat3;
lowp vec4 u_xlat10_3;
bvec4 u_xlatb3;
vec3 u_xlat4;
lowp vec4 u_xlat10_4;
mediump vec4 u_xlat16_5;
mediump vec3 u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_7;
mediump float u_xlat16_12;
float u_xlat15;
mediump float u_xlat16_15;
float u_xlat21;
float u_xlat22;
mediump float u_xlat16_26;
mediump float u_xlat16_27;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat21 = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat21 = float(1.0) / u_xlat21;
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat21 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat7.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat3.xyz = u_xlat7.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
    u_xlat10_3 = textureLod(_ShadowMapTexture, u_xlat3.xyz, 0.0);
    u_xlat3.x = dot(u_xlat10_3, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat4.xyz = u_xlat7.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
    u_xlat10_4 = textureLod(_ShadowMapTexture, u_xlat4.xyz, 0.0);
    u_xlat3.y = dot(u_xlat10_4, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat4.xyz = u_xlat7.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
    u_xlat10_4 = textureLod(_ShadowMapTexture, u_xlat4.xyz, 0.0);
    u_xlat3.z = dot(u_xlat10_4, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat4.xyz = u_xlat7.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
    u_xlat10_4 = textureLod(_ShadowMapTexture, u_xlat4.xyz, 0.0);
    u_xlat3.w = dot(u_xlat10_4, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat15 = dot(u_xlat7.xyz, u_xlat7.xyz);
    u_xlat22 = sqrt(u_xlat15);
    u_xlat22 = u_xlat22 * _LightPositionRange.w;
    u_xlat22 = u_xlat22 * _LightProjectionParams.w;
    u_xlatb3 = lessThan(u_xlat3, vec4(u_xlat22));
    u_xlat3.x = (u_xlatb3.x) ? _LightShadowData.x : float(1.0);
    u_xlat3.y = (u_xlatb3.y) ? _LightShadowData.x : float(1.0);
    u_xlat3.z = (u_xlatb3.z) ? _LightShadowData.x : float(1.0);
    u_xlat3.w = (u_xlatb3.w) ? _LightShadowData.x : float(1.0);
    u_xlat16_5.x = dot(u_xlat3, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat16_5.x = u_xlat0.x + u_xlat16_5.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat15 * _LightPos.w;
    u_xlat15 = inversesqrt(u_xlat15);
    u_xlat7.xyz = u_xlat7.xyz * vec3(u_xlat15);
    u_xlat0.x = texture(_LightTextureB0, u_xlat0.xx).w;
    u_xlat0.x = u_xlat16_5.x * u_xlat0.x;
    u_xlat3.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat16_5.xyz = (-u_xlat2.xyz) * u_xlat0.xxx + (-u_xlat7.xyz);
    u_xlat16_26 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_0.x = max(u_xlat16_26, 0.00100000005);
    u_xlat16_26 = inversesqrt(u_xlat16_0.x);
    u_xlat16_5.xyz = vec3(u_xlat16_26) * u_xlat16_5.xyz;
    u_xlat16_26 = dot((-u_xlat7.xyz), u_xlat16_5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_26 = min(max(u_xlat16_26, 0.0), 1.0);
#else
    u_xlat16_26 = clamp(u_xlat16_26, 0.0, 1.0);
#endif
    u_xlat16_0.x = max(u_xlat16_26, 0.319999993);
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat16_26 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_15 = u_xlat16_26 * u_xlat16_26 + 1.5;
    u_xlat16_26 = u_xlat16_26 * u_xlat16_26;
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_15;
    u_xlat10_4.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_4.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_27 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_27 = inversesqrt(u_xlat16_27);
    u_xlat16_6.xyz = vec3(u_xlat16_27) * u_xlat16_6.xyz;
    u_xlat16_5.x = dot(u_xlat16_6.xyz, u_xlat16_5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat16_12 = dot(u_xlat16_6.xyz, (-u_xlat7.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_12 = min(max(u_xlat16_12, 0.0), 1.0);
#else
    u_xlat16_12 = clamp(u_xlat16_12, 0.0, 1.0);
#endif
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_5.x;
    u_xlat16_7 = u_xlat16_26 * u_xlat16_26 + -1.0;
    u_xlat16_7 = u_xlat16_5.x * u_xlat16_7 + 1.00001001;
    u_xlat16_0.x = u_xlat16_7 * u_xlat16_0.x;
    u_xlat16_0.x = u_xlat16_26 / u_xlat16_0.x;
    u_xlat16_0.x = u_xlat16_0.x + -9.99999975e-05;
    u_xlat16_5.x = max(u_xlat16_0.x, 0.0);
    u_xlat16_5.x = min(u_xlat16_5.x, 100.0);
    u_xlat16_5.xzw = u_xlat16_5.xxx * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat16_5.xzw = u_xlat3.xyz * u_xlat16_5.xzw;
    u_xlat16_0.xyz = vec3(u_xlat16_12) * u_xlat16_5.xzw;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
mediump vec4 u_xlat16_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec4 u_xlat3;
lowp vec4 u_xlat10_3;
bvec4 u_xlatb3;
vec3 u_xlat4;
lowp vec4 u_xlat10_4;
mediump vec4 u_xlat16_5;
mediump vec3 u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_7;
mediump float u_xlat16_12;
float u_xlat15;
mediump float u_xlat16_15;
float u_xlat21;
float u_xlat22;
mediump float u_xlat16_26;
mediump float u_xlat16_27;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat21 = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat21 = float(1.0) / u_xlat21;
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat21 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat7.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat3.xyz = u_xlat7.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
    u_xlat10_3 = textureLod(_ShadowMapTexture, u_xlat3.xyz, 0.0);
    u_xlat3.x = dot(u_xlat10_3, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat4.xyz = u_xlat7.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
    u_xlat10_4 = textureLod(_ShadowMapTexture, u_xlat4.xyz, 0.0);
    u_xlat3.y = dot(u_xlat10_4, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat4.xyz = u_xlat7.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
    u_xlat10_4 = textureLod(_ShadowMapTexture, u_xlat4.xyz, 0.0);
    u_xlat3.z = dot(u_xlat10_4, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat4.xyz = u_xlat7.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
    u_xlat10_4 = textureLod(_ShadowMapTexture, u_xlat4.xyz, 0.0);
    u_xlat3.w = dot(u_xlat10_4, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat15 = dot(u_xlat7.xyz, u_xlat7.xyz);
    u_xlat22 = sqrt(u_xlat15);
    u_xlat22 = u_xlat22 * _LightPositionRange.w;
    u_xlat22 = u_xlat22 * _LightProjectionParams.w;
    u_xlatb3 = lessThan(u_xlat3, vec4(u_xlat22));
    u_xlat3.x = (u_xlatb3.x) ? _LightShadowData.x : float(1.0);
    u_xlat3.y = (u_xlatb3.y) ? _LightShadowData.x : float(1.0);
    u_xlat3.z = (u_xlatb3.z) ? _LightShadowData.x : float(1.0);
    u_xlat3.w = (u_xlatb3.w) ? _LightShadowData.x : float(1.0);
    u_xlat16_5.x = dot(u_xlat3, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat16_5.x = u_xlat0.x + u_xlat16_5.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat15 * _LightPos.w;
    u_xlat15 = inversesqrt(u_xlat15);
    u_xlat7.xyz = u_xlat7.xyz * vec3(u_xlat15);
    u_xlat0.x = texture(_LightTextureB0, u_xlat0.xx).w;
    u_xlat0.x = u_xlat16_5.x * u_xlat0.x;
    u_xlat3.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat16_5.xyz = (-u_xlat2.xyz) * u_xlat0.xxx + (-u_xlat7.xyz);
    u_xlat16_26 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_0.x = max(u_xlat16_26, 0.00100000005);
    u_xlat16_26 = inversesqrt(u_xlat16_0.x);
    u_xlat16_5.xyz = vec3(u_xlat16_26) * u_xlat16_5.xyz;
    u_xlat16_26 = dot((-u_xlat7.xyz), u_xlat16_5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_26 = min(max(u_xlat16_26, 0.0), 1.0);
#else
    u_xlat16_26 = clamp(u_xlat16_26, 0.0, 1.0);
#endif
    u_xlat16_0.x = max(u_xlat16_26, 0.319999993);
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat16_26 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_15 = u_xlat16_26 * u_xlat16_26 + 1.5;
    u_xlat16_26 = u_xlat16_26 * u_xlat16_26;
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_15;
    u_xlat10_4.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_4.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_27 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_27 = inversesqrt(u_xlat16_27);
    u_xlat16_6.xyz = vec3(u_xlat16_27) * u_xlat16_6.xyz;
    u_xlat16_5.x = dot(u_xlat16_6.xyz, u_xlat16_5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat16_12 = dot(u_xlat16_6.xyz, (-u_xlat7.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_12 = min(max(u_xlat16_12, 0.0), 1.0);
#else
    u_xlat16_12 = clamp(u_xlat16_12, 0.0, 1.0);
#endif
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_5.x;
    u_xlat16_7 = u_xlat16_26 * u_xlat16_26 + -1.0;
    u_xlat16_7 = u_xlat16_5.x * u_xlat16_7 + 1.00001001;
    u_xlat16_0.x = u_xlat16_7 * u_xlat16_0.x;
    u_xlat16_0.x = u_xlat16_26 / u_xlat16_0.x;
    u_xlat16_0.x = u_xlat16_0.x + -9.99999975e-05;
    u_xlat16_5.x = max(u_xlat16_0.x, 0.0);
    u_xlat16_5.x = min(u_xlat16_5.x, 100.0);
    u_xlat16_5.xzw = u_xlat16_5.xxx * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat16_5.xzw = u_xlat3.xyz * u_xlat16_5.xzw;
    u_xlat16_0.xyz = vec3(u_xlat16_12) * u_xlat16_5.xzw;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
    return;
}

#endif
"
}
SubProgram "gles " {
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  highp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w)));
  atten_6 = tmpvar_14.w;
  mediump float tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_15 = tmpvar_16;
  mediump float shadowVal_17;
  highp float mydist_18;
  mydist_18 = ((sqrt(
    dot (tmpvar_12, tmpvar_12)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_19;
  tmpvar_19 = textureCube (_ShadowMapTexture, tmpvar_12);
  highp vec4 vals_20;
  vals_20 = tmpvar_19;
  highp float tmpvar_21;
  tmpvar_21 = dot (vals_20, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVal_17 = tmpvar_21;
  mediump float tmpvar_22;
  if ((shadowVal_17 < mydist_18)) {
    tmpvar_22 = _LightShadowData.x;
  } else {
    tmpvar_22 = 1.0;
  };
  mediump float tmpvar_23;
  tmpvar_23 = clamp ((tmpvar_22 + tmpvar_15), 0.0, 1.0);
  atten_6 = (tmpvar_14.w * tmpvar_23);
  highp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = tmpvar_10;
  highp vec4 tmpvar_25;
  tmpvar_25.w = -8.0;
  tmpvar_25.xyz = (unity_WorldToLight * tmpvar_24).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_25.xyz, -8.0).w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_28;
  mediump vec3 tmpvar_29;
  tmpvar_29 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_30;
  tmpvar_30 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_31;
  viewDir_31 = -(tmpvar_30);
  mediump vec2 tmpvar_32;
  tmpvar_32.x = dot ((viewDir_31 - (2.0 * 
    (dot (tmpvar_29, viewDir_31) * tmpvar_29)
  )), lightDir_7);
  tmpvar_32.y = (1.0 - clamp (dot (tmpvar_29, viewDir_31), 0.0, 1.0));
  mediump float specular_33;
  mediump vec2 tmpvar_34;
  tmpvar_34.x = ((tmpvar_32 * tmpvar_32) * (tmpvar_32 * tmpvar_32)).x;
  tmpvar_34.y = (1.0 - gbuffer1_3.w);
  highp float tmpvar_35;
  tmpvar_35 = (texture2D (unity_NHxRoughness, tmpvar_34).w * 16.0);
  specular_33 = tmpvar_35;
  mediump vec4 tmpvar_36;
  tmpvar_36.w = 1.0;
  tmpvar_36.xyz = ((gbuffer0_4.xyz + (specular_33 * gbuffer1_3.xyz)) * (tmpvar_5 * clamp (
    dot (tmpvar_29, lightDir_7)
  , 0.0, 1.0)));
  mediump vec4 tmpvar_37;
  tmpvar_37 = exp2(-(tmpvar_36));
  tmpvar_1 = tmpvar_37;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 " {
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform highp sampler2D unity_NHxRoughness;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
mediump vec4 u_xlat16_0;
lowp vec4 u_xlat10_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
lowp vec4 u_xlat10_3;
mediump vec3 u_xlat16_4;
lowp vec3 u_xlat10_5;
mediump vec3 u_xlat16_6;
vec3 u_xlat7;
float u_xlat15;
bool u_xlatb15;
float u_xlat16;
float u_xlat21;
float u_xlat22;
mediump float u_xlat16_25;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat21 = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat21 = float(1.0) / u_xlat21;
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat21 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat7.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat10_3 = texture(_ShadowMapTexture, u_xlat7.xyz);
    u_xlat15 = dot(u_xlat10_3, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat22 = dot(u_xlat7.xyz, u_xlat7.xyz);
    u_xlat16 = sqrt(u_xlat22);
    u_xlat16 = u_xlat16 * _LightPositionRange.w;
    u_xlat16 = u_xlat16 * _LightProjectionParams.w;
#ifdef UNITY_ADRENO_ES3
    u_xlatb15 = !!(u_xlat15<u_xlat16);
#else
    u_xlatb15 = u_xlat15<u_xlat16;
#endif
    u_xlat16_4.x = (u_xlatb15) ? _LightShadowData.x : 1.0;
    u_xlat16_4.x = u_xlat0.x + u_xlat16_4.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat22 * _LightPos.w;
    u_xlat15 = inversesqrt(u_xlat22);
    u_xlat7.xyz = u_xlat7.xyz * vec3(u_xlat15);
    u_xlat0.x = texture(_LightTextureB0, u_xlat0.xx).w;
    u_xlat0.x = u_xlat16_4.x * u_xlat0.x;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat3.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat3.xyz = u_xlat3.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat15 = texture(_LightTexture0, u_xlat3.xyz, -8.0).w;
    u_xlat0.x = u_xlat0.x * u_xlat15;
    u_xlat3.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat10_5.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_4.xyz = u_xlat10_5.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_25 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_25 = inversesqrt(u_xlat16_25);
    u_xlat16_4.xyz = vec3(u_xlat16_25) * u_xlat16_4.xyz;
    u_xlat16_25 = dot(u_xlat16_4.xyz, (-u_xlat7.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_25 = min(max(u_xlat16_25, 0.0), 1.0);
#else
    u_xlat16_25 = clamp(u_xlat16_25, 0.0, 1.0);
#endif
    u_xlat16_6.xyz = u_xlat3.xyz * vec3(u_xlat16_25);
    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat2.xyz = u_xlat0.xxx * u_xlat2.xyz;
    u_xlat16_25 = dot((-u_xlat2.xyz), u_xlat16_4.xyz);
    u_xlat16_25 = u_xlat16_25 + u_xlat16_25;
    u_xlat16_4.xyz = u_xlat16_4.xyz * (-vec3(u_xlat16_25)) + (-u_xlat2.xyz);
    u_xlat16_4.x = dot(u_xlat16_4.xyz, (-u_xlat7.xyz));
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_4.x;
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_4.x;
    u_xlat10_0 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_4.y = (-u_xlat10_0.w) + 1.0;
    u_xlat21 = texture(unity_NHxRoughness, u_xlat16_4.xy).w;
    u_xlat21 = u_xlat21 * 16.0;
    u_xlat16_4.xyz = vec3(u_xlat21) * u_xlat10_0.xyz + u_xlat10_1.xyz;
    u_xlat16_0.xyz = u_xlat16_6.xyz * u_xlat16_4.xyz;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
    return;
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  highp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w)));
  atten_6 = tmpvar_14.w;
  mediump float tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_15 = tmpvar_16;
  mediump float shadowVal_17;
  highp float mydist_18;
  mydist_18 = ((sqrt(
    dot (tmpvar_12, tmpvar_12)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_19;
  tmpvar_19 = textureCube (_ShadowMapTexture, tmpvar_12);
  highp vec4 vals_20;
  vals_20 = tmpvar_19;
  highp float tmpvar_21;
  tmpvar_21 = dot (vals_20, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVal_17 = tmpvar_21;
  mediump float tmpvar_22;
  if ((shadowVal_17 < mydist_18)) {
    tmpvar_22 = _LightShadowData.x;
  } else {
    tmpvar_22 = 1.0;
  };
  mediump float tmpvar_23;
  tmpvar_23 = clamp ((tmpvar_22 + tmpvar_15), 0.0, 1.0);
  atten_6 = (tmpvar_14.w * tmpvar_23);
  highp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = tmpvar_10;
  highp vec4 tmpvar_25;
  tmpvar_25.w = -8.0;
  tmpvar_25.xyz = (unity_WorldToLight * tmpvar_24).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_25.xyz, -8.0).w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_28;
  mediump vec3 tmpvar_29;
  tmpvar_29 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_30;
  tmpvar_30 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_31;
  viewDir_31 = -(tmpvar_30);
  mediump float specularTerm_32;
  mediump vec3 tmpvar_33;
  mediump vec3 inVec_34;
  inVec_34 = (lightDir_7 + viewDir_31);
  tmpvar_33 = (inVec_34 * inversesqrt(max (0.001, 
    dot (inVec_34, inVec_34)
  )));
  mediump float tmpvar_35;
  tmpvar_35 = clamp (dot (tmpvar_29, tmpvar_33), 0.0, 1.0);
  mediump float tmpvar_36;
  tmpvar_36 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_37;
  tmpvar_37 = (tmpvar_36 * tmpvar_36);
  specularTerm_32 = ((tmpvar_37 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_33), 0.0, 1.0)) * (1.5 + tmpvar_37))
   * 
    (((tmpvar_35 * tmpvar_35) * ((tmpvar_37 * tmpvar_37) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_38;
  tmpvar_38 = clamp (specularTerm_32, 0.0, 100.0);
  specularTerm_32 = tmpvar_38;
  mediump vec4 tmpvar_39;
  tmpvar_39.w = 1.0;
  tmpvar_39.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_38 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_29, lightDir_7), 0.0, 1.0));
  mediump vec4 tmpvar_40;
  tmpvar_40 = exp2(-(tmpvar_39));
  tmpvar_1 = tmpvar_40;
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  highp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w)));
  atten_6 = tmpvar_14.w;
  mediump float tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_15 = tmpvar_16;
  mediump float shadowVal_17;
  highp float mydist_18;
  mydist_18 = ((sqrt(
    dot (tmpvar_12, tmpvar_12)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_19;
  tmpvar_19 = textureCube (_ShadowMapTexture, tmpvar_12);
  highp vec4 vals_20;
  vals_20 = tmpvar_19;
  highp float tmpvar_21;
  tmpvar_21 = dot (vals_20, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVal_17 = tmpvar_21;
  mediump float tmpvar_22;
  if ((shadowVal_17 < mydist_18)) {
    tmpvar_22 = _LightShadowData.x;
  } else {
    tmpvar_22 = 1.0;
  };
  mediump float tmpvar_23;
  tmpvar_23 = clamp ((tmpvar_22 + tmpvar_15), 0.0, 1.0);
  atten_6 = (tmpvar_14.w * tmpvar_23);
  highp vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = tmpvar_10;
  highp vec4 tmpvar_25;
  tmpvar_25.w = -8.0;
  tmpvar_25.xyz = (unity_WorldToLight * tmpvar_24).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_25.xyz, -8.0).w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_27;
  lowp vec4 tmpvar_28;
  tmpvar_28 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_28;
  mediump vec3 tmpvar_29;
  tmpvar_29 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_30;
  tmpvar_30 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_31;
  viewDir_31 = -(tmpvar_30);
  mediump float specularTerm_32;
  mediump vec3 tmpvar_33;
  mediump vec3 inVec_34;
  inVec_34 = (lightDir_7 + viewDir_31);
  tmpvar_33 = (inVec_34 * inversesqrt(max (0.001, 
    dot (inVec_34, inVec_34)
  )));
  mediump float tmpvar_35;
  tmpvar_35 = clamp (dot (tmpvar_29, tmpvar_33), 0.0, 1.0);
  mediump float tmpvar_36;
  tmpvar_36 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_37;
  tmpvar_37 = (tmpvar_36 * tmpvar_36);
  specularTerm_32 = ((tmpvar_37 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_33), 0.0, 1.0)) * (1.5 + tmpvar_37))
   * 
    (((tmpvar_35 * tmpvar_35) * ((tmpvar_37 * tmpvar_37) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_38;
  tmpvar_38 = clamp (specularTerm_32, 0.0, 100.0);
  specularTerm_32 = tmpvar_38;
  mediump vec4 tmpvar_39;
  tmpvar_39.w = 1.0;
  tmpvar_39.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_38 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_29, lightDir_7), 0.0, 1.0));
  mediump vec4 tmpvar_40;
  tmpvar_40 = exp2(-(tmpvar_39));
  tmpvar_1 = tmpvar_40;
  gl_FragData[0] = tmpvar_1;
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
mediump vec4 u_xlat16_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
lowp vec4 u_xlat10_3;
mediump vec4 u_xlat16_4;
lowp vec3 u_xlat10_5;
mediump vec3 u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_7;
mediump float u_xlat16_11;
float u_xlat15;
mediump float u_xlat16_15;
bool u_xlatb15;
float u_xlat16;
float u_xlat21;
float u_xlat22;
mediump float u_xlat16_25;
mediump float u_xlat16_27;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat21 = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat21 = float(1.0) / u_xlat21;
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat21 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat7.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat10_3 = texture(_ShadowMapTexture, u_xlat7.xyz);
    u_xlat15 = dot(u_xlat10_3, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat22 = dot(u_xlat7.xyz, u_xlat7.xyz);
    u_xlat16 = sqrt(u_xlat22);
    u_xlat16 = u_xlat16 * _LightPositionRange.w;
    u_xlat16 = u_xlat16 * _LightProjectionParams.w;
#ifdef UNITY_ADRENO_ES3
    u_xlatb15 = !!(u_xlat15<u_xlat16);
#else
    u_xlatb15 = u_xlat15<u_xlat16;
#endif
    u_xlat16_4.x = (u_xlatb15) ? _LightShadowData.x : 1.0;
    u_xlat16_4.x = u_xlat0.x + u_xlat16_4.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat22 * _LightPos.w;
    u_xlat15 = inversesqrt(u_xlat22);
    u_xlat7.xyz = u_xlat7.xyz * vec3(u_xlat15);
    u_xlat0.x = texture(_LightTextureB0, u_xlat0.xx).w;
    u_xlat0.x = u_xlat16_4.x * u_xlat0.x;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat3.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat3.xyz = u_xlat3.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat15 = texture(_LightTexture0, u_xlat3.xyz, -8.0).w;
    u_xlat0.x = u_xlat0.x * u_xlat15;
    u_xlat3.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat16_4.xyz = (-u_xlat2.xyz) * u_xlat0.xxx + (-u_xlat7.xyz);
    u_xlat16_25 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_0.x = max(u_xlat16_25, 0.00100000005);
    u_xlat16_25 = inversesqrt(u_xlat16_0.x);
    u_xlat16_4.xyz = vec3(u_xlat16_25) * u_xlat16_4.xyz;
    u_xlat16_25 = dot((-u_xlat7.xyz), u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_25 = min(max(u_xlat16_25, 0.0), 1.0);
#else
    u_xlat16_25 = clamp(u_xlat16_25, 0.0, 1.0);
#endif
    u_xlat16_0.x = max(u_xlat16_25, 0.319999993);
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat16_25 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_15 = u_xlat16_25 * u_xlat16_25 + 1.5;
    u_xlat16_25 = u_xlat16_25 * u_xlat16_25;
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_15;
    u_xlat10_5.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_5.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_27 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_27 = inversesqrt(u_xlat16_27);
    u_xlat16_6.xyz = vec3(u_xlat16_27) * u_xlat16_6.xyz;
    u_xlat16_4.x = dot(u_xlat16_6.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_11 = dot(u_xlat16_6.xyz, (-u_xlat7.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_11 = min(max(u_xlat16_11, 0.0), 1.0);
#else
    u_xlat16_11 = clamp(u_xlat16_11, 0.0, 1.0);
#endif
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_4.x;
    u_xlat16_7 = u_xlat16_25 * u_xlat16_25 + -1.0;
    u_xlat16_7 = u_xlat16_4.x * u_xlat16_7 + 1.00001001;
    u_xlat16_0.x = u_xlat16_7 * u_xlat16_0.x;
    u_xlat16_0.x = u_xlat16_25 / u_xlat16_0.x;
    u_xlat16_0.x = u_xlat16_0.x + -9.99999975e-05;
    u_xlat16_4.x = max(u_xlat16_0.x, 0.0);
    u_xlat16_4.x = min(u_xlat16_4.x, 100.0);
    u_xlat16_4.xzw = u_xlat16_4.xxx * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat16_4.xzw = u_xlat3.xyz * u_xlat16_4.xzw;
    u_xlat16_0.xyz = vec3(u_xlat16_11) * u_xlat16_4.xzw;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
mediump vec4 u_xlat16_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
lowp vec4 u_xlat10_3;
mediump vec4 u_xlat16_4;
lowp vec3 u_xlat10_5;
mediump vec3 u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_7;
mediump float u_xlat16_11;
float u_xlat15;
mediump float u_xlat16_15;
bool u_xlatb15;
float u_xlat16;
float u_xlat21;
float u_xlat22;
mediump float u_xlat16_25;
mediump float u_xlat16_27;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat21 = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat21 = float(1.0) / u_xlat21;
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat21 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat7.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat10_3 = texture(_ShadowMapTexture, u_xlat7.xyz);
    u_xlat15 = dot(u_xlat10_3, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat22 = dot(u_xlat7.xyz, u_xlat7.xyz);
    u_xlat16 = sqrt(u_xlat22);
    u_xlat16 = u_xlat16 * _LightPositionRange.w;
    u_xlat16 = u_xlat16 * _LightProjectionParams.w;
#ifdef UNITY_ADRENO_ES3
    u_xlatb15 = !!(u_xlat15<u_xlat16);
#else
    u_xlatb15 = u_xlat15<u_xlat16;
#endif
    u_xlat16_4.x = (u_xlatb15) ? _LightShadowData.x : 1.0;
    u_xlat16_4.x = u_xlat0.x + u_xlat16_4.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat22 * _LightPos.w;
    u_xlat15 = inversesqrt(u_xlat22);
    u_xlat7.xyz = u_xlat7.xyz * vec3(u_xlat15);
    u_xlat0.x = texture(_LightTextureB0, u_xlat0.xx).w;
    u_xlat0.x = u_xlat16_4.x * u_xlat0.x;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat3.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat3.xyz = u_xlat3.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat15 = texture(_LightTexture0, u_xlat3.xyz, -8.0).w;
    u_xlat0.x = u_xlat0.x * u_xlat15;
    u_xlat3.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat16_4.xyz = (-u_xlat2.xyz) * u_xlat0.xxx + (-u_xlat7.xyz);
    u_xlat16_25 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_0.x = max(u_xlat16_25, 0.00100000005);
    u_xlat16_25 = inversesqrt(u_xlat16_0.x);
    u_xlat16_4.xyz = vec3(u_xlat16_25) * u_xlat16_4.xyz;
    u_xlat16_25 = dot((-u_xlat7.xyz), u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_25 = min(max(u_xlat16_25, 0.0), 1.0);
#else
    u_xlat16_25 = clamp(u_xlat16_25, 0.0, 1.0);
#endif
    u_xlat16_0.x = max(u_xlat16_25, 0.319999993);
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat16_25 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_15 = u_xlat16_25 * u_xlat16_25 + 1.5;
    u_xlat16_25 = u_xlat16_25 * u_xlat16_25;
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_15;
    u_xlat10_5.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_5.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_27 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_27 = inversesqrt(u_xlat16_27);
    u_xlat16_6.xyz = vec3(u_xlat16_27) * u_xlat16_6.xyz;
    u_xlat16_4.x = dot(u_xlat16_6.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_11 = dot(u_xlat16_6.xyz, (-u_xlat7.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_11 = min(max(u_xlat16_11, 0.0), 1.0);
#else
    u_xlat16_11 = clamp(u_xlat16_11, 0.0, 1.0);
#endif
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_4.x;
    u_xlat16_7 = u_xlat16_25 * u_xlat16_25 + -1.0;
    u_xlat16_7 = u_xlat16_4.x * u_xlat16_7 + 1.00001001;
    u_xlat16_0.x = u_xlat16_7 * u_xlat16_0.x;
    u_xlat16_0.x = u_xlat16_25 / u_xlat16_0.x;
    u_xlat16_0.x = u_xlat16_0.x + -9.99999975e-05;
    u_xlat16_4.x = max(u_xlat16_0.x, 0.0);
    u_xlat16_4.x = min(u_xlat16_4.x, 100.0);
    u_xlat16_4.xzw = u_xlat16_4.xxx * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat16_4.xzw = u_xlat3.xyz * u_xlat16_4.xzw;
    u_xlat16_0.xyz = vec3(u_xlat16_11) * u_xlat16_4.xzw;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
    return;
}

#endif
"
}
SubProgram "gles " {
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  highp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w)));
  atten_6 = tmpvar_14.w;
  mediump float tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_15 = tmpvar_16;
  highp vec4 shadowVals_17;
  highp float mydist_18;
  mydist_18 = ((sqrt(
    dot (tmpvar_12, tmpvar_12)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_19;
  tmpvar_19.w = 0.0;
  tmpvar_19.xyz = (tmpvar_12 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_19.xyz, 0.0);
  tmpvar_20 = tmpvar_21;
  shadowVals_17.x = dot (tmpvar_20, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_22;
  tmpvar_22.w = 0.0;
  tmpvar_22.xyz = (tmpvar_12 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_22.xyz, 0.0);
  tmpvar_23 = tmpvar_24;
  shadowVals_17.y = dot (tmpvar_23, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_25;
  tmpvar_25.w = 0.0;
  tmpvar_25.xyz = (tmpvar_12 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_25.xyz, 0.0);
  tmpvar_26 = tmpvar_27;
  shadowVals_17.z = dot (tmpvar_26, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_28;
  tmpvar_28.w = 0.0;
  tmpvar_28.xyz = (tmpvar_12 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_28.xyz, 0.0);
  tmpvar_29 = tmpvar_30;
  shadowVals_17.w = dot (tmpvar_29, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_31;
  tmpvar_31 = lessThan (shadowVals_17, vec4(mydist_18));
  mediump vec4 tmpvar_32;
  tmpvar_32 = _LightShadowData.xxxx;
  mediump float tmpvar_33;
  if (tmpvar_31.x) {
    tmpvar_33 = tmpvar_32.x;
  } else {
    tmpvar_33 = 1.0;
  };
  mediump float tmpvar_34;
  if (tmpvar_31.y) {
    tmpvar_34 = tmpvar_32.y;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_31.z) {
    tmpvar_35 = tmpvar_32.z;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump float tmpvar_36;
  if (tmpvar_31.w) {
    tmpvar_36 = tmpvar_32.w;
  } else {
    tmpvar_36 = 1.0;
  };
  mediump vec4 tmpvar_37;
  tmpvar_37.x = tmpvar_33;
  tmpvar_37.y = tmpvar_34;
  tmpvar_37.z = tmpvar_35;
  tmpvar_37.w = tmpvar_36;
  mediump float tmpvar_38;
  tmpvar_38 = clamp ((dot (tmpvar_37, vec4(0.25, 0.25, 0.25, 0.25)) + tmpvar_15), 0.0, 1.0);
  atten_6 = (tmpvar_14.w * tmpvar_38);
  highp vec4 tmpvar_39;
  tmpvar_39.w = 1.0;
  tmpvar_39.xyz = tmpvar_10;
  highp vec4 tmpvar_40;
  tmpvar_40.w = -8.0;
  tmpvar_40.xyz = (unity_WorldToLight * tmpvar_39).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_40.xyz, -8.0).w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_41;
  tmpvar_41 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_41;
  lowp vec4 tmpvar_42;
  tmpvar_42 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_42;
  lowp vec4 tmpvar_43;
  tmpvar_43 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_43;
  mediump vec3 tmpvar_44;
  tmpvar_44 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_45;
  tmpvar_45 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_46;
  viewDir_46 = -(tmpvar_45);
  mediump vec2 tmpvar_47;
  tmpvar_47.x = dot ((viewDir_46 - (2.0 * 
    (dot (tmpvar_44, viewDir_46) * tmpvar_44)
  )), lightDir_7);
  tmpvar_47.y = (1.0 - clamp (dot (tmpvar_44, viewDir_46), 0.0, 1.0));
  mediump float specular_48;
  mediump vec2 tmpvar_49;
  tmpvar_49.x = ((tmpvar_47 * tmpvar_47) * (tmpvar_47 * tmpvar_47)).x;
  tmpvar_49.y = (1.0 - gbuffer1_3.w);
  highp float tmpvar_50;
  tmpvar_50 = (texture2D (unity_NHxRoughness, tmpvar_49).w * 16.0);
  specular_48 = tmpvar_50;
  mediump vec4 tmpvar_51;
  tmpvar_51.w = 1.0;
  tmpvar_51.xyz = ((gbuffer0_4.xyz + (specular_48 * gbuffer1_3.xyz)) * (tmpvar_5 * clamp (
    dot (tmpvar_44, lightDir_7)
  , 0.0, 1.0)));
  mediump vec4 tmpvar_52;
  tmpvar_52 = exp2(-(tmpvar_51));
  tmpvar_1 = tmpvar_52;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 " {
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform highp sampler2D unity_NHxRoughness;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
lowp vec4 u_xlat10_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec4 u_xlat4;
lowp vec4 u_xlat10_4;
bvec4 u_xlatb4;
vec3 u_xlat5;
lowp vec4 u_xlat10_5;
mediump vec3 u_xlat16_6;
mediump vec3 u_xlat16_7;
float u_xlat8;
float u_xlat17;
float u_xlat24;
mediump float u_xlat16_30;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat24 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat24 = _ZBufferParams.x * u_xlat24 + _ZBufferParams.y;
    u_xlat24 = float(1.0) / u_xlat24;
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat0.xyz;
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
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat8 = sqrt(u_xlat0.x);
    u_xlat8 = u_xlat8 * _LightPositionRange.w;
    u_xlat8 = u_xlat8 * _LightProjectionParams.w;
    u_xlatb4 = lessThan(u_xlat4, vec4(u_xlat8));
    u_xlat4.x = (u_xlatb4.x) ? _LightShadowData.x : float(1.0);
    u_xlat4.y = (u_xlatb4.y) ? _LightShadowData.x : float(1.0);
    u_xlat4.z = (u_xlatb4.z) ? _LightShadowData.x : float(1.0);
    u_xlat4.w = (u_xlatb4.w) ? _LightShadowData.x : float(1.0);
    u_xlat16_6.x = dot(u_xlat4, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat4.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat8 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat8 = sqrt(u_xlat8);
    u_xlat8 = (-u_xlat0.z) * u_xlat24 + u_xlat8;
    u_xlat8 = unity_ShadowFadeCenterAndType.w * u_xlat8 + u_xlat2.z;
    u_xlat8 = u_xlat8 * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat8 = min(max(u_xlat8, 0.0), 1.0);
#else
    u_xlat8 = clamp(u_xlat8, 0.0, 1.0);
#endif
    u_xlat16_6.x = u_xlat8 + u_xlat16_6.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_6.x = min(max(u_xlat16_6.x, 0.0), 1.0);
#else
    u_xlat16_6.x = clamp(u_xlat16_6.x, 0.0, 1.0);
#endif
    u_xlat8 = u_xlat0.x * _LightPos.w;
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat0.xzw = u_xlat0.xxx * u_xlat3.xyz;
    u_xlat8 = texture(_LightTextureB0, vec2(u_xlat8)).w;
    u_xlat8 = u_xlat16_6.x * u_xlat8;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat3.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat3.xyz = u_xlat3.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat17 = texture(_LightTexture0, u_xlat3.xyz, -8.0).w;
    u_xlat8 = u_xlat8 * u_xlat17;
    u_xlat3.xyz = vec3(u_xlat8) * _LightColor.xyz;
    u_xlat10_4.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_4.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_30 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_30 = inversesqrt(u_xlat16_30);
    u_xlat16_6.xyz = vec3(u_xlat16_30) * u_xlat16_6.xyz;
    u_xlat16_30 = dot(u_xlat16_6.xyz, (-u_xlat0.xzw));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_30 = min(max(u_xlat16_30, 0.0), 1.0);
#else
    u_xlat16_30 = clamp(u_xlat16_30, 0.0, 1.0);
#endif
    u_xlat16_7.xyz = u_xlat3.xyz * vec3(u_xlat16_30);
    u_xlat8 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat8 = inversesqrt(u_xlat8);
    u_xlat2.xyz = vec3(u_xlat8) * u_xlat2.xyz;
    u_xlat16_30 = dot((-u_xlat2.xyz), u_xlat16_6.xyz);
    u_xlat16_30 = u_xlat16_30 + u_xlat16_30;
    u_xlat16_6.xyz = u_xlat16_6.xyz * (-vec3(u_xlat16_30)) + (-u_xlat2.xyz);
    u_xlat16_6.x = dot(u_xlat16_6.xyz, (-u_xlat0.xzw));
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_6.x;
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_6.x;
    u_xlat10_0 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_6.y = (-u_xlat10_0.w) + 1.0;
    u_xlat24 = texture(unity_NHxRoughness, u_xlat16_6.xy).w;
    u_xlat24 = u_xlat24 * 16.0;
    u_xlat16_6.xyz = vec3(u_xlat24) * u_xlat10_0.xyz + u_xlat10_1.xyz;
    u_xlat16_0.xyz = u_xlat16_7.xyz * u_xlat16_6.xyz;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
    return;
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  highp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w)));
  atten_6 = tmpvar_14.w;
  mediump float tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_15 = tmpvar_16;
  highp vec4 shadowVals_17;
  highp float mydist_18;
  mydist_18 = ((sqrt(
    dot (tmpvar_12, tmpvar_12)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_19;
  tmpvar_19.w = 0.0;
  tmpvar_19.xyz = (tmpvar_12 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_19.xyz, 0.0);
  tmpvar_20 = tmpvar_21;
  shadowVals_17.x = dot (tmpvar_20, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_22;
  tmpvar_22.w = 0.0;
  tmpvar_22.xyz = (tmpvar_12 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_22.xyz, 0.0);
  tmpvar_23 = tmpvar_24;
  shadowVals_17.y = dot (tmpvar_23, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_25;
  tmpvar_25.w = 0.0;
  tmpvar_25.xyz = (tmpvar_12 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_25.xyz, 0.0);
  tmpvar_26 = tmpvar_27;
  shadowVals_17.z = dot (tmpvar_26, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_28;
  tmpvar_28.w = 0.0;
  tmpvar_28.xyz = (tmpvar_12 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_28.xyz, 0.0);
  tmpvar_29 = tmpvar_30;
  shadowVals_17.w = dot (tmpvar_29, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_31;
  tmpvar_31 = lessThan (shadowVals_17, vec4(mydist_18));
  mediump vec4 tmpvar_32;
  tmpvar_32 = _LightShadowData.xxxx;
  mediump float tmpvar_33;
  if (tmpvar_31.x) {
    tmpvar_33 = tmpvar_32.x;
  } else {
    tmpvar_33 = 1.0;
  };
  mediump float tmpvar_34;
  if (tmpvar_31.y) {
    tmpvar_34 = tmpvar_32.y;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_31.z) {
    tmpvar_35 = tmpvar_32.z;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump float tmpvar_36;
  if (tmpvar_31.w) {
    tmpvar_36 = tmpvar_32.w;
  } else {
    tmpvar_36 = 1.0;
  };
  mediump vec4 tmpvar_37;
  tmpvar_37.x = tmpvar_33;
  tmpvar_37.y = tmpvar_34;
  tmpvar_37.z = tmpvar_35;
  tmpvar_37.w = tmpvar_36;
  mediump float tmpvar_38;
  tmpvar_38 = clamp ((dot (tmpvar_37, vec4(0.25, 0.25, 0.25, 0.25)) + tmpvar_15), 0.0, 1.0);
  atten_6 = (tmpvar_14.w * tmpvar_38);
  highp vec4 tmpvar_39;
  tmpvar_39.w = 1.0;
  tmpvar_39.xyz = tmpvar_10;
  highp vec4 tmpvar_40;
  tmpvar_40.w = -8.0;
  tmpvar_40.xyz = (unity_WorldToLight * tmpvar_39).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_40.xyz, -8.0).w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_41;
  tmpvar_41 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_41;
  lowp vec4 tmpvar_42;
  tmpvar_42 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_42;
  lowp vec4 tmpvar_43;
  tmpvar_43 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_43;
  mediump vec3 tmpvar_44;
  tmpvar_44 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_45;
  tmpvar_45 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_46;
  viewDir_46 = -(tmpvar_45);
  mediump float specularTerm_47;
  mediump vec3 tmpvar_48;
  mediump vec3 inVec_49;
  inVec_49 = (lightDir_7 + viewDir_46);
  tmpvar_48 = (inVec_49 * inversesqrt(max (0.001, 
    dot (inVec_49, inVec_49)
  )));
  mediump float tmpvar_50;
  tmpvar_50 = clamp (dot (tmpvar_44, tmpvar_48), 0.0, 1.0);
  mediump float tmpvar_51;
  tmpvar_51 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_52;
  tmpvar_52 = (tmpvar_51 * tmpvar_51);
  specularTerm_47 = ((tmpvar_52 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_48), 0.0, 1.0)) * (1.5 + tmpvar_52))
   * 
    (((tmpvar_50 * tmpvar_50) * ((tmpvar_52 * tmpvar_52) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_53;
  tmpvar_53 = clamp (specularTerm_47, 0.0, 100.0);
  specularTerm_47 = tmpvar_53;
  mediump vec4 tmpvar_54;
  tmpvar_54.w = 1.0;
  tmpvar_54.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_53 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_44, lightDir_7), 0.0, 1.0));
  mediump vec4 tmpvar_55;
  tmpvar_55 = exp2(-(tmpvar_54));
  tmpvar_1 = tmpvar_55;
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  lowp vec4 tmpvar_1;
  mediump vec4 gbuffer2_2;
  mediump vec4 gbuffer1_3;
  mediump vec4 gbuffer0_4;
  mediump vec3 tmpvar_5;
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
  highp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_LightTextureB0, vec2((dot (tmpvar_12, tmpvar_12) * _LightPos.w)));
  atten_6 = tmpvar_14.w;
  mediump float tmpvar_15;
  highp float tmpvar_16;
  tmpvar_16 = clamp (((
    mix (tmpvar_9.z, sqrt(dot (tmpvar_11, tmpvar_11)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_15 = tmpvar_16;
  highp vec4 shadowVals_17;
  highp float mydist_18;
  mydist_18 = ((sqrt(
    dot (tmpvar_12, tmpvar_12)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_19;
  tmpvar_19.w = 0.0;
  tmpvar_19.xyz = (tmpvar_12 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_19.xyz, 0.0);
  tmpvar_20 = tmpvar_21;
  shadowVals_17.x = dot (tmpvar_20, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_22;
  tmpvar_22.w = 0.0;
  tmpvar_22.xyz = (tmpvar_12 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_22.xyz, 0.0);
  tmpvar_23 = tmpvar_24;
  shadowVals_17.y = dot (tmpvar_23, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_25;
  tmpvar_25.w = 0.0;
  tmpvar_25.xyz = (tmpvar_12 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_25.xyz, 0.0);
  tmpvar_26 = tmpvar_27;
  shadowVals_17.z = dot (tmpvar_26, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_28;
  tmpvar_28.w = 0.0;
  tmpvar_28.xyz = (tmpvar_12 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_29;
  lowp vec4 tmpvar_30;
  tmpvar_30 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_28.xyz, 0.0);
  tmpvar_29 = tmpvar_30;
  shadowVals_17.w = dot (tmpvar_29, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_31;
  tmpvar_31 = lessThan (shadowVals_17, vec4(mydist_18));
  mediump vec4 tmpvar_32;
  tmpvar_32 = _LightShadowData.xxxx;
  mediump float tmpvar_33;
  if (tmpvar_31.x) {
    tmpvar_33 = tmpvar_32.x;
  } else {
    tmpvar_33 = 1.0;
  };
  mediump float tmpvar_34;
  if (tmpvar_31.y) {
    tmpvar_34 = tmpvar_32.y;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_31.z) {
    tmpvar_35 = tmpvar_32.z;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump float tmpvar_36;
  if (tmpvar_31.w) {
    tmpvar_36 = tmpvar_32.w;
  } else {
    tmpvar_36 = 1.0;
  };
  mediump vec4 tmpvar_37;
  tmpvar_37.x = tmpvar_33;
  tmpvar_37.y = tmpvar_34;
  tmpvar_37.z = tmpvar_35;
  tmpvar_37.w = tmpvar_36;
  mediump float tmpvar_38;
  tmpvar_38 = clamp ((dot (tmpvar_37, vec4(0.25, 0.25, 0.25, 0.25)) + tmpvar_15), 0.0, 1.0);
  atten_6 = (tmpvar_14.w * tmpvar_38);
  highp vec4 tmpvar_39;
  tmpvar_39.w = 1.0;
  tmpvar_39.xyz = tmpvar_10;
  highp vec4 tmpvar_40;
  tmpvar_40.w = -8.0;
  tmpvar_40.xyz = (unity_WorldToLight * tmpvar_39).xyz;
  atten_6 = (atten_6 * textureCube (_LightTexture0, tmpvar_40.xyz, -8.0).w);
  tmpvar_5 = (_LightColor.xyz * atten_6);
  lowp vec4 tmpvar_41;
  tmpvar_41 = texture2D (_CameraGBufferTexture0, tmpvar_8);
  gbuffer0_4 = tmpvar_41;
  lowp vec4 tmpvar_42;
  tmpvar_42 = texture2D (_CameraGBufferTexture1, tmpvar_8);
  gbuffer1_3 = tmpvar_42;
  lowp vec4 tmpvar_43;
  tmpvar_43 = texture2D (_CameraGBufferTexture2, tmpvar_8);
  gbuffer2_2 = tmpvar_43;
  mediump vec3 tmpvar_44;
  tmpvar_44 = normalize(((gbuffer2_2.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_45;
  tmpvar_45 = normalize((tmpvar_10 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_46;
  viewDir_46 = -(tmpvar_45);
  mediump float specularTerm_47;
  mediump vec3 tmpvar_48;
  mediump vec3 inVec_49;
  inVec_49 = (lightDir_7 + viewDir_46);
  tmpvar_48 = (inVec_49 * inversesqrt(max (0.001, 
    dot (inVec_49, inVec_49)
  )));
  mediump float tmpvar_50;
  tmpvar_50 = clamp (dot (tmpvar_44, tmpvar_48), 0.0, 1.0);
  mediump float tmpvar_51;
  tmpvar_51 = (1.0 - gbuffer1_3.w);
  mediump float tmpvar_52;
  tmpvar_52 = (tmpvar_51 * tmpvar_51);
  specularTerm_47 = ((tmpvar_52 / (
    (max (0.32, clamp (dot (lightDir_7, tmpvar_48), 0.0, 1.0)) * (1.5 + tmpvar_52))
   * 
    (((tmpvar_50 * tmpvar_50) * ((tmpvar_52 * tmpvar_52) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_53;
  tmpvar_53 = clamp (specularTerm_47, 0.0, 100.0);
  specularTerm_47 = tmpvar_53;
  mediump vec4 tmpvar_54;
  tmpvar_54.w = 1.0;
  tmpvar_54.xyz = (((gbuffer0_4.xyz + 
    (tmpvar_53 * gbuffer1_3.xyz)
  ) * tmpvar_5) * clamp (dot (tmpvar_44, lightDir_7), 0.0, 1.0));
  mediump vec4 tmpvar_55;
  tmpvar_55 = exp2(-(tmpvar_54));
  tmpvar_1 = tmpvar_55;
  gl_FragData[0] = tmpvar_1;
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
vec4 u_xlat4;
lowp vec4 u_xlat10_4;
bvec4 u_xlatb4;
vec3 u_xlat5;
lowp vec4 u_xlat10_5;
mediump vec4 u_xlat16_6;
mediump vec3 u_xlat16_7;
float u_xlat8;
mediump float u_xlat16_8;
mediump float u_xlat16_14;
float u_xlat17;
mediump float u_xlat16_17;
float u_xlat24;
mediump float u_xlat16_30;
mediump float u_xlat16_31;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat24 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat24 = _ZBufferParams.x * u_xlat24 + _ZBufferParams.y;
    u_xlat24 = float(1.0) / u_xlat24;
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat0.xyz;
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
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat8 = sqrt(u_xlat0.x);
    u_xlat8 = u_xlat8 * _LightPositionRange.w;
    u_xlat8 = u_xlat8 * _LightProjectionParams.w;
    u_xlatb4 = lessThan(u_xlat4, vec4(u_xlat8));
    u_xlat4.x = (u_xlatb4.x) ? _LightShadowData.x : float(1.0);
    u_xlat4.y = (u_xlatb4.y) ? _LightShadowData.x : float(1.0);
    u_xlat4.z = (u_xlatb4.z) ? _LightShadowData.x : float(1.0);
    u_xlat4.w = (u_xlatb4.w) ? _LightShadowData.x : float(1.0);
    u_xlat16_6.x = dot(u_xlat4, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat4.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat8 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat8 = sqrt(u_xlat8);
    u_xlat8 = (-u_xlat0.z) * u_xlat24 + u_xlat8;
    u_xlat8 = unity_ShadowFadeCenterAndType.w * u_xlat8 + u_xlat2.z;
    u_xlat8 = u_xlat8 * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat8 = min(max(u_xlat8, 0.0), 1.0);
#else
    u_xlat8 = clamp(u_xlat8, 0.0, 1.0);
#endif
    u_xlat16_6.x = u_xlat8 + u_xlat16_6.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_6.x = min(max(u_xlat16_6.x, 0.0), 1.0);
#else
    u_xlat16_6.x = clamp(u_xlat16_6.x, 0.0, 1.0);
#endif
    u_xlat8 = u_xlat0.x * _LightPos.w;
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat0.xzw = u_xlat0.xxx * u_xlat3.xyz;
    u_xlat8 = texture(_LightTextureB0, vec2(u_xlat8)).w;
    u_xlat8 = u_xlat16_6.x * u_xlat8;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat3.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat3.xyz = u_xlat3.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat17 = texture(_LightTexture0, u_xlat3.xyz, -8.0).w;
    u_xlat8 = u_xlat8 * u_xlat17;
    u_xlat3.xyz = vec3(u_xlat8) * _LightColor.xyz;
    u_xlat8 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat8 = inversesqrt(u_xlat8);
    u_xlat16_6.xyz = (-u_xlat2.xyz) * vec3(u_xlat8) + (-u_xlat0.xzw);
    u_xlat16_30 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_8 = max(u_xlat16_30, 0.00100000005);
    u_xlat16_30 = inversesqrt(u_xlat16_8);
    u_xlat16_6.xyz = vec3(u_xlat16_30) * u_xlat16_6.xyz;
    u_xlat16_30 = dot((-u_xlat0.xzw), u_xlat16_6.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_30 = min(max(u_xlat16_30, 0.0), 1.0);
#else
    u_xlat16_30 = clamp(u_xlat16_30, 0.0, 1.0);
#endif
    u_xlat16_8 = max(u_xlat16_30, 0.319999993);
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat16_30 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_17 = u_xlat16_30 * u_xlat16_30 + 1.5;
    u_xlat16_30 = u_xlat16_30 * u_xlat16_30;
    u_xlat16_8 = u_xlat16_8 * u_xlat16_17;
    u_xlat10_4.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_7.xyz = u_xlat10_4.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_31 = dot(u_xlat16_7.xyz, u_xlat16_7.xyz);
    u_xlat16_31 = inversesqrt(u_xlat16_31);
    u_xlat16_7.xyz = vec3(u_xlat16_31) * u_xlat16_7.xyz;
    u_xlat16_6.x = dot(u_xlat16_7.xyz, u_xlat16_6.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_6.x = min(max(u_xlat16_6.x, 0.0), 1.0);
#else
    u_xlat16_6.x = clamp(u_xlat16_6.x, 0.0, 1.0);
#endif
    u_xlat16_14 = dot(u_xlat16_7.xyz, (-u_xlat0.xzw));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_14 = min(max(u_xlat16_14, 0.0), 1.0);
#else
    u_xlat16_14 = clamp(u_xlat16_14, 0.0, 1.0);
#endif
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_6.x;
    u_xlat16_0.x = u_xlat16_30 * u_xlat16_30 + -1.0;
    u_xlat16_0.x = u_xlat16_6.x * u_xlat16_0.x + 1.00001001;
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_8;
    u_xlat16_0.x = u_xlat16_30 / u_xlat16_0.x;
    u_xlat16_0.x = u_xlat16_0.x + -9.99999975e-05;
    u_xlat16_6.x = max(u_xlat16_0.x, 0.0);
    u_xlat16_6.x = min(u_xlat16_6.x, 100.0);
    u_xlat16_6.xzw = u_xlat16_6.xxx * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat16_6.xzw = u_xlat3.xyz * u_xlat16_6.xzw;
    u_xlat16_0.xyz = vec3(u_xlat16_14) * u_xlat16_6.xzw;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump vec4 u_xlat16_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
vec4 u_xlat4;
lowp vec4 u_xlat10_4;
bvec4 u_xlatb4;
vec3 u_xlat5;
lowp vec4 u_xlat10_5;
mediump vec4 u_xlat16_6;
mediump vec3 u_xlat16_7;
float u_xlat8;
mediump float u_xlat16_8;
mediump float u_xlat16_14;
float u_xlat17;
mediump float u_xlat16_17;
float u_xlat24;
mediump float u_xlat16_30;
mediump float u_xlat16_31;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat24 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat24 = _ZBufferParams.x * u_xlat24 + _ZBufferParams.y;
    u_xlat24 = float(1.0) / u_xlat24;
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat0.xyz;
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
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat8 = sqrt(u_xlat0.x);
    u_xlat8 = u_xlat8 * _LightPositionRange.w;
    u_xlat8 = u_xlat8 * _LightProjectionParams.w;
    u_xlatb4 = lessThan(u_xlat4, vec4(u_xlat8));
    u_xlat4.x = (u_xlatb4.x) ? _LightShadowData.x : float(1.0);
    u_xlat4.y = (u_xlatb4.y) ? _LightShadowData.x : float(1.0);
    u_xlat4.z = (u_xlatb4.z) ? _LightShadowData.x : float(1.0);
    u_xlat4.w = (u_xlatb4.w) ? _LightShadowData.x : float(1.0);
    u_xlat16_6.x = dot(u_xlat4, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat4.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat8 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat8 = sqrt(u_xlat8);
    u_xlat8 = (-u_xlat0.z) * u_xlat24 + u_xlat8;
    u_xlat8 = unity_ShadowFadeCenterAndType.w * u_xlat8 + u_xlat2.z;
    u_xlat8 = u_xlat8 * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat8 = min(max(u_xlat8, 0.0), 1.0);
#else
    u_xlat8 = clamp(u_xlat8, 0.0, 1.0);
#endif
    u_xlat16_6.x = u_xlat8 + u_xlat16_6.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_6.x = min(max(u_xlat16_6.x, 0.0), 1.0);
#else
    u_xlat16_6.x = clamp(u_xlat16_6.x, 0.0, 1.0);
#endif
    u_xlat8 = u_xlat0.x * _LightPos.w;
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat0.xzw = u_xlat0.xxx * u_xlat3.xyz;
    u_xlat8 = texture(_LightTextureB0, vec2(u_xlat8)).w;
    u_xlat8 = u_xlat16_6.x * u_xlat8;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat3.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat3.xyz = u_xlat3.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat17 = texture(_LightTexture0, u_xlat3.xyz, -8.0).w;
    u_xlat8 = u_xlat8 * u_xlat17;
    u_xlat3.xyz = vec3(u_xlat8) * _LightColor.xyz;
    u_xlat8 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat8 = inversesqrt(u_xlat8);
    u_xlat16_6.xyz = (-u_xlat2.xyz) * vec3(u_xlat8) + (-u_xlat0.xzw);
    u_xlat16_30 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_8 = max(u_xlat16_30, 0.00100000005);
    u_xlat16_30 = inversesqrt(u_xlat16_8);
    u_xlat16_6.xyz = vec3(u_xlat16_30) * u_xlat16_6.xyz;
    u_xlat16_30 = dot((-u_xlat0.xzw), u_xlat16_6.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_30 = min(max(u_xlat16_30, 0.0), 1.0);
#else
    u_xlat16_30 = clamp(u_xlat16_30, 0.0, 1.0);
#endif
    u_xlat16_8 = max(u_xlat16_30, 0.319999993);
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat16_30 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_17 = u_xlat16_30 * u_xlat16_30 + 1.5;
    u_xlat16_30 = u_xlat16_30 * u_xlat16_30;
    u_xlat16_8 = u_xlat16_8 * u_xlat16_17;
    u_xlat10_4.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_7.xyz = u_xlat10_4.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_31 = dot(u_xlat16_7.xyz, u_xlat16_7.xyz);
    u_xlat16_31 = inversesqrt(u_xlat16_31);
    u_xlat16_7.xyz = vec3(u_xlat16_31) * u_xlat16_7.xyz;
    u_xlat16_6.x = dot(u_xlat16_7.xyz, u_xlat16_6.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_6.x = min(max(u_xlat16_6.x, 0.0), 1.0);
#else
    u_xlat16_6.x = clamp(u_xlat16_6.x, 0.0, 1.0);
#endif
    u_xlat16_14 = dot(u_xlat16_7.xyz, (-u_xlat0.xzw));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_14 = min(max(u_xlat16_14, 0.0), 1.0);
#else
    u_xlat16_14 = clamp(u_xlat16_14, 0.0, 1.0);
#endif
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_6.x;
    u_xlat16_0.x = u_xlat16_30 * u_xlat16_30 + -1.0;
    u_xlat16_0.x = u_xlat16_6.x * u_xlat16_0.x + 1.00001001;
    u_xlat16_0.x = u_xlat16_0.x * u_xlat16_8;
    u_xlat16_0.x = u_xlat16_30 / u_xlat16_0.x;
    u_xlat16_0.x = u_xlat16_0.x + -9.99999975e-05;
    u_xlat16_6.x = max(u_xlat16_0.x, 0.0);
    u_xlat16_6.x = min(u_xlat16_6.x, 100.0);
    u_xlat16_6.xzw = u_xlat16_6.xxx * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat16_6.xzw = u_xlat3.xyz * u_xlat16_6.xzw;
    u_xlat16_0.xyz = vec3(u_xlat16_14) * u_xlat16_6.xzw;
    u_xlat16_0.w = 1.0;
    SV_Target0 = exp2((-u_xlat16_0));
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "POINT" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_10 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(normalize(tmpvar_10));
  lightDir_6 = tmpvar_11;
  atten_5 = texture2D (_LightTextureB0, vec2((dot (tmpvar_10, tmpvar_10) * _LightPos.w))).w;
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_14;
  mediump vec3 tmpvar_15;
  tmpvar_15 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_16;
  tmpvar_16 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_17;
  viewDir_17 = -(tmpvar_16);
  mediump vec2 tmpvar_18;
  tmpvar_18.x = dot ((viewDir_17 - (2.0 * 
    (dot (tmpvar_15, viewDir_17) * tmpvar_15)
  )), lightDir_6);
  tmpvar_18.y = (1.0 - clamp (dot (tmpvar_15, viewDir_17), 0.0, 1.0));
  mediump float specular_19;
  mediump vec2 tmpvar_20;
  tmpvar_20.x = ((tmpvar_18 * tmpvar_18) * (tmpvar_18 * tmpvar_18)).x;
  tmpvar_20.y = (1.0 - gbuffer1_2.w);
  highp float tmpvar_21;
  tmpvar_21 = (texture2D (unity_NHxRoughness, tmpvar_20).w * 16.0);
  specular_19 = tmpvar_21;
  mediump vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = ((gbuffer0_3.xyz + (specular_19 * gbuffer1_2.xyz)) * (tmpvar_4 * clamp (
    dot (tmpvar_15, lightDir_6)
  , 0.0, 1.0)));
  gl_FragData[0] = tmpvar_22;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "POINT" "UNITY_HDR_ON" }
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
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform highp sampler2D unity_NHxRoughness;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
lowp vec4 u_xlat10_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
lowp vec3 u_xlat10_3;
mediump vec3 u_xlat16_4;
mediump vec3 u_xlat16_5;
float u_xlat13;
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
    u_xlat0.xyz = vec3(u_xlat18) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat0.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat18 = inversesqrt(u_xlat18);
    u_xlat2.xyz = vec3(u_xlat18) * u_xlat2.xyz;
    u_xlat10_3.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_4.xyz = u_xlat10_3.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat16_22 = dot((-u_xlat2.xyz), u_xlat16_4.xyz);
    u_xlat16_22 = u_xlat16_22 + u_xlat16_22;
    u_xlat16_5.xyz = u_xlat16_4.xyz * (-vec3(u_xlat16_22)) + (-u_xlat2.xyz);
    u_xlat18 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat13 = inversesqrt(u_xlat18);
    u_xlat18 = u_xlat18 * _LightPos.w;
    u_xlat18 = texture(_LightTextureB0, vec2(u_xlat18)).w;
    u_xlat2.xyz = vec3(u_xlat18) * _LightColor.xyz;
    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat13);
    u_xlat16_22 = dot(u_xlat16_5.xyz, (-u_xlat0.xyz));
    u_xlat16_4.x = dot(u_xlat16_4.xyz, (-u_xlat0.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_4.xyz = u_xlat2.xyz * u_xlat16_4.xxx;
    u_xlat16_22 = u_xlat16_22 * u_xlat16_22;
    u_xlat16_5.x = u_xlat16_22 * u_xlat16_22;
    u_xlat10_0 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_5.y = (-u_xlat10_0.w) + 1.0;
    u_xlat18 = texture(unity_NHxRoughness, u_xlat16_5.xy).w;
    u_xlat18 = u_xlat18 * 16.0;
    u_xlat16_5.xyz = vec3(u_xlat18) * u_xlat10_0.xyz + u_xlat10_1.xyz;
    SV_Target0.xyz = u_xlat16_4.xyz * u_xlat16_5.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp sampler2D _LightTextureB0;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_10 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(normalize(tmpvar_10));
  lightDir_6 = tmpvar_11;
  atten_5 = texture2D (_LightTextureB0, vec2((dot (tmpvar_10, tmpvar_10) * _LightPos.w))).w;
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_14;
  mediump vec3 tmpvar_15;
  tmpvar_15 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_16;
  tmpvar_16 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_17;
  viewDir_17 = -(tmpvar_16);
  mediump float specularTerm_18;
  mediump vec3 tmpvar_19;
  mediump vec3 inVec_20;
  inVec_20 = (lightDir_6 + viewDir_17);
  tmpvar_19 = (inVec_20 * inversesqrt(max (0.001, 
    dot (inVec_20, inVec_20)
  )));
  mediump float tmpvar_21;
  tmpvar_21 = clamp (dot (tmpvar_15, tmpvar_19), 0.0, 1.0);
  mediump float tmpvar_22;
  tmpvar_22 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_23;
  tmpvar_23 = (tmpvar_22 * tmpvar_22);
  specularTerm_18 = ((tmpvar_23 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_19), 0.0, 1.0)) * (1.5 + tmpvar_23))
   * 
    (((tmpvar_21 * tmpvar_21) * ((tmpvar_23 * tmpvar_23) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_24;
  tmpvar_24 = clamp (specularTerm_18, 0.0, 100.0);
  specularTerm_18 = tmpvar_24;
  mediump vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_24 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_15, lightDir_6), 0.0, 1.0));
  gl_FragData[0] = tmpvar_25;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp sampler2D _LightTextureB0;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_10 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(normalize(tmpvar_10));
  lightDir_6 = tmpvar_11;
  atten_5 = texture2D (_LightTextureB0, vec2((dot (tmpvar_10, tmpvar_10) * _LightPos.w))).w;
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_12;
  tmpvar_12 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_12;
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_14;
  mediump vec3 tmpvar_15;
  tmpvar_15 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_16;
  tmpvar_16 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_17;
  viewDir_17 = -(tmpvar_16);
  mediump float specularTerm_18;
  mediump vec3 tmpvar_19;
  mediump vec3 inVec_20;
  inVec_20 = (lightDir_6 + viewDir_17);
  tmpvar_19 = (inVec_20 * inversesqrt(max (0.001, 
    dot (inVec_20, inVec_20)
  )));
  mediump float tmpvar_21;
  tmpvar_21 = clamp (dot (tmpvar_15, tmpvar_19), 0.0, 1.0);
  mediump float tmpvar_22;
  tmpvar_22 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_23;
  tmpvar_23 = (tmpvar_22 * tmpvar_22);
  specularTerm_18 = ((tmpvar_23 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_19), 0.0, 1.0)) * (1.5 + tmpvar_23))
   * 
    (((tmpvar_21 * tmpvar_21) * ((tmpvar_23 * tmpvar_23) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_24;
  tmpvar_24 = clamp (specularTerm_18, 0.0, 100.0);
  specularTerm_18 = tmpvar_24;
  mediump vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_24 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_15, lightDir_6), 0.0, 1.0));
  gl_FragData[0] = tmpvar_25;
}


#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT" "UNITY_HDR_ON" }
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
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump float u_xlat16_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec4 u_xlat16_4;
lowp vec3 u_xlat10_5;
mediump vec3 u_xlat16_6;
mediump float u_xlat16_11;
float u_xlat15;
mediump float u_xlat16_15;
float u_xlat21;
mediump float u_xlat16_21;
float u_xlat22;
mediump float u_xlat16_25;
mediump float u_xlat16_27;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat21 = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat21 = float(1.0) / u_xlat21;
    u_xlat0.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat0.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat22 = inversesqrt(u_xlat15);
    u_xlat15 = u_xlat15 * _LightPos.w;
    u_xlat15 = texture(_LightTextureB0, vec2(u_xlat15)).w;
    u_xlat3.xyz = vec3(u_xlat15) * _LightColor.xyz;
    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat22);
    u_xlat16_4.xyz = (-u_xlat2.xyz) * vec3(u_xlat21) + (-u_xlat0.xyz);
    u_xlat16_25 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_21 = max(u_xlat16_25, 0.00100000005);
    u_xlat16_25 = inversesqrt(u_xlat16_21);
    u_xlat16_4.xyz = vec3(u_xlat16_25) * u_xlat16_4.xyz;
    u_xlat16_25 = dot((-u_xlat0.xyz), u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_25 = min(max(u_xlat16_25, 0.0), 1.0);
#else
    u_xlat16_25 = clamp(u_xlat16_25, 0.0, 1.0);
#endif
    u_xlat16_21 = max(u_xlat16_25, 0.319999993);
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat16_25 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_15 = u_xlat16_25 * u_xlat16_25 + 1.5;
    u_xlat16_25 = u_xlat16_25 * u_xlat16_25;
    u_xlat16_21 = u_xlat16_21 * u_xlat16_15;
    u_xlat10_5.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_5.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_27 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_27 = inversesqrt(u_xlat16_27);
    u_xlat16_6.xyz = vec3(u_xlat16_27) * u_xlat16_6.xyz;
    u_xlat16_4.x = dot(u_xlat16_6.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_11 = dot(u_xlat16_6.xyz, (-u_xlat0.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_11 = min(max(u_xlat16_11, 0.0), 1.0);
#else
    u_xlat16_11 = clamp(u_xlat16_11, 0.0, 1.0);
#endif
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_4.x;
    u_xlat16_0 = u_xlat16_25 * u_xlat16_25 + -1.0;
    u_xlat16_0 = u_xlat16_4.x * u_xlat16_0 + 1.00001001;
    u_xlat16_0 = u_xlat16_0 * u_xlat16_21;
    u_xlat16_0 = u_xlat16_25 / u_xlat16_0;
    u_xlat16_0 = u_xlat16_0 + -9.99999975e-05;
    u_xlat16_4.x = max(u_xlat16_0, 0.0);
    u_xlat16_4.x = min(u_xlat16_4.x, 100.0);
    u_xlat16_4.xzw = u_xlat16_4.xxx * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat16_4.xzw = u_xlat3.xyz * u_xlat16_4.xzw;
    SV_Target0.xyz = vec3(u_xlat16_11) * u_xlat16_4.xzw;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT" "UNITY_HDR_ON" }
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
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump float u_xlat16_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec4 u_xlat16_4;
lowp vec3 u_xlat10_5;
mediump vec3 u_xlat16_6;
mediump float u_xlat16_11;
float u_xlat15;
mediump float u_xlat16_15;
float u_xlat21;
mediump float u_xlat16_21;
float u_xlat22;
mediump float u_xlat16_25;
mediump float u_xlat16_27;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat21 = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat21 = float(1.0) / u_xlat21;
    u_xlat0.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat0.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat21 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat21 = inversesqrt(u_xlat21);
    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat22 = inversesqrt(u_xlat15);
    u_xlat15 = u_xlat15 * _LightPos.w;
    u_xlat15 = texture(_LightTextureB0, vec2(u_xlat15)).w;
    u_xlat3.xyz = vec3(u_xlat15) * _LightColor.xyz;
    u_xlat0.xyz = u_xlat0.xyz * vec3(u_xlat22);
    u_xlat16_4.xyz = (-u_xlat2.xyz) * vec3(u_xlat21) + (-u_xlat0.xyz);
    u_xlat16_25 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_21 = max(u_xlat16_25, 0.00100000005);
    u_xlat16_25 = inversesqrt(u_xlat16_21);
    u_xlat16_4.xyz = vec3(u_xlat16_25) * u_xlat16_4.xyz;
    u_xlat16_25 = dot((-u_xlat0.xyz), u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_25 = min(max(u_xlat16_25, 0.0), 1.0);
#else
    u_xlat16_25 = clamp(u_xlat16_25, 0.0, 1.0);
#endif
    u_xlat16_21 = max(u_xlat16_25, 0.319999993);
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat16_25 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_15 = u_xlat16_25 * u_xlat16_25 + 1.5;
    u_xlat16_25 = u_xlat16_25 * u_xlat16_25;
    u_xlat16_21 = u_xlat16_21 * u_xlat16_15;
    u_xlat10_5.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_5.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_27 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_27 = inversesqrt(u_xlat16_27);
    u_xlat16_6.xyz = vec3(u_xlat16_27) * u_xlat16_6.xyz;
    u_xlat16_4.x = dot(u_xlat16_6.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_11 = dot(u_xlat16_6.xyz, (-u_xlat0.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_11 = min(max(u_xlat16_11, 0.0), 1.0);
#else
    u_xlat16_11 = clamp(u_xlat16_11, 0.0, 1.0);
#endif
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_4.x;
    u_xlat16_0 = u_xlat16_25 * u_xlat16_25 + -1.0;
    u_xlat16_0 = u_xlat16_4.x * u_xlat16_0 + 1.00001001;
    u_xlat16_0 = u_xlat16_0 * u_xlat16_21;
    u_xlat16_0 = u_xlat16_25 / u_xlat16_0;
    u_xlat16_0 = u_xlat16_0 + -9.99999975e-05;
    u_xlat16_4.x = max(u_xlat16_0, 0.0);
    u_xlat16_4.x = min(u_xlat16_4.x, 100.0);
    u_xlat16_4.xzw = u_xlat16_4.xxx * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat16_4.xzw = u_xlat3.xyz * u_xlat16_4.xzw;
    SV_Target0.xyz = vec3(u_xlat16_11) * u_xlat16_4.xzw;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  mediump vec3 lightDir_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_6).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_8;
  tmpvar_8 = -(_LightDir.xyz);
  lightDir_5 = tmpvar_8;
  tmpvar_4 = _LightColor.xyz;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraGBufferTexture0, tmpvar_6);
  gbuffer0_3 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_CameraGBufferTexture1, tmpvar_6);
  gbuffer1_2 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_CameraGBufferTexture2, tmpvar_6);
  gbuffer2_1 = tmpvar_11;
  mediump vec3 tmpvar_12;
  tmpvar_12 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize(((unity_CameraToWorld * tmpvar_7).xyz - _WorldSpaceCameraPos));
  mediump vec3 viewDir_14;
  viewDir_14 = -(tmpvar_13);
  mediump vec2 tmpvar_15;
  tmpvar_15.x = dot ((viewDir_14 - (2.0 * 
    (dot (tmpvar_12, viewDir_14) * tmpvar_12)
  )), lightDir_5);
  tmpvar_15.y = (1.0 - clamp (dot (tmpvar_12, viewDir_14), 0.0, 1.0));
  mediump float specular_16;
  mediump vec2 tmpvar_17;
  tmpvar_17.x = ((tmpvar_15 * tmpvar_15) * (tmpvar_15 * tmpvar_15)).x;
  tmpvar_17.y = (1.0 - gbuffer1_2.w);
  highp float tmpvar_18;
  tmpvar_18 = (texture2D (unity_NHxRoughness, tmpvar_17).w * 16.0);
  specular_16 = tmpvar_18;
  mediump vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = ((gbuffer0_3.xyz + (specular_16 * gbuffer1_2.xyz)) * (tmpvar_4 * clamp (
    dot (tmpvar_12, lightDir_5)
  , 0.0, 1.0)));
  gl_FragData[0] = tmpvar_19;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "UNITY_HDR_ON" }
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
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform highp sampler2D unity_NHxRoughness;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
lowp vec4 u_xlat10_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
lowp vec3 u_xlat10_2;
mediump vec3 u_xlat16_3;
mediump vec3 u_xlat16_4;
float u_xlat15;
mediump float u_xlat16_18;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat15 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat15 = _ZBufferParams.x * u_xlat15 + _ZBufferParams.y;
    u_xlat15 = float(1.0) / u_xlat15;
    u_xlat0.xyz = vec3(u_xlat15) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat0.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat15 = inversesqrt(u_xlat15);
    u_xlat0.xyz = vec3(u_xlat15) * u_xlat0.xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_3.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_18 = dot(u_xlat16_3.xyz, u_xlat16_3.xyz);
    u_xlat16_18 = inversesqrt(u_xlat16_18);
    u_xlat16_3.xyz = vec3(u_xlat16_18) * u_xlat16_3.xyz;
    u_xlat16_18 = dot((-u_xlat0.xyz), u_xlat16_3.xyz);
    u_xlat16_18 = u_xlat16_18 + u_xlat16_18;
    u_xlat16_4.xyz = u_xlat16_3.xyz * (-vec3(u_xlat16_18)) + (-u_xlat0.xyz);
    u_xlat16_3.x = dot(u_xlat16_3.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.x = min(max(u_xlat16_3.x, 0.0), 1.0);
#else
    u_xlat16_3.x = clamp(u_xlat16_3.x, 0.0, 1.0);
#endif
    u_xlat16_3.xyz = u_xlat16_3.xxx * _LightColor.xyz;
    u_xlat16_18 = dot(u_xlat16_4.xyz, (-_LightDir.xyz));
    u_xlat16_18 = u_xlat16_18 * u_xlat16_18;
    u_xlat16_4.x = u_xlat16_18 * u_xlat16_18;
    u_xlat10_0 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_4.y = (-u_xlat10_0.w) + 1.0;
    u_xlat15 = texture(unity_NHxRoughness, u_xlat16_4.xy).w;
    u_xlat15 = u_xlat15 * 16.0;
    u_xlat16_4.xyz = vec3(u_xlat15) * u_xlat10_0.xyz + u_xlat10_1.xyz;
    SV_Target0.xyz = u_xlat16_3.xyz * u_xlat16_4.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  mediump vec3 lightDir_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_6).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_8;
  tmpvar_8 = -(_LightDir.xyz);
  lightDir_5 = tmpvar_8;
  tmpvar_4 = _LightColor.xyz;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraGBufferTexture0, tmpvar_6);
  gbuffer0_3 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_CameraGBufferTexture1, tmpvar_6);
  gbuffer1_2 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_CameraGBufferTexture2, tmpvar_6);
  gbuffer2_1 = tmpvar_11;
  mediump vec3 tmpvar_12;
  tmpvar_12 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize(((unity_CameraToWorld * tmpvar_7).xyz - _WorldSpaceCameraPos));
  mediump vec3 viewDir_14;
  viewDir_14 = -(tmpvar_13);
  mediump float specularTerm_15;
  mediump vec3 tmpvar_16;
  mediump vec3 inVec_17;
  inVec_17 = (lightDir_5 + viewDir_14);
  tmpvar_16 = (inVec_17 * inversesqrt(max (0.001, 
    dot (inVec_17, inVec_17)
  )));
  mediump float tmpvar_18;
  tmpvar_18 = clamp (dot (tmpvar_12, tmpvar_16), 0.0, 1.0);
  mediump float tmpvar_19;
  tmpvar_19 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_20;
  tmpvar_20 = (tmpvar_19 * tmpvar_19);
  specularTerm_15 = ((tmpvar_20 / (
    (max (0.32, clamp (dot (lightDir_5, tmpvar_16), 0.0, 1.0)) * (1.5 + tmpvar_20))
   * 
    (((tmpvar_18 * tmpvar_18) * ((tmpvar_20 * tmpvar_20) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_21;
  tmpvar_21 = clamp (specularTerm_15, 0.0, 100.0);
  specularTerm_15 = tmpvar_21;
  mediump vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_21 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_12, lightDir_5), 0.0, 1.0));
  gl_FragData[0] = tmpvar_22;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  mediump vec3 lightDir_5;
  highp vec2 tmpvar_6;
  tmpvar_6 = (xlv_TEXCOORD0.xy / xlv_TEXCOORD0.w);
  highp vec4 tmpvar_7;
  tmpvar_7.w = 1.0;
  tmpvar_7.xyz = ((xlv_TEXCOORD1 * (_ProjectionParams.z / xlv_TEXCOORD1.z)) * (1.0/((
    (_ZBufferParams.x * texture2D (_CameraDepthTexture, tmpvar_6).x)
   + _ZBufferParams.y))));
  highp vec3 tmpvar_8;
  tmpvar_8 = -(_LightDir.xyz);
  lightDir_5 = tmpvar_8;
  tmpvar_4 = _LightColor.xyz;
  lowp vec4 tmpvar_9;
  tmpvar_9 = texture2D (_CameraGBufferTexture0, tmpvar_6);
  gbuffer0_3 = tmpvar_9;
  lowp vec4 tmpvar_10;
  tmpvar_10 = texture2D (_CameraGBufferTexture1, tmpvar_6);
  gbuffer1_2 = tmpvar_10;
  lowp vec4 tmpvar_11;
  tmpvar_11 = texture2D (_CameraGBufferTexture2, tmpvar_6);
  gbuffer2_1 = tmpvar_11;
  mediump vec3 tmpvar_12;
  tmpvar_12 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_13;
  tmpvar_13 = normalize(((unity_CameraToWorld * tmpvar_7).xyz - _WorldSpaceCameraPos));
  mediump vec3 viewDir_14;
  viewDir_14 = -(tmpvar_13);
  mediump float specularTerm_15;
  mediump vec3 tmpvar_16;
  mediump vec3 inVec_17;
  inVec_17 = (lightDir_5 + viewDir_14);
  tmpvar_16 = (inVec_17 * inversesqrt(max (0.001, 
    dot (inVec_17, inVec_17)
  )));
  mediump float tmpvar_18;
  tmpvar_18 = clamp (dot (tmpvar_12, tmpvar_16), 0.0, 1.0);
  mediump float tmpvar_19;
  tmpvar_19 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_20;
  tmpvar_20 = (tmpvar_19 * tmpvar_19);
  specularTerm_15 = ((tmpvar_20 / (
    (max (0.32, clamp (dot (lightDir_5, tmpvar_16), 0.0, 1.0)) * (1.5 + tmpvar_20))
   * 
    (((tmpvar_18 * tmpvar_18) * ((tmpvar_20 * tmpvar_20) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_21;
  tmpvar_21 = clamp (specularTerm_15, 0.0, 100.0);
  specularTerm_15 = tmpvar_21;
  mediump vec4 tmpvar_22;
  tmpvar_22.w = 1.0;
  tmpvar_22.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_21 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_12, lightDir_5), 0.0, 1.0));
  gl_FragData[0] = tmpvar_22;
}


#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "DIRECTIONAL" "UNITY_HDR_ON" }
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
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump float u_xlat16_0;
lowp vec3 u_xlat10_0;
vec2 u_xlat1;
mediump float u_xlat16_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
mediump vec3 u_xlat16_3;
mediump vec3 u_xlat16_4;
lowp vec3 u_xlat10_5;
mediump vec3 u_xlat16_8;
mediump float u_xlat16_13;
float u_xlat15;
mediump float u_xlat16_18;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat15 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat15 = _ZBufferParams.x * u_xlat15 + _ZBufferParams.y;
    u_xlat15 = float(1.0) / u_xlat15;
    u_xlat0.xyz = vec3(u_xlat15) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat0.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat15 = inversesqrt(u_xlat15);
    u_xlat16_3.xyz = (-u_xlat0.xyz) * vec3(u_xlat15) + (-_LightDir.xyz);
    u_xlat16_18 = dot(u_xlat16_3.xyz, u_xlat16_3.xyz);
    u_xlat16_0 = max(u_xlat16_18, 0.00100000005);
    u_xlat16_18 = inversesqrt(u_xlat16_0);
    u_xlat16_3.xyz = vec3(u_xlat16_18) * u_xlat16_3.xyz;
    u_xlat10_0.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_4.xyz = u_xlat10_0.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_18 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_18 = inversesqrt(u_xlat16_18);
    u_xlat16_4.xyz = vec3(u_xlat16_18) * u_xlat16_4.xyz;
    u_xlat16_18 = dot(u_xlat16_4.xyz, u_xlat16_3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_18 = min(max(u_xlat16_18, 0.0), 1.0);
#else
    u_xlat16_18 = clamp(u_xlat16_18, 0.0, 1.0);
#endif
    u_xlat16_3.x = dot((-_LightDir.xyz), u_xlat16_3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.x = min(max(u_xlat16_3.x, 0.0), 1.0);
#else
    u_xlat16_3.x = clamp(u_xlat16_3.x, 0.0, 1.0);
#endif
    u_xlat16_0 = max(u_xlat16_3.x, 0.319999993);
    u_xlat16_3.x = dot(u_xlat16_4.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.x = min(max(u_xlat16_3.x, 0.0), 1.0);
#else
    u_xlat16_3.x = clamp(u_xlat16_3.x, 0.0, 1.0);
#endif
    u_xlat16_8.x = u_xlat16_18 * u_xlat16_18;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_5.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_13 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_18 = u_xlat16_13 * u_xlat16_13;
    u_xlat16_1 = u_xlat16_13 * u_xlat16_13 + 1.5;
    u_xlat16_0 = u_xlat16_0 * u_xlat16_1;
    u_xlat16_1 = u_xlat16_18 * u_xlat16_18 + -1.0;
    u_xlat16_1 = u_xlat16_8.x * u_xlat16_1 + 1.00001001;
    u_xlat16_0 = u_xlat16_0 * u_xlat16_1;
    u_xlat16_0 = u_xlat16_18 / u_xlat16_0;
    u_xlat16_0 = u_xlat16_0 + -9.99999975e-05;
    u_xlat16_8.x = max(u_xlat16_0, 0.0);
    u_xlat16_8.x = min(u_xlat16_8.x, 100.0);
    u_xlat16_8.xyz = u_xlat16_8.xxx * u_xlat10_2.xyz + u_xlat10_5.xyz;
    u_xlat16_8.xyz = u_xlat16_8.xyz * _LightColor.xyz;
    SV_Target0.xyz = u_xlat16_3.xxx * u_xlat16_8.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "DIRECTIONAL" "UNITY_HDR_ON" }
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
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump float u_xlat16_0;
lowp vec3 u_xlat10_0;
vec2 u_xlat1;
mediump float u_xlat16_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
mediump vec3 u_xlat16_3;
mediump vec3 u_xlat16_4;
lowp vec3 u_xlat10_5;
mediump vec3 u_xlat16_8;
mediump float u_xlat16_13;
float u_xlat15;
mediump float u_xlat16_18;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat15 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat15 = _ZBufferParams.x * u_xlat15 + _ZBufferParams.y;
    u_xlat15 = float(1.0) / u_xlat15;
    u_xlat0.xyz = vec3(u_xlat15) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat0.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat15 = dot(u_xlat0.xyz, u_xlat0.xyz);
    u_xlat15 = inversesqrt(u_xlat15);
    u_xlat16_3.xyz = (-u_xlat0.xyz) * vec3(u_xlat15) + (-_LightDir.xyz);
    u_xlat16_18 = dot(u_xlat16_3.xyz, u_xlat16_3.xyz);
    u_xlat16_0 = max(u_xlat16_18, 0.00100000005);
    u_xlat16_18 = inversesqrt(u_xlat16_0);
    u_xlat16_3.xyz = vec3(u_xlat16_18) * u_xlat16_3.xyz;
    u_xlat10_0.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_4.xyz = u_xlat10_0.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_18 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_18 = inversesqrt(u_xlat16_18);
    u_xlat16_4.xyz = vec3(u_xlat16_18) * u_xlat16_4.xyz;
    u_xlat16_18 = dot(u_xlat16_4.xyz, u_xlat16_3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_18 = min(max(u_xlat16_18, 0.0), 1.0);
#else
    u_xlat16_18 = clamp(u_xlat16_18, 0.0, 1.0);
#endif
    u_xlat16_3.x = dot((-_LightDir.xyz), u_xlat16_3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.x = min(max(u_xlat16_3.x, 0.0), 1.0);
#else
    u_xlat16_3.x = clamp(u_xlat16_3.x, 0.0, 1.0);
#endif
    u_xlat16_0 = max(u_xlat16_3.x, 0.319999993);
    u_xlat16_3.x = dot(u_xlat16_4.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.x = min(max(u_xlat16_3.x, 0.0), 1.0);
#else
    u_xlat16_3.x = clamp(u_xlat16_3.x, 0.0, 1.0);
#endif
    u_xlat16_8.x = u_xlat16_18 * u_xlat16_18;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_5.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_13 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_18 = u_xlat16_13 * u_xlat16_13;
    u_xlat16_1 = u_xlat16_13 * u_xlat16_13 + 1.5;
    u_xlat16_0 = u_xlat16_0 * u_xlat16_1;
    u_xlat16_1 = u_xlat16_18 * u_xlat16_18 + -1.0;
    u_xlat16_1 = u_xlat16_8.x * u_xlat16_1 + 1.00001001;
    u_xlat16_0 = u_xlat16_0 * u_xlat16_1;
    u_xlat16_0 = u_xlat16_18 / u_xlat16_0;
    u_xlat16_0 = u_xlat16_0 + -9.99999975e-05;
    u_xlat16_8.x = max(u_xlat16_0, 0.0);
    u_xlat16_8.x = min(u_xlat16_8.x, 100.0);
    u_xlat16_8.xyz = u_xlat16_8.xxx * u_xlat10_2.xyz + u_xlat10_5.xyz;
    u_xlat16_8.xyz = u_xlat16_8.xyz * _LightColor.xyz;
    SV_Target0.xyz = u_xlat16_3.xxx * u_xlat16_8.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "SPOT" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_10 = (_LightPos.xyz - tmpvar_9);
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize(tmpvar_10);
  lightDir_6 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_9;
  highp vec4 tmpvar_13;
  tmpvar_13 = (unity_WorldToLight * tmpvar_12);
  highp vec4 tmpvar_14;
  tmpvar_14.zw = vec2(0.0, -8.0);
  tmpvar_14.xy = (tmpvar_13.xy / tmpvar_13.w);
  atten_5 = (texture2D (_LightTexture0, tmpvar_14.xy, -8.0).w * float((tmpvar_13.w < 0.0)));
  atten_5 = (atten_5 * texture2D (_LightTextureB0, vec2((dot (tmpvar_10, tmpvar_10) * _LightPos.w))).w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_17;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_20;
  viewDir_20 = -(tmpvar_19);
  mediump vec2 tmpvar_21;
  tmpvar_21.x = dot ((viewDir_20 - (2.0 * 
    (dot (tmpvar_18, viewDir_20) * tmpvar_18)
  )), lightDir_6);
  tmpvar_21.y = (1.0 - clamp (dot (tmpvar_18, viewDir_20), 0.0, 1.0));
  mediump float specular_22;
  mediump vec2 tmpvar_23;
  tmpvar_23.x = ((tmpvar_21 * tmpvar_21) * (tmpvar_21 * tmpvar_21)).x;
  tmpvar_23.y = (1.0 - gbuffer1_2.w);
  highp float tmpvar_24;
  tmpvar_24 = (texture2D (unity_NHxRoughness, tmpvar_23).w * 16.0);
  specular_22 = tmpvar_24;
  mediump vec4 tmpvar_25;
  tmpvar_25.w = 1.0;
  tmpvar_25.xyz = ((gbuffer0_3.xyz + (specular_22 * gbuffer1_2.xyz)) * (tmpvar_4 * clamp (
    dot (tmpvar_18, lightDir_6)
  , 0.0, 1.0)));
  gl_FragData[0] = tmpvar_25;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "SPOT" "UNITY_HDR_ON" }
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
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform highp sampler2D unity_NHxRoughness;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec3 u_xlat1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
lowp vec3 u_xlat10_3;
mediump vec3 u_xlat16_4;
mediump vec3 u_xlat16_5;
mediump vec3 u_xlat16_10;
float u_xlat12;
bool u_xlatb12;
float u_xlat13;
float u_xlat18;
float u_xlat19;
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
    u_xlat16_22 = dot((-u_xlat2.xyz), u_xlat16_4.xyz);
    u_xlat16_22 = u_xlat16_22 + u_xlat16_22;
    u_xlat16_5.xyz = u_xlat16_4.xyz * (-vec3(u_xlat16_22)) + (-u_xlat2.xyz);
    u_xlat2.xyz = (-u_xlat0.xyz) + _LightPos.xyz;
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat13 = inversesqrt(u_xlat18);
    u_xlat18 = u_xlat18 * _LightPos.w;
    u_xlat18 = texture(_LightTextureB0, vec2(u_xlat18)).w;
    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat2.xyz);
    u_xlat16_4.x = dot(u_xlat16_4.xyz, u_xlat2.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10.x = u_xlat16_22 * u_xlat16_22;
    u_xlat16_5.x = u_xlat16_10.x * u_xlat16_10.x;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_5.y = (-u_xlat10_2.w) + 1.0;
    u_xlat19 = texture(unity_NHxRoughness, u_xlat16_5.xy).w;
    u_xlat19 = u_xlat19 * 16.0;
    u_xlat16_10.xyz = vec3(u_xlat19) * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat1.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat0.xxx + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat0.zzz + u_xlat1.xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat0.xy = u_xlat0.xy / u_xlat0.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb12 = !!(u_xlat0.z<0.0);
#else
    u_xlatb12 = u_xlat0.z<0.0;
#endif
    u_xlat12 = u_xlatb12 ? 1.0 : float(0.0);
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.x = u_xlat12 * u_xlat0.x;
    u_xlat0.x = u_xlat18 * u_xlat0.x;
    u_xlat0.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat16_5.xyz = u_xlat16_4.xxx * u_xlat0.xyz;
    SV_Target0.xyz = u_xlat16_10.xyz * u_xlat16_5.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "SPOT" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_10 = (_LightPos.xyz - tmpvar_9);
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize(tmpvar_10);
  lightDir_6 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_9;
  highp vec4 tmpvar_13;
  tmpvar_13 = (unity_WorldToLight * tmpvar_12);
  highp vec4 tmpvar_14;
  tmpvar_14.zw = vec2(0.0, -8.0);
  tmpvar_14.xy = (tmpvar_13.xy / tmpvar_13.w);
  atten_5 = (texture2D (_LightTexture0, tmpvar_14.xy, -8.0).w * float((tmpvar_13.w < 0.0)));
  atten_5 = (atten_5 * texture2D (_LightTextureB0, vec2((dot (tmpvar_10, tmpvar_10) * _LightPos.w))).w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_17;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_20;
  viewDir_20 = -(tmpvar_19);
  mediump float specularTerm_21;
  mediump vec3 tmpvar_22;
  mediump vec3 inVec_23;
  inVec_23 = (lightDir_6 + viewDir_20);
  tmpvar_22 = (inVec_23 * inversesqrt(max (0.001, 
    dot (inVec_23, inVec_23)
  )));
  mediump float tmpvar_24;
  tmpvar_24 = clamp (dot (tmpvar_18, tmpvar_22), 0.0, 1.0);
  mediump float tmpvar_25;
  tmpvar_25 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_26;
  tmpvar_26 = (tmpvar_25 * tmpvar_25);
  specularTerm_21 = ((tmpvar_26 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_22), 0.0, 1.0)) * (1.5 + tmpvar_26))
   * 
    (((tmpvar_24 * tmpvar_24) * ((tmpvar_26 * tmpvar_26) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_27;
  tmpvar_27 = clamp (specularTerm_21, 0.0, 100.0);
  specularTerm_21 = tmpvar_27;
  mediump vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_27 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_18, lightDir_6), 0.0, 1.0));
  gl_FragData[0] = tmpvar_28;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "SPOT" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_10 = (_LightPos.xyz - tmpvar_9);
  highp vec3 tmpvar_11;
  tmpvar_11 = normalize(tmpvar_10);
  lightDir_6 = tmpvar_11;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_9;
  highp vec4 tmpvar_13;
  tmpvar_13 = (unity_WorldToLight * tmpvar_12);
  highp vec4 tmpvar_14;
  tmpvar_14.zw = vec2(0.0, -8.0);
  tmpvar_14.xy = (tmpvar_13.xy / tmpvar_13.w);
  atten_5 = (texture2D (_LightTexture0, tmpvar_14.xy, -8.0).w * float((tmpvar_13.w < 0.0)));
  atten_5 = (atten_5 * texture2D (_LightTextureB0, vec2((dot (tmpvar_10, tmpvar_10) * _LightPos.w))).w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_16;
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_17;
  mediump vec3 tmpvar_18;
  tmpvar_18 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_19;
  tmpvar_19 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_20;
  viewDir_20 = -(tmpvar_19);
  mediump float specularTerm_21;
  mediump vec3 tmpvar_22;
  mediump vec3 inVec_23;
  inVec_23 = (lightDir_6 + viewDir_20);
  tmpvar_22 = (inVec_23 * inversesqrt(max (0.001, 
    dot (inVec_23, inVec_23)
  )));
  mediump float tmpvar_24;
  tmpvar_24 = clamp (dot (tmpvar_18, tmpvar_22), 0.0, 1.0);
  mediump float tmpvar_25;
  tmpvar_25 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_26;
  tmpvar_26 = (tmpvar_25 * tmpvar_25);
  specularTerm_21 = ((tmpvar_26 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_22), 0.0, 1.0)) * (1.5 + tmpvar_26))
   * 
    (((tmpvar_24 * tmpvar_24) * ((tmpvar_26 * tmpvar_26) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_27;
  tmpvar_27 = clamp (specularTerm_21, 0.0, 100.0);
  specularTerm_21 = tmpvar_27;
  mediump vec4 tmpvar_28;
  tmpvar_28.w = 1.0;
  tmpvar_28.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_27 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_18, lightDir_6), 0.0, 1.0));
  gl_FragData[0] = tmpvar_28;
}


#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SPOT" "UNITY_HDR_ON" }
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
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec4 u_xlat16_4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_10;
float u_xlat12;
bool u_xlatb12;
float u_xlat13;
mediump float u_xlat16_16;
float u_xlat18;
mediump float u_xlat16_18;
float u_xlat19;
mediump float u_xlat16_20;
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
    u_xlat3.xyz = (-u_xlat0.xyz) + _LightPos.xyz;
    u_xlat13 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat19 = inversesqrt(u_xlat13);
    u_xlat13 = u_xlat13 * _LightPos.w;
    u_xlat13 = texture(_LightTextureB0, vec2(u_xlat13)).w;
    u_xlat3.xyz = vec3(u_xlat19) * u_xlat3.xyz;
    u_xlat16_4.xyz = (-u_xlat2.xyz) * vec3(u_xlat18) + u_xlat3.xyz;
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_18 = max(u_xlat16_22, 0.00100000005);
    u_xlat16_22 = inversesqrt(u_xlat16_18);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_5.xyz = vec3(u_xlat16_22) * u_xlat16_5.xyz;
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_22 = min(max(u_xlat16_22, 0.0), 1.0);
#else
    u_xlat16_22 = clamp(u_xlat16_22, 0.0, 1.0);
#endif
    u_xlat16_4.x = dot(u_xlat3.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10 = dot(u_xlat16_5.xyz, u_xlat3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_10 = min(max(u_xlat16_10, 0.0), 1.0);
#else
    u_xlat16_10 = clamp(u_xlat16_10, 0.0, 1.0);
#endif
    u_xlat16_18 = max(u_xlat16_4.x, 0.319999993);
    u_xlat16_4.x = u_xlat16_22 * u_xlat16_22;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyw = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_16 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_22 = u_xlat16_16 * u_xlat16_16;
    u_xlat16_20 = u_xlat16_16 * u_xlat16_16 + 1.5;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_20;
    u_xlat16_20 = u_xlat16_22 * u_xlat16_22 + -1.0;
    u_xlat16_20 = u_xlat16_4.x * u_xlat16_20 + 1.00001001;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_20;
    u_xlat16_18 = u_xlat16_22 / u_xlat16_18;
    u_xlat16_18 = u_xlat16_18 + -9.99999975e-05;
    u_xlat16_4.x = max(u_xlat16_18, 0.0);
    u_xlat16_4.x = min(u_xlat16_4.x, 100.0);
    u_xlat16_4.xzw = u_xlat16_4.xxx * u_xlat10_2.xyz + u_xlat10_1.xyw;
    u_xlat1.xyw = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat0.xyw = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat0.xxx + u_xlat1.xyw;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat0.xy = u_xlat0.xy / u_xlat0.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb12 = !!(u_xlat0.z<0.0);
#else
    u_xlatb12 = u_xlat0.z<0.0;
#endif
    u_xlat12 = u_xlatb12 ? 1.0 : float(0.0);
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.x = u_xlat12 * u_xlat0.x;
    u_xlat0.x = u_xlat13 * u_xlat0.x;
    u_xlat0.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat16_4.xzw = u_xlat0.xyz * u_xlat16_4.xzw;
    SV_Target0.xyz = vec3(u_xlat16_10) * u_xlat16_4.xzw;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SPOT" "UNITY_HDR_ON" }
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
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec4 u_xlat16_4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_10;
float u_xlat12;
bool u_xlatb12;
float u_xlat13;
mediump float u_xlat16_16;
float u_xlat18;
mediump float u_xlat16_18;
float u_xlat19;
mediump float u_xlat16_20;
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
    u_xlat3.xyz = (-u_xlat0.xyz) + _LightPos.xyz;
    u_xlat13 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat19 = inversesqrt(u_xlat13);
    u_xlat13 = u_xlat13 * _LightPos.w;
    u_xlat13 = texture(_LightTextureB0, vec2(u_xlat13)).w;
    u_xlat3.xyz = vec3(u_xlat19) * u_xlat3.xyz;
    u_xlat16_4.xyz = (-u_xlat2.xyz) * vec3(u_xlat18) + u_xlat3.xyz;
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_18 = max(u_xlat16_22, 0.00100000005);
    u_xlat16_22 = inversesqrt(u_xlat16_18);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_5.xyz = vec3(u_xlat16_22) * u_xlat16_5.xyz;
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_22 = min(max(u_xlat16_22, 0.0), 1.0);
#else
    u_xlat16_22 = clamp(u_xlat16_22, 0.0, 1.0);
#endif
    u_xlat16_4.x = dot(u_xlat3.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10 = dot(u_xlat16_5.xyz, u_xlat3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_10 = min(max(u_xlat16_10, 0.0), 1.0);
#else
    u_xlat16_10 = clamp(u_xlat16_10, 0.0, 1.0);
#endif
    u_xlat16_18 = max(u_xlat16_4.x, 0.319999993);
    u_xlat16_4.x = u_xlat16_22 * u_xlat16_22;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyw = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_16 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_22 = u_xlat16_16 * u_xlat16_16;
    u_xlat16_20 = u_xlat16_16 * u_xlat16_16 + 1.5;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_20;
    u_xlat16_20 = u_xlat16_22 * u_xlat16_22 + -1.0;
    u_xlat16_20 = u_xlat16_4.x * u_xlat16_20 + 1.00001001;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_20;
    u_xlat16_18 = u_xlat16_22 / u_xlat16_18;
    u_xlat16_18 = u_xlat16_18 + -9.99999975e-05;
    u_xlat16_4.x = max(u_xlat16_18, 0.0);
    u_xlat16_4.x = min(u_xlat16_4.x, 100.0);
    u_xlat16_4.xzw = u_xlat16_4.xxx * u_xlat10_2.xyz + u_xlat10_1.xyw;
    u_xlat1.xyw = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat0.xyw = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat0.xxx + u_xlat1.xyw;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat0.xy = u_xlat0.xy / u_xlat0.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb12 = !!(u_xlat0.z<0.0);
#else
    u_xlatb12 = u_xlat0.z<0.0;
#endif
    u_xlat12 = u_xlatb12 ? 1.0 : float(0.0);
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.x = u_xlat12 * u_xlat0.x;
    u_xlat0.x = u_xlat13 * u_xlat0.x;
    u_xlat0.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat16_4.xzw = u_xlat0.xyz * u_xlat16_4.xzw;
    SV_Target0.xyz = vec3(u_xlat16_10) * u_xlat16_4.xzw;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_10 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(normalize(tmpvar_10));
  lightDir_6 = tmpvar_11;
  atten_5 = texture2D (_LightTextureB0, vec2((dot (tmpvar_10, tmpvar_10) * _LightPos.w))).w;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_9;
  highp vec4 tmpvar_13;
  tmpvar_13.w = -8.0;
  tmpvar_13.xyz = (unity_WorldToLight * tmpvar_12).xyz;
  atten_5 = (atten_5 * textureCube (_LightTexture0, tmpvar_13.xyz, -8.0).w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_16;
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_19;
  viewDir_19 = -(tmpvar_18);
  mediump vec2 tmpvar_20;
  tmpvar_20.x = dot ((viewDir_19 - (2.0 * 
    (dot (tmpvar_17, viewDir_19) * tmpvar_17)
  )), lightDir_6);
  tmpvar_20.y = (1.0 - clamp (dot (tmpvar_17, viewDir_19), 0.0, 1.0));
  mediump float specular_21;
  mediump vec2 tmpvar_22;
  tmpvar_22.x = ((tmpvar_20 * tmpvar_20) * (tmpvar_20 * tmpvar_20)).x;
  tmpvar_22.y = (1.0 - gbuffer1_2.w);
  highp float tmpvar_23;
  tmpvar_23 = (texture2D (unity_NHxRoughness, tmpvar_22).w * 16.0);
  specular_21 = tmpvar_23;
  mediump vec4 tmpvar_24;
  tmpvar_24.w = 1.0;
  tmpvar_24.xyz = ((gbuffer0_3.xyz + (specular_21 * gbuffer1_2.xyz)) * (tmpvar_4 * clamp (
    dot (tmpvar_17, lightDir_6)
  , 0.0, 1.0)));
  gl_FragData[0] = tmpvar_24;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" "UNITY_HDR_ON" }
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
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform highp sampler2D unity_NHxRoughness;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec3 u_xlat1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
lowp vec3 u_xlat10_3;
mediump vec3 u_xlat16_4;
mediump vec3 u_xlat16_5;
mediump vec3 u_xlat16_10;
float u_xlat13;
float u_xlat18;
float u_xlat19;
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
    u_xlat16_22 = dot((-u_xlat2.xyz), u_xlat16_4.xyz);
    u_xlat16_22 = u_xlat16_22 + u_xlat16_22;
    u_xlat16_5.xyz = u_xlat16_4.xyz * (-vec3(u_xlat16_22)) + (-u_xlat2.xyz);
    u_xlat2.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat13 = inversesqrt(u_xlat18);
    u_xlat18 = u_xlat18 * _LightPos.w;
    u_xlat18 = texture(_LightTextureB0, vec2(u_xlat18)).w;
    u_xlat2.xyz = vec3(u_xlat13) * u_xlat2.xyz;
    u_xlat16_22 = dot(u_xlat16_5.xyz, (-u_xlat2.xyz));
    u_xlat16_4.x = dot(u_xlat16_4.xyz, (-u_xlat2.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10.x = u_xlat16_22 * u_xlat16_22;
    u_xlat16_5.x = u_xlat16_10.x * u_xlat16_10.x;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_5.y = (-u_xlat10_2.w) + 1.0;
    u_xlat19 = texture(unity_NHxRoughness, u_xlat16_5.xy).w;
    u_xlat19 = u_xlat19 * 16.0;
    u_xlat16_10.xyz = vec3(u_xlat19) * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat1.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat1.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat0.xxx + u_xlat1.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat0.zzz + u_xlat1.xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xyz, -8.0).w;
    u_xlat0.x = u_xlat0.x * u_xlat18;
    u_xlat0.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat16_5.xyz = u_xlat16_4.xxx * u_xlat0.xyz;
    SV_Target0.xyz = u_xlat16_10.xyz * u_xlat16_5.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT_COOKIE" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_10 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(normalize(tmpvar_10));
  lightDir_6 = tmpvar_11;
  atten_5 = texture2D (_LightTextureB0, vec2((dot (tmpvar_10, tmpvar_10) * _LightPos.w))).w;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_9;
  highp vec4 tmpvar_13;
  tmpvar_13.w = -8.0;
  tmpvar_13.xyz = (unity_WorldToLight * tmpvar_12).xyz;
  atten_5 = (atten_5 * textureCube (_LightTexture0, tmpvar_13.xyz, -8.0).w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_16;
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_19;
  viewDir_19 = -(tmpvar_18);
  mediump float specularTerm_20;
  mediump vec3 tmpvar_21;
  mediump vec3 inVec_22;
  inVec_22 = (lightDir_6 + viewDir_19);
  tmpvar_21 = (inVec_22 * inversesqrt(max (0.001, 
    dot (inVec_22, inVec_22)
  )));
  mediump float tmpvar_23;
  tmpvar_23 = clamp (dot (tmpvar_17, tmpvar_21), 0.0, 1.0);
  mediump float tmpvar_24;
  tmpvar_24 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_25;
  tmpvar_25 = (tmpvar_24 * tmpvar_24);
  specularTerm_20 = ((tmpvar_25 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_21), 0.0, 1.0)) * (1.5 + tmpvar_25))
   * 
    (((tmpvar_23 * tmpvar_23) * ((tmpvar_25 * tmpvar_25) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_26;
  tmpvar_26 = clamp (specularTerm_20, 0.0, 100.0);
  specularTerm_20 = tmpvar_26;
  mediump vec4 tmpvar_27;
  tmpvar_27.w = 1.0;
  tmpvar_27.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_26 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_17, lightDir_6), 0.0, 1.0));
  gl_FragData[0] = tmpvar_27;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT_COOKIE" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightPos;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_10 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_11;
  tmpvar_11 = -(normalize(tmpvar_10));
  lightDir_6 = tmpvar_11;
  atten_5 = texture2D (_LightTextureB0, vec2((dot (tmpvar_10, tmpvar_10) * _LightPos.w))).w;
  highp vec4 tmpvar_12;
  tmpvar_12.w = 1.0;
  tmpvar_12.xyz = tmpvar_9;
  highp vec4 tmpvar_13;
  tmpvar_13.w = -8.0;
  tmpvar_13.xyz = (unity_WorldToLight * tmpvar_12).xyz;
  atten_5 = (atten_5 * textureCube (_LightTexture0, tmpvar_13.xyz, -8.0).w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_15;
  lowp vec4 tmpvar_16;
  tmpvar_16 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_16;
  mediump vec3 tmpvar_17;
  tmpvar_17 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_18;
  tmpvar_18 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_19;
  viewDir_19 = -(tmpvar_18);
  mediump float specularTerm_20;
  mediump vec3 tmpvar_21;
  mediump vec3 inVec_22;
  inVec_22 = (lightDir_6 + viewDir_19);
  tmpvar_21 = (inVec_22 * inversesqrt(max (0.001, 
    dot (inVec_22, inVec_22)
  )));
  mediump float tmpvar_23;
  tmpvar_23 = clamp (dot (tmpvar_17, tmpvar_21), 0.0, 1.0);
  mediump float tmpvar_24;
  tmpvar_24 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_25;
  tmpvar_25 = (tmpvar_24 * tmpvar_24);
  specularTerm_20 = ((tmpvar_25 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_21), 0.0, 1.0)) * (1.5 + tmpvar_25))
   * 
    (((tmpvar_23 * tmpvar_23) * ((tmpvar_25 * tmpvar_25) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_26;
  tmpvar_26 = clamp (specularTerm_20, 0.0, 100.0);
  specularTerm_20 = tmpvar_26;
  mediump vec4 tmpvar_27;
  tmpvar_27.w = 1.0;
  tmpvar_27.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_26 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_17, lightDir_6), 0.0, 1.0));
  gl_FragData[0] = tmpvar_27;
}


#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT_COOKIE" "UNITY_HDR_ON" }
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
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec4 u_xlat16_4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_10;
float u_xlat13;
mediump float u_xlat16_16;
float u_xlat18;
mediump float u_xlat16_18;
float u_xlat19;
mediump float u_xlat16_20;
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
    u_xlat3.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat13 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat19 = inversesqrt(u_xlat13);
    u_xlat13 = u_xlat13 * _LightPos.w;
    u_xlat13 = texture(_LightTextureB0, vec2(u_xlat13)).w;
    u_xlat3.xyz = vec3(u_xlat19) * u_xlat3.xyz;
    u_xlat16_4.xyz = (-u_xlat2.xyz) * vec3(u_xlat18) + (-u_xlat3.xyz);
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_18 = max(u_xlat16_22, 0.00100000005);
    u_xlat16_22 = inversesqrt(u_xlat16_18);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_5.xyz = vec3(u_xlat16_22) * u_xlat16_5.xyz;
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_22 = min(max(u_xlat16_22, 0.0), 1.0);
#else
    u_xlat16_22 = clamp(u_xlat16_22, 0.0, 1.0);
#endif
    u_xlat16_4.x = dot((-u_xlat3.xyz), u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10 = dot(u_xlat16_5.xyz, (-u_xlat3.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_10 = min(max(u_xlat16_10, 0.0), 1.0);
#else
    u_xlat16_10 = clamp(u_xlat16_10, 0.0, 1.0);
#endif
    u_xlat16_18 = max(u_xlat16_4.x, 0.319999993);
    u_xlat16_4.x = u_xlat16_22 * u_xlat16_22;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyw = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_16 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_22 = u_xlat16_16 * u_xlat16_16;
    u_xlat16_20 = u_xlat16_16 * u_xlat16_16 + 1.5;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_20;
    u_xlat16_20 = u_xlat16_22 * u_xlat16_22 + -1.0;
    u_xlat16_20 = u_xlat16_4.x * u_xlat16_20 + 1.00001001;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_20;
    u_xlat16_18 = u_xlat16_22 / u_xlat16_18;
    u_xlat16_18 = u_xlat16_18 + -9.99999975e-05;
    u_xlat16_4.x = max(u_xlat16_18, 0.0);
    u_xlat16_4.x = min(u_xlat16_4.x, 100.0);
    u_xlat16_4.xzw = u_xlat16_4.xxx * u_xlat10_2.xyz + u_xlat10_1.xyw;
    u_xlat1.xyw = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat0.xxx + u_xlat1.xyw;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xyz, -8.0).w;
    u_xlat0.x = u_xlat0.x * u_xlat13;
    u_xlat0.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat16_4.xzw = u_xlat0.xyz * u_xlat16_4.xzw;
    SV_Target0.xyz = vec3(u_xlat16_10) * u_xlat16_4.xzw;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT_COOKIE" "UNITY_HDR_ON" }
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
uniform 	vec4 _LightPos;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec4 u_xlat16_4;
mediump vec3 u_xlat16_5;
mediump float u_xlat16_10;
float u_xlat13;
mediump float u_xlat16_16;
float u_xlat18;
mediump float u_xlat16_18;
float u_xlat19;
mediump float u_xlat16_20;
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
    u_xlat3.xyz = u_xlat0.xyz + (-_LightPos.xyz);
    u_xlat13 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat19 = inversesqrt(u_xlat13);
    u_xlat13 = u_xlat13 * _LightPos.w;
    u_xlat13 = texture(_LightTextureB0, vec2(u_xlat13)).w;
    u_xlat3.xyz = vec3(u_xlat19) * u_xlat3.xyz;
    u_xlat16_4.xyz = (-u_xlat2.xyz) * vec3(u_xlat18) + (-u_xlat3.xyz);
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_18 = max(u_xlat16_22, 0.00100000005);
    u_xlat16_22 = inversesqrt(u_xlat16_18);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_5.xyz = vec3(u_xlat16_22) * u_xlat16_5.xyz;
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_22 = min(max(u_xlat16_22, 0.0), 1.0);
#else
    u_xlat16_22 = clamp(u_xlat16_22, 0.0, 1.0);
#endif
    u_xlat16_4.x = dot((-u_xlat3.xyz), u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10 = dot(u_xlat16_5.xyz, (-u_xlat3.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_10 = min(max(u_xlat16_10, 0.0), 1.0);
#else
    u_xlat16_10 = clamp(u_xlat16_10, 0.0, 1.0);
#endif
    u_xlat16_18 = max(u_xlat16_4.x, 0.319999993);
    u_xlat16_4.x = u_xlat16_22 * u_xlat16_22;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyw = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_16 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_22 = u_xlat16_16 * u_xlat16_16;
    u_xlat16_20 = u_xlat16_16 * u_xlat16_16 + 1.5;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_20;
    u_xlat16_20 = u_xlat16_22 * u_xlat16_22 + -1.0;
    u_xlat16_20 = u_xlat16_4.x * u_xlat16_20 + 1.00001001;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_20;
    u_xlat16_18 = u_xlat16_22 / u_xlat16_18;
    u_xlat16_18 = u_xlat16_18 + -9.99999975e-05;
    u_xlat16_4.x = max(u_xlat16_18, 0.0);
    u_xlat16_4.x = min(u_xlat16_4.x, 100.0);
    u_xlat16_4.xzw = u_xlat16_4.xxx * u_xlat10_2.xyz + u_xlat10_1.xyw;
    u_xlat1.xyw = u_xlat0.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat0.xxx + u_xlat1.xyw;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xyz, -8.0).w;
    u_xlat0.x = u_xlat0.x * u_xlat13;
    u_xlat0.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat16_4.xzw = u_xlat0.xyz * u_xlat16_4.xzw;
    SV_Target0.xyz = vec3(u_xlat16_10) * u_xlat16_4.xzw;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_10 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = tmpvar_9;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(0.0, -8.0);
  tmpvar_12.xy = (unity_WorldToLight * tmpvar_11).xy;
  atten_5 = texture2D (_LightTexture0, tmpvar_12.xy, -8.0).w;
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_15;
  mediump vec3 tmpvar_16;
  tmpvar_16 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_17;
  tmpvar_17 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_18;
  viewDir_18 = -(tmpvar_17);
  mediump vec2 tmpvar_19;
  tmpvar_19.x = dot ((viewDir_18 - (2.0 * 
    (dot (tmpvar_16, viewDir_18) * tmpvar_16)
  )), lightDir_6);
  tmpvar_19.y = (1.0 - clamp (dot (tmpvar_16, viewDir_18), 0.0, 1.0));
  mediump float specular_20;
  mediump vec2 tmpvar_21;
  tmpvar_21.x = ((tmpvar_19 * tmpvar_19) * (tmpvar_19 * tmpvar_19)).x;
  tmpvar_21.y = (1.0 - gbuffer1_2.w);
  highp float tmpvar_22;
  tmpvar_22 = (texture2D (unity_NHxRoughness, tmpvar_21).w * 16.0);
  specular_20 = tmpvar_22;
  mediump vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = ((gbuffer0_3.xyz + (specular_20 * gbuffer1_2.xyz)) * (tmpvar_4 * clamp (
    dot (tmpvar_16, lightDir_6)
  , 0.0, 1.0)));
  gl_FragData[0] = tmpvar_23;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL_COOKIE" "UNITY_HDR_ON" }
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
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform highp sampler2D unity_NHxRoughness;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
lowp vec3 u_xlat10_3;
mediump vec3 u_xlat16_4;
mediump vec3 u_xlat16_5;
vec3 u_xlat6;
mediump vec3 u_xlat16_10;
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
    u_xlat16_22 = dot((-u_xlat2.xyz), u_xlat16_4.xyz);
    u_xlat16_22 = u_xlat16_22 + u_xlat16_22;
    u_xlat16_5.xyz = u_xlat16_4.xyz * (-vec3(u_xlat16_22)) + (-u_xlat2.xyz);
    u_xlat16_4.x = dot(u_xlat16_4.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10.x = dot(u_xlat16_5.xyz, (-_LightDir.xyz));
    u_xlat16_10.x = u_xlat16_10.x * u_xlat16_10.x;
    u_xlat16_5.x = u_xlat16_10.x * u_xlat16_10.x;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_5.y = (-u_xlat10_2.w) + 1.0;
    u_xlat18 = texture(unity_NHxRoughness, u_xlat16_5.xy).w;
    u_xlat18 = u_xlat18 * 16.0;
    u_xlat16_10.xyz = vec3(u_xlat18) * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat6.xz = u_xlat0.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat0.xx + u_xlat6.xz;
    u_xlat0.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat0.zz + u_xlat0.xy;
    u_xlat0.xy = u_xlat0.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat16_5.xyz = u_xlat16_4.xxx * u_xlat0.xyz;
    SV_Target0.xyz = u_xlat16_10.xyz * u_xlat16_5.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_10 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = tmpvar_9;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(0.0, -8.0);
  tmpvar_12.xy = (unity_WorldToLight * tmpvar_11).xy;
  atten_5 = texture2D (_LightTexture0, tmpvar_12.xy, -8.0).w;
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_15;
  mediump vec3 tmpvar_16;
  tmpvar_16 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_17;
  tmpvar_17 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_18;
  viewDir_18 = -(tmpvar_17);
  mediump float specularTerm_19;
  mediump vec3 tmpvar_20;
  mediump vec3 inVec_21;
  inVec_21 = (lightDir_6 + viewDir_18);
  tmpvar_20 = (inVec_21 * inversesqrt(max (0.001, 
    dot (inVec_21, inVec_21)
  )));
  mediump float tmpvar_22;
  tmpvar_22 = clamp (dot (tmpvar_16, tmpvar_20), 0.0, 1.0);
  mediump float tmpvar_23;
  tmpvar_23 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_24;
  tmpvar_24 = (tmpvar_23 * tmpvar_23);
  specularTerm_19 = ((tmpvar_24 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_20), 0.0, 1.0)) * (1.5 + tmpvar_24))
   * 
    (((tmpvar_22 * tmpvar_22) * ((tmpvar_24 * tmpvar_24) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_25;
  tmpvar_25 = clamp (specularTerm_19, 0.0, 100.0);
  specularTerm_19 = tmpvar_25;
  mediump vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_25 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_16, lightDir_6), 0.0, 1.0));
  gl_FragData[0] = tmpvar_26;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp vec4 _LightDir;
uniform highp vec4 _LightColor;
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_10 = -(_LightDir.xyz);
  lightDir_6 = tmpvar_10;
  highp vec4 tmpvar_11;
  tmpvar_11.w = 1.0;
  tmpvar_11.xyz = tmpvar_9;
  highp vec4 tmpvar_12;
  tmpvar_12.zw = vec2(0.0, -8.0);
  tmpvar_12.xy = (unity_WorldToLight * tmpvar_11).xy;
  atten_5 = texture2D (_LightTexture0, tmpvar_12.xy, -8.0).w;
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_13;
  lowp vec4 tmpvar_14;
  tmpvar_14 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_15;
  mediump vec3 tmpvar_16;
  tmpvar_16 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_17;
  tmpvar_17 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_18;
  viewDir_18 = -(tmpvar_17);
  mediump float specularTerm_19;
  mediump vec3 tmpvar_20;
  mediump vec3 inVec_21;
  inVec_21 = (lightDir_6 + viewDir_18);
  tmpvar_20 = (inVec_21 * inversesqrt(max (0.001, 
    dot (inVec_21, inVec_21)
  )));
  mediump float tmpvar_22;
  tmpvar_22 = clamp (dot (tmpvar_16, tmpvar_20), 0.0, 1.0);
  mediump float tmpvar_23;
  tmpvar_23 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_24;
  tmpvar_24 = (tmpvar_23 * tmpvar_23);
  specularTerm_19 = ((tmpvar_24 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_20), 0.0, 1.0)) * (1.5 + tmpvar_24))
   * 
    (((tmpvar_22 * tmpvar_22) * ((tmpvar_24 * tmpvar_24) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_25;
  tmpvar_25 = clamp (specularTerm_19, 0.0, 100.0);
  specularTerm_19 = tmpvar_25;
  mediump vec4 tmpvar_26;
  tmpvar_26.w = 1.0;
  tmpvar_26.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_25 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_16, lightDir_6), 0.0, 1.0));
  gl_FragData[0] = tmpvar_26;
}


#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" "UNITY_HDR_ON" }
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
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
mediump vec3 u_xlat16_3;
mediump vec3 u_xlat16_4;
vec3 u_xlat5;
mediump vec3 u_xlat16_8;
mediump float u_xlat16_13;
float u_xlat15;
mediump float u_xlat16_15;
mediump float u_xlat16_16;
mediump float u_xlat16_18;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat15 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat15 = _ZBufferParams.x * u_xlat15 + _ZBufferParams.y;
    u_xlat15 = float(1.0) / u_xlat15;
    u_xlat0.xyz = vec3(u_xlat15) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat15 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat15 = inversesqrt(u_xlat15);
    u_xlat16_3.xyz = (-u_xlat2.xyz) * vec3(u_xlat15) + (-_LightDir.xyz);
    u_xlat16_18 = dot(u_xlat16_3.xyz, u_xlat16_3.xyz);
    u_xlat16_15 = max(u_xlat16_18, 0.00100000005);
    u_xlat16_18 = inversesqrt(u_xlat16_15);
    u_xlat16_3.xyz = vec3(u_xlat16_18) * u_xlat16_3.xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_4.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_18 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_18 = inversesqrt(u_xlat16_18);
    u_xlat16_4.xyz = vec3(u_xlat16_18) * u_xlat16_4.xyz;
    u_xlat16_18 = dot(u_xlat16_4.xyz, u_xlat16_3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_18 = min(max(u_xlat16_18, 0.0), 1.0);
#else
    u_xlat16_18 = clamp(u_xlat16_18, 0.0, 1.0);
#endif
    u_xlat16_3.x = dot((-_LightDir.xyz), u_xlat16_3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.x = min(max(u_xlat16_3.x, 0.0), 1.0);
#else
    u_xlat16_3.x = clamp(u_xlat16_3.x, 0.0, 1.0);
#endif
    u_xlat16_15 = max(u_xlat16_3.x, 0.319999993);
    u_xlat16_3.x = dot(u_xlat16_4.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.x = min(max(u_xlat16_3.x, 0.0), 1.0);
#else
    u_xlat16_3.x = clamp(u_xlat16_3.x, 0.0, 1.0);
#endif
    u_xlat16_8.x = u_xlat16_18 * u_xlat16_18;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_13 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_18 = u_xlat16_13 * u_xlat16_13;
    u_xlat16_16 = u_xlat16_13 * u_xlat16_13 + 1.5;
    u_xlat16_15 = u_xlat16_15 * u_xlat16_16;
    u_xlat16_16 = u_xlat16_18 * u_xlat16_18 + -1.0;
    u_xlat16_16 = u_xlat16_8.x * u_xlat16_16 + 1.00001001;
    u_xlat16_15 = u_xlat16_15 * u_xlat16_16;
    u_xlat16_15 = u_xlat16_18 / u_xlat16_15;
    u_xlat16_15 = u_xlat16_15 + -9.99999975e-05;
    u_xlat16_8.x = max(u_xlat16_15, 0.0);
    u_xlat16_8.x = min(u_xlat16_8.x, 100.0);
    u_xlat16_8.xyz = u_xlat16_8.xxx * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat5.xz = u_xlat0.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat0.xx + u_xlat5.xz;
    u_xlat0.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat0.zz + u_xlat0.xy;
    u_xlat0.xy = u_xlat0.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat16_8.xyz = u_xlat0.xyz * u_xlat16_8.xyz;
    SV_Target0.xyz = u_xlat16_3.xxx * u_xlat16_8.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" "UNITY_HDR_ON" }
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
uniform 	vec4 _LightDir;
uniform 	vec4 _LightColor;
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec3 u_xlat2;
lowp vec4 u_xlat10_2;
mediump vec3 u_xlat16_3;
mediump vec3 u_xlat16_4;
vec3 u_xlat5;
mediump vec3 u_xlat16_8;
mediump float u_xlat16_13;
float u_xlat15;
mediump float u_xlat16_15;
mediump float u_xlat16_16;
mediump float u_xlat16_18;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat15 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat15 = _ZBufferParams.x * u_xlat15 + _ZBufferParams.y;
    u_xlat15 = float(1.0) / u_xlat15;
    u_xlat0.xyz = vec3(u_xlat15) * u_xlat0.xyz;
    u_xlat2.xyz = u_xlat0.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat0.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat0.xxx + u_xlat2.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat0.zzz + u_xlat0.xyw;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat2.xyz = u_xlat0.xyz + (-_WorldSpaceCameraPos.xyz);
    u_xlat15 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat15 = inversesqrt(u_xlat15);
    u_xlat16_3.xyz = (-u_xlat2.xyz) * vec3(u_xlat15) + (-_LightDir.xyz);
    u_xlat16_18 = dot(u_xlat16_3.xyz, u_xlat16_3.xyz);
    u_xlat16_15 = max(u_xlat16_18, 0.00100000005);
    u_xlat16_18 = inversesqrt(u_xlat16_15);
    u_xlat16_3.xyz = vec3(u_xlat16_18) * u_xlat16_3.xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_4.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_18 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_18 = inversesqrt(u_xlat16_18);
    u_xlat16_4.xyz = vec3(u_xlat16_18) * u_xlat16_4.xyz;
    u_xlat16_18 = dot(u_xlat16_4.xyz, u_xlat16_3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_18 = min(max(u_xlat16_18, 0.0), 1.0);
#else
    u_xlat16_18 = clamp(u_xlat16_18, 0.0, 1.0);
#endif
    u_xlat16_3.x = dot((-_LightDir.xyz), u_xlat16_3.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.x = min(max(u_xlat16_3.x, 0.0), 1.0);
#else
    u_xlat16_3.x = clamp(u_xlat16_3.x, 0.0, 1.0);
#endif
    u_xlat16_15 = max(u_xlat16_3.x, 0.319999993);
    u_xlat16_3.x = dot(u_xlat16_4.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_3.x = min(max(u_xlat16_3.x, 0.0), 1.0);
#else
    u_xlat16_3.x = clamp(u_xlat16_3.x, 0.0, 1.0);
#endif
    u_xlat16_8.x = u_xlat16_18 * u_xlat16_18;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_13 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_18 = u_xlat16_13 * u_xlat16_13;
    u_xlat16_16 = u_xlat16_13 * u_xlat16_13 + 1.5;
    u_xlat16_15 = u_xlat16_15 * u_xlat16_16;
    u_xlat16_16 = u_xlat16_18 * u_xlat16_18 + -1.0;
    u_xlat16_16 = u_xlat16_8.x * u_xlat16_16 + 1.00001001;
    u_xlat16_15 = u_xlat16_15 * u_xlat16_16;
    u_xlat16_15 = u_xlat16_18 / u_xlat16_15;
    u_xlat16_15 = u_xlat16_15 + -9.99999975e-05;
    u_xlat16_8.x = max(u_xlat16_15, 0.0);
    u_xlat16_8.x = min(u_xlat16_8.x, 100.0);
    u_xlat16_8.xyz = u_xlat16_8.xxx * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat5.xz = u_xlat0.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat0.xx + u_xlat5.xz;
    u_xlat0.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat0.zz + u_xlat0.xy;
    u_xlat0.xy = u_xlat0.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat16_8.xyz = u_xlat0.xyz * u_xlat16_8.xyz;
    SV_Target0.xyz = u_xlat16_3.xxx * u_xlat16_8.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "UNITY_HDR_ON" }
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (_LightPos.xyz - tmpvar_9);
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize(tmpvar_11);
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_9;
  highp vec4 tmpvar_14;
  tmpvar_14 = (unity_WorldToLight * tmpvar_13);
  highp vec4 tmpvar_15;
  tmpvar_15.zw = vec2(0.0, -8.0);
  tmpvar_15.xy = (tmpvar_14.xy / tmpvar_14.w);
  atten_5 = (texture2D (_LightTexture0, tmpvar_15.xy, -8.0).w * float((tmpvar_14.w < 0.0)));
  atten_5 = (atten_5 * texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w))).w);
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  mediump float shadowAttenuation_18;
  shadowAttenuation_18 = 1.0;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = tmpvar_9;
  highp vec4 tmpvar_20;
  tmpvar_20 = (unity_WorldToShadow[0] * tmpvar_19);
  lowp float tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22 = texture2DProj (_ShadowMapTexture, tmpvar_20);
  mediump float tmpvar_23;
  if ((tmpvar_22.x < (tmpvar_20.z / tmpvar_20.w))) {
    tmpvar_23 = _LightShadowData.x;
  } else {
    tmpvar_23 = 1.0;
  };
  tmpvar_21 = tmpvar_23;
  shadowAttenuation_18 = tmpvar_21;
  mediump float tmpvar_24;
  tmpvar_24 = clamp ((shadowAttenuation_18 + tmpvar_16), 0.0, 1.0);
  atten_5 = (atten_5 * tmpvar_24);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_27;
  mediump vec3 tmpvar_28;
  tmpvar_28 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_29;
  tmpvar_29 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_30;
  viewDir_30 = -(tmpvar_29);
  mediump vec2 tmpvar_31;
  tmpvar_31.x = dot ((viewDir_30 - (2.0 * 
    (dot (tmpvar_28, viewDir_30) * tmpvar_28)
  )), lightDir_6);
  tmpvar_31.y = (1.0 - clamp (dot (tmpvar_28, viewDir_30), 0.0, 1.0));
  mediump float specular_32;
  mediump vec2 tmpvar_33;
  tmpvar_33.x = ((tmpvar_31 * tmpvar_31) * (tmpvar_31 * tmpvar_31)).x;
  tmpvar_33.y = (1.0 - gbuffer1_2.w);
  highp float tmpvar_34;
  tmpvar_34 = (texture2D (unity_NHxRoughness, tmpvar_33).w * 16.0);
  specular_32 = tmpvar_34;
  mediump vec4 tmpvar_35;
  tmpvar_35.w = 1.0;
  tmpvar_35.xyz = ((gbuffer0_3.xyz + (specular_32 * gbuffer1_2.xyz)) * (tmpvar_4 * clamp (
    dot (tmpvar_28, lightDir_6)
  , 0.0, 1.0)));
  gl_FragData[0] = tmpvar_35;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "UNITY_HDR_ON" }
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform highp sampler2D unity_NHxRoughness;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
mediump float u_xlat16_0;
lowp vec4 u_xlat10_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
vec4 u_xlat3;
mediump vec3 u_xlat16_4;
lowp vec3 u_xlat10_5;
mediump vec3 u_xlat16_6;
vec3 u_xlat7;
lowp float u_xlat10_7;
float u_xlat14;
bool u_xlatb14;
float u_xlat15;
float u_xlat21;
float u_xlat22;
mediump float u_xlat16_25;
void main()
{
    u_xlat16_0 = (-_LightShadowData.x) + 1.0;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat15 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat15 = _ZBufferParams.x * u_xlat15 + _ZBufferParams.y;
    u_xlat15 = float(1.0) / u_xlat15;
    u_xlat2.xyz = u_xlat7.xyz * vec3(u_xlat15);
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3 = u_xlat2.yyyy * hlslcc_mtx4x4unity_WorldToShadow[1];
    u_xlat3 = hlslcc_mtx4x4unity_WorldToShadow[0] * u_xlat2.xxxx + u_xlat3;
    u_xlat3 = hlslcc_mtx4x4unity_WorldToShadow[2] * u_xlat2.wwww + u_xlat3;
    u_xlat3 = u_xlat3 + hlslcc_mtx4x4unity_WorldToShadow[3];
    u_xlat3.xyz = u_xlat3.xyz / u_xlat3.www;
    vec3 txVec0 = vec3(u_xlat3.xy,u_xlat3.z);
    u_xlat10_7 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_0 = u_xlat10_7 * u_xlat16_0 + _LightShadowData.x;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat7.x = (-u_xlat7.z) * u_xlat15 + u_xlat7.x;
    u_xlat7.x = unity_ShadowFadeCenterAndType.w * u_xlat7.x + u_xlat2.z;
    u_xlat7.x = u_xlat7.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat7.x = min(max(u_xlat7.x, 0.0), 1.0);
#else
    u_xlat7.x = clamp(u_xlat7.x, 0.0, 1.0);
#endif
    u_xlat16_4.x = u_xlat7.x + u_xlat16_0;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat0.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat2.xxx + u_xlat0.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat2.www + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat0.xy = u_xlat0.xy / u_xlat0.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb14 = !!(u_xlat0.z<0.0);
#else
    u_xlatb14 = u_xlat0.z<0.0;
#endif
    u_xlat14 = u_xlatb14 ? 1.0 : float(0.0);
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.x = u_xlat14 * u_xlat0.x;
    u_xlat7.xyz = (-u_xlat2.xyw) + _LightPos.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat15 = dot(u_xlat7.xyz, u_xlat7.xyz);
    u_xlat22 = u_xlat15 * _LightPos.w;
    u_xlat15 = inversesqrt(u_xlat15);
    u_xlat7.xyz = u_xlat7.xyz * vec3(u_xlat15);
    u_xlat15 = texture(_LightTextureB0, vec2(u_xlat22)).w;
    u_xlat0.x = u_xlat0.x * u_xlat15;
    u_xlat0.x = u_xlat16_4.x * u_xlat0.x;
    u_xlat3.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat10_5.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_4.xyz = u_xlat10_5.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_25 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_25 = inversesqrt(u_xlat16_25);
    u_xlat16_4.xyz = vec3(u_xlat16_25) * u_xlat16_4.xyz;
    u_xlat16_25 = dot(u_xlat16_4.xyz, u_xlat7.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_25 = min(max(u_xlat16_25, 0.0), 1.0);
#else
    u_xlat16_25 = clamp(u_xlat16_25, 0.0, 1.0);
#endif
    u_xlat16_6.xyz = u_xlat3.xyz * vec3(u_xlat16_25);
    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat2.xyz = u_xlat0.xxx * u_xlat2.xyz;
    u_xlat16_25 = dot((-u_xlat2.xyz), u_xlat16_4.xyz);
    u_xlat16_25 = u_xlat16_25 + u_xlat16_25;
    u_xlat16_4.xyz = u_xlat16_4.xyz * (-vec3(u_xlat16_25)) + (-u_xlat2.xyz);
    u_xlat16_4.x = dot(u_xlat16_4.xyz, u_xlat7.xyz);
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_4.x;
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_4.x;
    u_xlat10_0 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_4.y = (-u_xlat10_0.w) + 1.0;
    u_xlat21 = texture(unity_NHxRoughness, u_xlat16_4.xy).w;
    u_xlat21 = u_xlat21 * 16.0;
    u_xlat16_4.xyz = vec3(u_xlat21) * u_xlat10_0.xyz + u_xlat10_1.xyz;
    SV_Target0.xyz = u_xlat16_6.xyz * u_xlat16_4.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "UNITY_HDR_ON" }
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (_LightPos.xyz - tmpvar_9);
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize(tmpvar_11);
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_9;
  highp vec4 tmpvar_14;
  tmpvar_14 = (unity_WorldToLight * tmpvar_13);
  highp vec4 tmpvar_15;
  tmpvar_15.zw = vec2(0.0, -8.0);
  tmpvar_15.xy = (tmpvar_14.xy / tmpvar_14.w);
  atten_5 = (texture2D (_LightTexture0, tmpvar_15.xy, -8.0).w * float((tmpvar_14.w < 0.0)));
  atten_5 = (atten_5 * texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w))).w);
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  mediump float shadowAttenuation_18;
  shadowAttenuation_18 = 1.0;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = tmpvar_9;
  highp vec4 tmpvar_20;
  tmpvar_20 = (unity_WorldToShadow[0] * tmpvar_19);
  lowp float tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22 = texture2DProj (_ShadowMapTexture, tmpvar_20);
  mediump float tmpvar_23;
  if ((tmpvar_22.x < (tmpvar_20.z / tmpvar_20.w))) {
    tmpvar_23 = _LightShadowData.x;
  } else {
    tmpvar_23 = 1.0;
  };
  tmpvar_21 = tmpvar_23;
  shadowAttenuation_18 = tmpvar_21;
  mediump float tmpvar_24;
  tmpvar_24 = clamp ((shadowAttenuation_18 + tmpvar_16), 0.0, 1.0);
  atten_5 = (atten_5 * tmpvar_24);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_27;
  mediump vec3 tmpvar_28;
  tmpvar_28 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_29;
  tmpvar_29 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_30;
  viewDir_30 = -(tmpvar_29);
  mediump float specularTerm_31;
  mediump vec3 tmpvar_32;
  mediump vec3 inVec_33;
  inVec_33 = (lightDir_6 + viewDir_30);
  tmpvar_32 = (inVec_33 * inversesqrt(max (0.001, 
    dot (inVec_33, inVec_33)
  )));
  mediump float tmpvar_34;
  tmpvar_34 = clamp (dot (tmpvar_28, tmpvar_32), 0.0, 1.0);
  mediump float tmpvar_35;
  tmpvar_35 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_36;
  tmpvar_36 = (tmpvar_35 * tmpvar_35);
  specularTerm_31 = ((tmpvar_36 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_32), 0.0, 1.0)) * (1.5 + tmpvar_36))
   * 
    (((tmpvar_34 * tmpvar_34) * ((tmpvar_36 * tmpvar_36) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_37;
  tmpvar_37 = clamp (specularTerm_31, 0.0, 100.0);
  specularTerm_31 = tmpvar_37;
  mediump vec4 tmpvar_38;
  tmpvar_38.w = 1.0;
  tmpvar_38.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_37 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_28, lightDir_6), 0.0, 1.0));
  gl_FragData[0] = tmpvar_38;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "UNITY_HDR_ON" }
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (_LightPos.xyz - tmpvar_9);
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize(tmpvar_11);
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_9;
  highp vec4 tmpvar_14;
  tmpvar_14 = (unity_WorldToLight * tmpvar_13);
  highp vec4 tmpvar_15;
  tmpvar_15.zw = vec2(0.0, -8.0);
  tmpvar_15.xy = (tmpvar_14.xy / tmpvar_14.w);
  atten_5 = (texture2D (_LightTexture0, tmpvar_15.xy, -8.0).w * float((tmpvar_14.w < 0.0)));
  atten_5 = (atten_5 * texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w))).w);
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  mediump float shadowAttenuation_18;
  shadowAttenuation_18 = 1.0;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = tmpvar_9;
  highp vec4 tmpvar_20;
  tmpvar_20 = (unity_WorldToShadow[0] * tmpvar_19);
  lowp float tmpvar_21;
  highp vec4 tmpvar_22;
  tmpvar_22 = texture2DProj (_ShadowMapTexture, tmpvar_20);
  mediump float tmpvar_23;
  if ((tmpvar_22.x < (tmpvar_20.z / tmpvar_20.w))) {
    tmpvar_23 = _LightShadowData.x;
  } else {
    tmpvar_23 = 1.0;
  };
  tmpvar_21 = tmpvar_23;
  shadowAttenuation_18 = tmpvar_21;
  mediump float tmpvar_24;
  tmpvar_24 = clamp ((shadowAttenuation_18 + tmpvar_16), 0.0, 1.0);
  atten_5 = (atten_5 * tmpvar_24);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_27;
  mediump vec3 tmpvar_28;
  tmpvar_28 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_29;
  tmpvar_29 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_30;
  viewDir_30 = -(tmpvar_29);
  mediump float specularTerm_31;
  mediump vec3 tmpvar_32;
  mediump vec3 inVec_33;
  inVec_33 = (lightDir_6 + viewDir_30);
  tmpvar_32 = (inVec_33 * inversesqrt(max (0.001, 
    dot (inVec_33, inVec_33)
  )));
  mediump float tmpvar_34;
  tmpvar_34 = clamp (dot (tmpvar_28, tmpvar_32), 0.0, 1.0);
  mediump float tmpvar_35;
  tmpvar_35 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_36;
  tmpvar_36 = (tmpvar_35 * tmpvar_35);
  specularTerm_31 = ((tmpvar_36 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_32), 0.0, 1.0)) * (1.5 + tmpvar_36))
   * 
    (((tmpvar_34 * tmpvar_34) * ((tmpvar_36 * tmpvar_36) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_37;
  tmpvar_37 = clamp (specularTerm_31, 0.0, 100.0);
  specularTerm_31 = tmpvar_37;
  mediump vec4 tmpvar_38;
  tmpvar_38.w = 1.0;
  tmpvar_38.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_37 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_28, lightDir_6), 0.0, 1.0));
  gl_FragData[0] = tmpvar_38;
}


#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "UNITY_HDR_ON" }
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
mediump float u_xlat16_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec4 u_xlat3;
mediump vec4 u_xlat16_4;
lowp vec3 u_xlat10_5;
mediump vec3 u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_7;
lowp float u_xlat10_7;
mediump float u_xlat16_11;
float u_xlat14;
bool u_xlatb14;
float u_xlat15;
mediump float u_xlat16_15;
float u_xlat22;
mediump float u_xlat16_25;
mediump float u_xlat16_27;
void main()
{
    u_xlat16_0 = (-_LightShadowData.x) + 1.0;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat15 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat15 = _ZBufferParams.x * u_xlat15 + _ZBufferParams.y;
    u_xlat15 = float(1.0) / u_xlat15;
    u_xlat2.xyz = u_xlat7.xyz * vec3(u_xlat15);
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3 = u_xlat2.yyyy * hlslcc_mtx4x4unity_WorldToShadow[1];
    u_xlat3 = hlslcc_mtx4x4unity_WorldToShadow[0] * u_xlat2.xxxx + u_xlat3;
    u_xlat3 = hlslcc_mtx4x4unity_WorldToShadow[2] * u_xlat2.wwww + u_xlat3;
    u_xlat3 = u_xlat3 + hlslcc_mtx4x4unity_WorldToShadow[3];
    u_xlat3.xyz = u_xlat3.xyz / u_xlat3.www;
    vec3 txVec0 = vec3(u_xlat3.xy,u_xlat3.z);
    u_xlat10_7 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_0 = u_xlat10_7 * u_xlat16_0 + _LightShadowData.x;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat7.x = (-u_xlat7.z) * u_xlat15 + u_xlat7.x;
    u_xlat7.x = unity_ShadowFadeCenterAndType.w * u_xlat7.x + u_xlat2.z;
    u_xlat7.x = u_xlat7.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat7.x = min(max(u_xlat7.x, 0.0), 1.0);
#else
    u_xlat7.x = clamp(u_xlat7.x, 0.0, 1.0);
#endif
    u_xlat16_4.x = u_xlat7.x + u_xlat16_0;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat0.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat2.xxx + u_xlat0.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat2.www + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat0.xy = u_xlat0.xy / u_xlat0.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb14 = !!(u_xlat0.z<0.0);
#else
    u_xlatb14 = u_xlat0.z<0.0;
#endif
    u_xlat14 = u_xlatb14 ? 1.0 : float(0.0);
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.x = u_xlat14 * u_xlat0.x;
    u_xlat7.xyz = (-u_xlat2.xyw) + _LightPos.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat15 = dot(u_xlat7.xyz, u_xlat7.xyz);
    u_xlat22 = u_xlat15 * _LightPos.w;
    u_xlat15 = inversesqrt(u_xlat15);
    u_xlat7.xyz = u_xlat7.xyz * vec3(u_xlat15);
    u_xlat15 = texture(_LightTextureB0, vec2(u_xlat22)).w;
    u_xlat0.x = u_xlat0.x * u_xlat15;
    u_xlat0.x = u_xlat16_4.x * u_xlat0.x;
    u_xlat3.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat16_4.xyz = (-u_xlat2.xyz) * u_xlat0.xxx + u_xlat7.xyz;
    u_xlat16_25 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_0 = max(u_xlat16_25, 0.00100000005);
    u_xlat16_25 = inversesqrt(u_xlat16_0);
    u_xlat16_4.xyz = vec3(u_xlat16_25) * u_xlat16_4.xyz;
    u_xlat16_25 = dot(u_xlat7.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_25 = min(max(u_xlat16_25, 0.0), 1.0);
#else
    u_xlat16_25 = clamp(u_xlat16_25, 0.0, 1.0);
#endif
    u_xlat16_0 = max(u_xlat16_25, 0.319999993);
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat16_25 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_15 = u_xlat16_25 * u_xlat16_25 + 1.5;
    u_xlat16_25 = u_xlat16_25 * u_xlat16_25;
    u_xlat16_0 = u_xlat16_0 * u_xlat16_15;
    u_xlat10_5.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_5.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_27 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_27 = inversesqrt(u_xlat16_27);
    u_xlat16_6.xyz = vec3(u_xlat16_27) * u_xlat16_6.xyz;
    u_xlat16_4.x = dot(u_xlat16_6.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_11 = dot(u_xlat16_6.xyz, u_xlat7.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_11 = min(max(u_xlat16_11, 0.0), 1.0);
#else
    u_xlat16_11 = clamp(u_xlat16_11, 0.0, 1.0);
#endif
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_4.x;
    u_xlat16_7 = u_xlat16_25 * u_xlat16_25 + -1.0;
    u_xlat16_7 = u_xlat16_4.x * u_xlat16_7 + 1.00001001;
    u_xlat16_0 = u_xlat16_7 * u_xlat16_0;
    u_xlat16_0 = u_xlat16_25 / u_xlat16_0;
    u_xlat16_0 = u_xlat16_0 + -9.99999975e-05;
    u_xlat16_4.x = max(u_xlat16_0, 0.0);
    u_xlat16_4.x = min(u_xlat16_4.x, 100.0);
    u_xlat16_4.xzw = u_xlat16_4.xxx * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat16_4.xzw = u_xlat3.xyz * u_xlat16_4.xzw;
    SV_Target0.xyz = vec3(u_xlat16_11) * u_xlat16_4.xzw;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "UNITY_HDR_ON" }
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
mediump float u_xlat16_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec4 u_xlat3;
mediump vec4 u_xlat16_4;
lowp vec3 u_xlat10_5;
mediump vec3 u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_7;
lowp float u_xlat10_7;
mediump float u_xlat16_11;
float u_xlat14;
bool u_xlatb14;
float u_xlat15;
mediump float u_xlat16_15;
float u_xlat22;
mediump float u_xlat16_25;
mediump float u_xlat16_27;
void main()
{
    u_xlat16_0 = (-_LightShadowData.x) + 1.0;
    u_xlat7.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat7.xyz = u_xlat7.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat15 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat15 = _ZBufferParams.x * u_xlat15 + _ZBufferParams.y;
    u_xlat15 = float(1.0) / u_xlat15;
    u_xlat2.xyz = u_xlat7.xyz * vec3(u_xlat15);
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3 = u_xlat2.yyyy * hlslcc_mtx4x4unity_WorldToShadow[1];
    u_xlat3 = hlslcc_mtx4x4unity_WorldToShadow[0] * u_xlat2.xxxx + u_xlat3;
    u_xlat3 = hlslcc_mtx4x4unity_WorldToShadow[2] * u_xlat2.wwww + u_xlat3;
    u_xlat3 = u_xlat3 + hlslcc_mtx4x4unity_WorldToShadow[3];
    u_xlat3.xyz = u_xlat3.xyz / u_xlat3.www;
    vec3 txVec0 = vec3(u_xlat3.xy,u_xlat3.z);
    u_xlat10_7 = textureLod(hlslcc_zcmp_ShadowMapTexture, txVec0, 0.0);
    u_xlat16_0 = u_xlat10_7 * u_xlat16_0 + _LightShadowData.x;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat7.x = sqrt(u_xlat7.x);
    u_xlat7.x = (-u_xlat7.z) * u_xlat15 + u_xlat7.x;
    u_xlat7.x = unity_ShadowFadeCenterAndType.w * u_xlat7.x + u_xlat2.z;
    u_xlat7.x = u_xlat7.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat7.x = min(max(u_xlat7.x, 0.0), 1.0);
#else
    u_xlat7.x = clamp(u_xlat7.x, 0.0, 1.0);
#endif
    u_xlat16_4.x = u_xlat7.x + u_xlat16_0;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat0.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat2.xxx + u_xlat0.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat2.www + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat0.xy = u_xlat0.xy / u_xlat0.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb14 = !!(u_xlat0.z<0.0);
#else
    u_xlatb14 = u_xlat0.z<0.0;
#endif
    u_xlat14 = u_xlatb14 ? 1.0 : float(0.0);
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.x = u_xlat14 * u_xlat0.x;
    u_xlat7.xyz = (-u_xlat2.xyw) + _LightPos.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat15 = dot(u_xlat7.xyz, u_xlat7.xyz);
    u_xlat22 = u_xlat15 * _LightPos.w;
    u_xlat15 = inversesqrt(u_xlat15);
    u_xlat7.xyz = u_xlat7.xyz * vec3(u_xlat15);
    u_xlat15 = texture(_LightTextureB0, vec2(u_xlat22)).w;
    u_xlat0.x = u_xlat0.x * u_xlat15;
    u_xlat0.x = u_xlat16_4.x * u_xlat0.x;
    u_xlat3.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat16_4.xyz = (-u_xlat2.xyz) * u_xlat0.xxx + u_xlat7.xyz;
    u_xlat16_25 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_0 = max(u_xlat16_25, 0.00100000005);
    u_xlat16_25 = inversesqrt(u_xlat16_0);
    u_xlat16_4.xyz = vec3(u_xlat16_25) * u_xlat16_4.xyz;
    u_xlat16_25 = dot(u_xlat7.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_25 = min(max(u_xlat16_25, 0.0), 1.0);
#else
    u_xlat16_25 = clamp(u_xlat16_25, 0.0, 1.0);
#endif
    u_xlat16_0 = max(u_xlat16_25, 0.319999993);
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat16_25 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_15 = u_xlat16_25 * u_xlat16_25 + 1.5;
    u_xlat16_25 = u_xlat16_25 * u_xlat16_25;
    u_xlat16_0 = u_xlat16_0 * u_xlat16_15;
    u_xlat10_5.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_5.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_27 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_27 = inversesqrt(u_xlat16_27);
    u_xlat16_6.xyz = vec3(u_xlat16_27) * u_xlat16_6.xyz;
    u_xlat16_4.x = dot(u_xlat16_6.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_11 = dot(u_xlat16_6.xyz, u_xlat7.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_11 = min(max(u_xlat16_11, 0.0), 1.0);
#else
    u_xlat16_11 = clamp(u_xlat16_11, 0.0, 1.0);
#endif
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_4.x;
    u_xlat16_7 = u_xlat16_25 * u_xlat16_25 + -1.0;
    u_xlat16_7 = u_xlat16_4.x * u_xlat16_7 + 1.00001001;
    u_xlat16_0 = u_xlat16_7 * u_xlat16_0;
    u_xlat16_0 = u_xlat16_25 / u_xlat16_0;
    u_xlat16_0 = u_xlat16_0 + -9.99999975e-05;
    u_xlat16_4.x = max(u_xlat16_0, 0.0);
    u_xlat16_4.x = min(u_xlat16_4.x, 100.0);
    u_xlat16_4.xzw = u_xlat16_4.xxx * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat16_4.xzw = u_xlat3.xyz * u_xlat16_4.xzw;
    SV_Target0.xyz = vec3(u_xlat16_11) * u_xlat16_4.xzw;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (_LightPos.xyz - tmpvar_9);
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize(tmpvar_11);
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_9;
  highp vec4 tmpvar_14;
  tmpvar_14 = (unity_WorldToLight * tmpvar_13);
  highp vec4 tmpvar_15;
  tmpvar_15.zw = vec2(0.0, -8.0);
  tmpvar_15.xy = (tmpvar_14.xy / tmpvar_14.w);
  atten_5 = (texture2D (_LightTexture0, tmpvar_15.xy, -8.0).w * float((tmpvar_14.w < 0.0)));
  atten_5 = (atten_5 * texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w))).w);
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  mediump float shadowAttenuation_18;
  shadowAttenuation_18 = 1.0;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = tmpvar_9;
  highp vec4 tmpvar_20;
  tmpvar_20 = (unity_WorldToShadow[0] * tmpvar_19);
  lowp float tmpvar_21;
  highp vec4 shadowVals_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (tmpvar_20.xyz / tmpvar_20.w);
  shadowVals_22.x = texture2D (_ShadowMapTexture, (tmpvar_23.xy + _ShadowOffsets[0].xy)).x;
  shadowVals_22.y = texture2D (_ShadowMapTexture, (tmpvar_23.xy + _ShadowOffsets[1].xy)).x;
  shadowVals_22.z = texture2D (_ShadowMapTexture, (tmpvar_23.xy + _ShadowOffsets[2].xy)).x;
  shadowVals_22.w = texture2D (_ShadowMapTexture, (tmpvar_23.xy + _ShadowOffsets[3].xy)).x;
  bvec4 tmpvar_24;
  tmpvar_24 = lessThan (shadowVals_22, tmpvar_23.zzzz);
  mediump vec4 tmpvar_25;
  tmpvar_25 = _LightShadowData.xxxx;
  mediump float tmpvar_26;
  if (tmpvar_24.x) {
    tmpvar_26 = tmpvar_25.x;
  } else {
    tmpvar_26 = 1.0;
  };
  mediump float tmpvar_27;
  if (tmpvar_24.y) {
    tmpvar_27 = tmpvar_25.y;
  } else {
    tmpvar_27 = 1.0;
  };
  mediump float tmpvar_28;
  if (tmpvar_24.z) {
    tmpvar_28 = tmpvar_25.z;
  } else {
    tmpvar_28 = 1.0;
  };
  mediump float tmpvar_29;
  if (tmpvar_24.w) {
    tmpvar_29 = tmpvar_25.w;
  } else {
    tmpvar_29 = 1.0;
  };
  mediump vec4 tmpvar_30;
  tmpvar_30.x = tmpvar_26;
  tmpvar_30.y = tmpvar_27;
  tmpvar_30.z = tmpvar_28;
  tmpvar_30.w = tmpvar_29;
  mediump float tmpvar_31;
  tmpvar_31 = dot (tmpvar_30, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_21 = tmpvar_31;
  shadowAttenuation_18 = tmpvar_21;
  mediump float tmpvar_32;
  tmpvar_32 = clamp ((shadowAttenuation_18 + tmpvar_16), 0.0, 1.0);
  atten_5 = (atten_5 * tmpvar_32);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_33;
  tmpvar_33 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_33;
  lowp vec4 tmpvar_34;
  tmpvar_34 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_34;
  lowp vec4 tmpvar_35;
  tmpvar_35 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_35;
  mediump vec3 tmpvar_36;
  tmpvar_36 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_37;
  tmpvar_37 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_38;
  viewDir_38 = -(tmpvar_37);
  mediump vec2 tmpvar_39;
  tmpvar_39.x = dot ((viewDir_38 - (2.0 * 
    (dot (tmpvar_36, viewDir_38) * tmpvar_36)
  )), lightDir_6);
  tmpvar_39.y = (1.0 - clamp (dot (tmpvar_36, viewDir_38), 0.0, 1.0));
  mediump float specular_40;
  mediump vec2 tmpvar_41;
  tmpvar_41.x = ((tmpvar_39 * tmpvar_39) * (tmpvar_39 * tmpvar_39)).x;
  tmpvar_41.y = (1.0 - gbuffer1_2.w);
  highp float tmpvar_42;
  tmpvar_42 = (texture2D (unity_NHxRoughness, tmpvar_41).w * 16.0);
  specular_40 = tmpvar_42;
  mediump vec4 tmpvar_43;
  tmpvar_43.w = 1.0;
  tmpvar_43.xyz = ((gbuffer0_3.xyz + (specular_40 * gbuffer1_2.xyz)) * (tmpvar_4 * clamp (
    dot (tmpvar_36, lightDir_6)
  , 0.0, 1.0)));
  gl_FragData[0] = tmpvar_43;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _ShadowOffsets[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform highp sampler2D unity_NHxRoughness;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
lowp vec4 u_xlat10_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
vec4 u_xlat3;
vec4 u_xlat4;
lowp vec3 u_xlat10_4;
vec3 u_xlat5;
mediump vec3 u_xlat16_6;
mediump vec3 u_xlat16_7;
vec3 u_xlat8;
mediump float u_xlat16_8;
float u_xlat16;
bool u_xlatb16;
float u_xlat17;
float u_xlat24;
float u_xlat25;
mediump float u_xlat16_30;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat24 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat24 = _ZBufferParams.x * u_xlat24 + _ZBufferParams.y;
    u_xlat24 = float(1.0) / u_xlat24;
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat0.xyz;
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
    u_xlat0.x = dot(u_xlat4, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat16_8 = (-_LightShadowData.x) + 1.0;
    u_xlat0.x = u_xlat0.x * u_xlat16_8 + _LightShadowData.x;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat8.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat8.x = sqrt(u_xlat8.x);
    u_xlat8.x = (-u_xlat0.z) * u_xlat24 + u_xlat8.x;
    u_xlat8.x = unity_ShadowFadeCenterAndType.w * u_xlat8.x + u_xlat2.z;
    u_xlat8.x = u_xlat8.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat8.x = min(max(u_xlat8.x, 0.0), 1.0);
#else
    u_xlat8.x = clamp(u_xlat8.x, 0.0, 1.0);
#endif
    u_xlat16_6.x = u_xlat8.x + u_xlat0.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_6.x = min(max(u_xlat16_6.x, 0.0), 1.0);
#else
    u_xlat16_6.x = clamp(u_xlat16_6.x, 0.0, 1.0);
#endif
    u_xlat0.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat2.xxx + u_xlat0.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat2.www + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat0.xy = u_xlat0.xy / u_xlat0.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb16 = !!(u_xlat0.z<0.0);
#else
    u_xlatb16 = u_xlat0.z<0.0;
#endif
    u_xlat16 = u_xlatb16 ? 1.0 : float(0.0);
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.x = u_xlat16 * u_xlat0.x;
    u_xlat8.xyz = (-u_xlat2.xyw) + _LightPos.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat17 = dot(u_xlat8.xyz, u_xlat8.xyz);
    u_xlat25 = u_xlat17 * _LightPos.w;
    u_xlat17 = inversesqrt(u_xlat17);
    u_xlat8.xyz = u_xlat8.xyz * vec3(u_xlat17);
    u_xlat17 = texture(_LightTextureB0, vec2(u_xlat25)).w;
    u_xlat0.x = u_xlat0.x * u_xlat17;
    u_xlat0.x = u_xlat16_6.x * u_xlat0.x;
    u_xlat3.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat10_4.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_4.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_30 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_30 = inversesqrt(u_xlat16_30);
    u_xlat16_6.xyz = vec3(u_xlat16_30) * u_xlat16_6.xyz;
    u_xlat16_30 = dot(u_xlat16_6.xyz, u_xlat8.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_30 = min(max(u_xlat16_30, 0.0), 1.0);
#else
    u_xlat16_30 = clamp(u_xlat16_30, 0.0, 1.0);
#endif
    u_xlat16_7.xyz = u_xlat3.xyz * vec3(u_xlat16_30);
    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat2.xyz = u_xlat0.xxx * u_xlat2.xyz;
    u_xlat16_30 = dot((-u_xlat2.xyz), u_xlat16_6.xyz);
    u_xlat16_30 = u_xlat16_30 + u_xlat16_30;
    u_xlat16_6.xyz = u_xlat16_6.xyz * (-vec3(u_xlat16_30)) + (-u_xlat2.xyz);
    u_xlat16_6.x = dot(u_xlat16_6.xyz, u_xlat8.xyz);
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_6.x;
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_6.x;
    u_xlat10_0 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_6.y = (-u_xlat10_0.w) + 1.0;
    u_xlat24 = texture(unity_NHxRoughness, u_xlat16_6.xy).w;
    u_xlat24 = u_xlat24 * 16.0;
    u_xlat16_6.xyz = vec3(u_xlat24) * u_xlat10_0.xyz + u_xlat10_1.xyz;
    SV_Target0.xyz = u_xlat16_7.xyz * u_xlat16_6.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (_LightPos.xyz - tmpvar_9);
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize(tmpvar_11);
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_9;
  highp vec4 tmpvar_14;
  tmpvar_14 = (unity_WorldToLight * tmpvar_13);
  highp vec4 tmpvar_15;
  tmpvar_15.zw = vec2(0.0, -8.0);
  tmpvar_15.xy = (tmpvar_14.xy / tmpvar_14.w);
  atten_5 = (texture2D (_LightTexture0, tmpvar_15.xy, -8.0).w * float((tmpvar_14.w < 0.0)));
  atten_5 = (atten_5 * texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w))).w);
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  mediump float shadowAttenuation_18;
  shadowAttenuation_18 = 1.0;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = tmpvar_9;
  highp vec4 tmpvar_20;
  tmpvar_20 = (unity_WorldToShadow[0] * tmpvar_19);
  lowp float tmpvar_21;
  highp vec4 shadowVals_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (tmpvar_20.xyz / tmpvar_20.w);
  shadowVals_22.x = texture2D (_ShadowMapTexture, (tmpvar_23.xy + _ShadowOffsets[0].xy)).x;
  shadowVals_22.y = texture2D (_ShadowMapTexture, (tmpvar_23.xy + _ShadowOffsets[1].xy)).x;
  shadowVals_22.z = texture2D (_ShadowMapTexture, (tmpvar_23.xy + _ShadowOffsets[2].xy)).x;
  shadowVals_22.w = texture2D (_ShadowMapTexture, (tmpvar_23.xy + _ShadowOffsets[3].xy)).x;
  bvec4 tmpvar_24;
  tmpvar_24 = lessThan (shadowVals_22, tmpvar_23.zzzz);
  mediump vec4 tmpvar_25;
  tmpvar_25 = _LightShadowData.xxxx;
  mediump float tmpvar_26;
  if (tmpvar_24.x) {
    tmpvar_26 = tmpvar_25.x;
  } else {
    tmpvar_26 = 1.0;
  };
  mediump float tmpvar_27;
  if (tmpvar_24.y) {
    tmpvar_27 = tmpvar_25.y;
  } else {
    tmpvar_27 = 1.0;
  };
  mediump float tmpvar_28;
  if (tmpvar_24.z) {
    tmpvar_28 = tmpvar_25.z;
  } else {
    tmpvar_28 = 1.0;
  };
  mediump float tmpvar_29;
  if (tmpvar_24.w) {
    tmpvar_29 = tmpvar_25.w;
  } else {
    tmpvar_29 = 1.0;
  };
  mediump vec4 tmpvar_30;
  tmpvar_30.x = tmpvar_26;
  tmpvar_30.y = tmpvar_27;
  tmpvar_30.z = tmpvar_28;
  tmpvar_30.w = tmpvar_29;
  mediump float tmpvar_31;
  tmpvar_31 = dot (tmpvar_30, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_21 = tmpvar_31;
  shadowAttenuation_18 = tmpvar_21;
  mediump float tmpvar_32;
  tmpvar_32 = clamp ((shadowAttenuation_18 + tmpvar_16), 0.0, 1.0);
  atten_5 = (atten_5 * tmpvar_32);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_33;
  tmpvar_33 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_33;
  lowp vec4 tmpvar_34;
  tmpvar_34 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_34;
  lowp vec4 tmpvar_35;
  tmpvar_35 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_35;
  mediump vec3 tmpvar_36;
  tmpvar_36 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_37;
  tmpvar_37 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_38;
  viewDir_38 = -(tmpvar_37);
  mediump float specularTerm_39;
  mediump vec3 tmpvar_40;
  mediump vec3 inVec_41;
  inVec_41 = (lightDir_6 + viewDir_38);
  tmpvar_40 = (inVec_41 * inversesqrt(max (0.001, 
    dot (inVec_41, inVec_41)
  )));
  mediump float tmpvar_42;
  tmpvar_42 = clamp (dot (tmpvar_36, tmpvar_40), 0.0, 1.0);
  mediump float tmpvar_43;
  tmpvar_43 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_44;
  tmpvar_44 = (tmpvar_43 * tmpvar_43);
  specularTerm_39 = ((tmpvar_44 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_40), 0.0, 1.0)) * (1.5 + tmpvar_44))
   * 
    (((tmpvar_42 * tmpvar_42) * ((tmpvar_44 * tmpvar_44) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_45;
  tmpvar_45 = clamp (specularTerm_39, 0.0, 100.0);
  specularTerm_39 = tmpvar_45;
  mediump vec4 tmpvar_46;
  tmpvar_46.w = 1.0;
  tmpvar_46.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_45 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_36, lightDir_6), 0.0, 1.0));
  gl_FragData[0] = tmpvar_46;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _ShadowMapTexture;
uniform highp vec4 _ShadowOffsets[4];
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (_LightPos.xyz - tmpvar_9);
  highp vec3 tmpvar_12;
  tmpvar_12 = normalize(tmpvar_11);
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13.w = 1.0;
  tmpvar_13.xyz = tmpvar_9;
  highp vec4 tmpvar_14;
  tmpvar_14 = (unity_WorldToLight * tmpvar_13);
  highp vec4 tmpvar_15;
  tmpvar_15.zw = vec2(0.0, -8.0);
  tmpvar_15.xy = (tmpvar_14.xy / tmpvar_14.w);
  atten_5 = (texture2D (_LightTexture0, tmpvar_15.xy, -8.0).w * float((tmpvar_14.w < 0.0)));
  atten_5 = (atten_5 * texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w))).w);
  mediump float tmpvar_16;
  highp float tmpvar_17;
  tmpvar_17 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_16 = tmpvar_17;
  mediump float shadowAttenuation_18;
  shadowAttenuation_18 = 1.0;
  highp vec4 tmpvar_19;
  tmpvar_19.w = 1.0;
  tmpvar_19.xyz = tmpvar_9;
  highp vec4 tmpvar_20;
  tmpvar_20 = (unity_WorldToShadow[0] * tmpvar_19);
  lowp float tmpvar_21;
  highp vec4 shadowVals_22;
  highp vec3 tmpvar_23;
  tmpvar_23 = (tmpvar_20.xyz / tmpvar_20.w);
  shadowVals_22.x = texture2D (_ShadowMapTexture, (tmpvar_23.xy + _ShadowOffsets[0].xy)).x;
  shadowVals_22.y = texture2D (_ShadowMapTexture, (tmpvar_23.xy + _ShadowOffsets[1].xy)).x;
  shadowVals_22.z = texture2D (_ShadowMapTexture, (tmpvar_23.xy + _ShadowOffsets[2].xy)).x;
  shadowVals_22.w = texture2D (_ShadowMapTexture, (tmpvar_23.xy + _ShadowOffsets[3].xy)).x;
  bvec4 tmpvar_24;
  tmpvar_24 = lessThan (shadowVals_22, tmpvar_23.zzzz);
  mediump vec4 tmpvar_25;
  tmpvar_25 = _LightShadowData.xxxx;
  mediump float tmpvar_26;
  if (tmpvar_24.x) {
    tmpvar_26 = tmpvar_25.x;
  } else {
    tmpvar_26 = 1.0;
  };
  mediump float tmpvar_27;
  if (tmpvar_24.y) {
    tmpvar_27 = tmpvar_25.y;
  } else {
    tmpvar_27 = 1.0;
  };
  mediump float tmpvar_28;
  if (tmpvar_24.z) {
    tmpvar_28 = tmpvar_25.z;
  } else {
    tmpvar_28 = 1.0;
  };
  mediump float tmpvar_29;
  if (tmpvar_24.w) {
    tmpvar_29 = tmpvar_25.w;
  } else {
    tmpvar_29 = 1.0;
  };
  mediump vec4 tmpvar_30;
  tmpvar_30.x = tmpvar_26;
  tmpvar_30.y = tmpvar_27;
  tmpvar_30.z = tmpvar_28;
  tmpvar_30.w = tmpvar_29;
  mediump float tmpvar_31;
  tmpvar_31 = dot (tmpvar_30, vec4(0.25, 0.25, 0.25, 0.25));
  tmpvar_21 = tmpvar_31;
  shadowAttenuation_18 = tmpvar_21;
  mediump float tmpvar_32;
  tmpvar_32 = clamp ((shadowAttenuation_18 + tmpvar_16), 0.0, 1.0);
  atten_5 = (atten_5 * tmpvar_32);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_33;
  tmpvar_33 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_33;
  lowp vec4 tmpvar_34;
  tmpvar_34 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_34;
  lowp vec4 tmpvar_35;
  tmpvar_35 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_35;
  mediump vec3 tmpvar_36;
  tmpvar_36 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_37;
  tmpvar_37 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_38;
  viewDir_38 = -(tmpvar_37);
  mediump float specularTerm_39;
  mediump vec3 tmpvar_40;
  mediump vec3 inVec_41;
  inVec_41 = (lightDir_6 + viewDir_38);
  tmpvar_40 = (inVec_41 * inversesqrt(max (0.001, 
    dot (inVec_41, inVec_41)
  )));
  mediump float tmpvar_42;
  tmpvar_42 = clamp (dot (tmpvar_36, tmpvar_40), 0.0, 1.0);
  mediump float tmpvar_43;
  tmpvar_43 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_44;
  tmpvar_44 = (tmpvar_43 * tmpvar_43);
  specularTerm_39 = ((tmpvar_44 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_40), 0.0, 1.0)) * (1.5 + tmpvar_44))
   * 
    (((tmpvar_42 * tmpvar_42) * ((tmpvar_44 * tmpvar_44) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_45;
  tmpvar_45 = clamp (specularTerm_39, 0.0, 100.0);
  specularTerm_39 = tmpvar_45;
  mediump vec4 tmpvar_46;
  tmpvar_46.w = 1.0;
  tmpvar_46.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_45 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_36, lightDir_6), 0.0, 1.0));
  gl_FragData[0] = tmpvar_46;
}


#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _ShadowOffsets[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
mediump float u_xlat16_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec4 u_xlat3;
vec4 u_xlat4;
lowp vec3 u_xlat10_4;
vec3 u_xlat5;
mediump vec4 u_xlat16_6;
mediump vec3 u_xlat16_7;
vec3 u_xlat8;
mediump float u_xlat16_8;
mediump float u_xlat16_14;
float u_xlat16;
bool u_xlatb16;
float u_xlat17;
mediump float u_xlat16_17;
float u_xlat24;
float u_xlat25;
mediump float u_xlat16_30;
mediump float u_xlat16_31;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat24 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat24 = _ZBufferParams.x * u_xlat24 + _ZBufferParams.y;
    u_xlat24 = float(1.0) / u_xlat24;
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat0.xyz;
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
    u_xlat0.x = dot(u_xlat4, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat16_8 = (-_LightShadowData.x) + 1.0;
    u_xlat0.x = u_xlat0.x * u_xlat16_8 + _LightShadowData.x;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat8.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat8.x = sqrt(u_xlat8.x);
    u_xlat8.x = (-u_xlat0.z) * u_xlat24 + u_xlat8.x;
    u_xlat8.x = unity_ShadowFadeCenterAndType.w * u_xlat8.x + u_xlat2.z;
    u_xlat8.x = u_xlat8.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat8.x = min(max(u_xlat8.x, 0.0), 1.0);
#else
    u_xlat8.x = clamp(u_xlat8.x, 0.0, 1.0);
#endif
    u_xlat16_6.x = u_xlat8.x + u_xlat0.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_6.x = min(max(u_xlat16_6.x, 0.0), 1.0);
#else
    u_xlat16_6.x = clamp(u_xlat16_6.x, 0.0, 1.0);
#endif
    u_xlat0.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat2.xxx + u_xlat0.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat2.www + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat0.xy = u_xlat0.xy / u_xlat0.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb16 = !!(u_xlat0.z<0.0);
#else
    u_xlatb16 = u_xlat0.z<0.0;
#endif
    u_xlat16 = u_xlatb16 ? 1.0 : float(0.0);
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.x = u_xlat16 * u_xlat0.x;
    u_xlat8.xyz = (-u_xlat2.xyw) + _LightPos.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat17 = dot(u_xlat8.xyz, u_xlat8.xyz);
    u_xlat25 = u_xlat17 * _LightPos.w;
    u_xlat17 = inversesqrt(u_xlat17);
    u_xlat8.xyz = u_xlat8.xyz * vec3(u_xlat17);
    u_xlat17 = texture(_LightTextureB0, vec2(u_xlat25)).w;
    u_xlat0.x = u_xlat0.x * u_xlat17;
    u_xlat0.x = u_xlat16_6.x * u_xlat0.x;
    u_xlat3.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat16_6.xyz = (-u_xlat2.xyz) * u_xlat0.xxx + u_xlat8.xyz;
    u_xlat16_30 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_0 = max(u_xlat16_30, 0.00100000005);
    u_xlat16_30 = inversesqrt(u_xlat16_0);
    u_xlat16_6.xyz = vec3(u_xlat16_30) * u_xlat16_6.xyz;
    u_xlat16_30 = dot(u_xlat8.xyz, u_xlat16_6.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_30 = min(max(u_xlat16_30, 0.0), 1.0);
#else
    u_xlat16_30 = clamp(u_xlat16_30, 0.0, 1.0);
#endif
    u_xlat16_0 = max(u_xlat16_30, 0.319999993);
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat16_30 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_17 = u_xlat16_30 * u_xlat16_30 + 1.5;
    u_xlat16_30 = u_xlat16_30 * u_xlat16_30;
    u_xlat16_0 = u_xlat16_0 * u_xlat16_17;
    u_xlat10_4.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_7.xyz = u_xlat10_4.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_31 = dot(u_xlat16_7.xyz, u_xlat16_7.xyz);
    u_xlat16_31 = inversesqrt(u_xlat16_31);
    u_xlat16_7.xyz = vec3(u_xlat16_31) * u_xlat16_7.xyz;
    u_xlat16_6.x = dot(u_xlat16_7.xyz, u_xlat16_6.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_6.x = min(max(u_xlat16_6.x, 0.0), 1.0);
#else
    u_xlat16_6.x = clamp(u_xlat16_6.x, 0.0, 1.0);
#endif
    u_xlat16_14 = dot(u_xlat16_7.xyz, u_xlat8.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_14 = min(max(u_xlat16_14, 0.0), 1.0);
#else
    u_xlat16_14 = clamp(u_xlat16_14, 0.0, 1.0);
#endif
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_6.x;
    u_xlat16_8 = u_xlat16_30 * u_xlat16_30 + -1.0;
    u_xlat16_8 = u_xlat16_6.x * u_xlat16_8 + 1.00001001;
    u_xlat16_0 = u_xlat16_8 * u_xlat16_0;
    u_xlat16_0 = u_xlat16_30 / u_xlat16_0;
    u_xlat16_0 = u_xlat16_0 + -9.99999975e-05;
    u_xlat16_6.x = max(u_xlat16_0, 0.0);
    u_xlat16_6.x = min(u_xlat16_6.x, 100.0);
    u_xlat16_6.xzw = u_xlat16_6.xxx * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat16_6.xzw = u_xlat3.xyz * u_xlat16_6.xzw;
    SV_Target0.xyz = vec3(u_xlat16_14) * u_xlat16_6.xzw;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform 	vec4 _ShadowOffsets[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTexture0;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp sampler2DShadow hlslcc_zcmp_ShadowMapTexture;
uniform lowp sampler2D _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
mediump float u_xlat16_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec4 u_xlat3;
vec4 u_xlat4;
lowp vec3 u_xlat10_4;
vec3 u_xlat5;
mediump vec4 u_xlat16_6;
mediump vec3 u_xlat16_7;
vec3 u_xlat8;
mediump float u_xlat16_8;
mediump float u_xlat16_14;
float u_xlat16;
bool u_xlatb16;
float u_xlat17;
mediump float u_xlat16_17;
float u_xlat24;
float u_xlat25;
mediump float u_xlat16_30;
mediump float u_xlat16_31;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat24 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat24 = _ZBufferParams.x * u_xlat24 + _ZBufferParams.y;
    u_xlat24 = float(1.0) / u_xlat24;
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat0.xyz;
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
    u_xlat0.x = dot(u_xlat4, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat16_8 = (-_LightShadowData.x) + 1.0;
    u_xlat0.x = u_xlat0.x * u_xlat16_8 + _LightShadowData.x;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat8.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat8.x = sqrt(u_xlat8.x);
    u_xlat8.x = (-u_xlat0.z) * u_xlat24 + u_xlat8.x;
    u_xlat8.x = unity_ShadowFadeCenterAndType.w * u_xlat8.x + u_xlat2.z;
    u_xlat8.x = u_xlat8.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat8.x = min(max(u_xlat8.x, 0.0), 1.0);
#else
    u_xlat8.x = clamp(u_xlat8.x, 0.0, 1.0);
#endif
    u_xlat16_6.x = u_xlat8.x + u_xlat0.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_6.x = min(max(u_xlat16_6.x, 0.0), 1.0);
#else
    u_xlat16_6.x = clamp(u_xlat16_6.x, 0.0, 1.0);
#endif
    u_xlat0.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyw;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyw * u_xlat2.xxx + u_xlat0.xyz;
    u_xlat0.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyw * u_xlat2.www + u_xlat0.xyz;
    u_xlat0.xyz = u_xlat0.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyw;
    u_xlat0.xy = u_xlat0.xy / u_xlat0.zz;
#ifdef UNITY_ADRENO_ES3
    u_xlatb16 = !!(u_xlat0.z<0.0);
#else
    u_xlatb16 = u_xlat0.z<0.0;
#endif
    u_xlat16 = u_xlatb16 ? 1.0 : float(0.0);
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.x = u_xlat16 * u_xlat0.x;
    u_xlat8.xyz = (-u_xlat2.xyw) + _LightPos.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat17 = dot(u_xlat8.xyz, u_xlat8.xyz);
    u_xlat25 = u_xlat17 * _LightPos.w;
    u_xlat17 = inversesqrt(u_xlat17);
    u_xlat8.xyz = u_xlat8.xyz * vec3(u_xlat17);
    u_xlat17 = texture(_LightTextureB0, vec2(u_xlat25)).w;
    u_xlat0.x = u_xlat0.x * u_xlat17;
    u_xlat0.x = u_xlat16_6.x * u_xlat0.x;
    u_xlat3.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat16_6.xyz = (-u_xlat2.xyz) * u_xlat0.xxx + u_xlat8.xyz;
    u_xlat16_30 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_0 = max(u_xlat16_30, 0.00100000005);
    u_xlat16_30 = inversesqrt(u_xlat16_0);
    u_xlat16_6.xyz = vec3(u_xlat16_30) * u_xlat16_6.xyz;
    u_xlat16_30 = dot(u_xlat8.xyz, u_xlat16_6.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_30 = min(max(u_xlat16_30, 0.0), 1.0);
#else
    u_xlat16_30 = clamp(u_xlat16_30, 0.0, 1.0);
#endif
    u_xlat16_0 = max(u_xlat16_30, 0.319999993);
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat16_30 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_17 = u_xlat16_30 * u_xlat16_30 + 1.5;
    u_xlat16_30 = u_xlat16_30 * u_xlat16_30;
    u_xlat16_0 = u_xlat16_0 * u_xlat16_17;
    u_xlat10_4.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_7.xyz = u_xlat10_4.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_31 = dot(u_xlat16_7.xyz, u_xlat16_7.xyz);
    u_xlat16_31 = inversesqrt(u_xlat16_31);
    u_xlat16_7.xyz = vec3(u_xlat16_31) * u_xlat16_7.xyz;
    u_xlat16_6.x = dot(u_xlat16_7.xyz, u_xlat16_6.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_6.x = min(max(u_xlat16_6.x, 0.0), 1.0);
#else
    u_xlat16_6.x = clamp(u_xlat16_6.x, 0.0, 1.0);
#endif
    u_xlat16_14 = dot(u_xlat16_7.xyz, u_xlat8.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_14 = min(max(u_xlat16_14, 0.0), 1.0);
#else
    u_xlat16_14 = clamp(u_xlat16_14, 0.0, 1.0);
#endif
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_6.x;
    u_xlat16_8 = u_xlat16_30 * u_xlat16_30 + -1.0;
    u_xlat16_8 = u_xlat16_6.x * u_xlat16_8 + 1.00001001;
    u_xlat16_0 = u_xlat16_8 * u_xlat16_0;
    u_xlat16_0 = u_xlat16_30 / u_xlat16_0;
    u_xlat16_0 = u_xlat16_0 + -9.99999975e-05;
    u_xlat16_6.x = max(u_xlat16_0, 0.0);
    u_xlat16_6.x = min(u_xlat16_6.x, 100.0);
    u_xlat16_6.xzw = u_xlat16_6.xxx * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat16_6.xzw = u_xlat3.xyz * u_xlat16_6.xzw;
    SV_Target0.xyz = vec3(u_xlat16_14) * u_xlat16_6.xzw;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
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
uniform sampler2D _ShadowMapTexture;
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  mediump float tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_12 = tmpvar_13;
  mediump float shadowAttenuation_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_ShadowMapTexture, tmpvar_7);
  shadowAttenuation_14 = tmpvar_15.x;
  mediump float tmpvar_16;
  tmpvar_16 = clamp ((shadowAttenuation_14 + tmpvar_12), 0.0, 1.0);
  atten_5 = tmpvar_16;
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_19;
  mediump vec3 tmpvar_20;
  tmpvar_20 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_21;
  tmpvar_21 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_22;
  viewDir_22 = -(tmpvar_21);
  mediump vec2 tmpvar_23;
  tmpvar_23.x = dot ((viewDir_22 - (2.0 * 
    (dot (tmpvar_20, viewDir_22) * tmpvar_20)
  )), lightDir_6);
  tmpvar_23.y = (1.0 - clamp (dot (tmpvar_20, viewDir_22), 0.0, 1.0));
  mediump float specular_24;
  mediump vec2 tmpvar_25;
  tmpvar_25.x = ((tmpvar_23 * tmpvar_23) * (tmpvar_23 * tmpvar_23)).x;
  tmpvar_25.y = (1.0 - gbuffer1_2.w);
  highp float tmpvar_26;
  tmpvar_26 = (texture2D (unity_NHxRoughness, tmpvar_25).w * 16.0);
  specular_24 = tmpvar_26;
  mediump vec4 tmpvar_27;
  tmpvar_27.w = 1.0;
  tmpvar_27.xyz = ((gbuffer0_3.xyz + (specular_24 * gbuffer1_2.xyz)) * (tmpvar_4 * clamp (
    dot (tmpvar_20, lightDir_6)
  , 0.0, 1.0)));
  gl_FragData[0] = tmpvar_27;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform highp sampler2D unity_NHxRoughness;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
vec2 u_xlat1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
lowp vec3 u_xlat10_3;
mediump vec3 u_xlat16_4;
mediump vec3 u_xlat16_5;
vec3 u_xlat6;
mediump float u_xlat16_10;
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
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat18 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat6.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6.x = inversesqrt(u_xlat6.x);
    u_xlat6.xyz = u_xlat6.xxx * u_xlat3.xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_4.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat16_22 = dot((-u_xlat6.xyz), u_xlat16_4.xyz);
    u_xlat16_22 = u_xlat16_22 + u_xlat16_22;
    u_xlat16_5.xyz = u_xlat16_4.xyz * (-vec3(u_xlat16_22)) + (-u_xlat6.xyz);
    u_xlat16_4.x = dot(u_xlat16_4.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10 = dot(u_xlat16_5.xyz, (-_LightDir.xyz));
    u_xlat16_10 = u_xlat16_10 * u_xlat16_10;
    u_xlat16_5.x = u_xlat16_10 * u_xlat16_10;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat16_5.y = (-u_xlat10_2.w) + 1.0;
    u_xlat6.x = texture(unity_NHxRoughness, u_xlat16_5.xy).w;
    u_xlat6.x = u_xlat6.x * 16.0;
    u_xlat10_3.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat10_12 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat16_10 = u_xlat0.x + u_xlat10_12;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_10 = min(max(u_xlat16_10, 0.0), 1.0);
#else
    u_xlat16_10 = clamp(u_xlat16_10, 0.0, 1.0);
#endif
    u_xlat0.xzw = vec3(u_xlat16_10) * _LightColor.xyz;
    u_xlat16_4.xyz = u_xlat16_4.xxx * u_xlat0.xzw;
    u_xlat16_5.xyz = u_xlat6.xxx * u_xlat10_2.xyz + u_xlat10_3.xyz;
    SV_Target0.xyz = u_xlat16_4.xyz * u_xlat16_5.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
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
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  mediump float tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_12 = tmpvar_13;
  mediump float shadowAttenuation_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_ShadowMapTexture, tmpvar_7);
  shadowAttenuation_14 = tmpvar_15.x;
  mediump float tmpvar_16;
  tmpvar_16 = clamp ((shadowAttenuation_14 + tmpvar_12), 0.0, 1.0);
  atten_5 = tmpvar_16;
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_19;
  mediump vec3 tmpvar_20;
  tmpvar_20 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_21;
  tmpvar_21 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_22;
  viewDir_22 = -(tmpvar_21);
  mediump float specularTerm_23;
  mediump vec3 tmpvar_24;
  mediump vec3 inVec_25;
  inVec_25 = (lightDir_6 + viewDir_22);
  tmpvar_24 = (inVec_25 * inversesqrt(max (0.001, 
    dot (inVec_25, inVec_25)
  )));
  mediump float tmpvar_26;
  tmpvar_26 = clamp (dot (tmpvar_20, tmpvar_24), 0.0, 1.0);
  mediump float tmpvar_27;
  tmpvar_27 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_28;
  tmpvar_28 = (tmpvar_27 * tmpvar_27);
  specularTerm_23 = ((tmpvar_28 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_24), 0.0, 1.0)) * (1.5 + tmpvar_28))
   * 
    (((tmpvar_26 * tmpvar_26) * ((tmpvar_28 * tmpvar_28) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_29;
  tmpvar_29 = clamp (specularTerm_23, 0.0, 100.0);
  specularTerm_23 = tmpvar_29;
  mediump vec4 tmpvar_30;
  tmpvar_30.w = 1.0;
  tmpvar_30.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_29 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_20, lightDir_6), 0.0, 1.0));
  gl_FragData[0] = tmpvar_30;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
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
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  mediump float tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_12 = tmpvar_13;
  mediump float shadowAttenuation_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_ShadowMapTexture, tmpvar_7);
  shadowAttenuation_14 = tmpvar_15.x;
  mediump float tmpvar_16;
  tmpvar_16 = clamp ((shadowAttenuation_14 + tmpvar_12), 0.0, 1.0);
  atten_5 = tmpvar_16;
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_17;
  tmpvar_17 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_17;
  lowp vec4 tmpvar_18;
  tmpvar_18 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_18;
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_19;
  mediump vec3 tmpvar_20;
  tmpvar_20 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_21;
  tmpvar_21 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_22;
  viewDir_22 = -(tmpvar_21);
  mediump float specularTerm_23;
  mediump vec3 tmpvar_24;
  mediump vec3 inVec_25;
  inVec_25 = (lightDir_6 + viewDir_22);
  tmpvar_24 = (inVec_25 * inversesqrt(max (0.001, 
    dot (inVec_25, inVec_25)
  )));
  mediump float tmpvar_26;
  tmpvar_26 = clamp (dot (tmpvar_20, tmpvar_24), 0.0, 1.0);
  mediump float tmpvar_27;
  tmpvar_27 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_28;
  tmpvar_28 = (tmpvar_27 * tmpvar_27);
  specularTerm_23 = ((tmpvar_28 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_24), 0.0, 1.0)) * (1.5 + tmpvar_28))
   * 
    (((tmpvar_26 * tmpvar_26) * ((tmpvar_28 * tmpvar_28) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_29;
  tmpvar_29 = clamp (specularTerm_23, 0.0, 100.0);
  specularTerm_23 = tmpvar_29;
  mediump vec4 tmpvar_30;
  tmpvar_30.w = 1.0;
  tmpvar_30.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_29 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_20, lightDir_6), 0.0, 1.0));
  gl_FragData[0] = tmpvar_30;
}


#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
vec3 u_xlat1;
lowp float u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump vec3 u_xlat16_5;
float u_xlat6;
mediump float u_xlat16_6;
lowp vec3 u_xlat10_6;
mediump vec3 u_xlat16_10;
mediump float u_xlat16_12;
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
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat6 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6 = inversesqrt(u_xlat6);
    u_xlat16_4.xyz = (-u_xlat3.xyz) * vec3(u_xlat6) + (-_LightDir.xyz);
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_6 = max(u_xlat16_22, 0.00100000005);
    u_xlat16_22 = inversesqrt(u_xlat16_6);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat10_6.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_6.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_5.xyz = vec3(u_xlat16_22) * u_xlat16_5.xyz;
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_22 = min(max(u_xlat16_22, 0.0), 1.0);
#else
    u_xlat16_22 = clamp(u_xlat16_22, 0.0, 1.0);
#endif
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_6 = max(u_xlat16_4.x, 0.319999993);
    u_xlat16_4.x = dot(u_xlat16_5.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10.x = u_xlat16_22 * u_xlat16_22;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat16_16 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_22 = u_xlat16_16 * u_xlat16_16;
    u_xlat16_12 = u_xlat16_16 * u_xlat16_16 + 1.5;
    u_xlat16_6 = u_xlat16_12 * u_xlat16_6;
    u_xlat16_12 = u_xlat16_22 * u_xlat16_22 + -1.0;
    u_xlat16_12 = u_xlat16_10.x * u_xlat16_12 + 1.00001001;
    u_xlat16_6 = u_xlat16_12 * u_xlat16_6;
    u_xlat16_6 = u_xlat16_22 / u_xlat16_6;
    u_xlat16_6 = u_xlat16_6 + -9.99999975e-05;
    u_xlat16_10.x = max(u_xlat16_6, 0.0);
    u_xlat16_10.x = min(u_xlat16_10.x, 100.0);
    u_xlat10_6.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat10_1 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat16_16 = u_xlat0.x + u_xlat10_1;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_16 = min(max(u_xlat16_16, 0.0), 1.0);
#else
    u_xlat16_16 = clamp(u_xlat16_16, 0.0, 1.0);
#endif
    u_xlat1.xyz = vec3(u_xlat16_16) * _LightColor.xyz;
    u_xlat16_10.xyz = u_xlat16_10.xxx * u_xlat10_2.xyz + u_xlat10_6.xyz;
    u_xlat16_10.xyz = u_xlat1.xyz * u_xlat16_10.xyz;
    SV_Target0.xyz = u_xlat16_4.xxx * u_xlat16_10.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
vec3 u_xlat1;
lowp float u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump vec3 u_xlat16_5;
float u_xlat6;
mediump float u_xlat16_6;
lowp vec3 u_xlat10_6;
mediump vec3 u_xlat16_10;
mediump float u_xlat16_12;
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
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat6 = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat6 = inversesqrt(u_xlat6);
    u_xlat16_4.xyz = (-u_xlat3.xyz) * vec3(u_xlat6) + (-_LightDir.xyz);
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_6 = max(u_xlat16_22, 0.00100000005);
    u_xlat16_22 = inversesqrt(u_xlat16_6);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat10_6.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_6.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_5.xyz = vec3(u_xlat16_22) * u_xlat16_5.xyz;
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_22 = min(max(u_xlat16_22, 0.0), 1.0);
#else
    u_xlat16_22 = clamp(u_xlat16_22, 0.0, 1.0);
#endif
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_6 = max(u_xlat16_4.x, 0.319999993);
    u_xlat16_4.x = dot(u_xlat16_5.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10.x = u_xlat16_22 * u_xlat16_22;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat16_16 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_22 = u_xlat16_16 * u_xlat16_16;
    u_xlat16_12 = u_xlat16_16 * u_xlat16_16 + 1.5;
    u_xlat16_6 = u_xlat16_12 * u_xlat16_6;
    u_xlat16_12 = u_xlat16_22 * u_xlat16_22 + -1.0;
    u_xlat16_12 = u_xlat16_10.x * u_xlat16_12 + 1.00001001;
    u_xlat16_6 = u_xlat16_12 * u_xlat16_6;
    u_xlat16_6 = u_xlat16_22 / u_xlat16_6;
    u_xlat16_6 = u_xlat16_6 + -9.99999975e-05;
    u_xlat16_10.x = max(u_xlat16_6, 0.0);
    u_xlat16_10.x = min(u_xlat16_10.x, 100.0);
    u_xlat10_6.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat10_1 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat16_16 = u_xlat0.x + u_xlat10_1;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_16 = min(max(u_xlat16_16, 0.0), 1.0);
#else
    u_xlat16_16 = clamp(u_xlat16_16, 0.0, 1.0);
#endif
    u_xlat1.xyz = vec3(u_xlat16_16) * _LightColor.xyz;
    u_xlat16_10.xyz = u_xlat16_10.xxx * u_xlat10_2.xyz + u_xlat10_6.xyz;
    u_xlat16_10.xyz = u_xlat1.xyz * u_xlat16_10.xyz;
    SV_Target0.xyz = u_xlat16_4.xxx * u_xlat16_10.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  mediump float tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_12 = tmpvar_13;
  mediump float shadowAttenuation_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_ShadowMapTexture, tmpvar_7);
  shadowAttenuation_14 = tmpvar_15.x;
  mediump float tmpvar_16;
  tmpvar_16 = clamp ((shadowAttenuation_14 + tmpvar_12), 0.0, 1.0);
  atten_5 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = tmpvar_9;
  highp vec4 tmpvar_18;
  tmpvar_18.zw = vec2(0.0, -8.0);
  tmpvar_18.xy = (unity_WorldToLight * tmpvar_17).xy;
  atten_5 = (atten_5 * texture2D (_LightTexture0, tmpvar_18.xy, -8.0).w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_23;
  tmpvar_23 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_24;
  viewDir_24 = -(tmpvar_23);
  mediump vec2 tmpvar_25;
  tmpvar_25.x = dot ((viewDir_24 - (2.0 * 
    (dot (tmpvar_22, viewDir_24) * tmpvar_22)
  )), lightDir_6);
  tmpvar_25.y = (1.0 - clamp (dot (tmpvar_22, viewDir_24), 0.0, 1.0));
  mediump float specular_26;
  mediump vec2 tmpvar_27;
  tmpvar_27.x = ((tmpvar_25 * tmpvar_25) * (tmpvar_25 * tmpvar_25)).x;
  tmpvar_27.y = (1.0 - gbuffer1_2.w);
  highp float tmpvar_28;
  tmpvar_28 = (texture2D (unity_NHxRoughness, tmpvar_27).w * 16.0);
  specular_26 = tmpvar_28;
  mediump vec4 tmpvar_29;
  tmpvar_29.w = 1.0;
  tmpvar_29.xyz = ((gbuffer0_3.xyz + (specular_26 * gbuffer1_2.xyz)) * (tmpvar_4 * clamp (
    dot (tmpvar_22, lightDir_6)
  , 0.0, 1.0)));
  gl_FragData[0] = tmpvar_29;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform highp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform highp sampler2D unity_NHxRoughness;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
lowp vec4 u_xlat10_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
lowp vec3 u_xlat10_3;
mediump vec3 u_xlat16_4;
mediump vec3 u_xlat16_5;
lowp float u_xlat10_6;
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
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat10_6 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat16_4.x = u_xlat0.x + u_xlat10_6;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat0.xy = u_xlat2.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat2.xx + u_xlat0.xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat2.ww + u_xlat0.xy;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat0.xy = u_xlat0.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.x = u_xlat0.x * u_xlat16_4.x;
    u_xlat0.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat10_3.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_4.xyz = u_xlat10_3.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat16_22 = dot(u_xlat16_4.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_22 = min(max(u_xlat16_22, 0.0), 1.0);
#else
    u_xlat16_22 = clamp(u_xlat16_22, 0.0, 1.0);
#endif
    u_xlat16_5.xyz = u_xlat0.xyz * vec3(u_xlat16_22);
    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat0.xyz = u_xlat0.xxx * u_xlat2.xyz;
    u_xlat16_22 = dot((-u_xlat0.xyz), u_xlat16_4.xyz);
    u_xlat16_22 = u_xlat16_22 + u_xlat16_22;
    u_xlat16_4.xyz = u_xlat16_4.xyz * (-vec3(u_xlat16_22)) + (-u_xlat0.xyz);
    u_xlat16_4.x = dot(u_xlat16_4.xyz, (-_LightDir.xyz));
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_4.x;
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_4.x;
    u_xlat10_0 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_4.y = (-u_xlat10_0.w) + 1.0;
    u_xlat18 = texture(unity_NHxRoughness, u_xlat16_4.xy).w;
    u_xlat18 = u_xlat18 * 16.0;
    u_xlat16_4.xyz = vec3(u_xlat18) * u_xlat10_0.xyz + u_xlat10_1.xyz;
    SV_Target0.xyz = u_xlat16_5.xyz * u_xlat16_4.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  mediump float tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_12 = tmpvar_13;
  mediump float shadowAttenuation_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_ShadowMapTexture, tmpvar_7);
  shadowAttenuation_14 = tmpvar_15.x;
  mediump float tmpvar_16;
  tmpvar_16 = clamp ((shadowAttenuation_14 + tmpvar_12), 0.0, 1.0);
  atten_5 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = tmpvar_9;
  highp vec4 tmpvar_18;
  tmpvar_18.zw = vec2(0.0, -8.0);
  tmpvar_18.xy = (unity_WorldToLight * tmpvar_17).xy;
  atten_5 = (atten_5 * texture2D (_LightTexture0, tmpvar_18.xy, -8.0).w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_23;
  tmpvar_23 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_24;
  viewDir_24 = -(tmpvar_23);
  mediump float specularTerm_25;
  mediump vec3 tmpvar_26;
  mediump vec3 inVec_27;
  inVec_27 = (lightDir_6 + viewDir_24);
  tmpvar_26 = (inVec_27 * inversesqrt(max (0.001, 
    dot (inVec_27, inVec_27)
  )));
  mediump float tmpvar_28;
  tmpvar_28 = clamp (dot (tmpvar_22, tmpvar_26), 0.0, 1.0);
  mediump float tmpvar_29;
  tmpvar_29 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_30;
  tmpvar_30 = (tmpvar_29 * tmpvar_29);
  specularTerm_25 = ((tmpvar_30 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_26), 0.0, 1.0)) * (1.5 + tmpvar_30))
   * 
    (((tmpvar_28 * tmpvar_28) * ((tmpvar_30 * tmpvar_30) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_31;
  tmpvar_31 = clamp (specularTerm_25, 0.0, 100.0);
  specularTerm_25 = tmpvar_31;
  mediump vec4 tmpvar_32;
  tmpvar_32.w = 1.0;
  tmpvar_32.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_31 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_22, lightDir_6), 0.0, 1.0));
  gl_FragData[0] = tmpvar_32;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTexture0;
uniform sampler2D _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  mediump float tmpvar_12;
  highp float tmpvar_13;
  tmpvar_13 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_12 = tmpvar_13;
  mediump float shadowAttenuation_14;
  lowp vec4 tmpvar_15;
  tmpvar_15 = texture2D (_ShadowMapTexture, tmpvar_7);
  shadowAttenuation_14 = tmpvar_15.x;
  mediump float tmpvar_16;
  tmpvar_16 = clamp ((shadowAttenuation_14 + tmpvar_12), 0.0, 1.0);
  atten_5 = tmpvar_16;
  highp vec4 tmpvar_17;
  tmpvar_17.w = 1.0;
  tmpvar_17.xyz = tmpvar_9;
  highp vec4 tmpvar_18;
  tmpvar_18.zw = vec2(0.0, -8.0);
  tmpvar_18.xy = (unity_WorldToLight * tmpvar_17).xy;
  atten_5 = (atten_5 * texture2D (_LightTexture0, tmpvar_18.xy, -8.0).w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_19;
  tmpvar_19 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_20;
  lowp vec4 tmpvar_21;
  tmpvar_21 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_21;
  mediump vec3 tmpvar_22;
  tmpvar_22 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_23;
  tmpvar_23 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_24;
  viewDir_24 = -(tmpvar_23);
  mediump float specularTerm_25;
  mediump vec3 tmpvar_26;
  mediump vec3 inVec_27;
  inVec_27 = (lightDir_6 + viewDir_24);
  tmpvar_26 = (inVec_27 * inversesqrt(max (0.001, 
    dot (inVec_27, inVec_27)
  )));
  mediump float tmpvar_28;
  tmpvar_28 = clamp (dot (tmpvar_22, tmpvar_26), 0.0, 1.0);
  mediump float tmpvar_29;
  tmpvar_29 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_30;
  tmpvar_30 = (tmpvar_29 * tmpvar_29);
  specularTerm_25 = ((tmpvar_30 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_26), 0.0, 1.0)) * (1.5 + tmpvar_30))
   * 
    (((tmpvar_28 * tmpvar_28) * ((tmpvar_30 * tmpvar_30) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_31;
  tmpvar_31 = clamp (specularTerm_25, 0.0, 100.0);
  specularTerm_25 = tmpvar_31;
  mediump vec4 tmpvar_32;
  tmpvar_32.w = 1.0;
  tmpvar_32.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_31 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_22, lightDir_6), 0.0, 1.0));
  gl_FragData[0] = tmpvar_32;
}


#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform highp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump vec3 u_xlat16_5;
lowp float u_xlat10_6;
mediump vec3 u_xlat16_10;
mediump float u_xlat16_16;
float u_xlat18;
mediump float u_xlat16_18;
mediump float u_xlat16_19;
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
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat10_6 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat16_4.x = u_xlat0.x + u_xlat10_6;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat0.xy = u_xlat2.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat2.xx + u_xlat0.xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat2.ww + u_xlat0.xy;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat0.xy = u_xlat0.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.x = u_xlat0.x * u_xlat16_4.x;
    u_xlat0.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat18 = inversesqrt(u_xlat18);
    u_xlat16_4.xyz = (-u_xlat2.xyz) * vec3(u_xlat18) + (-_LightDir.xyz);
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_18 = max(u_xlat16_22, 0.00100000005);
    u_xlat16_22 = inversesqrt(u_xlat16_18);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_5.xyz = vec3(u_xlat16_22) * u_xlat16_5.xyz;
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_22 = min(max(u_xlat16_22, 0.0), 1.0);
#else
    u_xlat16_22 = clamp(u_xlat16_22, 0.0, 1.0);
#endif
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_18 = max(u_xlat16_4.x, 0.319999993);
    u_xlat16_4.x = dot(u_xlat16_5.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10.x = u_xlat16_22 * u_xlat16_22;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_16 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_22 = u_xlat16_16 * u_xlat16_16;
    u_xlat16_19 = u_xlat16_16 * u_xlat16_16 + 1.5;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_19;
    u_xlat16_19 = u_xlat16_22 * u_xlat16_22 + -1.0;
    u_xlat16_19 = u_xlat16_10.x * u_xlat16_19 + 1.00001001;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_19;
    u_xlat16_18 = u_xlat16_22 / u_xlat16_18;
    u_xlat16_18 = u_xlat16_18 + -9.99999975e-05;
    u_xlat16_10.x = max(u_xlat16_18, 0.0);
    u_xlat16_10.x = min(u_xlat16_10.x, 100.0);
    u_xlat16_10.xyz = u_xlat16_10.xxx * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat16_10.xyz = u_xlat0.xyz * u_xlat16_10.xyz;
    SV_Target0.xyz = u_xlat16_4.xxx * u_xlat16_10.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform lowp sampler2D _ShadowMapTexture;
uniform highp sampler2D _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
mediump vec3 u_xlat16_4;
mediump vec3 u_xlat16_5;
lowp float u_xlat10_6;
mediump vec3 u_xlat16_10;
mediump float u_xlat16_16;
float u_xlat18;
mediump float u_xlat16_18;
mediump float u_xlat16_19;
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
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat10_6 = texture(_ShadowMapTexture, u_xlat1.xy).x;
    u_xlat16_4.x = u_xlat0.x + u_xlat10_6;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat0.xy = u_xlat2.yy * hlslcc_mtx4x4unity_WorldToLight[1].xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_WorldToLight[0].xy * u_xlat2.xx + u_xlat0.xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_WorldToLight[2].xy * u_xlat2.ww + u_xlat0.xy;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat0.xy = u_xlat0.xy + hlslcc_mtx4x4unity_WorldToLight[3].xy;
    u_xlat0.x = texture(_LightTexture0, u_xlat0.xy, -8.0).w;
    u_xlat0.x = u_xlat0.x * u_xlat16_4.x;
    u_xlat0.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat18 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat18 = inversesqrt(u_xlat18);
    u_xlat16_4.xyz = (-u_xlat2.xyz) * vec3(u_xlat18) + (-_LightDir.xyz);
    u_xlat16_22 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_18 = max(u_xlat16_22, 0.00100000005);
    u_xlat16_22 = inversesqrt(u_xlat16_18);
    u_xlat16_4.xyz = vec3(u_xlat16_22) * u_xlat16_4.xyz;
    u_xlat10_2.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_2.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_22 = inversesqrt(u_xlat16_22);
    u_xlat16_5.xyz = vec3(u_xlat16_22) * u_xlat16_5.xyz;
    u_xlat16_22 = dot(u_xlat16_5.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_22 = min(max(u_xlat16_22, 0.0), 1.0);
#else
    u_xlat16_22 = clamp(u_xlat16_22, 0.0, 1.0);
#endif
    u_xlat16_4.x = dot((-_LightDir.xyz), u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_18 = max(u_xlat16_4.x, 0.319999993);
    u_xlat16_4.x = dot(u_xlat16_5.xyz, (-_LightDir.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_10.x = u_xlat16_22 * u_xlat16_22;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_16 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_22 = u_xlat16_16 * u_xlat16_16;
    u_xlat16_19 = u_xlat16_16 * u_xlat16_16 + 1.5;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_19;
    u_xlat16_19 = u_xlat16_22 * u_xlat16_22 + -1.0;
    u_xlat16_19 = u_xlat16_10.x * u_xlat16_19 + 1.00001001;
    u_xlat16_18 = u_xlat16_18 * u_xlat16_19;
    u_xlat16_18 = u_xlat16_22 / u_xlat16_18;
    u_xlat16_18 = u_xlat16_18 + -9.99999975e-05;
    u_xlat16_10.x = max(u_xlat16_18, 0.0);
    u_xlat16_10.x = min(u_xlat16_10.x, 100.0);
    u_xlat16_10.xyz = u_xlat16_10.xxx * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat16_10.xyz = u_xlat0.xyz * u_xlat16_10.xyz;
    SV_Target0.xyz = u_xlat16_4.xxx * u_xlat16_10.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_CUBE" "UNITY_HDR_ON" }
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
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w)));
  atten_5 = tmpvar_13.w;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  mediump float shadowVal_16;
  highp float mydist_17;
  mydist_17 = ((sqrt(
    dot (tmpvar_11, tmpvar_11)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_18;
  tmpvar_18 = textureCube (_ShadowMapTexture, tmpvar_11);
  highp vec4 vals_19;
  vals_19 = tmpvar_18;
  highp float tmpvar_20;
  tmpvar_20 = dot (vals_19, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVal_16 = tmpvar_20;
  mediump float tmpvar_21;
  if ((shadowVal_16 < mydist_17)) {
    tmpvar_21 = _LightShadowData.x;
  } else {
    tmpvar_21 = 1.0;
  };
  mediump float tmpvar_22;
  tmpvar_22 = clamp ((tmpvar_21 + tmpvar_14), 0.0, 1.0);
  atten_5 = (tmpvar_13.w * tmpvar_22);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_23;
  tmpvar_23 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_25;
  mediump vec3 tmpvar_26;
  tmpvar_26 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_27;
  tmpvar_27 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_28;
  viewDir_28 = -(tmpvar_27);
  mediump vec2 tmpvar_29;
  tmpvar_29.x = dot ((viewDir_28 - (2.0 * 
    (dot (tmpvar_26, viewDir_28) * tmpvar_26)
  )), lightDir_6);
  tmpvar_29.y = (1.0 - clamp (dot (tmpvar_26, viewDir_28), 0.0, 1.0));
  mediump float specular_30;
  mediump vec2 tmpvar_31;
  tmpvar_31.x = ((tmpvar_29 * tmpvar_29) * (tmpvar_29 * tmpvar_29)).x;
  tmpvar_31.y = (1.0 - gbuffer1_2.w);
  highp float tmpvar_32;
  tmpvar_32 = (texture2D (unity_NHxRoughness, tmpvar_31).w * 16.0);
  specular_30 = tmpvar_32;
  mediump vec4 tmpvar_33;
  tmpvar_33.w = 1.0;
  tmpvar_33.xyz = ((gbuffer0_3.xyz + (specular_30 * gbuffer1_2.xyz)) * (tmpvar_4 * clamp (
    dot (tmpvar_26, lightDir_6)
  , 0.0, 1.0)));
  gl_FragData[0] = tmpvar_33;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "POINT" "SHADOWS_CUBE" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform highp sampler2D unity_NHxRoughness;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
lowp vec4 u_xlat10_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
lowp vec4 u_xlat10_3;
mediump vec3 u_xlat16_4;
lowp vec3 u_xlat10_5;
mediump vec3 u_xlat16_6;
vec3 u_xlat7;
float u_xlat15;
bool u_xlatb15;
float u_xlat21;
float u_xlat22;
float u_xlat23;
mediump float u_xlat16_25;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat21 = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat21 = float(1.0) / u_xlat21;
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat21 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat7.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat10_3 = texture(_ShadowMapTexture, u_xlat7.xyz);
    u_xlat15 = dot(u_xlat10_3, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat22 = dot(u_xlat7.xyz, u_xlat7.xyz);
    u_xlat23 = sqrt(u_xlat22);
    u_xlat23 = u_xlat23 * _LightPositionRange.w;
    u_xlat23 = u_xlat23 * _LightProjectionParams.w;
#ifdef UNITY_ADRENO_ES3
    u_xlatb15 = !!(u_xlat15<u_xlat23);
#else
    u_xlatb15 = u_xlat15<u_xlat23;
#endif
    u_xlat16_4.x = (u_xlatb15) ? _LightShadowData.x : 1.0;
    u_xlat16_4.x = u_xlat0.x + u_xlat16_4.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat22 * _LightPos.w;
    u_xlat15 = inversesqrt(u_xlat22);
    u_xlat7.xyz = u_xlat7.xyz * vec3(u_xlat15);
    u_xlat0.x = texture(_LightTextureB0, u_xlat0.xx).w;
    u_xlat0.x = u_xlat16_4.x * u_xlat0.x;
    u_xlat3.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat10_5.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_4.xyz = u_xlat10_5.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_25 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_25 = inversesqrt(u_xlat16_25);
    u_xlat16_4.xyz = vec3(u_xlat16_25) * u_xlat16_4.xyz;
    u_xlat16_25 = dot(u_xlat16_4.xyz, (-u_xlat7.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_25 = min(max(u_xlat16_25, 0.0), 1.0);
#else
    u_xlat16_25 = clamp(u_xlat16_25, 0.0, 1.0);
#endif
    u_xlat16_6.xyz = u_xlat3.xyz * vec3(u_xlat16_25);
    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat2.xyz = u_xlat0.xxx * u_xlat2.xyz;
    u_xlat16_25 = dot((-u_xlat2.xyz), u_xlat16_4.xyz);
    u_xlat16_25 = u_xlat16_25 + u_xlat16_25;
    u_xlat16_4.xyz = u_xlat16_4.xyz * (-vec3(u_xlat16_25)) + (-u_xlat2.xyz);
    u_xlat16_4.x = dot(u_xlat16_4.xyz, (-u_xlat7.xyz));
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_4.x;
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_4.x;
    u_xlat10_0 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_4.y = (-u_xlat10_0.w) + 1.0;
    u_xlat21 = texture(unity_NHxRoughness, u_xlat16_4.xy).w;
    u_xlat21 = u_xlat21 * 16.0;
    u_xlat16_4.xyz = vec3(u_xlat21) * u_xlat10_0.xyz + u_xlat10_1.xyz;
    SV_Target0.xyz = u_xlat16_6.xyz * u_xlat16_4.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" "UNITY_HDR_ON" }
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
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w)));
  atten_5 = tmpvar_13.w;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  mediump float shadowVal_16;
  highp float mydist_17;
  mydist_17 = ((sqrt(
    dot (tmpvar_11, tmpvar_11)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_18;
  tmpvar_18 = textureCube (_ShadowMapTexture, tmpvar_11);
  highp vec4 vals_19;
  vals_19 = tmpvar_18;
  highp float tmpvar_20;
  tmpvar_20 = dot (vals_19, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVal_16 = tmpvar_20;
  mediump float tmpvar_21;
  if ((shadowVal_16 < mydist_17)) {
    tmpvar_21 = _LightShadowData.x;
  } else {
    tmpvar_21 = 1.0;
  };
  mediump float tmpvar_22;
  tmpvar_22 = clamp ((tmpvar_21 + tmpvar_14), 0.0, 1.0);
  atten_5 = (tmpvar_13.w * tmpvar_22);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_23;
  tmpvar_23 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_25;
  mediump vec3 tmpvar_26;
  tmpvar_26 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_27;
  tmpvar_27 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_28;
  viewDir_28 = -(tmpvar_27);
  mediump float specularTerm_29;
  mediump vec3 tmpvar_30;
  mediump vec3 inVec_31;
  inVec_31 = (lightDir_6 + viewDir_28);
  tmpvar_30 = (inVec_31 * inversesqrt(max (0.001, 
    dot (inVec_31, inVec_31)
  )));
  mediump float tmpvar_32;
  tmpvar_32 = clamp (dot (tmpvar_26, tmpvar_30), 0.0, 1.0);
  mediump float tmpvar_33;
  tmpvar_33 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_34;
  tmpvar_34 = (tmpvar_33 * tmpvar_33);
  specularTerm_29 = ((tmpvar_34 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_30), 0.0, 1.0)) * (1.5 + tmpvar_34))
   * 
    (((tmpvar_32 * tmpvar_32) * ((tmpvar_34 * tmpvar_34) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_35;
  tmpvar_35 = clamp (specularTerm_29, 0.0, 100.0);
  specularTerm_29 = tmpvar_35;
  mediump vec4 tmpvar_36;
  tmpvar_36.w = 1.0;
  tmpvar_36.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_35 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_26, lightDir_6), 0.0, 1.0));
  gl_FragData[0] = tmpvar_36;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" "UNITY_HDR_ON" }
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
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w)));
  atten_5 = tmpvar_13.w;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  mediump float shadowVal_16;
  highp float mydist_17;
  mydist_17 = ((sqrt(
    dot (tmpvar_11, tmpvar_11)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_18;
  tmpvar_18 = textureCube (_ShadowMapTexture, tmpvar_11);
  highp vec4 vals_19;
  vals_19 = tmpvar_18;
  highp float tmpvar_20;
  tmpvar_20 = dot (vals_19, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVal_16 = tmpvar_20;
  mediump float tmpvar_21;
  if ((shadowVal_16 < mydist_17)) {
    tmpvar_21 = _LightShadowData.x;
  } else {
    tmpvar_21 = 1.0;
  };
  mediump float tmpvar_22;
  tmpvar_22 = clamp ((tmpvar_21 + tmpvar_14), 0.0, 1.0);
  atten_5 = (tmpvar_13.w * tmpvar_22);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_23;
  tmpvar_23 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_23;
  lowp vec4 tmpvar_24;
  tmpvar_24 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_24;
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_25;
  mediump vec3 tmpvar_26;
  tmpvar_26 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_27;
  tmpvar_27 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_28;
  viewDir_28 = -(tmpvar_27);
  mediump float specularTerm_29;
  mediump vec3 tmpvar_30;
  mediump vec3 inVec_31;
  inVec_31 = (lightDir_6 + viewDir_28);
  tmpvar_30 = (inVec_31 * inversesqrt(max (0.001, 
    dot (inVec_31, inVec_31)
  )));
  mediump float tmpvar_32;
  tmpvar_32 = clamp (dot (tmpvar_26, tmpvar_30), 0.0, 1.0);
  mediump float tmpvar_33;
  tmpvar_33 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_34;
  tmpvar_34 = (tmpvar_33 * tmpvar_33);
  specularTerm_29 = ((tmpvar_34 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_30), 0.0, 1.0)) * (1.5 + tmpvar_34))
   * 
    (((tmpvar_32 * tmpvar_32) * ((tmpvar_34 * tmpvar_34) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_35;
  tmpvar_35 = clamp (specularTerm_29, 0.0, 100.0);
  specularTerm_29 = tmpvar_35;
  mediump vec4 tmpvar_36;
  tmpvar_36.w = 1.0;
  tmpvar_36.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_35 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_26, lightDir_6), 0.0, 1.0));
  gl_FragData[0] = tmpvar_36;
}


#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
mediump float u_xlat16_0;
bool u_xlatb0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
lowp vec3 u_xlat10_3;
vec3 u_xlat4;
lowp vec4 u_xlat10_4;
mediump vec4 u_xlat16_5;
mediump vec3 u_xlat16_6;
float u_xlat7;
mediump float u_xlat16_12;
float u_xlat14;
mediump float u_xlat16_19;
float u_xlat21;
mediump float u_xlat16_22;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat21 = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat21 = float(1.0) / u_xlat21;
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat4.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7 = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat7 = sqrt(u_xlat7);
    u_xlat7 = (-u_xlat0.z) * u_xlat21 + u_xlat7;
    u_xlat7 = unity_ShadowFadeCenterAndType.w * u_xlat7 + u_xlat2.z;
    u_xlat7 = u_xlat7 * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat7 = min(max(u_xlat7, 0.0), 1.0);
#else
    u_xlat7 = clamp(u_xlat7, 0.0, 1.0);
#endif
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat21 = inversesqrt(u_xlat14);
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat4.xyz;
    u_xlat10_4 = texture(_ShadowMapTexture, u_xlat4.xyz);
    u_xlat21 = dot(u_xlat10_4, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat16_5.xyz = (-u_xlat3.xyz) * u_xlat0.xxx + (-u_xlat2.xyz);
    u_xlat16_26 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_0 = max(u_xlat16_26, 0.00100000005);
    u_xlat16_26 = inversesqrt(u_xlat16_0);
    u_xlat16_5.xyz = vec3(u_xlat16_26) * u_xlat16_5.xyz;
    u_xlat10_3.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_3.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_26 = inversesqrt(u_xlat16_26);
    u_xlat16_6.xyz = vec3(u_xlat16_26) * u_xlat16_6.xyz;
    u_xlat16_26 = dot(u_xlat16_6.xyz, u_xlat16_5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_26 = min(max(u_xlat16_26, 0.0), 1.0);
#else
    u_xlat16_26 = clamp(u_xlat16_26, 0.0, 1.0);
#endif
    u_xlat16_5.x = dot((-u_xlat2.xyz), u_xlat16_5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat16_12 = dot(u_xlat16_6.xyz, (-u_xlat2.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_12 = min(max(u_xlat16_12, 0.0), 1.0);
#else
    u_xlat16_12 = clamp(u_xlat16_12, 0.0, 1.0);
#endif
    u_xlat16_0 = max(u_xlat16_5.x, 0.319999993);
    u_xlat16_5.x = u_xlat16_26 * u_xlat16_26;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_19 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_26 = u_xlat16_19 * u_xlat16_19;
    u_xlat16_22 = u_xlat16_19 * u_xlat16_19 + 1.5;
    u_xlat16_0 = u_xlat16_0 * u_xlat16_22;
    u_xlat16_22 = u_xlat16_26 * u_xlat16_26 + -1.0;
    u_xlat16_22 = u_xlat16_5.x * u_xlat16_22 + 1.00001001;
    u_xlat16_0 = u_xlat16_0 * u_xlat16_22;
    u_xlat16_0 = u_xlat16_26 / u_xlat16_0;
    u_xlat16_0 = u_xlat16_0 + -9.99999975e-05;
    u_xlat16_5.x = max(u_xlat16_0, 0.0);
    u_xlat16_5.x = min(u_xlat16_5.x, 100.0);
    u_xlat16_5.xzw = u_xlat16_5.xxx * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat0.x = sqrt(u_xlat14);
    u_xlat14 = u_xlat14 * _LightPos.w;
    u_xlat14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat0.x = u_xlat0.x * _LightPositionRange.w;
    u_xlat0.x = u_xlat0.x * _LightProjectionParams.w;
#ifdef UNITY_ADRENO_ES3
    u_xlatb0 = !!(u_xlat21<u_xlat0.x);
#else
    u_xlatb0 = u_xlat21<u_xlat0.x;
#endif
    u_xlat16_6.x = (u_xlatb0) ? _LightShadowData.x : 1.0;
    u_xlat16_6.x = u_xlat7 + u_xlat16_6.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_6.x = min(max(u_xlat16_6.x, 0.0), 1.0);
#else
    u_xlat16_6.x = clamp(u_xlat16_6.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat14 * u_xlat16_6.x;
    u_xlat0.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat16_5.xzw = u_xlat0.xyz * u_xlat16_5.xzw;
    SV_Target0.xyz = vec3(u_xlat16_12) * u_xlat16_5.xzw;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
mediump float u_xlat16_0;
bool u_xlatb0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
lowp vec3 u_xlat10_3;
vec3 u_xlat4;
lowp vec4 u_xlat10_4;
mediump vec4 u_xlat16_5;
mediump vec3 u_xlat16_6;
float u_xlat7;
mediump float u_xlat16_12;
float u_xlat14;
mediump float u_xlat16_19;
float u_xlat21;
mediump float u_xlat16_22;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat21 = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat21 = float(1.0) / u_xlat21;
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat4.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat2.xyw = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat7 = dot(u_xlat2.xyw, u_xlat2.xyw);
    u_xlat7 = sqrt(u_xlat7);
    u_xlat7 = (-u_xlat0.z) * u_xlat21 + u_xlat7;
    u_xlat7 = unity_ShadowFadeCenterAndType.w * u_xlat7 + u_xlat2.z;
    u_xlat7 = u_xlat7 * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat7 = min(max(u_xlat7, 0.0), 1.0);
#else
    u_xlat7 = clamp(u_xlat7, 0.0, 1.0);
#endif
    u_xlat14 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat21 = inversesqrt(u_xlat14);
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat4.xyz;
    u_xlat10_4 = texture(_ShadowMapTexture, u_xlat4.xyz);
    u_xlat21 = dot(u_xlat10_4, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat16_5.xyz = (-u_xlat3.xyz) * u_xlat0.xxx + (-u_xlat2.xyz);
    u_xlat16_26 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_0 = max(u_xlat16_26, 0.00100000005);
    u_xlat16_26 = inversesqrt(u_xlat16_0);
    u_xlat16_5.xyz = vec3(u_xlat16_26) * u_xlat16_5.xyz;
    u_xlat10_3.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_3.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_26 = inversesqrt(u_xlat16_26);
    u_xlat16_6.xyz = vec3(u_xlat16_26) * u_xlat16_6.xyz;
    u_xlat16_26 = dot(u_xlat16_6.xyz, u_xlat16_5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_26 = min(max(u_xlat16_26, 0.0), 1.0);
#else
    u_xlat16_26 = clamp(u_xlat16_26, 0.0, 1.0);
#endif
    u_xlat16_5.x = dot((-u_xlat2.xyz), u_xlat16_5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat16_12 = dot(u_xlat16_6.xyz, (-u_xlat2.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_12 = min(max(u_xlat16_12, 0.0), 1.0);
#else
    u_xlat16_12 = clamp(u_xlat16_12, 0.0, 1.0);
#endif
    u_xlat16_0 = max(u_xlat16_5.x, 0.319999993);
    u_xlat16_5.x = u_xlat16_26 * u_xlat16_26;
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_19 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_26 = u_xlat16_19 * u_xlat16_19;
    u_xlat16_22 = u_xlat16_19 * u_xlat16_19 + 1.5;
    u_xlat16_0 = u_xlat16_0 * u_xlat16_22;
    u_xlat16_22 = u_xlat16_26 * u_xlat16_26 + -1.0;
    u_xlat16_22 = u_xlat16_5.x * u_xlat16_22 + 1.00001001;
    u_xlat16_0 = u_xlat16_0 * u_xlat16_22;
    u_xlat16_0 = u_xlat16_26 / u_xlat16_0;
    u_xlat16_0 = u_xlat16_0 + -9.99999975e-05;
    u_xlat16_5.x = max(u_xlat16_0, 0.0);
    u_xlat16_5.x = min(u_xlat16_5.x, 100.0);
    u_xlat16_5.xzw = u_xlat16_5.xxx * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat0.x = sqrt(u_xlat14);
    u_xlat14 = u_xlat14 * _LightPos.w;
    u_xlat14 = texture(_LightTextureB0, vec2(u_xlat14)).w;
    u_xlat0.x = u_xlat0.x * _LightPositionRange.w;
    u_xlat0.x = u_xlat0.x * _LightProjectionParams.w;
#ifdef UNITY_ADRENO_ES3
    u_xlatb0 = !!(u_xlat21<u_xlat0.x);
#else
    u_xlatb0 = u_xlat21<u_xlat0.x;
#endif
    u_xlat16_6.x = (u_xlatb0) ? _LightShadowData.x : 1.0;
    u_xlat16_6.x = u_xlat7 + u_xlat16_6.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_6.x = min(max(u_xlat16_6.x, 0.0), 1.0);
#else
    u_xlat16_6.x = clamp(u_xlat16_6.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat14 * u_xlat16_6.x;
    u_xlat0.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat16_5.xzw = u_xlat0.xyz * u_xlat16_5.xzw;
    SV_Target0.xyz = vec3(u_xlat16_12) * u_xlat16_5.xzw;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w)));
  atten_5 = tmpvar_13.w;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  highp vec4 shadowVals_16;
  highp float mydist_17;
  mydist_17 = ((sqrt(
    dot (tmpvar_11, tmpvar_11)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_18;
  tmpvar_18.w = 0.0;
  tmpvar_18.xyz = (tmpvar_11 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_18.xyz, 0.0);
  tmpvar_19 = tmpvar_20;
  shadowVals_16.x = dot (tmpvar_19, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_21;
  tmpvar_21.w = 0.0;
  tmpvar_21.xyz = (tmpvar_11 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_22;
  lowp vec4 tmpvar_23;
  tmpvar_23 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_21.xyz, 0.0);
  tmpvar_22 = tmpvar_23;
  shadowVals_16.y = dot (tmpvar_22, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_24;
  tmpvar_24.w = 0.0;
  tmpvar_24.xyz = (tmpvar_11 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_24.xyz, 0.0);
  tmpvar_25 = tmpvar_26;
  shadowVals_16.z = dot (tmpvar_25, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_27;
  tmpvar_27.w = 0.0;
  tmpvar_27.xyz = (tmpvar_11 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_27.xyz, 0.0);
  tmpvar_28 = tmpvar_29;
  shadowVals_16.w = dot (tmpvar_28, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_30;
  tmpvar_30 = lessThan (shadowVals_16, vec4(mydist_17));
  mediump vec4 tmpvar_31;
  tmpvar_31 = _LightShadowData.xxxx;
  mediump float tmpvar_32;
  if (tmpvar_30.x) {
    tmpvar_32 = tmpvar_31.x;
  } else {
    tmpvar_32 = 1.0;
  };
  mediump float tmpvar_33;
  if (tmpvar_30.y) {
    tmpvar_33 = tmpvar_31.y;
  } else {
    tmpvar_33 = 1.0;
  };
  mediump float tmpvar_34;
  if (tmpvar_30.z) {
    tmpvar_34 = tmpvar_31.z;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_30.w) {
    tmpvar_35 = tmpvar_31.w;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump vec4 tmpvar_36;
  tmpvar_36.x = tmpvar_32;
  tmpvar_36.y = tmpvar_33;
  tmpvar_36.z = tmpvar_34;
  tmpvar_36.w = tmpvar_35;
  mediump float tmpvar_37;
  tmpvar_37 = clamp ((dot (tmpvar_36, vec4(0.25, 0.25, 0.25, 0.25)) + tmpvar_14), 0.0, 1.0);
  atten_5 = (tmpvar_13.w * tmpvar_37);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_38;
  tmpvar_38 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_38;
  lowp vec4 tmpvar_39;
  tmpvar_39 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_39;
  lowp vec4 tmpvar_40;
  tmpvar_40 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_40;
  mediump vec3 tmpvar_41;
  tmpvar_41 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_42;
  tmpvar_42 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_43;
  viewDir_43 = -(tmpvar_42);
  mediump vec2 tmpvar_44;
  tmpvar_44.x = dot ((viewDir_43 - (2.0 * 
    (dot (tmpvar_41, viewDir_43) * tmpvar_41)
  )), lightDir_6);
  tmpvar_44.y = (1.0 - clamp (dot (tmpvar_41, viewDir_43), 0.0, 1.0));
  mediump float specular_45;
  mediump vec2 tmpvar_46;
  tmpvar_46.x = ((tmpvar_44 * tmpvar_44) * (tmpvar_44 * tmpvar_44)).x;
  tmpvar_46.y = (1.0 - gbuffer1_2.w);
  highp float tmpvar_47;
  tmpvar_47 = (texture2D (unity_NHxRoughness, tmpvar_46).w * 16.0);
  specular_45 = tmpvar_47;
  mediump vec4 tmpvar_48;
  tmpvar_48.w = 1.0;
  tmpvar_48.xyz = ((gbuffer0_3.xyz + (specular_45 * gbuffer1_2.xyz)) * (tmpvar_4 * clamp (
    dot (tmpvar_41, lightDir_6)
  , 0.0, 1.0)));
  gl_FragData[0] = tmpvar_48;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform highp sampler2D unity_NHxRoughness;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
lowp vec4 u_xlat10_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
vec4 u_xlat3;
lowp vec4 u_xlat10_3;
bvec4 u_xlatb3;
vec3 u_xlat4;
lowp vec4 u_xlat10_4;
mediump vec3 u_xlat16_5;
mediump vec3 u_xlat16_6;
vec3 u_xlat7;
float u_xlat15;
float u_xlat21;
float u_xlat22;
mediump float u_xlat16_26;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat21 = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat21 = float(1.0) / u_xlat21;
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat21 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat7.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat3.xyz = u_xlat7.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
    u_xlat10_3 = textureLod(_ShadowMapTexture, u_xlat3.xyz, 0.0);
    u_xlat3.x = dot(u_xlat10_3, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat4.xyz = u_xlat7.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
    u_xlat10_4 = textureLod(_ShadowMapTexture, u_xlat4.xyz, 0.0);
    u_xlat3.y = dot(u_xlat10_4, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat4.xyz = u_xlat7.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
    u_xlat10_4 = textureLod(_ShadowMapTexture, u_xlat4.xyz, 0.0);
    u_xlat3.z = dot(u_xlat10_4, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat4.xyz = u_xlat7.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
    u_xlat10_4 = textureLod(_ShadowMapTexture, u_xlat4.xyz, 0.0);
    u_xlat3.w = dot(u_xlat10_4, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat15 = dot(u_xlat7.xyz, u_xlat7.xyz);
    u_xlat22 = sqrt(u_xlat15);
    u_xlat22 = u_xlat22 * _LightPositionRange.w;
    u_xlat22 = u_xlat22 * _LightProjectionParams.w;
    u_xlatb3 = lessThan(u_xlat3, vec4(u_xlat22));
    u_xlat3.x = (u_xlatb3.x) ? _LightShadowData.x : float(1.0);
    u_xlat3.y = (u_xlatb3.y) ? _LightShadowData.x : float(1.0);
    u_xlat3.z = (u_xlatb3.z) ? _LightShadowData.x : float(1.0);
    u_xlat3.w = (u_xlatb3.w) ? _LightShadowData.x : float(1.0);
    u_xlat16_5.x = dot(u_xlat3, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat16_5.x = u_xlat0.x + u_xlat16_5.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat15 * _LightPos.w;
    u_xlat15 = inversesqrt(u_xlat15);
    u_xlat7.xyz = u_xlat7.xyz * vec3(u_xlat15);
    u_xlat0.x = texture(_LightTextureB0, u_xlat0.xx).w;
    u_xlat0.x = u_xlat16_5.x * u_xlat0.x;
    u_xlat3.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat10_4.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_5.xyz = u_xlat10_4.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_26 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_26 = inversesqrt(u_xlat16_26);
    u_xlat16_5.xyz = vec3(u_xlat16_26) * u_xlat16_5.xyz;
    u_xlat16_26 = dot(u_xlat16_5.xyz, (-u_xlat7.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_26 = min(max(u_xlat16_26, 0.0), 1.0);
#else
    u_xlat16_26 = clamp(u_xlat16_26, 0.0, 1.0);
#endif
    u_xlat16_6.xyz = u_xlat3.xyz * vec3(u_xlat16_26);
    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat2.xyz = u_xlat0.xxx * u_xlat2.xyz;
    u_xlat16_26 = dot((-u_xlat2.xyz), u_xlat16_5.xyz);
    u_xlat16_26 = u_xlat16_26 + u_xlat16_26;
    u_xlat16_5.xyz = u_xlat16_5.xyz * (-vec3(u_xlat16_26)) + (-u_xlat2.xyz);
    u_xlat16_5.x = dot(u_xlat16_5.xyz, (-u_xlat7.xyz));
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_5.x;
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_5.x;
    u_xlat10_0 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_5.y = (-u_xlat10_0.w) + 1.0;
    u_xlat21 = texture(unity_NHxRoughness, u_xlat16_5.xy).w;
    u_xlat21 = u_xlat21 * 16.0;
    u_xlat16_5.xyz = vec3(u_xlat21) * u_xlat10_0.xyz + u_xlat10_1.xyz;
    SV_Target0.xyz = u_xlat16_6.xyz * u_xlat16_5.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w)));
  atten_5 = tmpvar_13.w;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  highp vec4 shadowVals_16;
  highp float mydist_17;
  mydist_17 = ((sqrt(
    dot (tmpvar_11, tmpvar_11)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_18;
  tmpvar_18.w = 0.0;
  tmpvar_18.xyz = (tmpvar_11 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_18.xyz, 0.0);
  tmpvar_19 = tmpvar_20;
  shadowVals_16.x = dot (tmpvar_19, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_21;
  tmpvar_21.w = 0.0;
  tmpvar_21.xyz = (tmpvar_11 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_22;
  lowp vec4 tmpvar_23;
  tmpvar_23 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_21.xyz, 0.0);
  tmpvar_22 = tmpvar_23;
  shadowVals_16.y = dot (tmpvar_22, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_24;
  tmpvar_24.w = 0.0;
  tmpvar_24.xyz = (tmpvar_11 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_24.xyz, 0.0);
  tmpvar_25 = tmpvar_26;
  shadowVals_16.z = dot (tmpvar_25, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_27;
  tmpvar_27.w = 0.0;
  tmpvar_27.xyz = (tmpvar_11 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_27.xyz, 0.0);
  tmpvar_28 = tmpvar_29;
  shadowVals_16.w = dot (tmpvar_28, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_30;
  tmpvar_30 = lessThan (shadowVals_16, vec4(mydist_17));
  mediump vec4 tmpvar_31;
  tmpvar_31 = _LightShadowData.xxxx;
  mediump float tmpvar_32;
  if (tmpvar_30.x) {
    tmpvar_32 = tmpvar_31.x;
  } else {
    tmpvar_32 = 1.0;
  };
  mediump float tmpvar_33;
  if (tmpvar_30.y) {
    tmpvar_33 = tmpvar_31.y;
  } else {
    tmpvar_33 = 1.0;
  };
  mediump float tmpvar_34;
  if (tmpvar_30.z) {
    tmpvar_34 = tmpvar_31.z;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_30.w) {
    tmpvar_35 = tmpvar_31.w;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump vec4 tmpvar_36;
  tmpvar_36.x = tmpvar_32;
  tmpvar_36.y = tmpvar_33;
  tmpvar_36.z = tmpvar_34;
  tmpvar_36.w = tmpvar_35;
  mediump float tmpvar_37;
  tmpvar_37 = clamp ((dot (tmpvar_36, vec4(0.25, 0.25, 0.25, 0.25)) + tmpvar_14), 0.0, 1.0);
  atten_5 = (tmpvar_13.w * tmpvar_37);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_38;
  tmpvar_38 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_38;
  lowp vec4 tmpvar_39;
  tmpvar_39 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_39;
  lowp vec4 tmpvar_40;
  tmpvar_40 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_40;
  mediump vec3 tmpvar_41;
  tmpvar_41 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_42;
  tmpvar_42 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_43;
  viewDir_43 = -(tmpvar_42);
  mediump float specularTerm_44;
  mediump vec3 tmpvar_45;
  mediump vec3 inVec_46;
  inVec_46 = (lightDir_6 + viewDir_43);
  tmpvar_45 = (inVec_46 * inversesqrt(max (0.001, 
    dot (inVec_46, inVec_46)
  )));
  mediump float tmpvar_47;
  tmpvar_47 = clamp (dot (tmpvar_41, tmpvar_45), 0.0, 1.0);
  mediump float tmpvar_48;
  tmpvar_48 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_49;
  tmpvar_49 = (tmpvar_48 * tmpvar_48);
  specularTerm_44 = ((tmpvar_49 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_45), 0.0, 1.0)) * (1.5 + tmpvar_49))
   * 
    (((tmpvar_47 * tmpvar_47) * ((tmpvar_49 * tmpvar_49) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_50;
  tmpvar_50 = clamp (specularTerm_44, 0.0, 100.0);
  specularTerm_44 = tmpvar_50;
  mediump vec4 tmpvar_51;
  tmpvar_51.w = 1.0;
  tmpvar_51.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_50 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_41, lightDir_6), 0.0, 1.0));
  gl_FragData[0] = tmpvar_51;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform highp sampler2D _LightTextureB0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w)));
  atten_5 = tmpvar_13.w;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  highp vec4 shadowVals_16;
  highp float mydist_17;
  mydist_17 = ((sqrt(
    dot (tmpvar_11, tmpvar_11)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_18;
  tmpvar_18.w = 0.0;
  tmpvar_18.xyz = (tmpvar_11 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_18.xyz, 0.0);
  tmpvar_19 = tmpvar_20;
  shadowVals_16.x = dot (tmpvar_19, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_21;
  tmpvar_21.w = 0.0;
  tmpvar_21.xyz = (tmpvar_11 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_22;
  lowp vec4 tmpvar_23;
  tmpvar_23 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_21.xyz, 0.0);
  tmpvar_22 = tmpvar_23;
  shadowVals_16.y = dot (tmpvar_22, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_24;
  tmpvar_24.w = 0.0;
  tmpvar_24.xyz = (tmpvar_11 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_24.xyz, 0.0);
  tmpvar_25 = tmpvar_26;
  shadowVals_16.z = dot (tmpvar_25, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_27;
  tmpvar_27.w = 0.0;
  tmpvar_27.xyz = (tmpvar_11 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_27.xyz, 0.0);
  tmpvar_28 = tmpvar_29;
  shadowVals_16.w = dot (tmpvar_28, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_30;
  tmpvar_30 = lessThan (shadowVals_16, vec4(mydist_17));
  mediump vec4 tmpvar_31;
  tmpvar_31 = _LightShadowData.xxxx;
  mediump float tmpvar_32;
  if (tmpvar_30.x) {
    tmpvar_32 = tmpvar_31.x;
  } else {
    tmpvar_32 = 1.0;
  };
  mediump float tmpvar_33;
  if (tmpvar_30.y) {
    tmpvar_33 = tmpvar_31.y;
  } else {
    tmpvar_33 = 1.0;
  };
  mediump float tmpvar_34;
  if (tmpvar_30.z) {
    tmpvar_34 = tmpvar_31.z;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_30.w) {
    tmpvar_35 = tmpvar_31.w;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump vec4 tmpvar_36;
  tmpvar_36.x = tmpvar_32;
  tmpvar_36.y = tmpvar_33;
  tmpvar_36.z = tmpvar_34;
  tmpvar_36.w = tmpvar_35;
  mediump float tmpvar_37;
  tmpvar_37 = clamp ((dot (tmpvar_36, vec4(0.25, 0.25, 0.25, 0.25)) + tmpvar_14), 0.0, 1.0);
  atten_5 = (tmpvar_13.w * tmpvar_37);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_38;
  tmpvar_38 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_38;
  lowp vec4 tmpvar_39;
  tmpvar_39 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_39;
  lowp vec4 tmpvar_40;
  tmpvar_40 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_40;
  mediump vec3 tmpvar_41;
  tmpvar_41 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_42;
  tmpvar_42 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_43;
  viewDir_43 = -(tmpvar_42);
  mediump float specularTerm_44;
  mediump vec3 tmpvar_45;
  mediump vec3 inVec_46;
  inVec_46 = (lightDir_6 + viewDir_43);
  tmpvar_45 = (inVec_46 * inversesqrt(max (0.001, 
    dot (inVec_46, inVec_46)
  )));
  mediump float tmpvar_47;
  tmpvar_47 = clamp (dot (tmpvar_41, tmpvar_45), 0.0, 1.0);
  mediump float tmpvar_48;
  tmpvar_48 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_49;
  tmpvar_49 = (tmpvar_48 * tmpvar_48);
  specularTerm_44 = ((tmpvar_49 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_45), 0.0, 1.0)) * (1.5 + tmpvar_49))
   * 
    (((tmpvar_47 * tmpvar_47) * ((tmpvar_49 * tmpvar_49) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_50;
  tmpvar_50 = clamp (specularTerm_44, 0.0, 100.0);
  specularTerm_44 = tmpvar_50;
  mediump vec4 tmpvar_51;
  tmpvar_51.w = 1.0;
  tmpvar_51.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_50 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_41, lightDir_6), 0.0, 1.0));
  gl_FragData[0] = tmpvar_51;
}


#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
mediump float u_xlat16_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec4 u_xlat3;
lowp vec4 u_xlat10_3;
bvec4 u_xlatb3;
vec3 u_xlat4;
lowp vec4 u_xlat10_4;
mediump vec4 u_xlat16_5;
mediump vec3 u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_7;
mediump float u_xlat16_12;
float u_xlat15;
mediump float u_xlat16_15;
float u_xlat21;
float u_xlat22;
mediump float u_xlat16_26;
mediump float u_xlat16_27;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat21 = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat21 = float(1.0) / u_xlat21;
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat21 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat7.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat3.xyz = u_xlat7.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
    u_xlat10_3 = textureLod(_ShadowMapTexture, u_xlat3.xyz, 0.0);
    u_xlat3.x = dot(u_xlat10_3, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat4.xyz = u_xlat7.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
    u_xlat10_4 = textureLod(_ShadowMapTexture, u_xlat4.xyz, 0.0);
    u_xlat3.y = dot(u_xlat10_4, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat4.xyz = u_xlat7.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
    u_xlat10_4 = textureLod(_ShadowMapTexture, u_xlat4.xyz, 0.0);
    u_xlat3.z = dot(u_xlat10_4, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat4.xyz = u_xlat7.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
    u_xlat10_4 = textureLod(_ShadowMapTexture, u_xlat4.xyz, 0.0);
    u_xlat3.w = dot(u_xlat10_4, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat15 = dot(u_xlat7.xyz, u_xlat7.xyz);
    u_xlat22 = sqrt(u_xlat15);
    u_xlat22 = u_xlat22 * _LightPositionRange.w;
    u_xlat22 = u_xlat22 * _LightProjectionParams.w;
    u_xlatb3 = lessThan(u_xlat3, vec4(u_xlat22));
    u_xlat3.x = (u_xlatb3.x) ? _LightShadowData.x : float(1.0);
    u_xlat3.y = (u_xlatb3.y) ? _LightShadowData.x : float(1.0);
    u_xlat3.z = (u_xlatb3.z) ? _LightShadowData.x : float(1.0);
    u_xlat3.w = (u_xlatb3.w) ? _LightShadowData.x : float(1.0);
    u_xlat16_5.x = dot(u_xlat3, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat16_5.x = u_xlat0.x + u_xlat16_5.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat15 * _LightPos.w;
    u_xlat15 = inversesqrt(u_xlat15);
    u_xlat7.xyz = u_xlat7.xyz * vec3(u_xlat15);
    u_xlat0.x = texture(_LightTextureB0, u_xlat0.xx).w;
    u_xlat0.x = u_xlat16_5.x * u_xlat0.x;
    u_xlat3.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat16_5.xyz = (-u_xlat2.xyz) * u_xlat0.xxx + (-u_xlat7.xyz);
    u_xlat16_26 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_0 = max(u_xlat16_26, 0.00100000005);
    u_xlat16_26 = inversesqrt(u_xlat16_0);
    u_xlat16_5.xyz = vec3(u_xlat16_26) * u_xlat16_5.xyz;
    u_xlat16_26 = dot((-u_xlat7.xyz), u_xlat16_5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_26 = min(max(u_xlat16_26, 0.0), 1.0);
#else
    u_xlat16_26 = clamp(u_xlat16_26, 0.0, 1.0);
#endif
    u_xlat16_0 = max(u_xlat16_26, 0.319999993);
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat16_26 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_15 = u_xlat16_26 * u_xlat16_26 + 1.5;
    u_xlat16_26 = u_xlat16_26 * u_xlat16_26;
    u_xlat16_0 = u_xlat16_0 * u_xlat16_15;
    u_xlat10_4.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_4.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_27 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_27 = inversesqrt(u_xlat16_27);
    u_xlat16_6.xyz = vec3(u_xlat16_27) * u_xlat16_6.xyz;
    u_xlat16_5.x = dot(u_xlat16_6.xyz, u_xlat16_5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat16_12 = dot(u_xlat16_6.xyz, (-u_xlat7.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_12 = min(max(u_xlat16_12, 0.0), 1.0);
#else
    u_xlat16_12 = clamp(u_xlat16_12, 0.0, 1.0);
#endif
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_5.x;
    u_xlat16_7 = u_xlat16_26 * u_xlat16_26 + -1.0;
    u_xlat16_7 = u_xlat16_5.x * u_xlat16_7 + 1.00001001;
    u_xlat16_0 = u_xlat16_7 * u_xlat16_0;
    u_xlat16_0 = u_xlat16_26 / u_xlat16_0;
    u_xlat16_0 = u_xlat16_0 + -9.99999975e-05;
    u_xlat16_5.x = max(u_xlat16_0, 0.0);
    u_xlat16_5.x = min(u_xlat16_5.x, 100.0);
    u_xlat16_5.xzw = u_xlat16_5.xxx * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat16_5.xzw = u_xlat3.xyz * u_xlat16_5.xzw;
    SV_Target0.xyz = vec3(u_xlat16_12) * u_xlat16_5.xzw;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
mediump float u_xlat16_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec4 u_xlat3;
lowp vec4 u_xlat10_3;
bvec4 u_xlatb3;
vec3 u_xlat4;
lowp vec4 u_xlat10_4;
mediump vec4 u_xlat16_5;
mediump vec3 u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_7;
mediump float u_xlat16_12;
float u_xlat15;
mediump float u_xlat16_15;
float u_xlat21;
float u_xlat22;
mediump float u_xlat16_26;
mediump float u_xlat16_27;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat21 = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat21 = float(1.0) / u_xlat21;
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat21 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat7.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat3.xyz = u_xlat7.xyz + vec3(0.0078125, 0.0078125, 0.0078125);
    u_xlat10_3 = textureLod(_ShadowMapTexture, u_xlat3.xyz, 0.0);
    u_xlat3.x = dot(u_xlat10_3, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat4.xyz = u_xlat7.xyz + vec3(-0.0078125, -0.0078125, 0.0078125);
    u_xlat10_4 = textureLod(_ShadowMapTexture, u_xlat4.xyz, 0.0);
    u_xlat3.y = dot(u_xlat10_4, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat4.xyz = u_xlat7.xyz + vec3(-0.0078125, 0.0078125, -0.0078125);
    u_xlat10_4 = textureLod(_ShadowMapTexture, u_xlat4.xyz, 0.0);
    u_xlat3.z = dot(u_xlat10_4, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat4.xyz = u_xlat7.xyz + vec3(0.0078125, -0.0078125, -0.0078125);
    u_xlat10_4 = textureLod(_ShadowMapTexture, u_xlat4.xyz, 0.0);
    u_xlat3.w = dot(u_xlat10_4, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat15 = dot(u_xlat7.xyz, u_xlat7.xyz);
    u_xlat22 = sqrt(u_xlat15);
    u_xlat22 = u_xlat22 * _LightPositionRange.w;
    u_xlat22 = u_xlat22 * _LightProjectionParams.w;
    u_xlatb3 = lessThan(u_xlat3, vec4(u_xlat22));
    u_xlat3.x = (u_xlatb3.x) ? _LightShadowData.x : float(1.0);
    u_xlat3.y = (u_xlatb3.y) ? _LightShadowData.x : float(1.0);
    u_xlat3.z = (u_xlatb3.z) ? _LightShadowData.x : float(1.0);
    u_xlat3.w = (u_xlatb3.w) ? _LightShadowData.x : float(1.0);
    u_xlat16_5.x = dot(u_xlat3, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat16_5.x = u_xlat0.x + u_xlat16_5.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat15 * _LightPos.w;
    u_xlat15 = inversesqrt(u_xlat15);
    u_xlat7.xyz = u_xlat7.xyz * vec3(u_xlat15);
    u_xlat0.x = texture(_LightTextureB0, u_xlat0.xx).w;
    u_xlat0.x = u_xlat16_5.x * u_xlat0.x;
    u_xlat3.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat16_5.xyz = (-u_xlat2.xyz) * u_xlat0.xxx + (-u_xlat7.xyz);
    u_xlat16_26 = dot(u_xlat16_5.xyz, u_xlat16_5.xyz);
    u_xlat16_0 = max(u_xlat16_26, 0.00100000005);
    u_xlat16_26 = inversesqrt(u_xlat16_0);
    u_xlat16_5.xyz = vec3(u_xlat16_26) * u_xlat16_5.xyz;
    u_xlat16_26 = dot((-u_xlat7.xyz), u_xlat16_5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_26 = min(max(u_xlat16_26, 0.0), 1.0);
#else
    u_xlat16_26 = clamp(u_xlat16_26, 0.0, 1.0);
#endif
    u_xlat16_0 = max(u_xlat16_26, 0.319999993);
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat16_26 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_15 = u_xlat16_26 * u_xlat16_26 + 1.5;
    u_xlat16_26 = u_xlat16_26 * u_xlat16_26;
    u_xlat16_0 = u_xlat16_0 * u_xlat16_15;
    u_xlat10_4.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_4.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_27 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_27 = inversesqrt(u_xlat16_27);
    u_xlat16_6.xyz = vec3(u_xlat16_27) * u_xlat16_6.xyz;
    u_xlat16_5.x = dot(u_xlat16_6.xyz, u_xlat16_5.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_5.x = min(max(u_xlat16_5.x, 0.0), 1.0);
#else
    u_xlat16_5.x = clamp(u_xlat16_5.x, 0.0, 1.0);
#endif
    u_xlat16_12 = dot(u_xlat16_6.xyz, (-u_xlat7.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_12 = min(max(u_xlat16_12, 0.0), 1.0);
#else
    u_xlat16_12 = clamp(u_xlat16_12, 0.0, 1.0);
#endif
    u_xlat16_5.x = u_xlat16_5.x * u_xlat16_5.x;
    u_xlat16_7 = u_xlat16_26 * u_xlat16_26 + -1.0;
    u_xlat16_7 = u_xlat16_5.x * u_xlat16_7 + 1.00001001;
    u_xlat16_0 = u_xlat16_7 * u_xlat16_0;
    u_xlat16_0 = u_xlat16_26 / u_xlat16_0;
    u_xlat16_0 = u_xlat16_0 + -9.99999975e-05;
    u_xlat16_5.x = max(u_xlat16_0, 0.0);
    u_xlat16_5.x = min(u_xlat16_5.x, 100.0);
    u_xlat16_5.xzw = u_xlat16_5.xxx * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat16_5.xzw = u_xlat3.xyz * u_xlat16_5.xzw;
    SV_Target0.xyz = vec3(u_xlat16_12) * u_xlat16_5.xzw;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "UNITY_HDR_ON" }
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w)));
  atten_5 = tmpvar_13.w;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  mediump float shadowVal_16;
  highp float mydist_17;
  mydist_17 = ((sqrt(
    dot (tmpvar_11, tmpvar_11)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_18;
  tmpvar_18 = textureCube (_ShadowMapTexture, tmpvar_11);
  highp vec4 vals_19;
  vals_19 = tmpvar_18;
  highp float tmpvar_20;
  tmpvar_20 = dot (vals_19, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVal_16 = tmpvar_20;
  mediump float tmpvar_21;
  if ((shadowVal_16 < mydist_17)) {
    tmpvar_21 = _LightShadowData.x;
  } else {
    tmpvar_21 = 1.0;
  };
  mediump float tmpvar_22;
  tmpvar_22 = clamp ((tmpvar_21 + tmpvar_14), 0.0, 1.0);
  atten_5 = (tmpvar_13.w * tmpvar_22);
  highp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = tmpvar_9;
  highp vec4 tmpvar_24;
  tmpvar_24.w = -8.0;
  tmpvar_24.xyz = (unity_WorldToLight * tmpvar_23).xyz;
  atten_5 = (atten_5 * textureCube (_LightTexture0, tmpvar_24.xyz, -8.0).w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_27;
  mediump vec3 tmpvar_28;
  tmpvar_28 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_29;
  tmpvar_29 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_30;
  viewDir_30 = -(tmpvar_29);
  mediump vec2 tmpvar_31;
  tmpvar_31.x = dot ((viewDir_30 - (2.0 * 
    (dot (tmpvar_28, viewDir_30) * tmpvar_28)
  )), lightDir_6);
  tmpvar_31.y = (1.0 - clamp (dot (tmpvar_28, viewDir_30), 0.0, 1.0));
  mediump float specular_32;
  mediump vec2 tmpvar_33;
  tmpvar_33.x = ((tmpvar_31 * tmpvar_31) * (tmpvar_31 * tmpvar_31)).x;
  tmpvar_33.y = (1.0 - gbuffer1_2.w);
  highp float tmpvar_34;
  tmpvar_34 = (texture2D (unity_NHxRoughness, tmpvar_33).w * 16.0);
  specular_32 = tmpvar_34;
  mediump vec4 tmpvar_35;
  tmpvar_35.w = 1.0;
  tmpvar_35.xyz = ((gbuffer0_3.xyz + (specular_32 * gbuffer1_2.xyz)) * (tmpvar_4 * clamp (
    dot (tmpvar_28, lightDir_6)
  , 0.0, 1.0)));
  gl_FragData[0] = tmpvar_35;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "UNITY_HDR_ON" }
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform highp sampler2D unity_NHxRoughness;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
lowp vec4 u_xlat10_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
lowp vec4 u_xlat10_3;
mediump vec3 u_xlat16_4;
lowp vec3 u_xlat10_5;
mediump vec3 u_xlat16_6;
vec3 u_xlat7;
float u_xlat15;
bool u_xlatb15;
float u_xlat16;
float u_xlat21;
float u_xlat22;
mediump float u_xlat16_25;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat21 = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat21 = float(1.0) / u_xlat21;
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat21 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat7.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat10_3 = texture(_ShadowMapTexture, u_xlat7.xyz);
    u_xlat15 = dot(u_xlat10_3, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat22 = dot(u_xlat7.xyz, u_xlat7.xyz);
    u_xlat16 = sqrt(u_xlat22);
    u_xlat16 = u_xlat16 * _LightPositionRange.w;
    u_xlat16 = u_xlat16 * _LightProjectionParams.w;
#ifdef UNITY_ADRENO_ES3
    u_xlatb15 = !!(u_xlat15<u_xlat16);
#else
    u_xlatb15 = u_xlat15<u_xlat16;
#endif
    u_xlat16_4.x = (u_xlatb15) ? _LightShadowData.x : 1.0;
    u_xlat16_4.x = u_xlat0.x + u_xlat16_4.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat22 * _LightPos.w;
    u_xlat15 = inversesqrt(u_xlat22);
    u_xlat7.xyz = u_xlat7.xyz * vec3(u_xlat15);
    u_xlat0.x = texture(_LightTextureB0, u_xlat0.xx).w;
    u_xlat0.x = u_xlat16_4.x * u_xlat0.x;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat3.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat3.xyz = u_xlat3.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat15 = texture(_LightTexture0, u_xlat3.xyz, -8.0).w;
    u_xlat0.x = u_xlat0.x * u_xlat15;
    u_xlat3.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat10_5.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_4.xyz = u_xlat10_5.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_25 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_25 = inversesqrt(u_xlat16_25);
    u_xlat16_4.xyz = vec3(u_xlat16_25) * u_xlat16_4.xyz;
    u_xlat16_25 = dot(u_xlat16_4.xyz, (-u_xlat7.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_25 = min(max(u_xlat16_25, 0.0), 1.0);
#else
    u_xlat16_25 = clamp(u_xlat16_25, 0.0, 1.0);
#endif
    u_xlat16_6.xyz = u_xlat3.xyz * vec3(u_xlat16_25);
    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat2.xyz = u_xlat0.xxx * u_xlat2.xyz;
    u_xlat16_25 = dot((-u_xlat2.xyz), u_xlat16_4.xyz);
    u_xlat16_25 = u_xlat16_25 + u_xlat16_25;
    u_xlat16_4.xyz = u_xlat16_4.xyz * (-vec3(u_xlat16_25)) + (-u_xlat2.xyz);
    u_xlat16_4.x = dot(u_xlat16_4.xyz, (-u_xlat7.xyz));
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_4.x;
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_4.x;
    u_xlat10_0 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_4.y = (-u_xlat10_0.w) + 1.0;
    u_xlat21 = texture(unity_NHxRoughness, u_xlat16_4.xy).w;
    u_xlat21 = u_xlat21 * 16.0;
    u_xlat16_4.xyz = vec3(u_xlat21) * u_xlat10_0.xyz + u_xlat10_1.xyz;
    SV_Target0.xyz = u_xlat16_6.xyz * u_xlat16_4.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "UNITY_HDR_ON" }
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w)));
  atten_5 = tmpvar_13.w;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  mediump float shadowVal_16;
  highp float mydist_17;
  mydist_17 = ((sqrt(
    dot (tmpvar_11, tmpvar_11)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_18;
  tmpvar_18 = textureCube (_ShadowMapTexture, tmpvar_11);
  highp vec4 vals_19;
  vals_19 = tmpvar_18;
  highp float tmpvar_20;
  tmpvar_20 = dot (vals_19, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVal_16 = tmpvar_20;
  mediump float tmpvar_21;
  if ((shadowVal_16 < mydist_17)) {
    tmpvar_21 = _LightShadowData.x;
  } else {
    tmpvar_21 = 1.0;
  };
  mediump float tmpvar_22;
  tmpvar_22 = clamp ((tmpvar_21 + tmpvar_14), 0.0, 1.0);
  atten_5 = (tmpvar_13.w * tmpvar_22);
  highp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = tmpvar_9;
  highp vec4 tmpvar_24;
  tmpvar_24.w = -8.0;
  tmpvar_24.xyz = (unity_WorldToLight * tmpvar_23).xyz;
  atten_5 = (atten_5 * textureCube (_LightTexture0, tmpvar_24.xyz, -8.0).w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_27;
  mediump vec3 tmpvar_28;
  tmpvar_28 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_29;
  tmpvar_29 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_30;
  viewDir_30 = -(tmpvar_29);
  mediump float specularTerm_31;
  mediump vec3 tmpvar_32;
  mediump vec3 inVec_33;
  inVec_33 = (lightDir_6 + viewDir_30);
  tmpvar_32 = (inVec_33 * inversesqrt(max (0.001, 
    dot (inVec_33, inVec_33)
  )));
  mediump float tmpvar_34;
  tmpvar_34 = clamp (dot (tmpvar_28, tmpvar_32), 0.0, 1.0);
  mediump float tmpvar_35;
  tmpvar_35 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_36;
  tmpvar_36 = (tmpvar_35 * tmpvar_35);
  specularTerm_31 = ((tmpvar_36 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_32), 0.0, 1.0)) * (1.5 + tmpvar_36))
   * 
    (((tmpvar_34 * tmpvar_34) * ((tmpvar_36 * tmpvar_36) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_37;
  tmpvar_37 = clamp (specularTerm_31, 0.0, 100.0);
  specularTerm_31 = tmpvar_37;
  mediump vec4 tmpvar_38;
  tmpvar_38.w = 1.0;
  tmpvar_38.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_37 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_28, lightDir_6), 0.0, 1.0));
  gl_FragData[0] = tmpvar_38;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "UNITY_HDR_ON" }
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w)));
  atten_5 = tmpvar_13.w;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  mediump float shadowVal_16;
  highp float mydist_17;
  mydist_17 = ((sqrt(
    dot (tmpvar_11, tmpvar_11)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  lowp vec4 tmpvar_18;
  tmpvar_18 = textureCube (_ShadowMapTexture, tmpvar_11);
  highp vec4 vals_19;
  vals_19 = tmpvar_18;
  highp float tmpvar_20;
  tmpvar_20 = dot (vals_19, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  shadowVal_16 = tmpvar_20;
  mediump float tmpvar_21;
  if ((shadowVal_16 < mydist_17)) {
    tmpvar_21 = _LightShadowData.x;
  } else {
    tmpvar_21 = 1.0;
  };
  mediump float tmpvar_22;
  tmpvar_22 = clamp ((tmpvar_21 + tmpvar_14), 0.0, 1.0);
  atten_5 = (tmpvar_13.w * tmpvar_22);
  highp vec4 tmpvar_23;
  tmpvar_23.w = 1.0;
  tmpvar_23.xyz = tmpvar_9;
  highp vec4 tmpvar_24;
  tmpvar_24.w = -8.0;
  tmpvar_24.xyz = (unity_WorldToLight * tmpvar_23).xyz;
  atten_5 = (atten_5 * textureCube (_LightTexture0, tmpvar_24.xyz, -8.0).w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_25;
  tmpvar_25 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_26;
  lowp vec4 tmpvar_27;
  tmpvar_27 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_27;
  mediump vec3 tmpvar_28;
  tmpvar_28 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_29;
  tmpvar_29 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_30;
  viewDir_30 = -(tmpvar_29);
  mediump float specularTerm_31;
  mediump vec3 tmpvar_32;
  mediump vec3 inVec_33;
  inVec_33 = (lightDir_6 + viewDir_30);
  tmpvar_32 = (inVec_33 * inversesqrt(max (0.001, 
    dot (inVec_33, inVec_33)
  )));
  mediump float tmpvar_34;
  tmpvar_34 = clamp (dot (tmpvar_28, tmpvar_32), 0.0, 1.0);
  mediump float tmpvar_35;
  tmpvar_35 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_36;
  tmpvar_36 = (tmpvar_35 * tmpvar_35);
  specularTerm_31 = ((tmpvar_36 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_32), 0.0, 1.0)) * (1.5 + tmpvar_36))
   * 
    (((tmpvar_34 * tmpvar_34) * ((tmpvar_36 * tmpvar_36) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_37;
  tmpvar_37 = clamp (specularTerm_31, 0.0, 100.0);
  specularTerm_31 = tmpvar_37;
  mediump vec4 tmpvar_38;
  tmpvar_38.w = 1.0;
  tmpvar_38.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_37 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_28, lightDir_6), 0.0, 1.0));
  gl_FragData[0] = tmpvar_38;
}


#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "UNITY_HDR_ON" }
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
mediump float u_xlat16_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
lowp vec4 u_xlat10_3;
mediump vec4 u_xlat16_4;
lowp vec3 u_xlat10_5;
mediump vec3 u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_7;
mediump float u_xlat16_11;
float u_xlat15;
mediump float u_xlat16_15;
bool u_xlatb15;
float u_xlat16;
float u_xlat21;
float u_xlat22;
mediump float u_xlat16_25;
mediump float u_xlat16_27;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat21 = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat21 = float(1.0) / u_xlat21;
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat21 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat7.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat10_3 = texture(_ShadowMapTexture, u_xlat7.xyz);
    u_xlat15 = dot(u_xlat10_3, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat22 = dot(u_xlat7.xyz, u_xlat7.xyz);
    u_xlat16 = sqrt(u_xlat22);
    u_xlat16 = u_xlat16 * _LightPositionRange.w;
    u_xlat16 = u_xlat16 * _LightProjectionParams.w;
#ifdef UNITY_ADRENO_ES3
    u_xlatb15 = !!(u_xlat15<u_xlat16);
#else
    u_xlatb15 = u_xlat15<u_xlat16;
#endif
    u_xlat16_4.x = (u_xlatb15) ? _LightShadowData.x : 1.0;
    u_xlat16_4.x = u_xlat0.x + u_xlat16_4.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat22 * _LightPos.w;
    u_xlat15 = inversesqrt(u_xlat22);
    u_xlat7.xyz = u_xlat7.xyz * vec3(u_xlat15);
    u_xlat0.x = texture(_LightTextureB0, u_xlat0.xx).w;
    u_xlat0.x = u_xlat16_4.x * u_xlat0.x;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat3.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat3.xyz = u_xlat3.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat15 = texture(_LightTexture0, u_xlat3.xyz, -8.0).w;
    u_xlat0.x = u_xlat0.x * u_xlat15;
    u_xlat3.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat16_4.xyz = (-u_xlat2.xyz) * u_xlat0.xxx + (-u_xlat7.xyz);
    u_xlat16_25 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_0 = max(u_xlat16_25, 0.00100000005);
    u_xlat16_25 = inversesqrt(u_xlat16_0);
    u_xlat16_4.xyz = vec3(u_xlat16_25) * u_xlat16_4.xyz;
    u_xlat16_25 = dot((-u_xlat7.xyz), u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_25 = min(max(u_xlat16_25, 0.0), 1.0);
#else
    u_xlat16_25 = clamp(u_xlat16_25, 0.0, 1.0);
#endif
    u_xlat16_0 = max(u_xlat16_25, 0.319999993);
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat16_25 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_15 = u_xlat16_25 * u_xlat16_25 + 1.5;
    u_xlat16_25 = u_xlat16_25 * u_xlat16_25;
    u_xlat16_0 = u_xlat16_0 * u_xlat16_15;
    u_xlat10_5.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_5.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_27 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_27 = inversesqrt(u_xlat16_27);
    u_xlat16_6.xyz = vec3(u_xlat16_27) * u_xlat16_6.xyz;
    u_xlat16_4.x = dot(u_xlat16_6.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_11 = dot(u_xlat16_6.xyz, (-u_xlat7.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_11 = min(max(u_xlat16_11, 0.0), 1.0);
#else
    u_xlat16_11 = clamp(u_xlat16_11, 0.0, 1.0);
#endif
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_4.x;
    u_xlat16_7 = u_xlat16_25 * u_xlat16_25 + -1.0;
    u_xlat16_7 = u_xlat16_4.x * u_xlat16_7 + 1.00001001;
    u_xlat16_0 = u_xlat16_7 * u_xlat16_0;
    u_xlat16_0 = u_xlat16_25 / u_xlat16_0;
    u_xlat16_0 = u_xlat16_0 + -9.99999975e-05;
    u_xlat16_4.x = max(u_xlat16_0, 0.0);
    u_xlat16_4.x = min(u_xlat16_4.x, 100.0);
    u_xlat16_4.xzw = u_xlat16_4.xxx * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat16_4.xzw = u_xlat3.xyz * u_xlat16_4.xzw;
    SV_Target0.xyz = vec3(u_xlat16_11) * u_xlat16_4.xzw;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "UNITY_HDR_ON" }
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
mediump float u_xlat16_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
lowp vec4 u_xlat10_3;
mediump vec4 u_xlat16_4;
lowp vec3 u_xlat10_5;
mediump vec3 u_xlat16_6;
vec3 u_xlat7;
mediump float u_xlat16_7;
mediump float u_xlat16_11;
float u_xlat15;
mediump float u_xlat16_15;
bool u_xlatb15;
float u_xlat16;
float u_xlat21;
float u_xlat22;
mediump float u_xlat16_25;
mediump float u_xlat16_27;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat21 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat21 = _ZBufferParams.x * u_xlat21 + _ZBufferParams.y;
    u_xlat21 = float(1.0) / u_xlat21;
    u_xlat2.xyz = vec3(u_xlat21) * u_xlat0.xyz;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_CameraToWorld[1].xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat2.xyw = hlslcc_mtx4x4unity_CameraToWorld[2].xyz * u_xlat2.zzz + u_xlat2.xyw;
    u_xlat2.xyw = u_xlat2.xyw + hlslcc_mtx4x4unity_CameraToWorld[3].xyz;
    u_xlat3.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat0.x = sqrt(u_xlat0.x);
    u_xlat0.x = (-u_xlat0.z) * u_xlat21 + u_xlat0.x;
    u_xlat0.x = unity_ShadowFadeCenterAndType.w * u_xlat0.x + u_xlat2.z;
    u_xlat0.x = u_xlat0.x * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat0.x = min(max(u_xlat0.x, 0.0), 1.0);
#else
    u_xlat0.x = clamp(u_xlat0.x, 0.0, 1.0);
#endif
    u_xlat7.xyz = u_xlat2.xyw + (-_LightPos.xyz);
    u_xlat10_3 = texture(_ShadowMapTexture, u_xlat7.xyz);
    u_xlat15 = dot(u_xlat10_3, vec4(1.0, 0.00392156886, 1.53787005e-05, 6.03086292e-08));
    u_xlat22 = dot(u_xlat7.xyz, u_xlat7.xyz);
    u_xlat16 = sqrt(u_xlat22);
    u_xlat16 = u_xlat16 * _LightPositionRange.w;
    u_xlat16 = u_xlat16 * _LightProjectionParams.w;
#ifdef UNITY_ADRENO_ES3
    u_xlatb15 = !!(u_xlat15<u_xlat16);
#else
    u_xlatb15 = u_xlat15<u_xlat16;
#endif
    u_xlat16_4.x = (u_xlatb15) ? _LightShadowData.x : 1.0;
    u_xlat16_4.x = u_xlat0.x + u_xlat16_4.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat0.x = u_xlat22 * _LightPos.w;
    u_xlat15 = inversesqrt(u_xlat22);
    u_xlat7.xyz = u_xlat7.xyz * vec3(u_xlat15);
    u_xlat0.x = texture(_LightTextureB0, u_xlat0.xx).w;
    u_xlat0.x = u_xlat16_4.x * u_xlat0.x;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat3.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat3.xyz = u_xlat3.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat15 = texture(_LightTexture0, u_xlat3.xyz, -8.0).w;
    u_xlat0.x = u_xlat0.x * u_xlat15;
    u_xlat3.xyz = u_xlat0.xxx * _LightColor.xyz;
    u_xlat0.x = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat16_4.xyz = (-u_xlat2.xyz) * u_xlat0.xxx + (-u_xlat7.xyz);
    u_xlat16_25 = dot(u_xlat16_4.xyz, u_xlat16_4.xyz);
    u_xlat16_0 = max(u_xlat16_25, 0.00100000005);
    u_xlat16_25 = inversesqrt(u_xlat16_0);
    u_xlat16_4.xyz = vec3(u_xlat16_25) * u_xlat16_4.xyz;
    u_xlat16_25 = dot((-u_xlat7.xyz), u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_25 = min(max(u_xlat16_25, 0.0), 1.0);
#else
    u_xlat16_25 = clamp(u_xlat16_25, 0.0, 1.0);
#endif
    u_xlat16_0 = max(u_xlat16_25, 0.319999993);
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat16_25 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_15 = u_xlat16_25 * u_xlat16_25 + 1.5;
    u_xlat16_25 = u_xlat16_25 * u_xlat16_25;
    u_xlat16_0 = u_xlat16_0 * u_xlat16_15;
    u_xlat10_5.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_5.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_27 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_27 = inversesqrt(u_xlat16_27);
    u_xlat16_6.xyz = vec3(u_xlat16_27) * u_xlat16_6.xyz;
    u_xlat16_4.x = dot(u_xlat16_6.xyz, u_xlat16_4.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_4.x = min(max(u_xlat16_4.x, 0.0), 1.0);
#else
    u_xlat16_4.x = clamp(u_xlat16_4.x, 0.0, 1.0);
#endif
    u_xlat16_11 = dot(u_xlat16_6.xyz, (-u_xlat7.xyz));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_11 = min(max(u_xlat16_11, 0.0), 1.0);
#else
    u_xlat16_11 = clamp(u_xlat16_11, 0.0, 1.0);
#endif
    u_xlat16_4.x = u_xlat16_4.x * u_xlat16_4.x;
    u_xlat16_7 = u_xlat16_25 * u_xlat16_25 + -1.0;
    u_xlat16_7 = u_xlat16_4.x * u_xlat16_7 + 1.00001001;
    u_xlat16_0 = u_xlat16_7 * u_xlat16_0;
    u_xlat16_0 = u_xlat16_25 / u_xlat16_0;
    u_xlat16_0 = u_xlat16_0 + -9.99999975e-05;
    u_xlat16_4.x = max(u_xlat16_0, 0.0);
    u_xlat16_4.x = min(u_xlat16_4.x, 100.0);
    u_xlat16_4.xzw = u_xlat16_4.xxx * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat16_4.xzw = u_xlat3.xyz * u_xlat16_4.xzw;
    SV_Target0.xyz = vec3(u_xlat16_11) * u_xlat16_4.xzw;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform highp sampler2D unity_NHxRoughness;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w)));
  atten_5 = tmpvar_13.w;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  highp vec4 shadowVals_16;
  highp float mydist_17;
  mydist_17 = ((sqrt(
    dot (tmpvar_11, tmpvar_11)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_18;
  tmpvar_18.w = 0.0;
  tmpvar_18.xyz = (tmpvar_11 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_18.xyz, 0.0);
  tmpvar_19 = tmpvar_20;
  shadowVals_16.x = dot (tmpvar_19, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_21;
  tmpvar_21.w = 0.0;
  tmpvar_21.xyz = (tmpvar_11 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_22;
  lowp vec4 tmpvar_23;
  tmpvar_23 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_21.xyz, 0.0);
  tmpvar_22 = tmpvar_23;
  shadowVals_16.y = dot (tmpvar_22, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_24;
  tmpvar_24.w = 0.0;
  tmpvar_24.xyz = (tmpvar_11 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_24.xyz, 0.0);
  tmpvar_25 = tmpvar_26;
  shadowVals_16.z = dot (tmpvar_25, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_27;
  tmpvar_27.w = 0.0;
  tmpvar_27.xyz = (tmpvar_11 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_27.xyz, 0.0);
  tmpvar_28 = tmpvar_29;
  shadowVals_16.w = dot (tmpvar_28, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_30;
  tmpvar_30 = lessThan (shadowVals_16, vec4(mydist_17));
  mediump vec4 tmpvar_31;
  tmpvar_31 = _LightShadowData.xxxx;
  mediump float tmpvar_32;
  if (tmpvar_30.x) {
    tmpvar_32 = tmpvar_31.x;
  } else {
    tmpvar_32 = 1.0;
  };
  mediump float tmpvar_33;
  if (tmpvar_30.y) {
    tmpvar_33 = tmpvar_31.y;
  } else {
    tmpvar_33 = 1.0;
  };
  mediump float tmpvar_34;
  if (tmpvar_30.z) {
    tmpvar_34 = tmpvar_31.z;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_30.w) {
    tmpvar_35 = tmpvar_31.w;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump vec4 tmpvar_36;
  tmpvar_36.x = tmpvar_32;
  tmpvar_36.y = tmpvar_33;
  tmpvar_36.z = tmpvar_34;
  tmpvar_36.w = tmpvar_35;
  mediump float tmpvar_37;
  tmpvar_37 = clamp ((dot (tmpvar_36, vec4(0.25, 0.25, 0.25, 0.25)) + tmpvar_14), 0.0, 1.0);
  atten_5 = (tmpvar_13.w * tmpvar_37);
  highp vec4 tmpvar_38;
  tmpvar_38.w = 1.0;
  tmpvar_38.xyz = tmpvar_9;
  highp vec4 tmpvar_39;
  tmpvar_39.w = -8.0;
  tmpvar_39.xyz = (unity_WorldToLight * tmpvar_38).xyz;
  atten_5 = (atten_5 * textureCube (_LightTexture0, tmpvar_39.xyz, -8.0).w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_40;
  tmpvar_40 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_40;
  lowp vec4 tmpvar_41;
  tmpvar_41 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_41;
  lowp vec4 tmpvar_42;
  tmpvar_42 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_42;
  mediump vec3 tmpvar_43;
  tmpvar_43 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_44;
  tmpvar_44 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_45;
  viewDir_45 = -(tmpvar_44);
  mediump vec2 tmpvar_46;
  tmpvar_46.x = dot ((viewDir_45 - (2.0 * 
    (dot (tmpvar_43, viewDir_45) * tmpvar_43)
  )), lightDir_6);
  tmpvar_46.y = (1.0 - clamp (dot (tmpvar_43, viewDir_45), 0.0, 1.0));
  mediump float specular_47;
  mediump vec2 tmpvar_48;
  tmpvar_48.x = ((tmpvar_46 * tmpvar_46) * (tmpvar_46 * tmpvar_46)).x;
  tmpvar_48.y = (1.0 - gbuffer1_2.w);
  highp float tmpvar_49;
  tmpvar_49 = (texture2D (unity_NHxRoughness, tmpvar_48).w * 16.0);
  specular_47 = tmpvar_49;
  mediump vec4 tmpvar_50;
  tmpvar_50.w = 1.0;
  tmpvar_50.xyz = ((gbuffer0_3.xyz + (specular_47 * gbuffer1_2.xyz)) * (tmpvar_4 * clamp (
    dot (tmpvar_43, lightDir_6)
  , 0.0, 1.0)));
  gl_FragData[0] = tmpvar_50;
}


#endif
"
}
SubProgram "gles3 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform highp sampler2D unity_NHxRoughness;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
lowp vec4 u_xlat10_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
vec3 u_xlat3;
vec4 u_xlat4;
lowp vec4 u_xlat10_4;
bvec4 u_xlatb4;
vec3 u_xlat5;
lowp vec4 u_xlat10_5;
mediump vec3 u_xlat16_6;
mediump vec3 u_xlat16_7;
float u_xlat8;
float u_xlat17;
float u_xlat24;
mediump float u_xlat16_30;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat24 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat24 = _ZBufferParams.x * u_xlat24 + _ZBufferParams.y;
    u_xlat24 = float(1.0) / u_xlat24;
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat0.xyz;
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
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat8 = sqrt(u_xlat0.x);
    u_xlat8 = u_xlat8 * _LightPositionRange.w;
    u_xlat8 = u_xlat8 * _LightProjectionParams.w;
    u_xlatb4 = lessThan(u_xlat4, vec4(u_xlat8));
    u_xlat4.x = (u_xlatb4.x) ? _LightShadowData.x : float(1.0);
    u_xlat4.y = (u_xlatb4.y) ? _LightShadowData.x : float(1.0);
    u_xlat4.z = (u_xlatb4.z) ? _LightShadowData.x : float(1.0);
    u_xlat4.w = (u_xlatb4.w) ? _LightShadowData.x : float(1.0);
    u_xlat16_6.x = dot(u_xlat4, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat4.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat8 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat8 = sqrt(u_xlat8);
    u_xlat8 = (-u_xlat0.z) * u_xlat24 + u_xlat8;
    u_xlat8 = unity_ShadowFadeCenterAndType.w * u_xlat8 + u_xlat2.z;
    u_xlat8 = u_xlat8 * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat8 = min(max(u_xlat8, 0.0), 1.0);
#else
    u_xlat8 = clamp(u_xlat8, 0.0, 1.0);
#endif
    u_xlat16_6.x = u_xlat8 + u_xlat16_6.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_6.x = min(max(u_xlat16_6.x, 0.0), 1.0);
#else
    u_xlat16_6.x = clamp(u_xlat16_6.x, 0.0, 1.0);
#endif
    u_xlat8 = u_xlat0.x * _LightPos.w;
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat0.xzw = u_xlat0.xxx * u_xlat3.xyz;
    u_xlat8 = texture(_LightTextureB0, vec2(u_xlat8)).w;
    u_xlat8 = u_xlat16_6.x * u_xlat8;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat3.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat3.xyz = u_xlat3.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat17 = texture(_LightTexture0, u_xlat3.xyz, -8.0).w;
    u_xlat8 = u_xlat8 * u_xlat17;
    u_xlat3.xyz = vec3(u_xlat8) * _LightColor.xyz;
    u_xlat10_4.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat16_6.xyz = u_xlat10_4.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_30 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_30 = inversesqrt(u_xlat16_30);
    u_xlat16_6.xyz = vec3(u_xlat16_30) * u_xlat16_6.xyz;
    u_xlat16_30 = dot(u_xlat16_6.xyz, (-u_xlat0.xzw));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_30 = min(max(u_xlat16_30, 0.0), 1.0);
#else
    u_xlat16_30 = clamp(u_xlat16_30, 0.0, 1.0);
#endif
    u_xlat16_7.xyz = u_xlat3.xyz * vec3(u_xlat16_30);
    u_xlat8 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat8 = inversesqrt(u_xlat8);
    u_xlat2.xyz = vec3(u_xlat8) * u_xlat2.xyz;
    u_xlat16_30 = dot((-u_xlat2.xyz), u_xlat16_6.xyz);
    u_xlat16_30 = u_xlat16_30 + u_xlat16_30;
    u_xlat16_6.xyz = u_xlat16_6.xyz * (-vec3(u_xlat16_30)) + (-u_xlat2.xyz);
    u_xlat16_6.x = dot(u_xlat16_6.xyz, (-u_xlat0.xzw));
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_6.x;
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_6.x;
    u_xlat10_0 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_6.y = (-u_xlat10_0.w) + 1.0;
    u_xlat24 = texture(unity_NHxRoughness, u_xlat16_6.xy).w;
    u_xlat24 = u_xlat24 * 16.0;
    u_xlat16_6.xyz = vec3(u_xlat24) * u_xlat10_0.xyz + u_xlat10_1.xyz;
    SV_Target0.xyz = u_xlat16_7.xyz * u_xlat16_6.xyz;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w)));
  atten_5 = tmpvar_13.w;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  highp vec4 shadowVals_16;
  highp float mydist_17;
  mydist_17 = ((sqrt(
    dot (tmpvar_11, tmpvar_11)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_18;
  tmpvar_18.w = 0.0;
  tmpvar_18.xyz = (tmpvar_11 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_18.xyz, 0.0);
  tmpvar_19 = tmpvar_20;
  shadowVals_16.x = dot (tmpvar_19, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_21;
  tmpvar_21.w = 0.0;
  tmpvar_21.xyz = (tmpvar_11 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_22;
  lowp vec4 tmpvar_23;
  tmpvar_23 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_21.xyz, 0.0);
  tmpvar_22 = tmpvar_23;
  shadowVals_16.y = dot (tmpvar_22, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_24;
  tmpvar_24.w = 0.0;
  tmpvar_24.xyz = (tmpvar_11 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_24.xyz, 0.0);
  tmpvar_25 = tmpvar_26;
  shadowVals_16.z = dot (tmpvar_25, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_27;
  tmpvar_27.w = 0.0;
  tmpvar_27.xyz = (tmpvar_11 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_27.xyz, 0.0);
  tmpvar_28 = tmpvar_29;
  shadowVals_16.w = dot (tmpvar_28, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_30;
  tmpvar_30 = lessThan (shadowVals_16, vec4(mydist_17));
  mediump vec4 tmpvar_31;
  tmpvar_31 = _LightShadowData.xxxx;
  mediump float tmpvar_32;
  if (tmpvar_30.x) {
    tmpvar_32 = tmpvar_31.x;
  } else {
    tmpvar_32 = 1.0;
  };
  mediump float tmpvar_33;
  if (tmpvar_30.y) {
    tmpvar_33 = tmpvar_31.y;
  } else {
    tmpvar_33 = 1.0;
  };
  mediump float tmpvar_34;
  if (tmpvar_30.z) {
    tmpvar_34 = tmpvar_31.z;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_30.w) {
    tmpvar_35 = tmpvar_31.w;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump vec4 tmpvar_36;
  tmpvar_36.x = tmpvar_32;
  tmpvar_36.y = tmpvar_33;
  tmpvar_36.z = tmpvar_34;
  tmpvar_36.w = tmpvar_35;
  mediump float tmpvar_37;
  tmpvar_37 = clamp ((dot (tmpvar_36, vec4(0.25, 0.25, 0.25, 0.25)) + tmpvar_14), 0.0, 1.0);
  atten_5 = (tmpvar_13.w * tmpvar_37);
  highp vec4 tmpvar_38;
  tmpvar_38.w = 1.0;
  tmpvar_38.xyz = tmpvar_9;
  highp vec4 tmpvar_39;
  tmpvar_39.w = -8.0;
  tmpvar_39.xyz = (unity_WorldToLight * tmpvar_38).xyz;
  atten_5 = (atten_5 * textureCube (_LightTexture0, tmpvar_39.xyz, -8.0).w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_40;
  tmpvar_40 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_40;
  lowp vec4 tmpvar_41;
  tmpvar_41 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_41;
  lowp vec4 tmpvar_42;
  tmpvar_42 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_42;
  mediump vec3 tmpvar_43;
  tmpvar_43 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_44;
  tmpvar_44 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_45;
  viewDir_45 = -(tmpvar_44);
  mediump float specularTerm_46;
  mediump vec3 tmpvar_47;
  mediump vec3 inVec_48;
  inVec_48 = (lightDir_6 + viewDir_45);
  tmpvar_47 = (inVec_48 * inversesqrt(max (0.001, 
    dot (inVec_48, inVec_48)
  )));
  mediump float tmpvar_49;
  tmpvar_49 = clamp (dot (tmpvar_43, tmpvar_47), 0.0, 1.0);
  mediump float tmpvar_50;
  tmpvar_50 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_51;
  tmpvar_51 = (tmpvar_50 * tmpvar_50);
  specularTerm_46 = ((tmpvar_51 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_47), 0.0, 1.0)) * (1.5 + tmpvar_51))
   * 
    (((tmpvar_49 * tmpvar_49) * ((tmpvar_51 * tmpvar_51) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_52;
  tmpvar_52 = clamp (specularTerm_46, 0.0, 100.0);
  specularTerm_46 = tmpvar_52;
  mediump vec4 tmpvar_53;
  tmpvar_53.w = 1.0;
  tmpvar_53.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_52 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_43, lightDir_6), 0.0, 1.0));
  gl_FragData[0] = tmpvar_53;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform highp mat4 unity_WorldToLight;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp samplerCube _ShadowMapTexture;
uniform sampler2D _CameraGBufferTexture0;
uniform sampler2D _CameraGBufferTexture1;
uniform sampler2D _CameraGBufferTexture2;
varying highp vec4 xlv_TEXCOORD0;
varying highp vec3 xlv_TEXCOORD1;
void main ()
{
  mediump vec4 gbuffer2_1;
  mediump vec4 gbuffer1_2;
  mediump vec4 gbuffer0_3;
  mediump vec3 tmpvar_4;
  highp float atten_5;
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
  tmpvar_11 = (tmpvar_9 - _LightPos.xyz);
  highp vec3 tmpvar_12;
  tmpvar_12 = -(normalize(tmpvar_11));
  lightDir_6 = tmpvar_12;
  highp vec4 tmpvar_13;
  tmpvar_13 = texture2D (_LightTextureB0, vec2((dot (tmpvar_11, tmpvar_11) * _LightPos.w)));
  atten_5 = tmpvar_13.w;
  mediump float tmpvar_14;
  highp float tmpvar_15;
  tmpvar_15 = clamp (((
    mix (tmpvar_8.z, sqrt(dot (tmpvar_10, tmpvar_10)), unity_ShadowFadeCenterAndType.w)
   * _LightShadowData.z) + _LightShadowData.w), 0.0, 1.0);
  tmpvar_14 = tmpvar_15;
  highp vec4 shadowVals_16;
  highp float mydist_17;
  mydist_17 = ((sqrt(
    dot (tmpvar_11, tmpvar_11)
  ) * _LightPositionRange.w) * _LightProjectionParams.w);
  highp vec4 tmpvar_18;
  tmpvar_18.w = 0.0;
  tmpvar_18.xyz = (tmpvar_11 + vec3(0.0078125, 0.0078125, 0.0078125));
  highp vec4 tmpvar_19;
  lowp vec4 tmpvar_20;
  tmpvar_20 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_18.xyz, 0.0);
  tmpvar_19 = tmpvar_20;
  shadowVals_16.x = dot (tmpvar_19, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_21;
  tmpvar_21.w = 0.0;
  tmpvar_21.xyz = (tmpvar_11 + vec3(-0.0078125, -0.0078125, 0.0078125));
  highp vec4 tmpvar_22;
  lowp vec4 tmpvar_23;
  tmpvar_23 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_21.xyz, 0.0);
  tmpvar_22 = tmpvar_23;
  shadowVals_16.y = dot (tmpvar_22, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_24;
  tmpvar_24.w = 0.0;
  tmpvar_24.xyz = (tmpvar_11 + vec3(-0.0078125, 0.0078125, -0.0078125));
  highp vec4 tmpvar_25;
  lowp vec4 tmpvar_26;
  tmpvar_26 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_24.xyz, 0.0);
  tmpvar_25 = tmpvar_26;
  shadowVals_16.z = dot (tmpvar_25, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  highp vec4 tmpvar_27;
  tmpvar_27.w = 0.0;
  tmpvar_27.xyz = (tmpvar_11 + vec3(0.0078125, -0.0078125, -0.0078125));
  highp vec4 tmpvar_28;
  lowp vec4 tmpvar_29;
  tmpvar_29 = impl_low_textureCubeLodEXT (_ShadowMapTexture, tmpvar_27.xyz, 0.0);
  tmpvar_28 = tmpvar_29;
  shadowVals_16.w = dot (tmpvar_28, vec4(1.0, 0.003921569, 1.53787e-05, 6.030863e-08));
  bvec4 tmpvar_30;
  tmpvar_30 = lessThan (shadowVals_16, vec4(mydist_17));
  mediump vec4 tmpvar_31;
  tmpvar_31 = _LightShadowData.xxxx;
  mediump float tmpvar_32;
  if (tmpvar_30.x) {
    tmpvar_32 = tmpvar_31.x;
  } else {
    tmpvar_32 = 1.0;
  };
  mediump float tmpvar_33;
  if (tmpvar_30.y) {
    tmpvar_33 = tmpvar_31.y;
  } else {
    tmpvar_33 = 1.0;
  };
  mediump float tmpvar_34;
  if (tmpvar_30.z) {
    tmpvar_34 = tmpvar_31.z;
  } else {
    tmpvar_34 = 1.0;
  };
  mediump float tmpvar_35;
  if (tmpvar_30.w) {
    tmpvar_35 = tmpvar_31.w;
  } else {
    tmpvar_35 = 1.0;
  };
  mediump vec4 tmpvar_36;
  tmpvar_36.x = tmpvar_32;
  tmpvar_36.y = tmpvar_33;
  tmpvar_36.z = tmpvar_34;
  tmpvar_36.w = tmpvar_35;
  mediump float tmpvar_37;
  tmpvar_37 = clamp ((dot (tmpvar_36, vec4(0.25, 0.25, 0.25, 0.25)) + tmpvar_14), 0.0, 1.0);
  atten_5 = (tmpvar_13.w * tmpvar_37);
  highp vec4 tmpvar_38;
  tmpvar_38.w = 1.0;
  tmpvar_38.xyz = tmpvar_9;
  highp vec4 tmpvar_39;
  tmpvar_39.w = -8.0;
  tmpvar_39.xyz = (unity_WorldToLight * tmpvar_38).xyz;
  atten_5 = (atten_5 * textureCube (_LightTexture0, tmpvar_39.xyz, -8.0).w);
  tmpvar_4 = (_LightColor.xyz * atten_5);
  lowp vec4 tmpvar_40;
  tmpvar_40 = texture2D (_CameraGBufferTexture0, tmpvar_7);
  gbuffer0_3 = tmpvar_40;
  lowp vec4 tmpvar_41;
  tmpvar_41 = texture2D (_CameraGBufferTexture1, tmpvar_7);
  gbuffer1_2 = tmpvar_41;
  lowp vec4 tmpvar_42;
  tmpvar_42 = texture2D (_CameraGBufferTexture2, tmpvar_7);
  gbuffer2_1 = tmpvar_42;
  mediump vec3 tmpvar_43;
  tmpvar_43 = normalize(((gbuffer2_1.xyz * 2.0) - 1.0));
  highp vec3 tmpvar_44;
  tmpvar_44 = normalize((tmpvar_9 - _WorldSpaceCameraPos));
  mediump vec3 viewDir_45;
  viewDir_45 = -(tmpvar_44);
  mediump float specularTerm_46;
  mediump vec3 tmpvar_47;
  mediump vec3 inVec_48;
  inVec_48 = (lightDir_6 + viewDir_45);
  tmpvar_47 = (inVec_48 * inversesqrt(max (0.001, 
    dot (inVec_48, inVec_48)
  )));
  mediump float tmpvar_49;
  tmpvar_49 = clamp (dot (tmpvar_43, tmpvar_47), 0.0, 1.0);
  mediump float tmpvar_50;
  tmpvar_50 = (1.0 - gbuffer1_2.w);
  mediump float tmpvar_51;
  tmpvar_51 = (tmpvar_50 * tmpvar_50);
  specularTerm_46 = ((tmpvar_51 / (
    (max (0.32, clamp (dot (lightDir_6, tmpvar_47), 0.0, 1.0)) * (1.5 + tmpvar_51))
   * 
    (((tmpvar_49 * tmpvar_49) * ((tmpvar_51 * tmpvar_51) - 1.0)) + 1.00001)
  )) - 0.0001);
  mediump float tmpvar_52;
  tmpvar_52 = clamp (specularTerm_46, 0.0, 100.0);
  specularTerm_46 = tmpvar_52;
  mediump vec4 tmpvar_53;
  tmpvar_53.w = 1.0;
  tmpvar_53.xyz = (((gbuffer0_3.xyz + 
    (tmpvar_52 * gbuffer1_2.xyz)
  ) * tmpvar_4) * clamp (dot (tmpvar_43, lightDir_6), 0.0, 1.0));
  gl_FragData[0] = tmpvar_53;
}


#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump float u_xlat16_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
vec4 u_xlat4;
lowp vec4 u_xlat10_4;
bvec4 u_xlatb4;
vec3 u_xlat5;
lowp vec4 u_xlat10_5;
mediump vec4 u_xlat16_6;
mediump vec3 u_xlat16_7;
float u_xlat8;
mediump float u_xlat16_8;
mediump float u_xlat16_14;
float u_xlat17;
mediump float u_xlat16_17;
float u_xlat24;
mediump float u_xlat16_30;
mediump float u_xlat16_31;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat24 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat24 = _ZBufferParams.x * u_xlat24 + _ZBufferParams.y;
    u_xlat24 = float(1.0) / u_xlat24;
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat0.xyz;
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
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat8 = sqrt(u_xlat0.x);
    u_xlat8 = u_xlat8 * _LightPositionRange.w;
    u_xlat8 = u_xlat8 * _LightProjectionParams.w;
    u_xlatb4 = lessThan(u_xlat4, vec4(u_xlat8));
    u_xlat4.x = (u_xlatb4.x) ? _LightShadowData.x : float(1.0);
    u_xlat4.y = (u_xlatb4.y) ? _LightShadowData.x : float(1.0);
    u_xlat4.z = (u_xlatb4.z) ? _LightShadowData.x : float(1.0);
    u_xlat4.w = (u_xlatb4.w) ? _LightShadowData.x : float(1.0);
    u_xlat16_6.x = dot(u_xlat4, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat4.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat8 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat8 = sqrt(u_xlat8);
    u_xlat8 = (-u_xlat0.z) * u_xlat24 + u_xlat8;
    u_xlat8 = unity_ShadowFadeCenterAndType.w * u_xlat8 + u_xlat2.z;
    u_xlat8 = u_xlat8 * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat8 = min(max(u_xlat8, 0.0), 1.0);
#else
    u_xlat8 = clamp(u_xlat8, 0.0, 1.0);
#endif
    u_xlat16_6.x = u_xlat8 + u_xlat16_6.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_6.x = min(max(u_xlat16_6.x, 0.0), 1.0);
#else
    u_xlat16_6.x = clamp(u_xlat16_6.x, 0.0, 1.0);
#endif
    u_xlat8 = u_xlat0.x * _LightPos.w;
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat0.xzw = u_xlat0.xxx * u_xlat3.xyz;
    u_xlat8 = texture(_LightTextureB0, vec2(u_xlat8)).w;
    u_xlat8 = u_xlat16_6.x * u_xlat8;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat3.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat3.xyz = u_xlat3.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat17 = texture(_LightTexture0, u_xlat3.xyz, -8.0).w;
    u_xlat8 = u_xlat8 * u_xlat17;
    u_xlat3.xyz = vec3(u_xlat8) * _LightColor.xyz;
    u_xlat8 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat8 = inversesqrt(u_xlat8);
    u_xlat16_6.xyz = (-u_xlat2.xyz) * vec3(u_xlat8) + (-u_xlat0.xzw);
    u_xlat16_30 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_8 = max(u_xlat16_30, 0.00100000005);
    u_xlat16_30 = inversesqrt(u_xlat16_8);
    u_xlat16_6.xyz = vec3(u_xlat16_30) * u_xlat16_6.xyz;
    u_xlat16_30 = dot((-u_xlat0.xzw), u_xlat16_6.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_30 = min(max(u_xlat16_30, 0.0), 1.0);
#else
    u_xlat16_30 = clamp(u_xlat16_30, 0.0, 1.0);
#endif
    u_xlat16_8 = max(u_xlat16_30, 0.319999993);
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat16_30 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_17 = u_xlat16_30 * u_xlat16_30 + 1.5;
    u_xlat16_30 = u_xlat16_30 * u_xlat16_30;
    u_xlat16_8 = u_xlat16_8 * u_xlat16_17;
    u_xlat10_4.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_7.xyz = u_xlat10_4.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_31 = dot(u_xlat16_7.xyz, u_xlat16_7.xyz);
    u_xlat16_31 = inversesqrt(u_xlat16_31);
    u_xlat16_7.xyz = vec3(u_xlat16_31) * u_xlat16_7.xyz;
    u_xlat16_6.x = dot(u_xlat16_7.xyz, u_xlat16_6.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_6.x = min(max(u_xlat16_6.x, 0.0), 1.0);
#else
    u_xlat16_6.x = clamp(u_xlat16_6.x, 0.0, 1.0);
#endif
    u_xlat16_14 = dot(u_xlat16_7.xyz, (-u_xlat0.xzw));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_14 = min(max(u_xlat16_14, 0.0), 1.0);
#else
    u_xlat16_14 = clamp(u_xlat16_14, 0.0, 1.0);
#endif
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_6.x;
    u_xlat16_0 = u_xlat16_30 * u_xlat16_30 + -1.0;
    u_xlat16_0 = u_xlat16_6.x * u_xlat16_0 + 1.00001001;
    u_xlat16_0 = u_xlat16_0 * u_xlat16_8;
    u_xlat16_0 = u_xlat16_30 / u_xlat16_0;
    u_xlat16_0 = u_xlat16_0 + -9.99999975e-05;
    u_xlat16_6.x = max(u_xlat16_0, 0.0);
    u_xlat16_6.x = min(u_xlat16_6.x, 100.0);
    u_xlat16_6.xzw = u_xlat16_6.xxx * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat16_6.xzw = u_xlat3.xyz * u_xlat16_6.xzw;
    SV_Target0.xyz = vec3(u_xlat16_14) * u_xlat16_6.xzw;
    SV_Target0.w = 1.0;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
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
uniform 	vec4 hlslcc_mtx4x4unity_WorldToLight[4];
uniform highp sampler2D _CameraDepthTexture;
uniform highp sampler2D _LightTextureB0;
uniform highp samplerCube _LightTexture0;
uniform lowp sampler2D _CameraGBufferTexture0;
uniform lowp sampler2D _CameraGBufferTexture1;
uniform lowp sampler2D _CameraGBufferTexture2;
uniform lowp samplerCube _ShadowMapTexture;
in highp vec4 vs_TEXCOORD0;
in highp vec3 vs_TEXCOORD1;
layout(location = 0) out mediump vec4 SV_Target0;
vec4 u_xlat0;
mediump float u_xlat16_0;
vec2 u_xlat1;
lowp vec3 u_xlat10_1;
vec4 u_xlat2;
lowp vec4 u_xlat10_2;
vec3 u_xlat3;
vec4 u_xlat4;
lowp vec4 u_xlat10_4;
bvec4 u_xlatb4;
vec3 u_xlat5;
lowp vec4 u_xlat10_5;
mediump vec4 u_xlat16_6;
mediump vec3 u_xlat16_7;
float u_xlat8;
mediump float u_xlat16_8;
mediump float u_xlat16_14;
float u_xlat17;
mediump float u_xlat16_17;
float u_xlat24;
mediump float u_xlat16_30;
mediump float u_xlat16_31;
void main()
{
    u_xlat0.x = _ProjectionParams.z / vs_TEXCOORD1.z;
    u_xlat0.xyz = u_xlat0.xxx * vs_TEXCOORD1.xyz;
    u_xlat1.xy = vs_TEXCOORD0.xy / vs_TEXCOORD0.ww;
    u_xlat24 = texture(_CameraDepthTexture, u_xlat1.xy).x;
    u_xlat24 = _ZBufferParams.x * u_xlat24 + _ZBufferParams.y;
    u_xlat24 = float(1.0) / u_xlat24;
    u_xlat2.xyz = vec3(u_xlat24) * u_xlat0.xyz;
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
    u_xlat0.x = dot(u_xlat3.xyz, u_xlat3.xyz);
    u_xlat8 = sqrt(u_xlat0.x);
    u_xlat8 = u_xlat8 * _LightPositionRange.w;
    u_xlat8 = u_xlat8 * _LightProjectionParams.w;
    u_xlatb4 = lessThan(u_xlat4, vec4(u_xlat8));
    u_xlat4.x = (u_xlatb4.x) ? _LightShadowData.x : float(1.0);
    u_xlat4.y = (u_xlatb4.y) ? _LightShadowData.x : float(1.0);
    u_xlat4.z = (u_xlatb4.z) ? _LightShadowData.x : float(1.0);
    u_xlat4.w = (u_xlatb4.w) ? _LightShadowData.x : float(1.0);
    u_xlat16_6.x = dot(u_xlat4, vec4(0.25, 0.25, 0.25, 0.25));
    u_xlat4.xyz = u_xlat2.xyw + (-unity_ShadowFadeCenterAndType.xyz);
    u_xlat8 = dot(u_xlat4.xyz, u_xlat4.xyz);
    u_xlat8 = sqrt(u_xlat8);
    u_xlat8 = (-u_xlat0.z) * u_xlat24 + u_xlat8;
    u_xlat8 = unity_ShadowFadeCenterAndType.w * u_xlat8 + u_xlat2.z;
    u_xlat8 = u_xlat8 * _LightShadowData.z + _LightShadowData.w;
#ifdef UNITY_ADRENO_ES3
    u_xlat8 = min(max(u_xlat8, 0.0), 1.0);
#else
    u_xlat8 = clamp(u_xlat8, 0.0, 1.0);
#endif
    u_xlat16_6.x = u_xlat8 + u_xlat16_6.x;
#ifdef UNITY_ADRENO_ES3
    u_xlat16_6.x = min(max(u_xlat16_6.x, 0.0), 1.0);
#else
    u_xlat16_6.x = clamp(u_xlat16_6.x, 0.0, 1.0);
#endif
    u_xlat8 = u_xlat0.x * _LightPos.w;
    u_xlat0.x = inversesqrt(u_xlat0.x);
    u_xlat0.xzw = u_xlat0.xxx * u_xlat3.xyz;
    u_xlat8 = texture(_LightTextureB0, vec2(u_xlat8)).w;
    u_xlat8 = u_xlat16_6.x * u_xlat8;
    u_xlat3.xyz = u_xlat2.yyy * hlslcc_mtx4x4unity_WorldToLight[1].xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[0].xyz * u_xlat2.xxx + u_xlat3.xyz;
    u_xlat3.xyz = hlslcc_mtx4x4unity_WorldToLight[2].xyz * u_xlat2.www + u_xlat3.xyz;
    u_xlat2.xyz = u_xlat2.xyw + (-_WorldSpaceCameraPos.xyz);
    u_xlat3.xyz = u_xlat3.xyz + hlslcc_mtx4x4unity_WorldToLight[3].xyz;
    u_xlat17 = texture(_LightTexture0, u_xlat3.xyz, -8.0).w;
    u_xlat8 = u_xlat8 * u_xlat17;
    u_xlat3.xyz = vec3(u_xlat8) * _LightColor.xyz;
    u_xlat8 = dot(u_xlat2.xyz, u_xlat2.xyz);
    u_xlat8 = inversesqrt(u_xlat8);
    u_xlat16_6.xyz = (-u_xlat2.xyz) * vec3(u_xlat8) + (-u_xlat0.xzw);
    u_xlat16_30 = dot(u_xlat16_6.xyz, u_xlat16_6.xyz);
    u_xlat16_8 = max(u_xlat16_30, 0.00100000005);
    u_xlat16_30 = inversesqrt(u_xlat16_8);
    u_xlat16_6.xyz = vec3(u_xlat16_30) * u_xlat16_6.xyz;
    u_xlat16_30 = dot((-u_xlat0.xzw), u_xlat16_6.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_30 = min(max(u_xlat16_30, 0.0), 1.0);
#else
    u_xlat16_30 = clamp(u_xlat16_30, 0.0, 1.0);
#endif
    u_xlat16_8 = max(u_xlat16_30, 0.319999993);
    u_xlat10_2 = texture(_CameraGBufferTexture1, u_xlat1.xy);
    u_xlat16_30 = (-u_xlat10_2.w) + 1.0;
    u_xlat16_17 = u_xlat16_30 * u_xlat16_30 + 1.5;
    u_xlat16_30 = u_xlat16_30 * u_xlat16_30;
    u_xlat16_8 = u_xlat16_8 * u_xlat16_17;
    u_xlat10_4.xyz = texture(_CameraGBufferTexture2, u_xlat1.xy).xyz;
    u_xlat10_1.xyz = texture(_CameraGBufferTexture0, u_xlat1.xy).xyz;
    u_xlat16_7.xyz = u_xlat10_4.xyz * vec3(2.0, 2.0, 2.0) + vec3(-1.0, -1.0, -1.0);
    u_xlat16_31 = dot(u_xlat16_7.xyz, u_xlat16_7.xyz);
    u_xlat16_31 = inversesqrt(u_xlat16_31);
    u_xlat16_7.xyz = vec3(u_xlat16_31) * u_xlat16_7.xyz;
    u_xlat16_6.x = dot(u_xlat16_7.xyz, u_xlat16_6.xyz);
#ifdef UNITY_ADRENO_ES3
    u_xlat16_6.x = min(max(u_xlat16_6.x, 0.0), 1.0);
#else
    u_xlat16_6.x = clamp(u_xlat16_6.x, 0.0, 1.0);
#endif
    u_xlat16_14 = dot(u_xlat16_7.xyz, (-u_xlat0.xzw));
#ifdef UNITY_ADRENO_ES3
    u_xlat16_14 = min(max(u_xlat16_14, 0.0), 1.0);
#else
    u_xlat16_14 = clamp(u_xlat16_14, 0.0, 1.0);
#endif
    u_xlat16_6.x = u_xlat16_6.x * u_xlat16_6.x;
    u_xlat16_0 = u_xlat16_30 * u_xlat16_30 + -1.0;
    u_xlat16_0 = u_xlat16_6.x * u_xlat16_0 + 1.00001001;
    u_xlat16_0 = u_xlat16_0 * u_xlat16_8;
    u_xlat16_0 = u_xlat16_30 / u_xlat16_0;
    u_xlat16_0 = u_xlat16_0 + -9.99999975e-05;
    u_xlat16_6.x = max(u_xlat16_0, 0.0);
    u_xlat16_6.x = min(u_xlat16_6.x, 100.0);
    u_xlat16_6.xzw = u_xlat16_6.xxx * u_xlat10_2.xyz + u_xlat10_1.xyz;
    u_xlat16_6.xzw = u_xlat3.xyz * u_xlat16_6.xzw;
    SV_Target0.xyz = vec3(u_xlat16_14) * u_xlat16_6.xzw;
    SV_Target0.w = 1.0;
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
SubProgram "gles hw_tier00 " {
Keywords { "POINT" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "POINT" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "DIRECTIONAL" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "DIRECTIONAL" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "DIRECTIONAL" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "DIRECTIONAL" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "SPOT" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "SPOT" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "SPOT" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SPOT" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SPOT" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SPOT" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT_COOKIE" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT_COOKIE" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT_COOKIE" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "POINT_COOKIE" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT_COOKIE" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT_COOKIE" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "DIRECTIONAL_COOKIE" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "DIRECTIONAL_COOKIE" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "SPOT" "SHADOWS_DEPTH" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "DIRECTIONAL" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "DIRECTIONAL_COOKIE" "SHADOWS_SCREEN" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT" "SHADOWS_CUBE" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "POINT" "SHADOWS_CUBE" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "POINT_COOKIE" "SHADOWS_CUBE" "SHADOWS_SOFT" "UNITY_HDR_ON" }
""
}
}
}
 Pass {
  ZTest Always
  ZWrite Off
  Cull Off
  GpuProgramID 66195
Program "vp" {
SubProgram "gles hw_tier00 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _LightBuffer;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = -(log2(texture2D (_LightBuffer, xlv_TEXCOORD0)));
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
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _LightBuffer;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = -(log2(texture2D (_LightBuffer, xlv_TEXCOORD0)));
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
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
}


#endif
#ifdef FRAGMENT
uniform sampler2D _LightBuffer;
varying highp vec2 xlv_TEXCOORD0;
void main ()
{
  lowp vec4 tmpvar_1;
  tmpvar_1 = -(log2(texture2D (_LightBuffer, xlv_TEXCOORD0)));
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
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _LightBuffer;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
mediump vec4 u_xlat16_0;
lowp vec4 u_xlat10_0;
void main()
{
    u_xlat10_0 = texture(_LightBuffer, vs_TEXCOORD0.xy);
    u_xlat16_0 = log2(u_xlat10_0);
    SV_Target0 = (-u_xlat16_0);
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
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _LightBuffer;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
mediump vec4 u_xlat16_0;
lowp vec4 u_xlat10_0;
void main()
{
    u_xlat10_0 = texture(_LightBuffer, vs_TEXCOORD0.xy);
    u_xlat16_0 = log2(u_xlat10_0);
    SV_Target0 = (-u_xlat16_0);
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
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform lowp sampler2D _LightBuffer;
in highp vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
mediump vec4 u_xlat16_0;
lowp vec4 u_xlat10_0;
void main()
{
    u_xlat10_0 = texture(_LightBuffer, vs_TEXCOORD0.xy);
    u_xlat16_0 = log2(u_xlat10_0);
    SV_Target0 = (-u_xlat16_0);
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