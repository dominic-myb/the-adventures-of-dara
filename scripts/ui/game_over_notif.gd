extends PanelContainer
var title_content: String
@onready var title = $MarginContainer/VBoxContainer/HBoxContainer2/Title

func _process(_delta):
	title.text = title_content
