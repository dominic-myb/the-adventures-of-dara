extends Node

"""
+ Add Conversation, then mission
+ Add Exp value per mission
+ Make a resource save
+ Make all death functions private
+ Use signals on_health_change

CHECK IF THE EVENT.QUEST_STATUS == ACCEPT, 
IF IT IS PREVENT FROM GETTING OTHER QUEST
USE PRIVATE _QUEST_STATUS LOCALLY 
THEN UPDATE EVENT.QUEST_STATUS 
IF THE QUEST IS BEING ACCEPTED

"""

signal pressed
signal accepted(quest: int)
enum QUESTS {
	Q1,
	Q2,
	Q3
}
enum QUEST_STATUS {
	LOCKED,
	UNLOCKED,
	ACCEPTED,
	DONE
}
enum NPCS {
	CLAM,
	JELLYFISH
}
const PLAYER_IMG = preload("res://art/package-icon/ICON.png")
const CLAM_IMG = preload("res://art/npc/clam-pic.png")
const JELLYFISH_IMG = preload("res://art/npc/jellyfish-pic.png")

var NPC = {
	NPCS.CLAM:{
		"status" : QUEST_STATUS.UNLOCKED,
		"quest" : QUESTS.Q1
	},
	NPCS.JELLYFISH:{
		"status" : QUEST_STATUS.LOCKED,
		"quest" : QUESTS.Q2
		}
}

var next_btn : TextureButton
var back_btn : TextureButton
var skip_btn : TextureButton

var lines_counter : int = 0
var lines : Array[String] = []
var pictures : Array[Texture2D] = []

var _quest_status : int
var _quest_num : int
var _npc : int

@onready var interact = $"../CanvasLayer/RightButtonContainer/RightButtons/Interact"
@onready var conversation_box = $"../CanvasLayer/Conversation"
@onready var lines_holder = $"../CanvasLayer/Conversation/MarginContainer/LinesCon/LinesHolder"
@onready var joystick = $"../CanvasLayer/JoystickContainer"
@onready var right_buttons = $"../CanvasLayer/RightButtonContainer"
@onready var picture = $"../CanvasLayer/Conversation/MarginContainer/LinesCon/Picture"

func _ready():
	interact.visible = false
	conversation_box.visible = false
	
	next_btn = get_node("%Next")
	back_btn = get_node("%Back")
	skip_btn = get_node("%Skip")
	
	_quest_num = QUESTS.Q1
	_quest_status = QUEST_STATUS.UNLOCKED
	
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

func _on_clam_interact_area_body_entered(body):
	if body.is_in_group("Player"):
		interact_btn(interact, true)
		interact.connect("pressed", on_interact_pressed)
		buttons_connect()
		_npc = NPCS.CLAM

func _on_clam_interact_area_body_exited(body):
	if body.is_in_group("Player"):
		interact_btn(interact, false)
		interact.disconnect("pressed", on_interact_pressed)
		buttons_disconnect()
		_npc = NPCS.CLAM

func _on_jellyfish_interact_area_body_entered(body):
	if body.is_in_group("Player"):
		interact_btn(interact, true)
		interact.connect("pressed", on_interact_pressed)
		buttons_connect()
		_npc = NPCS.JELLYFISH

func _on_jellyfish_interact_area_body_exited(body):
	if body.is_in_group("Player"):
		interact_btn(interact, false)
		interact.disconnect("pressed", on_interact_pressed)
		buttons_disconnect()
		_npc = NPCS.JELLYFISH

func on_interact_pressed():
	convo_manager()
	controls(joystick, right_buttons, false)
	conversation(conversation_box, true)
	line_controller(picture)

func on_next_pressed():
	lines_counter += 1
	if lines_counter >= lines.size():
		conversation(conversation_box, false)
		controls(joystick, right_buttons, true)
		lines_counter = 0
		if NPC[_npc]["status"] == QUEST_STATUS.UNLOCKED:
			NPC[_npc]["status"] = QUEST_STATUS.ACCEPTED
			quest_accepted()
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
	if NPC[_npc]["status"] == QUEST_STATUS.UNLOCKED:
		NPC[_npc]["status"] = QUEST_STATUS.ACCEPTED
		quest_accepted()

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
	if NPC[_npc]["status"] == QUEST_STATUS.LOCKED:
		lines = [
			"You're not ready for this!"
		]
		pictures = [
			CLAM_IMG
		]
	elif NPC[_npc]["status"] == QUEST_STATUS.UNLOCKED:
		lines = [
			"I Have a favor to you, Dara!",
			"What is it?",
			"I Want you to kill the eel",
			"Roger!"
		]
		pictures = [
			CLAM_IMG,
			PLAYER_IMG,
			CLAM_IMG,
			PLAYER_IMG
		]
	elif NPC[_npc]["status"] == QUEST_STATUS.ACCEPTED:
		lines = [
			"Remember that you need  to kill the eel",
			"Roger!"
		]
		pictures = [
			CLAM_IMG,
			PLAYER_IMG
		]
	elif NPC[_npc]["status"] == QUEST_STATUS.DONE:
		lines = [
			"Thank you, Dara",
			"Welcome!"
		]
		pictures = [
			CLAM_IMG,
			PLAYER_IMG
		]
	elif NPC[_npc]["status"] == QUEST_STATUS.LOCKED:
		lines = [
			"You're not ready for this!"
		]
		pictures = [
			JELLYFISH_IMG
		]
	elif NPC[_npc]["status"] == QUEST_STATUS.UNLOCKED:
		lines = [
			"I Have a favor to you, Dara!",
			"What is it?",
			"I Want you to kill the eel",
			"Roger!"
		]
		pictures = [
			JELLYFISH_IMG,
			PLAYER_IMG,
			JELLYFISH_IMG,
			PLAYER_IMG
		]
	elif NPC[_npc]["status"] == QUEST_STATUS.ACCEPTED:
		lines = [
			"Remember that you need  to kill the eel",
			"Roger!"
		]
		pictures = [
			JELLYFISH_IMG,
			PLAYER_IMG
		]
	elif NPC[_npc]["status"] == QUEST_STATUS.DONE:
		lines = [
			"Thank you, Dara",
			"Welcome!"
		]
		pictures = [
			JELLYFISH_IMG,
			PLAYER_IMG
		]
	
"""
START OF QUEST MANAGER
"""
func quest_locked():
	print_debug("QUEST2: LOCKED!")
func quest_unlocked():
	print_debug("QUEST2: UNLOCKED!")
func quest_accepted():
	print_debug("QUEST2: ACCEPTED!")
	accepted.emit(NPC[_npc]["quest"])
func quest_done():
	print_debug("QUEST2: DONE!")
