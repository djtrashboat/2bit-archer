extends "res://Source/Actors/Actor.gd"

var global_position_i: Vector2
var global_position_f: Vector2
var enable_mov: bool

func _physics_process(delta: float) -> void:
	_velocity.y += gravity * delta
	if is_on_wall():
		_velocity.x *= -0.3
	if enable_mov:
		if Input.is_action_just_pressed("click"):
			global_position_i = get_global_mouse_position()
		if Input.is_action_just_released("click"):
			global_position_f = get_global_mouse_position()
			_velocity = calculate_impulse()
			enable_mov = false
	move_and_slide(_velocity * max_speed)
	play_animation(_velocity)
	
func calculate_impulse() -> Vector2:
	Input.is_action_just_pressed("click")
	Input.is_action_just_released("click")
	var impulse: Vector2
	impulse = (global_position_i - global_position_f)
	return impulse

func play_animation(velocity: Vector2) -> void:
	if is_on_wall() and (velocity.x< (0.1) or velocity.x> (-0.1)):
		$AnimatedSprite.play("idle")
		enable_mov = true
	elif velocity.y > 0.0:
		if velocity.x == 0.0:
			$AnimatedSprite.flip_h = false
			$AnimatedSprite.play("fall")
		elif velocity.x < 0.0:
			$AnimatedSprite.flip_h = true
			$AnimatedSprite.play("fall")
		elif velocity.x > 0.0:
			$AnimatedSprite.flip_h = false
			$AnimatedSprite.play("fall")
	elif velocity.y < 0.0:
		if velocity.x > 0.0:
			$AnimatedSprite.flip_h = false
			$AnimatedSprite.play("jump")
		elif velocity.x < 0.0:
			$AnimatedSprite.flip_h = true
			$AnimatedSprite.play("jump")
		else:
			$AnimatedSprite.play("jump")
