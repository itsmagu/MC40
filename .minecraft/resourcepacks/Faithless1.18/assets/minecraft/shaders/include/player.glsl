if (player == 2 && color.rgb == vec3(0.0)) {
    color.a = 0.0;
}

float emissive = 0.0;
float damage = 0.25;

for (int i = 0; i < 4; i++) {
    for (int j = 0; j < 4; j++) {
        vec4 control = texelFetch(Sampler0, ivec2(36 + i, 16 + j), 0);
        if (control.rgb == color.rgb) {
            emissive = 1.0;
        }
    }
}

if (settings2.r > 0.99) {
    damage = 0.0;
}

if (overlayColor.a < 0.99) {
    if (texelFetch(Sampler0, ivec2(2, 16), 0).r > 0.99) {
        for (int i = 0; i < 4; i++) {
            for (int j = 0; j < 4; j++) {
                vec4 control = texelFetch(Sampler0, ivec2(12 + i, 16 + j), 0);
                if (control.rgb == color.rgb) {
                    damage = 0.25;
                }
            }
        }
        for (int i = 0; i < 4; i++) {
            for (int j = 0; j < 4; j++) {
                vec4 control = texelFetch(Sampler0, ivec2(16 + i, 16 + j), 0);
                if (control.rgb == color.rgb) {
                    damage = 1.0;
                }
            }
        }
    }
    color.rgb = mix(color.rgb, overlayColor.rgb, damage);
}

color *= ColorModulator;

if (settings.g != 1.0 || emissive != 1.0) {
    color *= lightMapColor * vertexColor;
}

fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
