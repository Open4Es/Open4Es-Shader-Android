#version 120

varying vec4 color;
 
void main() {

	gl_Position = ftransform();
	color = gl_Color;
}