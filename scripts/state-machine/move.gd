class_name Move
extends State
@onready var anim = $"../../AnimationPlayer"
var in_range : bool
func Enter():
	anim.play("move")
func Update(delta):
	pass
func Physics_Update(delta):
	if not in_range:
		Transitioned.emit(self, "idle")
func _on_player_detection_body_exited(body):
	if body.is_in_group("Player"):
		in_range = false

