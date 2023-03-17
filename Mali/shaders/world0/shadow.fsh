#version 120
 
uniform sampler2D texture;
 
varying vec4 texcoord;
 
void main() {
    gl_FragData[0] = texture2D(texture, texcoord.st);
}