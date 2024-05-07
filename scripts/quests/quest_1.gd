extends Node2D


const garbage1 = preload("res://scenes/quests/garbage/garbage1.tscn")
const garbage2 = preload("res://scenes/quests/garbage/garbage2.tscn")
const garbage3 = preload("res://scenes/quests/garbage/garbage3.tscn")
const garbage4 = preload("res://scenes/quests/garbage/garbage4.tscn")
const garbage5 = preload("res://scenes/quests/garbage/garbage5.tscn")

var timeout: bool = false
var in_range: bool = false


@onready var pos_1 = $SpawnPos1
@onready var pos_2 = $SpawnPos2
@onready var pos_3 = $SpawnPos3
@onready var pos_4 = $SpawnPos4

@onready var quest_items = $"../QuestItems"
@onready var label = $QuestArea/CollisionShape2D/Label
@onready var area_time = $TimeInsideArea
@onready var quest_time = $QuestTime

func _process(_delta):
	# add a code if the quest is done then dont display time anymore
	# after talking to NPC then the cross should show but then hide it
	# after the quest hide the cross
	# limit garbage spawn
	if quest_time.time_left > 0:
		label.text = "%s" % int(quest_time.time_left)
		if is_divisible_by_five(int(quest_time.time_left)):
			spawn_garbage()
		
	if not timeout or not in_range:
		label.text = "Get Inside!"
	if area_time and area_time.time_left > 0:
		label.text = "%s" % int(area_time.time_left)
		if area_time.time_left < 1:
			label.text = "Go!"
func is_divisible_by_five(_num):
	if _num % 5 == 0:
		return true
	else:
		return false
func spawn_garbage():
	randomize()
	var random_float = randf()
	var garbage
	if random_float < 0.20:
		garbage = garbage1.instantiate()
	elif random_float < 0.40:
		garbage = garbage2.instantiate()
	elif random_float < 0.60:
		garbage = garbage3.instantiate()
	elif random_float < 0.80:
		garbage = garbage4.instantiate()
	elif random_float < 1.00:
		garbage = garbage5.instantiate()
	garbage.position = chance_position()
	garbage.velocity = 100
	get_tree().get_first_node_in_group("QuestItems").add_child(garbage)

func chance_position():
	var _pos : Vector2
	randomize()
	var random_float = randf()
	if random_float < 0.25:
		_pos = pos_1.global_position
	elif random_float < 0.50:
		_pos = pos_2.global_position
	elif random_float < 0.75:
		_pos = pos_3.global_position
	elif random_float < 1.00:
		_pos = pos_4.global_position
	return _pos

func _on_quest_area_body_entered(body):
	if body.is_in_group("Player"):
		area_time.start()
		in_range = true

func _on_quest_area_body_exited(body):
	if body.is_in_group("Player"):
		area_time.stop()
		in_range = false

func _on_time_inside_area_timeout():
	timeout = true
	quest_time.start()
	#spawn_garbage()
	
func _on_quest_time_timeout():
	pass # Replace with function body.

