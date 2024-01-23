extends Node3D
class_name PickupSpawner

@export var respawnTime : float = 30
@export var respawnVariation : float = 15
@export var ignoreLimit : bool = false
@export var spawnScenes : Array[PackedScene]
@export var spawnWeights : Array[int]

var respawnCounter : float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(spawnScenes.size() == spawnWeights.size())
	if(!Global.testing):
		$MeshInstance3D.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	respawnCounter += delta
	# If time is right and we do not already have an item, spawn one
	if(respawnCounter > (respawnTime + randf_range(-respawnVariation, respawnVariation)) && get_child_count() == 0):
		print_debug("respawn triggered")
		print_debug("child_count ", get_child_count())
		if(Global.num_pickups < Global.MAX_PICKUPS || ignoreLimit):
			# Sum weights
			var totalWeights = spawnWeights.reduce(func(accum, number): return accum + number)
			for i in range(0, spawnScenes.size()):
				var rand = randi_range(0, totalWeights)
				if(rand < spawnWeights[i]):
					print_debug("trying to spawn ", spawnScenes[i].resource_name)
					var instance = spawnScenes[i].instantiate()
					add_child(instance)
					respawnCounter = 0
					return

