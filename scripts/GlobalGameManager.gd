extends Node

const main_ost = preload("res://audio/Galactic Adventure.mp3")
const level1_ost = preload("res://audio/GalacticOdyssey.mp3")

@onready var bgm_stream_player = $BMGStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func set_bgm(scene_name: String, level: int = 0):
	var bgm_to_play

	match scene_name:
		"Scores":
			bgm_to_play = main_ost
		"MainMenu":
			bgm_to_play = main_ost
		"Main":
			if level == 1:
				bgm_to_play = level1_ost
			else:
				bgm_to_play = level1_ost  # Default to main OST for other levels
		_:
			bgm_to_play = main_ost  # Default to main OST for unknown scenes

	if bgm_stream_player.stream != bgm_to_play:
		bgm_stream_player.stop()
		bgm_stream_player.stream = bgm_to_play
		bgm_stream_player.play()
		
const SAVE_FILE = "user://scores.save"
var scores = []

func save_score(new_score):
	# Load existing scores
	load_scores()
	
	# Add new score
	scores.append(new_score)
	
	# Sort scores in descending order
	scores.sort()
	scores.reverse()
	
	# Keep only top 10 scores
	scores = scores.slice(0, 10)
	
	# Save to file
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	if file:
		file.store_var(scores)
		file.close()
	else:
		print("Error: Couldn't open file for writing.")

func load_scores():
	if FileAccess.file_exists(SAVE_FILE):
		var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
		if file:
			scores = file.get_var()
			file.close()
		else:
			print("Error: Couldn't open file for reading.")
	else:
		scores = []

func reload_scene():
	# Get the current scene
	var current_scene = get_tree().current_scene
	
	# Get the current scene's filename
	var scene_file = current_scene.scene_file_path
	
	# Change scene to itself (effectively reloading it)
	get_tree().change_scene_to_file(scene_file)

# Example usage
func _on_game_over(final_score):
	save_score(final_score)
	reload_scene()
	
	
func print_scores():
	if scores.is_empty():
		print("No scores saved yet.")
	else:
		print("High Scores:")
		for i in range(scores.size()):
			print("%d. %d" % [i + 1, scores[i]])
