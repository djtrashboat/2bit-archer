extends KinematicBody2D
class_name Actor

const FLOOR_NORMAL: = Vector2.UP

export var gravity = 200.0
export var _speed: = Vector2(5,5)

var _velocity: = Vector2.ZERO

#var _is_airborne = false

func calculate_impulse(vi: Vector2, vf: Vector2) -> Vector2:#calcula o impulso a partir das cordenadas do mouse
	var impulse: Vector2
	impulse = (vi - vf)
	return impulse
