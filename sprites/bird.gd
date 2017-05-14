# bird.gd
extends RigidBody2D

onready var state = FlyingState.new()

func _ready():
	set_linear_velocity(Vector2(50, get_linear_velocity().y))	# 设置初始速度
	
	set_process_input(true)		# 打开输入动作监听，会监听任何事件，如鼠标的点击、移动
	set_fixed_process(true)		# 打开update，每帧调用一次
	print('_ready')
	pass

func _fixed_process(delta):
	# 限制旋转角度不超过30度
	if rad2deg(get_rot()) > 30:
		set_rot(deg2rad(30))
		set_angular_velocity(0)
		
	# 在下降时修正旋转角度,使头朝下
	if get_linear_velocity().y > 0:
		set_angular_velocity(1.5)
	pass
	
func flap():
	set_linear_velocity(Vector2(get_linear_velocity().x, -150))
	set_angular_velocity(-3)
	
func _input(event):
	if event.is_action_pressed('flap'):
		flap()
	pass


# ====== Finite State Machine =======
# class FlyingState ================================================

class FlyingState:
	# 结点初始化时调用
	func _init():
		pass
		
	# 用做动画
	func update(delta):
		pass
		
	func input(event):
		pass
	
	# 退出该状态
	func exit():
		pass

# class FlappingState ================================================

class FlappingState:
	# 结点初始化时调用
	func _init():
		pass
		
	# 用做动画
	func update(delta):
		pass
		
	func input(event):
		pass
	
	# 退出该状态
	func exit():
		pass
		
# class HitState ================================================

class HitState:
	# 结点初始化时调用
	func _init():
		pass
		
	# 用做动画
	func update(delta):
		pass
		
	func input(event):
		pass
	
	# 退出该状态
	func exit():
		pass
		
# class GroundedState ================================================

class GroundedState:
	# 结点初始化时调用
	func _init():
		pass
		
	# 用做动画
	func update(delta):
		pass
		
	func input(event):
		pass
	
	# 退出该状态
	func exit():
		pass
	