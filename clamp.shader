shader_type canvas_item;
render_mode blend_mix;

uniform sampler2D tonemap;
uniform bool enabled;

float lum(vec3 color) {
	float R = color.r;
	float G = color.g;
	float B = color.b;
	return (0.299*R + 0.587*G + 0.114*B);
}

float val(vec3 color) {
	return max(max(color.r, color.g), color.b);
}

vec4 clampTone(vec4 sample) {
	float l = lum(sample.rgb);
	float v = val(sample.rgb);
	return texture(tonemap, vec2(v, 0));
}

void fragment() {
	vec4 sample = texture(SCREEN_TEXTURE, SCREEN_UV.xy);
	if (enabled) {
		COLOR = clampTone(sample);	
	} else {
		COLOR = sample;
	}
}