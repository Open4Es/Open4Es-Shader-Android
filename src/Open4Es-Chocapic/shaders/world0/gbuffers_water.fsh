#version 120

uniform sampler2D texture;

varying vec4 texcoord;
varying vec4 color;

/* DRAWBUFFERS:0 */
void main() {
    gl_FragData[0] = color * texture2D(texture, texcoord.st);
}