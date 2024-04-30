extends CharacterBody2D

var player : CharacterBody2D

var is_alive : bool = true
var can_attack : bool = true
var is_hurt : bool = false
var in_range : bool = false
var in_area_dmg : bool = false

var speed : float = 100.0
var attack_cd : float = 3.0
var cd_timer : float = 0.0

var health : int = Game.enemy_hp

@onready var eel_sprite = $EelSprite
@onready var eel_anim = $EelAnim
@onready var area_dmg = $DamageArea/DACol
@onready var health_bar = $HealthBar

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	health_bar._init_health(health)
	eel_anim.play("idle")

func _process(_delta):
	if is_alive:
		
		if is_hurt:
			eel_anim.play("hurt")
			await eel_anim.animation_finished
			is_hurt = false
		
		if can_attack and in_area_dmg:
			await on_enemy_attack(eel_anim)
		
		if in_range:
			eel_anim.play("move")
		else:
			eel_anim.play("idle")

func _physics_process(delta):
	if not player:
		velocity = Vector2.ZERO
	if is_alive:
		
		if not can_attack:
			on_attack_cooldown(delta)
			
		follow_player()
		move_and_slide()

func follow_player():
	if not in_area_dmg and Game.is_alive:
		var direction = (player.global_position - self.global_position)
		if in_range:
			velocity = direction.normalized() * speed
			sprite_position(direction.normalized().x)
		else:
			velocity = Vector2.ZERO

func sprite_position(pos: float):
	if pos > 0: 
		eel_sprite.flip_h = false
	elif pos < 0: 
		eel_sprite.flip_h = true

func on_attack_cooldown(delta):
	cd_timer += delta
	if cd_timer >= attack_cd:
		can_attack = true
		cd_timer = 0.0

func on_enemy_attack(anim: AnimationPlayer):
	velocity = Vector2.ZERO
	anim.play("attack")
	await anim.animation_finished
	can_attack = false

func take_damage(damage):
	is_hurt = true
	health -= damage
	health_bar.health = health
	if health <= 0: 
		await _death()
	return health

func _death():
	is_alive = false
	area_dmg.disabled = true
	eel_anim.play("death")
	await eel_anim.animation_finished
	Game.player_exp += Game.exp_to_get
	self.queue_free()

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
