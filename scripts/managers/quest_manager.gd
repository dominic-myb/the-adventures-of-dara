extends Node

signal pressed
signal zero_hp
signal unlocked(num: int)
signal accepted(num: int)
signal failed(num: int)
signal done(num: int)

enum QUEST_LEVEL { 
	Q1, Q2,Q3
}

enum QUEST_STATUS { 
	LOCKED, UNLOCKED, ACCEPTED,DONE
}

enum NPC { 
	DALAG, PAWIKAN, KABIBE
}

const QUEST2 = preload("res://scenes/quests/quest2/quest2.tscn")
const PEARL = preload("res://scenes/quests/quest3/pearl.tscn")
const BOULDER = preload("res://scenes/quests/quest1/boulder.tscn")
const PLAYER_IMG = preload("res://art/player/player-img.png")
const DALAG_IMG = preload("res://art/npc//dalag/dalag-pic.png")
const PAWIKAN_IMG = preload("res://art/npc/pawikan/pawikan-pic.png")
const KABIBE_DEF = preload("res://art/npc/kabibe/kabibe_def_img.png")
const KABIBE_DONE = preload("res://art/npc/kabibe/kabibe_done_img.png")
const KABIBE_IDLE = preload("res://art/npc/kabibe/kabibe_idle_img.png")

# must load this 
var NPC_QUEST_STATUS = {
	NPC.DALAG:{
		"status" : QUEST_STATUS.UNLOCKED,
		"level" : QUEST_LEVEL.Q1
	},
	NPC.PAWIKAN:{
		"status" : QUEST_STATUS.LOCKED,
		"level" : QUEST_LEVEL.Q2
	},
	NPC.KABIBE:{
		"status" : QUEST_STATUS.LOCKED,
		"level" : QUEST_LEVEL.Q3
	}
}

var next_btn : TextureButton
var back_btn : TextureButton
var skip_btn : TextureButton

var lines_counter : int = 0
var lines : Array[String] = []
var pictures : Array[Texture2D] = []

var has_active_quest : bool 
var active_npc : int
var on: bool = true

@onready var interact = $"../CanvasLayer/RightButtonContainer/RightButtons/Interact"
@onready var conversation_box = $"../CanvasLayer/Conversation"
@onready var lines_holder = $"../CanvasLayer/Conversation/MarginContainer/LinesCon/LinesHolder"
@onready var joystick = $"../CanvasLayer/JoystickContainer"
@onready var right_buttons = $"../CanvasLayer/RightButtonContainer"
@onready var picture = $"../CanvasLayer/Conversation/MarginContainer/LinesCon/Picture"
@onready var quest_items = $"../Player/Player/Basket"
@onready var quest_2 = $"../Quest2"
@onready var quest_3 = $"../Quest3"
@onready var quest_notification = $"../CanvasLayer/QuestNotification"

@onready var game_over = $"../CanvasLayer/GameOver"
@onready var retry = $"../CanvasLayer/GameOver/MarginContainer/VBoxContainer/HBoxContainer/Retry"
@onready var home = $"../CanvasLayer/GameOver/MarginContainer/VBoxContainer/HBoxContainer/Home"
@onready var player = $"../Player/Player"

@onready var kabibe = $"../NPC/Kabibe"
@onready var pawikan = $"../NPC/Pawikan"
@onready var dalag = $"../NPC/Dalag"

func _ready():
	quest_items.hide()
	accepted.connect(quest)
	zero_hp.connect(on_zero_hp)
	retry.connect("pressed", on_retry)
	home.connect("pressed", on_home)
	interact.visible = false
	conversation_box.visible = false
	game_over.visible = false
	
	next_btn = get_node("%Next")
	back_btn = get_node("%Back")
	skip_btn = get_node("%Skip")
	
"""
START OF BUTTON MANAGER
"""
func buttons_connect():
	next_btn.connect("pressed", on_next_pressed)
	back_btn.connect("pressed", on_back_pressed)
	skip_btn.connect("pressed", on_skip_pressed)

func buttons_disconnect():
	next_btn.disconnect("pressed", on_next_pressed)
	back_btn.disconnect("pressed", on_back_pressed)
	skip_btn.disconnect("pressed", on_skip_pressed)

func on_out_of_range():
	controls(joystick, right_buttons, true)
	conversation(conversation_box, false)

