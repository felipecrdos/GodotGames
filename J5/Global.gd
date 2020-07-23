extends Node

var player

# Escolher um dos valores do array passado
func choose(array : Array):
	if array:
		randomize()
		var size = array.size()
		var index = randi()%size
		return array[index]
	return null	
