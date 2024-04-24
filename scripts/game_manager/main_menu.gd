extends Control

var scene_path = "res://scenes/world_sea.tscn"

func _ready():
	Utils.saveGame()
	Utils.loadGame()

func _on_play_pressed():
	get_tree().change_scene_to_file(scene_path)

func _on_options_pressed():
	pass # Replace with function body.

func _on_quit_pressed():
	Utils.saveGame()
	get_tree().quit()
