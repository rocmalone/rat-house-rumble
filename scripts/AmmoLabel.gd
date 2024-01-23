extends Label


func _on_visual_hand_component_current_item_changed_ammo(new_ammo, _max_ammo):
	text = str(new_ammo);
