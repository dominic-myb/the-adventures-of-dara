extends CharacterBody2D

signal dead

var player : CharacterBody2D

var in_range : bool = false
var is_hurt : bool = false
var can_attack : bool = true
var in_area_dmg : bool = false
var is_alive : bool = true

var attack_cd : float = 3.0
var cd_timer : float = 0.0

var health : int = Game.enemy_hp
var damage : int = Game.enemy_damage
var speed : float = Game.enemy_speed

@onready var octo_anim = $OctoAnim
@onready var octo_sprite = $OctoSprite
@onready var health_bar = $HealthBar
@onready var area_dmg = $DamageArea/DACol

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	health_bar._init_health(health)
	octo_anim.play("idle")
	Game.buffed.connect(_on_enemy_buff)
	dead.connect(_death)

func _process(_delta):
	if is_hurt:
		await _hurt(octo_anim)
	if can_attack and in_area_dmg:
		await _on_enemy_attack(octo_anim)
	if in_range:
		_moving(octo_anim)
	else:
		_idling(octo_anim)

func _physics_process(delta):
	_sprite_position(velocity.x)
	if not player:
		velocity = Vector2.ZERO
	if not can_attack:
		_on_attack_cooldown(delta)
	if in_area_dmg or not is_alive:
		velocity = Vector2.ZERO
	else:
		_follow_player()
	move_and_slide()

func _sprite_position(pos: float):
	if pos > 0: 
		octo_sprite.flip_h = false
		area_dmg.position.x = 32
	elif pos < 0: 
		octo_sprite.flip_h = true
		area_dmg.position.x = -32

func _idling(anim: AnimationPlayer):
	anim.play("idle")

func _moving(anim: AnimationPlayer):
	anim.play("move")

func _follow_player():
	if not in_area_dmg and Game.is_alive:
		var direction = (player.global_position - self.global_position)
		if in_range:
			velocity = direction.normalized() * speed
			_sprite_position(direction.normalized().x)
		else:
			velocity = Vector2.ZERO

func _on_enemy_attack(anim : AnimationPlayer):
	anim.play("attack")
	await anim.animation_finished
	can_attack = false

func _on_attack_cooldown(delta):
	cd_timer += delta
	if cd_timer >= attack_cd:
		can_attack = true
		cd_timer = 0.0

func _hurt(anim: AnimationPlayer):
	anim.play("hurt")
	await anim.animation_finished
	is_hurt = false

func _death():
	area_dmg.disabled = true
	octo_anim.play("death")
	await octo_anim.animation_finished
	Game.player_exp += Game.exp_to_get
	Utils.saveGame()
	queue_free()
	
func take_damage(amount):
	is_hurt = true
	health -= amount
	health_bar.health = health
	if health <= 0: 
		is_alive = false
		dead.emit()
	return health

func _on_enemy_buff():
	health = Game.enemy_max_hp
	damage = Game.enemy_damage
	speed = Game.enemy_speed
# SIGNAL CONNECTIONS:
func _on_player_detection_body_entered(body):
	if body.is_in_group("Player"):
		in_range = true

func _on_player_detection_body_exited(body):
	if body.is_in_group("Player"):
		in_range = false

func _on_damage_area_body_entered(body):
	if body.is_in_group("Player"):
		in_area_dmg = true

func _on_damage_area_body_exited(body):
	if body.is_in_group("Player"):
		in_area_dmg = false
		can_attack = false
