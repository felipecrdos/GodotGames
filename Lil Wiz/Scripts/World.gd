extends Node

var scene = "res://Scenes/Levels/LevelA.tscn"
onready var fade = get_node("/root/Game/Interface/FadeScreen")

signal change_level(world)
func _ready():	
	change_level(scene)
	
func change_level(scene):
	emit_signal("change_level", self)
	fade.start_fade(0, 1, 1)
	yield(fade.tween, "tween_completed")
	load_level(scene)
	fade.start_fade(1, 0, 1)
	
	
func load_level(scene):
	remove_level()
	var level = load(scene).instance()
	call_deferred("add_child", level)
	
func remove_level():
	if has_node("Level"):
		get_node("Level").call_deferred("free")
		pass
