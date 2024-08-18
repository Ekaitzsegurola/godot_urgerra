extends Control

const MainScene = preload("res://scenes/Main.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalGameManager.set_bgm("MainMenu", 1)
	print("aaaa")
	if GpgsManager.is_gpgs_available():
		GpgsManager.play_games_services.signIn()
		# Connect the signals for sign-in success and failure
		GpgsManager.play_games_services.connect("_on_sign_in_success", Callable(self, "_on_sign_in_success"))
		GpgsManager.play_games_services.connect("_on_sign_in_failed", Callable(self, "_on_sign_in_failed"))
		GpgsManager.play_games_services.connect("_on_leaderboard_score_submitted", Callable(self, "_on_leaderboard_score_submitted")) # leaderboard_id: String
		GpgsManager.play_games_services.connect("_on_leaderboard_score_submitting_failed", Callable(self, "_on_leaderboard_score_submitting_failed")) # leaderboard_id: String
	else:
		print("Google Play Games Services is not available")

func _on_sign_in_success(userProfile_json: String) -> void:
	print("Sign-in successful. Raw JSON:", userProfile_json)
	var json = JSON.new()
	var error = json.parse(userProfile_json)
	if error == OK:
		var userProfile = json.get_data()
		if typeof(userProfile) == TYPE_DICTIONARY:
			print("Display Name:", userProfile.get("displayName", "N/A"))
			print("Email:", userProfile.get("email", "N/A"))
			print("Token:", userProfile.get("token", "N/A"))
			print("ID:", userProfile.get("id", "N/A"))
		else:
			print("Parsed JSON is not a dictionary")
	else:
		print("JSON Parse Error: ", json.get_error_message(), " at line ", json.get_error_line())

func _on_sign_in_failed(error_code: int) -> void:
	print("Sign-in failed with error code: ", error_code)


func _on_start_button_pressed():
	# Change to the Main scene
	get_tree().change_scene_to_packed(MainScene)

func _on_exit_button_pressed():
	# Quit the game
	get_tree().quit()


func _on_record_button_pressed():
	# Change to the Scores
	get_tree().change_scene_to_file("res://scenes/Scores.tscn")
