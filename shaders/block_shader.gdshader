shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_lambert, specular_schlick_ggx;

uniform sampler2DArray block_textures : filter_nearest;
uniform vec3 highlight_block_pos;
uniform vec3 highlight_block_normal;
uniform vec3 highlight_block_mask_color : source_color;

// Instance uniform is not supported by gl_compability yet
// instance uniform float block_type;

void fragment() {
	float block_type = float(0);

	vec2 uv_scale = vec2(3.00000, 2.00000); // UV scale for block (1 texture on 6 faces)
	vec2 uv = UV * uv_scale;

	if (NODE_POSITION_WORLD.y == 0.0) // It works well x
		block_type = 0.0; // grass
	else
		block_type = 1.0; // stone

	vec4 block_texture = texture(block_textures, vec3(uv, block_type));
	
	ALBEDO = block_texture.xyz;

	// Highlight block
	vec3 world_normal = (INV_VIEW_MATRIX * vec4(NORMAL, 0.0)).xyz;
	if (NODE_POSITION_WORLD == highlight_block_pos	// `==` works (at least for now)
		&& dot(world_normal, highlight_block_normal) > 0.99) {
		ALBEDO += highlight_block_mask_color;
	}
}
