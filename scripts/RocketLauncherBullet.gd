extends Bullet

@onready var mesh = $MeshInstance3D
@onready var ray = $RayCast3D
@export var explosionScene : Resource
var explosion

func _ready():
	explosion = load(explosionScene.resource_path)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.basis * Vector3(0, 0, speed) * delta

func _on_body_entered(body:Node3D):
	if body is Player:
		if body.device == device:
			return
			
	var instance = explosion.instantiate()
	instance.position = position
	instance.device = device
	instance.weapon_name = weapon_name
	get_tree().get_root().add_child(instance)
	super._on_body_entered(body)


	
