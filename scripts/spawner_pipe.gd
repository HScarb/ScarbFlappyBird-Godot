# spawner_pipe.gd
extends Node2D

const scn_pipe = preload("res://scenes/pipe.tscn")
const GROUND_HEIGHT = 56	# 地面高度
const PIPE_WIDTH 	= 26	# 管道宽度
const OFFSET_X 		= 65	# 左右两管道之间间隔
const OFFSET_Y 		= 55	# 管道距离上下方偏移
const AMOUNT_TO_FILL_VIEW = 3	# 铺满窗口需要的管道数量

func _ready():
	var bird = utils.get_main_node().get_node("bird")
	if bird:
		bird.connect("state_changed", self, "_on_bird_state_changed", [], CONNECT_ONESHOT)	# 监听鸟状态变化的信号,只触发一次
	pass

func _on_bird_state_changed(bird):
	if bird.get_state() == bird.STATE_FLAPPING:
		start()
	pass

func start():
	go_init_pos()
	for i in range(AMOUNT_TO_FILL_VIEW):
		spawn_and_move()
	pass

# 初始化第一个管道位置
func go_init_pos():
	randomize()
	
	var init_pos = Vector2()
	init_pos.x = get_viewport_rect().size.width + PIPE_WIDTH / 2
	init_pos.y = rand_range(0 + OFFSET_Y, get_viewport_rect().size.height - GROUND_HEIGHT - OFFSET_Y)
	
	var camera = utils.get_main_node().get_node("camera")
	if camera:
		init_pos.x += camera.get_total_pos().x
	
	set_pos(init_pos)
	pass

# 生成管道并且移动到下一个位置
func spawn_and_move():
	spawn_pipe()
	go_next_pos()
	pass

# 生成管道(实例化并且注册监听)
func spawn_pipe():
	var new_pipe = scn_pipe.instance()
	new_pipe.set_pos(get_pos())
	# 注册监听事件
	new_pipe.connect("exit_tree", self, "spawn_and_move")
	get_node("container").add_child(new_pipe)
	pass

# 初始化下一个管道位置
func go_next_pos():
	randomize()
	
	var next_pos = get_pos()
	next_pos.x += PIPE_WIDTH / 2 + OFFSET_X + PIPE_WIDTH / 2
	next_pos.y = rand_range(0 + OFFSET_Y, get_viewport_rect().size.height - GROUND_HEIGHT - OFFSET_Y)
	set_pos(next_pos)
	pass