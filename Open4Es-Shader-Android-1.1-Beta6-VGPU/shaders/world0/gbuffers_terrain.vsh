#version 120
#define WavingPlants
#define WavingLeaves
#define WavingPlantsSpeed 0.2 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]
#define WavingLeavesSpeed 0.07 //[0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2]

attribute vec4 mc_Entity;
attribute vec4 mc_midTexCoord;

uniform sampler2D noisetex;

uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjection;
uniform mat4 gbufferProjectionInverse;

uniform float frameTimeCounter;
uniform float rainStrength;

varying vec2 lmcoord;
varying vec2 texcoord;
varying vec4 glcolor;
varying vec3 wPos;
varying vec2 uv0;
varying vec2 uv1;
varying float isOre;
varying float flag1;
varying float flag2;
varying float flag3;
varying float flag4;
varying float flag5;
varying float flag6;
varying float flag7;
varying vec4 positionInViewCoord;

void main(){
    positionInViewCoord = gl_ModelViewMatrix * gl_Vertex;
    gl_Position = gbufferProjection * positionInViewCoord;
    vec4 position = gl_Vertex;
    vec4 pos=gbufferModelViewInverse*gl_ModelViewMatrix*gl_Vertex;
    #ifdef WavingPlants
    if((mc_Entity.x == 31.0 || mc_Entity.x == 141.0 || mc_Entity.x == 142.0 || mc_Entity.x == 59.0 || mc_Entity.x == 127.0|| mc_Entity.x == 32.0 || mc_Entity.x == 37.0 || mc_Entity.x == 38.0 || mc_Entity.x == 115.0 || mc_Entity.x == 6.0 || mc_Entity.x == 39.0 ||
mc_Entity.x == 40.0 || mc_Entity.x == 104.0 || mc_Entity.x == 105.0) && gl_MultiTexCoord0.t < mc_midTexCoord.t)
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
	flag1 = 0.0;
    flag2 = 0.0;
    flag3 = 0.0;
    flag4 = 0.0;
    flag5 = 0.0;
    flag6 = 0.0;
    flag7 = 0.0;
	glcolor = gl_Color;
	texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	lmcoord  = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    uv0 = gl_MultiTexCoord0.xy; //Torch level
    uv1 = gl_MultiTexCoord1.xy; //Torch level
    wPos=pos.xyz;
    //if(mc_Entity.x == 56.0||mc_Entity.x == 73.0||mc_Entity.x == 129.0||mc_Entity.x == 14.0||mc_Entity.x == 15.0||mc_Entity.x == 21.0||mc_Entity.x == 79.0)isOre=1.0;
if(mc_Entity.x == 56.0){
 flag1 = 1.0;
}
if(mc_Entity.x == 73.0){
 flag2 = 1.0;
}
if(mc_Entity.x == 129.0){
 flag3 = 1.0;
}
if(mc_Entity.x == 14.0){
 flag4 = 1.0;
}
if(mc_Entity.x == 15.0){
 flag5 = 1.0;
}
if(mc_Entity.x == 21.0){
 flag6 = 1.0;
}
if(mc_Entity.x == 74.0){
 flag7 = 1.0;
}
}