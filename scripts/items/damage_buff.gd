extends Area2D

var damage : float = 5.0
@onready var anim = $AnimatedSprite2D

func _ready():
	anim.play("default")

func _on_body_entered(body):
	if body.is_in_group("Player") and body.has_method("on_damage_powerup"):
		body.on_damage_powerup(damage)
		queue_free()
