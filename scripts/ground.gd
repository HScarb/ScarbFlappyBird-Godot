# ground.gd
extends StaticBody2D

onready var bottom_right = get_node("bottom_right")
onready var camera = utils.get_main_node().get_node("camera")

#signal destroyed

func _ready():
	set_process(true)
	add_to_group(game.GROUP_GROUNDS)
	pass

func _process(delta):
	if camera == null: return
	
	# 如果该ground的右下角移出camera，释放
	if  bottom_right.get_global_pos().x <= camera.get_total_pos().x:
		queue_free()				# 释放本节点
		#emit_signal("destroyed")	# 发出结点摧毁的信号
	pass