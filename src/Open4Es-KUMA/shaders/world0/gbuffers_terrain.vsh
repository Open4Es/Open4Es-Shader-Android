#version 120

#define WavingPlants
#define WavingLeaves
#define WavingPlantsSpeed 0.2 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]
#define WavingLeavesSpeed 0.07 //[0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2]

varying vec4 color;
varying vec4 texcoord;
varying vec4 lmcoord;
uniform float frameTimeCounter;
uniform sampler2D noisetex;
attribute vec4 mc_Entity;
uniform float rainStrength;
attribute vec4 mc_midTexCoord;

void main(){
    vec4 position = gl_Vertex;
    #ifdef WavingPlants
    if((mc_Entity.x == 31.0 || mc_Entity.x == 37.0 || mc_Entity.x == 38.0) && gl_MultiTexCoord0.t < mc_midTexCoord.t)
{
    vec3 noise = texture2D(noisetex, position.xz / 256.0).rgb;
    float maxStrength = 1.0 + rainStrength * 0.5;
    float time = frameTimeCounter * 3.0;
    float reset = cos(noise.z * 10.0 + time * 0.1);
    reset = max( reset * reset, max(rainStrength, 0.1));
    position.x += sin(noise.x * 10.0 + time) * WavingPlantsSpeed * reset * maxStrength;
    position.z += sin(noise.y * 10.0 + time) * WavingPlantsSpeed * reset * maxStrength;
}
#endif
#ifdef WavingLeaves
if(mc_Entity.x == 18.0 || mc_Entity.x == 106.0 || mc_Entity.x == 161.0 || mc_Entity.x == 175.0) 
{
    vec3 noise = texture2D(noisetex, (position.xz + 0.5) / 16.0).rgb;
    float maxStrength = 1.0 + rainStrength * 0.5;
    float time = frameTimeCounter * 3.0;
    float reset = cos(noise.z * 10.0 + time * 0.1);
    reset = max( reset * reset, max(rainStrength, 0.1));
    position.x += sin(noise.x * 10.0 + time) * WavingLeavesSpeed * reset * maxStrength;
    position.z += sin(noise.y * 10.0 + time) * WavingLeavesSpeed * reset * maxStrength;
}
#endif
    position = gl_ModelViewMatrix * position;
	gl_Position = gl_ProjectionMatrix * position;
	gl_FogFragCoord = length(position.xyz);
	color = gl_Color;
	texcoord = gl_TextureMatrix[0] * gl_MultiTexCoord0;
	lmcoord = gl_TextureMatrix[1] * gl_MultiTexCoord1;
}