extends Spatial

var _timer = 0.0
var _moving_debug = false
var _debug_init_pos = Vector2()
var _moving_debug_press_start = Vector2()

onready var _viewport_container = get_node("ViewportContainer")
onready var _viewport = get_node("ViewportContainer/Viewport")

onready var _debug_controls = get_node("Controls/Control")
onready var _debug_controls_tab_container = get_node("Controls/Control/TabContainer")
onready var _control_bitdepth = get_node("Controls/Control/TabContainer/Params/BitDepth")
onready var _control_contrast = get_node("Controls/Control/TabContainer/Params/Contrast")
onready var _control_dithersize = get_node("Controls/Control/TabContainer/Params/DitherSize")
onready var _control_offset = get_node("Controls/Control/TabContainer/Params/Offset")
onready var _palette_preview = get_node("Controls/Control/TabContainer/Params/PalettePreview")
onready var _dither_preview = get_node("Controls/Control/TabContainer/Params/DitherPreview")
onready var _dither_label = get_node("Controls/Control/TabContainer/Params/DitherLabel")

onready var _gradient = get_node("ViewportContainer/Viewport/Gradient")
onready var _sphere = get_node("ViewportContainer/Viewport/Primitives/Sphere")
onready var _cube = get_node("ViewportContainer/Viewport/Primitives/Cube")
onready var _prism = get_node("ViewportContainer/Viewport/Primitives/Prism")

export var palettes = []
export var dither_patterns = []

func _ready():
	_viewport.size = get_viewport().size
	
	_viewport_container.material.set_shader_param("u_color_tex", palettes[0])
	_palette_preview.texture = palettes[0]
	
	_viewport_container.material.set_shader_param("u_dither_tex", dither_patterns[0])
	_dither_preview.texture = dither_patterns[0]
	_dither_label.text = "Bayer 16x16"
	
	_control_bitdepth.setup("Bit Depth", 2, 64, 32, 1)
	_control_contrast.setup("Contrast", 0.0, 5.0, 1.0, 0.01)
	_control_offset.setup("Offset", -1.0, 1.0, 0.0, 0.01)
	_control_dithersize.setup("Dither Size", 1, 8, 2, 1)
	
	_gradient.rect_size = Vector2(get_viewport().size.x * 0.1, get_viewport().size.y)

func _process(delta):
	_timer += delta
	
	_sphere.transform.origin.y = 2.5 + sin(_timer) * 1.0	
	_cube.transform.origin.y = 2.5 + sin(_timer + PI * 0.5) * 1.0
	_prism.transform.origin.y = 2.5 + sin(_timer + PI) * 1.0
	
	_cube.rotation.y = _timer
	_prism.rotation.z = _timer
	
	if _moving_debug:
		var mouse_delta = get_viewport().get_mouse_position() - _moving_debug_press_start
		_debug_controls.rect_position = _debug_init_pos + mouse_delta
		if Input.is_action_just_released("ui_click"):
			_moving_debug = false
	
	_viewport_container.material.set_shader_param("u_bit_depth", int(_control_bitdepth.get_value()))
	_viewport_container.material.set_shader_param("u_contrast", _control_contrast.get_value())
	_viewport_container.material.set_shader_param("u_offset", _control_offset.get_value())
	_viewport_container.material.set_shader_param("u_dither_size", int(_control_dithersize.get_value()))
	
func _on_Minimise_pressed():
	_debug_controls_tab_container.visible = !_debug_controls_tab_container.visible

func _on_Move_button_down():
	_moving_debug = true
	_debug_init_pos = _debug_controls.rect_position
	_moving_debug_press_start = get_viewport().get_mouse_position()

func _on_Move_button_up():
	_moving_debug = false

func _on_Checkbox_pressed():
	_viewport_container.material.set_shader_param("u_color_tex", palettes[0])
	_palette_preview.texture = palettes[0]

func _on_Checkbox2_pressed():
	_viewport_container.material.set_shader_param("u_color_tex", palettes[1])
	_palette_preview.texture = palettes[1]

func _on_Checkbox3_pressed():
	_viewport_container.material.set_shader_param("u_color_tex", palettes[2])
	_palette_preview.texture = palettes[2]

func _on_Checkbox4_pressed():
	_viewport_container.material.set_shader_param("u_color_tex", palettes[3])
	_palette_preview.texture = palettes[3]

func _on_Checkbox5_pressed():
	_viewport_container.material.set_shader_param("u_color_tex", palettes[4])
	_palette_preview.texture = palettes[4]

func _on_Dither1_pressed():
	_viewport_container.material.set_shader_param("u_dither_tex", dither_patterns[0])
	_dither_preview.texture = dither_patterns[0]
	_dither_label.text = "Bayer 16x16"

func _on_Dither2_pressed():
	_viewport_container.material.set_shader_param("u_dither_tex", dither_patterns[1])
	_dither_preview.texture = dither_patterns[1]
	_dither_label.text = "Bayer 8x8"

func _on_Dither3_pressed():
	_viewport_container.material.set_shader_param("u_dither_tex", dither_patterns[2])
	_dither_preview.texture = dither_patterns[2]
	_dither_label.text = "Bayer 4x4"

func _on_Dither4_pressed():
	_viewport_container.material.set_shader_param("u_dither_tex", dither_patterns[3])
	_dither_preview.texture = dither_patterns[3]
	_dither_label.text = "Bayer 2x2"

func _on_Dither5_pressed():
	_viewport_container.material.set_shader_param("u_dither_tex", dither_patterns[4])
	_dither_preview.texture = dither_patterns[4]
	_dither_label.text = "Blue Noise"
