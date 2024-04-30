extends ProgressBar

var mana = 0 : set = _set_mana

@onready var mana_regen = $ManaRegen
@onready var timer = $Timer

func _init_mana(_mana):
	mana = _mana
	max_value = mana
	value = mana
	mana_regen.max_value = mana
	mana_regen.value = mana

func _set_mana(new_mana):
	var prev_mana = mana
	mana = min(max_value, new_mana)
	value = new_mana
	
	if mana < prev_mana:
		timer.start()
	else:
		mana_regen.value = mana
