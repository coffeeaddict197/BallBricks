//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Sprites/Mask" {
Properties {
_MainTex ("Sprite Texture", 2D) = "white" { }
_AlphaTex ("External Alpha", 2D) = "white" { }
_Cutoff ("Mask alpha cutoff", Range(0, 1)) = 0
_Color ("Tint", Color) = (1,1,1,0.2)
_EnableExternalAlpha ("Enable External Alpha", Float) = 0
[MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
}
SubShader {
 Tags { "CanUseSpriteAtlas" = "true" "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
 Pass {
  Tags { "CanUseSpriteAtlas" = "true" "IGNOREPROJECTOR" = "true" "PreviewType" = "Plane" "QUEUE" = "Transparent" "RenderType" = "Transparent" }
  ZWrite Off
  Cull Off
  GpuProgramID 59372
Program "vp" {
SubProgram "gles hw_tier00 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying mediump vec2 xlv_TEXCOORD0;
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
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
uniform lowp float _Cutoff;
varying mediump vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec2 uv_1;
  uv_1 = xlv_TEXCOORD0;
  lowp float x_2;
  x_2 = (texture2D (_MainTex, uv_1).w - _Cutoff);
  if ((x_2 < 0.0)) {
    discard;
  };
  gl_FragData[0] = _Color;
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
varying mediump vec2 xlv_TEXCOORD0;
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
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
uniform lowp float _Cutoff;
varying mediump vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec2 uv_1;
  uv_1 = xlv_TEXCOORD0;
  lowp float x_2;
  x_2 = (texture2D (_MainTex, uv_1).w - _Cutoff);
  if ((x_2 < 0.0)) {
    discard;
  };
  gl_FragData[0] = _Color;
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
varying mediump vec2 xlv_TEXCOORD0;
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
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
uniform lowp float _Cutoff;
varying mediump vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec2 uv_1;
  uv_1 = xlv_TEXCOORD0;
  lowp float x_2;
  x_2 = (texture2D (_MainTex, uv_1).w - _Cutoff);
  if ((x_2 < 0.0)) {
    discard;
  };
  gl_FragData[0] = _Color;
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
in mediump vec2 in_TEXCOORD0;
out mediump vec2 vs_TEXCOORD0;
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
uniform 	mediump vec4 _Color;
uniform 	mediump float _Cutoff;
uniform lowp sampler2D _MainTex;
in mediump vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
lowp float u_xlat10_0;
bool u_xlatb0;
mediump float u_xlat16_1;
void main()
{
    u_xlat10_0 = texture(_MainTex, vs_TEXCOORD0.xy).w;
    u_xlat16_1 = u_xlat10_0 + (-_Cutoff);
#ifdef UNITY_ADRENO_ES3
    u_xlatb0 = !!(u_xlat16_1<0.0);
#else
    u_xlatb0 = u_xlat16_1<0.0;
#endif
    if((int(u_xlatb0) * int(0xffffffffu))!=0){discard;}
    SV_Target0 = _Color;
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
in mediump vec2 in_TEXCOORD0;
out mediump vec2 vs_TEXCOORD0;
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
uniform 	mediump vec4 _Color;
uniform 	mediump float _Cutoff;
uniform lowp sampler2D _MainTex;
in mediump vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
lowp float u_xlat10_0;
bool u_xlatb0;
mediump float u_xlat16_1;
void main()
{
    u_xlat10_0 = texture(_MainTex, vs_TEXCOORD0.xy).w;
    u_xlat16_1 = u_xlat10_0 + (-_Cutoff);
#ifdef UNITY_ADRENO_ES3
    u_xlatb0 = !!(u_xlat16_1<0.0);
#else
    u_xlatb0 = u_xlat16_1<0.0;
#endif
    if((int(u_xlatb0) * int(0xffffffffu))!=0){discard;}
    SV_Target0 = _Color;
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
in mediump vec2 in_TEXCOORD0;
out mediump vec2 vs_TEXCOORD0;
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
uniform 	mediump vec4 _Color;
uniform 	mediump float _Cutoff;
uniform lowp sampler2D _MainTex;
in mediump vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
lowp float u_xlat10_0;
bool u_xlatb0;
mediump float u_xlat16_1;
void main()
{
    u_xlat10_0 = texture(_MainTex, vs_TEXCOORD0.xy).w;
    u_xlat16_1 = u_xlat10_0 + (-_Cutoff);
#ifdef UNITY_ADRENO_ES3
    u_xlatb0 = !!(u_xlat16_1<0.0);
#else
    u_xlatb0 = u_xlat16_1<0.0;
#endif
    if((int(u_xlatb0) * int(0xffffffffu))!=0){discard;}
    SV_Target0 = _Color;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "ETC1_EXTERNAL_ALPHA" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying mediump vec2 xlv_TEXCOORD0;
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
uniform highp float _EnableExternalAlpha;
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
uniform sampler2D _AlphaTex;
uniform lowp float _Cutoff;
varying mediump vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec2 uv_1;
  uv_1 = xlv_TEXCOORD0;
  lowp vec4 color_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, uv_1);
  color_2.xyz = tmpvar_3.xyz;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_AlphaTex, uv_1);
  highp float tmpvar_5;
  tmpvar_5 = mix (tmpvar_3.w, tmpvar_4.x, _EnableExternalAlpha);
  color_2.w = tmpvar_5;
  lowp float x_6;
  x_6 = (color_2.w - _Cutoff);
  if ((x_6 < 0.0)) {
    discard;
  };
  gl_FragData[0] = _Color;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "ETC1_EXTERNAL_ALPHA" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying mediump vec2 xlv_TEXCOORD0;
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
uniform highp float _EnableExternalAlpha;
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
uniform sampler2D _AlphaTex;
uniform lowp float _Cutoff;
varying mediump vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec2 uv_1;
  uv_1 = xlv_TEXCOORD0;
  lowp vec4 color_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, uv_1);
  color_2.xyz = tmpvar_3.xyz;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_AlphaTex, uv_1);
  highp float tmpvar_5;
  tmpvar_5 = mix (tmpvar_3.w, tmpvar_4.x, _EnableExternalAlpha);
  color_2.w = tmpvar_5;
  lowp float x_6;
  x_6 = (color_2.w - _Cutoff);
  if ((x_6 < 0.0)) {
    discard;
  };
  gl_FragData[0] = _Color;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "ETC1_EXTERNAL_ALPHA" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying mediump vec2 xlv_TEXCOORD0;
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
uniform highp float _EnableExternalAlpha;
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
uniform sampler2D _AlphaTex;
uniform lowp float _Cutoff;
varying mediump vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec2 uv_1;
  uv_1 = xlv_TEXCOORD0;
  lowp vec4 color_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, uv_1);
  color_2.xyz = tmpvar_3.xyz;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_AlphaTex, uv_1);
  highp float tmpvar_5;
  tmpvar_5 = mix (tmpvar_3.w, tmpvar_4.x, _EnableExternalAlpha);
  color_2.w = tmpvar_5;
  lowp float x_6;
  x_6 = (color_2.w - _Cutoff);
  if ((x_6 < 0.0)) {
    discard;
  };
  gl_FragData[0] = _Color;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "ETC1_EXTERNAL_ALPHA" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in mediump vec2 in_TEXCOORD0;
out mediump vec2 vs_TEXCOORD0;
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
uniform 	float _EnableExternalAlpha;
uniform 	mediump vec4 _Color;
uniform 	mediump float _Cutoff;
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D _AlphaTex;
in mediump vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
float u_xlat0;
mediump float u_xlat16_0;
lowp float u_xlat10_0;
bool u_xlatb0;
mediump float u_xlat16_1;
lowp float u_xlat10_2;
void main()
{
    u_xlat10_0 = texture(_AlphaTex, vs_TEXCOORD0.xy).x;
    u_xlat10_2 = texture(_MainTex, vs_TEXCOORD0.xy).w;
    u_xlat16_0 = (-u_xlat10_2) + u_xlat10_0;
    u_xlat0 = _EnableExternalAlpha * u_xlat16_0 + u_xlat10_2;
    u_xlat16_1 = u_xlat0 + (-_Cutoff);
#ifdef UNITY_ADRENO_ES3
    u_xlatb0 = !!(u_xlat16_1<0.0);
#else
    u_xlatb0 = u_xlat16_1<0.0;
#endif
    if((int(u_xlatb0) * int(0xffffffffu))!=0){discard;}
    SV_Target0 = _Color;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "ETC1_EXTERNAL_ALPHA" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in mediump vec2 in_TEXCOORD0;
out mediump vec2 vs_TEXCOORD0;
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
uniform 	float _EnableExternalAlpha;
uniform 	mediump vec4 _Color;
uniform 	mediump float _Cutoff;
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D _AlphaTex;
in mediump vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
float u_xlat0;
mediump float u_xlat16_0;
lowp float u_xlat10_0;
bool u_xlatb0;
mediump float u_xlat16_1;
lowp float u_xlat10_2;
void main()
{
    u_xlat10_0 = texture(_AlphaTex, vs_TEXCOORD0.xy).x;
    u_xlat10_2 = texture(_MainTex, vs_TEXCOORD0.xy).w;
    u_xlat16_0 = (-u_xlat10_2) + u_xlat10_0;
    u_xlat0 = _EnableExternalAlpha * u_xlat16_0 + u_xlat10_2;
    u_xlat16_1 = u_xlat0 + (-_Cutoff);
#ifdef UNITY_ADRENO_ES3
    u_xlatb0 = !!(u_xlat16_1<0.0);
#else
    u_xlatb0 = u_xlat16_1<0.0;
#endif
    if((int(u_xlatb0) * int(0xffffffffu))!=0){discard;}
    SV_Target0 = _Color;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "ETC1_EXTERNAL_ALPHA" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in mediump vec2 in_TEXCOORD0;
out mediump vec2 vs_TEXCOORD0;
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
uniform 	float _EnableExternalAlpha;
uniform 	mediump vec4 _Color;
uniform 	mediump float _Cutoff;
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D _AlphaTex;
in mediump vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
float u_xlat0;
mediump float u_xlat16_0;
lowp float u_xlat10_0;
bool u_xlatb0;
mediump float u_xlat16_1;
lowp float u_xlat10_2;
void main()
{
    u_xlat10_0 = texture(_AlphaTex, vs_TEXCOORD0.xy).x;
    u_xlat10_2 = texture(_MainTex, vs_TEXCOORD0.xy).w;
    u_xlat16_0 = (-u_xlat10_2) + u_xlat10_0;
    u_xlat0 = _EnableExternalAlpha * u_xlat16_0 + u_xlat10_2;
    u_xlat16_1 = u_xlat0 + (-_Cutoff);
#ifdef UNITY_ADRENO_ES3
    u_xlatb0 = !!(u_xlat16_1<0.0);
#else
    u_xlatb0 = u_xlat16_1<0.0;
#endif
    if((int(u_xlatb0) * int(0xffffffffu))!=0){discard;}
    SV_Target0 = _Color;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "PIXELSNAP_ON" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp vec4 _ScreenParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying mediump vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _glesVertex.xyz;
  tmpvar_1 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_2));
  highp vec4 pos_3;
  pos_3.zw = tmpvar_1.zw;
  highp vec2 tmpvar_4;
  tmpvar_4 = (_ScreenParams.xy * 0.5);
  pos_3.xy = ((floor(
    (((tmpvar_1.xy / tmpvar_1.w) * tmpvar_4) + vec2(0.5, 0.5))
  ) / tmpvar_4) * tmpvar_1.w);
  gl_Position = pos_3;
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
}


#endif
#ifdef FRAGMENT
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
uniform lowp float _Cutoff;
varying mediump vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec2 uv_1;
  uv_1 = xlv_TEXCOORD0;
  lowp float x_2;
  x_2 = (texture2D (_MainTex, uv_1).w - _Cutoff);
  if ((x_2 < 0.0)) {
    discard;
  };
  gl_FragData[0] = _Color;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "PIXELSNAP_ON" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp vec4 _ScreenParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying mediump vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _glesVertex.xyz;
  tmpvar_1 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_2));
  highp vec4 pos_3;
  pos_3.zw = tmpvar_1.zw;
  highp vec2 tmpvar_4;
  tmpvar_4 = (_ScreenParams.xy * 0.5);
  pos_3.xy = ((floor(
    (((tmpvar_1.xy / tmpvar_1.w) * tmpvar_4) + vec2(0.5, 0.5))
  ) / tmpvar_4) * tmpvar_1.w);
  gl_Position = pos_3;
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
}


