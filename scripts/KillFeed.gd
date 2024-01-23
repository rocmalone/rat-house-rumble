extends VBoxContainer

@onready var labelResource = preload("res://Scenes/UI/kill_feed_item.tscn")
var allEntryID : Array = []
var currentlyDisplayedEntryID : Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.connect("add_killfeed_item", _on_add_killfeed_item)


func _on_add_killfeed_item(killer : int, killed : int, weapon : String):
	# print_debug(str(killer), str(killed), weapon)
	# 0 - 3 are players
	if(killer < 4 and killed < 4):
		var instance : KillFeedItem = labelResource.instantiate()
		instance.killer = Global.player_name_dict[killer]
		instance.killed = Global.player_name_dict[killed]
		instance.killer_color = Global.player_colors[killer]
		instance.killed_color = Global.player_colors[killed]
		instance.weapon = weapon
		add_child(instance)
	elif(killer >= 4 and killed < 4):
		var instance : KillFeedItem = labelResource.instantiate()
		instance.killer = Global.player_name_dict[killer]
		instance.killed = Global.player_name_dict[killed]
		instance.killer_color = Color(255, 86, 0)
		instance.killed_color = Global.player_colors[killed]
		instance.weapon = weapon
		add_child(instance)
	elif(killer < 4 and killed >= 4):
		var instance : KillFeedItem = labelResource.instantiate()
		instance.killer = Global.player_name_dict[killer]
		instance.killed = Global.player_name_dict[killed]
		instance.killer_color = Global.player_colors[killer]
		instance.killed_color = Color(255, 86, 0)
		instance.weapon = weapon
		add_child(instance)

	



			
