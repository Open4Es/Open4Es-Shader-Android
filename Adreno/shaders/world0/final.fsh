#version 120

#define INFO
#define Red 1.5 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3.0 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4.0 4.1 4.2 4.3 4.4 4.5 4.6 4.7 4.8 4.9 5.0]
#define Green 1.2 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3.0 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4.0 4.1 4.2 4.3 4.4 4.5 4.6 4.7 4.8 4.9 5.0]
#define Blue 1.1 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3.0 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4.0 4.1 4.2 4.3 4.4 4.5 4.6 4.7 4.8 4.9 5.0]
#define Brightness 1.0 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3.0 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4.0 4.1 4.2 4.3 4.4 4.5 4.6 4.7 4.8 4.9 5.0]
//#define Bloom
#define BloomQuality 1.0 //[1.0 2.0 3.0 4.0]
//#define ChromaticAberration
#define ChromaticAberrationQuality 1.0 //[1.0 2.0 4.0 8.0]
#define Lensflare

#define MANHATTAN_DISTANCE(DELTA) abs(DELTA.x)+abs(DELTA.y)

#define LENS_FLARE(COLOR, UV, LFPOS, LFSIZE, LFCOLOR) { \
                vec2 delta = UV - LFPOS; delta.x *= aspectRatio; \
                if(MANHATTAN_DISTANCE(delta) < LFSIZE * 2.0) { \
                    float d = max(LFSIZE - sqrt(dot(delta, delta)), 0.0); \
                    COLOR += LFCOLOR.rgb * LFCOLOR.a * smoothstep(0.0, LFSIZE, d) * sunVisibility;\
                } }
 
#define LF1SIZE 0.4
#define LF2SIZE 0.6
#define LF3SIZE 0.5
#define LF4SIZE 0.7
#define LF5SIZE 0.4
#define LF6SIZE 0.5
#define LF7SIZE 0.02
#define LF8SIZE 0.01
#define LF9SIZE 0.03
#define LF10SIZE 0.05
#define LF11SIZE 0.01
#define LF12SIZE 0.1
#define LF13SIZE 0.1

uniform sampler2D gcolor;
uniform sampler2D gaux1;//colortex4
uniform sampler2D depthtex0;

uniform float rainStrength;
uniform float aspectRatio;

uniform mat4 gbufferProjection;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferPreviousProjection;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferPreviousModelView;

uniform vec3 cameraPosition;
uniform vec3 previousCameraPosition;

uniform int worldTime;

varying vec2 texcoord;
varying float sunVisibility;
varying vec2 lf1Pos;
varying vec2 lf2Pos;
varying vec2 lf3Pos;
varying vec2 lf4Pos;
varying vec2 lf5Pos;
varying vec2 lf6Pos; 
varying vec2 lf7Pos;
varying vec2 lf8Pos;
varying vec2 lf9Pos;
varying vec2 lf10Pos;
varying vec2 lf11Pos;
varying vec2 lf12Pos;
varying vec2 lf13Pos;

const vec4 LF1COLOR = vec4(1.0, 1.0, 0.9, 0.15);
const vec4 LF2COLOR = vec4(0.9, 1.0, 0.7, 0.15);
const vec4 LF3COLOR = vec4(1.0, 0.7, 0.0, 0.15);
const vec4 LF4COLOR = vec4(0.9, 0.1, 0.0, 0.15);
const vec4 LF5COLOR = vec4(0.2, 0.06, 0.6, 0.4);
const vec4 LF6COLOR = vec4(0.4, 0.03, 1.0, 0.2);
const vec4 LF7COLOR = vec4(0.4, 0.9, 0.9, 1.0);
const vec4 LF8COLOR = vec4(0.4, 0.4, 1.0, 1.0);
const vec4 LF9COLOR = vec4(0.3, 0.4, 1.0, 1.0);
const vec4 LF10COLOR = vec4(1.5, 0.85, 0.45, 0.3);
const vec4 LF11COLOR = vec4(1.3, 0.8, 0.4, 0.5);
const vec4 LF12COLOR = vec4(1.3, 1.0, 1.0, 0.4);
const vec4 LF13COLOR = vec4(1.0, 1.0, 1.0, 0.1);

 
float A = 0.2;
float B = 0.50;
float C = 0.10 ;
float D = 0.20;
float E = 0.02;
float F = 0.30;
float W = 13.134;
 
vec3 uncharted2Tonemap(vec3 x) {
    return ((x*(A*x+C*B)+D*E)/(x*(A*x+B)+D*F))-E/F;
}

