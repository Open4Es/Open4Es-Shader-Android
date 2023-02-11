#version 150
#extension GL_ARB_explicit_attrib_location : enable

#define saturate(x) clamp(x,0.0,1.0)
#define lightColor vec3(1.5, 0.42 , 0.045)

uniform sampler2D gtexture;
uniform sampler2D lightmap;

uniform float alphaTestRef;
uniform float far;
uniform float rainStrength;

uniform vec3 fogColor;
uniform vec3 skyColor;

uniform int worldTime;
uniform int isEyeInWater;

in vec2 lmcoord;
in vec2 texcoord;
in vec4 tint;
in vec2 uv0;
in vec2 uv1;

const int noiseTextureResolution = 256;

/* DRAWBUFFERS:0 */
out vec4 colortex0Out;

void main() {
	vec4 color = texture(gtexture, texcoord) * tint;
	if (color.a < alphaTestRef) discard;
	color *= texture(lightmap, lmcoord);

	float indoor=smoothstep(.95,1.,lmcoord.y);
    float cave=smoothstep(.7,1.,lmcoord.y);
    float day=saturate(skyColor.r*2.);
    float sunset=saturate((fogColor.r-.1)-fogColor.b);

	//lighting
    color.rgb+=mix(lightColor*max(lmcoord.x-.5,0.),vec3(.0),(indoor*.5+day*1.5)*.5);
    color.rgb+=mix(vec3(0.),vec3(.0,.0,1.8)*max(lmcoord.x-.67,0.),saturate(float(isEyeInWater)));

	colortex0Out = color;
}