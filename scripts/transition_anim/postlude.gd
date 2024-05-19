extends Control
# ADD THE BUTTONS FOR SKIP?
@onready var anim = $AnimationPlayer

func _ready():
	anim.play("postlude")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "postlude":
		get_tree().change_scene_to_file("res://scenes/main_scenes/main_menu.tscn")
