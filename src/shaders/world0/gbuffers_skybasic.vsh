#version 150

uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;

in vec3 vaPosition;
in vec4 vaColor;

out vec4 starData; //rgb = star color, a = flag for weather or not this pixel is a star.

void main() {
	gl_Position = projectionMatrix * (modelViewMatrix * vec4(vaPosition, 1.0));
	starData    = vec4(vaColor.rgb, float(vaColor.r == vaColor.g && vaColor.g == vaColor.b && vaColor.r > 0.0));
}