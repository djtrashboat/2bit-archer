extends Node2D

var global_position_i: Vector2 #guarda a posicao do clique do mouse

func _ready():
	set_process(false)

func _ready_to_draw():
	global_position_i = get_global_mouse_position()
	set_process(true)

func _draw():
	draw_line(global_position_i, get_global_mouse_position(), Color(249, 248, 232), 2)

func _process(delta):
	update()

func _end_line():
	global_position_i = get_global_mouse_position()
	update()
	set_process(false)
