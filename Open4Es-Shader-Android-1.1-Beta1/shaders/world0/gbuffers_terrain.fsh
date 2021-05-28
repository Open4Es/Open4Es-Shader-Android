#version 120
#define lightColor vec3(1.5, 0.42 , 0.045)
#define saturate(x) clamp(x,0.,1.)

uniform sampler2D texture;
uniform sampler2D lightmap;
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

const int noiseTextureResolution = 256;

void main() {
	vec4 color = texture2D(texture, texcoord) * glcolor;
	color *= texture2D(lightmap, lmcoord);  
float indoor=smoothstep(.8,.9,lmcoord.y);
float cave=smoothstep(1.,.5,lmcoord.y);
float day=saturate(skyColor.r*2.);
float sunset=saturate((fogColor.r-.1)-fogColor.b);
if(flag1 >= 0.5){
 if(1.0 == smoothstep(0.2 , 0.6 , texture2D(texture, texcoord).b)){
  color.rgb += vec3(0.7 , 0.7 , 1.5) * texture2D(texture, texcoord).b;
 }
}
if(flag2 >= 0.5){
 if(texture2D(texture, texcoord).b < texture2D(texture, texcoord).r){
  color.rgb += vec3(1.5 , 0.4 , 0.4) * texture2D(texture, texcoord).r;
 }
}
if(flag3 >= 0.5){
 if(texture2D(texture, texcoord).r < texture2D(texture, texcoord).g){
  color.rgb += vec3(0.4 , 1.5 , 0.4) * texture2D(texture, texcoord).g;
 }
}
if(flag4 >= 0.5){
 if(0.8 < texture2D(texture, texcoord).r){
  color.rgb += vec3(1.5 , 1.5 , 0.4) * texture2D(texture, texcoord).r;
 }
}
if(flag5 >= 0.5){
 if(0.6 < texture2D(texture, texcoord).r){
  color.rgb += vec3(1.5 , 0.8 , 0.7) * texture2D(texture, texcoord).r;
 }
}
if(flag6 >= 0.5){
 if(0.4 > texture2D(texture, texcoord).b || 0.4 > texture2D(texture, texcoord).g){
  color.rgb += vec3(0.4 , 0.4 , 1.5) * texture2D(texture, texcoord).b;
 }
}
if(flag7 >= 0.5){
 color.rgb +=  (texture2D(texture, texcoord).r * texture2D(texture, texcoord).g) + vec3(2.0 , 0.0 , 0.0);
}
    //lighting
    color.rgb+=mix(lightColor*max(lmcoord.x-.5,0.),vec3(.0),(indoor*.5+day*1.5)*.5);
    color.rgb+=mix(vec3(0.),vec3(.0,.0,1.8)*max(lmcoord.x-.67,0.),saturate(float(isEyeInWater)));
    //Fog
    color.rgb=mix(color.rgb,(pow(skyColor,vec3(5.4))+fogColor)/vec3(2.),smoothstep(0.,far,length(wPos.zx))*rainStrength);
	/* DRAWBUFFERS:0 */
	gl_FragData[0] = color;
}