extends "res://Source/Actors/Actor.gd"

var global_position_i: Vector2
var global_position_f: Vector2

func _physics_process(delta: float) -> void:
	_velocity.y += gravity * delta
	if is_on_floor():
		print("is on floor")
		_velocity.x = 0
	if Input.is_action_just_pressed("click"):
		global_position_i = get_global_mouse_position()
	if Input.is_action_just_released("click"):
		global_position_f = get_global_mouse_position()
		_velocity = calculate_impulse()
	move_and_slide(_velocity * max_speed)
	
func calculate_impulse() -> Vector2:
	Input.is_action_just_pressed("click")
	Input.is_action_just_released("click")
	var impulse: Vector2
	impulse = (global_position_i - global_position_f)
	return impulse
