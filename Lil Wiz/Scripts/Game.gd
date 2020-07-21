extends Node

func init():
	pass

func _ready():
	init()

# Achar e definir a visibilidade para
# cada node passado no dicionário
func set_visible(nodes : Dictionary):
	for key in nodes:
		var node = find(key)
		if node is CanvasItem:
			node.visible = nodes[key]

# Achar nós de maneira recursiva.
func find(node : String):
	return find_node(node, true, false)

# Retorna o nome do arquivo sem a extensão.
func getfile(path : String):
	return path.get_basename().get_file()

func fade_in(start_value, end_value, time):
	find("FadeScreen").start_fade(0, 1, 2)
	yield(find("FadeScreen").tween, "tween_completed")

func fade_out(start_value, end_value, time):
	find("FadeScreen").start_fade(1, 0, 2)

func set_paused(value : bool):
	get_tree().paused = value
	
# Sinal recebido pelo nó World quando
# quando um sinal de troca de level é enviado.
func on_world_change_level(level):
	Data.level_data["name"] = getfile(level)
	Data.save_player()
	Data.save_level()

	set_visible({"MenuScreen":false})
	set_paused(false)
	
	fade_in(0, 1, 1)
	find("World").change_level(level)
	fade_out(1, 0, 1)
	
	Data.load_player()

func on_world_goto_menu(scene):
	set_visible({"PauseScreen":false})
	fade_in(0, 1, 1)
	find("World").remove_level()
	fade_out(1, 0, 1)
	set_visible({"MenuScreen":true})

func on_world_resume_level(file):
	set_paused(false)
	set_visible({"PauseScreen":false})
	
