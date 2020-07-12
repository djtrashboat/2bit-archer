extends Node2D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$"draw line"._end_line()
	
func _process(delta: float) -> void:
	$Sprite.position = get_global_mouse_position()
	if Input.is_action_just_pressed("click_right"):
		var color: Color
		color.r = 33
		color.g = 125
		color.b = 99
		_drawline(color)
	if Input.is_action_just_released("click_right"):
		_ditch_line()
	if Input.is_action_just_pressed("click_left"):
		var color: Color
		color.r = 0
		color.g = 232
		color.b = 255
		_drawline(color)
	if Input.is_action_just_released("click_left"):
		_ditch_line()
		
func _drawline(color: Color):
	$"draw line"._ready_to_draw(color)

func _ditch_line():
	$"draw line"._end_line()
