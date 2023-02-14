#version 120

varying vec4 color;
varying vec4 texcoord;
varying vec4 lmcoord;

uniform sampler2D texture;

void main() {
	
/* DRAWBUFFERS:7 */
	
	vec4 tex = texture2D(texture, texcoord.xy)*color;
	gl_FragData[0] = tex;
}