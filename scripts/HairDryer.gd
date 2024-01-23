extends Item

@export var startAudio : AudioStreamMP3
@export var midAudio : AudioStreamMP3
@export var endAudio : AudioStreamMP3

var bullet = load("res://Scenes/Weapons/HairDryerBullet.tscn")
var instance

@onready var audioStreamPlayer : AudioStreamPlayer = $AudioStreamPlayer

var fire_rate_cd : float = 0.07
var fire_rate_timer : float = 0

var is_firing = false
var is_firing_last_frame = false

var input_suffix : String 

func activate(device_id : int):
	input_suffix = "_device_" + str(device_id)
	if !$AnimationPlayer.is_playing():
		$AnimationPlayer.play("Shoot")
	# Decouple firing from animation
	if(fire_rate_timer <= 0):
		instance = bullet.instantiate()
		instance.position = $RayCast3D.global_position
		instance.transform.basis = $RayCast3D.global_transform.basis
		instance.device = device_id
		# Pass the position of the hairdryer to the bullet
		# Used for knockback calculations
		instance.initial_player_pos = global_position

		get_tree().get_root().add_child(instance)
		
		ammo -= 1
		fire_rate_timer = fire_rate_cd
		return true
	return false

func _physics_process(delta):
	if fire_rate_timer > 0:
		fire_rate_timer -= delta

	# Store whether we're firing or not for the audio clip sequences below
	if(input_suffix):
		if(Input.is_action_pressed("shoot" + input_suffix)):
			is_firing = true
		else: 
			is_firing = false

	# print_debug(is_firing, " ", is_firing_last_frame)
	# Middle audio
	if (is_firing and is_firing_last_frame):
		if(not audioStreamPlayer.playing):
			audioStreamPlayer.stream = midAudio
			audioStreamPlayer.play()
	# Startup audio
	elif (is_firing and not is_firing_last_frame):
		audioStreamPlayer.stream = startAudio
		audioStreamPlayer.play()
		$GPUParticles3D.emitting = true
	# Ending audio
	elif (not is_firing and is_firing_last_frame):
		audioStreamPlayer.stream = endAudio
		audioStreamPlayer.play()
		$GPUParticles3D.emitting = false

	is_firing_last_frame = is_firing


func _ready():
	resource_path = "res://Scenes/Weapons/HairDryer.tscn"

