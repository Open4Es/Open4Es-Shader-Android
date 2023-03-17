#version 120

//#define VANILLA_CLOUDS
uniform sampler2D texture;
uniform float far;
uniform vec3 fogColor;
uniform vec3 skyColor;

varying vec2 texcoord;
varying vec3 cPos;
varying vec3 wPos;
varying vec4 glcolor;

/* DRAWBUFFERS:0 */
void main(){
#ifdef VANILLA_CLOUDS
vec4 color=texture2D(texture,texcoord)*glcolor;
diffuse.rgb=mix(diffuse.rgb,fogColor,smoothstep(0.,far,length(wPos.xz)));
gl_FragData[0]=color;
#else
discard;
#endif
}