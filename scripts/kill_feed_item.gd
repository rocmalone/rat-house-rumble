extends HBoxContainer
class_name KillFeedItem

var killer : String
var killed : String
var weapon : String

var killer_color : Color
var killed_color : Color

# Called when the node enters the scene tree for the first time.
func _ready():
	$KillerLabel.text = killer
	$KillerLabel.add_theme_color_override("font_color", killer_color)
	$KilledLabel.text = killed
	$KilledLabel.add_theme_color_override("font_color", killed_color)
	if(weapon == ""):
		$WeaponLabel.hide()
		$Label2.hide()
	else:
		$WeaponLabel.text = weapon
