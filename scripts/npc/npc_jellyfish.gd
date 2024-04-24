extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var in_range : bool = false

@onready var j_sprite = $JSprite

func _ready():
	j_sprite.play("idle")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()

func _process(_delta):
	if in_range:
		j_sprite.play("interact")
	else:
		j_sprite.play("idle")
