extends Control

const SEA = "res://scenes/main_scenes/sea.tscn"
const WORLD_EARTH = "res://scenes/main_scenes/world_earth.tscn"
const PRELUDE = "res://scenes/main_scenes/prelude.tscn"

@onready var sfx = $Music
@onready var bg = $PanelContainer
@onready var settings = $Settings
@onready var back = $Settings/Back

func _ready():
	bg.visible = false
	settings.visible = false
	back.connect("pressed", on_back_pressed)
	sfx.play()
	Utils.saveGame()
	Utils.loadGame()

func _on_play_pressed():
	if Game.PLAYER_QUEST_LEVEL >= 3:
		get_tree().change_scene_to_file(WORLD_EARTH)
	elif Game.PLAYER_QUEST_LEVEL >= 1:
		get_tree().change_scene_to_file(SEA)
	else:
		get_tree().change_scene_to_file(PRELUDE)

func _on_options_pressed():
	bg.visible = true
	settings.visible = true

func _on_quit_pressed():
	Utils.saveGame()
	get_tree().quit()

func _on_sfx_finished():
	sfx.play()

func on_back_pressed():
	bg.visible = false
	settings.visible = false

func _on_master_value_changed(value):
	volume(0, value)

func _on_music_value_changed(value):
	volume(1, value)

func _on_sound_fx_value_changed(value):
	volume(2, value)

func volume(bus_index, value):
	AudioServer.set_bus_volume_db(bus_index, value)
