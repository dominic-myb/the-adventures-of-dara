extends Node

"""
+ Create a signal conn for buttons to hide
+ Add a public method that hides the l&r buttons when conv is showing
+ Add Conversation, then mission
+ On Back BTN line_num -= 1
+ On Skip BTN line_num = 0 then is_showed = false
"""
const ICON = preload("res://art/package-icon/ICON.png")
const CLAM = preload("res://art/npc/clam-pic.png")
signal player_near
var is_showed : bool = false
var line_num : int = 0
var lines : Array[String] = [
	"Hello, Dara",
	"Hi, Clam"
]
var picture : Array[Texture2D] = [
	CLAM,
	ICON
]
@onready var interact_btn = $"../CanvasLayer/RightButtonContainer/RightButtons/Interact"
@onready var clam = $"../NPC/Clam"
@onready var joystick_container = $"../CanvasLayer/JoystickContainer"
@onready var right_button_container = $"../CanvasLayer/RightButtonContainer"
@onready var conversation = $"../CanvasLayer/Conversation"
@onready var lines_holder = $"../CanvasLayer/Conversation/MarginContainer/LinesCon/LinesHolder"
@onready var picture_holder = $"../CanvasLayer/Conversation/MarginContainer/LinesCon/Picture"

func _ready():
	clam.connect("player_near", on_interact_btn_show)
	conversation.visible = false
	interact_btn.visible = false

func _process(_delta):
	controls_hide()
	conversation_hide()
	line_controller(line_num)

func _on_interact_pressed():
	is_showed = true

func on_interact_btn_show():
	interact_btn.visible = true

func controls_hide():
	joystick_container.visible = not is_showed
	right_button_container = not is_showed

func conversation_hide():
	conversation.visible = is_showed

func _on_skip_btn_pressed():
	line_num += 1

func line_controller(num : int):
	if num > lines.size()-1:
		is_showed = false
		line_num = 0
	else:
		lines_holder.text = lines[num]
		picture_holder.texture = picture[num]
