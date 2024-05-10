extends CharacterBody2D

var player : CharacterBody2D
var bubble_enabled: bool = false
var guide_enabled: bool = false

@onready var anim = $AnimatedSprite2D
@onready var collider = $CollisionShape2D
@onready var speech_bubble = $SpeechBubble
@onready var arrow_guide = $ArrowGuide
@onready var quest_manager = $"../../QuestManager"

func _ready():
	quest_manager.unlocked.connect(on_quest_unlocked)
	quest_manager.accepted.connect(on_quest_accepted)
	toggle_bubble(bubble_enabled)
	player = get_tree().get_first_node_in_group("Player")
	
func _process(_delta):
	toggle_bubble(bubble_enabled)
	toggle_guide(guide_enabled)
	if position.x < player.global_position.x:
		anim.flip_h = false
	elif position.x > player.global_position.x:
		anim.flip_h = true
	anim.play("idle")

func on_quest_unlocked(_num: int):
	if quest_manager.NPC_QUEST_STATUS[quest_manager.NPC.PAWIKAN]["status"] == quest_manager.QUEST_STATUS.UNLOCKED:
		guide_enabled = true

func on_quest_accepted(_num: int):
	if quest_manager.NPC_QUEST_STATUS[quest_manager.NPC.PAWIKAN]["status"] == quest_manager.QUEST_STATUS.ACCEPTED:
		guide_enabled = false
		bubble_enabled = true

func on_quest_done(_num: int):
	if quest_manager.NPC_QUEST_STATUS[quest_manager.NPC.PAWIKAN]["status"] == quest_manager.QUEST_STATUS.DONE:
		bubble_enabled = false

func toggle_bubble(_show: bool):
	speech_bubble.visible = _show

func toggle_guide(_show: bool):
	arrow_guide.visible = _show
	if _show:
		arrow_guide.play("default")
