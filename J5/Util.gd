extends Node
	
# Achar qualquer nó pelo nome. Não importa o nível de recursividade
func fnode(node:String):
	var fnode = null
	for n in get_tree().get_root().get_children():
		fnode = n.find_node(node, true, false)
	return fnode

# Retorna um dos valores contidos no array passado
func choose(array : Array):
	if array:
		randomize()
		var size = array.size()
		var index = randi()%size
		return array[index]
	return null	

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

# Verificar se uma Area2D se sobrepôs a um body específico
func check_area_collision(area: Area2D, body: Node):
	var is_colliding = false
	if area && body:
		if area.overlaps_body(body):
			is_colliding = true
	return is_colliding
	
# Verificar se uma Area2D se sobrepôs a qualquer body
func check_area_collisions(area: Area2D):
	var is_colliding = false
	for body in area.get_overlapping_bodies():
		print("hiting: ", body.name)
		is_colliding = true
	return is_colliding

# Retorna a direção horizontal em relação ao alvo
func hdirect(from, to):
	var frompos = from.global_position.x
	var topos = to.global_position.x
	return sign(topos - frompos)
