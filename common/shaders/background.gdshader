shader_type canvas_item;

uniform vec4 default_bg : source_color;
uniform vec4 inner_bg_1 : source_color;
uniform vec4 inner_bg_2 : source_color;
uniform vec4 inner_bg_3 : source_color;
uniform vec4 inner_bg_4 : source_color;

uniform vec2 size = vec2(480, 270);
uniform float inner_width = 10.0;

instance uniform vec2 offset = vec2(0.5, 0.5);
instance uniform float progress = 0.5;

bool isDistanceFromTextureEdge(vec2 pos, float dl, float dr, float dt, float db) {
	return pos.x > dl && pos.x < size.x - dr && pos.y > dt && pos.y < size.y - db;
}

bool isDistanceFromTextureEdge(vec2 pos, float d, vec2 o) {
	return isDistanceFromTextureEdge(pos, d * o.x, d * (1.0 - o.x), d * o.y, d * (1.0 - o.y));
}

vec4 getColor(vec2 uv) {
	vec2 pos = size * uv;
	
	float p = progress - float(floor(progress));
	float bound_1 = mix(inner_width, 0.0, p);
	float bound_2 = mix(inner_width * 2.0, inner_width, p);
	float bound_3 = mix(inner_width * 3.0, inner_width * 2.0, p);
	float bound_4 = mix(inner_width * 4.0, inner_width * 3.0, p);
	float bound_5 = mix(inner_width * 5.0, inner_width * 4.0, p);
	
	if (isDistanceFromTextureEdge(pos, bound_5, offset)) {
		return inner_bg_4;
	} else if (isDistanceFromTextureEdge(pos, bound_4, offset)) {
		return mix(inner_bg_4, inner_bg_3, p);
	} else if (isDistanceFromTextureEdge(pos, bound_3, offset)) {
		return mix(inner_bg_3, inner_bg_2, p);
	} else if (isDistanceFromTextureEdge(pos, bound_2, offset)) {
		return mix(inner_bg_2, inner_bg_1, p);
	} else if (isDistanceFromTextureEdge(pos, bound_1, offset)) {
		return mix(inner_bg_1, default_bg, p);
	}
	
	return default_bg;
}

void fragment() {
	COLOR = getColor(UV);
}
