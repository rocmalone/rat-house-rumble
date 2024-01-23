extends CharacterBody3D
class_name Player

# CONSTANTS
const MAX_SPEED = 10.0
const SLIDE_SPEED = 5.0
const SPRINT_SPEED = 7.0
const WALK_SPEED = 4.0
const BHOP_MIN_CUTOFF_SEC = 0.25
const BHOP_MAX_CUTOFF_SEC = 0.6
const JUMP_VELOCITY = 5.0
const MOUSE_SENSITIVITY = 0.002

const LOW_JOY_MODIFIER = 0.2
const JOY_DEADZONE = 0.005

	# Bob variables
const BOB_FREQ = 2.0
const BOB_AMP = 0.08
var t_bob = 0.0

	# FOV variables
const BASE_FOV = 75.0
const BASE_FOV_LOW = 55.0
const FOV_CHANGE = 1.5
var cur_fov = BASE_FOV

# Stats variables
var speed = 5.0

# Bunny hop variables
var bhop_timer : float = 0.0
var bhop_timer_enabled = false
var in_air_last_frame = false
var is_sliding = false
var bhop_mod = 1.0
var bhop_cutoff_sec = BHOP_MIN_CUTOFF_SEC

# Knockback variable
var outside_forces : Vector3 = Vector3.ZERO

# Co-op variables
@export var device : int
@onready var input_suffix : String = "_device_" + str(device)

@export var player_name : String

var startMenuPacked = preload("res://Scenes/start_menu.tscn")


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = 9.8

# Restrict movement and looking vars
var can_move = true
var can_look = true
var can_shoot = true
var can_spin = true


# Scope in variables
var isScoped = false

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var scoreboard = $UI/Scoreboard
@onready var animationPlayer = $AnimationPlayer
@onready var hurtSoundsComponent : HurtSoundsComponent = $HurtSoundsComponent
@onready var healthComponent : HealthComponent = $HealthComponent
@onready var visualHandComponent : VisualHandComponent = $Head/Camera3D/VisualHandComponent
@onready var playerMesh : MeshInstance3D = $Armature/Skeleton3D.get_child(0)
@onready var cur_joy_sensitivity = Global.player_joy_sensitivity[device]
var joy_sensitivity_mod = 1
var itemMesh = null;


var rotate_y_velocity : float = 0.0
func add_rotate_y_velocity(amount : float):
	rotate_y_velocity = amount


func _handle_look():
	if(!can_look):
		return
	# Handle Joypad Look
	# left/right
	var joy_look_horizontal = Input.get_axis("lookleft" + input_suffix, "lookright" + input_suffix)
	if abs(joy_look_horizontal) > JOY_DEADZONE and !Global.inMenu:
		head.rotate_y(-joy_look_horizontal * Global.player_joy_sensitivity[device] * joy_sensitivity_mod)

	# up/down
	var joy_look_vertical = Input.get_axis("lookup" + input_suffix, "lookdown" + input_suffix)
	if abs(joy_look_vertical) > JOY_DEADZONE and !Global.inMenu:
		camera.rotate_x(-joy_look_vertical * Global.player_joy_sensitivity[device] * joy_sensitivity_mod)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))


func _handle_move(delta):
	if(!can_move):
		return
	# Handle movement
	var input_dir = Input.get_vector(
		"left" + input_suffix, 
		"right" + input_suffix, 
		"forward" + input_suffix, 
		"backward" + input_suffix)
	
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	# if is_on_floor():
	if direction and !Global.inMenu:
		if velocity.x == 0 && velocity.z == 0 && !is_spinning:
			animationPlayer.play("Run")
	
		velocity.x = clampf(direction.x * speed * bhop_mod, -MAX_SPEED, MAX_SPEED)
		velocity.z = clampf(direction.z * speed * bhop_mod, -MAX_SPEED, MAX_SPEED)

		if !animationPlayer.is_playing():
			if(!is_sliding && !is_spinning):
				animationPlayer.play("Run")

	else:
		if is_on_floor() && !is_spinning:
			if velocity.x != 0 && velocity.z != 0: 
				animationPlayer.play("Idle")
			velocity.x = 0.0
			velocity.z = 0.0

			if(!animationPlayer.is_playing()):
				animationPlayer.play("Idle")
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)


