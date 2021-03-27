shader_type canvas_item;

uniform sampler2D u_dither_tex;
uniform sampler2D u_color_tex;

uniform int u_bit_depth;
uniform float u_contrast;
uniform float u_offset;
uniform int u_dither_size;

void fragment() 
{
	ivec2 tex_size = textureSize(TEXTURE, 0) / u_dither_size;
	vec2 uv = vec2(ivec2(UV * vec2(tex_size))) / vec2(tex_size);
	vec3 col = texture(TEXTURE, uv).rgb;
	
	// adjust
	float bits = float(u_bit_depth) + 0.00001;
	float lum = clamp(dot(col, vec3(0.299f, 0.587f, 0.114f)), 0.0, 1.0);
	float contrast = u_contrast;
	lum = (lum - 0.5 + u_offset) * contrast + 0.5;
	lum = clamp(lum - 0.0, 0.0, 1.0);
	lum *= bits;
	lum = floor(lum) / bits;
		
	// dithering
	ivec2 noise_size = textureSize(u_dither_tex, 0);
	vec2 inv_noise_size = vec2(1.0 / float(noise_size.x), 1.0 / float(noise_size.y));
	ivec2 texture_size = textureSize(TEXTURE, 0);
	

	ivec2 col_size = textureSize(u_color_tex, 0);
	col_size /= col_size.y;
	float col_x = float(col_size.x) - 1.0;
	
	float col_texel_size = 1.0 / col_x;
	
	lum = max(lum - 0.00001, 0.0);
	float lum_lower = floor(lum * col_x) * col_texel_size;
	float lum_upper = (floor(lum * col_x) + 1.0) * col_texel_size;
	float lum_scaled = lum * col_x - floor(lum * col_x);
	
	texture_size /= u_dither_size;
	vec2 noise_uv = UV * inv_noise_size * vec2(float(texture_size.x), float(texture_size.y));
	
	float threshold = texture(u_dither_tex, noise_uv).r;
	threshold = threshold * 0.99 + 0.005;
	float ramp_val = lum_scaled < threshold ? 0.0f : 1.0f;
	
	float col_sample = mix(lum_lower, lum_upper, ramp_val);
	vec3 final_col = texture(u_color_tex, vec2(col_sample, 0.5)).rgb;
	
	
    COLOR.rgb = vec3(final_col);
}