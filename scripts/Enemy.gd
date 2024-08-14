extends Area2D

signal enemy_destroyed(points)
signal enemy_shoot(position)

@export var speed = 100
@export var points = 10
@export var shoot_interval = 2.0

func _ready():
	add_to_group("enemies")
	$ShootTimer.wait_time = shoot_interval
	$ShootTimer.start()
	connect("area_entered", Callable(self, "_on_area_entered"))

func _process(delta):
	position.y += speed * delta
	
	if position.y > 800:  # Adjust based on your screen size
		queue_free()

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
