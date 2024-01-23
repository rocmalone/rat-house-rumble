extends Area3D
class_name Bullet

@export var speed = 200.0
@export var damage = 5
@export var delete_on_impact = true

@export var weapon_name : String = "default"
@export var self_damage : bool = false
@export var self_knockback : bool = false
var device : int = -1

func _process(delta):
    position += transform.basis * Vector3(0, 0, -speed) * delta


func deal_damage_to_body(body:Node3D, amount:int):
    var healthComponent : HealthComponent = body.find_child("HealthComponent")
    if(healthComponent):
        # Check if the body is the same player as shot the bullet
        # If self damage is off, then do nothing
        if(body is Player):
            if(body.device == device and !self_damage):
                return
        healthComponent.take_damage(amount, device, weapon_name)

func knockback_body(body:Node3D, amount:int, amount_vertical:int):
    if(body is Player):
        # If we are colliding with the same player who shot the bullet and there is no self knockback do nothing
        if(body.device == device and !self_knockback):
            return
        var direction = (body.global_position - global_position).normalized()
        body.add_outside_force(direction * amount + Vector3(0,amount_vertical,0))


func _on_body_entered(body:Node3D):
    deal_damage_to_body(body, damage)
    
    if(delete_on_impact):
        queue_free()
