extends Area2D
var movespeed : float = 1000.0
@onready var anim = $AnimatedSprite2D

func _ready():
	anim.play("default")

func _on_body_entered(body):
	if body.is_in_group("Player") and body.has_method("on_movespeed_powerup"):
		body.on_movespeed_powerup(movespeed)
		queue_free()
