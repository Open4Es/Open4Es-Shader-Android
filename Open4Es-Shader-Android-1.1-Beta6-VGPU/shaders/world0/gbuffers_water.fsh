#version 120

#define NotDefaultWaterTexture
uniform sampler2D texture;
uniform sampler2D lightmap;

uniform int worldTime;

varying float id;

varying vec3 normal;    // Normal vector in eye coordinate system

varying vec4 texcoord;
varying vec4 color;
varying vec4 lightMapCoord;

void main() {
    vec4 light = texture2D(lightmap, lightMapCoord.st); // Illumination
    vec3 normal_ = normalize(normal);
    normal_ = normal_ * 0.5 + 0.5;
    if(id!=10091) {
        gl_FragData[0] = color * texture2D(texture, texcoord.st) * light;   // If it is not a water surface, the texture is drawn normally
        gl_FragData[3] = vec4(normal_, 1.0);   // Normal
    }
    #ifdef NotDefaultWaterTexture
     else {    // If it is water surface, output vec3(0.05, 0.2, 0.3)
        gl_FragData[0] = vec4(vec3(0.07, 0.23, 0.52), 0.7) * light;   // Primary Color
        gl_FragData[3] = vec4(normal_, 1.0);   // Normal
    }
    #else
     else {
        gl_FragData[0] = color * texture2D(texture, texcoord.st) * light;
        gl_FragData[3] = vec4(normal_, 1.0);   // Normal
    }
    #endif
}