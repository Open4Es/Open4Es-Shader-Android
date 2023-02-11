#version 150
#extension GL_ARB_explicit_attrib_location : enable

uniform sampler2D gtexture;

in vec2 texcoord;
in vec4 tint;

/* DRAWBUFFERS:0 */
out vec4 colortex0Out;

void main() {
	vec4 color = texture(gtexture, texcoord) * tint;

	colortex0Out = color;
}