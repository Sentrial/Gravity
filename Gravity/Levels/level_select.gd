extends Node2D

var pageIndex = 0

func _ready():
	for buttonGroup in $Buttons.get_children():
		for button in buttonGroup.get_children():
			var index = str(int(str(button.name)))
			button.disabled = !Game.levels[index][0]
	updatePage()

func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://main.tscn")
	
func _on_level_button_pressed(index: int):
	get_tree().change_scene_to_file("res://Levels/level_" + str(index) + ".tscn")

func updatePage():
	if pageIndex == 0:
		$LeftButton.disabled = true
	if pageIndex == 1:
		$RightButton.disabled = true
	
	for buttonGroup in $Buttons.get_children():
		var index = int(str(buttonGroup.name))
		if index == pageIndex:
			buttonGroup.visible = true
		else:
			buttonGroup.visible = false

func _on_left_button_pressed():
	pageIndex = pageIndex - 1
	$RightButton.disabled = false
	
	updatePage()
	

func _on_right_button_pressed():
	pageIndex = pageIndex + 1
	$LeftButton.disabled = false
	
	updatePage()
