//////////////////////////////////////////
//
// NOTE: This is *not* a valid shader file
//
///////////////////////////////////////////
Shader "Hidden/Internal-GUIRoundedRect" {
Properties {
_MainTex ("Texture", any) = "white" { }
}
SubShader {
 Pass {
  ZTest Always
  ZWrite Off
  Cull Off
  GpuProgramID 62409
Program "vp" {
SubProgram "gles hw_tier00 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 unity_GUIClipTextureMatrix;
varying lowp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = tmpvar_1.xyz;
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = tmpvar_1.xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.zw = vec2(0.0, 1.0);
  tmpvar_4.xy = (unity_MatrixV * (unity_ObjectToWorld * tmpvar_2)).xy;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_3));
  xlv_COLOR = _glesColor;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (unity_GUIClipTextureMatrix * tmpvar_4).xy;
  xlv_TEXCOORD2 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
#extension GL_OES_standard_derivatives : enable
uniform sampler2D _MainTex;
uniform sampler2D _GUIClipTexture;
uniform highp float _CornerRadiuses[4];
uniform highp float _BorderWidths[4];
uniform highp float _Rect[4];
varying lowp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec2 center_2;
  highp int radiusIndex_3;
  highp float bw2_4;
  highp float bw1_5;
  mediump vec4 col_6;
  highp float tmpvar_7;
  tmpvar_7 = (1.0/(abs(dFdx(xlv_TEXCOORD2.x))));
  lowp vec4 tmpvar_8;
  tmpvar_8 = (texture2D (_MainTex, xlv_TEXCOORD0) * xlv_COLOR);
  col_6 = tmpvar_8;
  bool tmpvar_9;
  tmpvar_9 = (((xlv_TEXCOORD2.x - _Rect[0]) - (_Rect[2] / 2.0)) <= 0.0);
  bool tmpvar_10;
  tmpvar_10 = (((xlv_TEXCOORD2.y - _Rect[1]) - (_Rect[3] / 2.0)) <= 0.0);
  bw1_5 = _BorderWidths[0];
  bw2_4 = _BorderWidths[1];
  radiusIndex_3 = 0;
  if (tmpvar_9) {
    highp int tmpvar_11;
    if (tmpvar_10) {
      tmpvar_11 = 0;
    } else {
      tmpvar_11 = 3;
    };
    radiusIndex_3 = tmpvar_11;
  } else {
    highp int tmpvar_12;
    if (tmpvar_10) {
      tmpvar_12 = 1;
    } else {
      tmpvar_12 = 2;
    };
    radiusIndex_3 = tmpvar_12;
  };
  highp float tmpvar_13;
  tmpvar_13 = _CornerRadiuses[radiusIndex_3];
  highp vec2 tmpvar_14;
  tmpvar_14.x = (_Rect[0] + tmpvar_13);
  tmpvar_14.y = (_Rect[1] + tmpvar_13);
  center_2 = tmpvar_14;
  if (!(tmpvar_9)) {
    center_2.x = ((_Rect[0] + _Rect[2]) - tmpvar_13);
    bw1_5 = _BorderWidths[2];
  };
  if (!(tmpvar_10)) {
    center_2.y = ((_Rect[1] + _Rect[3]) - tmpvar_13);
    bw2_4 = _BorderWidths[3];
  };
  bool tmpvar_15;
  if (tmpvar_9) {
    tmpvar_15 = (xlv_TEXCOORD2.x <= center_2.x);
  } else {
    tmpvar_15 = (xlv_TEXCOORD2.x >= center_2.x);
  };
  bool tmpvar_16;
  if (tmpvar_15) {
    bool tmpvar_17;
    if (tmpvar_10) {
      tmpvar_17 = (xlv_TEXCOORD2.y <= center_2.y);
    } else {
      tmpvar_17 = (xlv_TEXCOORD2.y >= center_2.y);
    };
    tmpvar_16 = tmpvar_17;
  } else {
    tmpvar_16 = bool(0);
  };
  mediump float tmpvar_18;
  if (tmpvar_16) {
    mediump float rawDist_19;
    highp vec2 v_20;
    bool tmpvar_21;
    tmpvar_21 = ((bw1_5 > 0.0) || (bw2_4 > 0.0));
    highp vec2 tmpvar_22;
    tmpvar_22 = (xlv_TEXCOORD2.xy - center_2);
    v_20 = tmpvar_22;
    highp float tmpvar_23;
    tmpvar_23 = ((sqrt(
      dot (tmpvar_22, tmpvar_22)
    ) - tmpvar_13) * tmpvar_7);
    mediump float tmpvar_24;
    if (tmpvar_21) {
      highp float tmpvar_25;
      tmpvar_25 = clamp ((0.5 + tmpvar_23), 0.0, 1.0);
      tmpvar_24 = tmpvar_25;
    } else {
      tmpvar_24 = 0.0;
    };
    highp float tmpvar_26;
    tmpvar_26 = (tmpvar_13 - bw1_5);
    highp float tmpvar_27;
    tmpvar_27 = (tmpvar_13 - bw2_4);
    v_20.y = (tmpvar_22.y * (tmpvar_26 / tmpvar_27));
    highp float tmpvar_28;
    tmpvar_28 = ((sqrt(
      dot (v_20, v_20)
    ) - tmpvar_26) * tmpvar_7);
    rawDist_19 = tmpvar_28;
    mediump float tmpvar_29;
    tmpvar_29 = clamp ((rawDist_19 + 0.5), 0.0, 1.0);
    mediump float tmpvar_30;
    if (tmpvar_21) {
      mediump float tmpvar_31;
      if (((tmpvar_26 > 0.0) && (tmpvar_27 > 0.0))) {
        tmpvar_31 = tmpvar_29;
      } else {
        tmpvar_31 = 1.0;
      };
      tmpvar_30 = tmpvar_31;
    } else {
      tmpvar_30 = 0.0;
    };
    mediump float tmpvar_32;
    if ((tmpvar_24 == 0.0)) {
      tmpvar_32 = tmpvar_30;
    } else {
      tmpvar_32 = (1.0 - tmpvar_24);
    };
    tmpvar_18 = tmpvar_32;
  } else {
    tmpvar_18 = 1.0;
  };
  col_6.w = (col_6.w * tmpvar_18);
  highp vec4 tmpvar_33;
  tmpvar_33.x = (_Rect[0] + _BorderWidths[0]);
  tmpvar_33.y = (_Rect[1] + _BorderWidths[1]);
  tmpvar_33.z = (_Rect[2] - (_BorderWidths[0] + _BorderWidths[2]));
  tmpvar_33.w = (_Rect[3] - (_BorderWidths[1] + _BorderWidths[3]));
  bool tmpvar_34;
  tmpvar_34 = (((
    (xlv_TEXCOORD2.x >= tmpvar_33.x)
   && 
    (xlv_TEXCOORD2.x <= (tmpvar_33.x + tmpvar_33.z))
  ) && (xlv_TEXCOORD2.y >= tmpvar_33.y)) && (xlv_TEXCOORD2.y <= (tmpvar_33.y + tmpvar_33.w)));
  mediump float tmpvar_35;
  if (tmpvar_34) {
    tmpvar_35 = 0.0;
  } else {
    tmpvar_35 = col_6.w;
  };
  mediump float tmpvar_36;
  if ((((
    (_BorderWidths[0] > 0.0)
   || 
    (_BorderWidths[1] > 0.0)
  ) || (_BorderWidths[2] > 0.0)) || (_BorderWidths[3] > 0.0))) {
    mediump float tmpvar_37;
    if (tmpvar_16) {
      tmpvar_37 = col_6.w;
    } else {
      tmpvar_37 = tmpvar_35;
    };
    tmpvar_36 = tmpvar_37;
  } else {
    tmpvar_36 = 1.0;
  };
  col_6.w = (col_6.w * tmpvar_36);
  lowp vec4 tmpvar_38;
  tmpvar_38 = texture2D (_GUIClipTexture, xlv_TEXCOORD1);
  col_6.w = (col_6.w * tmpvar_38.w);
  tmpvar_1 = col_6;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 unity_GUIClipTextureMatrix;
varying lowp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = tmpvar_1.xyz;
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = tmpvar_1.xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.zw = vec2(0.0, 1.0);
  tmpvar_4.xy = (unity_MatrixV * (unity_ObjectToWorld * tmpvar_2)).xy;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_3));
  xlv_COLOR = _glesColor;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (unity_GUIClipTextureMatrix * tmpvar_4).xy;
  xlv_TEXCOORD2 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
#extension GL_OES_standard_derivatives : enable
uniform sampler2D _MainTex;
uniform sampler2D _GUIClipTexture;
uniform highp float _CornerRadiuses[4];
uniform highp float _BorderWidths[4];
uniform highp float _Rect[4];
varying lowp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec2 center_2;
  highp int radiusIndex_3;
  highp float bw2_4;
  highp float bw1_5;
  mediump vec4 col_6;
  highp float tmpvar_7;
  tmpvar_7 = (1.0/(abs(dFdx(xlv_TEXCOORD2.x))));
  lowp vec4 tmpvar_8;
  tmpvar_8 = (texture2D (_MainTex, xlv_TEXCOORD0) * xlv_COLOR);
  col_6 = tmpvar_8;
  bool tmpvar_9;
  tmpvar_9 = (((xlv_TEXCOORD2.x - _Rect[0]) - (_Rect[2] / 2.0)) <= 0.0);
  bool tmpvar_10;
  tmpvar_10 = (((xlv_TEXCOORD2.y - _Rect[1]) - (_Rect[3] / 2.0)) <= 0.0);
  bw1_5 = _BorderWidths[0];
  bw2_4 = _BorderWidths[1];
  radiusIndex_3 = 0;
  if (tmpvar_9) {
    highp int tmpvar_11;
    if (tmpvar_10) {
      tmpvar_11 = 0;
    } else {
      tmpvar_11 = 3;
    };
    radiusIndex_3 = tmpvar_11;
  } else {
    highp int tmpvar_12;
    if (tmpvar_10) {
      tmpvar_12 = 1;
    } else {
      tmpvar_12 = 2;
    };
    radiusIndex_3 = tmpvar_12;
  };
  highp float tmpvar_13;
  tmpvar_13 = _CornerRadiuses[radiusIndex_3];
  highp vec2 tmpvar_14;
  tmpvar_14.x = (_Rect[0] + tmpvar_13);
  tmpvar_14.y = (_Rect[1] + tmpvar_13);
  center_2 = tmpvar_14;
  if (!(tmpvar_9)) {
    center_2.x = ((_Rect[0] + _Rect[2]) - tmpvar_13);
    bw1_5 = _BorderWidths[2];
  };
  if (!(tmpvar_10)) {
    center_2.y = ((_Rect[1] + _Rect[3]) - tmpvar_13);
    bw2_4 = _BorderWidths[3];
  };
  bool tmpvar_15;
  if (tmpvar_9) {
    tmpvar_15 = (xlv_TEXCOORD2.x <= center_2.x);
  } else {
    tmpvar_15 = (xlv_TEXCOORD2.x >= center_2.x);
  };
  bool tmpvar_16;
  if (tmpvar_15) {
    bool tmpvar_17;
    if (tmpvar_10) {
      tmpvar_17 = (xlv_TEXCOORD2.y <= center_2.y);
    } else {
      tmpvar_17 = (xlv_TEXCOORD2.y >= center_2.y);
    };
    tmpvar_16 = tmpvar_17;
  } else {
    tmpvar_16 = bool(0);
  };
  mediump float tmpvar_18;
  if (tmpvar_16) {
    mediump float rawDist_19;
    highp vec2 v_20;
    bool tmpvar_21;
    tmpvar_21 = ((bw1_5 > 0.0) || (bw2_4 > 0.0));
    highp vec2 tmpvar_22;
    tmpvar_22 = (xlv_TEXCOORD2.xy - center_2);
    v_20 = tmpvar_22;
    highp float tmpvar_23;
    tmpvar_23 = ((sqrt(
      dot (tmpvar_22, tmpvar_22)
    ) - tmpvar_13) * tmpvar_7);
    mediump float tmpvar_24;
    if (tmpvar_21) {
      highp float tmpvar_25;
      tmpvar_25 = clamp ((0.5 + tmpvar_23), 0.0, 1.0);
      tmpvar_24 = tmpvar_25;
    } else {
      tmpvar_24 = 0.0;
    };
    highp float tmpvar_26;
    tmpvar_26 = (tmpvar_13 - bw1_5);
    highp float tmpvar_27;
    tmpvar_27 = (tmpvar_13 - bw2_4);
    v_20.y = (tmpvar_22.y * (tmpvar_26 / tmpvar_27));
    highp float tmpvar_28;
    tmpvar_28 = ((sqrt(
      dot (v_20, v_20)
    ) - tmpvar_26) * tmpvar_7);
    rawDist_19 = tmpvar_28;
    mediump float tmpvar_29;
    tmpvar_29 = clamp ((rawDist_19 + 0.5), 0.0, 1.0);
    mediump float tmpvar_30;
    if (tmpvar_21) {
      mediump float tmpvar_31;
      if (((tmpvar_26 > 0.0) && (tmpvar_27 > 0.0))) {
        tmpvar_31 = tmpvar_29;
      } else {
        tmpvar_31 = 1.0;
      };
      tmpvar_30 = tmpvar_31;
    } else {
      tmpvar_30 = 0.0;
    };
    mediump float tmpvar_32;
    if ((tmpvar_24 == 0.0)) {
      tmpvar_32 = tmpvar_30;
    } else {
      tmpvar_32 = (1.0 - tmpvar_24);
    };
    tmpvar_18 = tmpvar_32;
  } else {
    tmpvar_18 = 1.0;
  };
  col_6.w = (col_6.w * tmpvar_18);
  highp vec4 tmpvar_33;
  tmpvar_33.x = (_Rect[0] + _BorderWidths[0]);
  tmpvar_33.y = (_Rect[1] + _BorderWidths[1]);
  tmpvar_33.z = (_Rect[2] - (_BorderWidths[0] + _BorderWidths[2]));
  tmpvar_33.w = (_Rect[3] - (_BorderWidths[1] + _BorderWidths[3]));
  bool tmpvar_34;
  tmpvar_34 = (((
    (xlv_TEXCOORD2.x >= tmpvar_33.x)
   && 
    (xlv_TEXCOORD2.x <= (tmpvar_33.x + tmpvar_33.z))
  ) && (xlv_TEXCOORD2.y >= tmpvar_33.y)) && (xlv_TEXCOORD2.y <= (tmpvar_33.y + tmpvar_33.w)));
  mediump float tmpvar_35;
  if (tmpvar_34) {
    tmpvar_35 = 0.0;
  } else {
    tmpvar_35 = col_6.w;
  };
  mediump float tmpvar_36;
  if ((((
    (_BorderWidths[0] > 0.0)
   || 
    (_BorderWidths[1] > 0.0)
  ) || (_BorderWidths[2] > 0.0)) || (_BorderWidths[3] > 0.0))) {
    mediump float tmpvar_37;
    if (tmpvar_16) {
      tmpvar_37 = col_6.w;
    } else {
      tmpvar_37 = tmpvar_35;
    };
    tmpvar_36 = tmpvar_37;
  } else {
    tmpvar_36 = 1.0;
  };
  col_6.w = (col_6.w * tmpvar_36);
  lowp vec4 tmpvar_38;
  tmpvar_38 = texture2D (_GUIClipTexture, xlv_TEXCOORD1);
  col_6.w = (col_6.w * tmpvar_38.w);
  tmpvar_1 = col_6;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 unity_GUIClipTextureMatrix;
