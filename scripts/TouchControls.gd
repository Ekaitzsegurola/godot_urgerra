extends CanvasLayer

signal touch_movement(position)
signal shoot_pressed
signal shoot_released
signal powerup_pressed(version)
signal powerup_released(version)

#@onready var joystick = $Joystick
@onready var shoot_button = $ShootButton
@onready var powerup_button = $PowerUpButton

const ROCKET_TEXTURE_PATH = "res://sprites/ui/Powerup_Rocket.png"
const LASER_TEXTURE_PATH = "res://sprites/ui/Powerup_Laser.png"
const THREEBULLET_TEXTURE_PATH = "res://sprites/ui/Powerup_ThreeBullet.png"

func _ready():
	#if OS.get_name() != "Android":
		#queue_free()
		#return
	
	#joystick.connect("touch_movement", _on_touch_movement)
	shoot_button.connect("button_down", _on_shoot_pressed)
	shoot_button.connect("button_up", _on_shoot_released)
	powerup_button.connect("button_down", _on_powerup_pressed)
	powerup_button.connect("button_up", _on_powerup_released)

func _on_touch_movement(position):
	emit_signal("touch_movement", position)

func _on_shoot_pressed():
	emit_signal("shoot_pressed")

func _on_shoot_released():
	print("Shoot!")
	emit_signal("shoot_released")
	
func _on_powerup_pressed():
	var version = 0
	
	if powerup_button.texture_normal.resource_path == ROCKET_TEXTURE_PATH:
		version = 1
	elif powerup_button.texture_normal.resource_path == LASER_TEXTURE_PATH:
		version = 2
	elif powerup_button.texture_normal.resource_path == THREEBULLET_TEXTURE_PATH:
		version = 3
	
	emit_signal("powerup_pressed", version)
	powerup_button.texture_normal = null

func _on_powerup_released():
	#print("Powerup!")
	#var version = 1 if powerup_button.texture_normal.resource_path == ROCKET_TEXTURE_PATH else 0
	#emit_signal("powerup_released", version)
	pass

func _on_joystick_touch_movement(vector):
	pass # Replace with function body.
	
func set_powerup_button_texture(texture_path: String):
	var texture = load(texture_path)
	if texture:
		powerup_button.texture_normal = texture
	else:
		print("Failed to load texture: ", texture_path)
