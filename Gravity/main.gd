extends Node2D

var GRAVITY = .667
var BH_MASS = 250
var LETTER_MASS = 100

func _ready():
	Utils.loadGame()


@onready var blackHoles = get_node("BlackHoles")

func _on_quit_button_pressed():
	get_tree().quit()


func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://Levels/level_1.tscn")


func _on_levels_button_pressed():
	get_tree().change_scene_to_file("res://Levels/level_select.tscn")


func _on_skins_button_pressed():
	get_tree().change_scene_to_file("res://skin_select.tscn")


func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://credits.tscn")
	


func _physics_process(delta):
	for letter in $Title.get_children():
		var direction = ($BlackHoles/BlackHole.position - letter.position)
		var distance = direction.length()
		
		if (distance > 500):
			continue
		
		var force = direction * ((GRAVITY*BH_MASS*LETTER_MASS)/(distance**2))
		
		letter.apply_central_force(force)
			

func moveBlackHole():
	$BlackHoles/BlackHole.position = get_global_mouse_position()

func _input(ev):
	if ev is InputEventMouseButton:
		if ev.button_index == 1 and ev.is_pressed():
			moveBlackHole()
