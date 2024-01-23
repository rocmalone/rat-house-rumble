extends Control

@export var backToTitleScreen : bool
@export var backToStartMenu : bool

var isVisibleLastFrame : bool = false
signal optionsMenuClosed()

func _process(_delta):
	if(visible and !isVisibleLastFrame):
		$Stage1_VBoxContainer/MarginContainer/BackButton.grab_focus()
	if(!visible and isVisibleLastFrame):
		optionsMenuClosed.emit()

	isVisibleLastFrame = visible

	if(Input.is_action_just_pressed("ui_cancel")):
		if($Stage1_VBoxContainer.visible):
			_on_back_button_pressed()
		else:
			_on_back_from_controls_button_pressed()


func _on_back_button_pressed():
	if backToTitleScreen:
		get_tree().root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	elif backToStartMenu:
		get_tree().root.content_scale_mode = Window.CONTENT_SCALE_MODE_DISABLED
	
	hide()


func _on_controls_button_pressed():
	$Stage1_VBoxContainer.hide()
	$Stage2_VBoxContainer.show()
	$Stage2_VBoxContainer/MarginContainer5/BackFromControlsButton.grab_focus()


func _on_back_from_controls_button_pressed():
	$Stage2_VBoxContainer.hide()
	$Stage1_VBoxContainer.show()
	$Stage1_VBoxContainer/MarginContainer/BackButton.grab_focus()
