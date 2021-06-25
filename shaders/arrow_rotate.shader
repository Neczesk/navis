shader_type canvas_item;

uniform vec2 wind_direction = vec2(0.3,0.7);

uniform float speed = 1.0;


vec2 rotateUV(vec2 uv, vec2 pivot, float rotation) {
    float cosa = cos(rotation);
    float sina = sin(rotation);
    uv -= pivot;
    return vec2(
        cosa * uv.x - sina * uv.y,
        cosa * uv.y + sina * uv.x 
    ) + pivot;
}

void vertex() {
	float theta = dot(wind_direction, vec2(0.0, -1.0));
    VERTEX = rotateUV(VERTEX, 0.5/TEXTURE_PIXEL_SIZE, theta);
}

