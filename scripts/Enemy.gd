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

func _process(delta):
	position.y += speed * delta
	
	if position.y > 800:  # Adjust based on your screen size
		queue_free()

func hit():
	enemy_destroyed.emit(points)
	# Add visual effect for enemy hit here
	# For example, play an explosion animation
	$AnimatedSprite2D.play("explode")
	await $AnimatedSprite2D.animation_finished
	queue_free()

func _on_shoot_timer_timeout():
	enemy_shoot.emit(global_position)
