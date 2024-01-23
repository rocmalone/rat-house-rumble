extends Node3D
class_name Item

@export var itemName : String
@export var meshInstance3D : MeshInstance3D
@export var ammo : int
@export var max_ammo : int
@export var resource_path : String
@export var hand_position : Vector3
@export var hand_rotation_deg : Vector3
var device : int

func activate(device_id : int):
    device = device_id

func get_mesh():
    return meshInstance3D.mesh

func _ready():
    if(hand_position):
        position = hand_position
    if(hand_rotation_deg):
        rotation_degrees = hand_rotation_deg