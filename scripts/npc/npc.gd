class_name NPC
extends Node

var lines_counter : int = 0
var lines : Array[String] = []
var pictures : Array[Texture2D] = []

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
