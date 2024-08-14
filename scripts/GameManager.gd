extends Node

signal score_changed(new_score)
signal lives_changed(new_lives)
signal level_changed(new_level)

var score = 0
var lives = 3
var current_level = 1
var total_levels = 10

func _ready():
	start_game()

func start_game():
	score = 0
	lives = 3
	current_level = 1
	emit_signal("score_changed", score)
	emit_signal("lives_changed", lives)
	emit_signal("level_changed", current_level)
	load_level(current_level)

func load_level(level_number):
	# Here you would load the appropriate level scene
	# For now, we'll just print a message
	print("Loading level ", level_number)
	emit_signal("level_changed", current_level)
	# You could also adjust difficulty here based on the level number

func increase_score(points):
	score += points
	emit_signal("score_changed", score)

func decrease_lives():
	lives -= 1
	emit_signal("lives_changed", lives)
	if lives <= 0:
		game_over()

func next_level():
	current_level += 1
	emit_signal("level_changed", current_level)
	if current_level > total_levels:
		game_won()
	else:
		load_level(current_level)

func game_over():
	print("Game Over!")
	# Here you would show the game over screen and handle restarting

func game_won():
	print("Congratulations! You've completed all levels!")
	# Here you would show the victory screen
