extends CharacterBody2D

var player : CharacterBody2D

var is_alive : bool = true
var can_attack : bool = true
var is_hurt : bool = false
var in_range : bool = false
var in_area_dmg : bool = false

var speed : float = 100.0
var attack_cd : float = 0.0
var cd_timer  : float = 0.0

var health : int = Game.enemy_hp * 2
var damage : int = Game.enemy_damage * 2

@onready var big_shark_sprite = $BigSharkSprite
@onready var big_shark_anim = $BigSharkAnim
@onready var area_dmg = $DamageArea/DACol
@onready var healthbar_con = $CanvasLayer/Control
@onready var health_bar = $CanvasLayer/Control/HealthBar

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	big_shark_anim.play("idle")
	health_bar._init_health(health)
	healthbar_con.visible = false

func _process(_delta):
	if is_alive:
		
		if is_hurt:
			big_shark_anim.play("hurt")
			await big_shark_anim.animation_finished
			is_hurt = false
			
		if can_attack and in_area_dmg:
			await on_enemy_attack(big_shark_anim)
		
		if in_range:
			big_shark_anim.play("move")
		else:
			big_shark_anim.play("idle")

func _physics_process(delta):
	if is_alive:
		
		if not can_attack:
			on_attack_cooldown(delta)

		if in_area_dmg:
			velocity = Vector2.ZERO
		else:
			follow_player()
			
		move_and_slide()

func sprite_position(pos : float):
	#change the attack collider pos
	if pos > 0:
		big_shark_sprite.flip_h = false
		area_dmg.position.x = 83
	elif pos < 0:
		big_shark_sprite.flip_h = true
		area_dmg.position.x = -83

func follow_player():
	if Game.is_alive:
		var direction = (player.global_position - self.global_position)
		if in_range:
			velocity = direction.normalized() * speed
			sprite_position(direction.normalized().x)
		else:
			velocity = Vector2.ZERO
			#ADD PATROL METHOD

func on_enemy_attack(anim : AnimationPlayer):
	anim.play("attack")
	await anim.animation_finished
	can_attack = false

func on_attack_cooldown(delta):
	cd_timer += delta
	if cd_timer >= attack_cd:
		can_attack = true
		cd_timer = 0.0

func take_damage(amount):
	is_hurt = true
	health -= amount
	health_bar.health = health
	if health <= 0: 
		await death(big_shark_anim)
	return health

func death(anim : AnimationPlayer):
	is_alive = false
	anim.play("death")
	await anim.animation_finished
	queue_free()

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
