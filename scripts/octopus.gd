extends CharacterBody2D
var player : CharacterBody2D
var in_range : bool
var speed := 100.0
var in_damage_area : bool
var can_attack : = true
var attack_cd = 3.0
var cd_timer = 0.0
func _ready():
	player = get_tree().get_first_node_in_group("Player")
	$AnimationPlayer.play("idle")
func _process(_delta):
	print(can_attack)
	if can_attack and in_damage_area:
		await on_enemy_attack($AnimationPlayer)
	if in_range:
		$AnimationPlayer.play("move")
	else:
		$AnimationPlayer.play("idle")
func _physics_process(delta):
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
	if not in_damage_area:
		if pos > 0: 
			$AnimatedSprite2D.flip_h = false
			$"Damage Area/CollisionShape2D".set_rotation_degrees(0)
		elif pos < 0: 
			$AnimatedSprite2D.flip_h = true
			$"Damage Area/CollisionShape2D".set_rotation_degrees(-90)

func on_enemy_attack(anim : AnimationPlayer):
	velocity = Vector2.ZERO
	anim.play("attack")
	await anim.animation_finished
	can_attack = false

func on_attack_cooldown(delta):
	cd_timer += delta
	if cd_timer >= attack_cd:
		can_attack = true
		cd_timer = 0.0

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
