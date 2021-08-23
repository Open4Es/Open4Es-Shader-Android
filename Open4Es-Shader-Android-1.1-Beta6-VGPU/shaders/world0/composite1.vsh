#version 120

uniform int worldTime;
uniform float rainStrength;

varying float isNight;

varying vec3 mySkyColor;
varying vec3 mySunColor;
varying vec4 texcoord;

vec3 sunColorArr[24] = vec3[24](
    vec3(2, 2, 1),      // 0-1000
    vec3(2, 1.5, 1),    // 1000 - 2000
    vec3(1, 1, 1),      // 2000 - 3000
    vec3(1, 1, 1),      // 3000 - 4000
    vec3(1, 1, 1),      // 4000 - 5000 
    vec3(1, 1, 1),      // 5000 - 6000
    vec3(1, 1, 1),      // 6000 - 7000
    vec3(1, 1, 1),      // 7000 - 8000
    vec3(1, 1, 1),      // 8000 - 9000
    vec3(1, 1, 1),      // 9000 - 10000
    vec3(1, 1, 1),      // 10000 - 11000
    vec3(1, 1, 1),      // 11000 - 12000
    vec3(2, 1.5, 0.5),      // 12000 - 13000
    vec3(0.3, 0.5, 0.9),      // 13000 - 14000
    vec3(0.3, 0.5, 0.9),      // 14000 - 15000
    vec3(0.3, 0.5, 0.9),      // 15000 - 16000
    vec3(0.3, 0.5, 0.9),      // 16000 - 17000
    vec3(0.3, 0.5, 0.9),      // 17000 - 18000
    vec3(0.3, 0.5, 0.9),      // 18000 - 19000
    vec3(0.3, 0.5, 0.9),      // 19000 - 20000
    vec3(0.3, 0.5, 0.9),      // 20000 - 21000
    vec3(0.3, 0.5, 0.9),      // 21000 - 22000
    vec3(0.3, 0.5, 0.9),      // 22000 - 23000
    vec3(0.3, 0.5, 0.9)       // 23000 - 24000(0)
);

vec3 skyColorArr[24] = vec3[24](
    vec3(0.6, 0.7, 0.87),        // 0-1000
    vec3(0.6, 0.7, 0.87),        // 1000 - 2000
    vec3(0.6, 0.7, 0.87),        // 2000 - 3000
    vec3(0.6, 0.7, 0.87),        // 3000 - 4000
    vec3(0.6, 0.7, 0.87),        // 4000 - 5000 
    vec3(0.6, 0.7, 0.87),        // 5000 - 6000
    vec3(0.6, 0.7, 0.87),        // 6000 - 7000
    vec3(0.6, 0.7, 0.87),        // 7000 - 8000
    vec3(0.6, 0.7, 0.87),        // 8000 - 9000
    vec3(0.6, 0.7, 0.87),        // 9000 - 10000
    vec3(0.6, 0.7, 0.87),        // 10000 - 11000
    vec3(0.6, 0.7, 0.87),        // 11000 - 12000
    vec3(0.6, 0.7, 0.87),        // 12000 - 13000
    vec3(0.02, 0.02, 0.027),      // 13000 - 14000
    vec3(0.02, 0.02, 0.027),      // 14000 - 15000
    vec3(0.02, 0.02, 0.027),      // 15000 - 16000
    vec3(0.02, 0.02, 0.027),      // 16000 - 17000
    vec3(0.02, 0.02, 0.027),      // 17000 - 18000
    vec3(0.02, 0.02, 0.027),      // 18000 - 19000
    vec3(0.02, 0.02, 0.027),      // 19000 - 20000
    vec3(0.02, 0.02, 0.027),      // 20000 - 21000
    vec3(0.02, 0.02, 0.027),      // 21000 - 22000
    vec3(0.02, 0.02, 0.027),      // 22000 - 23000
    vec3(0.02, 0.02, 0.027)       // 23000 - 24000(0)
);

void main() {

    // Color Transition Interpolation
	int hour = worldTime/1000;
    int next = (hour+1<24)?(hour+1):(0);
    float delta = float(worldTime-hour*1000)/1000;
	// Sky Color
    mySkyColor = mix(skyColorArr[hour], skyColorArr[next], delta);
    // Sky Color
    mySunColor = mix(sunColorArr[hour], sunColorArr[next], delta);

    // Alternate Day and night interpolation
    isNight = 0;  // daytime
    if(12000<worldTime && worldTime<13000) {
        isNight = 1.0 - (13000-worldTime) / 1000.0; // evening
    }
    else if(13000<=worldTime && worldTime<=23000) {
        isNight = 1.0;    // Night
    }
    else if(23000<worldTime) {
        isNight = (24000-worldTime) / 1000.0;   // Dawn
    }

    // Weather Gradient
    //mySkyColor = mix(mySkyColor, vec3(0.7, 0.7, 0.8) * (1-isNight*0.7), rainStrength);
    //mySunColor = mix(mySunColor, vec3(0.7, 0.7, 0.8) * (1-isNight*0.5), rainStrength);

    gl_Position = ftransform();
    texcoord = gl_TextureMatrix[0] * gl_MultiTexCoord0;
}