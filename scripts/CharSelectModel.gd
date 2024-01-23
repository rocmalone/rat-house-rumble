extends Node3D

@onready var animationPlayer = $AnimationPlayer
var locked_in
var _played_locked_in


@export var char_name : String
@export var char_info_ui : Control
@export var environment : Environment
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(!animationPlayer.is_playing() && !locked_in):
		animationPlayer.play("Dance", 3.0)
	elif(locked_in && !_played_locked_in):
		_played_locked_in = true
		animationPlayer.stop()
		animationPlayer.play("Celebrate")
	elif(!locked_in && _played_locked_in):
		_played_locked_in = false
