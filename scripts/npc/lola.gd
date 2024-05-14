extends Area2D

var player: CharacterBody2D
@onready var anim = $AnimatedSprite2D

func _ready():
	player = get_tree().get_first_node_in_group("Player")

func _process(_delta):
	_sprite_orientation()
	
func _sprite_orientation():
	if player.global_position.x > position.x:
		anim.flip_h = false
	elif player.global_position.x < position.x:
		anim.flip_h = true
