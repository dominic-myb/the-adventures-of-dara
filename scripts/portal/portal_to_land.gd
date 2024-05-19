extends Area2D

const TRANSITION = "res://scenes/main_scenes/middle_transition.tscn"

@onready var quest_manager = $"../QuestManager"
@onready var player = $"../Player/Player"
@onready var anim = $AnimatedSprite2D
@onready var arrow_guide = $ArrowGuide

func _ready():
	quest_manager.connect("done", on_enable_arrow_guide)
	arrow_guide.visible = false
	
func on_enable_arrow_guide(_num: int):
	if _num == 2:
		arrow_guide.visible = true
		arrow_guide.play("default")
		anim.play("default")

func _on_body_entered(body):
	if body.is_in_group("Player") and Game.PLAYER_QUEST_LEVEL == 3:
		player.queue_free()
		get_tree().change_scene_to_file(TRANSITION)

func on_show_guide(_num: int):
	if _num == 2:
		arrow_guide.visible = true
	