#endif
#ifdef FRAGMENT
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
uniform lowp float _Cutoff;
varying mediump vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec2 uv_1;
  uv_1 = xlv_TEXCOORD0;
  lowp float x_2;
  x_2 = (texture2D (_MainTex, uv_1).w - _Cutoff);
  if ((x_2 < 0.0)) {
    discard;
  };
  gl_FragData[0] = _Color;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "PIXELSNAP_ON" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp vec4 _ScreenParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying mediump vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _glesVertex.xyz;
  tmpvar_1 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_2));
  highp vec4 pos_3;
  pos_3.zw = tmpvar_1.zw;
  highp vec2 tmpvar_4;
  tmpvar_4 = (_ScreenParams.xy * 0.5);
  pos_3.xy = ((floor(
    (((tmpvar_1.xy / tmpvar_1.w) * tmpvar_4) + vec2(0.5, 0.5))
  ) / tmpvar_4) * tmpvar_1.w);
  gl_Position = pos_3;
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
}


#endif
#ifdef FRAGMENT
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
uniform lowp float _Cutoff;
varying mediump vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec2 uv_1;
  uv_1 = xlv_TEXCOORD0;
  lowp float x_2;
  x_2 = (texture2D (_MainTex, uv_1).w - _Cutoff);
  if ((x_2 < 0.0)) {
    discard;
  };
  gl_FragData[0] = _Color;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "PIXELSNAP_ON" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ScreenParams;
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in mediump vec2 in_TEXCOORD0;
out mediump vec2 vs_TEXCOORD0;
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
    u_xlat0.xy = u_xlat0.xy / u_xlat0.ww;
    u_xlat1.xy = _ScreenParams.xy * vec2(0.5, 0.5);
    u_xlat0.xy = u_xlat0.xy * u_xlat1.xy;
    u_xlat0.xy = roundEven(u_xlat0.xy);
    u_xlat0.xy = u_xlat0.xy / u_xlat1.xy;
    gl_Position.xy = u_xlat0.ww * u_xlat0.xy;
    gl_Position.zw = u_xlat0.zw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	mediump vec4 _Color;
