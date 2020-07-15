extends Node2D

var global_position_i: Vector2 #guarda a posicao do clique do mouse no mundo
#var global_position2: Vector2
var mouse_position_i: Vector2 #guarda a posicao do clique do mouse na janela
var arrow_color: Color

func _ready():
	_end_line()
	set_process(false)

func _ready_to_draw(color: Color):
	#global_position_i = get_global_mouse_position()
	global_position_i =  get_local_mouse_position()
	#global_position2 = global_position_i
	#global_position_i.y += 6
	#global_position2.y -= 6
	mouse_position_i = get_viewport().get_mouse_position()
	arrow_color = color
	set_process(true)
	

func _draw():
	#draw_line(global_position_i, get_global_mouse_position(), Color(33, 125, 99), 1.5)
	#draw_line(global_position_i, get_local_mouse_position(), arrow_color, 1.5)
	draw_line(global_position_i, (global_position_i - mouse_position_i + get_viewport().get_mouse_position()), arrow_color, 1.5)
	#draw_line(global_position2, get_local_mouse_position(), arrow_color, 1.5)

func _process(delta):
	update()

func _end_line():
	global_position_i *= -999
	mouse_position_i *= -999
	#global_position_i = (global_position_i - mouse_position_i + get_viewport().get_mouse_position())
	#global_position_i = get_global_mouse_position()
	#global_position2 = get_global_mouse_position()
	#draw_line(get_viewport().get_mouse_position(), get_viewport().get_mouse_position(), arrow_color, 0)
	update()
	set_process(false)
