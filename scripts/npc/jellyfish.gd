class_name JELLYFISH
extends NPC

signal pressed

const PLAYER_PIC = preload("res://art/package-icon/ICON.png")
const CLAM_PIC = preload("res://art/npc/clam-pic.png")

var next_btn : TextureButton
var back_btn : TextureButton
var skip_btn : TextureButton

@onready var interact = $"../../CanvasLayer/RightButtonContainer/RightButtons/Interact"
@onready var conversation_box = $"../../CanvasLayer/Conversation"
@onready var joystick = $"../../CanvasLayer/JoystickContainer"
@onready var right_buttons = $"../../CanvasLayer/RightButtonContainer"
@onready var picture = $"../../CanvasLayer/Conversation/MarginContainer/LinesCon/Picture"
@onready var lines_holder = $"../../CanvasLayer/Conversation/MarginContainer/LinesCon/LinesHolder"

func _ready():
	lines_counter = 0
	next_btn = get_node("%Next")
	back_btn = get_node("%Back")
	skip_btn = get_node("%Skip")

	lines = [
		"Hello, Dara",
		"Hi, Aljay"
	]

	pictures = [
		CLAM_PIC,
		PLAYER_PIC
	]

func buttons_connect():
	next_btn.connect("pressed", on_next_pressed)
	back_btn.connect("pressed", on_back_pressed)
	skip_btn.connect("pressed", on_skip_pressed)

func buttons_disconnect():
	next_btn.disconnect("pressed", on_next_pressed)
	back_btn.disconnect("pressed", on_back_pressed)
	skip_btn.disconnect("pressed", on_skip_pressed)

func on_next_pressed():
	lines_counter += 1
	if lines_counter >= lines.size():
		conversation(conversation_box, false)
		controls(joystick, right_buttons, true)
		lines_counter = 0
	else:
		line_controller(lines_holder, picture)
	
func on_back_pressed():
	lines_counter -= 1
	if lines_counter < 0:
		lines_counter = 0
	else:
		line_controller(lines_holder, picture)

func on_skip_pressed():
	conversation(conversation_box, false)
	controls(joystick, right_buttons, true)

func on_interact_pressed():
	controls(joystick, right_buttons, false)
	conversation(conversation_box, true)
	line_controller(lines_holder, picture)

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
