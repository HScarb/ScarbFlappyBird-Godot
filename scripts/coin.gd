# coin.gd (built-in)
# 用于检测鸟穿过管子中间，加分
extends Area2D

func _ready():
	connect("body_enter", self, "_on_body_enter")
	pass

func _on_body_enter(other_body):
	if other_body.is_in_group(game.GROUP_BIRDS):
		# increase score
		game.score_current += 1		# 这里调用了_set_score_current
	pass