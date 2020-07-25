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

# Desabilitar as áreas dos filhos de um node.
func disable_all_child_area(parent : Node2D):
	for child in parent.get_children():
		if child is Area2D:
			child.set_deferred("monitoring", false)

# Abilitar as áreas dos filhos de um node.
func enable_all_child_area(parent : Node2D):
	for child in parent.get_children():
		if child is Area2D:
			child.set_deferred("monitoring", true)

func check_area_collision(area: Area2D, body: Node):
	var is_colliding = false
	if area && body:
		if area.overlaps_body(body):
			is_colliding = true
	return is_colliding

func check_area_collisions(area: Area2D):
	var is_colliding = false
	for body in area.get_overlapping_bodies():
		print("hiting: ", body.name)
		is_colliding = true
	return is_colliding

# Retorna a direção horizontal
func target_hdirect(target, this):
	var posx = this.global_position.x
	var tposx = target.global_position.x
	return  sign(tposx - posx)
