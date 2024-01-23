extends Control

@export var mainMenu : Control
@export var titleTextureRect : TextureRect

func _process(_delta):
	if(visible and Input.is_action_just_pressed("ui_cancel")):
		_on_back_from_credits_pressed()

func _on_back_from_credits_pressed():
	hide()
	titleTextureRect.show()
	mainMenu.show()
	mainMenu.get_child(0).grab_focus()