func on_interact_pressed():
	player.can_move = false
	convo_manager()
	controls(joystick, right_buttons, false)
	conversation(conversation_box, true)
	line_controller(picture)

func on_next_pressed():
	lines_counter += 1
	if lines_counter >= lines.size():
		player.can_move = true
		conversation(conversation_box, false)
		controls(joystick, right_buttons, true)
		lines_counter = 0
		if NPC_QUEST_STATUS[active_npc]["status"] == QUEST_STATUS.UNLOCKED and not has_active_quest:
			NPC_QUEST_STATUS[active_npc]["status"] = QUEST_STATUS.ACCEPTED
			accepted.emit(active_npc)
	else:
		line_controller(picture)

func on_back_pressed():
	lines_counter -= 1
	if lines_counter < 0:
		lines_counter = 0
	else:
		line_controller(picture)

func on_skip_pressed():
	convo_manager()
	conversation(conversation_box, false)
	controls(joystick, right_buttons, true)
	if NPC_QUEST_STATUS[active_npc]["status"] == QUEST_STATUS.UNLOCKED and not has_active_quest:
		NPC_QUEST_STATUS[active_npc]["status"] = QUEST_STATUS.ACCEPTED
		accepted.emit(active_npc)
		has_active_quest = true
	player.can_move = true

func controls(container1: HBoxContainer, container2: HBoxContainer, value: bool):
	container1.visible = value
	container2.visible = value

func conversation(panel: PanelContainer, value: bool):
	panel.visible = value

func interact_btn(btn: TouchScreenButton, value: bool):
	btn.visible = value

"""
START OF CONVERSATION MANAGER
"""
func line_controller(_pictures: TextureRect):
	_pictures.texture = pictures[lines_counter]
	lines_holder.text = lines[lines_counter]

