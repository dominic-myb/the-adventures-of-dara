class_name NPC
extends Node

"""
+ NPC: init signals pressed, locked, unlocked, accept, done
+ Clam: init lines[string], pic[texture2d]
+ Quest_N: should handle the lines in that quest
+ first quest should be unlocked [edit_when]: we have game tutorial
+ other quest should be QUEST_STATE.LOCKED
+ Convert all english[btn, dialogue] to filipino
"""

signal pressed

enum QUEST_STATE {
	LOCKED,
	UNLOCKED,
	ACCEPTED,
	DONE
}

var lines_counter : int = 0
var lines : Array[String] = []
var pictures : Array[Texture2D] = []

var quest_status : int

func controls(container1: HBoxContainer, container2: HBoxContainer, value: bool):
	container1.visible = value
	container2.visible = value

func conversation(panel: PanelContainer, value: bool):
	panel.visible = value

func interact_btn(btn: TouchScreenButton, value: bool):
	btn.visible = value

func line_controller(lines_holder: Label, img_holder: TextureRect):
	img_holder.texture = pictures[lines_counter]
	lines_holder.text = lines[lines_counter]

