extends Node

# PLAYER_ATTRIB
var player_hp = 3
var player_mana = 0
var player_max_mana = 100
var player_damage = 2 
var player_movespeed : float = 600.00 
var player_mana_regen_rate : float 
var PLAYER_QUEST_LEVEL : int = 0

var is_played : bool = false 
var QUEST_STATUS = {
	"Q1": false,
	"Q2": false,
	"Q3": false,
	"Q4": false,
	"Q5": false,
	"Q6": false
}

func _ready():
	#Utils.loadGame()
	player_mana = player_max_mana

func _process(delta):
	player_mana_regen_rate = delta
