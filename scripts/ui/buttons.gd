extends Control
@onready var attack_anim = $AttackAnim
@onready var interact_anim = $InteractAnim
var atk_is_pressed : bool
var int_is_pressed : bool
func _ready():
	attack_anim.play("unpressed")
	interact_anim.play("unpressed")

func _process(_delta):
	attack_anim.play("pressed" if atk_is_pressed else "unpressed")
	interact_anim.play("pressed" if int_is_pressed else "unpressed")
func _on_attack_button_down():
	atk_is_pressed = true


func _on_attack_button_up():
	atk_is_pressed = false


func _on_interact_button_down():
	int_is_pressed = true


func _on_interact_button_up():
	int_is_pressed = false
