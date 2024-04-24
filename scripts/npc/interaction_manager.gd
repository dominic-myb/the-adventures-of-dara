extends Node
"""
+ Add Conversation, then mission
+ Add a mission manager 3 states enum[to accept, working onit, done]
+ Add a constraint that stops the player from getting the mission again
+ Add a new conversation array based from the current mission state
+ Add Exp value per mission
+ Make healthbar, manabar, expbar
+ Make healthbar, lvlnum above in mobs
+ Make healthbar, anchor bottom center with name above
+ Make a resource save
+ Make all death functions private
+ Add character stats manager 
+ Use signals on_health_change
"""
@onready var interact_btn = $"../CanvasLayer/RightButtonContainer/RightButtons/Interact"
@onready var conversation = $"../CanvasLayer/Conversation"

func _ready():
	conversation.visible = false
	interact_btn.visible = false
