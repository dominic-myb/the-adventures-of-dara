extends Node2D

@onready var video = $VideoStreamPlayer
@onready var camera = $Camera2D
var scene_path = "res://scenes/world_sea.tscn"

func _ready():
	camera.zoom = Vector2(0.619,0.6)

func _on_skip_pressed():
	get_tree().change_scene_to_file(scene_path)
