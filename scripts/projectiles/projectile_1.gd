extends CharacterBody2D
var speed := 300
func _ready():
	$AnimatedSprite2D.play("default")
func _physics_process(delta):
	var collision_info = move_and_collide(velocity.normalized() * delta * speed)
func _process(delta):
	if velocity.x > 0: $AnimatedSprite2D.flip_h = false
	elif velocity.x < 0: $AnimatedSprite2D.flip_h = true