uniform 	mediump float _Cutoff;
uniform lowp sampler2D _MainTex;
in mediump vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
lowp float u_xlat10_0;
bool u_xlatb0;
mediump float u_xlat16_1;
void main()
{
    u_xlat10_0 = texture(_MainTex, vs_TEXCOORD0.xy).w;
    u_xlat16_1 = u_xlat10_0 + (-_Cutoff);
#ifdef UNITY_ADRENO_ES3
    u_xlatb0 = !!(u_xlat16_1<0.0);
#else
    u_xlatb0 = u_xlat16_1<0.0;
#endif
    if((int(u_xlatb0) * int(0xffffffffu))!=0){discard;}
    SV_Target0 = _Color;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "PIXELSNAP_ON" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ScreenParams;
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in mediump vec2 in_TEXCOORD0;
out mediump vec2 vs_TEXCOORD0;
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
    u_xlat0.xy = u_xlat0.xy / u_xlat0.ww;
    u_xlat1.xy = _ScreenParams.xy * vec2(0.5, 0.5);
    u_xlat0.xy = u_xlat0.xy * u_xlat1.xy;
    u_xlat0.xy = roundEven(u_xlat0.xy);
    u_xlat0.xy = u_xlat0.xy / u_xlat1.xy;
    gl_Position.xy = u_xlat0.ww * u_xlat0.xy;
    gl_Position.zw = u_xlat0.zw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	mediump vec4 _Color;
uniform 	mediump float _Cutoff;
uniform lowp sampler2D _MainTex;
in mediump vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
lowp float u_xlat10_0;
bool u_xlatb0;
mediump float u_xlat16_1;
void main()
{
    u_xlat10_0 = texture(_MainTex, vs_TEXCOORD0.xy).w;
    u_xlat16_1 = u_xlat10_0 + (-_Cutoff);
#ifdef UNITY_ADRENO_ES3
    u_xlatb0 = !!(u_xlat16_1<0.0);
#else
    u_xlatb0 = u_xlat16_1<0.0;
#endif
    if((int(u_xlatb0) * int(0xffffffffu))!=0){discard;}
    SV_Target0 = _Color;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "PIXELSNAP_ON" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ScreenParams;
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in mediump vec2 in_TEXCOORD0;
out mediump vec2 vs_TEXCOORD0;
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
    u_xlat0.xy = u_xlat0.xy / u_xlat0.ww;
    u_xlat1.xy = _ScreenParams.xy * vec2(0.5, 0.5);
    u_xlat0.xy = u_xlat0.xy * u_xlat1.xy;
    u_xlat0.xy = roundEven(u_xlat0.xy);
    u_xlat0.xy = u_xlat0.xy / u_xlat1.xy;
    gl_Position.xy = u_xlat0.ww * u_xlat0.xy;
    gl_Position.zw = u_xlat0.zw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	mediump vec4 _Color;
uniform 	mediump float _Cutoff;
uniform lowp sampler2D _MainTex;
in mediump vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
lowp float u_xlat10_0;
bool u_xlatb0;
mediump float u_xlat16_1;
void main()
{
    u_xlat10_0 = texture(_MainTex, vs_TEXCOORD0.xy).w;
    u_xlat16_1 = u_xlat10_0 + (-_Cutoff);
#ifdef UNITY_ADRENO_ES3
    u_xlatb0 = !!(u_xlat16_1<0.0);
#else
    u_xlatb0 = u_xlat16_1<0.0;
#endif
    if((int(u_xlatb0) * int(0xffffffffu))!=0){discard;}
    SV_Target0 = _Color;
    return;
}

#endif
"
}
SubProgram "gles hw_tier00 " {
Keywords { "ETC1_EXTERNAL_ALPHA" "PIXELSNAP_ON" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp vec4 _ScreenParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying mediump vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _glesVertex.xyz;
  tmpvar_1 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_2));
  highp vec4 pos_3;
  pos_3.zw = tmpvar_1.zw;
  highp vec2 tmpvar_4;
  tmpvar_4 = (_ScreenParams.xy * 0.5);
  pos_3.xy = ((floor(
    (((tmpvar_1.xy / tmpvar_1.w) * tmpvar_4) + vec2(0.5, 0.5))
  ) / tmpvar_4) * tmpvar_1.w);
  gl_Position = pos_3;
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
}


