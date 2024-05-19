extends Node2D

@onready var heart_1 = $Heart1
@onready var heart_2 = $Heart2
@onready var heart_3 = $Heart3

func _process(_delta):
	if Game.player_hp == 3:
		heart_1.play("1")
		heart_2.play("1")
		heart_3.play("1")
	elif Game.player_hp == 2:
		heart_1.play("1")
		heart_2.play("1")
		heart_3.play("0")
	elif Game.player_hp == 1:
		heart_1.play("1")
		heart_2.play("0")
		heart_3.play("0")
	elif Game.player_hp == 0:
		heart_1.play("0")
		heart_2.play("0")
		heart_3.play("0")
