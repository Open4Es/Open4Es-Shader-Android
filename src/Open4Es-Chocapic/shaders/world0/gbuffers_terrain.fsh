#version 120

uniform int fogMode;
uniform sampler2D texture;
uniform sampler2D lightmap;

varying vec4 color;
varying vec4 texcoord;
varying vec4 lmcoord;

const int noiseTextureResolution = 256;


/* DRAWBUFFERS:0 */
void main() {

	vec3 pointLightsTint = vec3(1.0, 0.6, 0.25);
	float pointLightsMap = lmcoord.x;
	
	float pointLightsBright = pow(pointLightsMap, 24.0) * 48.0;
	pointLightsBright = clamp(pointLightsBright, 0.0, 4.0);
	
	float pointLightsDark = pow(pointLightsMap, 1.0) * 1.0;	
	vec3 pointLights = pointLightsTint * (pointLightsBright + pointLightsDark);

	vec3 ambientLight = texture2D(lightmap, vec2(0, lmcoord.y)).rgb;

	vec3 resultLighting = ambientLight + pointLights;



	vec4 diffuse = texture2D(texture, texcoord.xy);
	diffuse *= color;
	diffuse *= vec4(resultLighting, 1.0);


	gl_FragData[0] = diffuse;
 
 
	if(fogMode == 9729)
		gl_FragData[0].rgb = mix(gl_Fog.color.rgb, gl_FragData[0].rgb, clamp((gl_Fog.end - gl_FogFragCoord) / (gl_Fog.end - gl_Fog.start), 0.0, 1.0));
	else if(fogMode == 2048)
		gl_FragData[0].rgb = mix(gl_Fog.color.rgb, gl_FragData[0].rgb, clamp(exp(-gl_FogFragCoord * gl_Fog.density), 0.0, 1.0));
}