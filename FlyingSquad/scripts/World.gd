extends Node

var lviewport
var mviewport
var rviewport

var game_data
var level

func _ready():
	lviewport = $HContainer/LeftScreen/Viewport
	mviewport = $HContainer/MidleScreen/Viewport
	rviewport = $HContainer/RightScreen/Viewport
	
	game_data = Global.game_data
	change_level()
	
func load_level():
	var path = game_data["Level"]["path"]
	level = load(path).instance()
	
func change_level():
	$Transition.start(0, 1, 1, 0)
	yield($Transition/Tween, "tween_all_completed")
	
	remove_level()
	load_level()
	mviewport.add_child(level)
	
	$Transition.start(1, 0, 1, 0)
	
func remove_level():
	for child in mviewport.get_children():
		if child is Level:
			child.free()

