extends VBoxContainer

@export var next_ui : Control
@export var options_menu : Control
@export var credits_ui: Control
@export var titleTextureRect : TextureRect

# Bit of a hack to make sure the play button gets focus
var hasPlayButtonRecievedFocus = false

func _process(_delta):
	if(!hasPlayButtonRecievedFocus):
		get_child(0).grab_focus()



func _on_play_button_pressed():
	hide()
	next_ui.show()
	next_ui.get_child(0).grab_focus()



func _on_quit_button_pressed():
	get_tree().quit()

func _on_play_button_focus_entered():
	hasPlayButtonRecievedFocus = true


func _on_options_button_pressed():
	get_tree().root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	options_menu.show()


func _on_options_menu_options_menu_closed():
	get_child(0).grab_focus()


func _on_credits_button_pressed():
	hide()
	titleTextureRect.hide()
	credits_ui.show()
	credits_ui.get_child(0).grab_focus()