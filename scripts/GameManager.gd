extends Node

@onready var timer_level = $TimerLevel

signal score_changed(new_score)
signal lives_changed(new_lives)
signal level_changed(new_level)
signal play_finished(win_lose)

var score = 0
var lives = 3
var current_level = 1
var total_levels = 10


func _ready():
	GlobalGameManager.set_bgm("Main", 1)
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
	play_finished.emit(0)
	print("Game Over!")
	# Here you would show the game over screen and handle restarting

func game_won():
	play_finished.emit(1)
	print("Congratulations! You've completed all levels!")
	# Here you would show the victory screen

func _on_replay_button_button_down():
	GlobalGameManager.save_score(score)
	GlobalGameManager.reload_scene()


func _on_timer_level_timeout():
	next_level()
	timer_level.wait_time = 60
	timer_level.one_shot = true
