extends Actor

var global_position_i: Vector2#guarda a posicao do clique do mouse
var global_position_f: Vector2#guarda a posicao de quando solta o mouse
var arrow_position_i: Vector2#guarda a posicao do clique do mouse
var arrow_position_f: Vector2#guarda a posicao de quando solta o mouse
var mousehold: bool = false
var arrow_angle: float
export (NodePath) var entity_path = ".."

onready var ArrowNode = get_node(entity_path)

func _ready() -> void:
	set_physics_process(false)

func _physics_process(delta: float) -> void:
	_velocity.y += gravity * delta
	#move_and_collide(_velocity * _speed *delta)
	if move_and_collide(_velocity *delta):
		_on_impact()
	#*************rotated() <-------- tem que aprender como funciona e aplicar

func launch_arrow(strength: Vector2) -> void:
	var temp = global_transform
	var scene = get_tree().current_scene
	get_parent().remove_child(self)
	scene.add_child(self)
	global_transform = temp
	_velocity = strength * _speed
	set_physics_process(true)
		#_is_airborne = true
		#var parent = ArrowNode.get_parent().get_parent()
		#parent.add_child(ArrowNode)

func _on_impact():
	_velocity *= 0
	$ArrowAnimatedSprite.stop()
	set_physics_process(false)
