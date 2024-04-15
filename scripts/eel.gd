extends CharacterBody2D
var player : CharacterBody2D
var in_range : bool
var in_damage_area : bool
var speed := 100.0
var can_attack := true
var attack_cd = 3.0
var cd_timer = 0
var health = Game.enemy_hp
var is_alive := true

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	$AnimationPlayer.play("idle")

func _process(_delta):
	if is_alive:
		if can_attack and in_damage_area:
			await on_enemy_attack($AnimationPlayer)
		if in_range:
			$AnimationPlayer.play("move")
		else:
			$AnimationPlayer.play("idle")

func _physics_process(delta):
	if is_alive:
		if not can_attack:
			on_attack_cooldown(delta)
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

func sprite_position(pos: float):
	if pos > 0: $AnimatedSprite2D.flip_h = false
	elif pos < 0: $AnimatedSprite2D.flip_h = true

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
	health -= damage
	if health <= 0: death()
	else: return health

func death():
	is_alive = false
	$"Damage Area/CollisionShape2D".disabled = true
	$AnimationPlayer.play("death")
	await $AnimationPlayer.animation_finished
	Game.player_exp += 10
	self.queue_free()
	
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
