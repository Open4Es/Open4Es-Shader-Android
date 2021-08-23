#version 120

uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform vec3 sunPosition;
uniform vec3 cameraPosition;

varying vec3 cPos;//Chunked Position
varying vec3 wPos;//World Position
varying vec3 glnormal;
varying vec4 starData;

void main(){
gl_Position=ftransform();
glnormal=gl_Normal;
starData=vec4(gl_Color.rgb,float(gl_Color.r==gl_Color.g&&gl_Color.g==gl_Color.b&&gl_Color.r>.0));

vec4 pos=gbufferModelViewInverse*gl_ModelViewMatrix*gl_Vertex;
cPos=pos.xyz+cameraPosition;
wPos=pos.xyz;
pos.y-=length(wPos.xz)*.2;
gl_Position=gl_ProjectionMatrix*gbufferModelView*pos;
}