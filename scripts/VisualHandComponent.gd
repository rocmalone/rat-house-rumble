extends Node3D
class_name VisualHandComponent

signal current_item_changed_ammo(new_ammo : int, max_ammo : int)

var current_item : Item = null

# Activate currently held item
func activate(device_id : int):
	if current_item and (current_item.ammo > 0):
		if current_item.activate(device_id):
			current_item_changed_ammo.emit(current_item.ammo, current_item.max_ammo)
	elif current_item and current_item.ammo <= 1:
		drop_items()

func swap_item(itemResource : Resource) -> bool:
	# If holding something
	if(current_item):
		# Check if already holding the item, if so refill ammo if possible
		if(itemResource.resource_path == current_item.resource_path):
			# print_debug("SAME ITEM AS CARRIED")
			if(current_item.ammo < current_item.max_ammo):
				current_item.ammo = current_item.max_ammo
				current_item_changed_ammo.emit(current_item.ammo, current_item.max_ammo)
				return true
			return false
		# If not switch the items
		else:
			current_item.queue_free()
			current_item = itemResource.instantiate()
			add_child(current_item)
			# Update ammo counter
			current_item_changed_ammo.emit(current_item.ammo, current_item.max_ammo)
			return true
	# Otherwise, we must not be holding anything and can pick it up
	current_item = itemResource.instantiate()
	# Update ammo counter
	current_item_changed_ammo.emit(current_item.ammo, current_item.max_ammo)
	add_child(current_item)
	return true

func drop_items():
	if(current_item):
		current_item.queue_free()
		current_item = null

# Called when the node enters the scene tree for the first time.
func _ready():
	if get_child_count() > 0:
		if get_child(0) is Item:
			current_item = get_child(0)

	# This code has to do with showing the weapon in the hand of the user to other players
	# if(get_child(0).is_in_group("ITEM")):
	# 	rightHandMeshInstance3D.set_mesh(get_child(0).get_mesh())
	# 	rightHandMeshInstance3D.scale = get_child(0).scale/(rightHandMeshInstance3D.get_parent().get_parent().get_parent().scale)
	# 	print_debug("NEW SCALE IS: ", rightHandMeshInstance3D.scale
