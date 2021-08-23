#version 120
#define saturate(x) clamp(x,0.0,1.0)
#define lightColor vec3(1.5, 0.42 , 0.045)
#define UnderWaterCaustics

uniform sampler2D texture;
uniform sampler2D lightmap;
uniform sampler2D noisetex;
uniform vec3 cameraPosition;
uniform mat4 gbufferModelViewInverse;
uniform int worldTime;
uniform vec3 fogColor;
uniform vec3 skyColor;
uniform float far;
uniform float rainStrength;
uniform int isEyeInWater;

varying vec2 lmcoord;
varying vec2 texcoord;
varying vec4 glcolor;
varying vec2 uv0;
varying vec2 uv1;
varying vec3 wPos;
varying float flag1;
varying float flag2;
varying float flag3;
varying float flag4;
varying float flag5;
varying float flag6;
varying float flag7;
varying vec4 positionInViewCoord;

const int noiseTextureResolution = 256;

float getCaustics(vec4 positionInWorldCoord) {

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

    return noise1 + noise2;;
}

/* DRAWBUFFERS:0 */
void main() {

    vec4 diffuse = texture2D(texture, texcoord) * glcolor;
	diffuse *= texture2D(lightmap, lmcoord);
	vec4 positionInWorldCoord = gbufferModelViewInverse * positionInViewCoord;
    positionInWorldCoord.xyz += cameraPosition;
    float caustics = getCaustics(positionInWorldCoord);
    #ifdef UnderWaterCaustics
    if(isEyeInWater==1){
    diffuse.rgb *= 1.0 + caustics*0.25;}
    #endif
    float indoor=smoothstep(.95,1.,lmcoord.y);
    float cave=smoothstep(.7,1.,lmcoord.y);
    float day=saturate(skyColor.r*2.);
    float sunset=saturate((fogColor.r-.1)-fogColor.b);
    if(flag1 >= 0.5){
 if(1.0 == smoothstep(0.2 , 0.6 , texture2D(texture, texcoord).b)){
  diffuse.rgb += vec3(0.7 , 0.7 , 1.5) * texture2D(texture, texcoord).b;
 }
}
if(flag2 >= 0.5){
 if(texture2D(texture, texcoord).b < texture2D(texture, texcoord).r){
  diffuse.rgb += vec3(1.5 , 0.4 , 0.4) * texture2D(texture, texcoord).r;
 }
}
if(flag3 >= 0.5){
 if(texture2D(texture, texcoord).r < texture2D(texture, texcoord).g){
  diffuse.rgb += vec3(0.4 , 1.5 , 0.4) * texture2D(texture, texcoord).g;
 }
}
if(flag4 >= 0.5){
 if(0.8 < texture2D(texture, texcoord).r){
  diffuse.rgb += vec3(1.5 , 1.5 , 0.4) * texture2D(texture, texcoord).r;
 }
}
if(flag5 >= 0.5){
 if(0.6 < texture2D(texture, texcoord).r){
  diffuse.rgb += vec3(1.5 , 0.8 , 0.7) * texture2D(texture, texcoord).r;
 }
}
if(flag6 >= 0.5){
 if(0.4 > texture2D(texture, texcoord).b || 0.4 > texture2D(texture, texcoord).g){
  diffuse.rgb += vec3(0.4 , 0.4 , 1.5) * texture2D(texture, texcoord).b;
 }
}
if(flag7 >= 0.5){
 diffuse.rgb +=  (texture2D(texture, texcoord).r * texture2D(texture, texcoord).g) + vec3(2.0 , 0.0 , 0.0);
}
    //lighting
    diffuse.rgb+=mix(lightColor*max(lmcoord.x-.5,0.),vec3(.0),(indoor*.5+day*1.5)*.5);
    diffuse.rgb+=mix(vec3(0.),vec3(.0,.0,1.8)*max(lmcoord.x-.67,0.),saturate(float(isEyeInWater)));
    //Fog
    diffuse.rgb=mix(diffuse.rgb,(pow(skyColor,vec3(5.4))+fogColor)/vec3(2.),smoothstep(0.,far,length(wPos.zx))*rainStrength);

	gl_FragData[0] = diffuse;
}