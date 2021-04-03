#version 120

#define SHADOW_MAP_BIAS 0.85
#define ShadowMapping
uniform sampler2D gcolor;
uniform sampler2D gnormal;
uniform sampler2D shadow;
uniform sampler2D depthtex0;

varying vec4 texcoord;
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
const int shadowMapResolution = 2048;
const int noiseTextureResolution = 256;

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
    float shadowDepth = texture2D(shadow, shadowposition.st).z;
    if(shadowDepth + 0.0005 < shadowposition.z){
    shade = 1.0;}
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
color.rgb *= 1.0 - shade * 0.5;
#endif
/* DRAWBUFFERS:0 */
gl_FragData[0] = color;


}
