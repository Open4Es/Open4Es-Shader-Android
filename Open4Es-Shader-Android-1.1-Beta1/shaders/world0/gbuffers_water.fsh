#version 120

#define WaterColor vec3(0.0, 0.7, 1.0)
uniform sampler2D texture;
uniform sampler2D lightmap;
uniform sampler2D noisetex;
uniform vec3 cameraPosition;
uniform mat4 gbufferModelViewInverse;
uniform int worldTime;
uniform float frameTimeCounter;
varying vec2 lmcoord;
varying vec2 texcoord;
varying vec4 glcolor;
varying vec3 cPos;
varying vec3 wPos;
varying float waterHeight;
varying vec2 uv1;
varying float waterFlag;
varying vec3 normal;
varying vec4 positionInViewCoord;
const int noiseTextureResolution = 128;

vec3 getWave(vec3 color, vec4 positionInWorldCoord) {

    // wave
    float speed1 = float(worldTime) / 1920.0;
    vec3 coord1 = positionInWorldCoord.xyz / 128.0;
    coord1.x += speed1;
    coord1.z += speed1 * 0.2;
    float noise1 = texture2D(noisetex, coord1.xz).x;

    // mix
    float speed2 = float(worldTime) / 896.0;
    vec3 coord2 = positionInWorldCoord.xyz / 128.0;
    coord2.x -= speed2 * 0.15 + noise1 * 0.05;  // wave
    coord2.z -= speed2 * 0.7 - noise1 * 0.05;
    float noise2 = texture2D(noisetex, coord2.xz).x;

    color *= noise2 * 0.6 + 0.4;

    return color;
}

void main() {
    vec4 positionInWorldCoord = gbufferModelViewInverse * positionInViewCoord;
    positionInWorldCoord.xyz += cameraPosition;
    vec3 finalColor = WaterColor;
    finalColor = getWave(WaterColor, positionInWorldCoord);
    float cosine = dot(normalize(positionInViewCoord.xyz), normalize(normal));
    cosine = clamp(abs(cosine), 0, 1);
    float factor = pow(1.0 - cosine, 4);
	vec4 color = texture2D(texture, texcoord) * glcolor;
	color *= texture2D(lightmap, lmcoord);
    if(waterFlag >= 0.5){
    gl_FragData[0] = vec4(mix(WaterColor*0.3,finalColor,factor),0.75); //Color
    return;
    }
/* DRAWBUFFERS:0 */
	gl_FragData[0] = color; //gcolor
}