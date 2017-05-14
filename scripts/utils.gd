# utils.gd
extends Node

func _ready():
	pass

# 获得一个场景的主节点
func get_main_node():
	var root_node = get_tree().get_root()
	return root_node.get_child(root_node.get_child_count() - 1)