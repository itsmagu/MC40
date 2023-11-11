#version 150

#moj_import <light.glsl>
#moj_import <fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV1;
in ivec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler0;
uniform sampler2D Sampler1;
uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform mat3 IViewRotMat;
uniform int FogShape;
uniform float GameTime;

uniform vec3 Light0_Direction;
uniform vec3 Light1_Direction;

out float vertexDistance;
out vec4 vertexColor;
out vec4 lightMapColor;
out vec4 overlayColor;
out vec2 texCoord0;
out vec4 normal;
flat out int player;
out vec3 settings;
out vec3 settings2;

float hash(float p) {
    p = fract(p * 0.011);
    p *= p + 7.5;
    p *= p + p;
    return fract(p);
}

float noise(float x) {
    float i = floor(x);
    float f = fract(x);
    float u = f * f * (3.0 - 2.0 * f);
    return mix(hash(i), hash(i + 1.0), u);
}

float fbm(float x) {
    float v = 0.0;
    float a = 0.5;
    float shift = float(100);
    for (int i = 0; i < 3; ++i) {
        v += a * noise(x);
        x = x * 2.0 + shift;
        a *= 0.5;
    }
    return v;
}

void main() {
    vec3 pos = IViewRotMat * Position;

    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    vertexColor = minecraft_mix_light(Light0_Direction, Light1_Direction, Normal, Color);
    lightMapColor = texelFetch(Sampler2, UV2 / 16, 0);
    vec4 damageFlash = texelFetch(Sampler1, UV1, 0);
    overlayColor = damageFlash;
    texCoord0 = UV0;
    normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);

    player = 0;
    if (ivec2(textureSize(Sampler0, 0)) == ivec2(64, 64) && ivec4(texelFetch(Sampler0, ivec2(0, 16), 0) * 255.0 + 0.5) == ivec4(1, 1, 1, 255)) {
        player = 1;
        settings = texelFetch(Sampler0, ivec2(1, 16), 0).rgb;
        settings2 = texelFetch(Sampler0, ivec2(2, 16), 0).rgb;
        // Check if current vertex is on the player's face
        if (texCoord0.x >= 0.125 && texCoord0.y >= 0.125 && texCoord0.x <= 0.25 && texCoord0.y <= 0.25) {
            // Damage face
            if (settings.r > 0.99 && damageFlash != vec4(1.0)) {
                if (gl_VertexID == 16) {
                    texCoord0 = vec2(0.5, 0.0);
                } else if (gl_VertexID == 17) {
                    texCoord0 = vec2(0.375, 0.0);
                } else if (gl_VertexID == 18) {
                    texCoord0 = vec2(0.375, 0.125);
                } else if (gl_VertexID == 19) {
                    texCoord0 = vec2(0.5, 0.125);
                }
            // Blinking
            } else if (settings.b > 0.99) {
                vec3 blinkOffset = texelFetch(Sampler0, ivec2(20, 20), 0).rgb;
                if (fbm(floor(GameTime * 6400.0) * 64.0 + (blinkOffset.r + blinkOffset.g + blinkOffset.b) * 0.01) > 0.725) {
                    if (gl_VertexID == 16) {
                        texCoord0 = vec2(0.125, 0.0);
                    } else if (gl_VertexID == 17) {
                        texCoord0 = vec2(0.0, 0.0);
                    } else if (gl_VertexID == 18) {
                        texCoord0 = vec2(0.0, 0.125);
                    } else if (gl_VertexID == 19) {
                        texCoord0 = vec2(0.125, 0.125);
                    }
                }
            }
        } else if (texCoord0.x >= 0.625 && texCoord0.y >= 0.125 && texCoord0.x <= 0.75 && texCoord0.y <= 0.25) {
            // Damage face
            if (settings.r > 0.99 && damageFlash != vec4(1.0)) {
                if (gl_VertexID == 160) {
                    texCoord0 = vec2(1.0, 0.0);
                } else if (gl_VertexID == 161) {
                    texCoord0 = vec2(0.875, 0.0);
                } else if (gl_VertexID == 162) {
                    texCoord0 = vec2(0.875, 0.125);
                } else if (gl_VertexID == 163) {
                    texCoord0 = vec2(1.0, 0.125);
                }
            // Blinking
            } else if (settings.b > 0.99) {
                vec3 blinkOffset = texelFetch(Sampler0, ivec2(3, 19), 0).rgb;
                if (fbm(floor(GameTime * 6400.0) * 64.0 + (blinkOffset.r + blinkOffset.g + blinkOffset.b) * 0.01) > 0.725) {
                    if (gl_VertexID == 160) {
                        texCoord0 = vec2(0.625, 0.0);
                    } else if (gl_VertexID == 161) {
                        texCoord0 = vec2(0.5, 0.0);
                    } else if (gl_VertexID == 162) {
                        texCoord0 = vec2(0.5, 0.125);
                    } else if (gl_VertexID == 163) {
                        texCoord0 = vec2(0.625, 0.125);
                    }
                }
            }
        }
        // Custom damage flash
        if (settings.g > 0.99) {
            overlayColor = texelFetch(Sampler0, ivec2(0, 19), 0);
            overlayColor.a = damageFlash.a;
        }
        // Cape
        if (settings2.g > 0.99) {
            vec3 normal = IViewRotMat * Normal;
            float wave = (sin(GameTime * 800.0) * 0.5 + 0.5) * 0.2;
            float angle = wave + 0.2;
            if (gl_VertexID == 284) {
                player = 2;
                pos += normal * 0.045;
                texCoord0 = vec2(1.0, 0.25);
            } else if (gl_VertexID == 285) {
                player = 2;
                pos += normal * 0.045;
                texCoord0 = vec2(0.875, 0.25);
            } else if (gl_VertexID == 286) {
                player = 2;
                texCoord0 = vec2(0.875, 0.5);
                pos += normal * angle;
                pos.y += length(angle) * 0.4 - 0.2;
            } else if (gl_VertexID == 287) {
                player = 2;
                texCoord0 = vec2(1.0, 0.5);
                pos += normal * angle;
                pos.y += length(angle) * 0.4 - 0.2;
            }
        }

        gl_Position = ProjMat * ModelViewMat * vec4(pos * IViewRotMat, 1.0);
    }

    vertexDistance = fog_distance(ModelViewMat, pos, FogShape);
}
