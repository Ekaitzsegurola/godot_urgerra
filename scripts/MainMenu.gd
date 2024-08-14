extends Control

const MainScene = preload("res://scenes/Main.tscn")
const ScoresScene = preload("res://scenes/Scores.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_start_button_pressed():
	# Change to the Main scene
	get_tree().change_scene_to_packed(MainScene)

func _on_exit_button_pressed():
	# Quit the game
	get_tree().quit()


func _on_record_button_pressed():
	# Change to the Scores
	get_tree().change_scene_to_packed(ScoresScene)
