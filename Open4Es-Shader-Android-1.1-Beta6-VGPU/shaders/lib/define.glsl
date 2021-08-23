#define ABOUT 0 //[0 1]

#define TONEMAP
#define RAIN
#define SHADOWS
#define SKY
#define FOG
#define WATER
#define UNDERWATER
#define CLOUDS
#define LIGHT
#define GLOWING_ORES
#define WAVE
//#define VANILLACLOUDS

#define daySkyColor vec3(.35,.65,1.)
#define nightSkyColor vec3(.0,.07,.13)
#define duskSkyColor vec3(1.2,.3,.5)
#define rainSkyColor vec3(.12,.12,.12)
#define underWaterSkyColor vec3(.2,.2,1.)

#define dayWaterColor vec3(.35,.85,1.)
#define nightWaterColor vec3(.0,.07,.13)
#define duskWaterColor vec3(1.2,.3,.5)
#define rainWaterColor vec3(.12,.12,.12)

#define dayCloudColor vec3(1.)
#define nightCloudColor vec3(.0,.13,.25)
#define duskCloudColor vec3(2.,1.,.8)
#define rainCloudColor vec3(.2,.2,.2)

#define dayFogColor vec3(.55,.7,1.)
#define nightFogColor vec3(.1,.1,.15)
#define duskFogColor vec3(1.,.34,.0)
#define rainFogColor vec3(.15,.15,.15)
#define underwaterFogColor vec3(.2,.2,1.)

#define dayColor vec3(1.32,1.36,1.)
#define nightColor vec3(.8,.8,1.)
#define duskColor vec3(8.,2.,.8)
#define rainColor vec3(.6,.7,1.)
#define underWaterColor vec3(.6,.6,20.)
#define caveColor vec3(1.2,1.1,1.)

#define lightColor vec3(2.,.7,.0)

#define saturate(x) clamp(x,0.,1.)
#define toneMap(b,c) tonemapFilmic(b*(b*c))

#define pow5(x) x*x*x*x*x