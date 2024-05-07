extends Area2D

var velocity : float
func _physics_process(delta):
	position.y += velocity * delta
