extends VBoxContainer

@onready var armorLabel = $ArmorLabel
@onready var healthLabel = $HealthLabel
@onready var ammoLabel = $AmmoLabel

# TODO - Healthbar smooth damage effect
func _on_health_component_health_changed(_old_health, new_health):
	healthLabel.text = "Health: " + str(new_health)

func _on_health_component_armor_changed(_old_armor, new_armor):
	armorLabel.text = "Armor: " + str(new_armor)

func _on_visual_hand_component_current_item_changed_ammo(new_ammo):
	ammoLabel.text = "Ammo: " + str(new_ammo)
