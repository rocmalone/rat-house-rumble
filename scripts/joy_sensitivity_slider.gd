extends HBoxContainer

@export var device : int = 0

@onready var hSlider : HSlider = $MarginContainer/HSlider

# Called when the node enters the scene tree for the first time.
func _ready():
	# hSlider.value = Global.player_joy_sensitivity[]
	$ValueLabel.text = str(hSlider.value)
	labelUpdate()
	hSlider.value = Global.player_joy_sensitivity[device]



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	labelUpdate()

	
func labelUpdate():
	if(Global.player_name_dict[device] == ""):
		$DeviceLabel.text = "Device " + str(device)
	else:
		$DeviceLabel.text = "Device " + str(device) + "\n(" + Global.player_name_dict[device] + ")"
		$DeviceLabel.add_theme_color_override("font_color", Global.player_colors[device])
	

func _on_h_slider_value_changed(value : float):
	Global.player_joy_sensitivity[device] = value
	$ValueLabel.text = str(hSlider.value)
	
