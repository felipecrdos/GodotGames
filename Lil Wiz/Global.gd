extends Node

# enums ========================================================================
	# enum que define categoria dos objetos
enum {PLAYER, ENEMY, PICKUP, TRIGGERABLE}

# Variávels globais ============================================================
const SCENES_PATH 		= "res://Scenes/" 
const ASSETS_PATH 		= "res://Assets/"
const RESOURCES_PATH 	= "res://Resources/"
const SCRIPTS_PATH 		= "res://Scripts/"
const LEVELS_PATH 		= "res://Scenes/Levels/"

# Funções para gerenciamento de diretórios =====================================
var directory = Directory.new()
func get_files_on_directory(path : String, with_path : bool):
	if !directory.dir_exists(path):
		print("Diretório não existe!")
		
	if directory.change_dir(path) == OK:
			directory.list_dir_begin()
			
			var files : Array = []
			var file = directory.get_next()
			while file:
				if directory.file_exists(file):
					files.append(file if !with_path else path+file)
				file = directory.get_next()
					
			directory.list_dir_end()
			return files
	return null
	pass

func get_folders_on_directory(path : String, with_path : bool):
	if !directory.dir_exists(path):
		print("Diretório não existe!")
		
	if directory.change_dir(path) == OK:
			directory.list_dir_begin()
			
			var folders : Array = []
			var folder = directory.get_next()
			while folder:
				
				if directory.dir_exists(folder):
					if folder != "." && folder != "..":
						folders.append(folder if !with_path else path+folder)
				folder = directory.get_next()
				
			directory.list_dir_end()
			return folders
	return null
	pass
# ==============================================================================
