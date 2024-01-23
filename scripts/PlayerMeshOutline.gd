extends MeshInstance3D

@export var player : Player
# var outline_mat = load("res://Materials/player_outline_material.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	var device : int = player.device
	var mat = get_active_material(0)
	var outline = StandardMaterial3D.new()
	outline.albedo_color = Global.player_colors[device]
	outline.grow = true
	outline.grow_amount = 0.6
	outline.cull_mode = 1 # FRONT
	mat.next_pass = outline