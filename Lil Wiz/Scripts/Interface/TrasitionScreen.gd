extends Node

func _ready():
	pass
		
func start_fade(start_value, end_value, time):
	$Tween.interpolate_property($Fade, "modulate:a", start_value, end_value, time, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

func on_world_change_level(world):
	start_fade(0, 1, 1)
	yield($Tween, "tween_completed")
	world.load_level()
	start_fade(1, 0, 1)
