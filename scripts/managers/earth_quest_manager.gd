extends Node
# ADD ALL THE UI, DESIGNS THAT WILL BE APPEARING IN THE GAME IF
# UNLOCKED, LOCKED, ACCEPT, DONE, [ENABLE, DISABLE] BASE ON Q NUM
signal accepted(_num: int)
signal unlocked(_num: int)
signal failed(_num: int)
signal done(_num: int)
signal zero_hp

const PLAYER_IMG = preload("res://art/player/player-img.png")
const LOLA_IMG = preload("res://art/npc/lola/lola-img.png")
const BATA_IMG = preload("res://art/npc/bata/bata-img.png")
const RECIPE = preload("res://scenes/quests/quest5/recipe.tscn")

enum QUEST_STATUS{
	LOCKED, UNLOCKED, ACCEPTED, DONE
}
enum NPCS{
	LOLA=3, LOLA2, BATA
}
enum QUEST_LEVEL{
	Q4=3, Q5, Q6
}

var NPC_QUEST_STATUS = {
	NPCS.LOLA:{
		"status": QUEST_STATUS.UNLOCKED,
		"level": QUEST_LEVEL.Q4
	},
	NPCS.LOLA2:{
		"status": QUEST_STATUS.LOCKED,
		"level": QUEST_LEVEL.Q5
	},
	NPCS.BATA:{
		"status": QUEST_STATUS.LOCKED,
		"level": QUEST_LEVEL.Q6
	}
}
var has_active_quest: bool
var lines: Array[String] = []
var pictures : Array[Texture2D] = []
var lines_counter: int = 0
var active_npc: int

@onready var next_btn = %Next
@onready var back_btn = %Back
@onready var skip_btn = %Skip
@onready var house = $"../Quest/House"
@onready var player = $"../Player/Player"
@onready var conversation_box = $"../CanvasLayer/Conversation"
@onready var action_buttons = $"../CanvasLayer/ActionButtons"
@onready var lines_holder = $"../CanvasLayer/Conversation/MarginContainer/LinesCon/LinesHolder"
@onready var picture = $"../CanvasLayer/Conversation/MarginContainer/LinesCon/Picture"
@onready var interact = $"../CanvasLayer/ActionButtons/Interact"
@onready var recipe_pos = $"../Quest/RecipePos"
@onready var bounds = $"../Bounds"
@onready var quest_5 = $"../CanvasLayer/Quest5"

@onready var game_over = $"../CanvasLayer/GameOver"
@onready var retry = $"../CanvasLayer/GameOver/MarginContainer/VBoxContainer/HBoxContainer/Retry"
@onready var home = $"../CanvasLayer/GameOver/MarginContainer/VBoxContainer/HBoxContainer/Home"

@onready var pos_1 = $"../RespawnPoints/Pos1"
@onready var pos_2 = $"../RespawnPoints/Pos2"
@onready var pos_3 = $"../RespawnPoints/Pos3"

func _ready():
	game_over.visible = false
	interact_btn(interact, false)
	next_btn = get_node("%Next")
	back_btn = get_node("%Back")
	skip_btn = get_node("%Skip")
	bounds.connect("failed", quest_failed)
	bounds.connect("out", on_out_of_bounds)
	retry.connect("pressed", on_retry)
	home.connect("pressed", on_home)
	accepted.connect(quest_accepted)
	accepted.connect(quest)
	zero_hp.connect(on_zero_hp)
	# connect 2 quest done

func buttons_connect():
	next_btn.connect("pressed", on_next_pressed)
	back_btn.connect("pressed", on_back_pressed)
	skip_btn.connect("pressed", on_skip_pressed)

func buttons_disconnect():
	next_btn.disconnect("pressed", on_next_pressed)
	back_btn.disconnect("pressed", on_back_pressed)
	skip_btn.disconnect("pressed", on_skip_pressed)
	
func conversation(panel: PanelContainer, value: bool):
	panel.visible = value

func controls(container: Node2D, value: bool):
	container.visible = value

func interact_btn(button: TouchScreenButton, value: bool):
	button.visible = value

func line_controller(_pictures: TextureRect):
	_pictures.texture = pictures[lines_counter]
	lines_holder.text = lines[lines_counter]

func on_interact_pressed():
	player.can_move = false
	convo_manager()
	controls(action_buttons, false)
	conversation(conversation_box, true)
	line_controller(picture)

func on_next_pressed():
	lines_counter += 1
	if lines_counter >= lines.size():
		player.can_move = true
		conversation(conversation_box, false)
		controls(action_buttons, true)
		lines_counter = 0
		if NPC_QUEST_STATUS[active_npc]["status"] == QUEST_STATUS.UNLOCKED and not has_active_quest:
			NPC_QUEST_STATUS[active_npc]["status"] = QUEST_STATUS.ACCEPTED
			accepted.emit(active_npc)
	else:
		line_controller(picture)

func on_back_pressed():
	lines_counter -= 1
	if lines_counter < 0:
		lines_counter = 0
	else:
		line_controller(picture)

