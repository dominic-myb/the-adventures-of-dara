class_name CLAM
extends NPC

signal pressed
const PLAYER_PIC = preload("res://art/package-icon/ICON.png")
const CLAM_PIC = preload("res://art/npc/clam-pic.png")
var next_btn : TextureButton
var back_btn : TextureButton
var skip_btn : TextureButton
func _ready():
	next_btn = get_node("%Next")
	back_btn = get_node("%Back")
	skip_btn = get_node("%Skip")
	next_btn.connect("pressed", on_next_pressed)
	back_btn.connect("pressed", on_back_pressed)
	skip_btn.connect("pressed", on_skip_pressed)
	lines = [
		"Hello",
		"Hi"
	]
	pictures = [
		CLAM_PIC,
		PLAYER_PIC
	]
func on_next_pressed():
	print("Next is pressed")
	
func on_back_pressed():
	print("Back is pressed")

func on_skip_pressed():
	print("Skip is pressed")
