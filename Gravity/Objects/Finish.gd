extends Area2D

func _on_body_entered(body):
	if $"../Player/Player".started:
		$Explosion.position = body.position - self.position
		$Explosion.emitting = true
		$"../Player/Player".completedLevel()
		$"../NextLevelButton".visible = true
		var currentLevelIndex = int(str(get_tree().current_scene.name))
		var nextLevelIndex = currentLevelIndex + 1
		if (nextLevelIndex <= Game.MAX_LEVEL):
			Game.levels[str(nextLevelIndex)][0] = true
		if Game.highestCompletedLevel < (nextLevelIndex - 1):
			Game.highestCompletedLevel = nextLevelIndex - 1
		
		if (!Game.levels[str(currentLevelIndex)][1]):
			Game.levels[str(currentLevelIndex)][1] = true
			Game.totalCompletedLevels += 1
			if (Game.totalCompletedLevels % 5 == 0):
				if !Game.skin_unlocked.has(str(Game.totalCompletedLevels/5)):
					return
				Game.skin_unlocked[str(Game.totalCompletedLevels/5)] = true
				var newSkinMessage = load("res://Specials/new_skin_unlocked.tscn").instantiate()
				$"../CompletedGroup".add_child(newSkinMessage)
				newSkinMessage.position = Vector2(140,360)
			
		Utils.saveGame()
