extends Node3D
class_name HealthComponent

signal health_depleted(killer_device_id : int, weapon_name : String)
signal health_changed(old_health : int, new_health : int)
signal armor_changed(old_armor : int, new_armor : int)
signal health_set() # Signal for AnimationPlayer2D to play animation of egg frying

@export var max_health : int = 100
@export var health : int = 100
@export var max_armor : int = 200
@export var armor : int = 0

@export var invulnerable : bool = false

var floating_number = preload("res://Scenes/Components/FloatingNumberComponent.tscn")


func take_damage(amount : int, device_id : int, weapon_name : String):
	if(invulnerable):
		_create_floating_number(0)
		return
	_create_floating_number(amount)

	if(armor > 0):
		var old_armor = armor

		armor -= amount
		if(armor < 0):
			amount = abs(armor)
			armor = 0
			take_damage(amount, device_id, weapon_name)

		armor_changed.emit(old_armor, armor)
		return

	var old_health = health
	health -= amount
	health_changed.emit(old_health, health)
	
	if health <= 0:
		health_depleted.emit(device_id, weapon_name)
	# print_debug("Health Component: ", health, " remaining")

func take_healing(amount : int):
	var old_health = health
	health += amount
	clamp(health, 0, max_health)
	health_changed.emit(old_health, health)

func set_health(amount : int):
	var old_health = health
	health = amount
	health_changed.emit(old_health, health)
	health_set.emit()

func take_armor(amount : int):
	var old_armor = armor
	armor += amount
	clamp(armor, 0, max_armor)
	armor_changed.emit(old_armor, armor)

func set_invulnerable(b : bool):
	invulnerable = b


func _create_floating_number(number : int):
	var instance : FloatingNumber = floating_number.instantiate()
	instance.label_text = str(number)
	get_tree().get_root().add_child(instance)
	instance.global_position = global_position
