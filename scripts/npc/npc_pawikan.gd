extends CharacterBody2D

var player : CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var collider = $CollisionShape2D

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	
func _process(_delta):
	if position.x < player.global_position.x:
		anim.flip_h = false
	elif position.x > player.global_position.x:
		anim.flip_h = true
	anim.play("idle")
