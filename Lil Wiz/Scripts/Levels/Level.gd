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
#export (PackedScene) var coin
#export (PackedScene) var key
#export (PackedScene) var chest

# Index do tile que representa os objetos
# a serem instanciados
var player_index : int
var coin_index : int

func _ready():
	find_index()
	#setup_level()

func find_index():
	for map in map_container.get_children():
		if map.tile_set:
			player_index = map.tile_set.find_tile_by_name("Player")
			coin_index = map.tile_set.find_tile_by_name("Coin")
	
func setup_level():
	for cell in actors_map32.get_used_cells():
		match actors_map32.get_cellv(cell):
			player_index:
				map_to_world_instance(player, cell, player_container, Vector2.ZERO)
#			coin_index:
#				map_to_world_instance(coin, cell, player_container, Vector2.ZERO)

func map_to_world_instance(packed, coord, parent, offset):
	var instance = packed.instance()
	var pos = actors_map32.map_to_world(coord)
	remove_cell(actors_map32, coord)
	instance.global_position = pos
	parent.add_child(instance)

func remove_cell(map, coord):
	map.set_cellv(coord, -1)
	pass
