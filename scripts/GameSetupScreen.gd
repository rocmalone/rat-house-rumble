extends MarginContainer

var locked_in_players = 0
var playerJoinControllerPacked = preload("res://Levels/GameSetupScreen/PlayerJoinController.tscn")
@export var number_of_players : int
var already_loading = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.num_players = number_of_players
	Global.player_character_choices = [-1,-1,-1,-1]
	get_tree().root.content_scale_mode = Window.CONTENT_SCALE_MODE_DISABLED



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# Handle start menus
	# if(Input.is_action_just_pressed("start") and not Global.inMenu):
	# 	$StartMenu.show()
		

	# Loop through all the PlayerJoinControllers and check if locked in
	for child in $GridContainer.get_children():
		if child is PlayerJoinController:
			if child.state == child.STATE.LOCKED_IN:
				locked_in_players += 1
				var childPlayerSelectComponent : PlayerSelectComponent = child.find_child("PlayerSelectComponent")
				Global.player_character_choices[child.device] = childPlayerSelectComponent.cur_char_num
				Global.player_name_dict[child.device] = childPlayerSelectComponent.cur_char.char_name
			elif child.state != child.STATE.LOCKED_IN:
				Global.player_character_choices[child.device] = -1
		elif child.get_class() == "GridContainer":
			for child2 in child.get_children():
				if child2 is PlayerJoinController:
					if child2.state == child2.STATE.LOCKED_IN:
						locked_in_players += 1
						var childPlayerSelectComponent : PlayerSelectComponent = child2.find_child("PlayerSelectComponent")
						Global.player_character_choices[child2.device] = childPlayerSelectComponent.cur_char_num
						Global.player_name_dict[child2.device] = childPlayerSelectComponent.cur_char.char_name
					elif child2.state != child2.STATE.LOCKED_IN:
						Global.player_character_choices[child2.device] = -1
	

	# print_debug("NUM_PLAYERS: ", Global.num_players, "\tLOCKED_PLAYERS: ", locked_in_players)

	if locked_in_players == Global.num_players and not already_loading:
		already_loading = true
		await get_tree().create_timer(1).timeout
		# print_debug("ALL LOCKED IN!")
		if(Global.testing):
			get_tree().change_scene_to_file("res://Levels/default.tscn")
		else:
			get_tree().change_scene_to_file("res://Levels/LoadingScene.tscn")
		

	locked_in_players = 0
	
