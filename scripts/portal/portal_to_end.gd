extends Area2D

const POSTLUDE = "res://scenes/main_scenes/postlude.tscn"

var done_all_quest: bool = false

@onready var anim = $AnimatedSprite2D
@onready var quest_manager = $"../QuestManager"
@onready var arrow_guide = $ArrowGuide

func _ready():
	anim.visible = false
	arrow_guide.visible = false
	quest_manager.connect("done", on_quest_done)
	
func on_quest_done(_num: int):
	anim.visible = true
	anim.play("default")
	arrow_guide.visible = true
	arrow_guide.play("default")
	if _num == 5:
		done_all_quest = true

func _on_body_entered(body):
	if body.is_in_group("Player") and done_all_quest:
		get_tree().change_scene_to_file(POSTLUDE)
