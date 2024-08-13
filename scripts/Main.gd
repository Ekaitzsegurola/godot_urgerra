extends Node2D

@onready var player_ship = $PlayerShip
@onready var projectile_manager = $ProjectileManager
@onready var enemy_spawner = $EnemySpawner
@onready var game_manager = $GameManager

func _ready():
	connect_signals()

func connect_signals():
	if player_ship and projectile_manager:
		player_ship.projectile_fired.connect(projectile_manager.spawn_player_projectile)

func _process(delta):
	check_collisions()

func check_collisions():
	if not (player_ship and projectile_manager and enemy_spawner):
		return
	
	var player_projectiles = projectile_manager.get_player_projectiles()
	var enemies = get_enemies()

	for enemy in enemies:
		if enemy.overlaps_body(player_ship):
			on_player_hit()
			enemy.queue_free()

func get_enemies():
	return enemy_spawner.get_children().filter(func(node): return node is Area2D)

func on_player_hit():
	game_manager.decrease_lives()
