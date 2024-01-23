extends Button


@onready var GameSetupScreen = preload("res://Levels/GameSetupScreen/GameSetupScreen3.tscn")

func _on_pressed():
	Global.num_players = 3
	get_tree().change_scene_to_packed(GameSetupScreen)