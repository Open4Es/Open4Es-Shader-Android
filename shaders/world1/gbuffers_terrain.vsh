#version 150

out vec2 lmcoord;
out vec2 texcoord;
out vec4 glcolor;
out vec2 uv0;
out vec2 uv1;

void main() {
	gl_Position = ftransform();
	texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	lmcoord  = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
	glcolor = gl_Color;
                uv0 = gl_MultiTexCoord0.xy; //Torch level
                uv1 = gl_MultiTexCoord1.xy; //Torch level
}