extends Control

signal touch_movement(vector)

@export var joystick_size: float = 200
@export var dead_zone: float = 0.2
@export var clampzone: float = 1.0

@onready var joystick_background: TextureRect = $JoystickBackground
@onready var joystick_handle: TextureRect = $JoystickBackground/JoystickHandle

var touch_index: int = -1
var touch_vector: Vector2 = Vector2.ZERO

func _ready():
	joystick_background.custom_minimum_size = Vector2(joystick_size, joystick_size)
	joystick_background.pivot_offset = Vector2(joystick_size / 2, joystick_size / 2)
	joystick_handle.pivot_offset = Vector2(joystick_size / 4, joystick_size / 4)

func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			if touch_index == -1 and joystick_background.get_global_rect().has_point(event.position):
				touch_index = event.index
				joystick_handle.global_position = event.position - joystick_handle.pivot_offset
		else:
			if touch_index == event.index:
				touch_index = -1
				joystick_handle.position = joystick_background.pivot_offset - joystick_handle.pivot_offset
				touch_vector = Vector2.ZERO
				emit_signal("touch_movement", touch_vector)

	if event is InputEventScreenDrag and touch_index == event.index:
		var center = joystick_background.global_position + joystick_background.pivot_offset
		var touch_position = event.position - center
		touch_vector = (touch_position / joystick_size).limit_length(clampzone)
		
		if touch_vector.length() <= dead_zone:
			touch_vector = Vector2.ZERO
		else:
			touch_vector = touch_vector.normalized() * ((touch_vector.length() - dead_zone) / (clampzone - dead_zone))
		
		joystick_handle.position = touch_vector * joystick_size + joystick_background.pivot_offset - joystick_handle.pivot_offset
		emit_signal("touch_movement", touch_vector)

func _process(delta):
	if touch_index != -1:
		emit_signal("touch_movement", touch_vector)
