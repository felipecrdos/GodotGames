extends Node

# Escolher um dos valores do array passado
func choose(array : Array):
	if array:
		randomize()
		var size = array.size()
		var index = randi()%size
		return array[index]
	return null	

# Abilitar monitoramente da área no frame específico.
func enable_monitoring_area_in_frame(area:Area2D ,animation:AnimatedSprite, frame:int):
	if frame >= 0:
		if animation.frame == frame && !area.monitoring:
			area.set_deferred("monitoring", true)
		yield(animation, "animation_finished")
		area.set_deferred("monitoring", false)
