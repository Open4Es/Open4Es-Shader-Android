#version 120

uniform sampler2D gcolor;

varying vec2 texcoord;

void main() {
	vec3 color = texture2D(gcolor, texcoord).rgb;

/* DRAWBUFFERS:0 */
	gl_FragData[0] = vec4(color, 1.0); //gcolor
}