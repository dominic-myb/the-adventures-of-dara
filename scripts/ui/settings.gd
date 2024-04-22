extends Control

signal is_pressed

func _on_exit_pressed():
	emit_signal("is_pressed")
