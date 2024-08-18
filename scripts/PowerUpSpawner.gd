extends Node2D

var power_up_life = preload("res://scenes/PowerUpLife.tscn")
var power_up_rocket = preload("res://scenes/PowerUpRocket.tscn")
@onready var spawn_area = get_node("/root/Main/AreaPowerUps")

func _ready():
	# Ensure the spawn_area is valid
	if not spawn_area:
		push_error("AreaPowerUps node not found!")

func _process(delta):
	if randf() < 0.03:  # 0.03% chance every frame
		spawn_power_up()

func spawn_power_up():
	if not spawn_area:
		return

	# Randomly choose between life and rocket power-up
	var power_up_scene = power_up_life if randf() < 0.5 else power_up_rocket
	var power_up_spawned = power_up_scene.instantiate()

	# Get the spawn area's position and size
	var area_position = spawn_area.global_position
	var area_size = spawn_area.get_node("CollisionShape2D").shape.extents * 2

	# Generate a random position within the spawn area
	var random_x = randf_range(0, area_size.x)
	var random_y = randf_range(0, area_size.y)
	
	print("area_size.x")
	print(area_size.x)

	# Set the power-up's position
	power_up_spawned.global_position = area_position + Vector2(random_x, random_y)

	# Add the power-up to the scene
	get_tree().get_root().add_child(power_up_spawned)
