extends Area2D

signal done(_num: int)
signal failed(_num: int)

var timer_display: PanelContainer
@onready var timed_spawn = $TimedSpawn

func _ready():
	timer_display = get_tree().get_first_node_in_group("Time")
	timer_display.visible = true

func _process(_delta):
	timer_display.time_content = timed_spawn.time_left

func _on_body_entered(body):
	if body.is_in_group("Player"):
		timer_display.visible = false
		done.emit(2)
		queue_free()

func _on_timed_spawn_timeout():
	# minus heart
	timer_display.visible = false
	failed.emit(2)
	queue_free()
