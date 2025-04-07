#version 460 compatibility

// textures
uniform sampler2D lightmap;
uniform sampler2D depthtex0;

//
uniform float viewWidth;
uniform float viewHeight;

uniform vec3 fogColor;

/* DRAWBUFFERS:0 */
layout (location = 0) out vec4 outColor0;

in vec2 lightMapCoords;
in vec3 viewSpacePosition;
in vec4 blockColor;

void main() {
    vec3 lightColor = pow(texture(lightmap, lightMapCoords).rgb, vec3(2.2));

    vec4 outColorData = pow(blockColor, vec4(2.2));
    vec3 outputColor = outColorData.rgb * lightColor;

    float transparency = outColorData.a;

    if(transparency < 0.1) discard;

    vec2 texCoord = gl_FragCoord.xy / vec2(viewWidth, viewHeight);
    float depth = texture(depthtex0, texCoord).r;
    if (depth != 1.0) discard; // prevents leaks (e.g. water)

    float distFromCam = distance(vec3(0), viewSpacePosition);
    float fogBlendFac = clamp((distFromCam - 100) / 3900, 0, 1); // 2500 = min, 4000 = max, 1500 = 4000 - 2500

    outputColor = mix(outputColor, pow(vec3(1.0, 0.0, 0.0), vec3(2.2)), fogBlendFac);

    outColor0 = pow(vec4(fogColor, transparency), vec4(1.0/2.2));
}