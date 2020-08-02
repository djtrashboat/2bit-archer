extends Node2D

onready var jumpingLineEffect: Particles2D = $"../Sprite/JumpingLineEffect"
onready var lineEffect: = $"../Line2D"
onready var effectsAnimationPlayer: AnimationPlayer= $"../ParticleMovement"

var globalPosition_i: Vector2 #guarda a posicao do clique do mouse no mundo
var mousePosition_i: Vector2 #guarda a posicao do clique do mouse na janela
var globalPosition_f: Vector2
var arrowColor: Color

func _ready():
	globalPosition_i = get_viewport().get_mouse_position()

func _ready_to_draw(color: Color):
	globalPosition_i =  get_local_mouse_position()
	mousePosition_i = get_viewport().get_mouse_position()
	arrowColor = color
	set_process(true)
	#Something to start line effect here
	jumpingLineEffect.restart()
	jumpingLineEffect.emitting = true 

func _draw():
	globalPosition_f = globalPosition_i - mousePosition_i + get_viewport().get_mouse_position() #just breaking this into 2
	draw_line(globalPosition_i, globalPosition_f, arrowColor, 1.5)


func _vector_rotation(vector: Vector2, angle: float) -> Vector2:	# Vector rotation
	var final_vector: Vector2
	final_vector.x = vector.x * cos(angle) - vector.y * sin(angle)
	final_vector.y = vector.x * sin(angle) + vector.y * cos(angle)
	return final_vector
	
func _UpdateAnimationPlayer() -> void:
	var startingKey: Vector2 = effectsAnimationPlayer.get_animation("JumpingSenoidAnimation").track_get_key_value(0,0)
	var upperKey: Vector2
	var lowerKey: Vector2 
	var middleKey: Vector2
	var lineVector:= Vector2(globalPosition_f*-1 +globalPosition_i)
	var upperBase:= Vector2(-lineVector.length()/4,-15)
	var lowerBase:= Vector2(-lineVector.length()*3/4, 15)
	#print(rad2deg(startingKey.angle_to_point(lineVector))) # debugging

	upperKey = startingKey + _vector_rotation(upperBase,  startingKey.angle_to_point(lineVector))
	lowerKey = startingKey + _vector_rotation(lowerBase, startingKey.angle_to_point(lineVector))
	
	# For senoid movement we need to change the key position according to global positions that draw the line
	# Keys:
	# 0 for starting point (globalPosition_f)
	# 1 for upper point		(top of senoid)
	# 2 for middle point	(middle of senoid)
	# 3 for lower point		(bottom of senoid)
	# 4 for ending point	(globalPosition_i)
	
	# Track ID for JumpingSenoidAnimation is 0
	
	
	
	###############################################################
	# Rewriting this fucking SHIT until it gets good
	
	effectsAnimationPlayer.get_animation("JumpingSenoidAnimation").track_set_key_value(0, 0, startingKey)
	effectsAnimationPlayer.get_animation("JumpingSenoidAnimation").track_set_key_value(0, 1, upperKey)
	effectsAnimationPlayer.get_animation("JumpingSenoidAnimation").track_set_key_value(0, 2, startingKey + lineVector/2)
	effectsAnimationPlayer.get_animation("JumpingSenoidAnimation").track_set_key_value(0, 3, lowerKey)
	effectsAnimationPlayer.get_animation("JumpingSenoidAnimation").track_set_key_value(0, 4, startingKey + lineVector)
	effectsAnimationPlayer.play("JumpingSenoidAnimation")
	###############################################################
	
func _physics_process(delta) -> void:
	#something to update line effect orientation here, or maybe in _physics_process?
	_UpdateAnimationPlayer()
	update()


func _end_line():
	#Something to end line effect here
	jumpingLineEffect.emitting = false
	
	lineEffect.clear_points()
	globalPosition_i *= -999
	mousePosition_i *= -999
	arrowColor.a = 0
	update()
	set_process(false)
