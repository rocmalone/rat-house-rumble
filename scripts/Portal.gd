extends Node3D
class_name Portal
@export var ToPortal : Portal
@export var exit_velocity : float = 9.0

var cur_player : Player
@onready var exit_position = $ExitLocation.global_position
@onready var exit_rotation = $ExitLocation.transform


const ROTATE_SPEED : float = 377.0
const FLUSH_Y_DOWN : float = 4.0
const FLUSH_TIME : float = 0.7
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


# Teleport the player to the portal
func arrive(player : Player):
	# Disable collision for the player
	player.set_collision_layer_value(1, false)

	# Teleport the player near and set a velocity towards the exit position
	player.global_position = global_position
	var direction = (exit_position - global_position).normalized()
	player.velocity = direction * exit_velocity

	# Water particles
	$GPUParticles3D.emitting = true

	# Wait for the player to explode out of the portal
	await get_tree().create_timer(0.5).timeout
	player.set_collision_layer_value(1, true)




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(cur_player):
		# Flush animation
		# cur_player.rotate_y(deg_to_rad(delta * ROTATE_SPEED))
		cur_player.global_position = original_position - Vector3(0,lerpf(0, FLUSH_Y_DOWN, timer),0)
		timer += delta

	if(timer > FLUSH_TIME):
		# cur_player.find_child("Head").find_child("Camera3D").look_at($ExitLocation.target_position)
		ToPortal.add_recent(cur_player)
		ToPortal.arrive(cur_player)
		cur_player = null
		timer = 0


# Suck the player into the portal
func _on_area_3d_body_entered(body:Node3D):
	if body is Player:
		if body not in recent_entries:
			cur_player = body
			original_position = body.position
			cur_player.add_rotate_y_velocity(50)
			$AudioStreamPlayer.play()
		
		
