extends Label

@export var crawl_interval_sec = 1
var time = 0
var randnum = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	if(time > randnum):
		randnum = randf_range(0.1, 0.5)
		time = 0
		uppercase = !uppercase
	
