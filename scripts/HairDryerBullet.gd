extends Bullet

var initial_player_pos : Vector3

# Custom knockback function
func knockback_body(body:Node3D, amount:int, amount_vertical:int):
    if(body is Player):
        # If we are colliding with the same player who shot the bullet and there is no self knockback do nothing
        if(body.device == device and !self_knockback):
            return
        var direction = (body.global_position - initial_player_pos).normalized()
        direction.y = amount_vertical
        body.add_outside_force(direction)


func _on_body_entered(body:Node3D):
    # Stop bullets from passing through
    if(body is Bullet):
        body.queue_free()
        
    super._on_body_entered(body)
    
	# Crazy knockback formula where knockback diminishes with the square of distance
    var dist = initial_player_pos.distance_to(body.global_position)
    var knockback_amount = (100 - (dist * 5))
    knockback_body(body, knockback_amount, 1)


