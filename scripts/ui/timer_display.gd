extends PanelContainer
var time_content: int
@onready var time = $MarginContainer/Time

func _process(_delta):
	time.text = "%s"%time_content
