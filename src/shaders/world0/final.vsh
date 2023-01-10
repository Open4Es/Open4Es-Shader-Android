#version 120

varying vec2 texcoord;
uniform float viewWidth;
uniform float viewHeight;
uniform vec3 sunPosition;
uniform mat4 gbufferProjection;
uniform sampler2D depthtex0;
 
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
 
#define LF1POS -00000001.00000001
#define LF2POS -00000001.00000001
#define LF3POS -00000001.00000001
#define LF4POS -00000001.00000001
#define LF5POS 0.99
#define LF6POS 0.49
#define LF7POS 0.39
#define LF8POS 0.45
#define LF9POS 0.20
#define LF10POS -0.10
#define LF11POS -0.19
#define LF12POS 0.20
#define LF13POS 0.40

void main() {
    gl_Position = ftransform();	
    texcoord = gl_MultiTexCoord0.st;
    vec4 ndcSunPosition = gbufferProjection * vec4(normalize(sunPosition), 1.0);
ndcSunPosition /= ndcSunPosition.w;
    vec2 pixelSize = vec2(1.0 / viewWidth, 1.0 / viewHeight);   
    sunVisibility = 0.0f;
    vec2 screenSunPosition = vec2(-10.0);
lf1Pos = lf2Pos = lf3Pos = lf4Pos = vec2(-10.0);
    if(ndcSunPosition.x >= -1.0 && ndcSunPosition.x <= 1.0 &&
    ndcSunPosition.y >= -1.0 && ndcSunPosition.y <= 1.0 &&
    ndcSunPosition.z >= -1.0 && ndcSunPosition.z <= 1.0)
{
    screenSunPosition = ndcSunPosition.xy * 0.5 + 0.5;
    for(int x = -4; x <= 4; x++)
    {
        for(int y = -4; y <= 4; y++)
        {
            float depth = texture2DLod(depthtex0, screenSunPosition.st + vec2(float(x), float(y)) * pixelSize, 0.0).r;
            if(depth > 0.9999)
                sunVisibility += 1.0 / 81.0;
        }
    }
    float shortestDis = min( min(screenSunPosition.s, 1.0 - screenSunPosition.s),
                             min(screenSunPosition.t, 1.0 - screenSunPosition.t));
    sunVisibility *= smoothstep(0.0, 0.2, clamp(shortestDis, 0.0, 0.2));
     
    vec2 dir = vec2(0.5) - screenSunPosition;
    lf1Pos = vec2(0.5) + dir * LF1POS;
    lf2Pos = vec2(0.5) + dir * LF2POS;
    lf3Pos = vec2(0.5) + dir * LF3POS;
    lf4Pos = vec2(0.5) + dir * LF4POS;
    lf5Pos = vec2(0.5) + dir * LF5POS;
    lf6Pos = vec2(0.5) + dir * LF6POS;
    lf7Pos = vec2(0.5) + dir * LF7POS;
    lf8Pos = vec2(0.5) + dir * LF8POS;
    lf9Pos = vec2(0.5) + dir * LF9POS;
    lf10Pos = vec2(0.5) + dir * LF10POS;
    lf11Pos = vec2(0.5) + dir * LF11POS;
    lf12Pos = vec2(0.5) + dir * LF12POS;
    lf13Pos = vec2(0.5) + dir * LF13POS;

    }
}