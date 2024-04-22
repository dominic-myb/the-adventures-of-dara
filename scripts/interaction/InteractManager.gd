extends Node
@onready var joystick = $"../CanvasLayer/LeftControls/Joystick"
@onready var attack_anim = $"../CanvasLayer/RightControls/Buttons/AttackAnim"
@onready var interact_anim = $"../CanvasLayer/RightControls/Buttons/InteractAnim"
@onready var quest_box = $"../CanvasLayer/CenterContainer/QuestBox"
@onready var exit = $"../CanvasLayer/CenterContainer/QuestBox/TextureRect/Exit"

var is_pressed : bool
var in_range : bool
func _ready():
	pass
func _process(_delta):
	interact_anim.visible = in_range
	quest_box.visible = is_pressed

func _on_interaction_area_body_entered(body):
	if body.is_in_group("Player"):
		in_range = true

func _on_interaction_area_body_exited(body):
	if body.is_in_group("Player"):
		in_range = false

func _on_interact_pressed():
	is_pressed = true

