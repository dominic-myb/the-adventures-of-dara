class_name PlayerEarth extends CharacterBody2D

const WATER = preload("res://scenes/projectiles/water.tscn")
const SPEED = 400.0
const JUMP_VELOCITY = -500.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_shoot: bool = true
var lock_shoot: bool = false
var cd: float = 3.0
var counter: float = 0.0
var can_move: bool = true

@onready var sprite = $AnimatedSprite2D
@onready var anim = $AnimationPlayer
@onready var collider = $CollisionShape2D
@onready var marker_2d = $Marker2D
@onready var music = $SoundFX/Music
@onready var on_accept = $SoundFX/OnAccept
@onready var on_done = $SoundFX/OnDone
@onready var on_failed = $SoundFX/OnFailed
@onready var quest_manager = $"../../QuestManager"

func _ready():
	quest_manager.connect("accepted", on_accept_quest)
	quest_manager.connect("failed", on_failed_quest)
	quest_manager.connect("done", on_done_quest)
	music.play()

func _physics_process(delta):
	var direction = Input.get_axis("left", "right")
	_gravity(delta)
	_on_move(direction)
	_on_jump()
	if not lock_shoot:
		shoot(delta)
	# add a condition can_move here !
	if can_move:
		move_and_slide()

func _process(_delta):
	_on_sprite_orientation(velocity.x)
	if anim.current_animation == "death":
		return
	if anim.current_animation == "hurt":
		return
	if anim.current_animation == "fall":
		return
	if anim.current_animation == "jump":
		return
	_on_idle_anim(velocity)
	_on_move_anim(velocity.x)
	_on_jump_anim(velocity.y)
	_on_fall_anim(velocity.y)
	

func _gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func _on_jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
func _on_move(_direction: float):
	if _direction:
		velocity.x = _direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
func _on_sprite_orientation(_direction: float):
	if _direction > 0:
		sprite.flip_h = false
		collider.position.x = -7
		marker_2d.position.x = 45
	elif _direction < 0:
		sprite.flip_h = true
		collider.position.x = 7
		marker_2d.position.x = -45

func _on_move_anim(_direction: float):
	if _direction:
		anim.play("move")
	
func _on_idle_anim(_velocity: Vector2):
	if _velocity == Vector2.ZERO:
		anim.play("idle")

func _on_jump_anim(_velocity_y: float):
	if _velocity_y < 0:
		anim.play("jump")

func _on_fall_anim(_velocity_y: float):
	if _velocity_y > 0:
		anim.play("fall")

func shoot(delta):
	if not can_shoot:
		counter += delta
		if counter >= cd:
			can_shoot = true
	elif Input.is_action_just_pressed("attack") and can_shoot:
		can_shoot = false
		_on_shoot()

func _on_shoot():
	var water = WATER.instantiate()
	water.position = marker_2d.global_position
	if get_tree().get_first_node_in_group("Water").get_children().size() < 1:
		get_tree().get_first_node_in_group("Water").add_child(water)


func _on_music_finished():
	music.play()
func on_accept_quest(_num: int):
	on_accept.play()
func on_failed_quest(_num: int):
	on_failed.play()
func on_done_quest(_num: int):
	on_done.play()
