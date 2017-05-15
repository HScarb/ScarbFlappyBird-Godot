# pipe.gd
extends StaticBody2D

onready var right = get_node("right")
onready var camera = utils.get_main_node().get_node("camera")

func _ready():
	set_process(true)
	add_to_group(game.GROUP_PIPES)		# 加入pipes组，用做碰撞检测时的碰撞物体识别
	pass

func _process(delta):
	if camera == null: return
	
	if right.get_global_pos().x <= camera.get_total_pos().x:
		queue_free()
	pass