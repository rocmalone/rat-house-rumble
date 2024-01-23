extends Button


@onready var GameSetupScreen = preload("res://Levels/GameSetupScreen/GameSetupScreen2.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	grab_focus() # Replace with function body.

func _on_pressed():
	Global.num_players = 2
	get_tree().change_scene_to_packed(GameSetupScreen)