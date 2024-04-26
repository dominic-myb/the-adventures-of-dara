class_name CLAM
extends NPC

signal accepted
signal done
signal pending

const PLAYER_PIC = preload("res://art/package-icon/ICON.png")
const CLAM_PIC = preload("res://art/npc/clam-pic.png")

var next_btn : TextureButton
var back_btn : TextureButton
var skip_btn : TextureButton

@onready var interact = $"../../CanvasLayer/RightButtonContainer/RightButtons/Interact"
@onready var conversation_box = $"../../CanvasLayer/Conversation"
@onready var lines_holder = $"../../CanvasLayer/Conversation/MarginContainer/LinesCon/LinesHolder"
@onready var right_buttons = $"../../CanvasLayer/RightButtonContainer"
@onready var joystick = $"../../CanvasLayer/JoystickContainer"
@onready var picture = $"../../CanvasLayer/Conversation/MarginContainer/LinesCon/Picture"

func _ready():
	# Get the quest_status on game save
	quest_status = QUEST_STATE.UNLOCKED
	next_btn = get_node("%Next")
	back_btn = get_node("%Back")
	skip_btn = get_node("%Skip")
	
func on_next_pressed():
	lines_counter += 1
	if lines_counter >= lines.size():
		conversation(conversation_box, false)
		controls(joystick, right_buttons, true)
		lines_counter = 0
		if quest_status == QUEST_STATE.UNLOCKED:
			quest_status = QUEST_STATE.ACCEPTED
			quest_accepted()
	else:
		line_controller(lines_holder, picture)

func on_back_pressed():
	lines_counter -= 1
	if lines_counter < 0:
		lines_counter = 0
	else:
		line_controller(lines_holder, picture)

func on_skip_pressed():
	convo_manager()
	conversation(conversation_box, false)
	controls(joystick, right_buttons, true)
	if quest_status == QUEST_STATE.UNLOCKED:
			quest_status = QUEST_STATE.ACCEPTED
			quest_accepted()
	
func on_interact_pressed():
	convo_manager()
	controls(joystick, right_buttons, false)
	conversation(conversation_box, true)
	line_controller(lines_holder, picture)
	
func buttons_connect():
	next_btn.connect("pressed", on_next_pressed)
	back_btn.connect("pressed", on_back_pressed)
	skip_btn.connect("pressed", on_skip_pressed)

func buttons_disconnect():
	next_btn.disconnect("pressed", on_next_pressed)
	back_btn.disconnect("pressed", on_back_pressed)
	skip_btn.disconnect("pressed", on_skip_pressed)

func _on_interaction_area_body_entered(body):
	if body.is_in_group("Player"):
		interact_btn(interact, true)
		interact.connect("pressed", on_interact_pressed)
		buttons_connect()

func _on_interaction_area_body_exited(body):
	if body.is_in_group("Player"):
		interact_btn(interact, false)
		interact.disconnect("pressed", on_interact_pressed)
		buttons_disconnect()

func quest_unlocked():
	# UI here about the quest 1
	print("Quest1: Unlocked")

func quest_accepted():
	print("Quest1: Accepted")
	accepted.emit()
	
func quest_done():
	print("Quest1: Done")
	
func convo_manager():
	lines_counter = 0
	if quest_status == QUEST_STATE.UNLOCKED:
		lines = [
			"I Have a favor to you, Dara!",
			"What is it?",
			"I Want you to kill the eel",
			"Roger!"
		]
		pictures = [
			CLAM_PIC,
			PLAYER_PIC,
			CLAM_PIC,
			PLAYER_PIC
		]
	elif quest_status == QUEST_STATE.ACCEPTED:
		lines = [
			"Remember that you need  to kill the eel",
			"Roger!"
		]
		pictures = [
			CLAM_PIC,
			PLAYER_PIC
		]
	elif quest_status == QUEST_STATE.DONE:
		lines = [
			"Thank you, Dara",
			"Welcome!"
		]
		pictures = [
			CLAM_PIC,
			PLAYER_PIC
		]
		
