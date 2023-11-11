#version 150

uniform sampler2D Sampler0;

uniform float Brightness;
uniform int WithLight;

in vec2 texCoord0;

out vec4 fragColor;

void main() {
    vec4 color = texture(Sampler0, texCoord0);
	if(WithLight == 0){
		fragColor = vec4(color.rgb * Brightness, 1);
		return;
	}
	float light = color.a;
	float litBrightness = max(light, Brightness);
    fragColor = vec4(color.rgb * litBrightness, 1);
}
