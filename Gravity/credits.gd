extends Node2D

func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://main.tscn")


func _on_website_button_pressed():
	OS.shell_open("https://brandonmccarthycs.com/")


func _on_youtube_button_pressed():
	OS.shell_open("https://www.youtube.com/sentrial")
