extends CharacterBody2D

signal dead(anim: AnimationPlayer)

var player : CharacterBody2D
var is_hurt : bool = false
var in_range : bool = false
var can_attack : bool = true
var in_area_dmg : bool = false

var speed : float = 100.0
var attack_cd : float = 0.0
var cd_timer  : float = 0.0

var health : int = Game.enemy_hp * 2
var damage : int = Game.enemy_damage * 2

@onready var area_dmg = $DamageArea/DACol
@onready var big_shark_anim = $BigSharkAnim
@onready var big_shark_sprite = $BigSharkSprite
@onready var healthbar_con = $CanvasLayer/Control
@onready var health_bar = $CanvasLayer/Control/HealthBar

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	dead.connect(_death)
	big_shark_anim.play("idle")
	health_bar._init_health(health)
	healthbar_con.visible = false

func _process(_delta):
	if is_hurt:
		await _hurt(big_shark_anim)
	if can_attack and in_area_dmg:
		await _on_enemy_attack(big_shark_anim)
	if in_range:
		_moving(big_shark_anim)
	else:
		_idling(big_shark_anim)

func _physics_process(delta):
	if not player:
		velocity = Vector2.ZERO
	if not can_attack:
		_on_attack_cooldown(delta)
	if in_area_dmg:
		velocity = Vector2.ZERO
	else:
		_follow_player()
	move_and_slide()

func _sprite_position(pos : float):
	#change the attack collider pos
	if pos > 0:
		big_shark_sprite.flip_h = false
		area_dmg.position.x = 83
	elif pos < 0:
		big_shark_sprite.flip_h = true
		area_dmg.position.x = -83

func _idling(anim: AnimationPlayer):
	anim.play("idle")
	
func _moving(anim: AnimationPlayer):
	anim.play("move")

func _follow_player():
	if Game.is_alive:
		var direction = (player.global_position - self.global_position)
		if in_range:
			velocity = direction.normalized() * speed
			_sprite_position(direction.normalized().x)
		else:
			velocity = Vector2.ZERO
			#ADD PATROL METHOD

func _on_enemy_attack(anim : AnimationPlayer):
	anim.play("attack")
	await anim.animation_finished
	can_attack = false

func _on_attack_cooldown(delta):
	cd_timer += delta
	if cd_timer >= attack_cd:
		can_attack = true
		cd_timer = 0.0

func take_damage(amount):
	is_hurt = true
	health -= amount
	health_bar.health = health
	if health <= 0: 
		dead.emit(big_shark_anim)
	return health

func _hurt(anim: AnimationPlayer):
	anim.play("hurt")
	await anim.animation_finished
	is_hurt = false

func _death(anim : AnimationPlayer):
	anim.play("death")
	await anim.animation_finished
	queue_free()
	
# SIGNAL CONNECTIONS:
func _on_player_detection_body_entered(body):
	if body.is_in_group("Player"):
		in_range = true
		healthbar_con.visible = true

func _on_player_detection_body_exited(body):
	if body.is_in_group("Player"):
		in_range = false
		healthbar_con.visible = false

func _on_damage_area_body_entered(body):
	if body.is_in_group("Player"):
		in_area_dmg = true
		player.take_damage(damage)

func _on_damage_area_body_exited(body):
	if body.is_in_group("Player"):
		in_area_dmg = false
		can_attack = false
