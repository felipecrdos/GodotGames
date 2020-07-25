extends Node

var player

# Paths
func get_level_node(node : String):
	var root =  get_tree().get_root()
	if root.has_node("Level"):
		var lvl = root.get_node("Level")
		if lvl.has_node(node):
			return lvl.get_node(node)
	return null
