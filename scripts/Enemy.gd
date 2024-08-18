extends Area2D
signal enemy_destroyed(points)
signal enemy_shoot(position)
signal enemy_hit
@export var speed = 100
@export var points = 10
@export var shoot_interval = 2.0
@export var life_points = 1
@export var is_horizontal = false
@export var move_right = false
@export var is_boss = false
@export var laser_duration = 2.0
@export var laser_cooldown = 5.0
@onready var game_manager = get_node("/root/Main/GameManager")
@onready var screen_size = get_viewport_rect().size
var laser_active = false
var laser_timer = 0.0
var laser_cooldown_timer = 0.0

func _ready():
	add_to_group("enemies")
	$ShootTimer.wait_time = shoot_interval
	$ShootTimer.start()
	connect("area_entered", Callable(self, "_on_area_entered"))
	game_manager.connect("level_changed", Callable(self, "_on_level_changed"))
	
	if is_boss:
		# Add a Line2D node for the laser
		var laser = Line2D.new()
		laser.name = "Laser"
		laser.width = 5
		laser.default_color = Color.RED
		laser.visible = false
		add_child(laser)

func _process(delta):
	if is_horizontal:
		if move_right:
			position.x += speed * delta
			if position.x > screen_size.x + 50:
				queue_free()
		else:
			position.x -= speed * delta
			if position.x < -50:
				queue_free()
	elif is_boss:
		if move_right:
			position.x += speed * delta
			if position.x > screen_size.x - 50:
				move_right = false
		else:
			position.x -= speed * delta
			if position.x < 50:
				move_right = true
		
		# Handle laser logic
		if laser_active:
			laser_timer += delta
			if laser_timer >= laser_duration:
				deactivate_laser()
		elif laser_cooldown_timer > 0:
			laser_cooldown_timer -= delta
		elif randf() < 0.01:  # 1% chance each frame to activate laser
			activate_laser()
	else:
		position.y += speed * delta
		if position.y > screen_size.y + 50:
			queue_free()

func hit(damage):
	life_points -= damage
	if life_points <= 0:
		if is_boss:
			game_manager.next_level()
		destroy()
	else:
		$Sprite2D.modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
		$Sprite2D.modulate = Color.WHITE
		
func destroy():
	enemy_destroyed.emit(points)
	if has_node("AnimatedSprite2D"):
		var sprite = $AnimatedSprite2D
		sprite.visible = true
		sprite.play("explode")
		
		# Ensure the animation doesn't loop
		sprite.sprite_frames.set_animation_loop("explode", false)
		
		# Wait for the animation to finish
		await sprite.animation_finished
	call_deferred("queue_free")

func _on_shoot_timer_timeout():
	print("Shoot")
	enemy_shoot.emit(global_position)

func _on_area_entered(area):
	if "entity_type" in area:
		if area.entity_type == 0:  # 0 represents Player
			hit(area.hit_damage)
			area.explode()
			area.queue_free()
	elif area.is_in_group("player_projectiles"):
		hit(area.hit_damage)
		area.explode()
		area.queue_free()
		
func _on_level_changed(value):
	pass

func set_horizontal_movement(start_left: bool):
	is_horizontal = true
	move_right = start_left
	rotation_degrees = 270 if start_left else 90

func activate_laser():
	if is_boss and not laser_active and laser_cooldown_timer <= 0:
		laser_active = true
		laser_timer = 0.0
		$Laser.visible = true
		$Laser.clear_points()
		$Laser.add_point(Vector2.ZERO)
		$Laser.add_point(Vector2(0, screen_size.y))

func deactivate_laser():
	if is_boss and laser_active:
		laser_active = false
		laser_cooldown_timer = laser_cooldown
		$Laser.visible = false

func _physics_process(delta):
	if is_boss and laser_active:
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(global_position, global_position + Vector2(0, screen_size.y))
		query.collide_with_bodies = false
		query.collide_with_areas = true
		var result = space_state.intersect_ray(query)
		
		if result:
			if result.collider.is_in_group("player"):
				result.collider.hit()  # Assuming the player has a hit() method
