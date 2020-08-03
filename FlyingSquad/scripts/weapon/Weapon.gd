extends Node2D
class_name Weapon

var firerate : float 
var sfirerate : float
var barrels : Array

func _ready():
	firerate = 10
	sfirerate = firerate
	
	for child in get_children():
		if child is Barrel:
			barrels.append(child)

func shoot():
	firerate -= 1
	if firerate <= 0:
		for barrel in barrels:
			barrel.shoot()
			firerate = sfirerate
