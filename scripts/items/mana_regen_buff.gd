extends Area2D

var regen_buff : float = 0.5
@onready var anim = $AnimatedSprite2D

func _ready():
	anim.play("default")

func _on_body_entered(body):
	if body.is_in_group("Player") and body.has_method("on_mana_powerup"):
		body.on_mana_powerup(regen_buff)
		queue_free()
