shader_type canvas_item;

uniform vec4 default_bg : source_color;
uniform vec4 inner_bg_1 : source_color;
uniform vec4 inner_bg_2 : source_color;
uniform vec4 inner_bg_3 : source_color;

uniform vec2 size = vec2(480, 270);
instance uniform vec2 offset = vec2(0.5, 0.5);
uniform float inner_width = 10.0;

bool isDistanceFromTextureEdge(vec2 pos, float dl, float dr, float dt, float db) {
	return pos.x > dl && pos.x < size.x - dr && pos.y > dt && pos.y < size.y - db;
}

bool isDistanceFromTextureEdge(vec2 pos, float d, vec2 o) {
	return isDistanceFromTextureEdge(pos, d * o.x, d * (1.0 - o.x), d * o.y, d * (1.0 - o.y));
}

vec4 getColor(vec2 uv) {
	vec2 pos = size * uv;
	
	float no_bound = 0.0;
	float bound_1 = inner_width;
	float bound_2 = inner_width * 2.0;
	float bound_3 = inner_width * 3.0;
	
	if (isDistanceFromTextureEdge(pos, bound_3, offset)) {
		return inner_bg_3;
	}
	else if (isDistanceFromTextureEdge(pos, bound_2, offset)) {
		return inner_bg_2;
	}
	if (isDistanceFromTextureEdge(pos, bound_1, offset)) {
		return inner_bg_1;
	}
	return default_bg;
}

void fragment() {
	COLOR = getColor(UV);
}
