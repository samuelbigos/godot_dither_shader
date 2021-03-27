extends Spatial

var _timer = 0.0

onready var _viewport = get_node("ViewportContainer/Viewport")
onready var _sphere = get_node("ViewportContainer/Viewport/Primitives/Sphere")
onready var _cube = get_node("ViewportContainer/Viewport/Primitives/Cube")
onready var _prism = get_node("ViewportContainer/Viewport/Primitives/Prism")

func _ready():
	_viewport.size = get_viewport().size

func _process(delta):
	_timer += delta
	
	_sphere.transform.origin.y = 2.5 + sin(_timer) * 1.0
	_cube.transform.origin.y = 2.5 + sin(_timer + PI * 0.5) * 1.0
	_prism.transform.origin.y = 2.5 + sin(_timer + PI) * 1.0
	
	_cube.rotation.y = _timer
	_prism.rotation.z = _timer
