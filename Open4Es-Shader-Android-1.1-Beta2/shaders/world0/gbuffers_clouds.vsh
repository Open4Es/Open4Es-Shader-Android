#version 120

uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform vec3 sunPosition;
uniform vec3 cameraPosition;

varying vec2 texcoord;
varying vec3 cPos;
varying vec3 wPos;
varying vec4 glcolor;

void main(){
gl_Position=ftransform();
texcoord=(gl_TextureMatrix[0]*gl_MultiTexCoord0).xy;
glcolor=gl_Color;
vec4 pos=gbufferModelViewInverse*gl_ModelViewMatrix*gl_Vertex;
cPos=pos.xyz+cameraPosition;
wPos=pos.xyz;
gl_Position=gl_ProjectionMatrix*gbufferModelView*pos;
}