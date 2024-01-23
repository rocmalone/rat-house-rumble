extends Control

var title_screen_packed = preload("res://Levels/TitleScreen/TitleScreen.tscn")

# @onready var optionsMenu = get_tree().get_root().find_child("OptionsMenu", true)
@export var optionsMenu : Control


func _on_resume_button_pressed():
	hide()
	Global.inMenu = false


func _on_main_menu_button_pressed():
	$Stage1_VBoxContainer.hide()
	$Stage2_VBoxContainer.show()
	$Stage2_VBoxContainer/DeclineQuit.grab_focus()



func _on_confirm_quit_pressed():
	hide()
	Global.inMenu = false
	get_tree().root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	get_tree().change_scene_to_packed(title_screen_packed)

func _on_decline_quit_pressed():
	$Stage2_VBoxContainer.hide()
	$Stage1_VBoxContainer.show()
	$Stage1_VBoxContainer/ResumeButton.grab_focus()

func _process(_delta):

	if(Input.is_action_just_pressed("ui_cancel") and Global.inMenu):
		if($Stage2_VBoxContainer.visible):
			$Stage2_VBoxContainer.hide()
			$Stage1_VBoxContainer.show()
			$Stage1_VBoxContainer/ResumeButton.grab_focus()
		elif($Stage1_VBoxContainer.visible):
			_on_resume_button_pressed()
	elif(Input.is_action_just_pressed("start") and Global.inMenu):
		_on_resume_button_pressed()
	elif(Input.is_action_just_pressed("back") and Global.inMenu):
		_on_resume_button_pressed()
	elif(Input.is_action_just_pressed("start") and !Global.inMenu):
		show()
		$Stage1_VBoxContainer/ResumeButton.grab_focus()
		Global.inMenu = true



func _on_options_button_pressed():
	get_tree().root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	optionsMenu.show()


func _on_options_menu_options_menu_closed():
	$Stage1_VBoxContainer/ResumeButton.grab_focus()
