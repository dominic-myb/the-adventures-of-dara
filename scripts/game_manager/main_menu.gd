extends Control

var scene_path = "res://scenes/world_sea.tscn"
@onready var play = $CanvasLayer/VBoxContainer/Play
@onready var options = $CanvasLayer/VBoxContainer/Options
@onready var quit = $CanvasLayer/VBoxContainer/Quit

func _ready():
	Utils.saveGame()
	Utils.loadGame()


func _on_play_button_pressed():
	play.play("pressed")
	await play.animation_finished
	get_tree().change_scene_to_file(scene_path)


func _on_options_button_pressed():
	options.play("pressed")
	await options.animation_finished


func _on_quit_button_pressed():
	quit.play("pressed")
	await quit.animation_finished
	Utils.saveGame()
	get_tree().quit()





