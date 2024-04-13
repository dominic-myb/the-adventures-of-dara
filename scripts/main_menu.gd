extends Node2D

func _ready():
	#Utils.saveGame()
	#Utils.loadGame()
	pass
func _on_play_pressed():
	get_node("AnimationPlayer").play("play")
	await get_node("AnimationPlayer").animation_finished
	get_tree().change_scene_to_file("res://scenes/world_sea.tscn")

func _on_load_pressed():
	get_node("AnimationPlayer").play("load")
	await get_node("AnimationPlayer").animation_finished
	#add here the scene for load game

func _on_quit_pressed():
	get_node("AnimationPlayer").play("quit")
	await get_node("AnimationPlayer").animation_finished
	get_tree().quit()
