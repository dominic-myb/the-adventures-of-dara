extends State
class_name Idle
var in_range: bool
func Enter():
	$"../../AnimationPlayer".play("idle")
func Update(delta):
	if in_range:
		Transitioned.emit(self, "move")
func Physics_Update(delta):
	pass


func _on_player_detection_body_entered(body):
	if body.is_in_group("Player"):
		in_range = true
