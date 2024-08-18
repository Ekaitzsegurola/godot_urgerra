extends Area2D

var power_up = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("powerups")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_timer_life_time_timeout():
	queue_free()
