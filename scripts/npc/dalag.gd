class_name Dalag extends NPC

var guide_on: bool = true

@onready var arrow_guide = $ArrowGuide
@onready var quest_manager = $"../../QuestManager"

func _ready():
	quest_manager.accepted.connect(on_accepted)
	anim = $AnimatedSprite2D
	anim.play("locked")
	toggle_arrow_guide(guide_on)
	# change this when accepted / finished

func toggle_arrow_guide(_show: bool):
	arrow_guide.visible = _show
	if _show:
		arrow_guide.play("default")

func on_accepted(_num: int):
	toggle_arrow_guide(!guide_on)
	anim.play("accepted")
	

func on_done(_num: int):
	toggle_arrow_guide(!guide_on)
	
