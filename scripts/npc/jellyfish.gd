class_name JELLYFISH
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
	# add an if statement area col detect here to 
	# distinguish which one of npc is currently interacting
	# same as the clam
	
	#if player detected:
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

# add functions to buttons
func on_next_pressed():
	print("Next is pressed")
	
func on_back_pressed():
	print("Back is pressed")

func on_skip_pressed():
	print("Skip is pressed")
