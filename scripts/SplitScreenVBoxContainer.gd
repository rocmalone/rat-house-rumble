extends VBoxContainer

@export var backToUI : VBoxContainer

var GameSetupScreen2 = load("res://Levels/GameSetupScreen/GameSetupScreen2.tscn")
var GameSetupScreen3 = load("res://Levels/GameSetupScreen/GameSetupScreen3.tscn")
var GameSetupScreen4 = load("res://Levels/GameSetupScreen/GameSetupScreen4.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(visible and Input.is_action_just_pressed("ui_cancel")):
		_on_back_from_split_screen_pressed()


func _on_back_from_split_screen_pressed():
	hide()
	backToUI.show()
	backToUI.get_child(0).grab_focus()



func _on_4player_pressed():
	Global.explore = false
	Global.num_players = 4
	get_tree().change_scene_to_packed(GameSetupScreen4)


func _on_3player_pressed():
	Global.explore = false
	Global.num_players = 3
	get_tree().change_scene_to_packed(GameSetupScreen3)

func _on_2player_pressed():
	Global.explore = false
	Global.num_players = 2
	get_tree().change_scene_to_packed(GameSetupScreen2)
