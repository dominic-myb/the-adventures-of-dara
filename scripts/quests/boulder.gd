extends CharacterBody2D

signal done(num: int)

var hp: float = 10.00
var dalag : Area2D 

@onready var arrow_guide = $ArrowGuide
@onready var health_bar = $CanvasLayer/Control/HealthBar

func _ready():
	health_bar._init_health(hp)
	dalag = get_tree().get_first_node_in_group("Dalag")
	done.connect(dalag.on_done)
	arrow_guide.play("default")
	
func _process(delta):
	velocity.y += 100 * delta
	move_and_slide()

func take_damage(amount: float):
	hp -= amount
	health_bar.health = hp
	if hp <= 0:
		#Game.QUEST_STATUS["Q1"] = true # status of 1st quest is true | done
		done.emit(0) # emit quest index num | enum
		queue_free()
