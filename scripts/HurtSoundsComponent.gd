extends AudioStreamPlayer
class_name HurtSoundsComponent

@export var sounds_folder_path : String
var new_audio_streams_array = []

@onready var audioStreamRandomizer : AudioStreamRandomizer = stream

# Add all the MP3 files in the specified hurtSoundsFolderPath to the AudioStreamRandomizer
# attached to this node.
func _ready():
	var dir = DirAccess.open(sounds_folder_path)
	if dir:
		# Note this array contains non-.mp3 files such as .import files
		var file_names_array = dir.get_files()

		print_debug("FILE NAMES ARRAY:\n", file_names_array)
		# Counter variable which only increments with .mp3 files. Used to index stream pool of AudioStreamRandomizer
		var i = 0
		for file_name in file_names_array:
			if file_name.ends_with(".mp3"):
				var file_path = sounds_folder_path + file_name
				var new_audio_stream = load(file_path)
				audioStreamRandomizer.add_stream(i, new_audio_stream, 1)
				# print_debug("LOADED AND ADDED ", file_path, " with i = ", i)
				i += 1
		# print_debug("COULD NOT FIND HURT SOUNDS FOLDER")

	# print_debug("STREAMS COUNT: ", audioStreamRandomizer.get_streams_count())


