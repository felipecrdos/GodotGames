extends Node2D
class_name Effect

var fliph = false
func play(anim):
	$ASprite.flip_h = fliph
	$ASprite.play(anim)
	yield($ASprite, "animation_finished")
	queue_free()
