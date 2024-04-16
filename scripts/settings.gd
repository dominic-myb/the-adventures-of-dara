extends Node
@onready var joystick = $"../CanvasLayer/HBoxContainer/Joystick"
@onready var attack_button = $"../CanvasLayer/HBoxContainer2/Attack Button"
@onready var clam = $"../NPC/Clam"
var is_visible := true
func _ready():
	#clam_anim = get_child(clam)
	pass
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		is_visible = true
	on_buttons_hide(is_visible)
func on_buttons_hide(value : bool):
	joystick.visible = value
	attack_button.visible = value
func _on_clam_body_entered(body):
	if body.is_in_group("Player"):
		is_visible = false

