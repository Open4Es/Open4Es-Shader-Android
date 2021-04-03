#version 120

varying vec4 color;
varying vec4 texcoord;
varying float entityType;
attribute vec4 mc_Entity;


void main() {
                vec4 position = gl_ModelViewMatrix * gl_Vertex;
                gl_Position = gl_ProjectionMatrix * position;
	gl_FogFragCoord = length(position.xyz);
	color = gl_Color;
	texcoord = gl_TextureMatrix[0] * gl_MultiTexCoord0;
    entityType = mc_Entity.x;
}