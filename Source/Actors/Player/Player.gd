extends "res://Source/Actors/Actor.gd"

var global_position_i: Vector2#guarda a posicao do clique do mouse
var global_position_f: Vector2#guarda a posicao de quando solta o mouse
var enable_mov: bool#se true o player pode comandar o personagem

func _physics_process(delta: float) -> void:
	_velocity.y += gravity * delta#aplicando a gravidade
	if $ceilingcast.is_colliding():#detecta se o player esta no teto
		_velocity.y = 12#se o player estiver no teto ele ganha velocidade em y para cair e nao grudar la
	elif is_on_wall():#bounce bounce
		_velocity.x *= -0.3#coeficiente de bounce
		enable_mov = true#quando o player bate na parede, ele ganha o comando de volta
	if enable_mov:#os comandos so funcionam se enablemov for true
		if Input.is_action_just_pressed("click_right"):#guarda a posicao do clique do mouse
			global_position_i = get_global_mouse_position()
		if Input.is_action_just_released("click_right"):#guarda a posicao de quando solta o mouse
			global_position_f = get_global_mouse_position()
			_velocity = calculate_impulse()#aplica o impulso a velocidade assim que o player solta o mouse 
			enable_mov = false#assim que o player aplica o impulso, ele perde o controle do personagem
	move_and_slide(_velocity * max_speed)#vrummmm
	play_animation(_velocity)#toca animacao
	
func calculate_impulse() -> Vector2:#calcula o impulso a partir das cordenadas do mouse
	var impulse: Vector2
	impulse = (global_position_i - global_position_f)
	return impulse


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