#endif
#ifdef FRAGMENT
uniform highp float _EnableExternalAlpha;
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
uniform sampler2D _AlphaTex;
uniform lowp float _Cutoff;
varying mediump vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec2 uv_1;
  uv_1 = xlv_TEXCOORD0;
  lowp vec4 color_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, uv_1);
  color_2.xyz = tmpvar_3.xyz;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_AlphaTex, uv_1);
  highp float tmpvar_5;
  tmpvar_5 = mix (tmpvar_3.w, tmpvar_4.x, _EnableExternalAlpha);
  color_2.w = tmpvar_5;
  lowp float x_6;
  x_6 = (color_2.w - _Cutoff);
  if ((x_6 < 0.0)) {
    discard;
  };
  gl_FragData[0] = _Color;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
Keywords { "ETC1_EXTERNAL_ALPHA" "PIXELSNAP_ON" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp vec4 _ScreenParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying mediump vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _glesVertex.xyz;
  tmpvar_1 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_2));
  highp vec4 pos_3;
  pos_3.zw = tmpvar_1.zw;
  highp vec2 tmpvar_4;
  tmpvar_4 = (_ScreenParams.xy * 0.5);
  pos_3.xy = ((floor(
    (((tmpvar_1.xy / tmpvar_1.w) * tmpvar_4) + vec2(0.5, 0.5))
  ) / tmpvar_4) * tmpvar_1.w);
  gl_Position = pos_3;
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
}


