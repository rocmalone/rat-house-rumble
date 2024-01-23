extends TextureProgressBar

@export var UI_AnimationPlayer : AnimationPlayer

func _on_visual_hand_component_current_item_changed_ammo(new_ammo, max_ammo):
	max_value = max_ammo;
	value = new_ammo;
	UI_AnimationPlayer.play("AmmoJiggle")
	
