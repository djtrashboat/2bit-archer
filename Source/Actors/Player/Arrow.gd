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
	hide()
	set_physics_process(false) #ele inicia sem processo de fisica (ate ser ligado em launch())

func _physics_process(delta: float) -> void:
	if move_and_collide(_velocity *delta):#arrow goes vrummmm e retorna 1 se colidir
		_on_impact()
	else:
		rotation = _velocity.angle()
		_velocity.y += gravity * 1.5 * delta #aplicando a gravidade

func launch_arrow(strength: Vector2) -> void:
	var temp = global_transform#guarda a posicao
	var scene = get_tree().current_scene#store a cena
	get_parent().remove_child(self)#player deixa de ser pai
	scene.add_child(self)#agora flecha eh filha da cena
	global_transform = temp#posicao dela eh a posicao que foi guardada antes
	position.y -= 6 #pra nao soltar flecha do pe
	_velocity = strength * _speed
	show()
	set_physics_process(true)#inicia o processo de fisica

func _on_impact(): #quando a flecha bate, para de tocar animacao e de ter fisica
	#_velocity *= 0
	$ArrowAnimatedSprite.play("stop")
	$ArrowAnimatedSprite.stop()
	set_physics_process(false)#desliga a fisica
