extends Node2D

# Acessar os containers do level através das 
# variáveis abaixos.
onready var map_container 			= $MapsContainer
onready var player_container 		= $PlayerContainer
onready var enemies_container 		= $EnemiesContainer
onready var pickups_container 		= $PickupsContainer
onready var triggerable_container 	= $TriggerableContainer

# Actors
onready var actors_map16 = $MapsContainer/Actors16
onready var actors_map32 = $MapsContainer/Actors32
onready var actors_map64 = $MapsContainer/Actors64

# Ground
onready var ground_map = $MapsContainer/Ground

# Cenas dos objetos que serão instanciados na cena
export (PackedScene) var player
export (PackedScene) var enemy
#export (PackedScene) var coin
#export (PackedScene) var key
#export (PackedScene) var chest

# Array que mapeira os objetos dentro de cada tilemap.
onready var objects_maps = {actors_map16:[{"type":Global.PLAYER, "name":"Player","index":-1,"packed":player, "offset":Vector2.ZERO}, 
										  {"type":Global.ENEMY, "name":"Enemy","index":-1,"packed":enemy, "offset":Vector2.ZERO}],
							actors_map32:[{"type":Global.PLAYER,"name":"Player","index":-1,"packed":player, "offset":Vector2.ZERO}, 
										  {"type":Global.ENEMY, "name":"Enemy","index":-1,"packed":enemy, "offset":Vector2.ZERO}],
							actors_map64:[{"type":Global.PLAYER,"name":"Player","index":-1,"packed":player, "offset":Vector2.ZERO}, 
										  {"type":Global.ENEMY, "name":"Enemy","index":-1,"packed":enemy, "offset":Vector2.ZERO}]}	
func _ready():
	find_index()
	setup_level()

# Achar os índeces dos objetos contidos
# no array "objects_maps".
func find_index():
	for map in objects_maps:
		if map.tile_set:
			for obj in objects_maps[map]:
				var index = map.tile_set.find_tile_by_name(obj["name"])
				if index != -1:
					obj["index"] = index
	
# Os objetos serão instanciados de acordo com os 
# índices encontrados nos TileMaps.
func setup_level():
	for map in objects_maps:
		if map.tile_set:
			for coord in map.get_used_cells():
				var index = map.get_cellv(coord)
				if index != -1:
					for obj in objects_maps[map]:
						if index == obj["index"]:
							var pos = map.map_to_world(coord)
							remove_cell(map, coord)
							create_object(pos, obj["packed"], obj["type"], obj["offset"])
							pass
						
# Criar (Instanciar) os objetos de acordo com os índices
# encontrado nos TileMaps e adicionalos a um container
# correspondente de acordo com o tipo do objeto.
func create_object(pos, packed, type, offset):		
	var object = packed.instance()
	object.global_position = pos
	match type:
		Global.PLAYER:
			player_container.add_child(object)
		Global.ENEMY:
			enemies_container.add_child(object)
		Global.PICKUP:
			pickups_container.add_child(object)
		Global.TRIGGERABLE:
			player_container.add_child(object)

# Remover a célula que correponde ao objeto instanciado.
func remove_cell(map, coord):
	map.set_cellv(coord, -1)
	pass

# Sinal recebido quando o player toca o portal
# para mudar de cena
func on_entered_portal(body, scene):
	var parent = get_parent()
	if parent && parent.has_method("change_level"):
		parent.change_level(scene)
