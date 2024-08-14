extends Node2D

@onready var player_ship = $PlayerShip
@onready var projectile_manager = $ProjectileManager
@onready var enemy_spawner = $EnemySpawner
@onready var game_manager = $GameManager

func _ready():
	connect_signals()
	print("Start!")
	GlobalGameManager.load_scores()
	GlobalGameManager.print_scores()

func connect_signals():
	if player_ship and projectile_manager:
		if not player_ship.projectile_fired.is_connected(projectile_manager.spawn_player_projectile):
			player_ship.projectile_fired.connect(projectile_manager.spawn_player_projectile)
		if not player_ship.player_hit.is_connected(on_player_hit):
			player_ship.player_hit.connect(on_player_hit)
	
	# Connect enemy signals
	if not enemy_spawner.child_entered_tree.is_connected(connect_enemy_signals):
		enemy_spawner.child_entered_tree.connect(connect_enemy_signals)

func connect_enemy_signals(enemy):
	if not enemy.enemy_shoot.is_connected(projectile_manager.spawn_enemy_projectile):
		enemy.enemy_shoot.connect(projectile_manager.spawn_enemy_projectile)
	if not enemy.enemy_destroyed.is_connected(game_manager.increase_score):
		enemy.enemy_destroyed.connect(game_manager.increase_score)

func _process(delta):
	check_collisions()

func check_collisions():
	if not (player_ship and projectile_manager and enemy_spawner):
		return
	
	var projectiles = projectile_manager.get_projectiles()
	var enemies = get_tree().get_nodes_in_group("enemies")

	for projectile in projectiles:
		if projectile.direction == Vector2.UP:
			for enemy in enemies:
				if projectile.overlaps_body(enemy):
					enemy.hit()
					projectile.queue_free()
					break
		elif projectile.direction == Vector2.DOWN:
			if projectile.overlaps_body(player_ship):
				player_ship.hit()
				projectile.queue_free()

	for enemy in enemies:
		if enemy.overlaps_body(player_ship):
			player_ship.hit()
			enemy.queue_free()

func on_player_hit():
	game_manager.decrease_lives()

