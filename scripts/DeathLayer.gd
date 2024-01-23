extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.


func _on_area_3d_body_entered(body:Node3D):
	if body is Player:
		body.healthComponent.take_damage(10000, body.device, "falling")
