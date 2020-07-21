extends Node
onready var tween = $Tween
onready var fade = $Fade
	
func start_fade(start_value, end_value, time):
	tween.interpolate_property(fade, "modulate:a", start_value, end_value, time, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
