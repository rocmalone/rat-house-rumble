extends Bullet

var timer = 0

@export var min_damage : int
@export var max_damage : int
@export var self_damage_mod : float = 0.5
@export var self_knockback_mod : float = 0.5

@onready var collisionShapeRadius : float = $CollisionShape3D.shape.radius

func _physics_process(delta):
	timer += delta
	if(timer > 1.0):
		queue_free()

func _ready():
	for child in get_children():
		if child is GPUParticles3D:
			child.emitting = true
	$AudioStreamPlayer3D.play()




func _on_body_entered(body:Node3D):
	# Handle splash damage
	var distance : float = global_position.distance_to(body.global_position)
	# 1.0 = edge of the splash, 0.0 = center of the splash 
	var relative_distance : float = clampf((collisionShapeRadius - distance) / collisionShapeRadius, 0, 1)

	damage = lerpf(min_damage, max_damage, relative_distance)
	var knockback = 30
	var knockback_v = 5

	# Self-explosion
	if body is Player:
		if body.device == device:
			knockback *= self_knockback_mod
			knockback_v *= self_knockback_mod
			damage *= self_damage_mod
	
	super.knockback_body(body, knockback, knockback_v)
	super.deal_damage_to_body(body, damage)

