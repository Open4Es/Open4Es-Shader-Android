#version 150
#extension GL_ARB_explicit_attrib_location : enable

uniform float alphaTestRef;
uniform int renderStage;
uniform sampler2D lightmap;

in vec2 lmcoord;
in vec4 tint;

/* DRAWBUFFERS:0 */
out vec4 colortex0Out;

void main() {
	vec4 color = tint;
	if (color.a < alphaTestRef) discard;
	//leads have light levels, but chunk borders don't.
	//and for whatever reason, chunk borders use gbuffers_basic
	//instead of gbuffers_lines, so we detect them with renderStage.
	if (renderStage != MC_RENDER_STAGE_DEBUG) {
		color *= texture(lightmap, lmcoord);
	}

	colortex0Out = color;
}