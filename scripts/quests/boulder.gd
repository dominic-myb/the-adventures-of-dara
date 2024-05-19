extends CharacterBody2D

signal done(_num: int)
signal failed(_num: int)
var max_hp: float = 50.00
var hp: float
var dalag : Area2D 
var timer_display: PanelContainer

@onready var anim = $AnimatedSprite2D
@onready var spawn_time = $SpawnTime
@onready var arrow_guide = $ArrowGuide
@onready var health_bar = $CanvasLayer/Control/HealthBar

func _ready():
	hp = max_hp
	timer_display = get_tree().get_first_node_in_group("Time")
	timer_display.visible = true
	health_bar._init_health(hp)
	dalag = get_tree().get_first_node_in_group("Dalag")
	done.connect(dalag.on_done)
	arrow_guide.play("default")
	anim.play("default")
	
func _process(delta):
	timer_display.time_content = spawn_time.time_left
	velocity.y += 100 * delta
	move_and_slide()

func take_damage(amount: float):
	hp -= amount
	health_bar.health = hp
	if (hp / max_hp) <= 0.25:
		anim.play("damaged_3")
	elif (hp / max_hp) <= 0.50:
		anim.play("damaged_2")
	elif (hp / max_hp) <= 0.75:
		anim.play("damaged_1")
	if hp <= 0:
		timer_display.visible = false
		anim.play("powder")
		await anim.animation_finished
		done.emit(0)
		queue_free()

func _on_spawn_time_timeout():
	timer_display.visible = false
	failed.emit(0)
	queue_free()
