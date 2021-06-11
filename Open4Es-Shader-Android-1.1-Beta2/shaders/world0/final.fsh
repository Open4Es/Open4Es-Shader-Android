#version 120

#define Red 1.5 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3.0 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4.0 4.1 4.2 4.3 4.4 4.5 4.6 4.7 4.8 4.9 5.0]
#define Green 1.2 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3.0 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4.0 4.1 4.2 4.3 4.4 4.5 4.6 4.7 4.8 4.9 5.0]
#define Blue 1.1 //[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3.0 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4.0 4.1 4.2 4.3 4.4 4.5 4.6 4.7 4.8 4.9 5.0]
uniform sampler2D gcolor;
uniform float rainStrength;
uniform int worldTime;
varying vec2 texcoord;
 
float A = 0.2;
float B = 0.50;
float C = 0.10 ;
float D = 0.20;
float E = 0.02;
float F = 0.30;
float W = 13.134;
 
vec3 uncharted2Tonemap(vec3 x) {
    return ((x*(A*x+C*B)+D*E)/(x*(A*x+B)+D*F))-E/F;
}

void main() {

    vec3 color = texture2D(gcolor, texcoord.st).rgb;	
    color.r = (color.r*Red)+(color.b+color.g)*(-0.1);
    color.g = (color.g*Green)+(color.r+color.b)*(-0.1);
    color.b = (color.b*Blue)+(color.r+color.g)*(-0.1);
    color = pow(color, vec3(1.4));
    if(12000<worldTime && worldTime<13000) {
        color *= 15.0 * 0.5 *(1.0-rainStrength*0.4); // dusk
    }
    else if(13000<=worldTime && worldTime<=23000) {
        color *= 15.0 * 0.3; // night
    }
    else if(23000<worldTime) {
        color *= 15.0 * 0.5 *(1.0-rainStrength*0.4); // dawn
    }
    else 
        color *= 15.0 * 1.0 *(1.0-rainStrength*0.7);
    vec3 curr = uncharted2Tonemap(color);  
    vec3 whiteScale = 1.0f/uncharted2Tonemap(vec3(W));
    color = curr*whiteScale;
    gl_FragColor = vec4(color,1.0f);	
}
