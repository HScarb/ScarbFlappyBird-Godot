# bird.gd
extends RigidBody2D

onready var state = FlappingState.new(self)

const STATE_FLYING	 = 0
const STATE_FLAPPING = 1
const STATE_HIT		 = 2
const STATE_GROUNDED = 3

func _ready():
	set_process_input(true)		# 打开输入动作监听，会监听任何事件，如鼠标的点击、移动
	set_fixed_process(true)		# 打开update，每帧调用一次
	print('_ready')
	pass

func _fixed_process(delta):
	state.update(delta)
	pass
	
func _input(event):
	state.input(event)
	pass

func set_state(new_state):
	state.exit()
	
	if new_state == STATE_FLYING:
		state = FlyingState.new(self)
	elif new_state == STATE_FLAPPING:
		state = FlappingState.new(self)
	elif new_state == STATE_HIT:
		state = HitState.new(self)
	elif new_state == STATE_GROUNDED:
		state = GroundedState.new(self)
	pass

func get_state():
	if state extends FlyingState:
		return STATE_FLYING
	elif state extends FlappingState:
		return STATE_FLAPPING
	elif state extends HitState:
		return STATE_HIT
	elif state extends GroundedState:
		return STATE_GROUNDED
	pass

# ====== Finite State Machine =======
# class FlyingState ================================================

class FlyingState:
	var bird
	
	# 结点初始化时调用
	func _init(bird):
		self.bird = bird
		
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
	var bird
	
	# 结点初始化时调用
	func _init(bird):
		self.bird = bird
		
		bird.set_linear_velocity(Vector2(50, bird.get_linear_velocity().y))	# 设置初始速度
		pass
		
	# 用做动画
	func update(delta):
		# 限制旋转角度不超过30度
		if rad2deg(bird.get_rot()) > 30:
			bird.set_rot(deg2rad(30))
			bird.set_angular_velocity(0)
			
		# 在下降时修正旋转角度,使头朝下
		if bird.get_linear_velocity().y > 0:
			bird.set_angular_velocity(1.5)
		pass
	func flap():
		bird.set_linear_velocity(Vector2(bird.get_linear_velocity().x, -150))
		bird.set_angular_velocity(-3)
		bird.get_node("anim").play("flap")		# 播放flap动画
		pass
		
	func input(event):
		if event.is_action_pressed('flap'):
			flap()
		pass
	
	# 退出该状态
	func exit():
		pass
		
# class HitState ================================================

class HitState:
	var bird
	
	# 结点初始化时调用
	func _init(bird):
		self.bird = bird
		
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
	var bird
	
	# 结点初始化时调用
	func _init(bird):
		self.bird = bird
		
	# 用做动画
	func update(delta):
		pass
		
	func input(event):
		pass
	
	# 退出该状态
	func exit():
		pass
	