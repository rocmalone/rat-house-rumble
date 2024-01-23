extends Node

# Debug variable, true = default.tscn
var testing = false

var baseX = 1152
var baseY = 648

var deviceInputManager = DeviceInputManager.new()
var num_players = 2
var score = [0,0,0,0]
var kills = [0,0,0,0]
var deaths = [0,0,0,0]
var player_name_dict = {
	0:"",
	1:"",
	2:"",
	3:"",
	4:"Balinese Puppet King"
}

var player_joy_sensitivity = [0.08, 0.08, 0.08, 0.08]
var player_joy_sensitivity_max = 0.2

var inMenu = false

# Explore mode or split screen rumble
var explore = false

# var playerViewportRefs = [null,null,null,null]

var player_colors = [Color(235, 0, 27, 1), Color(0, 136, 237, 1), Color(2, 180, 0, 1), Color(243, 246, 5, 1)]

var playerObjectRefs = [null,null,null,null]

var player_character_choices = [-1,-1,-1,-1]

signal add_killfeed_item(killerID : int, killedID : int, weapon : String)

var path_to_map : String = "res://Levels/PrimaryMap/PrimaryMap.tscn"

var num_pickups = 0
const MAX_PICKUPS = 10


# Called when the node enters the scene tree for the first time.
func _ready():
	print_debug("GLOBAL LOADED")
	# Create gamepad controls for up to four devices
	deviceInputManager.initialize(0)
	deviceInputManager.initialize(1)
	deviceInputManager.initialize(2)
	deviceInputManager.initialize(3)


# func _process(_delta):
# 	print_debug("GLOBAL PLAYER CHOICES",player_character_choices)

# func add_score(device_id : int, amount : int):
# 	pass

func add_kill(killer_device_id : int, killed_device_id : int, weapon_name : String):
	if(killer_device_id == killed_device_id or killer_device_id > 3):
		deaths[killed_device_id] += 1
	elif(killed_device_id == 4):
		# 50 score for BPK kill
		score[killer_device_id] += 50
	else:
		kills[killer_device_id] += 1
		score[killer_device_id] += 10
		deaths[killed_device_id] += 1
	add_killfeed_item.emit(killer_device_id, killed_device_id, weapon_name)


