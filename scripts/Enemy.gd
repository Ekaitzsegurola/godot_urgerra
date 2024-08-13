extends Area2D

signal enemy_destroyed(points)

@export var speed = 100
@export var points = 10

func _ready():
	add_to_group("enemies")

func _process(delta):
	position.y += speed * delta
	
	if position.y > 800:  # Adjust based on your screen size
		queue_free()

func hit():
	enemy_destroyed.emit(points)
	queue_free()
