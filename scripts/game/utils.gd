extends Node

const SAVE_PATH = "res://savegame.bin"

func saveGame():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var data: Dictionary = {
		"player_hp": Game.player_hp,
		"player_max_hp": Game.player_max_hp,
		"player_exp": Game.player_exp,
		"player_max_exp": Game.player_max_exp,
		"player_lvl": Game.player_lvl,
		"player_gold": Game.player_gold,
		"lvl_to_buff": Game.lvl_to_buff,
		"player_damage": Game.player_damage,
		"enemy_hp": Game.enemy_hp,
		"enemy_max_hp": Game.enemy_max_hp,
		"enemy_damage": Game.enemy_damage,
		"enemy_lvl": Game.enemy_lvl,
		"enemy_speed": Game.enemy_speed
	}
	var jstr = JSON.stringify(data)
	file.store_line(jstr)

func loadGame():
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if FileAccess.file_exists(SAVE_PATH) == true:
		if not file.eof_reached():
			var current_line = JSON.parse_string(file.get_line())
			if current_line:
				Game.player_hp = current_line["player_hp"]
				Game.player_max_hp = current_line["player_max_hp"]
				Game.player_exp = current_line["player_exp"]
				Game.player_max_exp = current_line["player_max_exp"]
				Game.player_lvl = current_line["player_lvl"]
				Game.player_gold = current_line["player_gold"]
				Game.lvl_to_buff = current_line["lvl_to_buff"]
				Game.player_damage = current_line["player_damage"]
				Game.enemy_hp = current_line["enemy_hp"]
				Game.enemy_max_hp = current_line["enemy_max_hp"]
				Game.enemy_damage = current_line["enemy_damage"]
				Game.enemy_lvl = current_line["enemy_lvl"]
				Game.enemy_speed = current_line["enemy_speed"]
