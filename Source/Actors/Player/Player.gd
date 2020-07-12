extends "res://Source/Actors/Actor.gd"

onready var ArrowNode := get_node("Arrow")

var global_position_i: Vector2#guarda a posicao do clique do mouse
var global_position_f: Vector2#guarda a posicao de quando solta o mouse
var global_arrow_position_i: Vector2
var global_arrow_position_f: Vector2
var arrow_angle: float


var enable_mov: bool #se true o player pode comandar o personagem
var populo: bool = false
var mousehold: bool = false
var mouserelease: bool = false

func _physics_process(delta: float) -> void:
	_velocity.y += gravity * delta#aplicando a gravidade
	if $ceilingcast.is_colliding():#detecta se o player esta no teto
		_velocity.y = 20 #max(_velocity.y, -_velocity.y) * 0.3#se o player estiver no teto ele ganha velocidade em y para cair e nao grudar la
	elif is_on_wall():#bounce bounce (on walls)
		_velocity.x *= -0.3#coeficiente de bounce
		enable_mov = true#quando o player bate na parede, ele ganha o comando de volta
	if enable_mov:#os comandos so funcionam se enablemov for true
		_get_input()
	move_and_slide(_velocity * max_speed)#vrummmm
	
	
	
	
	#if !populo:
	#	play_animation(_velocity)#toca animacao
	
func calculate_impulse(vi: Vector2, vf: Vector2) -> Vector2:#calcula o impulso a partir das cordenadas do mouse
	var impulse: Vector2
	impulse = (vi - vf)
	return impulse

func _get_input():
	if Input.is_action_just_pressed("click_right"):#guarda a posicao do clique do mouse
		#global_position_i = get_global_mouse_position()
		global_position_i = get_viewport().get_mouse_position()
		#$AnimatedSprite.play("populo")
		mousehold = true
	if Input.is_action_just_released("click_right"):#guarda a posicao de quando solta o mouse
		#global_position_f = get_global_mouse_position()
		global_position_f = get_viewport().get_mouse_position()
		_velocity = calculate_impulse(global_position_i, global_position_f)#aplica o impulso a velocidade assim que o player solta o mouse 
		enable_mov = false#assim que o player aplica o impulso, ele perde o controle do personagem
		#$Camera2D/ScreenShake/Frequency.stop()
		mousehold = false
		populo = false
	if Input.is_action_just_pressed("click_left"):
		global_arrow_position_i = get_viewport().get_mouse_position()
		mousehold = true
		var point: Vector2
		point.x = 0
		point.y = 0
		arrow_angle = global_arrow_position_i.angle_to_point(point)
	if Input.is_action_just_released("click_left"):
		global_arrow_position_f = get_viewport().get_mouse_position()
		_arrow_velocity = calculate_impulse(global_arrow_position_i, global_arrow_position_f)
		launch_arrow(arrow_angle)
		
		
func launch_arrow(angle: float) -> void:
		ArrowNode.visible = true
		
	
	
func _update():
	if !mousehold:
		play_animation(_velocity)
		$Camera2D/ScreenShake/Frequency.stop()
	else:
		$Camera2D/ScreenShake.start()
		$AnimatedSprite.play("populo")

func _process(delta: float) -> void:
	_update()

func play_animation(velocity: Vector2) -> void:#toca animacao
	if is_on_wall():# and (velocity.x< (0.1) or velocity.x> (-0.1)):# ***o player detecta o chao como parede***, #sem a segudanda parte ele ficava girando o sprite sem parar
		$AnimatedSprite.play("idle")
	elif velocity.y > 0.0:
		if velocity.x == 0.0:
			$AnimatedSprite.flip_h = false
			if enable_mov:#se true, toca a animacao com outline
				$AnimatedSprite.play("fall_1")
			else: $AnimatedSprite.play("fall_0")#se false, toca a animacao sem outline
		elif velocity.x < 0.0:
			$AnimatedSprite.flip_h = true
			if enable_mov:#se true, toca a animacao com outline
				$AnimatedSprite.play("fall_1")
			else: $AnimatedSprite.play("fall_0")#se false, toca a animacao sem outline
		elif velocity.x > 0.0:
			$AnimatedSprite.flip_h = false
			if enable_mov:#se true, toca a animacao com outline
				$AnimatedSprite.play("fall_1")
			else: $AnimatedSprite.play("fall_0")#se false, toca a animacao sem outline
	elif velocity.y < 0.0:
		if velocity.x > 0.0:
			$AnimatedSprite.flip_h = false
			if enable_mov:
				$AnimatedSprite.play("jump_1")
			else: $AnimatedSprite.play("jump_0")
		elif velocity.x < 0.0:
			$AnimatedSprite.flip_h = true
			if enable_mov:
				$AnimatedSprite.play("jump_1")
			else: $AnimatedSprite.play("jump_0")
		else:
			if enable_mov:
				$AnimatedSprite.play("jump_1")
			else: $AnimatedSprite.play("jump_0")
