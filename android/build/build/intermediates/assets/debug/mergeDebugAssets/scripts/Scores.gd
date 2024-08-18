extends Control

@onready var label_score_val1 = $TextureRect/ScoreLabelVal1
@onready var label_score_val2 = $TextureRect/ScoreLabelVal2
@onready var label_score_val3 = $TextureRect/ScoreLabelVal3
@onready var label_score_val4 = $TextureRect/ScoreLabelVal4


func _ready():
	display_top_scores()

func display_top_scores():
	# Ensure scores are loaded
	GlobalGameManager.load_scores()
	GlobalGameManager.show_and_print_leaderboards()
	
	# Get the scores array
	var scores = GlobalGameManager.scores
	
	# Create an array of our score labels
	var score_labels = [label_score_val1, label_score_val2, label_score_val3, label_score_val4]
	
	# Display up to 4 top scores
	for i in range(4):
		if i < scores.size():
			score_labels[i].text = str(scores[i])
		else:
			score_labels[i].text = "-"

# Optionally, add a method to update scores if needed
func update_scores():
	display_top_scores()


func _on_texture_button_pressed():
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")
