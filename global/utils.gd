extends Node

const SAVE_PATH = "res://savegame.bin"

func saveGame():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var data: Dictionary = {
		"player_hp": Game.player_hp,
		"player_damage": Game.player_damage,
		"player_mana": Game.player_mana,
		"player_max_mana": Game.player_max_mana,
		"player_movespeed": Game.player_movespeed,
		"player_mana_regen_rate": Game.player_mana_regen_rate,
		"PLAYER_QUEST_LEVEL": Game.PLAYER_QUEST_LEVEL,
		"is_played": Game.is_played,
		"QUEST_STATUS": Game.QUEST_STATUS,
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
				Game.player_damage = current_line["player_damage"]
				Game.player_mana = current_line["player_mana"]
				Game.player_max_mana = current_line["player_max_mana"]
				Game.player_movespeed = current_line["player_movespeed"]
				Game.player_mana_regen_rate = current_line["player_mana_regen_rate"]
				Game.PLAYER_QUEST_LEVEL = current_line["PLAYER_QUEST_LEVEL"]
				Game.is_played = current_line["is_played"]
				Game.QUEST_STATUS = current_line["QUEST_STATUS"]
