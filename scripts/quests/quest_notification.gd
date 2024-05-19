extends PanelContainer

# add a quest notif in game
# show in 3 secs
# hide after 3 secs

var enable_notif: bool
var title: String
var content: String

var display_time: float = 3.0
var cooldown: float = 0.0

@onready var title_holder = $MarginContainer/VBoxContainer/Title
@onready var contents_holder = $MarginContainer/VBoxContainer/Contents
@onready var timer = $Timer
@onready var quest_manager = $"../../QuestManager"

func _ready():
	visible = false
	quest_manager.connect("accepted", on_accept_quest)
	quest_manager.connect("failed", on_quest_failed)
	quest_manager.connect("done", on_done_quest)

func _process(_delta):
	_input_display()

func _input_display():
	title_holder.text = title
	contents_holder.text = content

func on_accept_quest(_num: int):
	if _num == 0:
		title = "<Quest 1: Accepted!>"
		content = "Durugin ang bato"
	elif _num == 1:
		title = "<Quest 2: Accepted!>"
		content = "Linisin ang dagat"
	elif _num == 2:
		title = "<Quest 3: Accepted!>"
		content = "Hanapin ang Perlas"
	visible = true
	timer.start()
	
func on_quest_failed(_num: int):
	if _num == 0:
		title = "<Quest 1: Failed>"
		content = "Durugin ang bato"
	elif _num == 1:
		title = "<Quest 2: Failed!>"
		content = "Linisin ang dagat"
	elif _num == 2:
		title = "<Quest 3: Failed!>"
		content = "Hanapin ang Perlas"
	visible = true
	timer.start()

func on_done_quest(_num: int):
	if _num == 0:
		title = "<Quest 1: Cleared>"
		content = "Durugin ang bato"
	elif _num == 1:
		title = "<Quest 2: Cleared!>"
		content = "Linisin ang dagat"
	elif _num == 2:
		title = "<Quest 3: Cleared!>"
		content = "Hanapin ang Perlas"
	visible = true
	timer.start()

func _on_timer_timeout():
	visible = false
