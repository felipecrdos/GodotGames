extends Node

onready var transition = get_node("/root/Game/Interface/TrasitionScreen")

var levels : Array = Global.get_files_on_directory(Global.LEVELS_PATH, true)
var level : Node2D = null
var index : int = 0

# Signals
signal change_level(world)

func _ready():	
	change_level()
	
func change_level():
	emit_signal("change_level", self)
	
func load_level():
	remove_level()
	level = load(levels[index]).instance()
	call_deferred("add_child", level)
	
func remove_level():
	if has_node("Level"):
		get_node("Level").queue_free()
