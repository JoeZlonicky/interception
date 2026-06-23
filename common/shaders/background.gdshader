shader_type canvas_item;

uniform vec4 default_bg : source_color;
uniform vec4 inner_bg_1 : source_color;
uniform vec4 inner_bg_2 : source_color;
uniform vec4 inner_bg_3 : source_color;
uniform vec2 size = vec2(480, 270);
uniform float inner_width = 10.0;

bool isDistanceFromTextureEdge(vec2 pos, float d) {
	return pos.x > d && pos.x < size.x - d && pos.y > d && pos.y < size.y - d;
}

vec4 getColor(vec2 pos) {
	if (isDistanceFromTextureEdge(pos, inner_width * 3.0)) {
		return inner_bg_3;
	} else if (isDistanceFromTextureEdge(pos, inner_width * 2.0)) {
		return inner_bg_2;
	} else if (isDistanceFromTextureEdge(pos, inner_width)) {
		return inner_bg_1;
	}
	return default_bg;
}

void fragment() {
	vec2 pos = size * UV;
	
	COLOR = getColor(pos);
}
