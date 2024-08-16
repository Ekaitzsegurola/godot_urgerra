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

@onready var game_manager = get_node("/root/Main/GameManager")
@onready var screen_size = get_viewport_rect().size

func _ready():
	add_to_group("enemies")
	$ShootTimer.wait_time = shoot_interval
	$ShootTimer.start()
	connect("area_entered", Callable(self, "_on_area_entered"))
	game_manager.connect("level_changed", Callable(self, "_on_level_changed"))

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
			if position.x > screen_size.x + 50:
				move_right = false
		else:
			position.x -= speed * delta
			if position.x < -50:
				move_right = true
	else:
		position.y += speed * delta
		if position.y > screen_size.y + 50:
			queue_free()

func hit():
	life_points -= 1
	if life_points <= 0:
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
	enemy_shoot.emit(global_position)

func _on_area_entered(area):
	if "entity_type" in area:
		if area.entity_type == 0:  # 0 represents Player
			hit()
			area.explode()
			area.queue_free()
	elif area.is_in_group("player_projectiles"):
		hit()
		area.explode()
		area.queue_free()
		
func _on_level_changed(value):
	pass

func set_horizontal_movement(start_left: bool):
	is_horizontal = true
	move_right = start_left
	rotation_degrees = 270 if start_left else 90
