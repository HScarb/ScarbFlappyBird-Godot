# cramea.gd
extends Camera2D

#onready var bird = get_node("../bird")		# 当ready，获得实例化的bird对象
# 获得结点树.获得根节点.获得第一个子节点(Node).获得鸟结点
#onready var bird = get_tree().get_root().get_child(0).get_node("bird")
# 使用utils中的方法获得bird
onready var bird = utils.get_main_node().get_node("bird")

func _ready():
	set_fixed_process(true)
	pass

func _fixed_process(delta):
	# 让camera跟随bird的x轴移动
	set_pos(Vector2(bird.get_pos().x, get_pos().y))
	pass
	
func get_total_pos():
	return get_pos() + get_offset()
	pass