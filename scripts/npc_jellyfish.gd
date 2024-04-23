extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var j_sprite = $JSprite

func _physics_process(delta):
	# if stay still jellyfish -> velocity = vector2.zero
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()
