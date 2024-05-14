extends Area2D
signal done(_num: int)
@onready var timed_spawn = $TimedSpawn

func _on_body_entered(body):
	if body.is_in_group("Player"):
		# quest successful
		done.emit(2)
		queue_free()

func _on_timed_spawn_timeout():
	# quest failed
	queue_free()