func _handle_sprint():
	pass
	# # Handle Sprint
	# if Input.is_action_pressed("leftstickpress" + input_suffix):
	# 	speed = SPRINT_SPEED
	# 	if animationPlayer.has_animation("Slide"):
	# 		animationPlayer.play("Slide")
	# if(animationPlayer.current_animation != "Slide"):
	# 	speed = WALK_SPEED

var is_spinning = false
func _handle_spin(_delta):
	# Handle Spin.
	if (Input.is_action_just_pressed("spin"  + input_suffix) and !Global.inMenu):
		if(can_spin):
			$SpinSoundComponent.play()
			# Spin cooldown and damage only when not in explore mode
			if(!Global.explore):
				can_spin = false
				healthComponent.take_damage(10, device, "Unstuck")
			$CollisionShape3D.disabled = true
			is_spinning = true
			velocity.y = JUMP_VELOCITY
			animationPlayer.play("Spin")
			await get_tree().create_timer(1).timeout
			$CollisionShape3D.disabled = false
			is_spinning = false
			can_spin = true
			
	if Input.is_action_just_pressed("x_button"  + input_suffix) and !Global.inMenu:
		if(animationPlayer.has_animation("Dance")):
			animationPlayer.play("Dance")



	if Input.is_action_just_pressed("rightstickpress" + input_suffix) and !Global.inMenu:
		if(isScoped):
			cur_fov = BASE_FOV
			# cur_joy_sensitivity = Global.player_joy_sensitivity[device]
			joy_sensitivity_mod = 1
			isScoped = false
		else:
			cur_fov = BASE_FOV_LOW
			joy_sensitivity_mod = LOW_JOY_MODIFIER
			isScoped = true

		


func _handle_item():
	if(!can_shoot):
		return
	# Handle Shoot
	if Input.is_action_pressed("shoot" + input_suffix) and !Global.inMenu:
		visualHandComponent.activate(device)


const MAX_JUMPS = 2
var cur_jumps = 0
# TODO: MAKE BHOP SYSTEM MORE INTERESTING
func _handle_jump(delta):
	# print_debug("TIMER ", bhop_timer, " // MOD ", bhop_mod)

	if(in_air_last_frame == true and is_on_floor()):
		bhop_timer_enabled = true
		cur_jumps = 0
	# If the bhop timer is ticking
	if(bhop_timer_enabled && is_on_floor()):
		# Increment the timer
		bhop_timer += delta
		# If it is over the cutoff, reset it and bhop speed modifier
		if(bhop_timer > bhop_cutoff_sec):
			bhop_timer = 0
			bhop_mod = 1.0
			bhop_cutoff_sec = BHOP_MIN_CUTOFF_SEC
			bhop_timer_enabled = false

	# Handle Jump.
	# if Input.is_action_just_pressed("jump" + input_suffix) && is_on_floor():
	if Input.is_action_just_pressed("jump" + input_suffix) && cur_jumps < MAX_JUMPS and !Global.inMenu:
		cur_jumps += 1
		velocity.y = JUMP_VELOCITY
		if (speed * bhop_mod) > SPRINT_SPEED:
			if(!is_sliding):
				print_debug("TRIGGERED SLIDE ANIM")
				animationPlayer.play("Slide", -1.0, 2.0)
				is_sliding = true
		else:
			animationPlayer.stop()
			animationPlayer.play("RESET")
			animationPlayer.play("Jump", -1.0, 2.0)
			is_sliding = false
				
		# If the bhop timer is counting and less than the cutoff increase mod
		if(bhop_timer > 0 and bhop_timer < bhop_cutoff_sec):
			bhop_mod = bhop_mod * 1.1
			bhop_cutoff_sec = clampf(bhop_cutoff_sec * bhop_mod, BHOP_MIN_CUTOFF_SEC, BHOP_MAX_CUTOFF_SEC)
			bhop_timer = 0

	in_air_last_frame = !is_on_floor()

	
