class_name BossShark
extends SeaEnemy
@onready var attack_cooldown = $AttackCooldown
@onready var control = $CanvasLayer/Control
func _ready():
	sprite = $BigSharkSprite
	anim = $BigSharkAnim
	collider = $BigSharkCol
	attack_range_col = $AttackRange/CollisionShape2D
	attack_col = $Attack/CollisionShape2D
	healthbar = $CanvasLayer/Control/HealthBar
	event_bus = $"../../EventBus"
	attack_range_pos = attack_range_col.position.x
	health = Game.enemy_hp * 2
	damage = Game.enemy_damage * 2
	movespeed = Game.enemy_speed * 2
	player = get_tree().get_first_node_in_group("Player")
	healthbar._init_health(health)
	anim.play("idle")
	Game.buffed.connect(_on_enemy_buff)
	dead.connect(death)

func _process(_delta):
	if anim.current_animation == "death":
		return
	if is_hurt:
		await hurt()
	if can_attack and in_attack_range:
		await on_enemy_attack()
		attack_cooldown.start()
	if in_range:
		control.visible = true
		moving()
	elif not in_range or not player:
		control.visible = false
		idling()

func _physics_process(_delta):
	sprite_orientation(velocity.x)
	if not player:
		velocity = Vector2.ZERO
	if in_attack_range or not is_alive:
		velocity = Vector2.ZERO
	else:
		follow_player()
	move_and_slide()

# SIGNAL CONNECTIONS:
func _on_player_detection_body_entered(body):
	if body.is_in_group("Player"):
		in_range = true

func _on_player_detection_body_exited(body):
	if body.is_in_group("Player"):
		in_range = false

func _on_damage_area_body_entered(body):
	if body.is_in_group("Player"):
		in_attack_range = true

func _on_damage_area_body_exited(body):
	if body.is_in_group("Player"):
		in_attack_range = false
		can_attack = false

func _on_attack_body_entered(body):
	if body.is_in_group("Player") and body.has_method("take_damage"):
		body.take_damage(damage)

func _on_attack_cooldown_timeout():
	can_attack = true
