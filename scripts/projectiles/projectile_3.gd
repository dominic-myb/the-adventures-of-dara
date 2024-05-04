extends Area2D
@onready var anim = $AnimatedSprite2D
var velocity = Vector2()
var speed : float = 1000.0
func _ready():
	anim.play("default")
func _physics_process(delta):
	position += velocity * speed * delta

func set_direction(_direction: Vector2):
	velocity = _direction.normalized()

func _on_body_entered(body):
	if body.is_in_group("Enemies") and body.has_method("take_damage"):
		body.take_damage(Game.player_damage)
		queue_free()
	elif body.is_in_group("Walls"):
		queue_free()
