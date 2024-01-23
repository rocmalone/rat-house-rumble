extends Label

func _on_health_component_health_changed(_old_health, new_health):
	text = str(new_health)