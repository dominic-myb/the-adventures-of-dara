class_name Kabibe extends NPC
@onready var quest_manager = $"../../QuestManager"
@onready var arrow_guide = $ArrowGuide

func _ready():
	quest_manager.connect("accepted", quest_accepted)
	quest_manager.connect("done", quest_done)
	quest_manager.connect("failed", quest_failed)
	quest_manager.connect("unlocked", quest_unlocked)
	arrow_guide.visible = false
	anim = $AnimatedSprite2D
	anim.play("default")

func quest_unlocked(_num: int):
	if _num == 2:
		arrow_guide.visible = true
		arrow_guide.play("default")

func quest_failed(_num: int):
	if _num == 2:
		arrow_guide.visible = true
		anim.play("default")
		arrow_guide.play("default")

func quest_accepted(_num: int):
	if _num == 2:
		arrow_guide.visible = false
		arrow_guide.play("default")
		anim.play("accepted")

func quest_done(_num: int):
	if _num == 2:
		arrow_guide.visible = false
		anim.play("done")
