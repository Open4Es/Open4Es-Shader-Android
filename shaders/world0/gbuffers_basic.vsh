#version 150

uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;

in ivec2 vaUV2;
in vec3 vaPosition;
in vec4 vaColor;

out vec2 lmcoord;
out vec4 tint;

void main() {
	gl_Position = projectionMatrix * (modelViewMatrix * vec4(vaPosition, 1.0));
	lmcoord     = vaUV2 * (1.0 / 256.0) + (1.0 / 32.0);
	tint        = vaColor;
}