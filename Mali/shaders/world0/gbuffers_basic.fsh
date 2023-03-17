#version 120

varying vec4 color;
 
/* DRAWBUFFERS:0 */
void main() {
	gl_FragData[0] = color;

}