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

func explode():
	if has_node("AnimatedSprite2D"):
		var sprite = $AnimatedSprite2D
		sprite.visible = true
		sprite.play("explode")
		
		# Ensure the animation doesn't loop
		sprite.sprite_frames.set_animation_loop("explode", false)
		
		# Wait for the animation to finish
		await sprite.animation_finished
		print("explode!")
		
func _on_area_entered(area):
	print("Projectile collided with: ", area.name)
	print("Projectile position: ", global_position)
	print("Collided area position: ", area.global_position)
	if direction == Vector2.UP and area.is_in_group("enemies"):
		print("Hit enemy")
		area.hit()
		explode()
		queue_free()
	elif direction == Vector2.DOWN and area.is_in_group("player"):
		print("Hit player")
		area.hit()
		explode()
		queue_free()
	
