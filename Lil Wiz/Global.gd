extends Node

# enums ========================================================================
	# enum que define categoria dos objetos
enum {PLAYER, ENEMY, PICKUP, TRIGGERABLE}

# Variávels globais ============================================================
		
# Funções para gerenciamento de diretórios =====================================
var directory = Directory.new()
func get_files_on_directory(path : String, with_path : bool):
	if !directory.dir_exists(path):
		return
		
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

# Utils ========================================================================
func find(nam):
	var game = get_node("/root/Game")
	return game.find_node(nam, true, false)

func set_paused(value : bool):
	get_tree().paused = value
	
# Achar e definir a visibilidade para
# cada node passado no dicionário
func setvisible(nodes : Dictionary):
	for key in nodes:
		var child = find(key)
		if child is CanvasItem:
			child.visible = nodes[key]

# Achar e definir o processamento para
# cada node passado no dicionário
func setprocess(nodes : Dictionary):
	for key in nodes:
		var child = find(key)
		child.set_process(nodes[key])

# Achar e definir o processamento de input 
# para cada node passado no dicionário
func setinput(nodes : Dictionary):
	for key in nodes:
		var child = find(key)
		child.set_process_input(nodes[key])

# Achar e definir o processamento físico 
# para cada node passado no dicionário
func setphysics(nodes : Dictionary):
	for key in nodes:
		var child = find(key)
		child.set_physics_process(nodes[key])

# 
func setall(nodes : Dictionary):
	setvisible(nodes)
	setprocess(nodes)
	setinput(nodes)
	setphysics(nodes)
