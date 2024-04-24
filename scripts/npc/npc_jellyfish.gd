extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var in_range : bool = false

@onready var j_sprite = $JSprite

func _ready():
	j_sprite.play("idle")

func _physics_process(delta):
	# if stay still jellyfish -> velocity = vector2.zero
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()

func _process(_delta):
	if in_range:
		j_sprite.play("interact")
	else:
		j_sprite.play("idle")

func _on_interaction_area_body_entered(body):
	if body.is_in_group("Player"):
		in_range = true


func _on_interaction_area_body_exited(body):
	if body.is_in_group("Player"):
		in_range = false
