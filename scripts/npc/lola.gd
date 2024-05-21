extends Area2D

var player: CharacterBody2D
@onready var anim = $AnimatedSprite2D
@onready var arrow_guide = $ArrowGuide
@onready var quest_manager = $"../../QuestManager"
func _ready():
	arrow_guide.play("default")
	player = get_tree().get_first_node_in_group("Player")
	quest_manager.connect("accepted", on_quest_accepted)
	quest_manager.connect("failed", on_quest_failed)
	quest_manager.connect("done", on_quest_done)
func _process(_delta):
	_sprite_orientation()
	
func _sprite_orientation():
	if player.global_position.x > position.x:
		anim.flip_h = false
	elif player.global_position.x < position.x:
		anim.flip_h = true
	anim.play("idle")

# ADD A ARROW GUIDE MANAGER INSIDE QUEST UNLOCKED!

func on_quest_unlocked(_num: int):
	if _num == 3:
		arrow_guide.visible = true
		arrow_guide.play("default")
	elif _num == 4:
		arrow_guide.visible = true
		arrow_guide.play("default")

func on_quest_accepted(_num: int):
	if _num == 3:
		arrow_guide.visible = false
		#arrow_guide.play("default")
	elif _num == 4:
		arrow_guide.visible = false
		#arrow_guide.play("default")

func on_quest_done(_num: int):
	if _num == 3:
		arrow_guide.visible = false
	elif _num == 4:
		arrow_guide.visible = false

func on_quest_failed(_num: int):
	if _num == 3:
		arrow_guide.visible = true
		arrow_guide.play("default")
	elif _num == 4:
		arrow_guide.visible = true
		arrow_guide.play("default")
