extends CharacterBody2D

var in_range : bool = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var clam_sprite = $ClamSprite

func _process(_delta):
	if in_range:
		on_interact(clam_sprite)
	else:
		on_idle(clam_sprite)

func on_interact(anim : AnimatedSprite2D):
	anim.play("interact")

func on_idle(anim : AnimatedSprite2D):
	anim.play("idle")

