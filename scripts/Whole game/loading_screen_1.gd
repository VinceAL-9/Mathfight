extends CanvasLayer

@export_file("*.tscn") var next_scene_path: String
@onready var transition = $Control/Transition

func _ready():
	ResourceLoader.load_threaded_request(next_scene_path)
	
func _process(_delta):
	if ResourceLoader.load_threaded_get_status(next_scene_path) == ResourceLoader.THREAD_LOAD_LOADED:
		set_process(false)
		transition.play("fade_in")
		await get_tree().create_timer(1.5).timeout
		var new_scene: PackedScene = ResourceLoader.load_threaded_get(next_scene_path)
		transition.play("fade_out")
		await get_tree().create_timer(1).timeout
		get_tree().change_scene_to_packed(new_scene)
		 
	
