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
signal accepted

enum QUEST_LEVEL { Q1, Q2,Q3
}

enum QUEST_STATUS { LOCKED, UNLOCKED, ACCEPTED,DONE
}

enum NPC { DALAG, PAWIKAN, KABIBE
}

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
@onready var quest_1 = $"../Quest1"
@onready var quest_items = $"../Player/Player/QuestItems"

func _ready():
	#quest_1.hide()
	#quest_items.hide()
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

func _on_clam_interact_area_body_entered(body):
	if body.is_in_group("Player"):
		active_npc = NPC.DALAG
		interact_btn(interact, true)
		interact.connect("pressed", on_interact_pressed)
		buttons_connect()

func _on_clam_interact_area_body_exited(body):
	if body.is_in_group("Player"):
		interact_btn(interact, false)
		interact.disconnect("pressed", on_interact_pressed)
		buttons_disconnect()

func _on_jellyfish_interact_area_body_entered(body):
	if body.is_in_group("Player"):
		active_npc = NPC.PAWIKAN
		interact_btn(interact, true)
		interact.connect("pressed", on_interact_pressed)
		buttons_connect()

func _on_jellyfish_interact_area_body_exited(body):
	if body.is_in_group("Player"):
		interact_btn(interact, false)
		interact.disconnect("pressed", on_interact_pressed)
		buttons_disconnect()

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
		if NPC_QUEST_STATUS[active_npc]["status"] == QUEST_STATUS.UNLOCKED and not has_active_quest:
			NPC_QUEST_STATUS[active_npc]["status"] = QUEST_STATUS.ACCEPTED
			accepted.emit()
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
		accepted.emit()
		has_active_quest = true

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
				"You're not ready for this!"
			]
			pictures = [
				DALAG_IMG
			]
	elif active_npc == NPC.PAWIKAN and NPC_QUEST_STATUS[active_npc]["status"] == QUEST_STATUS.LOCKED:
			lines = [
				"You're not ready for this!"
			]
			pictures = [
				PAWIKAN_IMG
			]
		# dapat nakakausap pa rin ng tama after ng quest
		# issue wrong pic displayed
	elif active_npc == NPC.DALAG and NPC_QUEST_STATUS[active_npc]["status"] == QUEST_STATUS.UNLOCKED:
		lines = [
			"I Have a favor to you, Dara!",
			"What is it?",
			"I Want you to kill the eel",
			"Roger!"
		]
		pictures = [
			DALAG_IMG,
			PLAYER_IMG,
			DALAG_IMG,
			PLAYER_IMG
		]
	elif active_npc == NPC.DALAG and NPC_QUEST_STATUS[active_npc]["status"] == QUEST_STATUS.ACCEPTED:
		lines = [
			"Remember that you need  to kill the eel",
			"Roger!"
		]
		pictures = [
			DALAG_IMG,
			PLAYER_IMG
		]
	elif active_npc == NPC.DALAG and NPC_QUEST_STATUS[active_npc]["status"] == QUEST_STATUS.DONE:
		lines = [
			"Thank you, Dara",
			"Welcome!"
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
	
"""
START OF QUEST MANAGER
"""
func _process(_delta):
	if Game.QUEST_STATUS["Q1"]:
		pass
	if Game.QUEST_STATUS["Q2"]:
		pass
	if Game.QUEST_STATUS["Q3"]:
		pass
	if Game.QUEST_STATUS["Q4"]:
		pass
	if Game.QUEST_STATUS["Q5"]:
		pass
	if Game.QUEST_STATUS["Q6"]:
		pass
		
func quest():
	if Game.PLAYER_QUEST_LEVEL == 0 and quest_accepted():
		var boulder = BOULDER.instantiate()
		var dalag = get_tree().get_first_node_in_group("NPC").find_child("Dalag")
		boulder.position = dalag.global_position
		get_tree().get_first_node_in_group("QuestItems").add_child(boulder)
		boulder.done.connect(quest_done)
		
	elif Game.PLAYER_QUEST_LEVEL == 1 and quest_accepted():
		quest_items.show()
		quest_1.show()
	elif Game.PLAYER_QUEST_LEVEL == 2 and quest_accepted():
		pass
	elif Game.PLAYER_QUEST_LEVEL == 3 and quest_accepted():
		pass
	elif Game.PLAYER_QUEST_LEVEL == 4 and quest_accepted():
		pass
	elif Game.PLAYER_QUEST_LEVEL == 5 and quest_accepted():
		pass

func quest_locked():
	print_debug("QUEST2: LOCKED!")
func quest_unlocked():
	print_debug("QUEST2: UNLOCKED!")
func quest_accepted():
	has_active_quest = true
	print_debug("QUEST2: ACCEPTED!")
	return true
func quest_done(num: int):
	Game.PLAYER_QUEST_LEVEL += 1
	NPC_QUEST_STATUS[num]["status"] = QUEST_STATUS.DONE
	NPC_QUEST_STATUS[num+1]["status"] = QUEST_STATUS.UNLOCKED
	print(NPC_QUEST_STATUS[active_npc]["status"])
	has_active_quest = false
	print_debug("QUEST2: DONE!")

func _on_dalag_ia_body_entered(body):
	if body.is_in_group("Player"):
		active_npc = NPC.DALAG
		interact_btn(interact, true)
		interact.connect("pressed", on_interact_pressed)
		buttons_connect()

func _on_dalag_ia_body_exited(body):
	if body.is_in_group("Player"):
		interact_btn(interact, false)
		interact.disconnect("pressed", on_interact_pressed)
		buttons_disconnect()

func _on_pawikan_ia_body_entered(body):
	if body.is_in_group("Player"):
		active_npc = NPC.PAWIKAN
		interact_btn(interact, true)
		interact.connect("pressed", on_interact_pressed)
		buttons_connect()

func _on_pawikan_ia_body_exited(body):
	if body.is_in_group("Player"):
		interact_btn(interact, false)
		interact.disconnect("pressed", on_interact_pressed)
		buttons_disconnect()
