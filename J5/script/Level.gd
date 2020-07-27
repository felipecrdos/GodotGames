extends Node2D

export (PackedScene) var player_packedscene
export (PackedScene) var orc_packedscene
export (PackedScene) var alligator_packedscene
export (PackedScene) var bear_packedscene
export (PackedScene) var scotty_packedscene

export (PackedScene) var portal_packedscene
export (PackedScene) var coin_packedscene
export (PackedScene) var chest_packedscene

var actor_container
var pickup_container
var trigger_container

var map_actor16
var map_actor32
var map_actor64
var maps_to_actors

func _ready():	
	actor_container 	= $ActorsContainer
	pickup_container 	= $PickupContainer
	trigger_container	= $TriggerContainer
	
	map_actor16 	= $ActorMap16
	map_actor32 	= $ActorMap32
	map_actor64 	= $ActorMap64
	
	maps_to_actors = {	map_actor16:[	{"type":0, "name":"Player","index":-1, "packed":player_packedscene,"parent":actor_container, "offset":Vector2.ZERO},
										{"type":0, "name":"Enemy","index":-1, "packed":0,"parent":actor_container, "offset":Vector2.ZERO}],
						map_actor32:[	{"type":0, "name":"Player","index":-1, "packed":player_packedscene,"parent":actor_container, "offset":Vector2.ZERO},
										{"type":0, "name":"Alligator","index":-1, "packed":alligator_packedscene,"parent":actor_container, "offset":Vector2.ZERO},
										{"type":0, "name":"Scotty","index":-1, "packed":scotty_packedscene,"parent":actor_container, "offset":Vector2.ZERO}],
						map_actor64:[	{"type":0, "name":"Orc","index":-1, "packed":orc_packedscene,"parent":actor_container, "offset":Vector2.ZERO},
										{"type":0, "name":"Bear","index":-1, "packed":bear_packedscene,"parent":actor_container, "offset":Vector2.ZERO}]}
	find_objects_indexes()
	find_corresponding_cells()
	
func find_objects_indexes():
	for map in maps_to_actors:
		if map.tile_set:
			for obj in maps_to_actors[map]:
				var index = map.tile_set.find_tile_by_name(obj["name"])
				if index != -1:
					obj["index"] = index
					print("map: ", map.name,"\tname: ", obj["name"],"\tindex: ", obj["index"])

func find_corresponding_cells():
	for map in maps_to_actors:
		if map.tile_set:
			for coord in map.get_used_cells():
				var index = map.get_cellv(coord)
				for obj in maps_to_actors[map]:
					if index == obj["index"]:
						var g_position = map.map_to_world(coord)
						remove_cell(map, coord)
						instantiate_objects(g_position, obj["packed"], obj["parent"], obj["offset"])

func instantiate_objects(g_position, packedscene, parent, offset):
	var new_object = packedscene.instance()
	parent.add_child(new_object)
	new_object.global_position = g_position
	new_object.global_position += offset
	if new_object is Enemy:
		new_object.sposition = new_object.global_position

func remove_cell(map, coord):
	map.set_cellv(coord, -1)


func on_portal_player_entering(scene):
	print("change to: ", scene)
