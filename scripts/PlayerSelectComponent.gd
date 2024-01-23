extends Control
class_name PlayerSelectComponent

const X_SPACING = 5  # How far apart characters are spaced
const Z_OFFSET = -3  # How far from the camera characters are
const CAMERA_SPEED : float = 10.0
const ROTATE_SPEED : float = 8.0 # deg/s

@export var camera : Camera3D
@onready var camera_container = camera.get_parent()
@onready var vp : SubViewport = $SubViewportContainer/SubViewport
#@onready var character_container = $SubViewportContainer/SubViewport/CharacterContainer


@export var char_container : Node3D
@onready var cur_char_num = 0
@onready var cur_char = char_container.get_child(cur_char_num)
@onready var cur_char_ui = cur_char.find_child("CharInfoUI")
var is_cur_char_visible = true

var current_animation_player : AnimationPlayer = null
var world_environment : WorldEnvironment = null
@onready var thwack_audioStreamPlayer = $thwack_AudioStreamPlayer
@onready var lock_audioStreamPlayer : AudioStreamPlayer = $lock_AudioStreamPlayer

@export var div_window_x : int
@export var div_window_y : int

var current_child = 0
var target_x : float = 0.0

@onready var lock_display = $SubViewportContainer/SubViewport/LockDisplay
@onready var selected_display = $SubViewportContainer/SubViewport/SelectedDisplay

var modx = 0
var mody = 0

## Move to the next character in character selection.
## direction = -1 for backwards, direction = 1 for forwards
func _next_char(direction : int):
	if(!(direction == -1 || direction == 1)):
		return
	thwack_audioStreamPlayer.play()

	# Set the current character to the "cur_char_num"'th child of the container
	cur_char = char_container.get_child(cur_char_num)
	# Set the current character model and UI to not visible
	cur_char.visible = false
	cur_char.char_info_ui.visible = false
	

	# If at the end of the array (front or back), restart cur_char_num. 
	# Otherwise, increment/decrement by one
	if(direction == 1):
		if(cur_char_num == char_container.get_children().size() - 1):
			cur_char_num = 0
		else:
			cur_char_num += 1
	elif(direction == -1):
		if(cur_char_num == 0):
			cur_char_num = char_container.get_children().size() - 1
		else:
			cur_char_num -= 1
	
	# Set the new cur_char from the new cur_char_num
	cur_char = char_container.get_child(cur_char_num)
	# Show the model for the character
	cur_char.visible = true
	# Show the UI for the character
	cur_char.char_info_ui.visible = true
	# Change the skybox image to the one attached to the character
	world_environment.environment = cur_char.environment

	# Add additional camera rotation for effect
	camera_container.rotate(Vector3(0,1,0), deg_to_rad(180 * direction))

	
func next():
	_next_char(1)

func previous():
	_next_char(-1)


func lock_in():
	print_debug("Char choices:", Global.player_character_choices)
	# If someone else has locked the char
	if(cur_char_num in Global.player_character_choices):
		print_debug("Tried to lock in, did not allow")
		cur_char.locked_in = false
		thwack_audioStreamPlayer.play()
		return false
	else:
		lock_audioStreamPlayer.play()
		cur_char.locked_in = true
		lock_display.show()
		return true
	

func lock_out():
	cur_char.locked_in = false
	lock_display.hide()

func _process(delta):


	# LERP the camera over to the current character
	#  Offset to account for head
	var camera_position_offset = Vector3(0, 1.2, 0)
	var camera_look_offset = Vector3(0,0.8,0)
	camera_container.global_position.x = lerp(camera_container.global_position.x, cur_char.global_position.x + camera_position_offset.x, delta * CAMERA_SPEED)
	camera_container.global_position.y = lerp(camera_container.global_position.y, cur_char.global_position.y + camera_position_offset.y, delta * CAMERA_SPEED)
	camera_container.global_position.z = lerp(camera_container.global_position.z, cur_char.global_position.z + camera_position_offset.z, delta * CAMERA_SPEED)
	# Rotate the camera around the current character y-axis while looking at it
	camera_container.rotate(Vector3(0,1,0), deg_to_rad(delta * ROTATE_SPEED))
	camera.look_at(cur_char.global_position + camera_look_offset)

	# Keep the viewport an appropriate size for the number of players config
	vp.size.x = get_window().size.x / div_window_x
	vp.size.y = get_window().size.y / div_window_y

	# Indicate if the character has been locked by another player
	var index_in_global = Global.player_character_choices.find(cur_char_num)
	# If the cur char is in the global array
	if(index_in_global != -1):
		$SubViewportContainer/SubViewport/SelectedDisplay/TextControl/Label.text = "Player " + str(index_in_global + 1)
		$SubViewportContainer/SubViewport/SelectedDisplay/TextControl/Label.add_theme_color_override("font_color", Global.player_colors[index_in_global])

		$SubViewportContainer/SubViewport/SelectedDisplay/ColorRect.size.x = vp.size.x 
		$SubViewportContainer/SubViewport/SelectedDisplay/ColorRect.size.y = vp.size.y
		$SubViewportContainer/SubViewport/SelectedDisplay/TextControl.position.x = vp.size.x / 2 + modx
		$SubViewportContainer/SubViewport/SelectedDisplay/TextControl.position.y = vp.size.y / 2 + mody

		# print_debug("TextControl Pos x:" + str($SubViewportContainer/SubViewport/SelectedDisplay/TextControl.position.x) + " y:" + str($SubViewportContainer/SubViewport/SelectedDisplay/TextControl.position.y))

		# print_debug("ColorRect Size x:" + str($SubViewportContainer/SubViewport/SelectedDisplay/ColorRect.size.x) + " y:" + str($SubViewportContainer/SubViewport/SelectedDisplay/ColorRect.size.y))

		
		# print_debug("Viewport Size x:" + str(vp.size.x) + " y:" + str(vp.size.y))

		$SubViewportContainer/SubViewport/SelectedDisplay.show()
		
	else:
		$SubViewportContainer/SubViewport/SelectedDisplay.hide()


func _ready():
	# Set the current character to the "cur_char_num"'th child of the container
	cur_char = char_container.get_child(cur_char_num)

	world_environment = char_container.get_parent().find_child("WorldEnvironment")
	# Initialize component w appropriate size for the number of players config
	vp.size.x = get_window().size.x / div_window_x
	vp.size.y = get_window().size.y / div_window_y

	# Set all characters and UIs to not visible except for the current one
	# Set all characters and 
	for chara in char_container.get_children():
		chara.visible = false
		chara.char_info_ui.visible = false
	cur_char.visible = true
	cur_char.char_info_ui.visible = true



	# Place camera child objects in a line
	# var x_pos = 0
	# for node in camera.get_children():
	# 	node.position.x = x_pos
	# 	node.position.z = Z_OFFSET||
	# 	x_pos += X_SPACING
