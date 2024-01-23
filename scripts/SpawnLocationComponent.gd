extends Node3D

class_name SpawnLocationComponent

func _ready():
	if(!Global.testing):
		$MeshInstance3D.hide()

