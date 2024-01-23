extends Button

@export var goToUI : Control

func _on_pressed():
	print_debug("SELECTED: FREE FOR ALL")
	get_parent().hide()
	goToUI.show()
	goToUI.get_child(0).grab_focus()