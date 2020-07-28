extends Node2D
 
onready var bus_layout = preload("res://resouce/bus.tres")
func _ready():
	#Global.sound = self
	AudioServer.set_bus_layout(bus_layout)
	set_bus_volume("sfx", -10)
	
	
# Funções para efeitos sonoros
func play_sfx(audio:String):
	if $Sfx.has_node(audio):
		var a = $Sfx.get_node(audio)
		#if !a.playing:
		a.play()
	
# Funções para musicas
func play_music(audio:String):
	if $Music.has_node(audio):
		$Music.get_node(audio).play()

func stop_music(audio:String):
	if $Music.has_node(audio):
		$Music.get_node(audio).stop()
	
func pause_music(audio:String):
	if $Music.has_node(audio):
		var m = $Music.get_node(audio)
		if !m.stream_paused:
			m.stream_paused = true

func resume_music(audio:String):
	if $Music.has_node(audio):
		var m = $Music.get_node(audio)
		if m.stream_paused:
			m.stream_paused = false

# Definir o volume dos audios no "Bus" especificado
func set_bus_volume(bus:String, volume:float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus),volume)
