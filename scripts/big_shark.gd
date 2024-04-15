extends CharacterBody2D
var player : CharacterBody2D
var health = 100
var is_alive = true
var in_range = false
var in_damage_area = false
var can_attack = true
var speed = 100
var attack_cd = 0.0
var cd_timer = 0.0
var is_hurt := false
var damage = Game.enemy_damage * 2
func _ready():
	player = get_tree().get_first_node_in_group("Player")
	$AnimationPlayer.play("idle")

func _process(_delta):
	if is_alive:
		if is_hurt:
			$AnimationPlayer.play("hurt")
			await $AnimationPlayer.animation_finished
			is_hurt = false
		if can_attack and in_damage_area:
			await on_enemy_attack($AnimationPlayer)
		$AnimationPlayer.play("move" if in_range else "idle")

func _physics_process(delta):
	if is_alive:
		if not can_attack:
			on_attack_cooldown(delta)
		if in_damage_area:
			velocity = Vector2.ZERO
		else:	
			follow_player()
		move_and_slide()

func sprite_position(pos : float):
	#change the attack collider pos
	if pos > 0:
		$AnimatedSprite2D.flip_h = false
		$"Damage Area/CollisionShape2D".position.x = 83
	elif pos < 0:
		$AnimatedSprite2D.flip_h = true
		$"Damage Area/CollisionShape2D".position.x = -83

func follow_player():
	var direction = (player.global_position - self.global_position)
	if in_range:
		velocity = direction.normalized() * speed
		sprite_position(direction.normalized().x)
	else:
		#ADD PATROL METHOD
		velocity = Vector2.ZERO

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
	if health <= 0: death()
	else: return health

func death():
	is_alive = false
	$AnimationPlayer.play("death")
	await $AnimationPlayer.animation_finished
	queue_free()

func _on_player_detection_body_entered(body):
	if body.is_in_group("Player"):
		in_range = true

func _on_player_detection_body_exited(body):
	if body.is_in_group("Player"):
		in_range = false

func _on_damage_area_body_entered(body):
	if body.is_in_group("Player"):
		in_damage_area = true
		player.take_damage(damage)

func _on_damage_area_body_exited(body):
	if body.is_in_group("Player"):
		in_damage_area = false
		can_attack = false
