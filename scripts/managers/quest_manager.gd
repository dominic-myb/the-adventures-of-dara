extends Node

signal pressed
signal accepted(num: int)
signal unlocked(num: int)

enum QUEST_LEVEL { Q1, Q2,Q3
}

enum QUEST_STATUS { LOCKED, UNLOCKED, ACCEPTED,DONE
}

enum NPC { DALAG, PAWIKAN, KABIBE
}

const QUEST2 = preload("res://scenes/quests/quest2.tscn")
const PEARL = preload("res://scenes/quests/pearl.tscn")
const BOULDER = preload("res://scenes/quests/boulder/boulder.tscn")
const PLAYER_IMG = preload("res://art/package-icon/ICON.png")
const DALAG_IMG = preload("res://art/npc//dalag/dalag-pic.png")
const PAWIKAN_IMG = preload("res://art/npc/pawikan/pawikan-pic.png")
const KABIBE_IMG = preload("res://art/npc/kabibe/clam-pic.png")

# must load this 
var NPC_QUEST_STATUS = {
	NPC.DALAG:{
		"status" : QUEST_STATUS.UNLOCKED,
		"level" : QUEST_LEVEL.Q1
	},
	NPC.PAWIKAN:{
		"status" : QUEST_STATUS.LOCKED,
		"level" : QUEST_LEVEL.Q2
	},
	NPC.KABIBE:{
		"status" : QUEST_STATUS.LOCKED,
		"level" : QUEST_LEVEL.Q3
	}
}

var next_btn : TextureButton
var back_btn : TextureButton
var skip_btn : TextureButton

var lines_counter : int = 0
var lines : Array[String] = []
var pictures : Array[Texture2D] = []

var has_active_quest : bool 
var active_npc : int

@onready var interact = $"../CanvasLayer/RightButtonContainer/RightButtons/Interact"
@onready var conversation_box = $"../CanvasLayer/Conversation"
@onready var lines_holder = $"../CanvasLayer/Conversation/MarginContainer/LinesCon/LinesHolder"
@onready var joystick = $"../CanvasLayer/JoystickContainer"
@onready var right_buttons = $"../CanvasLayer/RightButtonContainer"
@onready var picture = $"../CanvasLayer/Conversation/MarginContainer/LinesCon/Picture"
@onready var quest_items = $"../Player/Player/Basket"
@onready var quest_3 = $"../Quest3"

@onready var player = $"../Player/Player"

@onready var kabibe = $"../NPC/Kabibe"
@onready var pawikan = $"../NPC/Pawikan"
@onready var dalag = $"../NPC/Dalag"

func _ready():
	unlocked.connect(quest_unlocked)
	if Game.PLAYER_QUEST_LEVEL == 0:
		unlocked.emit(0)
	quest_items.hide()
	accepted.connect(quest)
	
	interact.visible = false
	conversation_box.visible = false
	
	next_btn = get_node("%Next")
	back_btn = get_node("%Back")
	skip_btn = get_node("%Skip")
	
"""
START OF BUTTON MANAGER
"""
func buttons_connect():
	next_btn.connect("pressed", on_next_pressed)
	back_btn.connect("pressed", on_back_pressed)
	skip_btn.connect("pressed", on_skip_pressed)

func buttons_disconnect():
	next_btn.disconnect("pressed", on_next_pressed)
	back_btn.disconnect("pressed", on_back_pressed)
	skip_btn.disconnect("pressed", on_skip_pressed)

func on_out_of_range():
	controls(joystick, right_buttons, true)
	conversation(conversation_box, false)

func on_interact_pressed():
	player.can_move = false
	convo_manager()
	controls(joystick, right_buttons, false)
	conversation(conversation_box, true)
	line_controller(picture)

func on_next_pressed():
	lines_counter += 1
	if lines_counter >= lines.size():
		player.can_move = true
		conversation(conversation_box, false)
		controls(joystick, right_buttons, true)
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
	controls(joystick, right_buttons, true)
	if NPC_QUEST_STATUS[active_npc]["status"] == QUEST_STATUS.UNLOCKED and not has_active_quest:
		NPC_QUEST_STATUS[active_npc]["status"] = QUEST_STATUS.ACCEPTED
		accepted.emit(active_npc)
		has_active_quest = true
	player.can_move = true

func controls(container1: HBoxContainer, container2: HBoxContainer, value: bool):
	container1.visible = value
	container2.visible = value

func conversation(panel: PanelContainer, value: bool):
	panel.visible = value

func interact_btn(btn: TouchScreenButton, value: bool):
	btn.visible = value

"""
START OF CONVERSATION MANAGER
"""
func line_controller(_pictures: TextureRect):
	_pictures.texture = pictures[lines_counter]
	lines_holder.text = lines[lines_counter]

