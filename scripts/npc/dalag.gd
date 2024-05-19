class_name Dalag extends NPC

var guide_on: bool = true

@onready var arrow_guide = $ArrowGuide
@onready var quest_manager = $"../../QuestManager"

func _ready():
	quest_manager.connect("accepted", on_accepted)
	quest_manager.connect("failed", on_failed)
	quest_manager.connect("done", on_done)
	anim = $AnimatedSprite2D
	anim.play("locked")
	toggle_arrow_guide(guide_on)

func toggle_arrow_guide(_show: bool):
	arrow_guide.visible = _show
	if _show:
		arrow_guide.play("default")

func on_accepted(_num: int):
	if _num == 0:
		toggle_arrow_guide(!guide_on)
		anim.play("accepted")
		
func on_failed(_num: int):
	if _num == 0:
		toggle_arrow_guide(guide_on)
		anim.play("locked")

func on_done(_num: int):
	if _num == 0:
		toggle_arrow_guide(!guide_on)
		anim.play("finished")
	
