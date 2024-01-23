extends Button

@export var goToUI : Control

func _on_pressed():
	get_parent().hide()
	goToUI.show()
	goToUI.get_child(0).grab_focus()

func _process(_delta):
	if(get_parent().visible and Input.is_action_just_pressed("ui_cancel")):
		_on_pressed()
