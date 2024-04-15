extends Area2D
func _ready():
	$AnimatedSprite2D.play("default")

func _on_body_entered(body):
	if body.is_in_group("Player"):
		$AnimatedSprite2D.play("interact")
		#trigger mission
