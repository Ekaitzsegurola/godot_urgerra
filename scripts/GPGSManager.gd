extends Node

var play_games_services

func _ready():
	initialize_gpgs()

func initialize_gpgs():
	# Check if plugin was added to the project
	if Engine.has_singleton("GodotPlayGamesServices"):
		play_games_services = Engine.get_singleton("GodotPlayGamesServices")
		
		# Initialize plugin
		var show_popups := true
		var request_email := true
		var request_profile := true
		var request_token := "629068067326-n9sd8li43c04g0q1t8dgom2d8smlg8s0.apps.googleusercontent.com"  # Replace with your actual Client ID

		play_games_services.init(show_popups, request_email, request_profile, request_token)

		# Connect callbacks
		play_games_services.connect("_on_sign_in_success", Callable(self, "_on_sign_in_success"))
		play_games_services.connect("_on_sign_in_failed", Callable(self, "_on_sign_in_failed"))
		play_games_services.connect("_on_sign_out_success", Callable(self, "_on_sign_out_success"))
		play_games_services.connect("_on_sign_out_failed", Callable(self, "_on_sign_out_failed"))
		# ... Connect other callbacks as needed ...

	else:
		print("Google Play Games Services plugin not found!")

# Callback functions
func _on_sign_in_success(account_id: String):
	var popup = AcceptDialog.new()
	popup.dialog_text = "Sign in successful. Account ID: " + account_id
	popup.title = "Sign In Status"
	add_child(popup)
	popup.popup_centered()

func _on_sign_in_failed(error_code: int):
	var popup = AcceptDialog.new()
	popup.dialog_text = "Sign in failed. Error code: " + str(error_code)
	popup.title = "Sign In Status"
	add_child(popup)
	popup.popup_centered()

func _on_sign_out_success():
	print("Sign out successful")

func _on_sign_out_failed():
	print("Sign out failed")
	
	
# Callbacks:
func _on_leaderboard_score_submitted(leaderboard_id: String):
	pass

func _on_leaderboard_score_submitting_failed(leaderboard_id: String):
	pass

# ... Add other callback functions as needed ...

func is_gpgs_available() -> bool:
	if play_games_services:
		return play_games_services.isGooglePlayServicesAvailable()
	return false
