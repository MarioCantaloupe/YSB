extends Node

var Kitchen01 = "res://02_scenes/03_levels/level_cuttingCounter.tscn"
var Kitchen02 = "res://02_scenes/03_levels/level_cookingCounter.tscn"


func wait(duration):  
	await get_tree().create_timer(duration, false, false, true).timeout

func change_scene(scene):
	get_tree().change_scene_to_file(scene)
