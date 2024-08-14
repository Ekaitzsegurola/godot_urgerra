extends Area2D

@export var speed = 500
@export var direction = Vector2.UP
@export_enum("Player", "Enemy") var entity_type: int = 0

func _ready():
	if entity_type == 0:
		add_to_group("player_projectiles")
	elif entity_type == 1: 
		add_to_group("enemy_projectiles")

func _process(delta):
	position += direction * speed * delta
	
	# Remove projectile if it goes off screen
	if position.y < -100 or position.y > get_viewport_rect().size.y + 100:
		queue_free()

func _on_area_entered(area):
	print("Projectile collided with: ", area.name)
	print("Projectile position: ", global_position)
	print("Collided area position: ", area.global_position)
	if direction == Vector2.UP and area.is_in_group("enemies"):
		print("Hit enemy")
		area.hit()
		queue_free()
	elif direction == Vector2.DOWN and area.is_in_group("player"):
		print("Hit player")
		area.hit()
		queue_free()
	
