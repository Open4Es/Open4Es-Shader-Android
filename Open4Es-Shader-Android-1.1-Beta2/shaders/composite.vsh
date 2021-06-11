#version 120
 
uniform vec3 sunPosition;
uniform vec3 moonPosition;
uniform int worldTime;
varying float lighting;
 
varying vec3 lightPosition;
varying float extShadow;
varying vec2 lmcoord;
varying vec2 texcoord;
varying vec2 uv0;
varying vec2 uv1;
 
#define SUNRISE 23200
#define SUNSET 12800
#define FADE_START 500
#define FADE_END 250
 
void main() {
    gl_Position = ftransform();
    texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
	lmcoord  = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    uv0 = gl_MultiTexCoord0.xy; //Torch level
    uv1 = gl_MultiTexCoord1.xy; //Torch level
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