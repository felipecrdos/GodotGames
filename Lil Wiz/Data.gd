extends Node

# Path para salvamento
var player_data_path = "user://player_data"
var config_data_path = "user://config_data"
var level_data_path  = "user://level_data"

# Dados
var player_data = { "name":"player",
					"state":0,
					"health":0,
					"score":0,
					"powerup":0}

var config_data = {}
var level_data = {"name":"Level"}

# Salvar/Carregar dados do Player
func save_player():
	save_data(player_data_path, player_data)
func load_player():
	player_data = load_data(player_data_path)

# Salvar/Carregar dados de configurações
func save_config():
	save_data(config_data_path, config_data)
func load_config():
	config_data = load_data(config_data_path)
	
# Salvar/Carregar dados do level
func save_level():
	save_data(level_data_path, level_data)
func load_level():
	level_data = load_data(level_data_path)
	
# Salvar ou carregar dados =====================================================
func save_data(path : String, data : Dictionary):
	var file = File.new()
	var res =  file.open(path, File.WRITE)
	if res == OK:
		file.store_line(to_json(data))

func load_data(path : String):
	var text : String
	var data : Dictionary
	var file = File.new()
	var res = file.open(path, File.READ)
	if res == OK:
		text = file.get_as_text()
		data = parse_json(text)
	file.close()
	return data
