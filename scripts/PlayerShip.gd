extends Area2D

signal projectile_fired(position)
signal player_hit

@export var speed = 300
@export var fire_rate = 0.2

var screen_size
var can_fire = true
var touch_position = Vector2.ZERO
var is_touching = false

@onready var ui_layer: CanvasLayer = get_node("/root/Main/TouchControls")

func _ready():
	screen_size = get_viewport_rect().size
	$FireRateTimer.wait_time = fire_rate
	$FireRateTimer.one_shot = true
	add_to_group("player")

func _process(delta):
	if OS.get_name() == "Android":
		move_touch(delta)
	else:
		move_keyboard(delta)
	handle_shooting()

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
	
func _on_FireRateTimer_timeout():
	can_fire = true

func hit():
	player_hit.emit()
	$Sprite2D.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	$Sprite2D.modulate = Color.WHITE

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