func on_skip_pressed():
	convo_manager()
	conversation(conversation_box, false)
	controls(action_buttons, true)
	if NPC_QUEST_STATUS[active_npc]["status"] == QUEST_STATUS.UNLOCKED and not has_active_quest:
		NPC_QUEST_STATUS[active_npc]["status"] = QUEST_STATUS.ACCEPTED
		accepted.emit(active_npc)
		has_active_quest = true
	player.can_move = true

func quest(_num: int):
	
	if Game.PLAYER_QUEST_LEVEL == 3 and quest_accepted(_num):
		player.lock_shoot = false
		house.enable_collider = false
		house.connect("done", quest_done)
		
	elif Game.PLAYER_QUEST_LEVEL == 4 and quest_accepted(_num):
		var recipe = RECIPE.instantiate()
		recipe.position = recipe_pos.global_position
		recipe.connect("done", quest_done)
		recipe.connect("failed", quest_failed)
		get_tree().get_first_node_in_group("QuestItems").add_child(recipe)
		
	elif Game.PLAYER_QUEST_LEVEL == 5 and quest_accepted(_num):
		quest_5.visible = true
		quest_5.on_shuffle()
		quest_5.connect("done", quest_done)
		quest_5.connect("failed", quest_failed)
		action_buttons.visible = false

func quest_accepted(_num: int):
	if _num == Game.PLAYER_QUEST_LEVEL:
		NPC_QUEST_STATUS[_num]["status"] = QUEST_STATUS.ACCEPTED
		has_active_quest = true
		return true

func quest_failed(_num: int):
	if has_active_quest:
		if Game.PLAYER_QUEST_LEVEL == 3:
			house.disconnect("done", quest_done)
		elif Game.PLAYER_QUEST_LEVEL == 5:
			quest_5.disconnect("done", quest_done)
			quest_5.disconnect("failed", quest_failed)
			action_buttons.visible = true
		has_active_quest = false
		NPC_QUEST_STATUS[_num]["status"] = QUEST_STATUS.UNLOCKED
		failed.emit(_num)
		Game.player_hp -= 1

func quest_done(_num: int):
	if Game.PLAYER_QUEST_LEVEL == _num:
		if _num < 5:
			NPC_QUEST_STATUS[_num+1]["status"] = QUEST_STATUS.UNLOCKED
		Game.QUEST_STATUS["Q"+"%s"%(_num+1)] = true
		Game.PLAYER_QUEST_LEVEL += 1
		has_active_quest = false
		if Game.PLAYER_QUEST_LEVEL == 6:
			action_buttons.visible = true
		done.emit(_num)

func on_zero_hp():
	if Game.player_hp == 0:
		has_active_quest = false
		Game.PLAYER_QUEST_LEVEL = 3
		Game._QUEST_STATUS["Q4"] = false
		Game._QUEST_STATUS["Q5"] = false
		Game._QUEST_STATUS["Q6"] = false
		game_over.title_content = "Game Over!"

func on_out_of_bounds(_num: int):
	if not has_active_quest:
		Game.player_hp -= 1
	game_over.title_content = "Retry!"
	game_over.visible = true
	player.can_move = false
	player.lock_shoot = true
	
func on_retry():
	if Game.PLAYER_QUEST_LEVEL == 3:
		player.global_position = pos_1.global_position
	elif Game.PLAYER_QUEST_LEVEL == 4:
		player.global_position = pos_2.global_position
	elif Game.PLAYER_QUEST_LEVEL == 5:
		player.global_position = pos_3.global_position
	player.visible = true
	game_over.visible = false
	player.can_move = true
	if Game.player_hp == 0:
		Game.player_hp = 3
	
func on_home():
	get_tree().change_scene_to_file("res://scenes/main_scenes/main_menu.tscn")

func on_confirmation():
	pass

