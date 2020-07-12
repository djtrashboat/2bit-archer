extends Node2D

var global_position_i: Vector2 #guarda a posicao do clique do mouse no mundo
var mouse_position_i: Vector2 #guarda a posicao do clique do mouse na janela
var arrow_color: Color
func _ready():
	set_process(false)

func _ready_to_draw(color: Color):
	#global_position_i = get_global_mouse_position()
	global_position_i =  get_local_mouse_position()
	#mouse_position_i = get_viewport().get_mouse_position()
	arrow_color = color
	set_process(true)
	

func _draw():
	#draw_line(global_position_i, get_global_mouse_position(), Color(33, 125, 99), 1.5)
	draw_line(global_position_i, get_local_mouse_position(), arrow_color, 1.5)

func _process(delta):
	update()

func _end_line():
	global_position_i = get_global_mouse_position()
	update()
	set_process(false)
