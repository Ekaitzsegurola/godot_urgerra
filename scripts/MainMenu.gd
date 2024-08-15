extends Control

const MainScene = preload("res://scenes/Main.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalGameManager.set_bgm("MainMenu", 1)


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
	get_tree().change_scene_to_file("res://scenes/Scores.tscn")
