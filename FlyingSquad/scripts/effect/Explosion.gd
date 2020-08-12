extends Node2D

func play(value : String):
	$ASprite.play(value)
	yield($ASprite, "animation_finished")
	queue_free()
	
