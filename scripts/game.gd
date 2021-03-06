# game.gd
extends Node

const GROUP_PIPES   = "pipes"
const GROUP_GROUNDS = "grounds"
const GROUP_BIRDS   = "birds"

const MEDAL_BRONZE   = 10
const MEDAL_SILVER   = 20
const MEDAL_GOLD     = 30
const MEDAL_PLATINUM = 40

var score_best 	  = 0 setget _set_score_best		# 当score_best改变时自动调用的回调函数
var score_current = 0 setget _set_score_current		# 当score_current改变时自动调用该回调函数

signal score_best_changed
signal score_current_changed

func _ready():
	stage_manager.connect("stage_changed", self, "_on_stage_changed")
	pass
	
func _on_stage_changed():
	score_current = 0
	pass

func _set_score_best(new_value):
	if new_value > score_best:
		score_best = new_value
		emit_signal("score_best_changed")
	pass

func _set_score_current(new_value):
	score_current = new_value
	emit_signal("score_current_changed")
	pass