func convo_manager():
	lines_counter = 0
	if active_npc == NPC.DALAG and NPC_QUEST_STATUS[active_npc]["status"] == QUEST_STATUS.LOCKED:
			lines = [
				"Hindi ka pa handa para dito!"
			]
			pictures = [
				DALAG_IMG
			]
	elif active_npc == NPC.PAWIKAN and NPC_QUEST_STATUS[active_npc]["status"] == QUEST_STATUS.LOCKED:
			lines = [
				"Hindi ka pa handa para dito!"
			]
			pictures = [
				PAWIKAN_IMG
			]
	elif active_npc == NPC.KABIBE and NPC_QUEST_STATUS[active_npc]["status"] == QUEST_STATUS.LOCKED:
			lines = [
				"Hindi ka pa handa para dito!"
			]
			pictures = [
				KABIBE_IDLE
			]
	elif active_npc == NPC.DALAG and NPC_QUEST_STATUS[active_npc]["status"] == QUEST_STATUS.UNLOCKED:
		lines = [
			"Kaibigan, saan ka patungo?",
			"At mukhang kaybigat ng iyong dala?",
			"Kaibigan para ito sa aking mahal na ina na may sakit",
			"Kay saklap naman ng sinapit ng iyong ina kaibigan",
			"Oo nga kaibigan.",
			"Kailangan kong dikdikin ang mga batong ito at paghaluhaluin",
			"nang sa gayon ay mapagaling ko ang aking ina.",
			"Mahihirapan ka niyan at pagdating mo sa iyong paroroonan ay...",
			"baka hindi mo na madikdik ang bato at pagod ka na sa iyong paglalakbay, ",
			"atin nang pagtulungan at dikdikin ang mga bato para ipainom sa iyong maysakit na ina"
		]
		pictures = [
			PLAYER_IMG,
			PLAYER_IMG,
			DALAG_IMG,
			PLAYER_IMG,
			DALAG_IMG,
			DALAG_IMG,
			DALAG_IMG,
			PLAYER_IMG,
			PLAYER_IMG,
			PLAYER_IMG
		]
	elif active_npc == NPC.DALAG and NPC_QUEST_STATUS[active_npc]["status"] == QUEST_STATUS.ACCEPTED:
		lines = [
			"Tulungan mo akong dikdikin ang bato",
			"Tutulungan kita"
		]
		pictures = [
			DALAG_IMG,
			PLAYER_IMG
		]
	elif active_npc == NPC.DALAG and NPC_QUEST_STATUS[active_npc]["status"] == QUEST_STATUS.DONE:
		lines = [
			"Maraming salamat, Dara",
			"Walang anuman, humayo ka na para mapainom mo na ng gamot ang iyong ina"
		]
		pictures = [
			DALAG_IMG,
			PLAYER_IMG
		]
	elif active_npc == NPC.PAWIKAN and NPC_QUEST_STATUS[active_npc]["status"] == QUEST_STATUS.UNLOCKED:
		lines = [
			"Kaibigan ano ang nangyari?",
			"Dahil sa mga basurang bumabagsak galing sa kalupaan lumalala na ang polusyon dito sa ating tahanan",
			"Tama ka kaibigan dahil sa polusyon nagkaroon ng sakit ang aking kaibigan na si Hito",
			"Mabuti nalamang ay nagamot namin siya, at hindi na lumala pa ang kanyang sakit.",
			"Mabuti naman kung ganoon kaibigan",
			"Kaibigan maari mo bang linisin ang mga basurang nalalag mula sa kalupaan.",
			"Oo kaibigan, para sa ikaaayos ng ating tahanan."
		]
		pictures = [
			PLAYER_IMG,
			PAWIKAN_IMG,
			PLAYER_IMG,
			PLAYER_IMG,
			PAWIKAN_IMG,
			PAWIKAN_IMG,
			PLAYER_IMG
		]
	elif active_npc == NPC.PAWIKAN and NPC_QUEST_STATUS[active_npc]["status"] == QUEST_STATUS.ACCEPTED:
		lines = [
			"Maraming salamat, Dara. Malaking tulong ito sa amin.",
			"Walang anuman. Masaya akong makatulong. Sana mas marami pang tao ang magising sa ganitong problema.",
			"Sana nga. Kung magtutulungan ang lahat, mas magiging maganda ang kinabukasan ng ating karagatan.",
			"Tama ka. Sige, tatapusin ko na ang paglilinis dito. Ingat ka, kaibigan!",
			"Maraming salamat ulit. Ingat din at nawa'y maging matagumpay ka sa iyong misyon."
		]
		pictures = [
			PAWIKAN_IMG,
			PLAYER_IMG,
			PAWIKAN_IMG,
			PLAYER_IMG,
			PAWIKAN_IMG
		]
	elif active_npc == NPC.PAWIKAN and  NPC_QUEST_STATUS[active_npc]["status"] == QUEST_STATUS.DONE:
		lines = [
			"Kumusta, kaibigan! Mas mabuti na ang pakiramdam ko ngayon. Salamat sa iyong pagsusumikap. Ang linis na ng karagatan!",
			"Natutuwa akong marinig yan. Mahirap ang quest na ito, pero sulit kapag nakikita kitang masaya.",
			"Malaking bagay ang iyong pagsisikap para sa aming mga nilalang sa dagat. Mas malaya kaming makalangoy at mas ligtas na kami ngayon.",
			"Napakaganda. Patuloy kong gagawin ang aking bahagi para panatilihing malinis ang karagatan.",
			"Salamat! Kung lahat sana ay kasing mapagmalasakit mo, magiging mas maganda ang ating mundo.",
			"Ipapalaganap ko ang mensahe at hihikayatin ang iba na tumulong din. Sama-sama, malaki ang magagawa natin.",
			"Tumpak! Salamat muli, at sana’y madalas kang dumalaw sa amin.",
			"Oo, dadalaw ako. Ingat ka, Pawikan!",
			"Ikaw rin, kaibigan. Paalam!"
		]
		pictures = [
			PAWIKAN_IMG,
			PLAYER_IMG,
			PAWIKAN_IMG,
			PLAYER_IMG,
			PAWIKAN_IMG,
			PLAYER_IMG,
			PAWIKAN_IMG,
			PLAYER_IMG,
			PAWIKAN_IMG
		]
	elif active_npc == NPC.KABIBE and NPC_QUEST_STATUS[active_npc]["status"] == QUEST_STATUS.UNLOCKED:
		lines = [
			"Kaibigan ano ang iyong problema, at mukang kay lungkot mo?",
			"Kaibigan nawawala ang perlas na aking iniingatan, dahil sa bagyo na dumaan.",
			"Ganoon ba kaibigan, nasalanta din ako ng bagyong dumaan.",
			"Namaalam ang aking mahal na ina at ama dahil sa bagyong iyon.",
			"Kay sama pala ng naidulot saiyo ba bagyong iyon kaibigan.",
			"Kaibigan maari mo ba akong tulungan hanapin ang aking nawawalang perlas?",
			"Oo naman kaibigan.",
			"Tayo tayo din naman ang magtutulungan aking kaibigan",
			"Maraming salamat kaibigan",
			"Balikan mo nalang ako dito sa aking lugar pag nahanap mo na ang aking perlas aking kaibigan"
		]
		pictures = [
			PLAYER_IMG,
			KABIBE_DEF,
			PLAYER_IMG,
			PLAYER_IMG,
			KABIBE_DEF,
			KABIBE_DEF,
			PLAYER_IMG,
			PLAYER_IMG,
			KABIBE_DEF,
			KABIBE_DEF
		]
	elif active_npc == NPC.KABIBE and NPC_QUEST_STATUS[active_npc]["status"] == QUEST_STATUS.ACCEPTED:
		lines = [
			"Pakihanap ang aking nawawalang perlas",
			"Tutulungan kita na hanapin!"
		]
		pictures = [
			KABIBE_DEF,
			PLAYER_IMG
		]
	elif active_npc == NPC.KABIBE and  NPC_QUEST_STATUS[active_npc]["status"] == QUEST_STATUS.DONE:
		lines = [
			"Kaibigan natagpuan ko na ang iyong nawawalang perlas",
			"Maraming salamat sa pag hanap at pag balik mo sa aking nawawalang perlas kaibigan",
			"Walang ano man kaibigan",
			"Sana ikaw ay lumigaya na dahil nahanap mo na ang nawawalang perlas",
			"Ako ay lubos na masaya na kaibigan",
			"Sana ay mapag tagumpayan mo na din ang misyon na naiwan sayo ng iyong mga magulang kaibigan",
			"Ako ay umaasa na mapag tagumpayan ko ang aking misyon kaibigan",
			"Humayo ka na kaibigan at malayo pa ang iyong lalakbayin",
			"Paalam kaibigan",
			"Paalam aking kaibigan"
		]
		pictures = [
			PLAYER_IMG,
			KABIBE_DONE,
			PLAYER_IMG,
			PLAYER_IMG,
			KABIBE_DONE,
			KABIBE_DONE,
			PLAYER_IMG,
			KABIBE_DONE,
			KABIBE_DONE,
			PLAYER_IMG
		]
	
