extends CanvasLayer

@onready var label_score = $LabelScore
@onready var health_bar = $HealthProgressBar

@onready var message_popup = $MessagePopup
@onready var label_win = $MessagePopup/LabelWin
@onready var label_lose = $MessagePopup/LabelLose
@onready var message_popup_level = $MessagePopupLevel
@onready var label_level = $MessagePopupLevel/LabelLevel

@onready var level_timer = $LevelTimer 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_game_manager_score_changed(new_score):
	if is_instance_valid(label_score) and label_score != null:
		label_score.text = "Score %d" % new_score
	else:
		print("Warning: label_score is not initialized or is null")
		




func _on_game_manager_lives_changed(new_lives):
	if is_instance_valid(health_bar) and health_bar != null:
		health_bar.value = new_lives * 10
	else:
		print("Warning: health_bar is not initialized or is null")


func _on_game_manager_play_finished(win_lose):
	message_popup.visible = true
	if win_lose == 0:
		label_lose.visible = true
	elif win_lose == 1: 
		label_win.visible = true


func _on_game_manager_level_changed(new_level):
	 # Update the label text
	label_level.text = "Level " + str(new_level)
	
	# Show the message popup
	message_popup_level.visible = true
	
	# Start the timer
	level_timer.start(1.0)  # 1 second duration
	
func _on_level_timer_timeout():
	# Hide the message popup after the timer expires
	message_popup_level.visible = false
