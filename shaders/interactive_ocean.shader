shader_type spatial;

uniform sampler2D displacement_map;
uniform float grid_points;
uniform float amp;

float height(vec2 hpos){
	float output = amp * texture(displacement_map, hpos).r;
	output -= amp * texture(displacement_map, hpos).g;
	return output * amp;
}

vec3 normal(vec2 hpos){
	float p = 1.0 / grid_points;
	float R = height(hpos + vec2(p, 0.0)), L = height(hpos - vec2(p, 0.0));
	float B = height(hpos + vec2(0.0, p)), T = height(hpos - vec2(p, 0.0));
	return vec3((R-L) / (2.0*p), -1.0, (B-T)/ (2.0 * p));
}

void vertex(){
	if (COLOR.r > 0.1){
		VERTEX.y += height(UV);
}

}

void fragment(){
	NORMAL = normal(UV);
	float fresnel = sqrt(1.0 - dot(NORMAL, VIEW));
	RIM = 0.2;
	METALLIC = 0.0;
	ROUGHNESS = 0.01;
	ALBEDO = vec3(0.1,0.1,0.2);
}
