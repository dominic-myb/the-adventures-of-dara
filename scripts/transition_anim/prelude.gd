extends Control

const SCENE_PATH = "res://scenes/main_scenes/sea.tscn"
@onready var anim = $AnimationPlayer
@onready var skip = $VBoxContainer/Skip

func _ready():
	skip.connect("pressed",_on_skip_pressed)

func _process(_delta):
	anim.play("prelude")
	
func _on_skip_pressed():
	get_tree().change_scene_to_file(SCENE_PATH)
	
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "prelude":
		get_tree().change_scene_to_file(SCENE_PATH)
