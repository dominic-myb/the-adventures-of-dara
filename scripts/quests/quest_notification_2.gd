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
	if _num == 3:
		title = "<Quest 4: Accepted!>"
		content = "Apulahin Ang Apoy"
	elif _num == 4:
		title = "<Quest 5: Accepted!>"
		content = "Hanapin Ang Resipi"
	elif _num == 5:
		title = "<Quest 6: Accepted!>"
		content = "Tulungan Ang Bata"
	visible = true
	timer.start()
	
func on_quest_failed(_num: int):
	if _num == 3:
		title = "<Quest 4: Failed>"
		content = "Apulahin Ang Apoy"
	elif _num == 4:
		title = "<Quest 5: Failed!>"
		content = "Hanapin Ang Resipi"
	elif _num == 5:
		title = "<Quest 6: Failed!>"
		content = "Tulungan Ang Bata"
	visible = true
	timer.start()

func on_done_quest(_num: int):
	if _num == 3:
		title = "<Quest 4: Cleared>"
		content = "Apulahin Ang Apoy"
	elif _num == 4:
		title = "<Quest 5: Cleared!>"
		content = "Hanapin Ang Resipi"
	elif _num == 5:
		title = "<Quest 6: Cleared!>"
		content = "Tulungan Ang Bata"
	visible = true
	timer.start()

func _on_timer_timeout():
	visible = false
