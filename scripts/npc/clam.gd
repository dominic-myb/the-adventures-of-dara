extends Node2D

@onready var interaction_area : InteractionArea = $InteractionArea
@onready var sprite = $AnimatedSprite2D

const lines : Array[String] = [
	"Hello"
]

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")

func _on_interact():
	print_debug(lines[0])
	#add the ui for conversation here
	#add mission ui
