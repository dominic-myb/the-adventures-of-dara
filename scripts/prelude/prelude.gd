extends Control

const SCENE_PATH = "res://scenes/main_scenes/sea.tscn"
@onready var anim = $AnimationPlayer

func _ready():
	anim.play("prelude")

func _on_skip_pressed():
	get_tree().change_scene_to_file(SCENE_PATH)
