extends Area2D

signal enemy_destroyed(points)
signal enemy_shoot(position)

@export var speed = 100
@export var points = 10
@export var shoot_interval = 2.0

@onready var game_manager = get_node("/root/Main/GameManager")

func _ready():
	add_to_group("enemies")
	$ShootTimer.wait_time = shoot_interval
	$ShootTimer.start()
	connect("area_entered", Callable(self, "_on_area_entered"))
	 # Connect the level_changed signal to the GameManager
	game_manager.connect("level_changed", Callable(self, "_on_level_changed"))
	 # Debug: Print all signals of the game_manager
	#print_game_manager_signals()

func _process(delta):
	position.y += speed * delta
	
	if position.y > 800:  # Adjust based on your screen size
		queue_free()

func print_game_manager_signals():
	print("Debugging GameManager signals:")
	
	# Check if game_manager is valid
	if not is_instance_valid(game_manager):
		print("Error: game_manager is not a valid instance")
		return
	
	# Print all signals defined in the game_manager
	print("Signals defined in GameManager:")
	var signal_list = game_manager.get_signal_list()
	for signal_info in signal_list:
		print("- ", signal_info.name)
	
	# Print all signal connections of the game_manager
	print("Signal connections in GameManager:")
	for signal_name in signal_list:
		var connections = game_manager.get_signal_connection_list(signal_name.name)
		for connection in connections:
			print("- ", signal_name.name, " connected to ", connection.callable)
			
func hit():
	enemy_destroyed.emit(points)
	# Add visual effect for enemy hit here
	# For example, play an explosion animation
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.play("explode")
		await $AnimatedSprite2D.animation_finished
	queue_free()

func _on_shoot_timer_timeout():
	enemy_shoot.emit(global_position)

func _on_area_entered(area):
 # Check if the area has the entity_type property
	if "entity_type" in area:
		# Check if the entering area is a player projectile
		if area.entity_type == 0:  # 0 represents Player
			hit()
			area.queue_free()
	# Fallback to the group check if entity_type is not available
	elif area.is_in_group("player_projectiles"):
		hit()
		area.queue_free()
		
func _on_level_changed():
	pass
