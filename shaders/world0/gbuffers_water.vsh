#version 150
#define lerp(x , y , a) x * (1.0 - a) + y * a //mix
uniform vec3 cameraPosition;
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjection;
uniform mat4 gbufferProjectionInverse;
uniform int worldTime;
uniform float frameTimeCounter;
attribute vec4 mc_Entity;
out vec2 lmcoord;
out vec2 texcoord;
out vec4 glcolor;
out vec3 cPos;
out vec3 wPos;
out float waterHeight;
out vec2 uv1;
out float waterFlag;
out vec3 normal;
out vec4 positionInViewCoord;




void main() {
    positionInViewCoord = gl_ModelViewMatrix * gl_Vertex;
    gl_Position = gbufferProjection * positionInViewCoord;
    texcoord = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
    lmcoord  = (gl_TextureMatrix[1] * gl_MultiTexCoord1).xy;
    glcolor = gl_Color;
    normal = gl_NormalMatrix * gl_Normal;


    waterFlag = 0.0;

    cPos = (gbufferModelViewInverse * gl_ModelViewMatrix * gl_Vertex).xyz + cameraPosition;
    wPos = (gbufferModelViewInverse * (gl_ModelViewMatrix * gl_Vertex)).xyz;

/*highp float waterWave = 
sin(noise(frameTimeCounter  + (cPos.xz + cPos.xy + cPos.xz + cPos.xx + cPos.yy + cPos.zz ) *0.2
+ noise(frameTimeCounter  + (cPos.xz + cPos.xy + cPos.xz + cPos.xx + cPos.yy + cPos.zz)*0.2))) *2.0; //Water wave */

if(mc_Entity.x == 8.0 || mc_Entity.x == 9.0){
waterFlag = 1.0;

 //gl_Position.y -= waterWave * 0.2; //Water height
 uv1 = gl_MultiTexCoord1.xy; //Torch level
}

//waterHeight = waterWave;
}
