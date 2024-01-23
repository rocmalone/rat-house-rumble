extends Node3D

var subviewport = preload("res://Levels/PrimaryMap/configured_sub_viewport.tscn")
var subviewport_container = preload("res://Levels/PrimaryMap/configured_sub_viewport_container.tscn")

# Temp variable for spawn positions
var placement_x = 0

var hasGeneratedPlayers = false

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().root.content_scale_mode = Window.CONTENT_SCALE_MODE_DISABLED


func _generate_players():
		print("READY")
		if(Global.num_players == 2):
			print("2 PLAYERS")
			$ViewportGridContainer.columns = 1
			for i in range(0,Global.num_players):
				print("ADDING VIEWPORT ", i)
				var player_i
				# Instantiate the player object based on the character select selections
				match Global.player_character_choices[i]:
					-1:
						continue
					0:
						player_i = load("res://Scenes/Player/Player_Jim.tscn").instantiate()
					1:
						player_i = load("res://Scenes/Player/Player_Akram.tscn").instantiate()
					2:
						player_i = load("res://Scenes/Player/Player_Sasha.tscn").instantiate()
					3:
						player_i = load("res://Scenes/Player/Player_Nick.tscn").instantiate()
					4:
						player_i = load("res://Scenes/Player/Player_Ezra.tscn").instantiate()

				# Set player instance parameters and spawn location
				player_i.device = i
				player_i.player_name = Global.player_name_dict[i]
				player_i.spawn(get_tree())
				# Set global player object references
				Global.playerObjectRefs[i] = player_i

				# Create the viewports
				var subviewport_container_i = subviewport_container.instantiate()
				$ViewportGridContainer.add_child(subviewport_container_i)

				var subviewport_i = subviewport.instantiate()
				# Global.playerViewportRefs[i] = subviewport_i
				subviewport_container_i.add_child(subviewport_i)

				subviewport_i.add_child(player_i)

				subviewport_i.div_window_x = 1
				subviewport_i.div_window_y = 2




		elif(Global.num_players == 3):
			$ViewportGridContainer.columns = 1

			for i in range(0,Global.num_players):
				var player_i
				match Global.player_character_choices[i]:
					-1:
						continue
					0:
						player_i = load("res://Scenes/Player/Player_Jim.tscn").instantiate()
					1:
						player_i = load("res://Scenes/Player/Player_Akram.tscn").instantiate()
					2:
						player_i = load("res://Scenes/Player/Player_Sasha.tscn").instantiate()
					3:
						player_i = load("res://Scenes/Player/Player_Nick.tscn").instantiate()
					4:
						player_i = load("res://Scenes/Player/Player_Ezra.tscn").instantiate()

				player_i.device = i
				player_i.player_name = Global.player_name_dict[i]
				# Set global player object references
				Global.playerObjectRefs[i] = player_i

				var new_viewport_grid_container : GridContainer = $ViewportGridContainer/NewViewportGridContainer

				if(i == 0):
					var subviewport_container_i = subviewport_container.instantiate()
					$ViewportGridContainer.add_child(subviewport_container_i)
		
					var subviewport_i = subviewport.instantiate()
					# Global.playerViewportRefs[i] = subviewport_i
					subviewport_container_i.add_child(subviewport_i)
		
					subviewport_i.add_child(player_i)

					subviewport_i.div_window_x = 1
					subviewport_i.div_window_y = 2

					# Create new sub-grid for the other viewports
					new_viewport_grid_container = GridContainer.new()
					new_viewport_grid_container.name = "NewViewportGridContainer"
					new_viewport_grid_container.columns = 2
					new_viewport_grid_container.size_flags_vertical = 3
					$ViewportGridContainer.add_child(new_viewport_grid_container)

					continue

				var subviewport_container_i = subviewport_container.instantiate()
				new_viewport_grid_container.add_child(subviewport_container_i)

				var subviewport_i = subviewport.instantiate()
				# Global.playerViewportRefs[i] = subviewport_i
				subviewport_container_i.add_child(subviewport_i)

				subviewport_i.add_child(player_i)

				subviewport_i.div_window_x = 2
				subviewport_i.div_window_y = 2


		elif(Global.num_players == 4):
			$ViewportGridContainer.columns = 2
			for i in range(0,Global.num_players):
				var player_i
				match Global.player_character_choices[i]:
					-1:
						continue
					0:
						player_i = load("res://Scenes/Player/Player_Jim.tscn").instantiate()
					1:
						player_i = load("res://Scenes/Player/Player_Akram.tscn").instantiate()
					2:
						player_i = load("res://Scenes/Player/Player_Sasha.tscn").instantiate()
					3:
						player_i = load("res://Scenes/Player/Player_Nick.tscn").instantiate()
					4:
						player_i = load("res://Scenes/Player/Player_Ezra.tscn").instantiate()

				player_i.device = i
				player_i.player_name = Global.player_name_dict[i]
				# Set global player object references
				Global.playerObjectRefs[i] = player_i

				var subviewport_container_i = subviewport_container.instantiate()
				$ViewportGridContainer.add_child(subviewport_container_i)

				var subviewport_i = subviewport.instantiate()
				# Global.playerViewportRefs[i] = subviewport_i
				subviewport_container_i.add_child(subviewport_i)

				subviewport_i.add_child(player_i)

				subviewport_i.div_window_x = 2
				subviewport_i.div_window_y = 2

func _generate_explore():
	$ViewportGridContainer.columns = 1
	var player_i

	player_i = load("res://Scenes/Player/Player_Sasha.tscn").instantiate()

	# Set player instance parameters and spawn location
	player_i.device = 0
	player_i.player_name = Global.player_name_dict[0]
	player_i.spawn(get_tree())
	# Set global player object references
	Global.playerObjectRefs[0] = player_i

	# Create the viewports
	var subviewport_container_i = subviewport_container.instantiate()
	$ViewportGridContainer.add_child(subviewport_container_i)

	var subviewport_i = subviewport.instantiate()
	# Global.playerViewportRefs[i] = subviewport_i
	subviewport_container_i.add_child(subviewport_i)

	subviewport_i.add_child(player_i)

	subviewport_i.div_window_x = 1
	subviewport_i.div_window_y = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(self.is_inside_tree() and !hasGeneratedPlayers):
		if(Global.explore):
			_generate_explore()
		else:
			_generate_players()

		hasGeneratedPlayers = true

