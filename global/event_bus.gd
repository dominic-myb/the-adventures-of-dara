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
var player : CharacterBody2D
@onready var quest_manager = $"../QuestManager"
@onready var death_cam = $"../Player/Marker2D/Camera2D"
@onready var alive_cam = $"../Player/Player/Camera2D"
@onready var marker_2d = $"../Player/Marker2D"
var player_pos
func _ready():
	Game.is_played = true
	Utils.saveGame()
	player = get_tree().get_first_node_in_group("Player")
	quest_manager.connect("accepted", on_accept)
	player.game_over.connect(on_player_death)

func _process(_delta):
	if player:
		if not player:
			return
		player_pos = player.global_position
	if not Game.is_alive:
		on_player_death()

func on_accept(quest: int):
	if quest == 0:
		print("Im working!")

func on_player_death():
	marker_2d.position = player_pos
	death_cam.visible = true
	
func on_enemy_death(pos: Vector2):
	const movespeed = preload("res://scenes/items/movespeed_buff.tscn")
	const mana = preload("res://scenes/items/mana_regen_buff.tscn")
	const damage = preload("res://scenes/items/damage_buff.tscn")
	randomize()
	var random_f = randf()
	print(random_f)
	var item : Node
	if random_f < 0.3:
		item = movespeed.instantiate()
	elif random_f < 0.95:
		item = mana.instantiate()
	else:
		item = damage.instantiate()
	get_tree().get_first_node_in_group("Powerups").add_child(item)
	item.position = pos
