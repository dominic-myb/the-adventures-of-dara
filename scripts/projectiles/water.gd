extends CharacterBody2D
@onready var anim = $AnimationPlayer

#func _ready():
	#anim.play("default")
	
func _process(_delta):
	anim.play("default")
	await anim.animation_finished
	queue_free()
func _on_body_entered(body):
	if body.is_in_group("House"):
		# send damage / 
		queue_free()
