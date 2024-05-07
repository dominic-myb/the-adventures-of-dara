class_name SeaEnemy
extends CharacterBody2D

signal dead
var player : CharacterBody2D

# STATS
var health: float
var damage: float
var movespeed: float
var attack_range_pos: float
var is_hurt: bool = false
var in_attack_range: bool = false
var in_range: bool = false
var can_attack: bool = true
var is_alive: bool = true

@onready var event_bus: Node
@onready var anim: AnimationPlayer
@onready var healthbar: ProgressBar
@onready var sprite: AnimatedSprite2D
@onready var collider: CollisionShape2D
@onready var attack_range_col: CollisionShape2D
@onready var attack_col: CollisionShape2D

func sprite_orientation(pos_x: float):
	if sprite:
		if pos_x > 0:
			sprite.flip_h = false
			if attack_range_col:
				attack_range_col.position.x = attack_range_pos
				attack_col.position.x = attack_range_pos
		elif pos_x < 0:
			sprite.flip_h = true
			if attack_range_col:
				attack_range_col.position.x = -attack_range_pos
				attack_col.position.x = -attack_range_pos
	else: 
		print_debug("No Sprite Attached!")
		return

func idling():
	if anim:
		anim.play("idle")
	else: 
		print_debug("No Anim Attached!")
		return

func moving():
	if anim:
		anim.play("move")
	else: 
		print_debug("No Anim Attached!")
		return

func follow_player():
	if not in_attack_range and Game.is_alive:
		var direction = (player.global_position - self.global_position)
		if in_range:
			velocity = direction.normalized() * movespeed
			sprite_orientation(direction.normalized().x)
		else:
			velocity = Vector2.ZERO

func on_enemy_attack():
	if anim:
		anim.play("attack")
		await anim.animation_finished
		can_attack = false
	else:
		print_debug("No Anim Attached!")
		
func hurt():
	if anim:
		anim.play("hurt")
		await anim.animation_finished
		is_hurt = false
	else:
		print_debug("No Anim Attached!")
	
func death():
	call_deferred("disable_colliders")
	anim.play("death")
	await anim.animation_finished
	Game.player_exp += Game.exp_to_get
	event_bus.on_enemy_death(global_position)
	Utils.saveGame()
	queue_free()

func disable_colliders():
	attack_range_col.disabled = true
	collider.disabled = true

func take_damage(amount):
	is_hurt = true
	health -= amount
	healthbar.health = health
	if health <= 0: 
		is_alive = false
		dead.emit()
	return health

func _on_enemy_buff():
	health = Game.enemy_max_hp
	damage = Game.enemy_damage
	movespeed = Game.enemy_speed
