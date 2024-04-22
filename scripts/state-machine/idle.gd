class_name Idle
extends State
@export var enemy : CharacterBody2D
@onready var anim = $"../../AnimationPlayer"
var player : CharacterBody2D
var in_range: bool
func Enter():
	player = get_tree().get_first_node_in_group("Player")
	anim.play("idle")
func Update(delta):
	pass
func Physics_Update(delta):
	if in_range:
		Transitioned.emit(self, "move")
func _on_player_detection_body_entered(body):
	if body.is_in_group("Player"):
		in_range = true
