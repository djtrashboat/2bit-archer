extends Actor

var global_position_i: Vector2#guarda a posicao do clique do mouse
var global_position_f: Vector2#guarda a posicao de quando solta o mouse
var arrow_position_i: Vector2#guarda a posicao do clique do mouse
var arrow_position_f: Vector2#guarda a posicao de quando solta o mouse
#var mousehold: bool = false
#var arrow_angle: float
export (NodePath) var entity_path = ".."

onready var ArrowNode = get_node(entity_path)

func _ready() -> void:
	#set_process(false)
	#hide()
	#set_global_position(global_position_i - global_position_i)
	position.x = 420.0
	position.y = -610.0
	set_physics_process(false) #ele inicia sem processo de fisica (ate ser ligado em launch())

func _physics_process(delta: float) -> void:
	if move_and_collide(_velocity *delta):#arrow goes vrummmm e retorna 1 se colidir
		_on_impact()
	else:
		rotation = _velocity.angle()
		_velocity.y += gravity * 1.5 * delta #aplicando a gravidade

func launch_arrow(strength: Vector2) -> void:
	#set_process(true)
	var temp = global_transform#guarda a posicao
	var scene = get_tree().current_scene#store a cena
	_velocity.x = get_parent()._velocity.x
	get_parent().remove_child(self)#player deixa de ser pai
	scene.add_child(self)#agora flecha eh filha da cena
	global_transform = temp#posicao dela eh a posicao que foi guardada antes
	position.y -= 6 #pra nao soltar flecha do pe
	_velocity += strength * _speed
	#show()
	set_physics_process(true)#inicia o processo de fisica

func _on_impact(): #quando a flecha bate, para de tocar animacao e de ter fisica
	#_velocity *= 0
	$ArrowAnimatedSprite.play("stop")
	$ArrowAnimatedSprite.stop()
	set_physics_process(false)#desliga a fisica
	$ArrowCol.queue_free()
	$qfreetimer.start()


func _on_ArrowCol_area_entered(area: Area2D) -> void:#quando a flecha bate no slime, ela some
	if area.name == "arrow_detector" or area.name == "enemy_shield":
		#print("arrowqfree")
		queue_free()

func _set_pos(new_pos: Vector2):
	set_global_position(new_pos)


func _on_qfreetimer_timeout() -> void:
	queue_free()
