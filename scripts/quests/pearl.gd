extends Area2D
@onready var timed_spawn = $TimedSpawn

func _on_body_entered(body):
	if body.is_in_group("Player"):
		# quest successful
		queue_free()

func _on_timed_spawn_timeout():
	# quest failed
	queue_free()
