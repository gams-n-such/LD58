shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
    	vec3 c = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0).rgb;
    	c.rgb = 1.0 - c.rgb;
    	COLOR.rgb = c;
    	COLOR.a = 1.0;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
