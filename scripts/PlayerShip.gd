extends Area2D

signal projectile_fired(position)
signal player_hit

@export var speed = 300
@export var fire_rate = 0.2

var screen_size
var can_fire = true

func _ready():
	screen_size = get_viewport_rect().size
	$FireRateTimer.wait_time = fire_rate
	$FireRateTimer.one_shot = true
	add_to_group("player")

func _process(delta):
	move(delta)
	handle_shooting()

func move(delta):
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

func handle_shooting():
	if Input.is_action_pressed("shoot") and can_fire:
		fire_projectile()

func fire_projectile():
	can_fire = false
	projectile_fired.emit($Muzzle.global_position)
	$FireRateTimer.start()

func _on_FireRateTimer_timeout():
	can_fire = true

func hit():
	player_hit.emit()
	# Add visual effect for player hit here
	# For example, flash the player sprite
	$Sprite2D.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	$Sprite2D.modulate = Color.WHITE
