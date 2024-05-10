extends PanelContainer

var text_to_display = "Panatilihing malinis ang karagatan"
@onready var label = $Label
@onready var anim = $AnimationPlayer

func _ready():
	set_text_with_wrap(text_to_display)

func _process(_delta):
	anim.play("default")

func set_text_with_wrap(text: String):
	var wrapped_text = ""
	var current_line = ""
	var char_count = 0

	for word in text.split(" "):
		if char_count + len(word) > 14:
			wrapped_text += current_line + "\n"
			current_line = ""
			char_count = 0
		current_line += word + " "
		char_count += len(word) + 1

	if current_line != "":
		wrapped_text += current_line

	label.set_text(wrapped_text)
