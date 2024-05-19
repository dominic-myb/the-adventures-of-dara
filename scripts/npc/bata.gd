extends Area2D

@onready var collider = $CollisionShape2D
@onready var anim = $AnimatedSprite2D
@onready var player = $"../../Player/Player"

func _process(_delta):
	on_sprite_orientation()
	on_unlocked()
func on_sprite_orientation():
	if player.global_position.x > position.x:
		anim.flip_h = true
	elif player.global_position.x < position.x:
		anim.flip_h = false

func on_unlocked():
	if Game.PLAYER_QUEST_LEVEL == 4:
		anim.play("done")

func on_done():
	anim.play("done")
