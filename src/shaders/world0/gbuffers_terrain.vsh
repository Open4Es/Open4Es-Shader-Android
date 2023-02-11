#version 150

#define WavingPlants
#define WavingLeaves
#define WavingPlantsSpeed 0.2 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0]
#define WavingLeavesSpeed 0.07 //[0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2]

uniform mat4 modelViewMatrix;
uniform mat4 modelViewMatrixInverse;
uniform mat4 projectionMatrix;
uniform mat4 projectionMatrixInverse;
//uniform mat4 textureMatrix = mat4(1.0);
uniform mat4 textureMatrix;
uniform vec3 chunkOffset;

uniform sampler2D noisetex;

uniform float frameTimeCounter;
uniform float rainStrength;

in ivec2 vaUV2;
in vec2 vaUV0;
in vec3 vaPosition;
in vec4 vaColor;
in vec3 mc_Entity;
in vec2 mc_midTexCoord;

out vec2 lmcoord;
out vec2 texcoord;
out vec4 tint;
out vec2 uv0;
out vec2 uv1;

void main() {
    vec3 position = vaPosition;
    gl_Position = projectionMatrix * (modelViewMatrix * vec4(vaPosition + chunkOffset, 1.0));
    texcoord = (textureMatrix * vec4(vaUV0, 0.0, 1.0)).xy;
	lmcoord = vaUV2 * (1.0 / 256.0) + (1.0 / 32.0);
	tint = vaColor;
    uv0 = vaUV0.xy;
    uv1 = vaUV2.xy;
#ifdef WavingPlants
if((mc_Entity.x == 31.0 || mc_Entity.x == 141.0 || mc_Entity.x == 142.0 || mc_Entity.x == 59.0 || mc_Entity.x == 127.0|| mc_Entity.x == 32.0 || mc_Entity.x == 37.0 || mc_Entity.x == 38.0 || mc_Entity.x == 115.0 || mc_Entity.x == 6.0 || mc_Entity.x == 39.0 ||
mc_Entity.x == 40.0 || mc_Entity.x == 104.0 || mc_Entity.x == 105.0) && vaUV0.t < mc_midTexCoord.t)
{
    vec3 noise = texture(noisetex, position.xz / 256.0).rgb;
    float maxStrength = 1.0 + rainStrength * 0.5;
    float time = frameTimeCounter * 3.0;
    float reset = cos(noise.z * 10.0 + time * 0.1);
    reset = max( reset * reset, max(rainStrength, 0.1));
    gl_Position.x += sin(noise.x * 10.0 + time) * WavingPlantsSpeed * reset * maxStrength;
    //gl_Position.z += sin(noise.z * 10.0 + time) * WavingPlantsSpeed * reset * maxStrength;
}
#endif
#ifdef WavingLeaves
if(mc_Entity.x == 18.0 || mc_Entity.x == 106.0 || mc_Entity.x == 161.0 || mc_Entity.x == 175.0) 
{
    vec3 noise = texture(noisetex, (position.xz + 0.5) / 16.0).rgb;
    float maxStrength = 1.0 + rainStrength * 0.5;
    float time = frameTimeCounter * 3.0;
    float reset = cos(noise.z * 10.0 + time * 0.1);
    reset = max( reset * reset, max(rainStrength, 0.1));
    gl_Position.x += sin(noise.x * 10.0 + time) * WavingLeavesSpeed * reset * maxStrength;
    //gl_Position.z += sin(noise.z * 10.0 + time) * WavingLeavesSpeed * reset * maxStrength;
}
#endif
}