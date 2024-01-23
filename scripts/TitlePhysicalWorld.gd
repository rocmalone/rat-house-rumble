extends Node3D

const ROTATE_SPEED = 8.0
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("start")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Rotate the scene
	rotate(Vector3(0,1,0), deg_to_rad(delta * ROTATE_SPEED))