func convo_manager():
	lines_counter = 0
	if active_npc == NPCS.LOLA and NPC_QUEST_STATUS[active_npc]["status"] == QUEST_STATUS.LOCKED:
		lines = [
			"Hindi ka pa handa para dito!?"
		]
		pictures = [
			LOLA_IMG
		]
	elif active_npc == NPCS.LOLA2 and NPC_QUEST_STATUS[active_npc]["status"] == QUEST_STATUS.LOCKED:
		lines = [
			"Hindi ka pa handa para dito!"
		]
		pictures = [
			LOLA_IMG
		]
	elif active_npc == NPCS.BATA and NPC_QUEST_STATUS[active_npc]["status"] == QUEST_STATUS.LOCKED:
		lines = [
			"Hindi ka pa handa para dito!"
		]
		pictures = [
			BATA_IMG
		]
	elif active_npc == NPCS.LOLA and NPC_QUEST_STATUS[active_npc]["status"] == QUEST_STATUS.UNLOCKED:
		lines = [
			"Inay, ano ang iyong problema?",
			"Anak, kasalukuyang nasusunog ang mga bahay sa ating bayan",
			"Maraming mga tao ang nangagnailangan ng tulong",
			"Maari mo bang tulungan ang mga taong maapula ang apoy?",
			"Opo inay, gagawin ko po ang aking makakaya!"
		]
		pictures = [
			PLAYER_IMG,
			LOLA_IMG,
			LOLA_IMG,
			LOLA_IMG,
			PLAYER_IMG
		]
	elif active_npc == NPCS.LOLA and NPC_QUEST_STATUS[active_npc]["status"] == QUEST_STATUS.ACCEPTED:
		lines = [
			"Pakitulungang apulahin ang apoy sa mga kabahayan, Anak",
			"Makakaasa po kayo!"
		]
		pictures = [
			LOLA_IMG,
			PLAYER_IMG
		]
	elif active_npc == NPCS.LOLA and NPC_QUEST_STATUS[active_npc]["status"] == QUEST_STATUS.DONE:
		lines = [
			"Inay natulungan ko na po ang mga taong apulahin ang apoy na sumusunog sakanilang mga bahay!",
			"Maraming salamat saiyo anak!",
			"Dahil sa iyong mabuting kalooban maraming tao ang naisalba",
			"Walang anuman po inay!",
			"Tanggapin mo itong resipi na ipinagmamali ng ating bayan!",
			"Ito ang resipi ng Pawa, and pawa ang pagkain na nagmula sa ating bayan.",
			"Malugod ko pong tinatanggap ito inay!"
		]
		pictures = [
			PLAYER_IMG,
			LOLA_IMG,
			LOLA_IMG,
			PLAYER_IMG,
			LOLA_IMG,
			LOLA_IMG,
			PLAYER_IMG
		]
	elif active_npc == NPCS.LOLA2 and NPC_QUEST_STATUS[active_npc]["status"] == QUEST_STATUS.UNLOCKED:
		lines = [
			"LOLA2"
		]
		pictures = [
			LOLA_IMG
		]
	elif active_npc == NPCS.LOLA2 and NPC_QUEST_STATUS[active_npc]["status"] == QUEST_STATUS.ACCEPTED:
		lines = [
			"LOLA2"
		]
		pictures = [
			LOLA_IMG
		]
	elif active_npc == NPCS.LOLA2 and NPC_QUEST_STATUS[active_npc]["status"] == QUEST_STATUS.DONE:
		lines = [
			"LOLA2"
		]
		pictures = [
			LOLA_IMG
		]
	elif active_npc == NPCS.BATA and NPC_QUEST_STATUS[active_npc]["status"] == QUEST_STATUS.UNLOCKED:
		lines = [
			"Bata ano ang iyong problema?",
			"Ako po ay nagugutom!",
			"Kahapon pa pong hindi umuuwi ang aking mga magulang galing sa sakahan",
			"Ganoon ba!",
			"Kahabag-habag naman ang iyong dinaranas!",
			"Sandali lamang bata, at hahanapin ko ang mga sangkap ng resipi na aking natanggap kanina."
		]
		pictures = [
			PLAYER_IMG,
			BATA_IMG,
			BATA_IMG,
			PLAYER_IMG,
			PLAYER_IMG,
			PLAYER_IMG
		]
	elif active_npc == NPCS.BATA and NPC_QUEST_STATUS[active_npc]["status"] == QUEST_STATUS.ACCEPTED:
		lines = [
			"Mmmm. mukhang masarap po ang inyong ginagawang pawa"
		]
		pictures = [
			BATA_IMG
		]
	elif active_npc == NPCS.BATA and NPC_QUEST_STATUS[active_npc]["status"] == QUEST_STATUS.DONE:
		lines = [
			"Maraming salamat po sa pagkain!",
			"Ito na ata ang pinaka masarap na pawa na aking natikman!",
			"Walang ano man bata",
			"Naway makauwi na ang iyong mga magulang upang ikaw ay hindi na magutom muli!",
			"Maraming salamat po ulit!"
		]
		pictures = [
			BATA_IMG,
			BATA_IMG,
			PLAYER_IMG,
			PLAYER_IMG,
			BATA_IMG
		]

func _on_lola_body_entered(body):
	if body.is_in_group("Player"):
		if Game.PLAYER_QUEST_LEVEL == 3:
			active_npc = NPCS.LOLA
		elif Game.PLAYER_QUEST_LEVEL == 4:
			active_npc = NPCS.LOLA2
		interact_btn(interact, true)
		interact.connect("pressed", on_interact_pressed)
		buttons_connect()

func _on_lola_body_exited(body):
	if body.is_in_group("Player"):
		interact_btn(interact, false)
		interact.disconnect("pressed", on_interact_pressed)
		buttons_disconnect()

func _on_bata_body_entered(body):
	if body.is_in_group("Player"):
		active_npc = NPCS.BATA
		interact_btn(interact, true)
		interact.connect("pressed", on_interact_pressed)
		buttons_connect()

func _on_bata_body_exited(body):
	if body.is_in_group("Player"):
		interact_btn(interact, false)
		interact.disconnect("pressed", on_interact_pressed)
		buttons_disconnect()
