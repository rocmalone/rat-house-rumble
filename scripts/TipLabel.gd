extends Label

var tips = ["bunny hop to gain momentum", "there's a rocket launcher in the attic", "press down right stick to aim your weapon", "your spin move (y-button) makes you no-clip"]

var timer = 0
@export var time_threshold = 10
@onready var last_index = randi_range(0, tips.size() - 1)

# Called when the node enters the scene tree for the first time.
func _ready():
	text = "Tip: " + tips[last_index]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	if(timer > time_threshold):
		var random = randi_range(0, tips.size() - 1)
		if(random != last_index):
			text = "Tip: " + tips[random]
			last_index = random
			timer = 0

