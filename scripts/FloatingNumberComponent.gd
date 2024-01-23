extends RigidBody3D
class_name FloatingNumber


var color : Color = Color(1.0, 1.0, 1.0, 1.0)

@onready var label : Label3D = $Label3D
var original_pixel_size

var fade_timer : float = 0
var label_text : String

@export var fade_time : float = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	linear_velocity = Vector3(randf_range(-1, 1), randf_range(2,4), randf_range(-1, 1))
	label.text = label_text
	original_pixel_size = label.pixel_size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	fade_timer += delta
	var relative_fade = lerp(1, 0, fade_timer / fade_time)
	if(relative_fade > 1):
		queue_free()

	label.modulate.a = relative_fade
	label.outline_modulate.a = relative_fade
	label.pixel_size = original_pixel_size * relative_fade
	
