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
var damage : int = Game.enemy_damage

@onready var octo_anim = $OctoAnim
@onready var octo_sprite = $OctoSprite


func _ready():
	player = get_tree().get_first_node_in_group("Player")
	octo_anim.play("idle")


func _process(_delta):
	if is_alive:
		
		if is_hurt:
			octo_anim.play("hurt")
			await octo_anim.animation_finished
			is_hurt = false
			
		if can_attack and in_area_dmg:
			sprite_position(velocity.x)
			velocity = Vector2.ZERO
			await on_enemy_attack(octo_anim)
			can_attack = false
		
		if in_range:
			octo_anim.play("move")
		else:
			octo_anim.play("idle")


func _physics_process(delta):
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
			octo_sprite.flip_h = false
		elif pos < 0: 
			octo_sprite.flip_h = true


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
		await death(octo_anim)
	return health


func death(anim : AnimationPlayer):
	is_alive = false
	anim.play("death")
	await anim.animation_finished
	Game.player_exp += 10
	Utils.saveGame()
	queue_free()


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

