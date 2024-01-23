extends Button


func _on_pressed():
	print_debug("SELECTED: EXPLORE")
	Global.explore = true

	Global.num_players = 1
	get_tree().root.content_scale_mode = Window.CONTENT_SCALE_MODE_DISABLED
	get_tree().change_scene_to_file("res://Levels/LoadingScene.tscn")
