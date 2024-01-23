extends VBoxContainer
class_name ScoreboardCol

var player_name : String
var kills : String
var deaths : String
var score : String

@export var type = "players"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if(!visible):
		return
	match(type):
		"players":
			$Row0/Label.text = "Players"
			for i in range(0, Global.num_players):
				var l = get_node("Row" + str(i+1) + "/Label")
				l.text = str(Global.player_name_dict[i])
		"kills":
			$Row0/Label.text = "Kills"
			for i in range(0, Global.num_players):
				var l = get_node("Row" + str(i+1) + "/Label")
				l.text = str(Global.kills[i])
		"deaths":
			$Row0/Label.text = "Deaths"
			for i in range(0, Global.num_players):
				var l = get_node("Row" + str(i+1) + "/Label")
				l.text = str(Global.deaths[i])
		"score":
			$Row0/Label.text = "Score"
			for i in range(0, Global.num_players):
				var l = get_node("Row" + str(i+1) + "/Label")
				l.text = str(Global.score[i])
