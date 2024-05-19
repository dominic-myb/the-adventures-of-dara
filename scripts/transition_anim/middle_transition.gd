extends Control
const SCENE_PATH = "res://scenes/main_scenes/world_earth.tscn"
@onready var skip = $VBoxContainer/Skip
@onready var anim = $AnimationPlayer

func _ready():
	skip.connect("pressed",_on_skip_pressed)
	
func _process(_delta):
	anim.play("middle_transition")

func _on_skip_pressed():
	get_tree().change_scene_to_file(SCENE_PATH)

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "middle_transition":
		get_tree().change_scene_to_file(SCENE_PATH)
