extends CharacterBody2D
var speed : float = 0.01
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func _physics_process(delta):
	
	_gravity(delta)
	move_and_slide()
		
func _gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta * speed

func delete():
	queue_free()
