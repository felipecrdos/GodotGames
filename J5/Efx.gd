extends Node

var effects = 	[	{	"name":"SmokeExplosion",
						"animation":"explosion", 
						"packed":preload("res://scenes/SmokeExplosion.tscn")
					},
					{	"name":"FireExplosion",
						"animation":"explosion",
						"packed":preload("res://scenes/FireExplosion.tscn")
					}
				]

func create_effect(effect:String,position:Vector2,scale=Vector2(1,1)):
	for obj in effects:
		if obj["name"] == effect:
			var new_effect = obj["packed"].instance()
			new_effect.set_deferred("scale",scale)
			new_effect.set_deferred("global_position",position)
			new_effect.call_deferred("play", obj["animation"])
			Util.fnode("EffectContainer").call_deferred("add_child", new_effect)
