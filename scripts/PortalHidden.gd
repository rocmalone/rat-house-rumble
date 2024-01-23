extends Node3D
class_name PortalHidden
@export var ToPortal : PortalHidden

var cur_player : Player
@onready var exit_position = $ExitLocation.global_position
@onready var exit_rotation = $ExitLocation.transform


const ROTATE_SPEED : float = 377.0
const FLUSH_Y_DOWN : float = 4.0
const FLUSH_TIME : float = 0.1
var timer = 0

const RECENT_CLEAR_TIME = 1.5
var recent_entries = []
var recent_clear_timer = 0


var original_position : Vector3

func add_recent(player : Player):
	# Add the player to the recent array and record its index
	recent_entries.append(player)
	var index = recent_entries.size() - 1
	# Create a timer for RECENT_CLEAR_TIME and complete the next line after it times out
	await get_tree().create_timer(RECENT_CLEAR_TIME).timeout
	recent_entries.remove_at(index)

func arrive(player : Player):
	# Disable collision for the player
	# player.set_collision_layer_value(1, false)

	# Teleport the player near and set a velocity towards the exit position
	player.global_position = exit_position
	# var direction = (exit_position - global_position).normalized()

	# await get_tree().create_timer(0.2).timeout
	# player.set_collision_layer_value(1, true)



func _on_area_3d_body_entered(body:Node3D):
	if body is Player:
		if body not in recent_entries:
			print_debug("PLAYER ENTERED HIDDEN PORTAL")
			cur_player = body
			original_position = body.position
			ToPortal.add_recent(cur_player)
			ToPortal.arrive(cur_player)
			cur_player = null
		
		
