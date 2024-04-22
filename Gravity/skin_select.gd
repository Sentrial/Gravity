extends Node2D

var currentIndex

# Called when the node enters the scene tree for the first time.
func _ready():
	currentIndex = Game.selectedSkinIndex
	if currentIndex == 0:
		$LeftButton.disabled = true
	if currentIndex == Game.SKIN_PATHS.size() - 1:
		$RightButton.disabled = true
	updateSkin()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func showCorrectTrail():
	for trail in $Trails.get_children():
		if int(str(trail.name)) == currentIndex:
			trail.emitting = true
		else:
			trail.emitting = false

func updateSkin():
	if Game.selectedSkinIndex == currentIndex:
		$Checkmark.visible = true
	else:
		$Checkmark.visible = false
	
	$Skin.texture = load(Game.SKIN_PATHS[str(currentIndex)])
	
	showCorrectTrail()
	
	$SelectButton.disabled = false
	
	if !Game.skin_unlocked[str(currentIndex)]:
		$SelectButton.disabled = true

func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://main.tscn")


func _on_right_button_pressed():
	currentIndex += 1
	
	$LeftButton.disabled = false
	
	if currentIndex >= Game.SKIN_PATHS.size() - 1:
		$RightButton.disabled = true
	
	updateSkin()

func _on_left_button_pressed():
	currentIndex -= 1
	
	$RightButton.disabled = false
	
	if currentIndex <= 0:
		$LeftButton.disabled = true
		
	updateSkin()


func _on_select_button_pressed():
	Game.selectedSkinIndex = currentIndex
	$Checkmark.visible = true
	Utils.saveGame()
