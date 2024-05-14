extends Node2D
@onready var pos_1 = $Pos1
@onready var pos_2 = $Pos2
@onready var pos_3 = $Pos3
@onready var pos_4 = $Pos4

func _ready():
	pos_1 = pos_1.global_position
	pos_2 = pos_2.global_position
	pos_3 = pos_3.global_position
	pos_4 = pos_4.global_position
