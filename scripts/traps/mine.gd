extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var mine_sprite = $MineSprite

func _ready():
	mine_sprite.play("default")

func _physics_process(_delta):
	velocity = Vector2.ZERO
	move_and_slide()

func _on_mine_trigger_body_entered(body):
	if body.is_in_group("Player"):
		explode()

func explode():
	mine_sprite.play("explode")
	await mine_sprite.animation_finished
	queue_free()
