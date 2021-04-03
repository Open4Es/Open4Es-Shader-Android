#version 120

varying vec4 color;
varying vec4 texcoord;

void main() {
	gl_Position = ftransform();
	color = gl_Color;
	texcoord = gl_TextureMatrix[0] * gl_MultiTexCoord0;
}