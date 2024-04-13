extends State
class_name Move
var in_range: bool
var player: CharacterBody2D
func Enter():
	player = get_tree().get_first_node_in_group("Player")
	$"../../AnimationPlayer".play("move")
func Update(delta):
	if in_range == false:
		Transitioned.emit(self, "idle")
	
func Physics_Update(delta):
	pass


func _on_player_detection_body_exited(body):
	if body.is_in_group("Player"):
		in_range = false

