#version 120

#define SHADOW_MAP_BIAS 0.85
uniform sampler2D gcolor;
uniform sampler2D shadow;
uniform sampler2D colortex0;
uniform sampler2D depthtex0;
uniform sampler2D texture;
uniform sampler2D lightmap;
uniform float rainStrength;
uniform int worldTime;
varying float lighting;

varying vec2 lmcoord;
varying vec2 texcoord;
varying vec2 uv0;
varying vec2 uv1;
varying float extShadow;
varying vec3 lightPosition;

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;
uniform float far;

const int RG16 = 0;
const int gnormalFormat = RG16;
const int RGBA16       = 1;
const int gcolorFormat = RGBA16;
const float  sunPathRotation	= -40.0f;
const int shadowMapResolution = 4096;
const int noiseTextureResolution = 256;

float shadowMapping(vec4 worldPosition, float dist) {
    if(dist > 0.9) //distance
        return extShadow;
    float shade = 0.0;
    vec4 shadowposition = shadowModelView * worldPosition;
    shadowposition = shadowProjection * shadowposition;
    float distb = sqrt(shadowposition.x * shadowposition.x + shadowposition.y * shadowposition.y);
    float distortFactor = (1.0 - SHADOW_MAP_BIAS) + distb * SHADOW_MAP_BIAS;
    shadowposition.xy /= distortFactor;
    shadowposition /= shadowposition.w;
    shadowposition = shadowposition * 0.5 + 0.5;
    float shadowDepth = texture2D(shadow, shadowposition.st).z;
    if(shadowDepth + 0.0001 < shadowposition.z){
    shade = 1.0;}
    shade -= clamp((dist - 0.7) * 5.0, 0.0, 1.0);
    shade = clamp(shade, 0.0, 1.0); 
    return max(shade, extShadow);
}

void main() {
    
vec4 color = texture2D(gcolor, texcoord.st);
float depth = texture2D(depthtex0, texcoord.st).x;
vec4 viewPosition = gbufferProjectionInverse * vec4(texcoord.s * 2.0 - 1.0, texcoord.t * 2.0 - 1.0, 2.0 * depth - 1.0, 1.0f);
viewPosition /= viewPosition.w;
vec4 worldPosition = gbufferModelViewInverse * viewPosition;
float dist = length(worldPosition.xyz) / far;
float shade = shadowMapping(worldPosition, dist);
if(12000<worldTime && worldTime<13000) {
color.rgb *=(1.0 - shade *0.4*(1.0-rainStrength*0.8)*(1.0-lmcoord.x*0.4)); // dusk
}
else if(13000<=worldTime && worldTime<=23000) {
color.rgb *=(1.0 - shade *0.05*(1.0-rainStrength*0.8)*(1.0-lmcoord.x*0.4)); // night
}
else if(23000<worldTime) {
color.rgb *=(1.0 - shade *0.4*(1.0-rainStrength*0.8)*(1.0-lmcoord.x*0.4)); // dawn
}
else 
color.rgb *=(1.0 - shade *0.5 *(1.0-rainStrength*0.8)*(1.0-lmcoord.x*0.5));

/* DRAWBUFFERS:0 */
gl_FragData[0] = color;


}
