#version 460

// uniforms
uniform vec3 chunkOffset;
uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
uniform vec3 cameraPosition;
uniform mat4 gbufferModelViewInverse;
uniform mat3 normalMatrix;

// inputs
in vec2 vaUV0;
in ivec2 vaUV2;
in vec3 vaPosition;
in vec3 vaNormal;
in vec4 vaColor;

// outputs
out vec2 texCoord;
out vec2 lightMapCoords;
out vec3 folliageColor;
out vec3 geoNormal;

void main() {
    geoNormal = normalMatrix * vaNormal;
    texCoord = vaUV0;
    folliageColor = vaColor.rgb;
    lightMapCoords = vaUV2 * (1.0 / 256.0) + (1.0 / 32.0);

    vec3 worldSpaceVertPos = cameraPosition + (gbufferModelViewInverse * modelViewMatrix *  vec4(vaPosition + chunkOffset, 1)).xyz;
    

    float distToCam = distance(worldSpaceVertPos, cameraPosition);

    //gl_Position = projectionMatrix * modelViewMatrix * vec4(vaPosition + chunkOffset - 0.1 * distToCam, 1);


    gl_Position = projectionMatrix * modelViewMatrix * vec4(vaPosition + chunkOffset, 1);
}