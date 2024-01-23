extends HBoxContainer


@onready var initial_value = $MarginContainer/HSlider.value
# Called when the node enters the scene tree for the first time.
func _ready():
	AudioServer.set_bus_volume_db(0, linear_to_db(initial_value))


func _on_h_slider_value_changed(value:float):
	AudioServer.set_bus_volume_db(0, linear_to_db(value))
	$ValueLabel.text = str(round(value * 100))
