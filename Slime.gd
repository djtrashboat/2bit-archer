extends "res://Source/Actors/enemy.gd"

export var directionfrequency: int = 5
var changedirectionin: int
export var initial_direction: int = 1

func _physics_process(delta: float) -> void:
	_velocity.y += gravity * delta
	if is_on_wall():
		_velocity.x *= -0.3
	move_and_slide(_velocity * _speed)

func _jump():
	_velocity = -_speed * 8
	_velocity.x *= initial_direction
	changedirectionin -= 1
	if changedirectionin == 0:
		initial_direction *= -1
		changedirectionin = directionfrequency

func _process(delta: float) -> void:
	_update()

func _update():
	pass

func _ready():
	$Timer.start()
	changedirectionin = directionfrequency

func _on_Timer_timeout() -> void:
	_jump()
