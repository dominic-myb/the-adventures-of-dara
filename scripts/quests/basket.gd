extends Area2D
var points: int = 0
func _on_body_entered(body):
	if body.is_in_group("Garbage"):
		body.queue_free()
		points += 1
