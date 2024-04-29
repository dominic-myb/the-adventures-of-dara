class_name Player
extends CharacterBody2D

"""
PROBLEM ON HANDLING TAKING DAMAGE
NEEDS DEATH MESSAGE UI
"""

const PROJECTILE_PATH = preload("res://scenes/projectiles/projectile_2.tscn")

var is_hurt : bool = false
var is_moving : bool = false
var is_pressed : bool = false
var health : float = 100
var movespeed : float = 600.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var aim = $Aim
@onready var player_col = $PlayerCol
@onready var player_anim = $PlayerAnim
@onready var player_sprite = $PlayerSprite
@onready var aim_position = $Aim/AimPosition
@onready var health_bar = $CanvasLayer/HealthBar
@onready var joystick = $"../../CanvasLayer/JoystickContainer/Joystick"

func _ready():
	health_bar._init_health(health)
	player_anim.play("idle")

func _physics_process(delta):
	var direction = joystick.vector_pos.normalized()
	if Input.is_action_just_pressed("ui_accept"):
		_player_attack()

	_gravity(delta)
	_movement(direction, delta)
	move_and_slide()

func _process(_delta):
	_sprite_position(velocity.x)
	if not Game.is_alive:
		await _death(player_anim)
	if is_hurt:
		_hurt(player_anim)
	if is_moving:
		_moving(player_anim)
	else:
		_idling(player_anim)

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

func _moving(anim: AnimationPlayer):
	anim.play("move")

func _idling(anim: AnimationPlayer):
	anim.play("idle")
	player_col.set_rotation_degrees(0)

func _sprite_position(pos: float):
	if pos > 0:
		player_sprite.flip_h = false
		player_col.set_rotation_degrees(30)
	elif pos < 0:
		player_sprite.flip_h = true
		player_col.set_rotation_degrees(-30)

func _player_attack():
	var direction = aim_position.global_position - self.position
	var projectile = PROJECTILE_PATH.instantiate()
	get_parent().add_child(projectile)
	projectile.position = aim_position.global_position
	projectile.velocity = direction * movespeed
	projectile.rotation = atan2(direction.y, direction.x)

func _hurt(anim: AnimationPlayer):
	anim.play("hurt")
	await anim.animation_finished
	is_hurt = false
	return is_hurt

func take_damage(damage):
	is_hurt = true
	Game.player_hp -= damage
	health_bar.health = Game.player_hp
	if Game.player_hp <= 0: 
		await _death(player_anim)
		_on_player_death()

func _death(anim: AnimationPlayer):
	anim.play("death")
	await anim.animation_finished
func _on_player_death():
	Game.is_alive = false
	#queue_free()

