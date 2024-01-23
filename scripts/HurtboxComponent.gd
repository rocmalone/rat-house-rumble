extends Area3D

@export var healthComponent : HealthComponent




func _on_body_entered(body:Node3D):
	if body.is_class("Bullet"):
		print_debug("BULLET COLLISION TAKE", body.damage)

