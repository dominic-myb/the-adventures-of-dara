extends PanelContainer

signal pressing(_num: int)
signal done(_num: int)
signal failed(_num: int)

const PAMINTA = preload("res://art/quests/quest5/food_land/paminta.png")
const PEPER = preload("res://art/quests/quest5/food_land/pepper.png")
const SILI = preload("res://art/quests/quest5/food_land/sili.png")
const RED = preload("res://art/quests/quest5/food_land/red.png")
const GREEN = preload("res://art/quests/quest5/food_land/green.png")

var touch_counter: int = 0 # reset
var points: int = 0 # reset
var enable_btns: bool # reset
var recipes : Array[String] = [
	"res://art/quests/quest5/food_land/brownsugar.png",
	"res://art/quests/quest5/food_land/flour.png",
	"res://art/quests/quest5/food_land/nut.png",
	"res://art/quests/quest5/food_land/oil.png",
	"res://art/quests/quest5/food_land/paminta.png", #
	"res://art/quests/quest5/food_land/pepper.png", #
	"res://art/quests/quest5/food_land/salt.png",
	"res://art/quests/quest5/food_land/sili.png", #
	"res://art/quests/quest5/food_land/water.png"
]

@onready var img_1 = $MarginContainer/GridContainer/img_1
@onready var img_2 = $MarginContainer/GridContainer/img_2
@onready var img_3 = $MarginContainer/GridContainer/img_3
@onready var img_4 = $MarginContainer/GridContainer/img_4
@onready var img_5 = $MarginContainer/GridContainer/img_5
@onready var img_6 = $MarginContainer/GridContainer/img_6
@onready var img_7 = $MarginContainer/GridContainer/img_7
@onready var img_8 = $MarginContainer/GridContainer/img_8
@onready var img_9 = $MarginContainer/GridContainer/img_9
@onready var grid_container = $MarginContainer/GridContainer

func _ready():
	enable_btns = false
	on_shuffle()
	failed.connect(on_quest_failed)
	pressing.connect(what_is_currently_pressing)
	connect_buttons()

func connect_buttons():
	for i in range(1, 10):
		var button_name = "img_%d" % i
		var texture_button = get_node("MarginContainer/GridContainer/"+button_name)
		var method_name = "_on_img_%d"%i+"_pressed"
		if texture_button == TextureButton:
			if not texture_button.is_connected("pressed", method_name):
				texture_button.disconnect("pressed", method_name)

func disconnect_buttons():
	for i in range(1, 10):
		var button_name = "img_%d" % i
		var texture_button = get_node("MarginContainer/GridContainer/"+button_name)
		var method_name = "_on_img_%d"%i+"_pressed"
		if texture_button == TextureButton:
			if texture_button.is_connected("pressed", method_name):
				texture_button.disconnect("pressed", method_name)

func _on_img_1_pressed():
	touch_counter += 1
	if button_checker(img_1):
		points += 1 
	pressing.emit(1)
	img_1.disconnect("pressed", _on_img_1_pressed)

func _on_img_2_pressed():
	touch_counter += 1
	if button_checker(img_2):
		points += 1 
	pressing.emit(2)
	img_2.disconnect("pressed", _on_img_2_pressed)

func _on_img_3_pressed():
	touch_counter += 1
	if button_checker(img_3):
		points += 1 
	pressing.emit(3)
	img_3.disconnect("pressed", _on_img_3_pressed)

func _on_img_4_pressed():
	touch_counter += 1
	if button_checker(img_4):
		points += 1 
	pressing.emit(4)
	img_4.disconnect("pressed", _on_img_4_pressed)

func _on_img_5_pressed():
	touch_counter += 1
	if button_checker(img_5):
		points += 1 
	pressing.emit(5)
	img_5.disconnect("pressed", _on_img_5_pressed)

func _on_img_6_pressed():
	touch_counter += 1
	if button_checker(img_6):
		points += 1 
	pressing.emit(6)
	img_6.disconnect("pressed", _on_img_6_pressed)

func _on_img_7_pressed():
	touch_counter += 1
	if button_checker(img_7):
		points += 1 
	pressing.emit(7)
	img_7.disconnect("pressed", _on_img_7_pressed)

func _on_img_8_pressed():
	touch_counter += 1
	if button_checker(img_8):
		points += 1 
	pressing.emit(8)
	img_8.disconnect("pressed", _on_img_8_pressed)

func _on_img_9_pressed():
	touch_counter += 1
	if button_checker(img_9):
		points += 1 
	pressing.emit(9)
	img_9.disconnect("pressed", _on_img_9_pressed)

func what_is_currently_pressing(_num: int):
	if touch_counter >= 6:
		enable_btns = true
		on_all_button_disable(enable_btns)
		if points >= 6:
			done.emit(5)
		else:
			failed.emit(5)
		visible = false

func on_shuffle():
	recipes.shuffle()
	for i in range(1, 10):
		var button_name = "img_%d" % i
		var texture_button = get_node("MarginContainer/GridContainer/"+button_name)
		if texture_button is TextureButton:
			var texture = load(recipes[i - 1])
			texture_button.texture_normal = texture
			if texture_button.texture_normal == PAMINTA:
				texture_button.texture_pressed = RED
			elif texture_button.texture_normal == SILI:
				texture_button.texture_pressed = RED
			elif texture_button.texture_normal == PEPER:
				texture_button.texture_pressed = RED
			else:
				texture_button.texture_pressed = GREEN

func button_checker(_img_1: TextureButton):
	_img_1.disabled = true
	if _img_1.texture_normal == PAMINTA or _img_1.texture_normal == SILI or _img_1.texture_normal == PEPER:
		_img_1.texture_normal = RED
		return false
	else:
		_img_1.texture_normal = GREEN
		return true

func on_quest_failed(_num: int):
	if _num == 5:
		#enable_btns = false
		#touch_counter = 0
		#points = 0
		#if pressing.is_connected(what_is_currently_pressing):
			#pressing.disconnect(what_is_currently_pressing)
		#for i in range(1, 10):
			#var button_name = "img_%d" % i
			#var texture_button = get_node("MarginContainer/GridContainer/"+button_name)
			#if texture_button is TextureButton:
				#if texture_button.disabled:
					#texture_button.disabled = false
				#texture_button.texture_pressed = null
				#if texture_button.toggle_mode == true:
					#texture_button.toggle_mode = false
		#disconnect_buttons()
		#connect_buttons()
		#pressing.connect(what_is_currently_pressing)
		#on_shuffle()

		queue_free()
func on_all_button_disable(_value: bool):
	for i in range(1, 10):
		var _button_name = "img_%d" % i
		var texture_button = get_node("MarginContainer/GridContainer/" + _button_name)
		if texture_button is TextureButton:
			if not texture_button.disabled:
				texture_button.disabled = true
