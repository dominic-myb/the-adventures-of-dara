extends Node

signal buffed

var player_hp = 0
var player_max_hp = 10
var player_exp = 0
var player_max_exp = 100
var player_lvl = 1
var player_gold = 0
var lvl_to_buff = 5
var player_damage = 2 
var is_alive : bool = true #
var cam_pos : Vector2 #

var enemy_hp = 0
var enemy_max_hp = 10
var enemy_damage = 2
var enemy_lvl = 1
var enemy_speed = 100.0

var exp_to_get = 10

func _ready():
	player_hp = player_max_hp
	enemy_hp = enemy_max_hp
func _process(_delta):
	if player_exp >= player_max_exp:
		# leftover exps will be counted
		player_exp = player_exp - player_max_exp
		player_lvl += 1
		player_damage += 1
		enemy_damage += 1
		player_max_exp += 100
		print("Exp: ", Game.player_exp)
		print("Lvl: ", Game.player_lvl)
		print("MaxExp: ", Game.player_max_exp)
		# Utils.saveGame()
		# get_tree().change_scene_to_file("res://src/scenes/world_earth.tscn")
	if player_lvl >= lvl_to_buff:
		# every 5 levels buffs the perma health + heals
		# full health before adding max health for game difficulty
		player_hp = player_max_hp
		player_max_hp += 10
		lvl_to_buff += 5
		enemy_max_hp += 10
		enemy_hp = enemy_max_hp
		exp_to_get += 10
		buffed.emit()
