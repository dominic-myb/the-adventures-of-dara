extends Control

const SCENE_PATH = "res://scenes/main_scenes/sea.tscn"
const PRELUDE = "res://scenes/main_scenes/prelude.tscn"

func _ready():
	Utils.saveGame()
	Utils.loadGame()

func _on_play_pressed():
	#if Game.is_played:
		#get_tree().change_scene_to_file(SCENE_PATH)
	#else: 
	get_tree().change_scene_to_file(PRELUDE)

func _on_options_pressed():
	pass # Replace with function body.

func _on_quit_pressed():
	Utils.saveGame()
	get_tree().quit()
