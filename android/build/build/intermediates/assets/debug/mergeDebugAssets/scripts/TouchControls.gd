extends CanvasLayer

signal touch_movement(position)
signal shoot_pressed
signal shoot_released

#@onready var joystick = $Joystick
@onready var shoot_button = $ShootButton

func _ready():
	if OS.get_name() != "Android":
		queue_free()
		return
	
	#joystick.connect("touch_movement", _on_touch_movement)
	shoot_button.connect("button_down", _on_shoot_pressed)
	shoot_button.connect("button_up", _on_shoot_released)

func _on_touch_movement(position):
	emit_signal("touch_movement", position)

func _on_shoot_pressed():
	emit_signal("shoot_pressed")

func _on_shoot_released():
	print("Shoot!")
	emit_signal("shoot_released")


func _on_joystick_touch_movement(vector):
	pass # Replace with function body.
