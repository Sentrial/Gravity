extends Node


const SAVE_PATH = "user://savegame.bin"


func saveGame():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var data: Dictionary = {
		"levels": Game.levels,
		"highestCompletedLevel": Game.highestCompletedLevel,
		"selectedSkinIndex": Game.selectedSkinIndex,
		"totalCompletedLevels": Game.totalCompletedLevels,
		"skin_unlocked": Game.skin_unlocked
	}
	var jstr = JSON.stringify(data)
	file.store_line(jstr)
	
func loadGame():
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if FileAccess.file_exists(SAVE_PATH):
		if not file.eof_reached():
			var current_line = JSON.parse_string(file.get_line())
			if current_line:
				Game.levels = current_line["levels"]
				Game.highestCompletedLevel = int(current_line["highestCompletedLevel"])
				Game.selectedSkinIndex = int(current_line["selectedSkinIndex"])
				Game.totalCompletedLevels = int(current_line["totalCompletedLevels"])
				Game.skin_unlocked = current_line["skin_unlocked"]
		file.close()
