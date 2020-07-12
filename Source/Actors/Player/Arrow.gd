extends Actor

onready var ArrowNode := get_node(".")

var global_position_i: Vector2#guarda a posicao do clique do mouse
var global_position_f: Vector2#guarda a posicao de quando solta o mouse
var mousehold: bool = false
var arrow_angle: float



func _physics_process(delta: float) -> void:
	_get_input()
	if _is_airborne:
		_velocity.y += gravity * delta
		move_and_slide(_velocity * max_speed)
		
func _get_input():
	if Input.is_action_just_pressed("click_left"):
		global_position_i = get_viewport().get_mouse_position()
		mousehold = true
		var point: Vector2
		point.x = 0
		point.y = 0
		arrow_angle = global_position_i.angle_to_point(point)
	if Input.is_action_just_released("click_left"):
		global_position_f = get_viewport().get_mouse_position()
		_velocity = calculate_impulse(global_position_i, global_position_f)
		launch_arrow(arrow_angle)

func launch_arrow(angle: float) -> void:
		ArrowNode.visible = true
		_is_airborne = true
		var parent = ArrowNode.get_parent().get_parent()
		parent.add_child(ArrowNode)
		
		
