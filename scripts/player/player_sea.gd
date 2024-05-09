class_name Player
extends CharacterBody2D

"""
NEEDS DEATH MESSAGE UI
"""
signal game_over
const PROJECTILE_PATH = preload("res://scenes/projectiles/projectile_3.tscn")

var is_hurt : bool = false
var is_moving : bool = false
var is_pressed : bool = false
var mana_regen_rate : float = Game.player_mana_regen_rate
var mana : float = Game.player_mana
var damage : float = Game.player_damage
var movespeed : float = Game.player_movespeed

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_move : bool = true

@onready var aim = $Aim
@onready var player_col = $PlayerCol
@onready var player_anim = $PlayerAnim
@onready var player_sprite = $PlayerSprite
@onready var aim_position = $Aim/AimPosition
@onready var mana_bar = $CanvasLayer/MarginCon/StatsCon/BarCon/ManaBar
@onready var joystick = $"../../CanvasLayer/JoystickContainer/Joystick"
@onready var health_bar = $CanvasLayer/MarginCon/StatsCon/BarCon/HealthBar
@onready var experience_bar = $CanvasLayer/MarginCon/StatsCon/BarCon/ExperienceBar
@onready var mana_buff_timer = $ManaBuffTimer
@onready var damage_buff_timer = $DamageBuffTimer
@onready var movespeed_buff_timer = $MovespeedBuffTimer
@onready var basket = $QuestItems/Basket

func _ready():
	game_over.connect(_death)
	health_bar._init_health(Game.player_hp)
	mana_bar._init_mana(Game.player_mana)
	experience_bar._init_experience(Game.player_exp, Game.player_max_exp)
	player_anim.play("idle")
	
func _physics_process(delta):
	var direction = joystick.vector_pos.normalized()
	_mana_regen(delta + mana_regen_rate)
	_gravity(delta)
	_movement(direction, delta)
	if can_move:
		move_and_slide()

func _process(_delta):
	_sprite_position(velocity.x)
	experience_bar.experience = Game.player_exp
	if Input.is_action_just_pressed("ui_accept"):
		_player_attack()
	if is_hurt:
		await _hurt(player_anim)
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
		if basket:
			basket.position.x = 60
	elif pos < 0:
		player_sprite.flip_h = true
		player_col.set_rotation_degrees(-30)
		if basket:
			basket.position.x = -60

func _mana_regen(delta):
	if Game.player_mana < Game.player_max_mana:
		Game.player_mana += delta * 2
		mana_bar.mana = Game.player_mana

func _player_attack():
	var direction = aim_position.global_position - self.position
	if Game.player_mana > 5:
		var projectile = PROJECTILE_PATH.instantiate()
		get_tree().get_first_node_in_group("Projectiles").add_child(projectile)
		projectile.position = aim_position.global_position
		projectile.set_direction(direction)
		projectile.rotation = atan2(direction.y, direction.x)
		Game.player_mana -= 5
		mana_bar.mana = Game.player_mana

func _hurt(anim: AnimationPlayer):
	anim.play("hurt")
	await anim.animation_finished
	is_hurt = false

func _death():
	Game.is_alive = false
	player_anim.play("death")
	await player_anim.animation_finished
	queue_free()

func on_mana_powerup(_amount):
	mana_buff_timer.start()
	mana_regen_rate += _amount

func on_damage_powerup(_amount):
	damage_buff_timer.start()
	damage += _amount
	
func on_movespeed_powerup(_amount):
	movespeed_buff_timer.start()
	movespeed += _amount

func take_damage(_damage):
	is_hurt = true
	Game.player_hp -= _damage
	health_bar.health = Game.player_hp
	if Game.player_hp <= 0: 
		game_over.emit()

func _on_mana_buff_timer_timeout():
	mana_regen_rate = Game.player_mana_regen_rate

func _on_damage_buff_timer_timeout():
	damage = Game.player_damage

func _on_movespeed_buff_timer_timeout():
	movespeed = Game.player_movespeed

