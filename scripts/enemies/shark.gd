extends CharacterBody2D

var player : CharacterBody2D

var can_attack : bool = true
var is_alive : bool = true
var is_hurt : bool = false
var in_range : bool = false
var in_damage_area : bool = false

var speed : float = 100.0
var attack_cd : float = 3.0
var cd_timer : float = 0.0

var health : int = Game.enemy_hp

@onready var shark_anim = $SharkAnim
@onready var shark_sprite = $SharkSprite
@onready var area_dmg = $DamageArea/DACol

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	shark_anim.play("idle")


func _process(_delta):
	if is_alive:
		if is_hurt:
			shark_anim.play("hurt")
			await shark_anim.animation_finished
			is_hurt = false
		
		if can_attack and in_damage_area:
			await on_enemy_attack(shark_anim)
			can_attack = false
		
		if in_range:
			shark_anim.play("move")
		else:
			shark_anim.play("idle")


func _physics_process(delta):
	if is_alive:
		if not can_attack:
			on_attack_cooldown(delta)
		if in_damage_area: 
			velocity = Vector2.ZERO  
		else: 
			follow_player()
		move_and_slide()


func follow_player():
	if not in_damage_area:
		var direction = (player.global_position - self.global_position)
		if in_range:
			velocity = direction.normalized() * speed
			sprite_position(direction.normalized().x)
		else:
			velocity = Vector2.ZERO


func on_enemy_attack(anim : AnimationPlayer):
	anim.play("attack")
	await anim.animation_finished


func on_attack_cooldown(delta):
	cd_timer += delta
	if cd_timer >= attack_cd:
		can_attack = true
		cd_timer = 0.0


func take_damage(amount):
	is_hurt = true
	health -= amount
	if health <= 0: 
		await death(shark_anim)
	return health


func death(anim : AnimationPlayer):
	is_alive = false
	anim.play("death")
	await anim.animation_finished
	queue_free()


func sprite_position(pos: float):
	if pos > 0: 
		shark_sprite.flip_h = false
		area_dmg.position.x = 27
	elif pos < 0: 
		shark_sprite.flip_h = true
		area_dmg.position.x = -27


func _on_player_detection_body_entered(body):
	if body.is_in_group("Player"):
		in_range = true


func _on_player_detection_body_exited(body):
	if body.is_in_group("Player"):
		in_range = false


func _on_damage_area_body_entered(body):
	if body.is_in_group("Player"):
		in_damage_area = true


func _on_damage_area_body_exited(body):
	if body.is_in_group("Player"):
		in_damage_area = false
		can_attack = false

