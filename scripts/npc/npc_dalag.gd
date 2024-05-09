extends CharacterBody2D

var player : CharacterBody2D

@onready var sprite = $AnimatedSprite2D
@onready var collider = $CollisionShape2D
@onready var anim = $AnimationPlayer


func _ready():
	player = get_tree().get_first_node_in_group("Player")
	
func _process(_delta):
	if position.x < player.global_position.x:
		sprite.flip_h = false
	elif position.x > player.global_position.x:
		sprite.flip_h = true
	if Game.QUEST_STATUS["Q1"]:
		anim.play("quest_done")
	else:
		anim.play("idle")
	if anim.current_animation == "idle":
		collider.position.y = 40
	elif anim.current_animation == "quest_done":
		collider.position.y = 0

