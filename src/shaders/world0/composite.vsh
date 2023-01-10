#version 120
 
uniform vec3 sunPosition;
uniform vec3 moonPosition;
uniform int worldTime;

varying vec2 texcoord;
varying vec3 lightPosition;
varying float extShadow;
 
#define SUNRISE 23200
#define SUNSET 12800
#define FADE_START 500
#define FADE_END 250
 
void main() {
    gl_Position = ftransform();
    texcoord = gl_MultiTexCoord0.xy;
    if(worldTime >= SUNRISE - FADE_START && worldTime <= SUNRISE + FADE_START)
    {
        extShadow = 0.0;
        if(worldTime < SUNRISE - FADE_END) extShadow -= float(SUNRISE - FADE_END - worldTime) / float(FADE_END); else if(worldTime > SUNRISE + FADE_END)
            extShadow -= float(worldTime - SUNRISE - FADE_END) / float(FADE_END);
    }
    else if(worldTime >= SUNSET - FADE_START && worldTime <= SUNSET + FADE_START)
    {
        extShadow = 1.0;
        if(worldTime < SUNSET - FADE_END) extShadow -= float(SUNSET - FADE_END - worldTime) / float(FADE_END); else if(worldTime > SUNSET + FADE_END)
            extShadow -= float(worldTime - SUNSET - FADE_END) / float(FADE_END);
    }
    else
        extShadow = 0.0;
     
    if(worldTime < SUNSET || worldTime > SUNRISE)
        lightPosition = normalize(sunPosition);
    else
        lightPosition = normalize(moonPosition);
}