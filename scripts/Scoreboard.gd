extends Control
class_name Scoreboard

@onready var scoreboardCol = load("res://Scenes/UI/scoreboard_col.tscn")
@export var playerNode : Player 

# Called when the node enters the scene tree for the first time.
func _ready():
	var playersInst = scoreboardCol.instantiate()
	playersInst.type = "players"
	var killsInst = scoreboardCol.instantiate()
	killsInst.type = "kills"
	var deathsInst = scoreboardCol.instantiate()
	deathsInst.type = "deaths"
	var scoreInst = scoreboardCol.instantiate()
	scoreInst.type = "score"

func _process(_delta):
	if(visible):
		var deviceId = playerNode.device
		if(Global.playerObjectRefs[deviceId]):
			var playerViewport = Global.playerObjectRefs[deviceId].get_parent()
			var scaleX = playerViewport.size.x / Global.baseX
			var scaleY = playerViewport.size.y / Global.baseY

			if(scaleX != 0 and scaleY != 0):
				# If widescreen
				if((scaleX / scaleY) > (16.0/9.0 + 0.1)):
					scale.x = scaleX / 2
				else:
					scale.x = scaleX
					scale.y = scaleY / 1.5
			

			position.x = 0
			position.y = 0


		# $ColorRect.size.x = Global.playerViewportRefs[deviceId].size.x * 0.8
		# $ColorRect.size.x = Global.playerViewportRefs[deviceId].size.y * 0.8
		# $ColorRect.position.x = Global.playerViewportRefs[deviceId].size.x * (0.2)
		# $ColorRect.position.y = Global.playerViewportRefs[deviceId].size.y * (0.2)