varying lowp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = tmpvar_1.xyz;
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = tmpvar_1.xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.zw = vec2(0.0, 1.0);
  tmpvar_4.xy = (unity_MatrixV * (unity_ObjectToWorld * tmpvar_2)).xy;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_3));
  xlv_COLOR = _glesColor;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (unity_GUIClipTextureMatrix * tmpvar_4).xy;
  xlv_TEXCOORD2 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
#extension GL_OES_standard_derivatives : enable
uniform sampler2D _MainTex;
uniform sampler2D _GUIClipTexture;
uniform highp float _CornerRadiuses[4];
uniform highp float _BorderWidths[4];
uniform highp float _Rect[4];
varying lowp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec2 center_2;
  highp int radiusIndex_3;
  highp float bw2_4;
  highp float bw1_5;
  mediump vec4 col_6;
  highp float tmpvar_7;
  tmpvar_7 = (1.0/(abs(dFdx(xlv_TEXCOORD2.x))));
  lowp vec4 tmpvar_8;
  tmpvar_8 = (texture2D (_MainTex, xlv_TEXCOORD0) * xlv_COLOR);
  col_6 = tmpvar_8;
  bool tmpvar_9;
  tmpvar_9 = (((xlv_TEXCOORD2.x - _Rect[0]) - (_Rect[2] / 2.0)) <= 0.0);
  bool tmpvar_10;
  tmpvar_10 = (((xlv_TEXCOORD2.y - _Rect[1]) - (_Rect[3] / 2.0)) <= 0.0);
  bw1_5 = _BorderWidths[0];
  bw2_4 = _BorderWidths[1];
  radiusIndex_3 = 0;
  if (tmpvar_9) {
    highp int tmpvar_11;
    if (tmpvar_10) {
      tmpvar_11 = 0;
    } else {
      tmpvar_11 = 3;
    };
    radiusIndex_3 = tmpvar_11;
  } else {
    highp int tmpvar_12;
    if (tmpvar_10) {
      tmpvar_12 = 1;
    } else {
      tmpvar_12 = 2;
    };
    radiusIndex_3 = tmpvar_12;
  };
  highp float tmpvar_13;
  tmpvar_13 = _CornerRadiuses[radiusIndex_3];
  highp vec2 tmpvar_14;
  tmpvar_14.x = (_Rect[0] + tmpvar_13);
  tmpvar_14.y = (_Rect[1] + tmpvar_13);
  center_2 = tmpvar_14;
  if (!(tmpvar_9)) {
    center_2.x = ((_Rect[0] + _Rect[2]) - tmpvar_13);
    bw1_5 = _BorderWidths[2];
  };
  if (!(tmpvar_10)) {
    center_2.y = ((_Rect[1] + _Rect[3]) - tmpvar_13);
    bw2_4 = _BorderWidths[3];
  };
  bool tmpvar_15;
  if (tmpvar_9) {
    tmpvar_15 = (xlv_TEXCOORD2.x <= center_2.x);
  } else {
    tmpvar_15 = (xlv_TEXCOORD2.x >= center_2.x);
  };
  bool tmpvar_16;
  if (tmpvar_15) {
    bool tmpvar_17;
    if (tmpvar_10) {
      tmpvar_17 = (xlv_TEXCOORD2.y <= center_2.y);
    } else {
      tmpvar_17 = (xlv_TEXCOORD2.y >= center_2.y);
    };
    tmpvar_16 = tmpvar_17;
  } else {
    tmpvar_16 = bool(0);
  };
  mediump float tmpvar_18;
  if (tmpvar_16) {
    mediump float rawDist_19;
    highp vec2 v_20;
    bool tmpvar_21;
    tmpvar_21 = ((bw1_5 > 0.0) || (bw2_4 > 0.0));
    highp vec2 tmpvar_22;
    tmpvar_22 = (xlv_TEXCOORD2.xy - center_2);
    v_20 = tmpvar_22;
    highp float tmpvar_23;
    tmpvar_23 = ((sqrt(
      dot (tmpvar_22, tmpvar_22)
    ) - tmpvar_13) * tmpvar_7);
    mediump float tmpvar_24;
    if (tmpvar_21) {
      highp float tmpvar_25;
      tmpvar_25 = clamp ((0.5 + tmpvar_23), 0.0, 1.0);
      tmpvar_24 = tmpvar_25;
    } else {
      tmpvar_24 = 0.0;
    };
    highp float tmpvar_26;
    tmpvar_26 = (tmpvar_13 - bw1_5);
    highp float tmpvar_27;
    tmpvar_27 = (tmpvar_13 - bw2_4);
    v_20.y = (tmpvar_22.y * (tmpvar_26 / tmpvar_27));
    highp float tmpvar_28;
    tmpvar_28 = ((sqrt(
      dot (v_20, v_20)
    ) - tmpvar_26) * tmpvar_7);
    rawDist_19 = tmpvar_28;
    mediump float tmpvar_29;
    tmpvar_29 = clamp ((rawDist_19 + 0.5), 0.0, 1.0);
    mediump float tmpvar_30;
    if (tmpvar_21) {
      mediump float tmpvar_31;
      if (((tmpvar_26 > 0.0) && (tmpvar_27 > 0.0))) {
        tmpvar_31 = tmpvar_29;
      } else {
        tmpvar_31 = 1.0;
      };
      tmpvar_30 = tmpvar_31;
    } else {
      tmpvar_30 = 0.0;
    };
    mediump float tmpvar_32;
    if ((tmpvar_24 == 0.0)) {
      tmpvar_32 = tmpvar_30;
    } else {
      tmpvar_32 = (1.0 - tmpvar_24);
    };
    tmpvar_18 = tmpvar_32;
  } else {
    tmpvar_18 = 1.0;
  };
  col_6.w = (col_6.w * tmpvar_18);
  highp vec4 tmpvar_33;
  tmpvar_33.x = (_Rect[0] + _BorderWidths[0]);
  tmpvar_33.y = (_Rect[1] + _BorderWidths[1]);
  tmpvar_33.z = (_Rect[2] - (_BorderWidths[0] + _BorderWidths[2]));
  tmpvar_33.w = (_Rect[3] - (_BorderWidths[1] + _BorderWidths[3]));
  bool tmpvar_34;
  tmpvar_34 = (((
    (xlv_TEXCOORD2.x >= tmpvar_33.x)
   && 
    (xlv_TEXCOORD2.x <= (tmpvar_33.x + tmpvar_33.z))
  ) && (xlv_TEXCOORD2.y >= tmpvar_33.y)) && (xlv_TEXCOORD2.y <= (tmpvar_33.y + tmpvar_33.w)));
  mediump float tmpvar_35;
  if (tmpvar_34) {
    tmpvar_35 = 0.0;
  } else {
    tmpvar_35 = col_6.w;
  };
  mediump float tmpvar_36;
  if ((((
    (_BorderWidths[0] > 0.0)
   || 
    (_BorderWidths[1] > 0.0)
  ) || (_BorderWidths[2] > 0.0)) || (_BorderWidths[3] > 0.0))) {
    mediump float tmpvar_37;
    if (tmpvar_16) {
      tmpvar_37 = col_6.w;
    } else {
      tmpvar_37 = tmpvar_35;
    };
    tmpvar_36 = tmpvar_37;
  } else {
    tmpvar_36 = 1.0;
  };
  col_6.w = (col_6.w * tmpvar_36);
  lowp vec4 tmpvar_38;
  tmpvar_38 = texture2D (_GUIClipTexture, xlv_TEXCOORD1);
  col_6.w = (col_6.w * tmpvar_38.w);
  tmpvar_1 = col_6;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixV[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	vec4 _MainTex_ST;
uniform 	vec4 hlslcc_mtx4x4unity_GUIClipTextureMatrix[4];
in highp vec4 in_POSITION0;
in mediump vec4 in_COLOR0;
in highp vec2 in_TEXCOORD0;
out mediump vec4 vs_COLOR0;
out highp vec2 vs_TEXCOORD0;
out highp vec2 vs_TEXCOORD1;
out highp vec4 vs_TEXCOORD2;
vec4 u_xlat0;
vec4 u_xlat1;
vec2 u_xlat2;
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
    vs_COLOR0 = in_COLOR0;
    u_xlat1.xy = u_xlat0.yy * hlslcc_mtx4x4unity_MatrixV[1].xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_MatrixV[0].xy * u_xlat0.xx + u_xlat1.xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_MatrixV[2].xy * u_xlat0.zz + u_xlat0.xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_MatrixV[3].xy * u_xlat0.ww + u_xlat0.xy;
    u_xlat2.xy = u_xlat0.yy * hlslcc_mtx4x4unity_GUIClipTextureMatrix[1].xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_GUIClipTextureMatrix[0].xy * u_xlat0.xx + u_xlat2.xy;
    vs_TEXCOORD1.xy = u_xlat0.xy + hlslcc_mtx4x4unity_GUIClipTextureMatrix[3].xy;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    vs_TEXCOORD2 = in_POSITION0;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	float _CornerRadiuses[4];
uniform 	float _BorderWidths[4];
uniform 	float _Rect[4];
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D _GUIClipTexture;
in mediump vec4 vs_COLOR0;
in highp vec2 vs_TEXCOORD0;
in highp vec2 vs_TEXCOORD1;
in highp vec4 vs_TEXCOORD2;
layout(location = 0) out mediump vec4 SV_Target0;
float u_xlat0;
bool u_xlatb0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
bvec3 u_xlatb1;
vec4 u_xlat2;
vec3 u_xlat3;
mediump float u_xlat16_5;
vec3 u_xlat6;
lowp float u_xlat10_6;
bvec3 u_xlatb6;
float u_xlat7;
bool u_xlatb7;
float u_xlat12;
bool u_xlatb12;
float u_xlat13;
ivec2 u_xlati13;
bvec2 u_xlatb13;
vec2 u_xlat15;
vec2 u_xlat16;
float u_xlat18;
float u_xlat19;
void main()
{
    u_xlat0 = _BorderWidths[0] + _BorderWidths[2];
    u_xlat0 = (-u_xlat0) + _Rect[2];
    u_xlat6.x = _BorderWidths[0] + _Rect[0];
    u_xlat0 = u_xlat0 + u_xlat6.x;
#ifdef UNITY_ADRENO_ES3
    u_xlatb6.x = !!(vs_TEXCOORD2.x>=u_xlat6.x);
#else
    u_xlatb6.x = vs_TEXCOORD2.x>=u_xlat6.x;
#endif
#ifdef UNITY_ADRENO_ES3
    u_xlatb0 = !!(u_xlat0>=vs_TEXCOORD2.x);
#else
    u_xlatb0 = u_xlat0>=vs_TEXCOORD2.x;
#endif
    u_xlatb0 = u_xlatb0 && u_xlatb6.x;
    u_xlat6.x = _BorderWidths[1] + _Rect[1];
#ifdef UNITY_ADRENO_ES3
    u_xlatb12 = !!(vs_TEXCOORD2.y>=u_xlat6.x);
#else
    u_xlatb12 = vs_TEXCOORD2.y>=u_xlat6.x;
#endif
    u_xlatb0 = u_xlatb12 && u_xlatb0;
    u_xlat12 = _BorderWidths[1] + _BorderWidths[3];
    u_xlat12 = (-u_xlat12) + _Rect[3];
    u_xlat6.x = u_xlat12 + u_xlat6.x;
#ifdef UNITY_ADRENO_ES3
    u_xlatb6.x = !!(u_xlat6.x>=vs_TEXCOORD2.y);
#else
    u_xlatb6.x = u_xlat6.x>=vs_TEXCOORD2.y;
#endif
    u_xlatb0 = u_xlatb6.x && u_xlatb0;
    u_xlat1.x = _BorderWidths[0];
    u_xlat2.x = _BorderWidths[2];
    u_xlat6.x = vs_TEXCOORD2.x + (-_Rect[0]);
    u_xlat6.x = (-_Rect[2]) * 0.5 + u_xlat6.x;
    u_xlat12 = _Rect[0] + _Rect[2];
    u_xlat18 = vs_TEXCOORD2.y + (-_Rect[1]);
    u_xlat6.z = (-_Rect[3]) * 0.5 + u_xlat18;
    u_xlatb6.xz = greaterThanEqual(vec4(0.0, 0.0, 0.0, 0.0), u_xlat6.xxzz).xz;
    u_xlati13.xy = (u_xlatb6.z) ? ivec2(0, 1) : ivec2(3, 2);
    u_xlati13.x = (u_xlatb6.x) ? u_xlati13.x : u_xlati13.y;
    u_xlat2.y = u_xlat12 + (-_CornerRadiuses[u_xlati13.x]);
    u_xlat1.y = _Rect[0] + _CornerRadiuses[u_xlati13.x];
    u_xlat2.xy = (u_xlatb6.x) ? u_xlat1.xy : u_xlat2.xy;
    u_xlat15.x = _BorderWidths[1];
    u_xlat16.x = _BorderWidths[3];
    u_xlat12 = _Rect[1] + _Rect[3];
    u_xlat16.y = u_xlat12 + (-_CornerRadiuses[u_xlati13.x]);
    u_xlat15.y = _Rect[1] + _CornerRadiuses[u_xlati13.x];
    u_xlat2.zw = (u_xlatb6.z) ? u_xlat15.xy : u_xlat16.xy;
    u_xlat1.xy = (-u_xlat2.xz) + vec2(_CornerRadiuses[u_xlati13.x]);
    u_xlat12 = u_xlat1.x / u_xlat1.y;
    u_xlat3.xy = vec2((-u_xlat2.y) + vs_TEXCOORD2.x, (-u_xlat2.w) + vs_TEXCOORD2.y);
    u_xlat3.z = u_xlat12 * u_xlat3.y;
    u_xlat12 = dot(u_xlat3.xz, u_xlat3.xz);
    u_xlat19 = dot(u_xlat3.xy, u_xlat3.xy);
    u_xlat19 = sqrt(u_xlat19);
    u_xlat13 = u_xlat19 + (-_CornerRadiuses[u_xlati13.x]);
    u_xlat12 = sqrt(u_xlat12);
    u_xlat12 = (-u_xlat1.x) + u_xlat12;
    u_xlatb1.xy = lessThan(vec4(0.0, 0.0, 0.0, 0.0), u_xlat1.xyxx).xy;
    u_xlatb1.x = u_xlatb1.y && u_xlatb1.x;
    u_xlat7 = dFdx(vs_TEXCOORD2.x);
    u_xlat7 = float(1.0) / abs(u_xlat7);
    u_xlat12 = u_xlat12 * u_xlat7 + 0.5;
#ifdef UNITY_ADRENO_ES3
    u_xlat12 = min(max(u_xlat12, 0.0), 1.0);
#else
    u_xlat12 = clamp(u_xlat12, 0.0, 1.0);
#endif
    u_xlat7 = u_xlat13 * u_xlat7 + 0.5;
#ifdef UNITY_ADRENO_ES3
    u_xlat7 = min(max(u_xlat7, 0.0), 1.0);
#else
    u_xlat7 = clamp(u_xlat7, 0.0, 1.0);
#endif
    u_xlat12 = (u_xlatb1.x) ? u_xlat12 : 1.0;
    u_xlatb1.xz = lessThan(vec4(0.0, 0.0, 0.0, 0.0), u_xlat2.xxzx).xz;
    u_xlatb1.x = u_xlatb1.z || u_xlatb1.x;
    u_xlat12 = u_xlatb1.x ? u_xlat12 : float(0.0);
    u_xlat1.x = u_xlatb1.x ? u_xlat7 : float(0.0);
#ifdef UNITY_ADRENO_ES3
    u_xlatb7 = !!(u_xlat1.x==0.0);
#else
    u_xlatb7 = u_xlat1.x==0.0;
#endif
    u_xlat1.x = (-u_xlat1.x) + 1.0;
    u_xlat12 = (u_xlatb7) ? u_xlat12 : u_xlat1.x;
    u_xlatb1.xy = greaterThanEqual(u_xlat2.ywyy, vs_TEXCOORD2.xyxx).xy;
    u_xlatb13.xy = greaterThanEqual(vs_TEXCOORD2.xyxy, u_xlat2.ywyw).xy;
    u_xlatb6.x = (u_xlatb6.x) ? u_xlatb1.x : u_xlatb13.x;
    u_xlatb6.z = (u_xlatb6.z) ? u_xlatb1.y : u_xlatb13.y;
    u_xlatb6.x = u_xlatb6.z && u_xlatb6.x;
    u_xlat12 = (u_xlatb6.x) ? u_xlat12 : 1.0;
    u_xlat10_1 = texture(_MainTex, vs_TEXCOORD0.xy);
    u_xlat1 = u_xlat10_1 * vs_COLOR0;
    u_xlat12 = u_xlat12 * u_xlat1.w;
    u_xlat0 = (u_xlatb0) ? 0.0 : u_xlat12;
    u_xlat16_5 = (u_xlatb6.x) ? u_xlat12 : u_xlat0;
#ifdef UNITY_ADRENO_ES3
    u_xlatb0 = !!(0.0<_BorderWidths[0]);
#else
    u_xlatb0 = 0.0<_BorderWidths[0];
#endif
#ifdef UNITY_ADRENO_ES3
    u_xlatb6.x = !!(0.0<_BorderWidths[1]);
#else
    u_xlatb6.x = 0.0<_BorderWidths[1];
#endif
    u_xlatb0 = u_xlatb6.x || u_xlatb0;
#ifdef UNITY_ADRENO_ES3
    u_xlatb6.x = !!(0.0<_BorderWidths[2]);
#else
    u_xlatb6.x = 0.0<_BorderWidths[2];
#endif
    u_xlatb0 = u_xlatb6.x || u_xlatb0;
#ifdef UNITY_ADRENO_ES3
    u_xlatb6.x = !!(0.0<_BorderWidths[3]);
#else
    u_xlatb6.x = 0.0<_BorderWidths[3];
#endif
    u_xlatb0 = u_xlatb6.x || u_xlatb0;
    u_xlat0 = (u_xlatb0) ? u_xlat16_5 : 1.0;
    u_xlat0 = u_xlat0 * u_xlat12;
    u_xlat10_6 = texture(_GUIClipTexture, vs_TEXCOORD1.xy).w;
    u_xlat1.w = u_xlat10_6 * u_xlat0;
    SV_Target0 = u_xlat1;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixV[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	vec4 _MainTex_ST;
uniform 	vec4 hlslcc_mtx4x4unity_GUIClipTextureMatrix[4];
in highp vec4 in_POSITION0;
in mediump vec4 in_COLOR0;
in highp vec2 in_TEXCOORD0;
out mediump vec4 vs_COLOR0;
out highp vec2 vs_TEXCOORD0;
out highp vec2 vs_TEXCOORD1;
out highp vec4 vs_TEXCOORD2;
vec4 u_xlat0;
vec4 u_xlat1;
vec2 u_xlat2;
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
    vs_COLOR0 = in_COLOR0;
    u_xlat1.xy = u_xlat0.yy * hlslcc_mtx4x4unity_MatrixV[1].xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_MatrixV[0].xy * u_xlat0.xx + u_xlat1.xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_MatrixV[2].xy * u_xlat0.zz + u_xlat0.xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_MatrixV[3].xy * u_xlat0.ww + u_xlat0.xy;
    u_xlat2.xy = u_xlat0.yy * hlslcc_mtx4x4unity_GUIClipTextureMatrix[1].xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_GUIClipTextureMatrix[0].xy * u_xlat0.xx + u_xlat2.xy;
    vs_TEXCOORD1.xy = u_xlat0.xy + hlslcc_mtx4x4unity_GUIClipTextureMatrix[3].xy;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    vs_TEXCOORD2 = in_POSITION0;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	float _CornerRadiuses[4];
uniform 	float _BorderWidths[4];
uniform 	float _Rect[4];
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D _GUIClipTexture;
in mediump vec4 vs_COLOR0;
in highp vec2 vs_TEXCOORD0;
in highp vec2 vs_TEXCOORD1;
in highp vec4 vs_TEXCOORD2;
layout(location = 0) out mediump vec4 SV_Target0;
float u_xlat0;
bool u_xlatb0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
bvec3 u_xlatb1;
vec4 u_xlat2;
vec3 u_xlat3;
mediump float u_xlat16_5;
vec3 u_xlat6;
lowp float u_xlat10_6;
bvec3 u_xlatb6;
float u_xlat7;
bool u_xlatb7;
float u_xlat12;
bool u_xlatb12;
float u_xlat13;
ivec2 u_xlati13;
bvec2 u_xlatb13;
vec2 u_xlat15;
vec2 u_xlat16;
float u_xlat18;
float u_xlat19;
void main()
{
    u_xlat0 = _BorderWidths[0] + _BorderWidths[2];
    u_xlat0 = (-u_xlat0) + _Rect[2];
    u_xlat6.x = _BorderWidths[0] + _Rect[0];
    u_xlat0 = u_xlat0 + u_xlat6.x;
#ifdef UNITY_ADRENO_ES3
    u_xlatb6.x = !!(vs_TEXCOORD2.x>=u_xlat6.x);
#else
    u_xlatb6.x = vs_TEXCOORD2.x>=u_xlat6.x;
#endif
#ifdef UNITY_ADRENO_ES3
    u_xlatb0 = !!(u_xlat0>=vs_TEXCOORD2.x);
#else
    u_xlatb0 = u_xlat0>=vs_TEXCOORD2.x;
#endif
    u_xlatb0 = u_xlatb0 && u_xlatb6.x;
    u_xlat6.x = _BorderWidths[1] + _Rect[1];
#ifdef UNITY_ADRENO_ES3
    u_xlatb12 = !!(vs_TEXCOORD2.y>=u_xlat6.x);
#else
    u_xlatb12 = vs_TEXCOORD2.y>=u_xlat6.x;
#endif
    u_xlatb0 = u_xlatb12 && u_xlatb0;
    u_xlat12 = _BorderWidths[1] + _BorderWidths[3];
    u_xlat12 = (-u_xlat12) + _Rect[3];
    u_xlat6.x = u_xlat12 + u_xlat6.x;
#ifdef UNITY_ADRENO_ES3
    u_xlatb6.x = !!(u_xlat6.x>=vs_TEXCOORD2.y);
#else
    u_xlatb6.x = u_xlat6.x>=vs_TEXCOORD2.y;
#endif
    u_xlatb0 = u_xlatb6.x && u_xlatb0;
    u_xlat1.x = _BorderWidths[0];
    u_xlat2.x = _BorderWidths[2];
    u_xlat6.x = vs_TEXCOORD2.x + (-_Rect[0]);
    u_xlat6.x = (-_Rect[2]) * 0.5 + u_xlat6.x;
    u_xlat12 = _Rect[0] + _Rect[2];
    u_xlat18 = vs_TEXCOORD2.y + (-_Rect[1]);
    u_xlat6.z = (-_Rect[3]) * 0.5 + u_xlat18;
    u_xlatb6.xz = greaterThanEqual(vec4(0.0, 0.0, 0.0, 0.0), u_xlat6.xxzz).xz;
    u_xlati13.xy = (u_xlatb6.z) ? ivec2(0, 1) : ivec2(3, 2);
    u_xlati13.x = (u_xlatb6.x) ? u_xlati13.x : u_xlati13.y;
    u_xlat2.y = u_xlat12 + (-_CornerRadiuses[u_xlati13.x]);
    u_xlat1.y = _Rect[0] + _CornerRadiuses[u_xlati13.x];
    u_xlat2.xy = (u_xlatb6.x) ? u_xlat1.xy : u_xlat2.xy;
    u_xlat15.x = _BorderWidths[1];
    u_xlat16.x = _BorderWidths[3];
    u_xlat12 = _Rect[1] + _Rect[3];
    u_xlat16.y = u_xlat12 + (-_CornerRadiuses[u_xlati13.x]);
    u_xlat15.y = _Rect[1] + _CornerRadiuses[u_xlati13.x];
    u_xlat2.zw = (u_xlatb6.z) ? u_xlat15.xy : u_xlat16.xy;
    u_xlat1.xy = (-u_xlat2.xz) + vec2(_CornerRadiuses[u_xlati13.x]);
    u_xlat12 = u_xlat1.x / u_xlat1.y;
    u_xlat3.xy = vec2((-u_xlat2.y) + vs_TEXCOORD2.x, (-u_xlat2.w) + vs_TEXCOORD2.y);
    u_xlat3.z = u_xlat12 * u_xlat3.y;
    u_xlat12 = dot(u_xlat3.xz, u_xlat3.xz);
    u_xlat19 = dot(u_xlat3.xy, u_xlat3.xy);
    u_xlat19 = sqrt(u_xlat19);
    u_xlat13 = u_xlat19 + (-_CornerRadiuses[u_xlati13.x]);
    u_xlat12 = sqrt(u_xlat12);
    u_xlat12 = (-u_xlat1.x) + u_xlat12;
    u_xlatb1.xy = lessThan(vec4(0.0, 0.0, 0.0, 0.0), u_xlat1.xyxx).xy;
    u_xlatb1.x = u_xlatb1.y && u_xlatb1.x;
    u_xlat7 = dFdx(vs_TEXCOORD2.x);
    u_xlat7 = float(1.0) / abs(u_xlat7);
    u_xlat12 = u_xlat12 * u_xlat7 + 0.5;
#ifdef UNITY_ADRENO_ES3
    u_xlat12 = min(max(u_xlat12, 0.0), 1.0);
#else
    u_xlat12 = clamp(u_xlat12, 0.0, 1.0);
#endif
    u_xlat7 = u_xlat13 * u_xlat7 + 0.5;
#ifdef UNITY_ADRENO_ES3
    u_xlat7 = min(max(u_xlat7, 0.0), 1.0);
#else
    u_xlat7 = clamp(u_xlat7, 0.0, 1.0);
#endif
    u_xlat12 = (u_xlatb1.x) ? u_xlat12 : 1.0;
    u_xlatb1.xz = lessThan(vec4(0.0, 0.0, 0.0, 0.0), u_xlat2.xxzx).xz;
    u_xlatb1.x = u_xlatb1.z || u_xlatb1.x;
    u_xlat12 = u_xlatb1.x ? u_xlat12 : float(0.0);
    u_xlat1.x = u_xlatb1.x ? u_xlat7 : float(0.0);
#ifdef UNITY_ADRENO_ES3
    u_xlatb7 = !!(u_xlat1.x==0.0);
#else
    u_xlatb7 = u_xlat1.x==0.0;
#endif
    u_xlat1.x = (-u_xlat1.x) + 1.0;
    u_xlat12 = (u_xlatb7) ? u_xlat12 : u_xlat1.x;
    u_xlatb1.xy = greaterThanEqual(u_xlat2.ywyy, vs_TEXCOORD2.xyxx).xy;
    u_xlatb13.xy = greaterThanEqual(vs_TEXCOORD2.xyxy, u_xlat2.ywyw).xy;
    u_xlatb6.x = (u_xlatb6.x) ? u_xlatb1.x : u_xlatb13.x;
    u_xlatb6.z = (u_xlatb6.z) ? u_xlatb1.y : u_xlatb13.y;
    u_xlatb6.x = u_xlatb6.z && u_xlatb6.x;
    u_xlat12 = (u_xlatb6.x) ? u_xlat12 : 1.0;
    u_xlat10_1 = texture(_MainTex, vs_TEXCOORD0.xy);
    u_xlat1 = u_xlat10_1 * vs_COLOR0;
    u_xlat12 = u_xlat12 * u_xlat1.w;
    u_xlat0 = (u_xlatb0) ? 0.0 : u_xlat12;
    u_xlat16_5 = (u_xlatb6.x) ? u_xlat12 : u_xlat0;
#ifdef UNITY_ADRENO_ES3
    u_xlatb0 = !!(0.0<_BorderWidths[0]);
#else
    u_xlatb0 = 0.0<_BorderWidths[0];
#endif
#ifdef UNITY_ADRENO_ES3
    u_xlatb6.x = !!(0.0<_BorderWidths[1]);
#else
    u_xlatb6.x = 0.0<_BorderWidths[1];
#endif
    u_xlatb0 = u_xlatb6.x || u_xlatb0;
#ifdef UNITY_ADRENO_ES3
    u_xlatb6.x = !!(0.0<_BorderWidths[2]);
#else
    u_xlatb6.x = 0.0<_BorderWidths[2];
#endif
    u_xlatb0 = u_xlatb6.x || u_xlatb0;
#ifdef UNITY_ADRENO_ES3
    u_xlatb6.x = !!(0.0<_BorderWidths[3]);
#else
    u_xlatb6.x = 0.0<_BorderWidths[3];
#endif
    u_xlatb0 = u_xlatb6.x || u_xlatb0;
    u_xlat0 = (u_xlatb0) ? u_xlat16_5 : 1.0;
    u_xlat0 = u_xlat0 * u_xlat12;
    u_xlat10_6 = texture(_GUIClipTexture, vs_TEXCOORD1.xy).w;
    u_xlat1.w = u_xlat10_6 * u_xlat0;
    SV_Target0 = u_xlat1;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixV[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	vec4 _MainTex_ST;
uniform 	vec4 hlslcc_mtx4x4unity_GUIClipTextureMatrix[4];
in highp vec4 in_POSITION0;
in mediump vec4 in_COLOR0;
in highp vec2 in_TEXCOORD0;
out mediump vec4 vs_COLOR0;
out highp vec2 vs_TEXCOORD0;
out highp vec2 vs_TEXCOORD1;
out highp vec4 vs_TEXCOORD2;
vec4 u_xlat0;
vec4 u_xlat1;
vec2 u_xlat2;
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
    vs_COLOR0 = in_COLOR0;
    u_xlat1.xy = u_xlat0.yy * hlslcc_mtx4x4unity_MatrixV[1].xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_MatrixV[0].xy * u_xlat0.xx + u_xlat1.xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_MatrixV[2].xy * u_xlat0.zz + u_xlat0.xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_MatrixV[3].xy * u_xlat0.ww + u_xlat0.xy;
    u_xlat2.xy = u_xlat0.yy * hlslcc_mtx4x4unity_GUIClipTextureMatrix[1].xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_GUIClipTextureMatrix[0].xy * u_xlat0.xx + u_xlat2.xy;
    vs_TEXCOORD1.xy = u_xlat0.xy + hlslcc_mtx4x4unity_GUIClipTextureMatrix[3].xy;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    vs_TEXCOORD2 = in_POSITION0;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	float _CornerRadiuses[4];
uniform 	float _BorderWidths[4];
uniform 	float _Rect[4];
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D _GUIClipTexture;
in mediump vec4 vs_COLOR0;
in highp vec2 vs_TEXCOORD0;
in highp vec2 vs_TEXCOORD1;
in highp vec4 vs_TEXCOORD2;
layout(location = 0) out mediump vec4 SV_Target0;
float u_xlat0;
bool u_xlatb0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
bvec3 u_xlatb1;
vec4 u_xlat2;
vec3 u_xlat3;
mediump float u_xlat16_5;
vec3 u_xlat6;
lowp float u_xlat10_6;
bvec3 u_xlatb6;
float u_xlat7;
bool u_xlatb7;
float u_xlat12;
bool u_xlatb12;
float u_xlat13;
ivec2 u_xlati13;
bvec2 u_xlatb13;
vec2 u_xlat15;
vec2 u_xlat16;
float u_xlat18;
float u_xlat19;
void main()
{
    u_xlat0 = _BorderWidths[0] + _BorderWidths[2];
    u_xlat0 = (-u_xlat0) + _Rect[2];
    u_xlat6.x = _BorderWidths[0] + _Rect[0];
    u_xlat0 = u_xlat0 + u_xlat6.x;
#ifdef UNITY_ADRENO_ES3
    u_xlatb6.x = !!(vs_TEXCOORD2.x>=u_xlat6.x);
#else
    u_xlatb6.x = vs_TEXCOORD2.x>=u_xlat6.x;
#endif
#ifdef UNITY_ADRENO_ES3
    u_xlatb0 = !!(u_xlat0>=vs_TEXCOORD2.x);
#else
    u_xlatb0 = u_xlat0>=vs_TEXCOORD2.x;
#endif
    u_xlatb0 = u_xlatb0 && u_xlatb6.x;
    u_xlat6.x = _BorderWidths[1] + _Rect[1];
#ifdef UNITY_ADRENO_ES3
    u_xlatb12 = !!(vs_TEXCOORD2.y>=u_xlat6.x);
#else
    u_xlatb12 = vs_TEXCOORD2.y>=u_xlat6.x;
#endif
    u_xlatb0 = u_xlatb12 && u_xlatb0;
    u_xlat12 = _BorderWidths[1] + _BorderWidths[3];
    u_xlat12 = (-u_xlat12) + _Rect[3];
    u_xlat6.x = u_xlat12 + u_xlat6.x;
#ifdef UNITY_ADRENO_ES3
    u_xlatb6.x = !!(u_xlat6.x>=vs_TEXCOORD2.y);
#else
    u_xlatb6.x = u_xlat6.x>=vs_TEXCOORD2.y;
#endif
    u_xlatb0 = u_xlatb6.x && u_xlatb0;
    u_xlat1.x = _BorderWidths[0];
    u_xlat2.x = _BorderWidths[2];
    u_xlat6.x = vs_TEXCOORD2.x + (-_Rect[0]);
    u_xlat6.x = (-_Rect[2]) * 0.5 + u_xlat6.x;
    u_xlat12 = _Rect[0] + _Rect[2];
    u_xlat18 = vs_TEXCOORD2.y + (-_Rect[1]);
    u_xlat6.z = (-_Rect[3]) * 0.5 + u_xlat18;
    u_xlatb6.xz = greaterThanEqual(vec4(0.0, 0.0, 0.0, 0.0), u_xlat6.xxzz).xz;
    u_xlati13.xy = (u_xlatb6.z) ? ivec2(0, 1) : ivec2(3, 2);
    u_xlati13.x = (u_xlatb6.x) ? u_xlati13.x : u_xlati13.y;
    u_xlat2.y = u_xlat12 + (-_CornerRadiuses[u_xlati13.x]);
    u_xlat1.y = _Rect[0] + _CornerRadiuses[u_xlati13.x];
    u_xlat2.xy = (u_xlatb6.x) ? u_xlat1.xy : u_xlat2.xy;
    u_xlat15.x = _BorderWidths[1];
    u_xlat16.x = _BorderWidths[3];
    u_xlat12 = _Rect[1] + _Rect[3];
    u_xlat16.y = u_xlat12 + (-_CornerRadiuses[u_xlati13.x]);
    u_xlat15.y = _Rect[1] + _CornerRadiuses[u_xlati13.x];
    u_xlat2.zw = (u_xlatb6.z) ? u_xlat15.xy : u_xlat16.xy;
    u_xlat1.xy = (-u_xlat2.xz) + vec2(_CornerRadiuses[u_xlati13.x]);
    u_xlat12 = u_xlat1.x / u_xlat1.y;
    u_xlat3.xy = vec2((-u_xlat2.y) + vs_TEXCOORD2.x, (-u_xlat2.w) + vs_TEXCOORD2.y);
    u_xlat3.z = u_xlat12 * u_xlat3.y;
    u_xlat12 = dot(u_xlat3.xz, u_xlat3.xz);
    u_xlat19 = dot(u_xlat3.xy, u_xlat3.xy);
    u_xlat19 = sqrt(u_xlat19);
    u_xlat13 = u_xlat19 + (-_CornerRadiuses[u_xlati13.x]);
    u_xlat12 = sqrt(u_xlat12);
    u_xlat12 = (-u_xlat1.x) + u_xlat12;
    u_xlatb1.xy = lessThan(vec4(0.0, 0.0, 0.0, 0.0), u_xlat1.xyxx).xy;
    u_xlatb1.x = u_xlatb1.y && u_xlatb1.x;
    u_xlat7 = dFdx(vs_TEXCOORD2.x);
    u_xlat7 = float(1.0) / abs(u_xlat7);
    u_xlat12 = u_xlat12 * u_xlat7 + 0.5;
#ifdef UNITY_ADRENO_ES3
    u_xlat12 = min(max(u_xlat12, 0.0), 1.0);
#else
    u_xlat12 = clamp(u_xlat12, 0.0, 1.0);
#endif
    u_xlat7 = u_xlat13 * u_xlat7 + 0.5;
#ifdef UNITY_ADRENO_ES3
    u_xlat7 = min(max(u_xlat7, 0.0), 1.0);
#else
    u_xlat7 = clamp(u_xlat7, 0.0, 1.0);
#endif
    u_xlat12 = (u_xlatb1.x) ? u_xlat12 : 1.0;
    u_xlatb1.xz = lessThan(vec4(0.0, 0.0, 0.0, 0.0), u_xlat2.xxzx).xz;
    u_xlatb1.x = u_xlatb1.z || u_xlatb1.x;
    u_xlat12 = u_xlatb1.x ? u_xlat12 : float(0.0);
    u_xlat1.x = u_xlatb1.x ? u_xlat7 : float(0.0);
#ifdef UNITY_ADRENO_ES3
    u_xlatb7 = !!(u_xlat1.x==0.0);
#else
    u_xlatb7 = u_xlat1.x==0.0;
#endif
    u_xlat1.x = (-u_xlat1.x) + 1.0;
    u_xlat12 = (u_xlatb7) ? u_xlat12 : u_xlat1.x;
    u_xlatb1.xy = greaterThanEqual(u_xlat2.ywyy, vs_TEXCOORD2.xyxx).xy;
    u_xlatb13.xy = greaterThanEqual(vs_TEXCOORD2.xyxy, u_xlat2.ywyw).xy;
    u_xlatb6.x = (u_xlatb6.x) ? u_xlatb1.x : u_xlatb13.x;
    u_xlatb6.z = (u_xlatb6.z) ? u_xlatb1.y : u_xlatb13.y;
    u_xlatb6.x = u_xlatb6.z && u_xlatb6.x;
    u_xlat12 = (u_xlatb6.x) ? u_xlat12 : 1.0;
    u_xlat10_1 = texture(_MainTex, vs_TEXCOORD0.xy);
    u_xlat1 = u_xlat10_1 * vs_COLOR0;
    u_xlat12 = u_xlat12 * u_xlat1.w;
    u_xlat0 = (u_xlatb0) ? 0.0 : u_xlat12;
    u_xlat16_5 = (u_xlatb6.x) ? u_xlat12 : u_xlat0;
#ifdef UNITY_ADRENO_ES3
    u_xlatb0 = !!(0.0<_BorderWidths[0]);
#else
    u_xlatb0 = 0.0<_BorderWidths[0];
#endif
#ifdef UNITY_ADRENO_ES3
    u_xlatb6.x = !!(0.0<_BorderWidths[1]);
#else
    u_xlatb6.x = 0.0<_BorderWidths[1];
#endif
    u_xlatb0 = u_xlatb6.x || u_xlatb0;
#ifdef UNITY_ADRENO_ES3
    u_xlatb6.x = !!(0.0<_BorderWidths[2]);
#else
    u_xlatb6.x = 0.0<_BorderWidths[2];
#endif
    u_xlatb0 = u_xlatb6.x || u_xlatb0;
#ifdef UNITY_ADRENO_ES3
    u_xlatb6.x = !!(0.0<_BorderWidths[3]);
#else
    u_xlatb6.x = 0.0<_BorderWidths[3];
#endif
    u_xlatb0 = u_xlatb6.x || u_xlatb0;
    u_xlat0 = (u_xlatb0) ? u_xlat16_5 : 1.0;
    u_xlat0 = u_xlat0 * u_xlat12;
    u_xlat10_6 = texture(_GUIClipTexture, vs_TEXCOORD1.xy).w;
    u_xlat1.w = u_xlat10_6 * u_xlat0;
    SV_Target0 = u_xlat1;
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
 Pass {
  ZTest Always
  ZWrite Off
  Cull Off
  GpuProgramID 77836
Program "vp" {
SubProgram "gles hw_tier00 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 unity_GUIClipTextureMatrix;
varying lowp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = tmpvar_1.xyz;
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = tmpvar_1.xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.zw = vec2(0.0, 1.0);
  tmpvar_4.xy = (unity_MatrixV * (unity_ObjectToWorld * tmpvar_2)).xy;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_3));
  xlv_COLOR = _glesColor;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (unity_GUIClipTextureMatrix * tmpvar_4).xy;
  xlv_TEXCOORD2 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
#extension GL_OES_standard_derivatives : enable
uniform sampler2D _MainTex;
uniform sampler2D _GUIClipTexture;
uniform highp float _CornerRadiuses[4];
uniform highp float _BorderWidths[4];
uniform highp float _Rect[4];
varying lowp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec2 center_2;
  highp int radiusIndex_3;
  highp float bw2_4;
  highp float bw1_5;
  mediump vec4 col_6;
  highp float tmpvar_7;
  tmpvar_7 = (1.0/(abs(dFdx(xlv_TEXCOORD2.x))));
  lowp vec4 tmpvar_8;
  tmpvar_8 = (texture2D (_MainTex, xlv_TEXCOORD0) * xlv_COLOR);
  col_6 = tmpvar_8;
  bool tmpvar_9;
  tmpvar_9 = (((xlv_TEXCOORD2.x - _Rect[0]) - (_Rect[2] / 2.0)) <= 0.0);
  bool tmpvar_10;
  tmpvar_10 = (((xlv_TEXCOORD2.y - _Rect[1]) - (_Rect[3] / 2.0)) <= 0.0);
  bw1_5 = _BorderWidths[0];
  bw2_4 = _BorderWidths[1];
  radiusIndex_3 = 0;
  if (tmpvar_9) {
    highp int tmpvar_11;
    if (tmpvar_10) {
      tmpvar_11 = 0;
    } else {
      tmpvar_11 = 3;
    };
    radiusIndex_3 = tmpvar_11;
  } else {
    highp int tmpvar_12;
    if (tmpvar_10) {
      tmpvar_12 = 1;
    } else {
      tmpvar_12 = 2;
    };
    radiusIndex_3 = tmpvar_12;
  };
  highp float tmpvar_13;
  tmpvar_13 = _CornerRadiuses[radiusIndex_3];
  highp vec2 tmpvar_14;
  tmpvar_14.x = (_Rect[0] + tmpvar_13);
  tmpvar_14.y = (_Rect[1] + tmpvar_13);
  center_2 = tmpvar_14;
  if (!(tmpvar_9)) {
    center_2.x = ((_Rect[0] + _Rect[2]) - tmpvar_13);
    bw1_5 = _BorderWidths[2];
  };
  if (!(tmpvar_10)) {
    center_2.y = ((_Rect[1] + _Rect[3]) - tmpvar_13);
    bw2_4 = _BorderWidths[3];
  };
  bool tmpvar_15;
  if (tmpvar_9) {
    tmpvar_15 = (xlv_TEXCOORD2.x <= center_2.x);
  } else {
    tmpvar_15 = (xlv_TEXCOORD2.x >= center_2.x);
  };
  bool tmpvar_16;
  if (tmpvar_15) {
    bool tmpvar_17;
    if (tmpvar_10) {
      tmpvar_17 = (xlv_TEXCOORD2.y <= center_2.y);
    } else {
      tmpvar_17 = (xlv_TEXCOORD2.y >= center_2.y);
    };
    tmpvar_16 = tmpvar_17;
  } else {
    tmpvar_16 = bool(0);
  };
  mediump float tmpvar_18;
  if (tmpvar_16) {
    mediump float rawDist_19;
    highp vec2 v_20;
    bool tmpvar_21;
    tmpvar_21 = ((bw1_5 > 0.0) || (bw2_4 > 0.0));
    highp vec2 tmpvar_22;
    tmpvar_22 = (xlv_TEXCOORD2.xy - center_2);
    v_20 = tmpvar_22;
    highp float tmpvar_23;
    tmpvar_23 = ((sqrt(
      dot (tmpvar_22, tmpvar_22)
    ) - tmpvar_13) * tmpvar_7);
    mediump float tmpvar_24;
    if (tmpvar_21) {
      highp float tmpvar_25;
      tmpvar_25 = clamp ((0.5 + tmpvar_23), 0.0, 1.0);
      tmpvar_24 = tmpvar_25;
    } else {
      tmpvar_24 = 0.0;
    };
    highp float tmpvar_26;
    tmpvar_26 = (tmpvar_13 - bw1_5);
    highp float tmpvar_27;
    tmpvar_27 = (tmpvar_13 - bw2_4);
    v_20.y = (tmpvar_22.y * (tmpvar_26 / tmpvar_27));
    highp float tmpvar_28;
    tmpvar_28 = ((sqrt(
      dot (v_20, v_20)
    ) - tmpvar_26) * tmpvar_7);
    rawDist_19 = tmpvar_28;
    mediump float tmpvar_29;
    tmpvar_29 = clamp ((rawDist_19 + 0.5), 0.0, 1.0);
    mediump float tmpvar_30;
    if (tmpvar_21) {
      mediump float tmpvar_31;
      if (((tmpvar_26 > 0.0) && (tmpvar_27 > 0.0))) {
        tmpvar_31 = tmpvar_29;
      } else {
        tmpvar_31 = 1.0;
      };
      tmpvar_30 = tmpvar_31;
    } else {
      tmpvar_30 = 0.0;
    };
    mediump float tmpvar_32;
    if ((tmpvar_24 == 0.0)) {
      tmpvar_32 = tmpvar_30;
    } else {
      tmpvar_32 = (1.0 - tmpvar_24);
    };
    tmpvar_18 = tmpvar_32;
  } else {
    tmpvar_18 = 1.0;
  };
  col_6.w = (col_6.w * tmpvar_18);
  highp vec4 tmpvar_33;
  tmpvar_33.x = (_Rect[0] + _BorderWidths[0]);
  tmpvar_33.y = (_Rect[1] + _BorderWidths[1]);
  tmpvar_33.z = (_Rect[2] - (_BorderWidths[0] + _BorderWidths[2]));
  tmpvar_33.w = (_Rect[3] - (_BorderWidths[1] + _BorderWidths[3]));
  bool tmpvar_34;
  tmpvar_34 = (((
    (xlv_TEXCOORD2.x >= tmpvar_33.x)
   && 
    (xlv_TEXCOORD2.x <= (tmpvar_33.x + tmpvar_33.z))
  ) && (xlv_TEXCOORD2.y >= tmpvar_33.y)) && (xlv_TEXCOORD2.y <= (tmpvar_33.y + tmpvar_33.w)));
  mediump float tmpvar_35;
  if (tmpvar_34) {
    tmpvar_35 = 0.0;
  } else {
    tmpvar_35 = col_6.w;
  };
  mediump float tmpvar_36;
  if ((((
    (_BorderWidths[0] > 0.0)
   || 
    (_BorderWidths[1] > 0.0)
  ) || (_BorderWidths[2] > 0.0)) || (_BorderWidths[3] > 0.0))) {
    mediump float tmpvar_37;
    if (tmpvar_16) {
      tmpvar_37 = col_6.w;
    } else {
      tmpvar_37 = tmpvar_35;
    };
    tmpvar_36 = tmpvar_37;
  } else {
    tmpvar_36 = 1.0;
  };
  col_6.w = (col_6.w * tmpvar_36);
  lowp vec4 tmpvar_38;
  tmpvar_38 = texture2D (_GUIClipTexture, xlv_TEXCOORD1);
  col_6.w = (col_6.w * tmpvar_38.w);
  tmpvar_1 = col_6;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier01 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 unity_GUIClipTextureMatrix;
varying lowp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = tmpvar_1.xyz;
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = tmpvar_1.xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.zw = vec2(0.0, 1.0);
  tmpvar_4.xy = (unity_MatrixV * (unity_ObjectToWorld * tmpvar_2)).xy;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_3));
  xlv_COLOR = _glesColor;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (unity_GUIClipTextureMatrix * tmpvar_4).xy;
  xlv_TEXCOORD2 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
#extension GL_OES_standard_derivatives : enable
uniform sampler2D _MainTex;
uniform sampler2D _GUIClipTexture;
uniform highp float _CornerRadiuses[4];
uniform highp float _BorderWidths[4];
uniform highp float _Rect[4];
varying lowp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec2 center_2;
  highp int radiusIndex_3;
  highp float bw2_4;
  highp float bw1_5;
  mediump vec4 col_6;
  highp float tmpvar_7;
  tmpvar_7 = (1.0/(abs(dFdx(xlv_TEXCOORD2.x))));
  lowp vec4 tmpvar_8;
  tmpvar_8 = (texture2D (_MainTex, xlv_TEXCOORD0) * xlv_COLOR);
  col_6 = tmpvar_8;
  bool tmpvar_9;
  tmpvar_9 = (((xlv_TEXCOORD2.x - _Rect[0]) - (_Rect[2] / 2.0)) <= 0.0);
  bool tmpvar_10;
  tmpvar_10 = (((xlv_TEXCOORD2.y - _Rect[1]) - (_Rect[3] / 2.0)) <= 0.0);
  bw1_5 = _BorderWidths[0];
  bw2_4 = _BorderWidths[1];
  radiusIndex_3 = 0;
  if (tmpvar_9) {
    highp int tmpvar_11;
    if (tmpvar_10) {
      tmpvar_11 = 0;
    } else {
      tmpvar_11 = 3;
    };
    radiusIndex_3 = tmpvar_11;
  } else {
    highp int tmpvar_12;
    if (tmpvar_10) {
      tmpvar_12 = 1;
    } else {
      tmpvar_12 = 2;
    };
    radiusIndex_3 = tmpvar_12;
  };
  highp float tmpvar_13;
  tmpvar_13 = _CornerRadiuses[radiusIndex_3];
  highp vec2 tmpvar_14;
  tmpvar_14.x = (_Rect[0] + tmpvar_13);
  tmpvar_14.y = (_Rect[1] + tmpvar_13);
  center_2 = tmpvar_14;
  if (!(tmpvar_9)) {
    center_2.x = ((_Rect[0] + _Rect[2]) - tmpvar_13);
    bw1_5 = _BorderWidths[2];
  };
  if (!(tmpvar_10)) {
    center_2.y = ((_Rect[1] + _Rect[3]) - tmpvar_13);
    bw2_4 = _BorderWidths[3];
  };
  bool tmpvar_15;
  if (tmpvar_9) {
    tmpvar_15 = (xlv_TEXCOORD2.x <= center_2.x);
  } else {
    tmpvar_15 = (xlv_TEXCOORD2.x >= center_2.x);
  };
  bool tmpvar_16;
  if (tmpvar_15) {
    bool tmpvar_17;
    if (tmpvar_10) {
      tmpvar_17 = (xlv_TEXCOORD2.y <= center_2.y);
    } else {
      tmpvar_17 = (xlv_TEXCOORD2.y >= center_2.y);
    };
    tmpvar_16 = tmpvar_17;
  } else {
    tmpvar_16 = bool(0);
  };
  mediump float tmpvar_18;
  if (tmpvar_16) {
    mediump float rawDist_19;
    highp vec2 v_20;
    bool tmpvar_21;
    tmpvar_21 = ((bw1_5 > 0.0) || (bw2_4 > 0.0));
    highp vec2 tmpvar_22;
    tmpvar_22 = (xlv_TEXCOORD2.xy - center_2);
    v_20 = tmpvar_22;
    highp float tmpvar_23;
    tmpvar_23 = ((sqrt(
      dot (tmpvar_22, tmpvar_22)
    ) - tmpvar_13) * tmpvar_7);
    mediump float tmpvar_24;
    if (tmpvar_21) {
      highp float tmpvar_25;
      tmpvar_25 = clamp ((0.5 + tmpvar_23), 0.0, 1.0);
      tmpvar_24 = tmpvar_25;
    } else {
      tmpvar_24 = 0.0;
    };
    highp float tmpvar_26;
    tmpvar_26 = (tmpvar_13 - bw1_5);
    highp float tmpvar_27;
    tmpvar_27 = (tmpvar_13 - bw2_4);
    v_20.y = (tmpvar_22.y * (tmpvar_26 / tmpvar_27));
    highp float tmpvar_28;
    tmpvar_28 = ((sqrt(
      dot (v_20, v_20)
    ) - tmpvar_26) * tmpvar_7);
    rawDist_19 = tmpvar_28;
    mediump float tmpvar_29;
    tmpvar_29 = clamp ((rawDist_19 + 0.5), 0.0, 1.0);
    mediump float tmpvar_30;
    if (tmpvar_21) {
      mediump float tmpvar_31;
      if (((tmpvar_26 > 0.0) && (tmpvar_27 > 0.0))) {
        tmpvar_31 = tmpvar_29;
      } else {
        tmpvar_31 = 1.0;
      };
      tmpvar_30 = tmpvar_31;
    } else {
      tmpvar_30 = 0.0;
    };
    mediump float tmpvar_32;
    if ((tmpvar_24 == 0.0)) {
      tmpvar_32 = tmpvar_30;
    } else {
      tmpvar_32 = (1.0 - tmpvar_24);
    };
    tmpvar_18 = tmpvar_32;
  } else {
    tmpvar_18 = 1.0;
  };
  col_6.w = (col_6.w * tmpvar_18);
  highp vec4 tmpvar_33;
  tmpvar_33.x = (_Rect[0] + _BorderWidths[0]);
  tmpvar_33.y = (_Rect[1] + _BorderWidths[1]);
  tmpvar_33.z = (_Rect[2] - (_BorderWidths[0] + _BorderWidths[2]));
  tmpvar_33.w = (_Rect[3] - (_BorderWidths[1] + _BorderWidths[3]));
  bool tmpvar_34;
  tmpvar_34 = (((
    (xlv_TEXCOORD2.x >= tmpvar_33.x)
   && 
    (xlv_TEXCOORD2.x <= (tmpvar_33.x + tmpvar_33.z))
  ) && (xlv_TEXCOORD2.y >= tmpvar_33.y)) && (xlv_TEXCOORD2.y <= (tmpvar_33.y + tmpvar_33.w)));
  mediump float tmpvar_35;
  if (tmpvar_34) {
    tmpvar_35 = 0.0;
  } else {
    tmpvar_35 = col_6.w;
  };
  mediump float tmpvar_36;
  if ((((
    (_BorderWidths[0] > 0.0)
   || 
    (_BorderWidths[1] > 0.0)
  ) || (_BorderWidths[2] > 0.0)) || (_BorderWidths[3] > 0.0))) {
    mediump float tmpvar_37;
    if (tmpvar_16) {
      tmpvar_37 = col_6.w;
    } else {
      tmpvar_37 = tmpvar_35;
    };
    tmpvar_36 = tmpvar_37;
  } else {
    tmpvar_36 = 1.0;
  };
  col_6.w = (col_6.w * tmpvar_36);
  lowp vec4 tmpvar_38;
  tmpvar_38 = texture2D (_GUIClipTexture, xlv_TEXCOORD1);
  col_6.w = (col_6.w * tmpvar_38.w);
  tmpvar_1 = col_6;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles hw_tier02 " {
"#version 100

#ifdef VERTEX
attribute vec4 _glesVertex;
attribute vec4 _glesColor;
attribute vec4 _glesMultiTexCoord0;
uniform highp mat4 unity_ObjectToWorld;
uniform highp mat4 unity_MatrixV;
uniform highp mat4 unity_MatrixVP;
uniform highp vec4 _MainTex_ST;
uniform highp mat4 unity_GUIClipTextureMatrix;
varying lowp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  highp vec4 tmpvar_1;
  tmpvar_1 = _glesVertex;
  highp vec4 tmpvar_2;
  tmpvar_2.w = 1.0;
  tmpvar_2.xyz = tmpvar_1.xyz;
  highp vec4 tmpvar_3;
  tmpvar_3.w = 1.0;
  tmpvar_3.xyz = tmpvar_1.xyz;
  highp vec4 tmpvar_4;
  tmpvar_4.zw = vec2(0.0, 1.0);
  tmpvar_4.xy = (unity_MatrixV * (unity_ObjectToWorld * tmpvar_2)).xy;
  gl_Position = (unity_MatrixVP * (unity_ObjectToWorld * tmpvar_3));
  xlv_COLOR = _glesColor;
  xlv_TEXCOORD0 = ((_glesMultiTexCoord0.xy * _MainTex_ST.xy) + _MainTex_ST.zw);
  xlv_TEXCOORD1 = (unity_GUIClipTextureMatrix * tmpvar_4).xy;
  xlv_TEXCOORD2 = tmpvar_1;
}


#endif
#ifdef FRAGMENT
#extension GL_OES_standard_derivatives : enable
uniform sampler2D _MainTex;
uniform sampler2D _GUIClipTexture;
uniform highp float _CornerRadiuses[4];
uniform highp float _BorderWidths[4];
uniform highp float _Rect[4];
varying lowp vec4 xlv_COLOR;
varying highp vec2 xlv_TEXCOORD0;
varying highp vec2 xlv_TEXCOORD1;
varying highp vec4 xlv_TEXCOORD2;
void main ()
{
  lowp vec4 tmpvar_1;
  highp vec2 center_2;
  highp int radiusIndex_3;
  highp float bw2_4;
  highp float bw1_5;
  mediump vec4 col_6;
  highp float tmpvar_7;
  tmpvar_7 = (1.0/(abs(dFdx(xlv_TEXCOORD2.x))));
  lowp vec4 tmpvar_8;
  tmpvar_8 = (texture2D (_MainTex, xlv_TEXCOORD0) * xlv_COLOR);
  col_6 = tmpvar_8;
  bool tmpvar_9;
  tmpvar_9 = (((xlv_TEXCOORD2.x - _Rect[0]) - (_Rect[2] / 2.0)) <= 0.0);
  bool tmpvar_10;
  tmpvar_10 = (((xlv_TEXCOORD2.y - _Rect[1]) - (_Rect[3] / 2.0)) <= 0.0);
  bw1_5 = _BorderWidths[0];
  bw2_4 = _BorderWidths[1];
  radiusIndex_3 = 0;
  if (tmpvar_9) {
    highp int tmpvar_11;
    if (tmpvar_10) {
      tmpvar_11 = 0;
    } else {
      tmpvar_11 = 3;
    };
    radiusIndex_3 = tmpvar_11;
  } else {
    highp int tmpvar_12;
    if (tmpvar_10) {
      tmpvar_12 = 1;
    } else {
      tmpvar_12 = 2;
    };
    radiusIndex_3 = tmpvar_12;
  };
  highp float tmpvar_13;
  tmpvar_13 = _CornerRadiuses[radiusIndex_3];
  highp vec2 tmpvar_14;
  tmpvar_14.x = (_Rect[0] + tmpvar_13);
  tmpvar_14.y = (_Rect[1] + tmpvar_13);
  center_2 = tmpvar_14;
  if (!(tmpvar_9)) {
    center_2.x = ((_Rect[0] + _Rect[2]) - tmpvar_13);
    bw1_5 = _BorderWidths[2];
  };
  if (!(tmpvar_10)) {
    center_2.y = ((_Rect[1] + _Rect[3]) - tmpvar_13);
    bw2_4 = _BorderWidths[3];
  };
  bool tmpvar_15;
  if (tmpvar_9) {
    tmpvar_15 = (xlv_TEXCOORD2.x <= center_2.x);
  } else {
    tmpvar_15 = (xlv_TEXCOORD2.x >= center_2.x);
  };
  bool tmpvar_16;
  if (tmpvar_15) {
    bool tmpvar_17;
    if (tmpvar_10) {
      tmpvar_17 = (xlv_TEXCOORD2.y <= center_2.y);
    } else {
      tmpvar_17 = (xlv_TEXCOORD2.y >= center_2.y);
    };
    tmpvar_16 = tmpvar_17;
  } else {
    tmpvar_16 = bool(0);
  };
  mediump float tmpvar_18;
  if (tmpvar_16) {
    mediump float rawDist_19;
    highp vec2 v_20;
    bool tmpvar_21;
    tmpvar_21 = ((bw1_5 > 0.0) || (bw2_4 > 0.0));
    highp vec2 tmpvar_22;
    tmpvar_22 = (xlv_TEXCOORD2.xy - center_2);
    v_20 = tmpvar_22;
    highp float tmpvar_23;
    tmpvar_23 = ((sqrt(
      dot (tmpvar_22, tmpvar_22)
    ) - tmpvar_13) * tmpvar_7);
    mediump float tmpvar_24;
    if (tmpvar_21) {
      highp float tmpvar_25;
      tmpvar_25 = clamp ((0.5 + tmpvar_23), 0.0, 1.0);
      tmpvar_24 = tmpvar_25;
    } else {
      tmpvar_24 = 0.0;
    };
    highp float tmpvar_26;
    tmpvar_26 = (tmpvar_13 - bw1_5);
    highp float tmpvar_27;
    tmpvar_27 = (tmpvar_13 - bw2_4);
    v_20.y = (tmpvar_22.y * (tmpvar_26 / tmpvar_27));
    highp float tmpvar_28;
    tmpvar_28 = ((sqrt(
      dot (v_20, v_20)
    ) - tmpvar_26) * tmpvar_7);
    rawDist_19 = tmpvar_28;
    mediump float tmpvar_29;
    tmpvar_29 = clamp ((rawDist_19 + 0.5), 0.0, 1.0);
    mediump float tmpvar_30;
    if (tmpvar_21) {
      mediump float tmpvar_31;
      if (((tmpvar_26 > 0.0) && (tmpvar_27 > 0.0))) {
        tmpvar_31 = tmpvar_29;
      } else {
        tmpvar_31 = 1.0;
      };
      tmpvar_30 = tmpvar_31;
    } else {
      tmpvar_30 = 0.0;
    };
    mediump float tmpvar_32;
    if ((tmpvar_24 == 0.0)) {
      tmpvar_32 = tmpvar_30;
    } else {
      tmpvar_32 = (1.0 - tmpvar_24);
    };
    tmpvar_18 = tmpvar_32;
  } else {
    tmpvar_18 = 1.0;
  };
  col_6.w = (col_6.w * tmpvar_18);
  highp vec4 tmpvar_33;
  tmpvar_33.x = (_Rect[0] + _BorderWidths[0]);
  tmpvar_33.y = (_Rect[1] + _BorderWidths[1]);
  tmpvar_33.z = (_Rect[2] - (_BorderWidths[0] + _BorderWidths[2]));
  tmpvar_33.w = (_Rect[3] - (_BorderWidths[1] + _BorderWidths[3]));
  bool tmpvar_34;
  tmpvar_34 = (((
    (xlv_TEXCOORD2.x >= tmpvar_33.x)
   && 
    (xlv_TEXCOORD2.x <= (tmpvar_33.x + tmpvar_33.z))
  ) && (xlv_TEXCOORD2.y >= tmpvar_33.y)) && (xlv_TEXCOORD2.y <= (tmpvar_33.y + tmpvar_33.w)));
  mediump float tmpvar_35;
  if (tmpvar_34) {
    tmpvar_35 = 0.0;
  } else {
    tmpvar_35 = col_6.w;
  };
  mediump float tmpvar_36;
  if ((((
    (_BorderWidths[0] > 0.0)
   || 
    (_BorderWidths[1] > 0.0)
  ) || (_BorderWidths[2] > 0.0)) || (_BorderWidths[3] > 0.0))) {
    mediump float tmpvar_37;
    if (tmpvar_16) {
      tmpvar_37 = col_6.w;
    } else {
      tmpvar_37 = tmpvar_35;
    };
    tmpvar_36 = tmpvar_37;
  } else {
    tmpvar_36 = 1.0;
  };
  col_6.w = (col_6.w * tmpvar_36);
  lowp vec4 tmpvar_38;
  tmpvar_38 = texture2D (_GUIClipTexture, xlv_TEXCOORD1);
  col_6.w = (col_6.w * tmpvar_38.w);
  tmpvar_1 = col_6;
  gl_FragData[0] = tmpvar_1;
}


#endif
"
}
SubProgram "gles3 hw_tier00 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixV[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	vec4 _MainTex_ST;
uniform 	vec4 hlslcc_mtx4x4unity_GUIClipTextureMatrix[4];
in highp vec4 in_POSITION0;
in mediump vec4 in_COLOR0;
in highp vec2 in_TEXCOORD0;
out mediump vec4 vs_COLOR0;
out highp vec2 vs_TEXCOORD0;
out highp vec2 vs_TEXCOORD1;
out highp vec4 vs_TEXCOORD2;
vec4 u_xlat0;
vec4 u_xlat1;
vec2 u_xlat2;
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
    vs_COLOR0 = in_COLOR0;
    u_xlat1.xy = u_xlat0.yy * hlslcc_mtx4x4unity_MatrixV[1].xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_MatrixV[0].xy * u_xlat0.xx + u_xlat1.xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_MatrixV[2].xy * u_xlat0.zz + u_xlat0.xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_MatrixV[3].xy * u_xlat0.ww + u_xlat0.xy;
    u_xlat2.xy = u_xlat0.yy * hlslcc_mtx4x4unity_GUIClipTextureMatrix[1].xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_GUIClipTextureMatrix[0].xy * u_xlat0.xx + u_xlat2.xy;
    vs_TEXCOORD1.xy = u_xlat0.xy + hlslcc_mtx4x4unity_GUIClipTextureMatrix[3].xy;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    vs_TEXCOORD2 = in_POSITION0;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	float _CornerRadiuses[4];
uniform 	float _BorderWidths[4];
uniform 	float _Rect[4];
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D _GUIClipTexture;
in mediump vec4 vs_COLOR0;
in highp vec2 vs_TEXCOORD0;
in highp vec2 vs_TEXCOORD1;
in highp vec4 vs_TEXCOORD2;
layout(location = 0) out mediump vec4 SV_Target0;
float u_xlat0;
bool u_xlatb0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
bvec3 u_xlatb1;
vec4 u_xlat2;
vec3 u_xlat3;
mediump float u_xlat16_5;
vec3 u_xlat6;
lowp float u_xlat10_6;
bvec3 u_xlatb6;
float u_xlat7;
bool u_xlatb7;
float u_xlat12;
bool u_xlatb12;
float u_xlat13;
ivec2 u_xlati13;
bvec2 u_xlatb13;
vec2 u_xlat15;
vec2 u_xlat16;
float u_xlat18;
float u_xlat19;
void main()
{
    u_xlat0 = _BorderWidths[0] + _BorderWidths[2];
    u_xlat0 = (-u_xlat0) + _Rect[2];
    u_xlat6.x = _BorderWidths[0] + _Rect[0];
    u_xlat0 = u_xlat0 + u_xlat6.x;
#ifdef UNITY_ADRENO_ES3
    u_xlatb6.x = !!(vs_TEXCOORD2.x>=u_xlat6.x);
#else
    u_xlatb6.x = vs_TEXCOORD2.x>=u_xlat6.x;
#endif
#ifdef UNITY_ADRENO_ES3
    u_xlatb0 = !!(u_xlat0>=vs_TEXCOORD2.x);
#else
    u_xlatb0 = u_xlat0>=vs_TEXCOORD2.x;
#endif
    u_xlatb0 = u_xlatb0 && u_xlatb6.x;
    u_xlat6.x = _BorderWidths[1] + _Rect[1];
#ifdef UNITY_ADRENO_ES3
    u_xlatb12 = !!(vs_TEXCOORD2.y>=u_xlat6.x);
#else
    u_xlatb12 = vs_TEXCOORD2.y>=u_xlat6.x;
#endif
    u_xlatb0 = u_xlatb12 && u_xlatb0;
    u_xlat12 = _BorderWidths[1] + _BorderWidths[3];
    u_xlat12 = (-u_xlat12) + _Rect[3];
    u_xlat6.x = u_xlat12 + u_xlat6.x;
#ifdef UNITY_ADRENO_ES3
    u_xlatb6.x = !!(u_xlat6.x>=vs_TEXCOORD2.y);
#else
    u_xlatb6.x = u_xlat6.x>=vs_TEXCOORD2.y;
#endif
    u_xlatb0 = u_xlatb6.x && u_xlatb0;
    u_xlat1.x = _BorderWidths[0];
    u_xlat2.x = _BorderWidths[2];
    u_xlat6.x = vs_TEXCOORD2.x + (-_Rect[0]);
    u_xlat6.x = (-_Rect[2]) * 0.5 + u_xlat6.x;
    u_xlat12 = _Rect[0] + _Rect[2];
    u_xlat18 = vs_TEXCOORD2.y + (-_Rect[1]);
    u_xlat6.z = (-_Rect[3]) * 0.5 + u_xlat18;
    u_xlatb6.xz = greaterThanEqual(vec4(0.0, 0.0, 0.0, 0.0), u_xlat6.xxzz).xz;
    u_xlati13.xy = (u_xlatb6.z) ? ivec2(0, 1) : ivec2(3, 2);
    u_xlati13.x = (u_xlatb6.x) ? u_xlati13.x : u_xlati13.y;
    u_xlat2.y = u_xlat12 + (-_CornerRadiuses[u_xlati13.x]);
    u_xlat1.y = _Rect[0] + _CornerRadiuses[u_xlati13.x];
    u_xlat2.xy = (u_xlatb6.x) ? u_xlat1.xy : u_xlat2.xy;
    u_xlat15.x = _BorderWidths[1];
    u_xlat16.x = _BorderWidths[3];
    u_xlat12 = _Rect[1] + _Rect[3];
    u_xlat16.y = u_xlat12 + (-_CornerRadiuses[u_xlati13.x]);
    u_xlat15.y = _Rect[1] + _CornerRadiuses[u_xlati13.x];
    u_xlat2.zw = (u_xlatb6.z) ? u_xlat15.xy : u_xlat16.xy;
    u_xlat1.xy = (-u_xlat2.xz) + vec2(_CornerRadiuses[u_xlati13.x]);
    u_xlat12 = u_xlat1.x / u_xlat1.y;
    u_xlat3.xy = vec2((-u_xlat2.y) + vs_TEXCOORD2.x, (-u_xlat2.w) + vs_TEXCOORD2.y);
    u_xlat3.z = u_xlat12 * u_xlat3.y;
    u_xlat12 = dot(u_xlat3.xz, u_xlat3.xz);
    u_xlat19 = dot(u_xlat3.xy, u_xlat3.xy);
    u_xlat19 = sqrt(u_xlat19);
    u_xlat13 = u_xlat19 + (-_CornerRadiuses[u_xlati13.x]);
    u_xlat12 = sqrt(u_xlat12);
    u_xlat12 = (-u_xlat1.x) + u_xlat12;
    u_xlatb1.xy = lessThan(vec4(0.0, 0.0, 0.0, 0.0), u_xlat1.xyxx).xy;
    u_xlatb1.x = u_xlatb1.y && u_xlatb1.x;
    u_xlat7 = dFdx(vs_TEXCOORD2.x);
    u_xlat7 = float(1.0) / abs(u_xlat7);
    u_xlat12 = u_xlat12 * u_xlat7 + 0.5;
#ifdef UNITY_ADRENO_ES3
    u_xlat12 = min(max(u_xlat12, 0.0), 1.0);
#else
    u_xlat12 = clamp(u_xlat12, 0.0, 1.0);
#endif
    u_xlat7 = u_xlat13 * u_xlat7 + 0.5;
#ifdef UNITY_ADRENO_ES3
    u_xlat7 = min(max(u_xlat7, 0.0), 1.0);
#else
    u_xlat7 = clamp(u_xlat7, 0.0, 1.0);
#endif
    u_xlat12 = (u_xlatb1.x) ? u_xlat12 : 1.0;
    u_xlatb1.xz = lessThan(vec4(0.0, 0.0, 0.0, 0.0), u_xlat2.xxzx).xz;
    u_xlatb1.x = u_xlatb1.z || u_xlatb1.x;
    u_xlat12 = u_xlatb1.x ? u_xlat12 : float(0.0);
    u_xlat1.x = u_xlatb1.x ? u_xlat7 : float(0.0);
#ifdef UNITY_ADRENO_ES3
    u_xlatb7 = !!(u_xlat1.x==0.0);
#else
    u_xlatb7 = u_xlat1.x==0.0;
#endif
    u_xlat1.x = (-u_xlat1.x) + 1.0;
    u_xlat12 = (u_xlatb7) ? u_xlat12 : u_xlat1.x;
    u_xlatb1.xy = greaterThanEqual(u_xlat2.ywyy, vs_TEXCOORD2.xyxx).xy;
    u_xlatb13.xy = greaterThanEqual(vs_TEXCOORD2.xyxy, u_xlat2.ywyw).xy;
    u_xlatb6.x = (u_xlatb6.x) ? u_xlatb1.x : u_xlatb13.x;
    u_xlatb6.z = (u_xlatb6.z) ? u_xlatb1.y : u_xlatb13.y;
    u_xlatb6.x = u_xlatb6.z && u_xlatb6.x;
    u_xlat12 = (u_xlatb6.x) ? u_xlat12 : 1.0;
    u_xlat10_1 = texture(_MainTex, vs_TEXCOORD0.xy);
    u_xlat1 = u_xlat10_1 * vs_COLOR0;
    u_xlat12 = u_xlat12 * u_xlat1.w;
    u_xlat0 = (u_xlatb0) ? 0.0 : u_xlat12;
    u_xlat16_5 = (u_xlatb6.x) ? u_xlat12 : u_xlat0;
#ifdef UNITY_ADRENO_ES3
    u_xlatb0 = !!(0.0<_BorderWidths[0]);
#else
    u_xlatb0 = 0.0<_BorderWidths[0];
#endif
#ifdef UNITY_ADRENO_ES3
    u_xlatb6.x = !!(0.0<_BorderWidths[1]);
#else
    u_xlatb6.x = 0.0<_BorderWidths[1];
#endif
    u_xlatb0 = u_xlatb6.x || u_xlatb0;
#ifdef UNITY_ADRENO_ES3
    u_xlatb6.x = !!(0.0<_BorderWidths[2]);
#else
    u_xlatb6.x = 0.0<_BorderWidths[2];
#endif
    u_xlatb0 = u_xlatb6.x || u_xlatb0;
#ifdef UNITY_ADRENO_ES3
    u_xlatb6.x = !!(0.0<_BorderWidths[3]);
#else
    u_xlatb6.x = 0.0<_BorderWidths[3];
#endif
    u_xlatb0 = u_xlatb6.x || u_xlatb0;
    u_xlat0 = (u_xlatb0) ? u_xlat16_5 : 1.0;
    u_xlat0 = u_xlat0 * u_xlat12;
    u_xlat10_6 = texture(_GUIClipTexture, vs_TEXCOORD1.xy).w;
    u_xlat1.w = u_xlat10_6 * u_xlat0;
    SV_Target0 = u_xlat1;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier01 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixV[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	vec4 _MainTex_ST;
uniform 	vec4 hlslcc_mtx4x4unity_GUIClipTextureMatrix[4];
in highp vec4 in_POSITION0;
in mediump vec4 in_COLOR0;
in highp vec2 in_TEXCOORD0;
out mediump vec4 vs_COLOR0;
out highp vec2 vs_TEXCOORD0;
out highp vec2 vs_TEXCOORD1;
out highp vec4 vs_TEXCOORD2;
vec4 u_xlat0;
vec4 u_xlat1;
vec2 u_xlat2;
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
    vs_COLOR0 = in_COLOR0;
    u_xlat1.xy = u_xlat0.yy * hlslcc_mtx4x4unity_MatrixV[1].xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_MatrixV[0].xy * u_xlat0.xx + u_xlat1.xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_MatrixV[2].xy * u_xlat0.zz + u_xlat0.xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_MatrixV[3].xy * u_xlat0.ww + u_xlat0.xy;
    u_xlat2.xy = u_xlat0.yy * hlslcc_mtx4x4unity_GUIClipTextureMatrix[1].xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_GUIClipTextureMatrix[0].xy * u_xlat0.xx + u_xlat2.xy;
    vs_TEXCOORD1.xy = u_xlat0.xy + hlslcc_mtx4x4unity_GUIClipTextureMatrix[3].xy;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    vs_TEXCOORD2 = in_POSITION0;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	float _CornerRadiuses[4];
uniform 	float _BorderWidths[4];
uniform 	float _Rect[4];
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D _GUIClipTexture;
in mediump vec4 vs_COLOR0;
in highp vec2 vs_TEXCOORD0;
in highp vec2 vs_TEXCOORD1;
in highp vec4 vs_TEXCOORD2;
layout(location = 0) out mediump vec4 SV_Target0;
float u_xlat0;
bool u_xlatb0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
bvec3 u_xlatb1;
vec4 u_xlat2;
vec3 u_xlat3;
mediump float u_xlat16_5;
vec3 u_xlat6;
lowp float u_xlat10_6;
bvec3 u_xlatb6;
float u_xlat7;
bool u_xlatb7;
float u_xlat12;
bool u_xlatb12;
float u_xlat13;
ivec2 u_xlati13;
bvec2 u_xlatb13;
vec2 u_xlat15;
vec2 u_xlat16;
float u_xlat18;
float u_xlat19;
void main()
{
    u_xlat0 = _BorderWidths[0] + _BorderWidths[2];
    u_xlat0 = (-u_xlat0) + _Rect[2];
    u_xlat6.x = _BorderWidths[0] + _Rect[0];
    u_xlat0 = u_xlat0 + u_xlat6.x;
#ifdef UNITY_ADRENO_ES3
    u_xlatb6.x = !!(vs_TEXCOORD2.x>=u_xlat6.x);
#else
    u_xlatb6.x = vs_TEXCOORD2.x>=u_xlat6.x;
#endif
#ifdef UNITY_ADRENO_ES3
    u_xlatb0 = !!(u_xlat0>=vs_TEXCOORD2.x);
#else
    u_xlatb0 = u_xlat0>=vs_TEXCOORD2.x;
#endif
    u_xlatb0 = u_xlatb0 && u_xlatb6.x;
    u_xlat6.x = _BorderWidths[1] + _Rect[1];
#ifdef UNITY_ADRENO_ES3
    u_xlatb12 = !!(vs_TEXCOORD2.y>=u_xlat6.x);
#else
    u_xlatb12 = vs_TEXCOORD2.y>=u_xlat6.x;
#endif
    u_xlatb0 = u_xlatb12 && u_xlatb0;
    u_xlat12 = _BorderWidths[1] + _BorderWidths[3];
    u_xlat12 = (-u_xlat12) + _Rect[3];
    u_xlat6.x = u_xlat12 + u_xlat6.x;
#ifdef UNITY_ADRENO_ES3
    u_xlatb6.x = !!(u_xlat6.x>=vs_TEXCOORD2.y);
#else
    u_xlatb6.x = u_xlat6.x>=vs_TEXCOORD2.y;
#endif
    u_xlatb0 = u_xlatb6.x && u_xlatb0;
    u_xlat1.x = _BorderWidths[0];
    u_xlat2.x = _BorderWidths[2];
    u_xlat6.x = vs_TEXCOORD2.x + (-_Rect[0]);
    u_xlat6.x = (-_Rect[2]) * 0.5 + u_xlat6.x;
    u_xlat12 = _Rect[0] + _Rect[2];
    u_xlat18 = vs_TEXCOORD2.y + (-_Rect[1]);
    u_xlat6.z = (-_Rect[3]) * 0.5 + u_xlat18;
    u_xlatb6.xz = greaterThanEqual(vec4(0.0, 0.0, 0.0, 0.0), u_xlat6.xxzz).xz;
    u_xlati13.xy = (u_xlatb6.z) ? ivec2(0, 1) : ivec2(3, 2);
    u_xlati13.x = (u_xlatb6.x) ? u_xlati13.x : u_xlati13.y;
    u_xlat2.y = u_xlat12 + (-_CornerRadiuses[u_xlati13.x]);
    u_xlat1.y = _Rect[0] + _CornerRadiuses[u_xlati13.x];
    u_xlat2.xy = (u_xlatb6.x) ? u_xlat1.xy : u_xlat2.xy;
    u_xlat15.x = _BorderWidths[1];
    u_xlat16.x = _BorderWidths[3];
    u_xlat12 = _Rect[1] + _Rect[3];
    u_xlat16.y = u_xlat12 + (-_CornerRadiuses[u_xlati13.x]);
    u_xlat15.y = _Rect[1] + _CornerRadiuses[u_xlati13.x];
    u_xlat2.zw = (u_xlatb6.z) ? u_xlat15.xy : u_xlat16.xy;
    u_xlat1.xy = (-u_xlat2.xz) + vec2(_CornerRadiuses[u_xlati13.x]);
    u_xlat12 = u_xlat1.x / u_xlat1.y;
    u_xlat3.xy = vec2((-u_xlat2.y) + vs_TEXCOORD2.x, (-u_xlat2.w) + vs_TEXCOORD2.y);
    u_xlat3.z = u_xlat12 * u_xlat3.y;
    u_xlat12 = dot(u_xlat3.xz, u_xlat3.xz);
    u_xlat19 = dot(u_xlat3.xy, u_xlat3.xy);
    u_xlat19 = sqrt(u_xlat19);
    u_xlat13 = u_xlat19 + (-_CornerRadiuses[u_xlati13.x]);
    u_xlat12 = sqrt(u_xlat12);
    u_xlat12 = (-u_xlat1.x) + u_xlat12;
    u_xlatb1.xy = lessThan(vec4(0.0, 0.0, 0.0, 0.0), u_xlat1.xyxx).xy;
    u_xlatb1.x = u_xlatb1.y && u_xlatb1.x;
    u_xlat7 = dFdx(vs_TEXCOORD2.x);
    u_xlat7 = float(1.0) / abs(u_xlat7);
    u_xlat12 = u_xlat12 * u_xlat7 + 0.5;
#ifdef UNITY_ADRENO_ES3
    u_xlat12 = min(max(u_xlat12, 0.0), 1.0);
#else
    u_xlat12 = clamp(u_xlat12, 0.0, 1.0);
#endif
    u_xlat7 = u_xlat13 * u_xlat7 + 0.5;
#ifdef UNITY_ADRENO_ES3
    u_xlat7 = min(max(u_xlat7, 0.0), 1.0);
#else
    u_xlat7 = clamp(u_xlat7, 0.0, 1.0);
#endif
    u_xlat12 = (u_xlatb1.x) ? u_xlat12 : 1.0;
    u_xlatb1.xz = lessThan(vec4(0.0, 0.0, 0.0, 0.0), u_xlat2.xxzx).xz;
    u_xlatb1.x = u_xlatb1.z || u_xlatb1.x;
    u_xlat12 = u_xlatb1.x ? u_xlat12 : float(0.0);
    u_xlat1.x = u_xlatb1.x ? u_xlat7 : float(0.0);
#ifdef UNITY_ADRENO_ES3
    u_xlatb7 = !!(u_xlat1.x==0.0);
#else
    u_xlatb7 = u_xlat1.x==0.0;
#endif
    u_xlat1.x = (-u_xlat1.x) + 1.0;
    u_xlat12 = (u_xlatb7) ? u_xlat12 : u_xlat1.x;
    u_xlatb1.xy = greaterThanEqual(u_xlat2.ywyy, vs_TEXCOORD2.xyxx).xy;
    u_xlatb13.xy = greaterThanEqual(vs_TEXCOORD2.xyxy, u_xlat2.ywyw).xy;
    u_xlatb6.x = (u_xlatb6.x) ? u_xlatb1.x : u_xlatb13.x;
    u_xlatb6.z = (u_xlatb6.z) ? u_xlatb1.y : u_xlatb13.y;
    u_xlatb6.x = u_xlatb6.z && u_xlatb6.x;
    u_xlat12 = (u_xlatb6.x) ? u_xlat12 : 1.0;
    u_xlat10_1 = texture(_MainTex, vs_TEXCOORD0.xy);
    u_xlat1 = u_xlat10_1 * vs_COLOR0;
    u_xlat12 = u_xlat12 * u_xlat1.w;
    u_xlat0 = (u_xlatb0) ? 0.0 : u_xlat12;
    u_xlat16_5 = (u_xlatb6.x) ? u_xlat12 : u_xlat0;
#ifdef UNITY_ADRENO_ES3
    u_xlatb0 = !!(0.0<_BorderWidths[0]);
#else
    u_xlatb0 = 0.0<_BorderWidths[0];
#endif
#ifdef UNITY_ADRENO_ES3
    u_xlatb6.x = !!(0.0<_BorderWidths[1]);
#else
    u_xlatb6.x = 0.0<_BorderWidths[1];
#endif
    u_xlatb0 = u_xlatb6.x || u_xlatb0;
#ifdef UNITY_ADRENO_ES3
    u_xlatb6.x = !!(0.0<_BorderWidths[2]);
#else
    u_xlatb6.x = 0.0<_BorderWidths[2];
#endif
    u_xlatb0 = u_xlatb6.x || u_xlatb0;
#ifdef UNITY_ADRENO_ES3
    u_xlatb6.x = !!(0.0<_BorderWidths[3]);
#else
    u_xlatb6.x = 0.0<_BorderWidths[3];
#endif
    u_xlatb0 = u_xlatb6.x || u_xlatb0;
    u_xlat0 = (u_xlatb0) ? u_xlat16_5 : 1.0;
    u_xlat0 = u_xlat0 * u_xlat12;
    u_xlat10_6 = texture(_GUIClipTexture, vs_TEXCOORD1.xy).w;
    u_xlat1.w = u_xlat10_6 * u_xlat0;
    SV_Target0 = u_xlat1;
    return;
}

#endif
"
}
SubProgram "gles3 hw_tier02 " {
"#ifdef VERTEX
#version 300 es

uniform 	vec4 hlslcc_mtx4x4unity_ObjectToWorld[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixV[4];
uniform 	vec4 hlslcc_mtx4x4unity_MatrixVP[4];
uniform 	vec4 _MainTex_ST;
uniform 	vec4 hlslcc_mtx4x4unity_GUIClipTextureMatrix[4];
in highp vec4 in_POSITION0;
in mediump vec4 in_COLOR0;
in highp vec2 in_TEXCOORD0;
out mediump vec4 vs_COLOR0;
out highp vec2 vs_TEXCOORD0;
out highp vec2 vs_TEXCOORD1;
out highp vec4 vs_TEXCOORD2;
vec4 u_xlat0;
vec4 u_xlat1;
vec2 u_xlat2;
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
    vs_COLOR0 = in_COLOR0;
    u_xlat1.xy = u_xlat0.yy * hlslcc_mtx4x4unity_MatrixV[1].xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_MatrixV[0].xy * u_xlat0.xx + u_xlat1.xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_MatrixV[2].xy * u_xlat0.zz + u_xlat0.xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_MatrixV[3].xy * u_xlat0.ww + u_xlat0.xy;
    u_xlat2.xy = u_xlat0.yy * hlslcc_mtx4x4unity_GUIClipTextureMatrix[1].xy;
    u_xlat0.xy = hlslcc_mtx4x4unity_GUIClipTextureMatrix[0].xy * u_xlat0.xx + u_xlat2.xy;
    vs_TEXCOORD1.xy = u_xlat0.xy + hlslcc_mtx4x4unity_GUIClipTextureMatrix[3].xy;
    vs_TEXCOORD0.xy = in_TEXCOORD0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
    vs_TEXCOORD2 = in_POSITION0;
    return;
}

#endif
#ifdef FRAGMENT
#version 300 es

precision highp int;
uniform 	float _CornerRadiuses[4];
uniform 	float _BorderWidths[4];
uniform 	float _Rect[4];
uniform lowp sampler2D _MainTex;
uniform lowp sampler2D _GUIClipTexture;
in mediump vec4 vs_COLOR0;
in highp vec2 vs_TEXCOORD0;
in highp vec2 vs_TEXCOORD1;
in highp vec4 vs_TEXCOORD2;
layout(location = 0) out mediump vec4 SV_Target0;
float u_xlat0;
bool u_xlatb0;
vec4 u_xlat1;
lowp vec4 u_xlat10_1;
bvec3 u_xlatb1;
vec4 u_xlat2;
vec3 u_xlat3;
mediump float u_xlat16_5;
vec3 u_xlat6;
lowp float u_xlat10_6;
bvec3 u_xlatb6;
float u_xlat7;
bool u_xlatb7;
float u_xlat12;
bool u_xlatb12;
float u_xlat13;
ivec2 u_xlati13;
bvec2 u_xlatb13;
vec2 u_xlat15;
vec2 u_xlat16;
float u_xlat18;
float u_xlat19;
void main()
{
    u_xlat0 = _BorderWidths[0] + _BorderWidths[2];
    u_xlat0 = (-u_xlat0) + _Rect[2];
    u_xlat6.x = _BorderWidths[0] + _Rect[0];
    u_xlat0 = u_xlat0 + u_xlat6.x;
#ifdef UNITY_ADRENO_ES3
    u_xlatb6.x = !!(vs_TEXCOORD2.x>=u_xlat6.x);
#else
    u_xlatb6.x = vs_TEXCOORD2.x>=u_xlat6.x;
#endif
#ifdef UNITY_ADRENO_ES3
    u_xlatb0 = !!(u_xlat0>=vs_TEXCOORD2.x);
#else
    u_xlatb0 = u_xlat0>=vs_TEXCOORD2.x;
#endif
    u_xlatb0 = u_xlatb0 && u_xlatb6.x;
    u_xlat6.x = _BorderWidths[1] + _Rect[1];
#ifdef UNITY_ADRENO_ES3
    u_xlatb12 = !!(vs_TEXCOORD2.y>=u_xlat6.x);
#else
    u_xlatb12 = vs_TEXCOORD2.y>=u_xlat6.x;
#endif
    u_xlatb0 = u_xlatb12 && u_xlatb0;
    u_xlat12 = _BorderWidths[1] + _BorderWidths[3];
    u_xlat12 = (-u_xlat12) + _Rect[3];
    u_xlat6.x = u_xlat12 + u_xlat6.x;
#ifdef UNITY_ADRENO_ES3
    u_xlatb6.x = !!(u_xlat6.x>=vs_TEXCOORD2.y);
#else
    u_xlatb6.x = u_xlat6.x>=vs_TEXCOORD2.y;
#endif
    u_xlatb0 = u_xlatb6.x && u_xlatb0;
    u_xlat1.x = _BorderWidths[0];
    u_xlat2.x = _BorderWidths[2];
    u_xlat6.x = vs_TEXCOORD2.x + (-_Rect[0]);
    u_xlat6.x = (-_Rect[2]) * 0.5 + u_xlat6.x;
    u_xlat12 = _Rect[0] + _Rect[2];
    u_xlat18 = vs_TEXCOORD2.y + (-_Rect[1]);
    u_xlat6.z = (-_Rect[3]) * 0.5 + u_xlat18;
    u_xlatb6.xz = greaterThanEqual(vec4(0.0, 0.0, 0.0, 0.0), u_xlat6.xxzz).xz;
    u_xlati13.xy = (u_xlatb6.z) ? ivec2(0, 1) : ivec2(3, 2);
    u_xlati13.x = (u_xlatb6.x) ? u_xlati13.x : u_xlati13.y;
    u_xlat2.y = u_xlat12 + (-_CornerRadiuses[u_xlati13.x]);
    u_xlat1.y = _Rect[0] + _CornerRadiuses[u_xlati13.x];
    u_xlat2.xy = (u_xlatb6.x) ? u_xlat1.xy : u_xlat2.xy;
    u_xlat15.x = _BorderWidths[1];
    u_xlat16.x = _BorderWidths[3];
    u_xlat12 = _Rect[1] + _Rect[3];
    u_xlat16.y = u_xlat12 + (-_CornerRadiuses[u_xlati13.x]);
    u_xlat15.y = _Rect[1] + _CornerRadiuses[u_xlati13.x];
    u_xlat2.zw = (u_xlatb6.z) ? u_xlat15.xy : u_xlat16.xy;
    u_xlat1.xy = (-u_xlat2.xz) + vec2(_CornerRadiuses[u_xlati13.x]);
    u_xlat12 = u_xlat1.x / u_xlat1.y;
    u_xlat3.xy = vec2((-u_xlat2.y) + vs_TEXCOORD2.x, (-u_xlat2.w) + vs_TEXCOORD2.y);
    u_xlat3.z = u_xlat12 * u_xlat3.y;
    u_xlat12 = dot(u_xlat3.xz, u_xlat3.xz);
    u_xlat19 = dot(u_xlat3.xy, u_xlat3.xy);
    u_xlat19 = sqrt(u_xlat19);
    u_xlat13 = u_xlat19 + (-_CornerRadiuses[u_xlati13.x]);
    u_xlat12 = sqrt(u_xlat12);
    u_xlat12 = (-u_xlat1.x) + u_xlat12;
    u_xlatb1.xy = lessThan(vec4(0.0, 0.0, 0.0, 0.0), u_xlat1.xyxx).xy;
    u_xlatb1.x = u_xlatb1.y && u_xlatb1.x;
    u_xlat7 = dFdx(vs_TEXCOORD2.x);
    u_xlat7 = float(1.0) / abs(u_xlat7);
    u_xlat12 = u_xlat12 * u_xlat7 + 0.5;
#ifdef UNITY_ADRENO_ES3
    u_xlat12 = min(max(u_xlat12, 0.0), 1.0);
#else
    u_xlat12 = clamp(u_xlat12, 0.0, 1.0);
#endif
    u_xlat7 = u_xlat13 * u_xlat7 + 0.5;
#ifdef UNITY_ADRENO_ES3
    u_xlat7 = min(max(u_xlat7, 0.0), 1.0);
#else
    u_xlat7 = clamp(u_xlat7, 0.0, 1.0);
#endif
    u_xlat12 = (u_xlatb1.x) ? u_xlat12 : 1.0;
    u_xlatb1.xz = lessThan(vec4(0.0, 0.0, 0.0, 0.0), u_xlat2.xxzx).xz;
    u_xlatb1.x = u_xlatb1.z || u_xlatb1.x;
    u_xlat12 = u_xlatb1.x ? u_xlat12 : float(0.0);
    u_xlat1.x = u_xlatb1.x ? u_xlat7 : float(0.0);
#ifdef UNITY_ADRENO_ES3
    u_xlatb7 = !!(u_xlat1.x==0.0);
#else
    u_xlatb7 = u_xlat1.x==0.0;
#endif
    u_xlat1.x = (-u_xlat1.x) + 1.0;
    u_xlat12 = (u_xlatb7) ? u_xlat12 : u_xlat1.x;
    u_xlatb1.xy = greaterThanEqual(u_xlat2.ywyy, vs_TEXCOORD2.xyxx).xy;
    u_xlatb13.xy = greaterThanEqual(vs_TEXCOORD2.xyxy, u_xlat2.ywyw).xy;
    u_xlatb6.x = (u_xlatb6.x) ? u_xlatb1.x : u_xlatb13.x;
    u_xlatb6.z = (u_xlatb6.z) ? u_xlatb1.y : u_xlatb13.y;
    u_xlatb6.x = u_xlatb6.z && u_xlatb6.x;
    u_xlat12 = (u_xlatb6.x) ? u_xlat12 : 1.0;
    u_xlat10_1 = texture(_MainTex, vs_TEXCOORD0.xy);
    u_xlat1 = u_xlat10_1 * vs_COLOR0;
    u_xlat12 = u_xlat12 * u_xlat1.w;
    u_xlat0 = (u_xlatb0) ? 0.0 : u_xlat12;
    u_xlat16_5 = (u_xlatb6.x) ? u_xlat12 : u_xlat0;
#ifdef UNITY_ADRENO_ES3
    u_xlatb0 = !!(0.0<_BorderWidths[0]);
#else
    u_xlatb0 = 0.0<_BorderWidths[0];
#endif
#ifdef UNITY_ADRENO_ES3
    u_xlatb6.x = !!(0.0<_BorderWidths[1]);
#else
    u_xlatb6.x = 0.0<_BorderWidths[1];
#endif
    u_xlatb0 = u_xlatb6.x || u_xlatb0;
#ifdef UNITY_ADRENO_ES3
    u_xlatb6.x = !!(0.0<_BorderWidths[2]);
#else
    u_xlatb6.x = 0.0<_BorderWidths[2];
#endif
    u_xlatb0 = u_xlatb6.x || u_xlatb0;
#ifdef UNITY_ADRENO_ES3
    u_xlatb6.x = !!(0.0<_BorderWidths[3]);
#else
    u_xlatb6.x = 0.0<_BorderWidths[3];
#endif
    u_xlatb0 = u_xlatb6.x || u_xlatb0;
    u_xlat0 = (u_xlatb0) ? u_xlat16_5 : 1.0;
    u_xlat0 = u_xlat0 * u_xlat12;
    u_xlat10_6 = texture(_GUIClipTexture, vs_TEXCOORD1.xy).w;
    u_xlat1.w = u_xlat10_6 * u_xlat0;
    SV_Target0 = u_xlat1;
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
Fallback "Hidden/Internal-GUITextureClip"
}