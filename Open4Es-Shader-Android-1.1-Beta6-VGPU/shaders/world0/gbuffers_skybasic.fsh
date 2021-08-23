#version 120

#include "/lib/lib.glsl"

uniform int isEyeInWater;
uniform float viewHeight;
uniform float viewWidth;
uniform float rainStrength;
uniform float frameTimeCounter;
uniform float far;
uniform mat4 gbufferModelView;
uniform mat4 gbufferProjectionInverse;
uniform vec3 fogColor;
uniform vec3 skyColor;

varying vec3 cPos;//Chunked Position
varying vec3 wPos;//World Position
varying vec3 glnormal;
varying vec4 starData;

//https://www.shadertoy.com/view/4dS3Wd
float fbm(vec2 x,int octaves){float v=0.;float a=.5;vec2 shift=vec2(1.);mat2 rot=mat2(cos(.5),sin(.5),-sin(.5),cos(.50));for(int i=0;i<octaves;++i){v+=a*noise(x);x+=frameTimeCounter*.02;shift-=frameTimeCounter*.02;x=rot*x*2.+shift;a*=.5;}return v;}

float fogify(float x,float w){
return w/(x*x+w);
}

vec3 calcSkyColor(vec3 pos){

//*-*-Data Base-*-*
float day=saturate(skyColor.r*2.);
float dusk=saturate((fogColor.r-.1)-fogColor.b);

#ifdef SKY
vec3 color=mix(mix(mix(mix(nightSkyColor,daySkyColor,day),duskSkyColor,dusk),rainSkyColor,rainStrength),underWaterSkyColor,float(isEyeInWater==1));
vec3 fog=mix(mix(mix(mix(nightFogColor,dayFogColor,day),duskFogColor,dusk),rainFogColor,rainStrength),underwaterFogColor,float(isEyeInWater==1));

#ifdef CLOUDS
if(isEyeInWater==0){
float cl=mix(.45,.0,rainStrength);
float noise=smoothstep(cl,.63,fbm(wPos.xz*.04,5));
float light=smoothstep(cl,1.,fbm(wPos.xz*.05,4));
float cloud=mix(abs(noise*.8+light),0.,smoothstep(0.,far,length(wPos.xz)));
vec3 cc=mix(mix(mix(nightCloudColor,dayCloudColor,day),duskCloudColor,dusk),rainCloudColor,rainStrength);
color=mix(color,cc,cloud);
}
#endif

#else
vec3 color=skyColor;
vec3 fog=fogColor;
#endif

float upDot=dot(pos,gbufferModelView[1].xyz);
return mix(color,fog,fogify(max(upDot,.0),.01));
}

//*-*-Main-*-*
void main(){

vec3 diffuse;
if(starData.a>.5){
diffuse=starData.rgb;
}
else{
vec4 pos=vec4(gl_FragCoord.xy/vec2(viewWidth,viewHeight)*2.-1.,1.,1.);
pos=gbufferProjectionInverse*pos;
diffuse=calcSkyColor(normalize(pos.xyz));
}

diffuse=toneMap(diffuse,vec3(1.));

//gl_FragData[0]=vec4(diffuse,mix(0.,1.,-(normalize(cross(dFdx(cPos),dFdy(cPos)))).y));
gl_FragData[0]=vec4(diffuse,1.0);
}