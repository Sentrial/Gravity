extends Node2D


@onready var startPos = $Player/Player.position

func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://main.tscn")
	


func _on_reset_button_pressed():
	$Player/Player.restartLevel()


func _on_next_level_button_pressed():
	var currLevelIndex = int(str(get_tree().current_scene.name))
	if (currLevelIndex < Game.MAX_LEVEL):
		get_tree().change_scene_to_file("res://Levels/level_" + str(currLevelIndex + 1) + ".tscn")
	else:
		get_tree().change_scene_to_file("res://main.tscn")


func _on_flip_gravity_button_pressed():
	$Player/Player.invertGravity()