func _handle_headbob(delta):
	t_bob += delta * velocity.length() * float(is_on_floor())

	var pos = Vector3.ZERO
	if(!is_sliding):
		pos.y = sin(t_bob * BOB_FREQ) * BOB_AMP
		pos.x = cos(t_bob * BOB_FREQ / 2) * BOB_AMP

	camera.transform.origin = pos


func _handle_fov(delta):
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = cur_fov + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)





func _on_health_component_health_changed(_new_health, _old_health):
	animationPlayer.play("Hurt")
	hurtSoundsComponent.play()

func _on_health_component_armor_changed(_new_armor, _old_armor):
	animationPlayer.play("Hurt")
	hurtSoundsComponent.play()

# _handle_death
func _on_health_component_health_depleted(killer_device_id : int, weapon_name : String):
	Global.add_kill(killer_device_id, device, weapon_name)
	can_move = false
	can_shoot = false

	velocity = Vector3.ZERO
	outside_forces = Vector3.ZERO

	visualHandComponent.drop_items()

	spawn()

func spawn(scene_tree := get_tree()):
	var min_distance_from_player_squared = 10^2
	var dead = true
	# Count the number of spawn locations
	var numSpawnLocations = scene_tree.get_nodes_in_group("SPAWN_LOCATIONS").size();
	# How many times we've looped looking for a spawn location
	var numAttemptsToSpawn = 0
	while(dead):
		var whichLocationToSpawn = randi_range(0,numSpawnLocations - 1)
		var spawnLocation = scene_tree.get_nodes_in_group("SPAWN_LOCATIONS")[whichLocationToSpawn]
		
		var players_near = 0
		# Verify there is not a player too close to the spawn location
		for player in Global.playerObjectRefs:
			if(player):
				if(spawnLocation.global_position.distance_squared_to(player.global_position) < min_distance_from_player_squared):
					players_near += 1

		# Spawn the player. Otherwise, repeat this loop searching for a new spawn location.
		# If we've tried to spawn over 100 times, there is a problem and we should just spawn
		if(players_near == 0 or numAttemptsToSpawn > 100):
			var spawn_position = Vector3(0,4,0) # Default
			# If there are no spawn locations from some reason (i.e. testing map)
			if(spawnLocation):
				spawn_position = spawnLocation.global_position
			# End the loop
			dead = false

			# Move to the component
			global_position = spawn_position
			
			# camera.look_at(spawnLocation.find_child("Raycast3D").to_global(spawnLocation.find_child("Raycast3D").target_position))

			# Reset health and capabilities
			if(healthComponent):
				healthComponent.set_health(healthComponent.max_health)
			can_move = true
			can_shoot = true
			
		numAttemptsToSpawn += 1
	


func add_outside_force(amount : Vector3):
	outside_forces = amount

func _handle_outside_forces(_delta):
	velocity += outside_forces
	outside_forces = Vector3.ZERO


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	_handle_look()
	_handle_move(delta)
	_handle_sprint()
	_handle_spin(delta)
	_handle_item()
	_handle_jump(delta)
	_handle_headbob(delta)
	_handle_fov(delta)
	_handle_outside_forces(delta)

	# Menu Controls
	# Show/Hide Scoreboard
	if Input.is_action_pressed("back" + input_suffix) and !Global.inMenu:
		scoreboard.show()
	else:
		scoreboard.hide()

	
	# Y-Rotation Velocity
	if(rotate_y_velocity > 0):
		head.rotate_y(rotate_y_velocity * delta)
		# Multiply the rotate_y_velocity by 75% each frame
		rotate_y_velocity = rotate_y_velocity * 0.95
		if(rotate_y_velocity < 0.05):
			rotate_y_velocity = 0





	move_and_slide()


func _ready():
	# Handle visual layers to ensure body isn't visible to camera, but is to
	# other players.
	if(playerMesh):
		playerMesh.set_layer_mask_value(1, false)
		playerMesh.set_layer_mask_value(20 - device, true)
	camera.set_cull_mask_value(20 - device, false)


# func _unhandled_input(event):
# 	pass
	# if event is InputEventMouseMotion and player_num == 1:
	# 	head.rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
	# 	camera.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
	# 	camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(60))
