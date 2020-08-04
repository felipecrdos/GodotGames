extends Node

var player

# Save/Load game data
var game_path = "user://game_data.json"
var game_data = {	
					"Player":{	"name":"Player", 
								"health":4,
								"maxhealth":4, 
								"powerup":0,
								"maxpowerup":4, 
								"crystal":0,
								"weapon":["res://assets/sprite/weapon/mg_side.png",
										  "res://assets/sprite/weapon/matter_side.png",
										  "res://assets/sprite/weapon/laser_side.png",
										  "res://assets/sprite/weapon/rocket_side.png"]
							},
					"Level":{	"path":"res://scenes/levels/Level.tscn",
								"name":"Level", 
								"difficulty":"Easy", 
								"Boss":"RedRibbon"
							}
				}

func save_data():
	var file = File.new()
	file.open(game_path, File.WRITE)
	file.store_line(to_json(game_data))
	file.close()
	
func load_data():
	var file = File.new()
	file.open(game_path, File.READ)
	game_data = parse_json(file.get_as_text())
	file.close()

#===
func choose(values:Array):
	if !values.empty():
		randomize()
		return values[randi()%values.size()]
	return -1

func findnode(node:String):
	var root = get_tree().get_root()
	var find = null
	for n in root.get_children():
		find = n.find_node(node, true, false) 
		if find:
			break
	return find
