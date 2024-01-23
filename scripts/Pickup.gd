extends Area3D
class_name Pickup

const ROTATION_SPEED = 1.0
const BOB_FREQ = 2.0
const BOB_AMP = 0.005

var original_y
var bob_max_y
var time = 0.0

var hidden = false
var respawn_t = 0.0

@export var respawnTime = 30

@export var itemScene : Resource = load("res://Scenes/Weapons/AssaultRifle.tscn")
# @export var itemScene : Resource = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	rotate_y(ROTATION_SPEED * delta)

	time += delta * BOB_FREQ
	position = position + Vector3(0, sin(time) * BOB_AMP, 0)
	respawn_t += delta
	if(hidden and respawn_t > respawnTime):
		show()
		hidden = false

func _on_body_entered(body:Node3D):
	print("BODY ENTERED")
	if body is Player and hidden == false:
		# print_debug("PLAYER COLLIDED WITH PICKUP")
		# print_debug("Resource Path: ", itemScene.resource_path)
		var visHand : VisualHandComponent = body.visualHandComponent
		if(visHand.swap_item(itemScene)):
			hide()
			hidden = true
			respawn_t = 0
			# global_position.x += randf_range(0.0, 3.0)
			# global_position.y += randf_range(0.0, 3.0)
