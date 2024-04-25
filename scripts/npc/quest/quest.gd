class_name Quest
extends Node

enum QUEST_STATE {
	PENDING,
	ACCEPTED,
	DONE
}

var quest_status : int

func quest_pending(_quest_status: int):
	_quest_status = QUEST_STATE.PENDING
	print("Quest1: Pending")
	pass

func quest_accepted(_quest_status: int):
	_quest_status = QUEST_STATE.ACCEPTED
	print("Quest1: Accepted")
	
func quest_done(_quest_status: int):
	_quest_status = QUEST_STATE.DONE
	print("Quest1: Done")
