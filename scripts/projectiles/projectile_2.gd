extends CharacterBody2D

var speed : float = 1000.0
@onready var projectile_sprite = $ProjectileSprite

func _ready():
	projectile_sprite.play("default")

func _physics_process(delta):
	var collision_info = move_and_collide(velocity.normalized() * delta * speed)
	if collision_info:
		var collider = collision_info.get_collider()
		if collider.has_method("take_damage"):
			collider.take_damage(Game.player_damage)
		queue_free()
