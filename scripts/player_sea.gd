extends CharacterBody2D
class_name Player
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const PROJECTILE_PATH = preload("res://projectiles/projectile_1.tscn")
#can add other projectile
#fix the projectile orientation
#add attack buttons
#add enemy damage
#add the game and utils script

@onready var joystick = $"../../CanvasLayer/HBoxContainer/Joystick"
var speed = 600.0
var is_moving: bool
func _ready():
	$AnimationPlayer.play("idle")

func _physics_process(delta):
	var direction = joystick.vector_pos.normalized()
	if Input.is_action_just_pressed("ui_accept"):
		player_attack(direction)
	_gravity(delta)
	_movement(direction, delta)
	move_and_slide()

func _process(delta):
	_sprite_position(velocity.x)
	if is_moving:
		$AnimationPlayer.play("move")
	else:
		$AnimationPlayer.play("idle")
		$CollisionShape2D.set_rotation_degrees(0)
func _gravity(delta: float):
	if not is_on_floor():
		velocity.y += gravity * delta * 0.5

func _movement(direction, _delta: float):
	if direction:
		is_moving = true
		velocity = direction * speed * 0.5
		$Aim.rotation = atan2(direction.y, direction.x)
	else:
		is_moving = false
		velocity.x = move_toward(velocity.x, 0, 10)
		velocity.y = move_toward(0, velocity.y, 10)

func _sprite_position(pos: float):
	if pos > 0:
		$AnimatedSprite2D.flip_h = false
		$CollisionShape2D.set_rotation_degrees(30)
	elif pos < 0:
		$AnimatedSprite2D.flip_h = true
		$CollisionShape2D.set_rotation_degrees(-30)

func player_attack(direction):
	var projectile = PROJECTILE_PATH.instantiate()
	get_parent().add_child(projectile)
	projectile.position = $Aim/Marker2D.global_position
	projectile.velocity = direction
