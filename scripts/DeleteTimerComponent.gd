extends Node

@export var time_until_delete : float = 1.0
@export var node_to_delete : Node
var timer : float = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	timer += delta
	if(timer > time_until_delete):
		if(node_to_delete):
			node_to_delete.queue_free()
			queue_free()
		else:
			get_parent().queue_free()
