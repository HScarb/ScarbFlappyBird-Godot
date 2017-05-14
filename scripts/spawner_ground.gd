# spawner_ground.gd
# 连续场景生成器
extends Node2D

# 获得ground scene的引用
const scn_ground = preload("res://scenes/ground.tscn")
const GROUND_WIDTH = 168		# ground图片的长
const AMOUNT_TO_FILL_VIEW = 2	# 让ground充满窗口需要的ground数量

func _ready():
	for i in range(AMOUNT_TO_FILL_VIEW):
		#spawn_ground()
		#go_next_pos()
		spawn_and_move()
	pass
	
func spawn_and_move():
	spawn_ground()
	go_next_pos()

func spawn_ground():
	# 实例化一个ground，设置位置并且添加到本结点，注册信号监听
	var new_ground = scn_ground.instance()
	new_ground.set_pos(get_pos())
	# 注册信号监听事件，当收到ground发来的destroyed信号，执行这两个函数
	#new_ground.connect("destroyed", self, "spawn_ground")
	#new_ground.connect("destroyed", self, "go_next_pos")
	# 注册built-in信号exit_tree，在本结点移除时自动调用
	new_ground.connect("exit_tree", self, "spawn_and_move")
	# 新建一个Node作为container(Node没有坐标属性)
	get_node("container").add_child(new_ground)
	pass
	
func go_next_pos():
	set_pos(get_pos() + Vector2(GROUND_WIDTH, 0))
	pass