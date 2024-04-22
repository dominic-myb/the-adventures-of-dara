extends Control
@onready var anim = $ButtonsAnim
@onready var buttons_container = $CanvasLayer/ButtonsContainer
@onready var settings = $CanvasLayer/Settings

func _ready():
	Utils.saveGame()
	Utils.loadGame()
	#connect("is_pressed", _on_exit_pressed)
func _on_play_pressed():
	anim.play("play")
	await anim.animation_finished
	get_tree().change_scene_to_file("res://scenes/world_sea.tscn")

func _on_load_pressed():
	anim.play("load")
	await anim.animation_finished
	settings.show()
	print("showed")
func _on_quit_pressed():
	anim.play("quit")
	await anim.animation_finished
	Utils.saveGame()
	get_tree().quit()

