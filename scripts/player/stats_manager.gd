extends Node

@onready var damage = $"../CanvasLayer/Container/Stats/Damage"
@onready var regen_rate = $"../CanvasLayer/Container/Stats/RegenRate"
@onready var speed = $"../CanvasLayer/Container/Stats/Speed"
@onready var damage_timer = $"../CanvasLayer/Container/Timers/DamageTimer"
@onready var regen_rate_timer = $"../CanvasLayer/Container/Timers/RegenRateTimer"
@onready var speed_timer = $"../CanvasLayer/Container/Timers/SpeedTimer"
@onready var player = $".."

func _ready():
	stats_update_display()

func _process(_delta):
	stats_update_display()

func round_place(num,places):
	return (round(num*pow(10,places))/pow(10,places))

func stats_update_display():
	damage.text = "Damage: %s" % round_place(player.damage,2)
	regen_rate.text = "RegenRate: %s" % round_place(player.mana_regen_rate,2)
	speed.text = "Movespeed: %s" % round_place(player.movespeed,2)
	if player.damage_buff_timer:
		damage_timer.text = "%s" % round_place(player.damage_buff_timer.time_left,2)
	if player.mana_buff_timer:
		regen_rate_timer.text = "%s" % round_place(player.mana_buff_timer.time_left,2)
	if player.movespeed_buff_timer:
		speed_timer.text = "%s" % round_place(player.movespeed_buff_timer.time_left,2)
