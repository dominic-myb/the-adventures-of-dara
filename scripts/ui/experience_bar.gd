extends ProgressBar

var experience = 0 : set = _set_experience

@onready var added_experience = $AddedExp
@onready var timer = $Timer

func _init_experience(_experience, max_experience):
	experience = _experience
	max_value = max_experience
	value = experience
	added_experience.max_value = max_experience
	added_experience.value = experience

func _set_experience(new_experience):
	var prev_experience = experience
	max_value = Game.player_max_exp
	experience = min(max_value, new_experience)
	value = new_experience
	
	if experience < prev_experience:
		timer.start()
	else:
		added_experience.value = experience


func _on_timer_timeout():
	added_experience.value = experience
