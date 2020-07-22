extends Node2D

onready var fade = $Fade
onready var tween = $Tween

func start_fade(svalue, evalue, time, delay):
	tween.interpolate_property(fade, "modulate:a", svalue, evalue, time, Tween.TRANS_LINEAR, Tween.EASE_IN, delay)
	tween.start()
