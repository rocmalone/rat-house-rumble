extends Area3D
class_name ArmorPickup

const ROTATION_SPEED = 1.0
const BOB_FREQ = 2.0
const BOB_AMP = 0.005

var original_y
var bob_max_y
var time = 0.0

var respawn_t = 0.0

@export var armorAdd = 30
@export var respawnTime = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	rotate_y(ROTATION_SPEED * delta)

	time += delta * BOB_FREQ
	position = position + Vector3(0, sin(time) * BOB_AMP, 0)
	respawn_t += delta
	if(!visible and respawn_t > respawnTime):
		show()

func _on_body_entered(body:Node3D):
	if body is Player and visible:
		respawn_t = 0
		body.healthComponent.take_armor(armorAdd)
		hide()