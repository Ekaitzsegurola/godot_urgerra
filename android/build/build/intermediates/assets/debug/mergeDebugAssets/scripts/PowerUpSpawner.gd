extends Node2D

var power_up_life = preload("res://scenes/PowerUpLife.tscn")
@onready var spawn_area = get_node("/root/Main/AreaPowerUps")

func _ready():
	# Ensure the spawn_area is valid
	if not spawn_area:
		push_error("AreaPowerUps node not found!")

func _process(delta):
	if randf() < 0.0003:  # 1% chance every frame
		spawn_power_up()

func spawn_power_up():
	if not spawn_area:
		return

	var power_up_life_spawned = power_up_life.instantiate()

	# Get the spawn area's position and size
	var area_position = spawn_area.global_position
	var area_size = spawn_area.get_node("CollisionShape2D").shape.extents * 2

	# Generate a random position within the spawn area
	var random_x = randf_range(0, area_size.x)
	var random_y = randf_range(0, area_size.y)
	
	print("area_size.x")
	print(area_size.x)

	# Set the power-up's position
	power_up_life_spawned.global_position = area_position + Vector2(random_x, random_y)

	# Add the power-up to the scene
	get_tree().get_root().add_child(power_up_life_spawned)
