#version 150
#extension GL_ARB_explicit_attrib_location : enable

#define torchColor vec3(1.5, 0.42 , 0.045) *4.0

uniform float alphaTestRef;
uniform sampler2D gtexture;
uniform sampler2D lightmap;

in vec2 lmcoord;
in vec2 texcoord;
in vec4 tint;
in vec2 uv0;
in vec2 uv1;

/* DRAWBUFFERS:0 */
out vec4 colortex0Out;

void main() {
	vec4 color = texture(gtexture, texcoord) * tint;
	if (color.a < alphaTestRef) discard;
	color *= texture(lightmap, lmcoord);
	color.rgb += (uv1.x * 0.0002 * torchColor);

	colortex0Out = color;
}