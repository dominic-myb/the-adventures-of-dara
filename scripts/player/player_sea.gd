extends CharacterBody2D
<<<<<<< HEAD
@onready var sprite = $PlayerSprite
@onready var anim = $PlayerAnim
@onready var col = $PlayerCol
@onready var joystick = $"../../CanvasLayer/HBoxContainer/Joystick"
@onready var aim = $Aim
@onready var aim_pos = $Aim/Crosshair

signal is_dead

const PROJECTILE_PATH = preload("res://scenes/projectiles/projectile_2.tscn")
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var movespeed := 600.0
var is_moving := false
=======
class_name Player
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const PROJECTILE_PATH = preload("res://scenes/projectiles/projectile_2.tscn")
<<<<<<< Updated upstream:scripts/player/player_sea.gd
@onready var joystick = $"../../CanvasLayer/HBoxContainer/Joystick"
=======
@onready var player = %Player
@onready var joystick = $"../../CanvasLayer/LeftControls/Joystick"
>>>>>>> Stashed changes:scripts/player_sea.gd
var speed := 600.0
var is_moving : bool
>>>>>>> aa0b159a17e4eb7b19b0d2d819600b25f0cf40d0
var is_pressed := false
var is_hurt := false

func _ready():
	anim.play("idle")

func _physics_process(delta):
	var direction = joystick.vector_pos.normalized()
	if Input.is_action_just_pressed("ui_accept"):
		player_attack()
	_gravity(delta)
	_movement(direction, delta)
	move_and_slide()

func _process(_delta):
	_sprite_position(velocity.x)
	if is_hurt:
		anim.play("hurt")
		await anim.animation_finished
		is_hurt = false
	if is_moving:
		anim.play("move")
	else:
		anim.play("idle")
		col.set_rotation_degrees(0)

func _gravity(delta: float):
	if not is_on_floor():
		velocity.y += gravity * delta * 0.5

func _movement(direction, _delta: float):
	if direction:
		is_moving = true
		velocity = direction * movespeed * 0.5
		aim.rotation = atan2(direction.y, direction.x)
	else:
		is_moving = false
		velocity.x = move_toward(velocity.x, 0, 10)
		velocity.y = move_toward(0, velocity.y, 10)

func _sprite_position(pos: float):
	if pos > 0:
		sprite.flip_h = false
		col.set_rotation_degrees(30)
	elif pos < 0:
		sprite.flip_h = true
		col.set_rotation_degrees(-30)

func player_attack():
	var direction = aim_pos.global_position - self.position
	var projectile = PROJECTILE_PATH.instantiate()
	get_parent().add_child(projectile)
	projectile.position = aim_pos.global_position
	projectile.velocity = direction * movespeed
	projectile.rotation = atan2(direction.y, direction.x)	#rotation of projectile
	
func take_damage(damage):
	is_hurt = true
	Game.player_hp -= damage
	if Game.player_hp <= 0: death()

func death():
	anim.play("death")
	await anim.animation_finished
	queue_free()

