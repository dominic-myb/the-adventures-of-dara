extends CharacterBody2D
@onready var sprite = $EelSprite
@onready var anim = $EelAnim
@onready var attack_col = $AttackArea/AttackCol

var player : CharacterBody2D
var speed := 100.0
var attack_cd = 3.0
var cd_timer = 0
var health = Game.enemy_hp
var in_range : bool
var in_attack_area : bool
var can_attack := true
var is_alive := true
var is_hurt := false
@onready var anim = $EelAnimPlayer

func _ready():
	player = get_tree().get_first_node_in_group("Player")
<<<<<<< HEAD
	await idle(anim)
=======
	anim.play("idle")
>>>>>>> aa0b159a17e4eb7b19b0d2d819600b25f0cf40d0

func _process(_delta):
	if is_alive:
		if is_hurt:
<<<<<<< HEAD
			await hurt(anim)
		if can_attack and in_attack_area:
			await on_enemy_attack(anim)
		if in_range:
			await move(anim)
		if not in_range:
			await idle(anim)
=======
			anim.play("hurt")
			await anim.animation_finished
			is_hurt = false
		if can_attack and in_damage_area:
			await on_enemy_attack(anim)
		if in_range:
			anim.play("move")
		else:
			anim.play("idle")
>>>>>>> aa0b159a17e4eb7b19b0d2d819600b25f0cf40d0

func _physics_process(delta):
	if is_alive:
		if not can_attack:
			on_attack_cooldown(delta)
		if in_attack_area:
			velocity = Vector2.ZERO
		else:
			follow_player()
		move_and_slide()

func follow_player():
	if not in_attack_area:
		var direction = (player.global_position - self.global_position)
		if in_range:
			velocity = direction.normalized() * speed
			sprite_position(direction.normalized().x)
		else:
			velocity = Vector2.ZERO

func sprite_position(pos: float):
	if pos > 0: sprite.flip_h = false
	elif pos < 0: sprite.flip_h = true

func on_attack_cooldown(delta):
	cd_timer += delta
	if cd_timer >= attack_cd:
		can_attack = true
		cd_timer = 0.0

func on_enemy_attack(_anim: AnimationPlayer):
<<<<<<< HEAD
=======
	velocity = Vector2.ZERO
>>>>>>> aa0b159a17e4eb7b19b0d2d819600b25f0cf40d0
	_anim.play("attack")
	await _anim.animation_finished
	can_attack = false

func take_damage(damage):
	is_hurt = true
	health -= damage
	if health <= 0: await death(anim)
	else: return health

func move(_anim : AnimationPlayer):
	_anim.play("move")
	await _anim.animation_finished

func idle(_anim : AnimationPlayer):
	_anim.play("idle")
	await _anim.animation_finished

func hurt(_anim : AnimationPlayer):
	_anim.play("hurt")
	await _anim.animation_finished
	is_hurt = false

func death(_anim : AnimationPlayer):
	is_alive = false
<<<<<<< HEAD
	attack_col.disabled = true
	_anim.play("death")
	await _anim.animation_finished
=======
	$"Damage Area/CollisionShape2D".disabled = true
	anim.play("death")
	await anim.animation_finished
>>>>>>> aa0b159a17e4eb7b19b0d2d819600b25f0cf40d0
	Game.player_exp += 10
	self.queue_free()
	
func _on_player_detection_body_entered(body):
	if body.is_in_group("Player"):
		in_range = true

func _on_player_detection_body_exited(body):
	if body.is_in_group("Player"):
		in_range = false

func _on_attack_area_body_entered(body):
	if body.is_in_group("Player"):
		in_attack_area = true

func _on_attack_area_body_exited(body):
	if body.is_in_group("Player"):
		in_attack_area = false
		can_attack = false
