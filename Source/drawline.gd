extends Node2D

onready var jumpingLineEffect: Particles2D = $"../Sprite/JumpingLineEffect"

var globalPosition_i: Vector2 #guarda a posicao do clique do mouse no mundo
var mousePosition_i: Vector2 #guarda a posicao do clique do mouse na janela
var arrowColor: Color

func _ready():
	globalPosition_i = get_viewport().get_mouse_position()



func _ready_to_draw(color: Color):
	globalPosition_i =  get_local_mouse_position()
	mousePosition_i = get_viewport().get_mouse_position()
	arrowColor = color
	set_process(true)
	#Something to start line effect here
	jumpingLineEffect.emitting = true 

func _draw():
	var globalPosition_f = globalPosition_i - mousePosition_i + get_viewport().get_mouse_position() #just breaking this into 2
	draw_line(globalPosition_i, globalPosition_f, arrowColor, 1.5)
	

func _process(delta):
	#something to update line effect orientation here, or maybe in _physics_process?
	update()


func _end_line():
	#Something to end line effect here
	jumpingLineEffect.emitting = false
	globalPosition_i *= -999
	mousePosition_i *= -999
	arrowColor.a = 0
	update()
	set_process(false)
