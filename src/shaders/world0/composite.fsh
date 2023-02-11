#version 120

#define SHADOW_MAP_BIAS 0.85
#define ShadowMapping
#define ShadowSamples 4.0 //[1.0 2.0 4.0 8.0 16.0 32.0 64.0]
uniform sampler2D gcolor;
uniform sampler2D gnormal;
uniform sampler2D shadow;
uniform sampler2D depthtex0;

uniform int worldTime;

varying vec2 texcoord;
varying float extShadow;
varying vec3 lightPosition;

uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelViewInverse;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;
uniform float far;
uniform float rainStrength;
uniform float frameTimeCounter;

const int RG16 = 0;
const int gnormalFormat = RG16;
const int RGBA16       = 1;
const int gcolorFormat = RGBA16;
const float  sunPathRotation	= -40.0f;
const int shadowMapResolution = 2048; //[256 512 1024 2048]
const int noiseTextureResolution = 256;

float rand(highp vec2 coord){
    return fract(sin(dot(coord.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

vec2 rand2d(highp  vec2 coord)
{
    float x = rand(coord);
    float y = rand(coord * 10000.0);
    return vec2(x, y);
}

#ifdef ShadowMapping
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
   
    float shadowSamplesRadius = 0.001;

    for(float i = 1.0; i <= ShadowSamples; i += 1.0)
    {
        vec2 sampleCoord = rand2d(shadowposition.xy * i) - 0.5;
        float shadowDepth = texture2D(shadow, shadowposition.st + sampleCoord * shadowSamplesRadius).z;
        if(shadowDepth + 0.0003 < shadowposition.z ){
            shade += 1.0;
        }
    }
    shade /= ShadowSamples;
    
    shade -= clamp((dist - 0.7) * 5.0, 0.0, 1.0);
    shade = clamp(shade, 0.0, 1.0); 
    return max(shade, extShadow);
}
#endif
void main() {
    
vec4 color = texture2D(gcolor, texcoord.st);
#ifdef ShadowMapping
float depth = texture2D(depthtex0, texcoord.st).x;
vec4 viewPosition = gbufferProjectionInverse * vec4(texcoord.s * 2.0 - 1.0, texcoord.t * 2.0 - 1.0, 2.0 * depth - 1.0, 1.0f);
viewPosition /= viewPosition.w;
vec4 worldPosition = gbufferModelViewInverse * viewPosition;
float dist = length(worldPosition.xyz) / far;
float shade = shadowMapping(worldPosition, dist);
//color.rgb *= 1.0 - shade * 0.5;
if(12000<worldTime && worldTime<13000) {
color.rgb *=(1.0 - shade *0.5*(1.0-rainStrength*0.8)); // dusk
}
else if(13000<=worldTime && worldTime<=23000) {
color.rgb *=(1.0 - shade *0.2*(1.0-rainStrength*0.8)); // night
}
else if(23000<worldTime) {
color.rgb *=(1.0 - shade *0.5*(1.0-rainStrength*0.8)); // dawn
}
else 
color.rgb *=(1.0 - shade *0.5 *(1.0-rainStrength*0.8));
#endif
/* DRAWBUFFERS:0 */
gl_FragData[0] = color;


}
