shader_type spatial;
render_mode unshaded;

uniform sampler2D SCREEN_SAMPLER: hint_screen_texture, filter_linear_mipmap;
uniform vec3 NIGHT_VISION_COLOR: source_color;
uniform bool ENABLE_NIGHT_VISION;
uniform bool ENABLE_NOISE;

// set max strength to your liking here=20.0, step_size=0.1
uniform float strength:hint_range(0, 50.0, 0.1)=16;

vec3 get_noise_texture(vec4 screen, vec2 uv) {
	// Random noise
    float x = (uv.x + 4.0 ) * (uv.y + 4.0 ) * (TIME * 10.0);
	// Add grain to Screen
	screen = screen+vec4(mod((mod(x, 13.0) ) * (mod(x, 123.0) ), 0.01)-0.005) * strength;
    
    screen = 1.0 - screen;
	return screen.rgb;
}

void vertex() {
	POSITION = vec4(VERTEX, 1);
}

void fragment() {
	vec2 uv = SCREEN_UV;
	
	vec4 screen_texture = texture(SCREEN_SAMPLER,uv);
	vec3 screen_color = screen_texture.rgb;
	vec3 color = NIGHT_VISION_COLOR;

	
	if(ENABLE_NOISE){
	//	vec3 noise_color = get_noise_texture(screen_texture, uv);
	//	screen_color *= noise_color;
	}
	if(ENABLE_NIGHT_VISION){
		screen_color *= color;
	}
	
	ALBEDO = screen_color;
}

