extends CharacterBody2D
var player : CharacterBody2D
var in_range : bool
var in_damage_area : bool
var can_attack : bool
var speed := 100.0
var attack_cd := 3.0
var cd_timer := 0.0
var health = Game.enemy_hp
var is_hurt := false
@onready var anim = $SharkAnimPlayer
@onready var sprite = $SharkSprite
@onready var col = $SharkCol
@onready var damage_col = $DamageArea/CollisionShape2D
func _ready():
	player = get_tree().get_first_node_in_group("Player")
	anim.play("idle")
func _process(_delta):
	if is_hurt:
		anim.play("hurt")
		await anim.animation_finished
		is_hurt = false
	if can_attack and in_damage_area:
		await on_enemy_attack(anim)
	anim.play("move" if in_range else "idle")

func _physics_process(delta):
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
	if health <= 0: 
		print_debug("death")
		await death()
	else: return health

func death():
	anim.play("death")
	await anim.animation_finished
	queue_free()

func sprite_position(pos: float):
	if pos > 0: 
		sprite.flip_h = false
		damage_col.position.x = 27
	elif pos < 0: 
		sprite.flip_h = true
		damage_col.position.x = -27

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
