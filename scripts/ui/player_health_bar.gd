extends ProgressBar

var health = 0 : set = _set_health

@onready var timer = $Timer
@onready var damage_bar = $DamageBar

func _ready():
	_init_health(Game.player_hp)

func _set_health(new_health):
	var prev_health = health
	health = min(max_value, new_health)
	value = new_health
	
	
	if health < prev_health:
		timer.start()
	else:
		damage_bar.value = health

func _init_health(_health):
	health = _health
	max_value = health
	value = health
	damage_bar.max_value = health
	damage_bar.value = health


func _on_timer_timeout():
	damage_bar.value = health
