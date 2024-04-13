extends CharacterBody2D
class_name Player
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var joystick = $"../CanvasLayer/HBoxContainer/Joystick"
var speed = 600.0
func _ready():
	$AnimationPlayer.play("idle")

func _physics_process(delta):
	_gravity(delta)
	_movement(delta)
	move_and_slide()

func _process(_delta):
	_sprite_position(velocity.x)

func _gravity(delta: float):
	if not is_on_floor():
		velocity.y += gravity * delta * 0.5

func _movement(_delta: float):
	var direction = joystick.vector_pos.normalized()
	if direction:
		velocity = direction * speed * 0.5
	else:
		velocity.x = move_toward(velocity.x, 0, 10)
		velocity.y = move_toward(0, velocity.y, 10)

func _sprite_position(pos: float):
	if pos > 0:
		$AnimatedSprite2D.flip_h = false
	elif pos < 0:
		$AnimatedSprite2D.flip_h = true
