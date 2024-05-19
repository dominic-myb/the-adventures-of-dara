extends Area2D

signal failed(_num: int)
signal out(minus_life: int)

@onready var player = $"../Player/Player"

func _on_body_entered(body):
	if body.is_in_group("Player"):
		player.visible = false
		out.emit(1)
		failed.emit(Game.PLAYER_QUEST_LEVEL)

