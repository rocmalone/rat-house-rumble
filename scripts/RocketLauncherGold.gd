extends Item

var bullet = load("res://Scenes/Weapons/RocketLauncherBulletGold.tscn")
var instance


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
