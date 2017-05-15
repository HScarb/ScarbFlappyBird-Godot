# bird.gd
extends RigidBody2D

onready var state = FlyingState.new(self) # FlappingState.new(self)

var speed = 50

const STATE_FLYING	 = 0
const STATE_FLAPPING = 1
const STATE_HIT		 = 2
const STATE_GROUNDED = 3

signal state_changed

func _ready():
	set_process_input(true)		# 打开输入动作监听，会监听任何事件，如鼠标的点击、移动
	set_fixed_process(true)		# 打开update，每帧调用一次
	
	add_to_group(game.GROUP_BIRDS)
	connect("body_enter", self, "_on_body_enter")	# 监听鸟碰撞
	print('_ready')
	pass

func _fixed_process(delta):
	state.update(delta)
	pass
	
func _input(event):
	state.input(event)
	pass

# 碰撞时调用，other为与鸟碰撞的物体
func _on_body_enter(other_body):
	# 如果这个状态有碰撞函数，则调用
	if state.has_method("on_body_enter"):
		state.on_body_enter(other_body)
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
		
	emit_signal("state_changed", self)		# 状态变换时发送信号，并且以bird为参数
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
	var prev_gravity_scale
	
	# 结点初始化时调用
	func _init(bird):
		self.bird = bird
		bird.get_node("anim").play("flying")
		bird.set_linear_velocity(Vector2(bird.speed, bird.get_linear_velocity().y))	# 设置初始速度
		
		prev_gravity_scale = bird.get_gravity_scale()
		bird.set_gravity_scale(0)
		pass
		
	# 用做动画
	func update(delta):
		pass
		
	func input(event):
		pass
	
	# 退出该状态
	func exit():
		bird.set_gravity_scale(prev_gravity_scale)
		# 退出时修正鸟的位置，防止之前的动画使鸟位置偏移
		bird.get_node("anim").stop()
		bird.get_node("anim_sprite").set_pos(Vector2(0, 0))
		pass

# class FlappingState ================================================

class FlappingState:
	var bird
	
	# 结点初始化时调用
	func _init(bird):
		self.bird = bird
		
		bird.set_linear_velocity(Vector2(bird.speed, bird.get_linear_velocity().y))	# 设置初始速度
		flap()		# 初始向上飞一次
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
		
	# 处理碰撞
	func on_body_enter(other_body):
		if other_body.is_in_group(game.GROUP_PIPES):
			bird.set_state(bird.STATE_HIT)
		if other_body.is_in_group(game.GROUP_GROUNDS):
			bird.set_state(bird.STATE_GROUNDED)
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
		# 当撞到管子，设置速度为0，角速度为2(向地下 顺时针转)
		bird.set_linear_velocity(Vector2(0, 0))
		bird.set_angular_velocity(2)
		
		var other_body = bird.get_colliding_bodies()[0]		# 获取鸟撞的柱子
		bird.add_collision_exception_with(other_body)		# 让鸟和该柱子无法碰撞
		pass
		
	# 用做动画
	func update(delta):
		pass
		
	func input(event):
		pass
	
	func on_body_enter(other_body):
		if other_body.is_in_group(game.GROUP_GROUNDS):
			bird.set_state(bird.STATE_GROUNDED)
	
	# 退出该状态
	func exit():
		pass
		
# class GroundedState ================================================

class GroundedState:
	var bird
	
	# 结点初始化时调用
	func _init(bird):
		self.bird = bird
		# 设置速度和角速度都为0
		bird.set_linear_velocity(Vector2(0, 0))
		bird.set_angular_velocity(0)
		pass
		
	# 用做动画
	func update(delta):
		pass
		
	func input(event):
		pass
	
	# 退出该状态
	func exit():
		pass
	