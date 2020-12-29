//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Hidden/CubeBlend" {
Properties {
_TexA ("Cubemap", Cube) = "grey" { }
_TexB ("Cubemap", Cube) = "grey" { }
_value ("Value", Range(0, 1)) = 0.5
}
SubShader {
 Tags { "QUEUE" = "Background" "RenderType" = "Background" }
 Pass {
  Tags { "QUEUE" = "Background" "RenderType" = "Background" }
  ZTest Always
  ZWrite Off
  GpuProgramID 19854
Program "vp" {
SubProgram "gles hw_tier00 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec3 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xyz;
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

uniform mediump vec4 _TexA_HDR;
uniform mediump vec4 _TexB_HDR;
uniform lowp samplerCube _TexA;
uniform lowp samplerCube _TexB;
uniform highp float _Level;
uniform highp float _value;
varying highp vec3 xlv_TEXCOORD0;
void main ()
{
  mediump vec3 res_1;
  mediump vec4 tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = impl_low_textureCubeLodEXT (_TexA, xlv_TEXCOORD0, _Level);
  tmpvar_2 = tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_4 = ((_TexA_HDR.x * (
    (_TexA_HDR.w * (tmpvar_2.w - 1.0))
   + 1.0)) * tmpvar_2.xyz);
  mediump vec4 tmpvar_5;
  lowp vec4 tmpvar_6;
  tmpvar_6 = impl_low_textureCubeLodEXT (_TexB, xlv_TEXCOORD0, _Level);
  tmpvar_5 = tmpvar_6;
  mediump vec3 tmpvar_7;
  tmpvar_7 = ((_TexB_HDR.x * (
    (_TexB_HDR.w * (tmpvar_5.w - 1.0))
   + 1.0)) * tmpvar_5.xyz);
  highp vec3 tmpvar_8;
  tmpvar_8 = mix (tmpvar_4, tmpvar_7, vec3(_value));
  res_1 = tmpvar_8;
  mediump vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = res_1;
  gl_FragData[0] = tmpvar_9;
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
varying highp vec3 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xyz;
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

uniform mediump vec4 _TexA_HDR;
uniform mediump vec4 _TexB_HDR;
uniform lowp samplerCube _TexA;
uniform lowp samplerCube _TexB;
uniform highp float _Level;
uniform highp float _value;
varying highp vec3 xlv_TEXCOORD0;
void main ()
{
  mediump vec3 res_1;
  mediump vec4 tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = impl_low_textureCubeLodEXT (_TexA, xlv_TEXCOORD0, _Level);
  tmpvar_2 = tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_4 = ((_TexA_HDR.x * (
    (_TexA_HDR.w * (tmpvar_2.w - 1.0))
   + 1.0)) * tmpvar_2.xyz);
  mediump vec4 tmpvar_5;
  lowp vec4 tmpvar_6;
  tmpvar_6 = impl_low_textureCubeLodEXT (_TexB, xlv_TEXCOORD0, _Level);
  tmpvar_5 = tmpvar_6;
  mediump vec3 tmpvar_7;
  tmpvar_7 = ((_TexB_HDR.x * (
    (_TexB_HDR.w * (tmpvar_5.w - 1.0))
   + 1.0)) * tmpvar_5.xyz);
  highp vec3 tmpvar_8;
  tmpvar_8 = mix (tmpvar_4, tmpvar_7, vec3(_value));
  res_1 = tmpvar_8;
  mediump vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = res_1;
  gl_FragData[0] = tmpvar_9;
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
varying highp vec3 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xyz;
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

uniform mediump vec4 _TexA_HDR;
uniform mediump vec4 _TexB_HDR;
uniform lowp samplerCube _TexA;
uniform lowp samplerCube _TexB;
uniform highp float _Level;
uniform highp float _value;
varying highp vec3 xlv_TEXCOORD0;
void main ()
{
  mediump vec3 res_1;
  mediump vec4 tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = impl_low_textureCubeLodEXT (_TexA, xlv_TEXCOORD0, _Level);
  tmpvar_2 = tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_4 = ((_TexA_HDR.x * (
    (_TexA_HDR.w * (tmpvar_2.w - 1.0))
   + 1.0)) * tmpvar_2.xyz);
  mediump vec4 tmpvar_5;
  lowp vec4 tmpvar_6;
  tmpvar_6 = impl_low_textureCubeLodEXT (_TexB, xlv_TEXCOORD0, _Level);
  tmpvar_5 = tmpvar_6;
  mediump vec3 tmpvar_7;
  tmpvar_7 = ((_TexB_HDR.x * (
    (_TexB_HDR.w * (tmpvar_5.w - 1.0))
   + 1.0)) * tmpvar_5.xyz);
  highp vec3 tmpvar_8;
  tmpvar_8 = mix (tmpvar_4, tmpvar_7, vec3(_value));
  res_1 = tmpvar_8;
  mediump vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = res_1;
  gl_FragData[0] = tmpvar_9;
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
in highp vec3 in_TEXCOORD0;
out highp vec3 vs_TEXCOORD0;
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
    vs_TEXCOORD0.xyz = in_TEXCOORD0.xyz;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	mediump vec4 _TexA_HDR;
uniform 	mediump vec4 _TexB_HDR;
uniform 	float _Level;
uniform 	float _value;
uniform lowp samplerCube _TexA;
uniform lowp samplerCube _TexB;
in highp vec3 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
mediump vec3 u_xlat16_0;
lowp vec4 u_xlat10_0;
mediump vec3 u_xlat16_1;
mediump float u_xlat16_7;
void main()
{
    u_xlat10_0 = textureLod(_TexA, vs_TEXCOORD0.xyz, _Level);
    u_xlat16_1.x = u_xlat10_0.w + -1.0;
    u_xlat16_1.x = _TexA_HDR.w * u_xlat16_1.x + 1.0;
    u_xlat16_1.x = u_xlat16_1.x * _TexA_HDR.x;
    u_xlat16_1.xyz = u_xlat10_0.xyz * u_xlat16_1.xxx;
    u_xlat10_0 = textureLod(_TexB, vs_TEXCOORD0.xyz, _Level);
    u_xlat16_7 = u_xlat10_0.w + -1.0;
    u_xlat16_7 = _TexB_HDR.w * u_xlat16_7 + 1.0;
    u_xlat16_7 = u_xlat16_7 * _TexB_HDR.x;
    u_xlat16_0.xyz = vec3(u_xlat16_7) * u_xlat10_0.xyz + (-u_xlat16_1.xyz);
    u_xlat0.xyz = vec3(vec3(_value, _value, _value)) * u_xlat16_0.xyz + u_xlat16_1.xyz;
    SV_Target0.xyz = u_xlat0.xyz;
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
in highp vec4 in_POSITION0;
in highp vec3 in_TEXCOORD0;
out highp vec3 vs_TEXCOORD0;
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
    vs_TEXCOORD0.xyz = in_TEXCOORD0.xyz;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	mediump vec4 _TexA_HDR;
uniform 	mediump vec4 _TexB_HDR;
uniform 	float _Level;
uniform 	float _value;
uniform lowp samplerCube _TexA;
uniform lowp samplerCube _TexB;
in highp vec3 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
mediump vec3 u_xlat16_0;
lowp vec4 u_xlat10_0;
mediump vec3 u_xlat16_1;
mediump float u_xlat16_7;
void main()
{
    u_xlat10_0 = textureLod(_TexA, vs_TEXCOORD0.xyz, _Level);
    u_xlat16_1.x = u_xlat10_0.w + -1.0;
    u_xlat16_1.x = _TexA_HDR.w * u_xlat16_1.x + 1.0;
    u_xlat16_1.x = u_xlat16_1.x * _TexA_HDR.x;
    u_xlat16_1.xyz = u_xlat10_0.xyz * u_xlat16_1.xxx;
    u_xlat10_0 = textureLod(_TexB, vs_TEXCOORD0.xyz, _Level);
    u_xlat16_7 = u_xlat10_0.w + -1.0;
    u_xlat16_7 = _TexB_HDR.w * u_xlat16_7 + 1.0;
    u_xlat16_7 = u_xlat16_7 * _TexB_HDR.x;
    u_xlat16_0.xyz = vec3(u_xlat16_7) * u_xlat10_0.xyz + (-u_xlat16_1.xyz);
    u_xlat0.xyz = vec3(vec3(_value, _value, _value)) * u_xlat16_0.xyz + u_xlat16_1.xyz;
    SV_Target0.xyz = u_xlat0.xyz;
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
in highp vec4 in_POSITION0;
in highp vec3 in_TEXCOORD0;
out highp vec3 vs_TEXCOORD0;
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
    vs_TEXCOORD0.xyz = in_TEXCOORD0.xyz;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	mediump vec4 _TexA_HDR;
uniform 	mediump vec4 _TexB_HDR;
uniform 	float _Level;
uniform 	float _value;
uniform lowp samplerCube _TexA;
uniform lowp samplerCube _TexB;
in highp vec3 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
mediump vec3 u_xlat16_0;
lowp vec4 u_xlat10_0;
mediump vec3 u_xlat16_1;
mediump float u_xlat16_7;
void main()
{
    u_xlat10_0 = textureLod(_TexA, vs_TEXCOORD0.xyz, _Level);
    u_xlat16_1.x = u_xlat10_0.w + -1.0;
    u_xlat16_1.x = _TexA_HDR.w * u_xlat16_1.x + 1.0;
    u_xlat16_1.x = u_xlat16_1.x * _TexA_HDR.x;
    u_xlat16_1.xyz = u_xlat10_0.xyz * u_xlat16_1.xxx;
    u_xlat10_0 = textureLod(_TexB, vs_TEXCOORD0.xyz, _Level);
    u_xlat16_7 = u_xlat10_0.w + -1.0;
    u_xlat16_7 = _TexB_HDR.w * u_xlat16_7 + 1.0;
    u_xlat16_7 = u_xlat16_7 * _TexB_HDR.x;
    u_xlat16_0.xyz = vec3(u_xlat16_7) * u_xlat10_0.xyz + (-u_xlat16_1.xyz);
    u_xlat0.xyz = vec3(vec3(_value, _value, _value)) * u_xlat16_0.xyz + u_xlat16_1.xyz;
    SV_Target0.xyz = u_xlat0.xyz;
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
}
SubShader {
 Tags { "QUEUE" = "Background" "RenderType" = "Background" }
 Pass {
  Tags { "QUEUE" = "Background" "RenderType" = "Background" }
  ZTest Always
  ZWrite Off
  GpuProgramID 105093
Program "vp" {
SubProgram "gles hw_tier00 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying highp vec3 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xyz;
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

uniform mediump vec4 _TexA_HDR;
uniform mediump vec4 _TexB_HDR;
uniform lowp samplerCube _TexA;
uniform lowp samplerCube _TexB;
uniform highp float _Level;
uniform highp float _value;
varying highp vec3 xlv_TEXCOORD0;
void main ()
{
  mediump vec3 res_1;
  mediump vec4 tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = impl_low_textureCubeLodEXT (_TexA, xlv_TEXCOORD0, _Level);
  tmpvar_2 = tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_4 = ((_TexA_HDR.x * (
    (_TexA_HDR.w * (tmpvar_2.w - 1.0))
   + 1.0)) * tmpvar_2.xyz);
  mediump vec4 tmpvar_5;
  lowp vec4 tmpvar_6;
  tmpvar_6 = impl_low_textureCubeLodEXT (_TexB, xlv_TEXCOORD0, _Level);
  tmpvar_5 = tmpvar_6;
  mediump vec3 tmpvar_7;
  tmpvar_7 = ((_TexB_HDR.x * (
    (_TexB_HDR.w * (tmpvar_5.w - 1.0))
   + 1.0)) * tmpvar_5.xyz);
  highp vec3 tmpvar_8;
  tmpvar_8 = mix (tmpvar_4, tmpvar_7, vec3(_value));
  res_1 = tmpvar_8;
  mediump vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = res_1;
  gl_FragData[0] = tmpvar_9;
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
varying highp vec3 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xyz;
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

uniform mediump vec4 _TexA_HDR;
uniform mediump vec4 _TexB_HDR;
uniform lowp samplerCube _TexA;
uniform lowp samplerCube _TexB;
uniform highp float _Level;
uniform highp float _value;
varying highp vec3 xlv_TEXCOORD0;
void main ()
{
  mediump vec3 res_1;
  mediump vec4 tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = impl_low_textureCubeLodEXT (_TexA, xlv_TEXCOORD0, _Level);
  tmpvar_2 = tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_4 = ((_TexA_HDR.x * (
    (_TexA_HDR.w * (tmpvar_2.w - 1.0))
   + 1.0)) * tmpvar_2.xyz);
  mediump vec4 tmpvar_5;
  lowp vec4 tmpvar_6;
  tmpvar_6 = impl_low_textureCubeLodEXT (_TexB, xlv_TEXCOORD0, _Level);
  tmpvar_5 = tmpvar_6;
  mediump vec3 tmpvar_7;
  tmpvar_7 = ((_TexB_HDR.x * (
    (_TexB_HDR.w * (tmpvar_5.w - 1.0))
   + 1.0)) * tmpvar_5.xyz);
  highp vec3 tmpvar_8;
  tmpvar_8 = mix (tmpvar_4, tmpvar_7, vec3(_value));
  res_1 = tmpvar_8;
  mediump vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = res_1;
  gl_FragData[0] = tmpvar_9;
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
varying highp vec3 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1.w = 1.0;
  tmpvar_1.xyz = _glesVertex.xyz;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_1));
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xyz;
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

uniform mediump vec4 _TexA_HDR;
uniform mediump vec4 _TexB_HDR;
uniform lowp samplerCube _TexA;
uniform lowp samplerCube _TexB;
uniform highp float _Level;
uniform highp float _value;
varying highp vec3 xlv_TEXCOORD0;
void main ()
{
  mediump vec3 res_1;
  mediump vec4 tmpvar_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = impl_low_textureCubeLodEXT (_TexA, xlv_TEXCOORD0, _Level);
  tmpvar_2 = tmpvar_3;
  mediump vec3 tmpvar_4;
  tmpvar_4 = ((_TexA_HDR.x * (
    (_TexA_HDR.w * (tmpvar_2.w - 1.0))
   + 1.0)) * tmpvar_2.xyz);
  mediump vec4 tmpvar_5;
  lowp vec4 tmpvar_6;
  tmpvar_6 = impl_low_textureCubeLodEXT (_TexB, xlv_TEXCOORD0, _Level);
  tmpvar_5 = tmpvar_6;
  mediump vec3 tmpvar_7;
  tmpvar_7 = ((_TexB_HDR.x * (
    (_TexB_HDR.w * (tmpvar_5.w - 1.0))
   + 1.0)) * tmpvar_5.xyz);
  highp vec3 tmpvar_8;
  tmpvar_8 = mix (tmpvar_4, tmpvar_7, vec3(_value));
  res_1 = tmpvar_8;
  mediump vec4 tmpvar_9;
  tmpvar_9.w = 1.0;
  tmpvar_9.xyz = res_1;
  gl_FragData[0] = tmpvar_9;
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
in highp vec3 in_TEXCOORD0;
out highp vec3 vs_TEXCOORD0;
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
    vs_TEXCOORD0.xyz = in_TEXCOORD0.xyz;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	mediump vec4 _TexA_HDR;
uniform 	mediump vec4 _TexB_HDR;
uniform 	float _Level;
uniform 	float _value;
uniform lowp samplerCube _TexA;
uniform lowp samplerCube _TexB;
in highp vec3 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
mediump vec3 u_xlat16_0;
lowp vec4 u_xlat10_0;
mediump vec3 u_xlat16_1;
mediump float u_xlat16_7;
void main()
{
    u_xlat10_0 = textureLod(_TexA, vs_TEXCOORD0.xyz, _Level);
    u_xlat16_1.x = u_xlat10_0.w + -1.0;
    u_xlat16_1.x = _TexA_HDR.w * u_xlat16_1.x + 1.0;
    u_xlat16_1.x = u_xlat16_1.x * _TexA_HDR.x;
    u_xlat16_1.xyz = u_xlat10_0.xyz * u_xlat16_1.xxx;
    u_xlat10_0 = textureLod(_TexB, vs_TEXCOORD0.xyz, _Level);
    u_xlat16_7 = u_xlat10_0.w + -1.0;
    u_xlat16_7 = _TexB_HDR.w * u_xlat16_7 + 1.0;
    u_xlat16_7 = u_xlat16_7 * _TexB_HDR.x;
    u_xlat16_0.xyz = vec3(u_xlat16_7) * u_xlat10_0.xyz + (-u_xlat16_1.xyz);
    u_xlat0.xyz = vec3(vec3(_value, _value, _value)) * u_xlat16_0.xyz + u_xlat16_1.xyz;
    SV_Target0.xyz = u_xlat0.xyz;
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
in highp vec4 in_POSITION0;
in highp vec3 in_TEXCOORD0;
out highp vec3 vs_TEXCOORD0;
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
    vs_TEXCOORD0.xyz = in_TEXCOORD0.xyz;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	mediump vec4 _TexA_HDR;
uniform 	mediump vec4 _TexB_HDR;
uniform 	float _Level;
uniform 	float _value;
uniform lowp samplerCube _TexA;
uniform lowp samplerCube _TexB;
in highp vec3 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
mediump vec3 u_xlat16_0;
lowp vec4 u_xlat10_0;
mediump vec3 u_xlat16_1;
mediump float u_xlat16_7;
void main()
{
    u_xlat10_0 = textureLod(_TexA, vs_TEXCOORD0.xyz, _Level);
    u_xlat16_1.x = u_xlat10_0.w + -1.0;
    u_xlat16_1.x = _TexA_HDR.w * u_xlat16_1.x + 1.0;
    u_xlat16_1.x = u_xlat16_1.x * _TexA_HDR.x;
    u_xlat16_1.xyz = u_xlat10_0.xyz * u_xlat16_1.xxx;
    u_xlat10_0 = textureLod(_TexB, vs_TEXCOORD0.xyz, _Level);
    u_xlat16_7 = u_xlat10_0.w + -1.0;
    u_xlat16_7 = _TexB_HDR.w * u_xlat16_7 + 1.0;
    u_xlat16_7 = u_xlat16_7 * _TexB_HDR.x;
    u_xlat16_0.xyz = vec3(u_xlat16_7) * u_xlat10_0.xyz + (-u_xlat16_1.xyz);
    u_xlat0.xyz = vec3(vec3(_value, _value, _value)) * u_xlat16_0.xyz + u_xlat16_1.xyz;
    SV_Target0.xyz = u_xlat0.xyz;
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
in highp vec4 in_POSITION0;
in highp vec3 in_TEXCOORD0;
out highp vec3 vs_TEXCOORD0;
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
    vs_TEXCOORD0.xyz = in_TEXCOORD0.xyz;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	mediump vec4 _TexA_HDR;
uniform 	mediump vec4 _TexB_HDR;
uniform 	float _Level;
uniform 	float _value;
uniform lowp samplerCube _TexA;
uniform lowp samplerCube _TexB;
in highp vec3 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
vec3 u_xlat0;
mediump vec3 u_xlat16_0;
lowp vec4 u_xlat10_0;
mediump vec3 u_xlat16_1;
mediump float u_xlat16_7;
void main()
{
    u_xlat10_0 = textureLod(_TexA, vs_TEXCOORD0.xyz, _Level);
    u_xlat16_1.x = u_xlat10_0.w + -1.0;
    u_xlat16_1.x = _TexA_HDR.w * u_xlat16_1.x + 1.0;
    u_xlat16_1.x = u_xlat16_1.x * _TexA_HDR.x;
    u_xlat16_1.xyz = u_xlat10_0.xyz * u_xlat16_1.xxx;
    u_xlat10_0 = textureLod(_TexB, vs_TEXCOORD0.xyz, _Level);
    u_xlat16_7 = u_xlat10_0.w + -1.0;
    u_xlat16_7 = _TexB_HDR.w * u_xlat16_7 + 1.0;
    u_xlat16_7 = u_xlat16_7 * _TexB_HDR.x;
    u_xlat16_0.xyz = vec3(u_xlat16_7) * u_xlat10_0.xyz + (-u_xlat16_1.xyz);
    u_xlat0.xyz = vec3(vec3(_value, _value, _value)) * u_xlat16_0.xyz + u_xlat16_1.xyz;
    SV_Target0.xyz = u_xlat0.xyz;
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
}
}