#version 120

varying vec4 color;


void main() {
	vec4 position = gl_ModelViewMatrix * gl_Vertex;
	gl_Position = gl_ProjectionMatrix * position;
	gl_FogFragCoord = length(position.xyz);
	color = gl_Color;
}