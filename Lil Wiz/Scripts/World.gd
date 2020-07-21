extends Node

var scene
var fade
signal change_level

func init():
	scene = "res://Scenes/Levels/LevelA.tscn"
	fade = get_parent().find_node("FadeScreen")

func _ready():	
	init()
	change_level(scene)
	
func change_level(scene):
	fade.start_fade(0, 1, 1)
	yield(fade.tween, "tween_completed")
	load_level(scene)
	fade.start_fade(1, 0, 1)
	emit_signal("change_level", self)
	
func load_level(scene):
	remove_level()
	call_deferred("add_child",load(scene).instance())
	
func remove_level():
	if has_node("Level"):
		get_node("Level").call_deferred("free")
