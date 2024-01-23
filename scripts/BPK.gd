extends CharacterBody3D

@onready var nav_agent : NavigationAgent3D = $NavigationAgent3D

var SPEED = 7.5
var AGGRO_RANGE_SQUARED = 600

var REAGGRO_TIME = 0.2
var reaggro_timer = 0.0

var ATTACK_COOLDOWN = 0.8
var attack_timer = 0.0

var KNOCKBACK = 90
var DAMAGE = 77

@onready var current_location = global_transform.origin
@onready var spawn_location = global_transform.origin
@onready var animation_player = $AnimationPlayer
@onready var health_bar : Sprite3D = $mesh/HealthBar
@onready var health_bar_max_scale : float = health_bar.scale.x
@onready var health_component : HealthComponent = $HealthComponent

var player_to_attack : Player = null
var players_in_attack_zone : Array[Player] = []
var can_move = true

func _physics_process(delta):
	current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * SPEED

	velocity = new_velocity
	move_and_slide()

	reaggro_timer += delta
	attack_timer += delta

	# Prevent movement if health depleted
	if(!can_move):
		nav_agent.target_position = current_location

	var closest_player_location = null
	if(reaggro_timer > REAGGRO_TIME and can_move):
		reaggro_timer = 0
		# Loop through possible player locations
		var players = get_tree().get_nodes_in_group("Players")

		for player in players:
			var dist_sq_to_this_player = current_location.distance_squared_to(player.global_transform.origin)

			if(dist_sq_to_this_player < AGGRO_RANGE_SQUARED):
				if(player.global_transform.origin.y > 11):
					if((closest_player_location == null) or (dist_sq_to_this_player < current_location.distance_squared_to(closest_player_location))):
						closest_player_location = player.global_transform.origin
		
	if closest_player_location != null and can_move:
		# Prevent jittering
		if(nav_agent.target_position != closest_player_location):
			nav_agent.target_position = closest_player_location
		# if(nav_agent.target_position.distance_squared_to(closest_player_location) > 8):
			
		look_at(closest_player_location)

	if(attack_timer > ATTACK_COOLDOWN and can_move):
		for player in players_in_attack_zone:
			attack(player)
		attack_timer = 0




	
	

func attack(player : Player):
	var knockback_vector = (current_location - player.global_transform.origin).normalized() * KNOCKBACK
	knockback_vector.y = 25

	player.add_outside_force(knockback_vector)
	player.healthComponent.take_damage(DAMAGE, 4, "")
	animation_player.play("Attack")

func _on_hurt_box_body_entered(body):
	if(body is Player):
		players_in_attack_zone.push_back(body)

func _on_hurt_box_body_exited(body):
	if(body is Player):
		players_in_attack_zone = players_in_attack_zone.filter(func(pl : Player): return pl != body)



func _on_health_component_health_changed(_old_health, new_health):
	# Update health bar
	var new_health_bar_scale = (float(new_health) / float(health_component.max_health)) * health_bar_max_scale
	health_bar.scale.x = new_health_bar_scale


func _on_health_component_health_depleted(killer_device_id, weapon_name):
	can_move = false
	health_component.invulnerable = true
	$mesh.transparency = 0.6
	Global.add_kill(killer_device_id, 4, weapon_name)
	await get_tree().create_timer(10).timeout
	health_component.set_health(health_component.max_health)
	can_move = true
	health_component.invulnerable = false
	$mesh.transparency = 0