#endif
#ifdef FRAGMENT
uniform highp float _EnableExternalAlpha;
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
uniform sampler2D _AlphaTex;
uniform lowp float _Cutoff;
varying mediump vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec2 uv_1;
  uv_1 = xlv_TEXCOORD0;
  lowp vec4 color_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, uv_1);
  color_2.xyz = tmpvar_3.xyz;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_AlphaTex, uv_1);
  highp float tmpvar_5;
  tmpvar_5 = mix (tmpvar_3.w, tmpvar_4.x, _EnableExternalAlpha);
  color_2.w = tmpvar_5;
  lowp float x_6;
  x_6 = (color_2.w - _Cutoff);
  if ((x_6 < 0.0)) {
    discard;
  };
  gl_FragData[0] = _Color;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
Keywords { "ETC1_EXTERNAL_ALPHA" "PIXELSNAP_ON" }
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesMultiTexCoord0;
uniform highp vec4 _ScreenParams;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixVP;
varying mediump vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec4 tmpvar_1;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = _glesVertex.xyz;
  tmpvar_1 = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_2));
  highp vec4 pos_3;
  pos_3.zw = tmpvar_1.zw;
  highp vec2 tmpvar_4;
  tmpvar_4 = (_ScreenParams.xy * 0.5);
  pos_3.xy = ((floor(
    (((tmpvar_1.xy / tmpvar_1.w) * tmpvar_4) + vec2(0.5, 0.5))
  ) / tmpvar_4) * tmpvar_1.w);
  gl_Position = pos_3;
  xlv_TEXCOORD0 = _glesMultiTexCoord0.xy;
}


