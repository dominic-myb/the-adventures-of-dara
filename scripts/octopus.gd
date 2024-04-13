extends CharacterBody2D
var player : CharacterBody2D
var in_range : bool
var speed := 100.0
func _ready():
	player = get_tree().get_first_node_in_group("Player")
	$AnimationPlayer.play("idle")
func _process(delta):
	pass
func _physics_process(delta):
	_follow_player()
	move_and_slide()
func _follow_player():
	var direction = (player.global_position - self.global_position)
	if in_range:
		velocity = direction.normalized() * speed
		_sprite_position(direction.normalized().x)
		$AnimationPlayer.play("move")
	else:
		velocity = Vector2.ZERO
		$AnimationPlayer.play("idle")
func _sprite_position(pos: float):
	if pos > 0: $AnimatedSprite2D.flip_h = false
	elif pos < 0: $AnimatedSprite2D.flip_h = true
func _on_player_detection_body_entered(body):
	if body.is_in_group("Player"):
		in_range = true

func _on_player_detection_body_exited(body):
	if body.is_in_group("Player"):
		in_range = false
