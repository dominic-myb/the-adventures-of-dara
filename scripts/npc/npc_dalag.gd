extends CharacterBody2D

signal connected
var player : CharacterBody2D
var boulder : CharacterBody2D
var accepted : bool

@onready var sprite = $AnimatedSprite2D
@onready var collider = $CollisionShape2D
@onready var anim = $AnimationPlayer
@onready var guide = $ArrowGuide
@onready var heart = $AnimationPlayer2
@onready var heart_sprite = $Heart
@onready var quest_manager = $"../../QuestManager"

func _ready():
	guide.play("default")
	heart_sprite.hide()
	quest_manager.accepted.connect(on_accepted)
	player = get_tree().get_first_node_in_group("Player")
	
func _process(_delta):
	sprite_pos(position.x, player.global_position.x, sprite)
	if Game.QUEST_STATUS["Q1"] or accepted:
		anim.play("quest_done")
	else:
		on_unlocked()
	set_collision_pos(anim, collider)

func sprite_pos(_self_pos: float, _player_pos: float, _sprite: AnimatedSprite2D):
	heart.play("default")
	if _self_pos < _player_pos:
		_sprite.flip_h = false
		heart_sprite.position.x = 54
	elif _self_pos > _player_pos:
		_sprite.flip_h = true
		heart_sprite.position.x = -54

func set_collision_pos(_anim: AnimationPlayer, _col: CollisionShape2D):
	if heart.current_animation == "default":
		return
	if _anim.current_animation == "idle":
		_col.position.y = 40
	elif _anim.current_animation == "quest_done":
		_col.position.y = 0

func on_unlocked():
	accepted = false
	anim.play("idle")

func on_done(num: int):
	print(num)
	heart_sprite.show() 
	heart.play("default")
	guide.hide()
	anim.play("quest_done")

func on_accepted():
	accepted = true
	guide.hide()
