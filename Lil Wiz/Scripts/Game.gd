extends Node

var world
var sound
var interface
var fade_screen
var pause_screen
var menu_screen 

func init():
	world = get_node("World")
	sound = get_node("Sound")
	interface = get_node("Interface")
	fade_screen = find_node("FadeScreen")
	pause_screen = find_node("PauseScreen")
	menu_screen = find_node("MenuScreen")

func _ready():
	init()

func on_world_change_level(level):
	menu_screen.visible = false
	fade_screen.start_fade(0, 1, 1)
	yield(fade_screen.tween, "tween_completed")
	world.change_level(level)
	fade_screen.start_fade(1, 0, 1)
