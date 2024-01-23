extends Item

var bullet = load("res://Scenes/Weapons/AssaultRifleBullet.tscn")
var instance

@export var shootSound : AudioStream

func activate(device_id : int):
	if !$AnimationPlayer.is_playing():
		$AnimationPlayer.play("Shoot")
		$AudioStreamPlayer.play()
		instance = bullet.instantiate()
		instance.position = $RayCast3D.global_position
		instance.transform.basis = $RayCast3D.global_transform.basis
		instance.device = device_id
		get_tree().get_root().add_child(instance)
		ammo -= 1
		return true
	return false

func _ready():
	var audioStreamPlayer : AudioStreamPlayer = $AudioStreamPlayer
	var stream = audioStreamPlayer.stream
	stream.add_stream(0,shootSound, 1.0)
	resource_path = "res://Scenes/Weapons/AssaultRifle.tscn"

	