func convo_manager():
	lines_counter = 0
	if active_npc == NPC.DALAG and NPC_QUEST_STATUS[active_npc]["status"] == QUEST_STATUS.LOCKED:
			lines = [
				"Hindi ka pa handa para dito!"
			]
			pictures = [
				DALAG_IMG
			]
	elif active_npc == NPC.PAWIKAN and NPC_QUEST_STATUS[active_npc]["status"] == QUEST_STATUS.LOCKED:
			lines = [
				"Hindi ka pa handa para dito!"
			]
			pictures = [
				PAWIKAN_IMG
			]
	elif active_npc == NPC.KABIBE and NPC_QUEST_STATUS[active_npc]["status"] == QUEST_STATUS.LOCKED:
			lines = [
				"Hindi ka pa handa para dito!"
			]
			pictures = [
				KABIBE_IMG
			]
	elif active_npc == NPC.DALAG and NPC_QUEST_STATUS[active_npc]["status"] == QUEST_STATUS.UNLOCKED:
		lines = [
			"Kaibigan, saan ka patungo?",
			"At mukhang kaybigat ng iyong dala?",
			"Kaibigan para ito sa aking mahal na ina na may sakit",
			"Kay saklap naman ng sinapit ng iyong ina kaibigan",
			"Oo nga kaibigan.",
			"Kailangan kong dikdikin ang mga batong ito at paghaluhaluin",
			"nang sa gayon ay mapagaling ko ang aking ina.",
			"Mahihirapan ka niyan at pagdating mo sa iyong paroroonan ay...",
			"baka hindi mo na madikdik ang bato at pagod ka na sa iyong paglalakbay, ",
			"atin nang pagtulungan at dikdikin ang mga bato para ipainom sa iyong maysakit na ina"
		]
		pictures = [
			PLAYER_IMG,
			PLAYER_IMG,
			DALAG_IMG,
			PLAYER_IMG,
			DALAG_IMG,
			DALAG_IMG,
			DALAG_IMG,
			PLAYER_IMG,
			PLAYER_IMG,
			PLAYER_IMG
		]
	elif active_npc == NPC.DALAG and NPC_QUEST_STATUS[active_npc]["status"] == QUEST_STATUS.ACCEPTED:
		lines = [
			"Tulungan mo akong dikdikin ang bato",
			"Tutulungan kita"
		]
		pictures = [
			DALAG_IMG,
			PLAYER_IMG
		]
	elif active_npc == NPC.DALAG and NPC_QUEST_STATUS[active_npc]["status"] == QUEST_STATUS.DONE:
		lines = [
			"Maraming salamat, Dara",
			"Walang anuman, humayo ka na para mapainom mo na ng gamot ang iyong ina"
		]
		pictures = [
			DALAG_IMG,
			PLAYER_IMG
		]
	elif active_npc == NPC.PAWIKAN and NPC_QUEST_STATUS[active_npc]["status"] == QUEST_STATUS.UNLOCKED:
		lines = [
			"I Have a favor to you, Dara!",
			"What is it?",
			"I Want you to kill the eel",
			"Roger!"
		]
		pictures = [
			PAWIKAN_IMG,
			PLAYER_IMG,
			PAWIKAN_IMG,
			PLAYER_IMG
		]
	elif active_npc == NPC.PAWIKAN and NPC_QUEST_STATUS[active_npc]["status"] == QUEST_STATUS.ACCEPTED:
		lines = [
			"Remember that you need  to kill the eel",
			"Roger!"
		]
		pictures = [
			PAWIKAN_IMG,
			PLAYER_IMG
		]
	elif active_npc == NPC.PAWIKAN and  NPC_QUEST_STATUS[active_npc]["status"] == QUEST_STATUS.DONE:
		lines = [
			"Thank you, Dara",
			"Welcome!"
		]
		pictures = [
			PAWIKAN_IMG,
			PLAYER_IMG
		]
	elif active_npc == NPC.KABIBE and NPC_QUEST_STATUS[active_npc]["status"] == QUEST_STATUS.UNLOCKED:
		lines = [
			"I Have a favor to you, Dara!",
			"What is it?",
			"I Want you to kill the eel",
			"Roger!"
		]
		pictures = [
			KABIBE_IMG,
			PLAYER_IMG,
			KABIBE_IMG,
			PLAYER_IMG
		]
	elif active_npc == NPC.KABIBE and NPC_QUEST_STATUS[active_npc]["status"] == QUEST_STATUS.ACCEPTED:
		lines = [
			"Remember that you need  to kill the eel",
			"Roger!"
		]
		pictures = [
			KABIBE_IMG,
			PLAYER_IMG
		]
	elif active_npc == NPC.KABIBE and  NPC_QUEST_STATUS[active_npc]["status"] == QUEST_STATUS.DONE:
		lines = [
			"Thank you, Dara",
			"Welcome!"
		]
		pictures = [
			KABIBE_IMG,
			PLAYER_IMG
		]
	
