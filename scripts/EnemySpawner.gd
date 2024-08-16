extends Node2D

var enemy_scene = preload("res://scenes/Enemy.tscn")
var enemy2_scene = preload("res://scenes/Enemy2.tscn")
var enemy3_scene = preload("res://scenes/Enemy3.tscn")
var enemy4_scene = preload("res://scenes/Enemy4.tscn")
var enemy5_scene = preload("res://scenes/Enemy5.tscn")
var enemy6_scene = preload("res://scenes/Enemy6.tscn")

@export var spawn_interval = 2.0
@export var spawn_interval2 = 1.2
@export var spawn_interval5 = 1.0
@onready var screen_width = get_viewport_rect().size.x
@onready var screen_height = get_viewport_rect().size.y
@onready var spawn_timer = $SpawnTimer
@onready var game_manager = get_node("/root/Main/GameManager")

func _ready():
	if not spawn_timer:
		spawn_timer = Timer.new()
		spawn_timer.name = "SpawnTimer"
		add_child(spawn_timer)
	
	spawn_timer.wait_time = spawn_interval
	spawn_timer.timeout.connect(spawn_enemy)
	spawn_timer.start()

func spawn_enemy():
	var enemy
	var random_value = randf()
	
	match game_manager.current_level:
		1:
			enemy = enemy_scene.instantiate()
		2:
			if random_value < 1.0/3.0:
				enemy = enemy2_scene.instantiate()
			else:
				enemy = enemy_scene.instantiate()
		3:
			spawn_timer.wait_time = spawn_interval2
			if random_value < 1.0/3.0:
				enemy = enemy2_scene.instantiate()
			else:
				enemy = enemy_scene.instantiate()
		4:
			spawn_timer.wait_time = spawn_interval2
			if random_value < 1.0/6.0:
				enemy = spawn_enemy3()
			elif random_value < 1.0/2.5:
				enemy = enemy2_scene.instantiate()
			else:
				enemy = enemy_scene.instantiate()
		5:
			spawn_timer.wait_time = spawn_interval5
			if random_value < 1.0/5.0:
				enemy = spawn_enemy3()
			elif random_value < 1.0/2.0:
				enemy = enemy2_scene.instantiate()
			else:
				enemy = enemy_scene.instantiate()
		6:
			spawn_timer.wait_time = spawn_interval5
			if random_value < 1.0/5.0:
				enemy = spawn_enemy3()
			elif random_value < 1.0/3.0:
				enemy = enemy5_scene.instantiate()
			else:
				enemy = enemy4_scene.instantiate()
		7:
			spawn_timer.stop()
			enemy = spawn_enemy_boss()
		_:
			enemy = enemy_scene.instantiate()
	
	if enemy:
		setup_enemy(enemy)

func spawn_enemy_boss():
	var enemy_boss = enemy6_scene.instantiate()
	
	enemy_boss.position.x = screen_width / 2  # Start in the center and top of screen
	enemy_boss.position.y = 100
		
	return enemy_boss
	
func spawn_enemy3():
	var enemy3 = enemy3_scene.instantiate()
	var start_left = randf() < 0.5
	
	if start_left:
		enemy3.position.x = -50  # Start off-screen to the left
		enemy3.position.y = randf_range(0, screen_height - 100)
	else:
		enemy3.position.x = screen_width + 50  # Start off-screen to the right
		enemy3.position.y = randf_range(0, screen_height - 100)
	
	enemy3.set_horizontal_movement(start_left)
	
	return enemy3

func setup_enemy(enemy):
	if not enemy.is_horizontal and not enemy.is_boss:
		enemy.position.x = randf_range(0, screen_width)
		enemy.position.y = -50
	
	enemy.enemy_destroyed.connect($"../GameManager".increase_score)
	add_child(enemy)
	
	if not enemy.is_in_group("enemies"):
		enemy.add_to_group("enemies")
