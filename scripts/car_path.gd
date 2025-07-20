extends Path2D

# In your script, assuming you have a Path2D named "path_node" and a scene to instantiate named "object_scene"
var object_scene = preload("res://scenes/car.tscn") # Replace with your scene path

@onready var path_follow = $PathFollow2D;

func _ready():
	var object_instance = object_scene.instantiate()
	path_follow.add_child(object_instance)
	# You can also set initial position here if needed
	start_follow_path(object_instance)

func start_follow_path(object_node):
	var tween = create_tween()
	tween.tween_property(path_follow, "progress_ratio", 1.0, 10.0) # Move to end in 5 seconds
	tween.play()
	# You can connect signals for completion or other events
	tween.finished.connect(func():
		print("Path following complete")
		# Optionally remove the object or reset the path
		object_node.queue_free()
		# path_follow.progress_ratio = 0.0
	)
