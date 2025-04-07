#version 460 compatibility

// outputs
out vec2 lightMapCoords;
out vec3 viewSpacePosition;
out vec4 blockColor;

void main() {
    lightMapCoords = (gl_TextureMatrix[2] * gl_MultiTexCoord2).xy;
    viewSpacePosition = (gl_ModelViewMatrix * gl_Vertex).xyz;
    blockColor = gl_Color;

    gl_Position = ftransform();
}
