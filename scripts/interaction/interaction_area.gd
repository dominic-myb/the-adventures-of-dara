extends Area2D
class_name InteractionArea
@export var action_name : String = ""
@export var anim : AnimatedSprite2D
var interact: Callable = func():
	pass


func _on_body_entered(_body):
	InteractionManager.register_area(self)
	anim.play("interact")

func _on_body_exited(_body):
	InteractionManager.unregister_area(self)
	anim.play("default")
