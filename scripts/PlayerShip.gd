extends Area2D

signal projectile_fired(position)
signal rocket_fired(position)
signal player_hit

@export var speed = 300
@export var fire_rate = 0.2

var screen_size
var can_fire = true
var touch_position = Vector2.ZERO
var is_touching = false
var is_invulnerable = false

@export var laser_duration = 2.0
@export var laser_cooldown = 5.0
var laser_active = false
var laser_timer = 0.0
var laser_cooldown_timer = 0.0

@onready var ui_layer: CanvasLayer = get_node("/root/Main/TouchControls")
@onready var game_manager = get_node("/root/Main/GameManager")

@onready var touch_control = get_node("/root/Main/TouchControls")

func _ready():
	screen_size = get_viewport_rect().size
	$FireRateTimer.wait_time = fire_rate
	$FireRateTimer.one_shot = true
	add_to_group("player")
	connect("area_entered", Callable(self, "_on_area_entered"))
	
	# Add a Line2D node for the laser
	var laser = Line2D.new()
	laser.name = "Laser"
	laser.width = 5
	laser.default_color = Color.BLUE
	laser.visible = false
	add_child(laser)
	
	touch_control.connect("powerup_pressed", _on_powerup_pressed)
	touch_control.connect("powerup_released", _on_powerup_released)

func _process(delta):
	if OS.get_name() == "Android":
		move_touch(delta)
	else:
		move_keyboard(delta)
	handle_shooting()
	
	# Handle laser logic
	if laser_active:
		laser_timer += delta
		if laser_timer >= laser_duration:
			deactivate_laser()
	elif laser_cooldown_timer > 0:
		laser_cooldown_timer -= delta

func move_keyboard(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)

func move_touch(delta):
	if is_touching:
		var direction = (touch_position - position).normalized()
		position += direction * speed * delta
		position = position.clamp(Vector2.ZERO, screen_size)

func handle_shooting():
	if OS.get_name() != "Android" and Input.is_action_pressed("shoot"):
		if can_fire:
			fire_projectile()

func fire_projectile():
	can_fire = false
	projectile_fired.emit($Muzzle.global_position)
	$FireRateTimer.start()

func fire_rocket():
	can_fire = false
	rocket_fired.emit($Muzzle.global_position)
	$FireRateTimer.start()
	
func activate_laser():
	if not laser_active and laser_cooldown_timer <= 0:
		laser_active = true
		laser_timer = 0.0
		$Laser.visible = true
		$Laser.clear_points()
		$Laser.add_point(Vector2.ZERO)
		$Laser.add_point(Vector2(0, -screen_size.y))  # Shooting upwards

func deactivate_laser():
	if laser_active:
		laser_active = false
		laser_cooldown_timer = laser_cooldown
		$Laser.visible = false

func _physics_process(delta):
	if laser_active:
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(global_position, global_position + Vector2(0, -screen_size.y))
		query.collide_with_bodies = false
		query.collide_with_areas = true
		var result = space_state.intersect_ray(query)
		
		if result:
			if result.collider.is_in_group("enemies"):
				result.collider.hit(2)  # Assuming enemies have a hit(damage) method
	
func _on_FireRateTimer_timeout():
	can_fire = true

func hit():
	if not is_invulnerable:
		is_invulnerable = true
		player_hit.emit()
		$Sprite2D.modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
		$Sprite2D.modulate = Color.WHITE
		is_invulnerable = false

func _unhandled_input(event):
	if OS.get_name() == "Android":
		if event is InputEventScreenTouch:
			if not is_touch_on_ui(event.position):
				is_touching = event.pressed
				touch_position = event.position
		elif event is InputEventScreenDrag:
			if not is_touch_on_ui(event.position):
				touch_position = event.position

func is_touch_on_ui(touch_pos: Vector2) -> bool:
	if ui_layer:
		for child in ui_layer.get_children():
			if child is Control and child.get_global_rect().has_point(touch_pos):
				return true
	return false

func _on_touch_controls_shoot_pressed():
	if can_fire:
		fire_projectile()

func _on_touch_controls_shoot_released():
	pass # Replace with function body.
		
func _on_powerup_pressed(version):
	if version == 1:
		# Handle rocket powerup press
		print("Rocket shooted")
		if can_fire:
			fire_rocket()
	elif version == 2:
		activate_laser()
	else:
		# Handle other powerup press
		pass

func _on_powerup_released(version):
	if version == 1:
		# Handle rocket powerup release
		pass
	elif version == 2:
		deactivate_laser()
	else:
		# Handle other powerup release
		pass

func _on_area_entered(area):
 # Check if the area has the entity_type property
	if "entity_type" in area:
		# Check if the entering area is a player projectile
		if area.entity_type == 1:  # 0 represents Player
			hit()
			area.queue_free()
	# Fallback to the group check if entity_type is not available
	elif area.is_in_group("enemy_projectiles"):
		hit()
		area.queue_free()
	#collision with enemy spaceship
	elif area.is_in_group("enemies"):
		hit()
		area.queue_free()
	elif area.is_in_group("powerups"):
		if "power_up" in area:
			if area.power_up == 0:
				game_manager.increase_lives(1)
			if area.power_up == 1:
				touch_control.set_powerup_button_texture("res://sprites/ui/Powerup_Rocket.png")
			if area.power_up == 2:
				touch_control.set_powerup_button_texture("res://sprites/ui/Powerup_Laser.png")
		area.queue_free()
