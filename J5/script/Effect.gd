extends Node2D
class_name Effect

func play(anim):
	$ASprite.play(anim)
	yield($ASprite, "animation_finished")
	queue_free()
