extends Node2D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$"draw line"._end_line()
	
func _process(delta: float) -> void:
	$Sprite.position = get_global_mouse_position()
	if Input.is_action_just_pressed("click_right"):
		_drawline()
	if Input.is_action_just_released("click_right"):
		_ditch_line()

func _drawline():
	$"draw line"._ready_to_draw()

func _ditch_line():
	$"draw line"._end_line()