"""
START OF QUEST MANAGER
"""
		
func quest(_num: int):
	if Game.PLAYER_QUEST_LEVEL == 0 and quest_accepted(_num):
		# DALAG
		var boulder = BOULDER.instantiate()
		boulder.position = dalag.global_position
		get_tree().get_first_node_in_group("QuestItems").add_child(boulder)
		boulder.done.connect(quest_done)
		
	elif Game.PLAYER_QUEST_LEVEL == 1 and quest_accepted(_num):
		# PAWIKAN
		#pawikan.bubble_enabled = true
		var _quest2 = QUEST2.instantiate()
		_quest2.position = Vector2(2684, -2498)
		get_tree().get_first_node_in_group("World").add_child(_quest2)
		quest_items.show()
		_quest2.done.connect(quest_done)
		#quest_1.show()
	elif Game.PLAYER_QUEST_LEVEL == 2 and quest_accepted(_num):
		# KABIBE
		var pearl = PEARL.instantiate()
		randomize()
		var random_float = randf()
		if random_float < 0.25:
			pearl.position = quest_3.pos_1
		elif random_float < 0.50:
			pearl.position = quest_3.pos_2
		elif random_float < 0.75:
			pearl.position = quest_3.pos_3
		elif random_float < 1.00:
			pearl.position = quest_3.pos_4
		get_tree().get_first_node_in_group("QuestItems").add_child(pearl)
		pearl.done.connect(quest_done)
	elif Game.PLAYER_QUEST_LEVEL == 3 and quest_accepted(_num):
		pass
	elif Game.PLAYER_QUEST_LEVEL == 4 and quest_accepted(_num):
		pass
	elif Game.PLAYER_QUEST_LEVEL == 5 and quest_accepted(_num):
		pass

func quest_locked():
	print_debug("QUEST: LOCKED!")

func quest_unlocked(_num: int):
	if NPC_QUEST_STATUS[NPC.DALAG]["status"] == QUEST_STATUS.UNLOCKED and Game.PLAYER_QUEST_LEVEL == 0:
		# DALAG
		#dalag.guide_enabled = true
		pass
	elif NPC_QUEST_STATUS[NPC.PAWIKAN]["status"] == QUEST_STATUS.UNLOCKED and Game.PLAYER_QUEST_LEVEL == 1:
		# PAWIKAN
		pass
	elif NPC_QUEST_STATUS[NPC.KABIBE]["status"] == QUEST_STATUS.UNLOCKED and Game.PLAYER_QUEST_LEVEL == 2:
		# PAWIKAN
		pass
		
func quest_accepted(_num: int):
	NPC_QUEST_STATUS[_num]["status"] = QUEST_STATUS.ACCEPTED
	has_active_quest = true
	print_debug("QUEST: ACCEPTED!")
	return true

func quest_done(num: int):
	Game.PLAYER_QUEST_LEVEL += 1
	NPC_QUEST_STATUS[num]["status"] = QUEST_STATUS.DONE
	NPC_QUEST_STATUS[num+1]["status"] = QUEST_STATUS.UNLOCKED
	Game.QUEST_STATUS["Q"+"%s"%num] = true
	has_active_quest = false
	unlocked.emit(num+1)
	print_debug("QUEST: DONE!")

func _on_pawikan_body_entered(body):
	if body.is_in_group("Player"):
		active_npc = NPC.PAWIKAN
		interact_btn(interact, true)
		interact.connect("pressed", on_interact_pressed)
		buttons_connect()

func _on_pawikan_body_exited(body):
	if body.is_in_group("Player"):
		interact_btn(interact, false)
		interact.disconnect("pressed", on_interact_pressed)
		buttons_disconnect()

func _on_dalag_body_entered(body):
	if body.is_in_group("Player"):
		active_npc = NPC.DALAG
		interact_btn(interact, true)
		interact.connect("pressed", on_interact_pressed)
		buttons_connect()

func _on_dalag_body_exited(body):
	if body.is_in_group("Player"):
		on_out_of_range()
		interact_btn(interact, false)
		interact.disconnect("pressed", on_interact_pressed)
		buttons_disconnect()

func _on_kabibe_body_entered(body):
	if body.is_in_group("Player"):
		active_npc = NPC.KABIBE
		interact_btn(interact, true)
		interact.connect("pressed", on_interact_pressed)
		buttons_connect()

func _on_kabibe_body_exited(body):
	if body.is_in_group("Player"):
		interact_btn(interact, false)
		interact.disconnect("pressed", on_interact_pressed)
		buttons_disconnect()