"""
START OF QUEST MANAGER
"""
		
func quest(_num: int):
	if Game.PLAYER_QUEST_LEVEL == 0 and quest_accepted(_num):
		# DALAG
		var boulder = BOULDER.instantiate()
		boulder.position = dalag.global_position
		get_tree().get_first_node_in_group("QuestItems").add_child(boulder)
		boulder.connect("done", quest_done)
		boulder.connect("failed", quest_failed)
		
	elif Game.PLAYER_QUEST_LEVEL == 1 and quest_accepted(_num):
		# PAWIKAN
		quest_items.show()
		quest_2.visible = true
		quest_2.toggle_guide(true)
		quest_2.col1.set_disabled(false)
		quest_2.col2.set_disabled(false)
		quest_2.connect("done", quest_done)
		quest_2.connect("failed", quest_failed)

	elif Game.PLAYER_QUEST_LEVEL == 2 and quest_accepted(_num):
		# KABIBE
		var pearl = PEARL.instantiate()
		randomize()
		var random_float = randf()
		if random_float < 0.10:
			pearl.position = quest_3.pos_1
		elif random_float < 0.20:
			pearl.position = quest_3.pos_2
		elif random_float < 0.30:
			pearl.position = quest_3.pos_3
		elif random_float < 0.40:
			pearl.position = quest_3.pos_4
		elif random_float < 0.50:
			pearl.position = quest_3.pos_5
		elif random_float < 0.60:
			pearl.position = quest_3.pos_6
		elif random_float < 0.70:
			pearl.position = quest_3.pos_7
		elif random_float < 0.80:
			pearl.position = quest_3.pos_8
		elif random_float < 0.90:
			pearl.position = quest_3.pos_9
		elif random_float < 1.00:
			pearl.position = quest_3.pos_10
		get_tree().get_first_node_in_group("QuestItems").add_child(pearl)
		pearl.connect("done", quest_done)
		pearl.connect("failed", quest_failed)

