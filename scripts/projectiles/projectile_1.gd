extends CharacterBody2D
var speed := 300
func _ready():
	$AnimatedSprite2D.play("default")
func _physics_process(delta):
	var collision_info = move_and_collide(velocity.normalized() * delta * speed)
	if collision_info:
		var collider = collision_info.get_collider()
		if collider.has_method("take_damage"):
			collider.take_damage(Game.player_damage)
		queue_free()
func _process(delta):
	if velocity.x > 0: $AnimatedSprite2D.flip_h = false
	elif velocity.x < 0: $AnimatedSprite2D.flip_h = true
