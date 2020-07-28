extends Node

var player

func choose(values:Array):
	if !values.empty():
		randomize()
		return values[randi()%values.size()]
	return -1

func findnode(node:String):
	var rt = get_tree().get_root()
	for n in rt.get_children():
		if n.has_node(node):
			return n.find_node(node, true, false)
	return null
