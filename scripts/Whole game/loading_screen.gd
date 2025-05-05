extends CanvasLayer

@export_file("*.tscn") var next_scene_path: String # makes it that its posssible to pick a scene file
@onready var transition = $Control/Transition # variable for transition

func _ready():
	ResourceLoader.load_threaded_request(next_scene_path) # loads the picked scene 
	
func _process(_delta):
	if ResourceLoader.load_threaded_get_status(next_scene_path) == ResourceLoader.THREAD_LOAD_LOADED: # checks if the scene has loaded
		set_process(false) # sets to false just in case to avoid the function getting called more than once 
		transition.play("fade_in") # plays transition
		await get_tree().create_timer(1).timeout # 1 second delay for transition
		var new_scene: PackedScene = ResourceLoader.load_threaded_get(next_scene_path) # resource loader stores the scene into a packed scene variable 
		transition.play("fade_out") # plays transition
		await get_tree().create_timer(1).timeout # 1 second delay for transition
		get_tree().change_scene_to_packed(new_scene) # goes to the scene
		 
