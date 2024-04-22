extends CharacterBody2D
var player : CharacterBody2D

@onready var anim = $BigSharkAnim
@onready var attack_col = $AttackArea/AttackCol
@onready var sprite = $BigSharkSprite

var health := 100
var movespeed := 100
var attack_cd := 0.0
var cd_timer := 0.0
var damage = Game.enemy_damage * 2
var is_alive := true
var in_range := false
var in_attack_area := false
var is_hurt := false
var can_attack := true
func _ready():
	player = get_tree().get_first_node_in_group("Player")
	anim.play("idle")

func _process(_delta):
	if is_alive:
		if is_hurt:
			anim.play("hurt")
			await anim.animation_finished
			is_hurt = false
		if can_attack and in_attack_area:
			await on_enemy_attack(anim)
		anim.play("move" if in_range else "idle")

func _physics_process(delta):
	if is_alive:
		if not can_attack:
			on_attack_cooldown(delta)
		if in_attack_area:
			velocity = Vector2.ZERO
		else:
			follow_player()
		move_and_slide()

func sprite_position(pos : float):
	#change the attack collider pos
	if pos > 0:
		sprite.flip_h = false
		attack_col.position.x = 83
	elif pos < 0:
		sprite.flip_h = true
		attack_col.position.x = -83

func follow_player():
	var direction = (player.global_position - self.global_position)
	if in_range:
		velocity = direction.normalized() * movespeed
		sprite_position(direction.normalized().x)
	else:
		#ADD PATROL METHOD
		velocity = Vector2.ZERO

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
	if health <= 0: death()
	else: return health

func death():
	is_alive = false
	anim.play("death")
	await anim.animation_finished
	queue_free()

func _on_player_detection_body_entered(body):
	if body.is_in_group("Player"):
		in_range = true

func _on_player_detection_body_exited(body):
	if body.is_in_group("Player"):
		in_range = false

func _on_attack_area_body_entered(body):
	if body.is_in_group("Player"):
		in_attack_area = true
		player.take_damage(damage)

func _on_attack_area_body_exited(body):
	if body.is_in_group("Player"):
		in_attack_area = false
		can_attack = false