#func quest_unlocked(_num: int):
	#if NPC_QUEST_STATUS[NPC.DALAG]["status"] == QUEST_STATUS.UNLOCKED and Game.PLAYER_QUEST_LEVEL == 0:
		## DALAG
		##dalag.guide_enabled = true
		#pass
	#elif NPC_QUEST_STATUS[NPC.PAWIKAN]["status"] == QUEST_STATUS.UNLOCKED and Game.PLAYER_QUEST_LEVEL == 1:
		## PAWIKAN
		#pass
	#elif NPC_QUEST_STATUS[NPC.KABIBE]["status"] == QUEST_STATUS.UNLOCKED and Game.PLAYER_QUEST_LEVEL == 2:
		## PAWIKAN
		#pass

func on_home():
	pass

func on_retry():
	if Game.PLAYER_QUEST_LEVEL == 0:
		#player.global_position = pos_1.global_position
		pass
	elif Game.PLAYER_QUEST_LEVEL == 1:
		#player.global_position = pos_2.global_position
		pass
	elif Game.PLAYER_QUEST_LEVEL == 2:
		#player.global_position = pos_3.global_position
		pass
	player.visible = true
	game_over.visible = false
	player.can_move = true
	player.can_attack = true
	right_buttons.visible = true
	joystick.visible = true
	if Game.player_hp == 0:
		Game.player_hp = 3

func on_zero_hp():
	if Game.player_hp == 0:
		has_active_quest = false
		Game.PLAYER_QUEST_LEVEL = 0
		Game._QUEST_STATUS["Q1"] = false
		Game._QUEST_STATUS["Q2"] = false
		Game._QUEST_STATUS["Q3"] = false
		game_over.title_content = "Game Over"
		game_over.visible = true
		player.can_move = false
		player.can_attack = false
		right_buttons.visible = false
		joystick.visible = false

func quest_accepted(_num: int):
	NPC_QUEST_STATUS[_num]["status"] = QUEST_STATUS.ACCEPTED
	has_active_quest = true
	print_debug("QUEST: ACCEPTED!")
	return true

func quest_done(num: int):
	Game.PLAYER_QUEST_LEVEL += 1
	NPC_QUEST_STATUS[num]["status"] = QUEST_STATUS.DONE
	Game.QUEST_STATUS["Q"+"%s"%num] = true
	has_active_quest = false
	done.emit(num)
	print_debug("QUEST: DONE!")
	if num < 2:
		NPC_QUEST_STATUS[num+1]["status"] = QUEST_STATUS.UNLOCKED
		#unlocked.emit(num+1)

func quest_failed(_num: int):
	has_active_quest = false
	NPC_QUEST_STATUS[_num]["status"] = QUEST_STATUS.UNLOCKED
	if Game.PLAYER_QUEST_LEVEL == 0:
		var boulder = get_tree().get_first_node_in_group("QuestItems").get_node("Boulder")
		boulder.disconnect("done", quest_done)
		boulder.disconnect("failed", quest_failed)
	elif Game.PLAYER_QUEST_LEVEL == 1:
		quest_2.visible = false
		quest_2.col1.set_disabled(true)
		quest_2.col2.set_disabled(true)
		quest_2.disconnect("done", quest_done)
		quest_2.disconnect("failed", quest_failed)
	Game.player_hp -= 1
	if Game.player_hp == 0:
		zero_hp.emit()
	failed.emit(_num)

func _on_pawikan_body_entered(body):
	if body.is_in_group("Player"):
		active_npc = NPC.PAWIKAN
		interact_btn(interact, true)
		interact.connect("pressed", on_interact_pressed)
		buttons_connect()

func _on_pawikan_body_exited(body):
	if body.is_in_group("Player"):
		interact_btn(interact, false)
		interact.disconnect("pressed", on_interact_pressed)
		buttons_disconnect()

func _on_dalag_body_entered(body):
	if body.is_in_group("Player"):
		active_npc = NPC.DALAG
		interact_btn(interact, true)
		interact.connect("pressed", on_interact_pressed)
		buttons_connect()

func _on_dalag_body_exited(body):
	if body.is_in_group("Player"):
		on_out_of_range()
		interact_btn(interact, false)
		interact.disconnect("pressed", on_interact_pressed)
		buttons_disconnect()

func _on_kabibe_body_entered(body):
	if body.is_in_group("Player"):
		active_npc = NPC.KABIBE
		interact_btn(interact, true)
		interact.connect("pressed", on_interact_pressed)
		buttons_connect()

func _on_kabibe_body_exited(body):
	if body.is_in_group("Player"):
		interact_btn(interact, false)
		interact.disconnect("pressed", on_interact_pressed)
		buttons_disconnect()
