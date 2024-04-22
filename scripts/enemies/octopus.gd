extends CharacterBody2D
@onready var anim = $OctoAnim
@onready var sprite = $OctoSprite
var player : CharacterBody2D
var in_range : bool
var in_damage_area : bool
var can_attack := true
var is_alive := true
var is_hurt := false
var movespeed := 100.0
var attack_cd = 3.0
var cd_timer = 0.0
var health = Game.enemy_hp
var damage = Game.enemy_damage
func _ready():
	player = get_tree().get_first_node_in_group("Player")
	await idle(anim)

func _process(_delta):
	if is_alive:
		if is_hurt:
			await hurt(anim)
		if can_attack and in_damage_area:
			velocity = Vector2.ZERO
			sprite_position(velocity.x)
			await on_enemy_attack(anim)
		if in_range:
			await move(anim)
		else:
			await idle(anim)

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
			velocity = direction.normalized() * movespeed
			sprite_position(direction.normalized().x)
		else:
			velocity = Vector2.ZERO

func sprite_position(pos: float):
	if pos > 0: sprite.flip_h = false
	elif pos < 0: sprite.flip_h = true

func on_enemy_attack(_anim : AnimationPlayer):
	_anim.play("attack")
	await _anim.animation_finished
	can_attack = false

func on_attack_cooldown(delta):
	cd_timer += delta
	if cd_timer >= attack_cd:
		can_attack = true
		cd_timer = 0.0

func take_damage(amount):
	is_hurt = true
	health -= amount
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
	velocity = Vector2.ZERO
	is_alive = false
	_anim.play("death")
	await _anim.animation_finished
	Game.player_exp += 10
	Utils.saveGame()
	self.queue_free()

func _on_player_detection_body_entered(body):
	if body.is_in_group("Player"):
		in_range = true

func _on_player_detection_body_exited(body):
	if body.is_in_group("Player"):
		in_range = false

func _on_attack_area_body_entered(body):
	if body.is_in_group("Player"):
		in_damage_area = true

func _on_attack_area_body_exited(body):
	if body.is_in_group("Player"):
		in_damage_area = false
		can_attack = false