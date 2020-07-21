extends Node

var tween
var fade

func init():
	tween = $Tween
	fade = $Fade	
	
func _ready():
	init()
	
func start_fade(start_value, end_value, time):
	tween.interpolate_property(fade, "modulate:a", start_value, end_value, time, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
