shader_type canvas_item;

uniform sampler2D u_noise_tex;
uniform sampler2D u_color_tex;

void fragment() 
{
	vec3 col = texture(TEXTURE, UV).rgb;
	
	// adjust
	float bits = 64.0;
	float lum = clamp(dot(col, vec3(0.299f, 0.587f, 0.114f)), 0.0, 1.0);
	float contrast = 1.0;
	lum = (lum - 0.5) * contrast + 0.5;
	lum = clamp(lum - 0.0, 0.0, 1.0);
	lum *= bits;
	lum = floor(lum) / bits;
		
	// dithering
	ivec2 noise_size = textureSize(u_noise_tex, 0);
	vec2 inv_noise_size = vec2(1.0 / float(noise_size.x), 1.0 / float(noise_size.y));
	ivec2 texture_size = textureSize(TEXTURE, 0);
	

	ivec2 col_size = textureSize(u_color_tex, 0);
	col_size /= col_size.y;
	float col_x = float(col_size.x) - 1.0;
	
	float col_texel_size = 1.0 / col_x;
	
	float lum_lower = floor(lum * col_x - 0.00001) * col_texel_size;
	float lum_upper = (floor(lum * col_x) + 1.0) * col_texel_size;
	float lum_scaled = lum * col_x - floor(lum * col_x - 0.00001);
	
	
	vec2 noise_uv = UV * inv_noise_size * vec2(float(texture_size.x), float(texture_size.y));
	
	float threshold = texture(u_noise_tex, noise_uv).r;
	float ramp_val = lum_scaled < threshold ? 0.0f : 1.0f;
	
	float col_sample = mix(lum_lower, lum_upper, ramp_val);
	vec3 final_col = texture(u_color_tex, vec2(col_sample, 0.5)).rgb;
	
	
    COLOR.rgb = vec3(final_col);
}