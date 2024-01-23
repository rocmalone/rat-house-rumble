extends Node3D

var target_scene_path = Global.path_to_map
var progress : Array[float]

var loading_status : int

@onready var progress_bar = $Control/ProgressBar
@onready var texture_rect = $Control/TextureRect

var slideshow_time : float = 0
var slideshow_next : float = 10
var image_queue : Array[String]
var images_folder = "res://Assets/LoadingScreens"
var last_five_indexes = [null, null, null, null, null]

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS

	# Asynchronously load the map
	ResourceLoader.load_threaded_request(target_scene_path, "", true)

	# Load all the image files
	var dir = DirAccess.open(images_folder)
	if dir:
		# Note this array contains non-.mp3 files such as .import files
		var file_names_array = dir.get_files()

		# print_debug("FILE NAMES ARRAY:\n", file_names_array)
		for file_name in file_names_array:
			if file_name.ends_with(".png") or file_name.ends_with(".jpg"):
				var file_path = images_folder + "/" + file_name
				image_queue.push_back(file_path)

	var next_image_index = randi_range(0, image_queue.size() - 1)
	var next_image_path = image_queue[next_image_index]
	texture_rect.texture = load(next_image_path)
	last_five_indexes.pop_front()
	last_five_indexes.push_back(next_image_index)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	loading_status = ResourceLoader.load_threaded_get_status(target_scene_path, progress)

	match loading_status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			progress_bar.value = progress[0] * 100
		ResourceLoader.THREAD_LOAD_LOADED:
			get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(target_scene_path))
		ResourceLoader.THREAD_LOAD_FAILED:
			print("Error occured while loading map ...")

	slideshow_time += delta
	if slideshow_time >= slideshow_next:
		# Pick a random image from the queue
		var next_image_index = randi_range(0, image_queue.size() - 1)
		if(next_image_index not in last_five_indexes):
			slideshow_time = 0
			var next_image_path = image_queue[next_image_index]
			texture_rect.texture = load(next_image_path)
			last_five_indexes.pop_front()
			last_five_indexes.push_back(next_image_index)
		# If the image was in the last 5 images, wait till the next frame and try again
		