#endif
#ifdef FRAGMENT
uniform highp float _EnableExternalAlpha;
uniform lowp vec4 _Color;
uniform sampler2D _MainTex;
uniform sampler2D _AlphaTex;
uniform lowp float _Cutoff;
varying mediump vec2 xlv_TEXCOORD0;
void main ()
{
  highp vec2 uv_1;
  uv_1 = xlv_TEXCOORD0;
  lowp vec4 color_2;
  lowp vec4 tmpvar_3;
  tmpvar_3 = texture2D (_MainTex, uv_1);
  color_2.xyz = tmpvar_3.xyz;
  lowp vec4 tmpvar_4;
  tmpvar_4 = texture2D (_AlphaTex, uv_1);
  highp float tmpvar_5;
  tmpvar_5 = mix (tmpvar_3.w, tmpvar_4.x, _EnableExternalAlpha);
  color_2.w = tmpvar_5;
  lowp float x_6;
  x_6 = (color_2.w - _Cutoff);
  if ((x_6 < 0.0)) {
    discard;
  };
  gl_FragData[0] = _Color;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
Keywords { "ETC1_EXTERNAL_ALPHA" "PIXELSNAP_ON" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ScreenParams;
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in mediump vec2 in_TEXCOORD0;
out mediump vec2 vs_TEXCOORD0;
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
    u_xlat0.xy = u_xlat0.xy / u_xlat0.ww;
    u_xlat1.xy = _ScreenParams.xy * vec2(0.5, 0.5);
    u_xlat0.xy = u_xlat0.xy * u_xlat1.xy;
    u_xlat0.xy = roundEven(u_xlat0.xy);
    u_xlat0.xy = u_xlat0.xy / u_xlat1.xy;
    gl_Position.xy = u_xlat0.ww * u_xlat0.xy;
    gl_Position.zw = u_xlat0.zw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	float _EnableExternalAlpha;
uniform 	mediump vec4 _Color;
uniform 	mediump float _Cutoff;
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D _AlphaTex;
in mediump vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
float u_xlat0;
mediump float u_xlat16_0;
lowp float u_xlat10_0;
bool u_xlatb0;
mediump float u_xlat16_1;
lowp float u_xlat10_2;
void main()
{
    u_xlat10_0 = texture(_AlphaTex, vs_TEXCOORD0.xy).x;
    u_xlat10_2 = texture(_MainTex, vs_TEXCOORD0.xy).w;
    u_xlat16_0 = (-u_xlat10_2) + u_xlat10_0;
    u_xlat0 = _EnableExternalAlpha * u_xlat16_0 + u_xlat10_2;
    u_xlat16_1 = u_xlat0 + (-_Cutoff);
#ifdef UNITY_ADRENO_ES3
    u_xlatb0 = !!(u_xlat16_1<0.0);
#else
    u_xlatb0 = u_xlat16_1<0.0;
#endif
    if((int(u_xlatb0) * int(0xffffffffu))!=0){discard;}
    SV_Target0 = _Color;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
Keywords { "ETC1_EXTERNAL_ALPHA" "PIXELSNAP_ON" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ScreenParams;
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in mediump vec2 in_TEXCOORD0;
out mediump vec2 vs_TEXCOORD0;
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
    u_xlat0.xy = u_xlat0.xy / u_xlat0.ww;
    u_xlat1.xy = _ScreenParams.xy * vec2(0.5, 0.5);
    u_xlat0.xy = u_xlat0.xy * u_xlat1.xy;
    u_xlat0.xy = roundEven(u_xlat0.xy);
    u_xlat0.xy = u_xlat0.xy / u_xlat1.xy;
    gl_Position.xy = u_xlat0.ww * u_xlat0.xy;
    gl_Position.zw = u_xlat0.zw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	float _EnableExternalAlpha;
uniform 	mediump vec4 _Color;
uniform 	mediump float _Cutoff;
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D _AlphaTex;
in mediump vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
float u_xlat0;
mediump float u_xlat16_0;
lowp float u_xlat10_0;
bool u_xlatb0;
mediump float u_xlat16_1;
lowp float u_xlat10_2;
void main()
{
    u_xlat10_0 = texture(_AlphaTex, vs_TEXCOORD0.xy).x;
    u_xlat10_2 = texture(_MainTex, vs_TEXCOORD0.xy).w;
    u_xlat16_0 = (-u_xlat10_2) + u_xlat10_0;
    u_xlat0 = _EnableExternalAlpha * u_xlat16_0 + u_xlat10_2;
    u_xlat16_1 = u_xlat0 + (-_Cutoff);
#ifdef UNITY_ADRENO_ES3
    u_xlatb0 = !!(u_xlat16_1<0.0);
#else
    u_xlatb0 = u_xlat16_1<0.0;
#endif
    if((int(u_xlatb0) * int(0xffffffffu))!=0){discard;}
    SV_Target0 = _Color;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
Keywords { "ETC1_EXTERNAL_ALPHA" "PIXELSNAP_ON" }
"#ifdef VERTEX
#version 300 es

uniform 	vec4 _ScreenParams;
uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
in highp vec4 in_POSITION0;
in mediump vec2 in_TEXCOORD0;
out mediump vec2 vs_TEXCOORD0;
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
    u_xlat0.xy = u_xlat0.xy / u_xlat0.ww;
    u_xlat1.xy = _ScreenParams.xy * vec2(0.5, 0.5);
    u_xlat0.xy = u_xlat0.xy * u_xlat1.xy;
    u_xlat0.xy = roundEven(u_xlat0.xy);
    u_xlat0.xy = u_xlat0.xy / u_xlat1.xy;
    gl_Position.xy = u_xlat0.ww * u_xlat0.xy;
    gl_Position.zw = u_xlat0.zw;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	float _EnableExternalAlpha;
uniform 	mediump vec4 _Color;
uniform 	mediump float _Cutoff;
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D _AlphaTex;
in mediump vec2 vs_TEXCOORD0;
layout(location = 0) out mediump vec4 SV_Target0;
float u_xlat0;
mediump float u_xlat16_0;
lowp float u_xlat10_0;
bool u_xlatb0;
mediump float u_xlat16_1;
lowp float u_xlat10_2;
void main()
{
    u_xlat10_0 = texture(_AlphaTex, vs_TEXCOORD0.xy).x;
    u_xlat10_2 = texture(_MainTex, vs_TEXCOORD0.xy).w;
    u_xlat16_0 = (-u_xlat10_2) + u_xlat10_0;
    u_xlat0 = _EnableExternalAlpha * u_xlat16_0 + u_xlat10_2;
    u_xlat16_1 = u_xlat0 + (-_Cutoff);
#ifdef UNITY_ADRENO_ES3
    u_xlatb0 = !!(u_xlat16_1<0.0);
#else
    u_xlatb0 = u_xlat16_1<0.0;
#endif
    if((int(u_xlatb0) * int(0xffffffffu))!=0){discard;}
    SV_Target0 = _Color;
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
Keywords { "ETC1_EXTERNAL_ALPHA" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "ETC1_EXTERNAL_ALPHA" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "ETC1_EXTERNAL_ALPHA" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "ETC1_EXTERNAL_ALPHA" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "ETC1_EXTERNAL_ALPHA" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "ETC1_EXTERNAL_ALPHA" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "PIXELSNAP_ON" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "PIXELSNAP_ON" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "PIXELSNAP_ON" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "PIXELSNAP_ON" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "PIXELSNAP_ON" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "PIXELSNAP_ON" }
""
}
SubProgram "gles hw_tier00 " {
Keywords { "ETC1_EXTERNAL_ALPHA" "PIXELSNAP_ON" }
""
}
SubProgram "gles hw_tier01 " {
Keywords { "ETC1_EXTERNAL_ALPHA" "PIXELSNAP_ON" }
""
}
SubProgram "gles hw_tier02 " {
Keywords { "ETC1_EXTERNAL_ALPHA" "PIXELSNAP_ON" }
""
}
SubProgram "gles3 hw_tier00 " {
Keywords { "ETC1_EXTERNAL_ALPHA" "PIXELSNAP_ON" }
""
}
SubProgram "gles3 hw_tier01 " {
Keywords { "ETC1_EXTERNAL_ALPHA" "PIXELSNAP_ON" }
""
}
SubProgram "gles3 hw_tier02 " {
Keywords { "ETC1_EXTERNAL_ALPHA" "PIXELSNAP_ON" }
""
}
}
}
}
}