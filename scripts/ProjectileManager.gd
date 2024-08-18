extends Node2D

var player_projectile_scene = preload("res://scenes/PlayerProjectile.tscn")
var enemy_projectile_scene = preload("res://scenes/EnemyProjectile.tscn")
var player_rocket_scene = preload("res://scenes/PlayerRocket.tscn")

var player_projectiles = []
var enemy_projectiles = []

func spawn_player_projectile(pos):
	var projectile = player_projectile_scene.instantiate()
	projectile.position = pos
	projectile.direction = Vector2.UP
	add_child(projectile)
	
func spawn_player_rocket(pos):
	var projectile = player_rocket_scene.instantiate()
	projectile.position = pos
	projectile.direction = Vector2.UP
	add_child(projectile)

func spawn_enemy_projectile(pos):
	var projectile = enemy_projectile_scene.instantiate()
	print("New projectile")
	projectile.position = pos
	projectile.direction = Vector2.DOWN
	add_child(projectile)

func get_projectiles():
	return get_children()


func _process(delta):
	update_projectiles(player_projectiles)
	update_projectiles(enemy_projectiles)

func update_projectiles(projectile_list):
	for projectile in projectile_list:
		if not is_instance_valid(projectile) or not projectile.is_inside_tree():
			projectile_list.erase(projectile)
			if is_instance_valid(projectile):
				projectile.queue_free()

func get_player_projectiles():
	return player_projectiles

func get_enemy_projectiles():
	return enemy_projectiles
