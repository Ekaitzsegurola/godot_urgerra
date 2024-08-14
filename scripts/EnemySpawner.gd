extends Node2D

var enemy_scene = preload("res://scenes/Enemy.tscn")
@export var spawn_interval = 2.0
@onready var screen_width = get_viewport_rect().size.x
@onready var spawn_timer = $SpawnTimer

func _ready():
	if not spawn_timer:
		spawn_timer = Timer.new()
		spawn_timer.name = "SpawnTimer"
		add_child(spawn_timer)
	
	spawn_timer.wait_time = spawn_interval
	spawn_timer.timeout.connect(spawn_enemy)
	spawn_timer.start()

func spawn_enemy():
	var enemy = enemy_scene.instantiate()
	enemy.position.x = randf_range(0, screen_width)
	print(enemy.position.x)
	enemy.position.y = -50
	enemy.enemy_destroyed.connect($"../GameManager".increase_score)
	add_child(enemy)
