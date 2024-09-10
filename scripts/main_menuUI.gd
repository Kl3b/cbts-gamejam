extends Control




func _on_play_button_pressed():
	LevelManager.goToLevel(Gamemanager.CurrentLevelNumber)
