shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_lambert, specular_schlick_ggx;

uniform sampler2DArray block_textures : filter_nearest;
uniform vec3 hilight_block_pos;
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

}
