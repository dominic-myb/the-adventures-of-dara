extends Node
"""
ADD A DETECTOR IF THE QUEST IS FULFILLED
THEN SIGNAL DONE, CONNECT THE QUEST MANAGER
TO THE DONE SIGNAL WITH PARAM(Q_NUM) WHICH IS
THE PREV ACCEPTED(Q_NUM), STORE IN A TEMP VAR
"""
signal done
enum ENEMIES {
	OCTO,
	EEL,
	SHARK,
	BIG_SHARK
}
var ememies = {
	ENEMIES.OCTO:{
		"kills": 0
	},
	ENEMIES.EEL:{
		"kills": 0
	},
	ENEMIES.SHARK:{
		"kills": 0
	},
	ENEMIES.BIG_SHARK:{
		"kills": 0
	}
}
@onready var quest_manager = $"../QuestManager"
@onready var death_cam = $"../Player/Camera2D"
@onready var alive_cam = $"../Player/Player/Camera2D"
func _ready():
	quest_manager.connect("accepted", on_accept)
func _process(_delta):
	if Game.is_alive:
		Game.cam_pos = alive_cam.position
	elif not Game.is_alive:
		on_player_death(Game.cam_pos)
func on_accept(quest: int):
	if quest == 0:
		print("Im working!")
func on_player_death(pos: Vector2):
	death_cam.position = pos
	death_cam.visible = true
