extends Control

class_name PlayerJoinController

@export var device : int
@onready var pressAToJoinComponent = $PressAToJoin

@onready var playerSelectComponent = $PlayerSelectComponent

@onready var input_suffix = "_device_" + str(device)

enum STATE {PRESS_TO_JOIN, CHARACTER_SELECT, LOCKED_IN}
@export var state = STATE.PRESS_TO_JOIN

const JOY_DEADZONE = 0.2

func _clear_children():
	for child in get_children():
		child.queue_free()


func _process(_delta):
	if(state == STATE.PRESS_TO_JOIN):
		# Enter character select state
		if(Input.is_action_just_pressed("jump" + input_suffix) and !Global.inMenu):
			state = STATE.CHARACTER_SELECT
			playerSelectComponent.show()
			pressAToJoinComponent.hide()
	
	elif(state == STATE.CHARACTER_SELECT):
		# Return to press to join state
		if(Input.is_action_just_pressed("sprint" + input_suffix) and !Global.inMenu):
			playerSelectComponent.hide()
			pressAToJoinComponent.show()

			state = STATE.PRESS_TO_JOIN

		if(Input.is_action_just_pressed("ui_left" + input_suffix) and !Global.inMenu):
			playerSelectComponent.previous()
		elif(Input.is_action_just_pressed("ui_right" + input_suffix) and !Global.inMenu):
			playerSelectComponent.next()

		# Go to locked in state
		elif(Input.is_action_just_pressed("jump" + input_suffix) and !Global.inMenu):
			# .lock_in() returns true if successful, false if char is selected by another player
			if(playerSelectComponent.lock_in()):
				state = STATE.LOCKED_IN
	
	elif(state == STATE.LOCKED_IN):
		# Return to selection state
		if(Input.is_action_just_pressed("sprint" + input_suffix) and !Global.inMenu):
			playerSelectComponent.lock_out()
			state = STATE.CHARACTER_SELECT

	

		



