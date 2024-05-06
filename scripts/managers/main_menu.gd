extends Control

var scene_path = "res://scenes/world_sea.tscn"
var prelude = "res://scenes/prelude.tscn"

func _ready():
	Utils.saveGame()
	Utils.loadGame()

func _on_play_pressed():
	if Game.is_played:
		get_tree().change_scene_to_file(scene_path)
	else: 
		get_tree().change_scene_to_file(prelude)

func _on_options_pressed():
	pass # Replace with function body.

func _on_quit_pressed():
	Utils.saveGame()
	get_tree().quit()
