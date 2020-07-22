extends Node

func _ready():
	pass

# Retorna o nome do arquivo sem a extensão.
func getfile(path : String):
	return path.get_basename().get_file()

func fade_in(start_value, end_value, time):
	Global.find("FadeScreen").start_fade(0, 1, 2)
	yield(Global.find("FadeScreen").tween, "tween_completed")

func fade_out(start_value, end_value, time):
	Global.find("FadeScreen").start_fade(1, 0, 2)
	
# Sinal recebido pelo nó World quando
# quando um sinal de troca de level é enviado.
func on_world_change_level(level):
	Data.level_data["name"] = getfile(level)
	Data.save_player()
	Data.save_level()

	Global.setall({"MenuScreen":false, "MenuButtons":false})
	Global.set_paused(false)
	
	fade_in(0, 1, 1)
	Global.find("World").change_level(level)
	fade_out(1, 0, 1)
	
	Data.load_player()

func on_world_goto_menu(scene):
	Global.setall({"PauseScreen":false, "PauseButtons":false})
	fade_in(0, 1, 1)
	Global.find("World").remove_level()
	fade_out(1, 0, 1)
	Global.setall({"MenuScreen":true, "MenuButtons":true})

func on_world_resume_level(file):
	Global.set_paused(false)
	Global.setall({"PauseScreen":false, "PauseButtons":false})
	
func on_quit_button_pressed(file):
	get_tree().quit()
	
