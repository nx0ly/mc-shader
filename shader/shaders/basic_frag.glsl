#version 460 compatibility

// textures
uniform sampler2D gtexture;
uniform sampler2D lightmap;
uniform sampler2D shadowtex0;
uniform sampler2D depthtex0;


// uniforms
uniform vec3 shadowLightPosition;
uniform mat4 gbufferModelViewInverse;
uniform float viewWidth;
uniform float viewHeight;
uniform vec3 cameraPosition;
uniform mat4 shadowModelView;
uniform mat4 shadowProjection;

/* DRAWBUFFERS:0 */
layout (location = 0) out vec4 outColor0;

// inputs
in vec2 texCoord;
in vec2 lightMapCoords;
in vec3 folliageColor;
in vec3 geoNormal;
in vec3 viewSpacePosition;

void main() {
    vec3 shadowLightDirection = normalize(mat3(gbufferModelViewInverse) * shadowLightPosition);
    vec3 worldGeoNormal = mat3(gbufferModelViewInverse) * geoNormal;

    float lightBrightness = clamp(dot(shadowLightDirection, worldGeoNormal), 0.1, 1.1); // tells us how close they are to looking in the same direction

    vec3 lightColor = pow(clamp(texture(lightmap, lightMapCoords).rgb, vec3(0.1, 0.1, 0.1), vec3(1.0, 1.0, 1.0)), vec3(2.2));

    vec4 outColorData = pow(texture(gtexture, texCoord), vec4(2.2));
    vec3 outputColor = outColorData.rgb * pow(folliageColor, vec3(2.2)) * (lightColor) * lightBrightness;

    float transparency = outColorData.a;

    if(transparency < 0.01) discard;

    outputColor *= lightBrightness;


/*

vec3 shadow = texture(shadowtex0, gl_FragCoord.xy/vec2(viewWidth, viewHeight)).rgb;

vec3 fragFeetPlayerSpace = (gbufferModelViewInverse * vec4(viewSpacePosition, 1.0)).xyz;
vec3 fragWorldSpace = fragFeetPlayerSpace + cameraPosition;
vec3 fragShadowViewSpace = (shadowModelView * vec4(fragFeetPlayerSpace, 1.0)).xyz;

vec4 fragHomogeneousSpace = shadowProjection * vec4(fragShadowViewSpace, 1.0);

vec3 fragShadowNDCSpace = fragHomogeneousSpace.xyz / fragHomogeneousSpace.w;
vec3 fragShadowScreenSpace = fragShadowNDCSpace * 0.5 + 0.5;

texture(shadowtex0, fragShadowScreenSpace.xy);
*/

    outColor0 = vec4(pow(outputColor, vec3(1.0/2.2)), 1);
}