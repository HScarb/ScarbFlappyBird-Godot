# game.gd
extends Node

const GROUP_PIPES = "pipes"
const GROUP_GROUNDS = "grounds"
const GROUP_BIRDS = "birds"

var score_best 	  = 0 setget _set_score_best		# 当score_best改变时自动调用的回调函数
var score_current = 0 setget _set_score_current		# 当score_current改变时自动调用该回调函数

signal score_best_changed
signal score_current_changed

func _ready():

	pass

func _set_score_best(new_value):
	score_best = new_value
	emit_signal("score_best_changed")
	pass

func _set_score_current(new_value):
	score_current = new_value
	emit_signal("score_current_changed")
	pass