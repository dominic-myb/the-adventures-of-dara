extends Area2D
signal done
var status_lvl: int = 4
@onready var anim = $AnimatedSprite2D

func _ready():
	done.connect(on_done)
	if Game.PLAYER_QUEST_LEVEL == 3:
		_fire_status(status_lvl)

# if this quest accepted the player attack should be water attack
func _process(_delta):
	_fire_status(status_lvl)

func _fire_status(_fire_stat: int):
	if status_lvl == 0:
		anim.play("fire_0")
	if _fire_stat == 4:
		anim.play("fire_4")
	elif _fire_stat == 3:
		anim.play("fire_3")
	elif _fire_stat == 2:
		anim.play("fire_2")
	elif _fire_stat == 1:
		anim.play("fire_1")
		await anim.animation_finished
		status_lvl = 0
	
func on_done():
	anim.play("no_fire")

func on_change_status():
	if status_lvl > 0:
		status_lvl -= 1
		print_debug(status_lvl)

func _on_body_entered(body):
	if body.is_in_group("Water"):
		on_change_status()
		print_debug("hit")
