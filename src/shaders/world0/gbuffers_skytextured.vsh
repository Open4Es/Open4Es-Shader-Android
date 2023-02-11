#version 150

uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
//uniform mat4 textureMatrix = mat4(1.0);
uniform mat4 textureMatrix;

in vec2 vaUV0;
in vec3 vaPosition;
in vec4 vaColor;

out vec2 texcoord;
out vec4 tint;

void main() {
	gl_Position = projectionMatrix * (modelViewMatrix * vec4(vaPosition, 1.0));
	texcoord    = (textureMatrix * vec4(vaUV0, 0.0, 1.0)).xy;
	tint        = vaColor;
}