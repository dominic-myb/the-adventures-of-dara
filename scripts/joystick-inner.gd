extends Sprite2D
@onready var parent = $".."

var pressing = false
@export var max_length = 50
@export var deadzone = 5

func _ready():
	max_length *= parent.scale.x

func _process(delta):
	if pressing:
		if get_global_mouse_position().distance_to(parent.global_position) <= max_length:
			global_position = get_global_mouse_position()
		else:
			var angle = parent.global_position.angle_to_point(get_global_mouse_position())
			global_position.x = parent.global_position.x + cos(angle)*max_length
			global_position.y = parent.global_position.y + sin(angle)*max_length
		calculate_vector()
	else:
		global_position = lerp(global_position, parent.global_position, delta*10)
		parent.vector_pos = Vector2(0,0)

func calculate_vector():
	if abs((global_position.x - parent.global_position.x)) >= deadzone:
		parent.vector_pos.x = (global_position.x - parent.global_position.x)/max_length
	if abs((global_position.y - parent.global_position.y)) >= deadzone:
		parent.vector_pos.y = (global_position.y - parent.global_position.y)/max_length

func _on_joystick_button_pressed():
	pressing = true

func _on_joystick_button_released():
	pressing = false
