extends CharacterBody2D
signal done(num: int)
var hp: float = 10.00
func _process(delta):
	velocity.y += 100 * delta
	move_and_slide()

func take_damage(amount: float):
	hp -= amount
	if hp <= 0:
		Game.QUEST_STATUS["Q1"] = true # status of 1st quest is true | done
		done.emit(0) # emit quest index num | enum
		queue_free()
	return hp