#ifdef Lensflare
vec3 lensFlare(vec3 color, vec2 uv) {
    if(sunVisibility <= 0.0 || rainStrength >= 0.3)
    return color;
    LENS_FLARE(color, uv, lf1Pos, LF1SIZE, LF1COLOR);
    LENS_FLARE(color, uv, lf2Pos, LF2SIZE, LF2COLOR);
    LENS_FLARE(color, uv, lf3Pos, LF3SIZE, LF3COLOR);
    LENS_FLARE(color, uv, lf4Pos, LF4SIZE, LF4COLOR);
    LENS_FLARE(color, uv, lf5Pos, LF5SIZE, LF5COLOR);
    LENS_FLARE(color, uv, lf6Pos, LF6SIZE, LF6COLOR);
    LENS_FLARE(color, uv, lf7Pos, LF7SIZE, LF7COLOR);
    LENS_FLARE(color, uv, lf8Pos, LF8SIZE, LF8COLOR);
    LENS_FLARE(color, uv, lf9Pos, LF9SIZE, LF9COLOR);
    LENS_FLARE(color, uv, lf10Pos, LF10SIZE, LF10COLOR);
    LENS_FLARE(color, uv, lf11Pos, LF11SIZE, LF11COLOR);
    LENS_FLARE(color, uv, lf12Pos, LF12SIZE, LF12COLOR);
    LENS_FLARE(color, uv, lf13Pos, LF13SIZE, LF13COLOR);
    return color;
}
#endif

float rand(highp vec2 coord){
    return fract(sin(dot(coord.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

vec2 rand2d(highp  vec2 coord)
{
    float x = rand(coord);
    float y = rand(coord * 10000.0);
    return vec2(x, y);
}


vec3 bloom()
{
    float bloomSteps = 4.0;
    float bloomRadius = 0.02;
    float bloomThreshold = 1.0;
    float bloomIntancity = 1.0;

    vec4 bloomTexture = vec4(0.0);

    float totalSteps = 0.0;
    for(float n = 1.0; n <= BloomQuality; n += 1.0)
    {
        for(float i = 1.0; i <= bloomSteps * n; i += 1.0){
            totalSteps += 1.0;
            vec2 stepCoord = vec2(sin(i * 6.0 / bloomSteps), cos(i * 6.0 / bloomSteps)) * bloomRadius * vec2(1.0, aspectRatio) * n;
            vec2 jitterCoord = (rand2d(texcoord.xy) - 0.5) * bloomRadius;
            bloomTexture += texture2D(gcolor, texcoord.xy + stepCoord + jitterCoord);
        }
    }
    bloomTexture /= totalSteps;


    float brightness = (bloomTexture.r + bloomTexture.g + bloomTexture.b) / 3.0;
    brightness = pow(brightness, bloomThreshold);
    bloomTexture *= bloomIntancity * brightness;

    return bloomTexture.rgb;
}

vec3 chromaticAberration()
{
    float distortion = 0.1;
    float edge = 4.0;

    float mask = length(texcoord.xy - 0.5);
    mask = pow(mask, edge);

    vec3 result = vec3(0.0);

    for(float i = 1.0; i <= ChromaticAberrationQuality; i += 1.0 ){
        vec2 dir = normalize(texcoord.xy - 0.5);
        result.r += texture2D(gcolor, texcoord.xy - (dir * (i/ChromaticAberrationQuality) * distortion * mask)).r;
        result.g += texture2D(gcolor, texcoord.xy - (dir * (i/ChromaticAberrationQuality) * 0.66 * distortion * mask)).g;
        result.b += texture2D(gcolor, texcoord.xy - (dir * (i/ChromaticAberrationQuality) * 0.33 * distortion * mask)).b;
    }

    result /= ChromaticAberrationQuality;

    return result;
}

void main() {

    #ifdef ChromaticAberration
    vec3 color = chromaticAberration();
    #else
    vec3 color = texture2D(gcolor, texcoord.st).rgb;	
    #endif

    color.r = (color.r*Red)+(color.b+color.g)*(-0.1);
    color.g = (color.g*Green)+(color.r+color.b)*(-0.1);
    color.b = (color.b*Blue)+(color.r+color.g)*(-0.1);

    #ifdef Lensflare
        color = lensFlare(color, texcoord.st);
    #endif

    #ifdef Bloom
        color.rgb += bloom();
    #endif
 
    color = pow(color, vec3(1.4));
    if(12000<worldTime && worldTime<13000) {
        color *= 15.0 * Brightness * 0.8 *(1.0-rainStrength*0.4); // dusk
    }
    else if(13000<=worldTime && worldTime<=23000) {
        color *= 15.0 * Brightness * 0.3; // night
    }
    else if(23000<worldTime) {
        color *= 15.0 * Brightness * 0.8 *(1.0-rainStrength*0.4); // dawn
    }
    else 
        color *= 15.0 * Brightness * 0.8 *(1.0-rainStrength*0.7);
    vec3 curr = uncharted2Tonemap(color);  
    vec3 whiteScale = 1.0f/uncharted2Tonemap(vec3(W));
    color = curr*whiteScale;
    gl_FragColor = vec4(color,1.0f);	
}
