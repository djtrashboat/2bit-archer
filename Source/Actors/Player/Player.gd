extends "res://Source/Actors/Actor.gd"


var global_position_i: Vector2#guarda a posicao do clique do mouse
var global_position_f: Vector2#guarda a posicao de quando solta o mouse
onready var arrow_position_i: Vector2 = get_viewport().get_mouse_position()#guarda a posicao do clique do mouse
onready var arrow_position_f: Vector2 = get_viewport().get_mouse_position()#guarda a posicao de quando solta o mouse
const Arrow_Projectile = preload("res://Source/Actors/Player/Arrow.tscn")

var enable_mov: bool #se true o player pode comandar o personagem
var populo: bool = false
var mousehold: bool = false
var mouserelease: bool = false
var is_shielded: bool = false
var is_winged: bool = false
var extra_jump: bool = false
var can_shoot: bool = true

func _physics_process(delta: float) -> void:
	_velocity.y += gravity * delta#aplicando a gravidade
	if $ceilingcast.is_colliding():#detecta se o player esta no teto
		_velocity.y = 20 #max(_velocity.y, -_velocity.y) * 0.3#se o player estiver no teto ele ganha velocidade em y para cair e nao grudar la
	elif is_on_wall():#bounce bounce (on walls)
		_velocity.x *= -0.3#coeficiente de bounce
		enable_mov = true#quando o player bate na parede, ele ganha o comando de volta
		if is_winged:
			extra_jump = true
	if enable_mov:#os comandos so funcionam se enablemov for true
		_get_input()
	move_and_slide(_velocity * _speed)#vrummmm
	#if can_shoot:
	_get_arrow_strength()#chama o input da flecha


func _get_input():
	if Input.is_action_just_pressed("click_right"):#guarda a posicao do clique do mouse
		#global_position_i = get_global_mouse_position()
		global_position_i = get_viewport().get_mouse_position()
		mousehold = true
	if Input.is_action_just_released("click_right"):#guarda a posicao de quando solta o mouse
		#global_position_f = get_global_mouse_position()
		global_position_f = get_viewport().get_mouse_position()
		_velocity = calculate_impulse(global_position_i, global_position_f)#aplica o impulso a velocidade assim que o player solta o mouse
		if extra_jump:
			extra_jump = false
		else:
			enable_mov = false#assim que o player aplica o impulso, ele perde o controle do personagem
		mousehold = false
		populo = false


func _get_arrow_strength():#pega o input do mouse_left e guarda as variaveis
	if Input.is_action_just_pressed("click_left"):#guarda a posicao do clique do mouse
		arrow_position_i = get_viewport().get_mouse_position()
		$bownarrow.show()
	if Input.is_action_just_released("click_left"):#guarda a posicao de quando solta o mouse
		arrow_position_f = get_viewport().get_mouse_position()
		$bownarrow.hide()
		if can_shoot:
			spawn_arrow()#arrow goes woosh
			can_shoot = false
			$arrow_delay.start()



func _update():
	if !mousehold:
		play_animation(_velocity)
		$Camera2D/ScreenShake/Frequency.stop()
	else:
		$Camera2D/ScreenShake.start()
		$AnimatedSprite.play("populo")
	$bownarrow.rotation = (arrow_position_i - get_viewport().get_mouse_position()).angle()

func _process(delta: float) -> void:
	_update()

func spawn_arrow():#woosh the arrow
	add_child(Arrow_Projectile.instance())
	$Arrow._set_pos(global_position)
	$Arrow.launch_arrow(arrow_position_i - arrow_position_f)#chama launch arrow do outro script

func play_animation(velocity: Vector2) -> void:#toca animacao
	if can_shoot:
		$bownarrow.frame = 0
	else:
		$bownarrow.frame = 1
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


func _on_EnemyDetector_body_entered(body: Node) -> void:
	if is_winged:
		is_winged = false
		extra_jump = false
		$wings.hide()
	elif is_shielded:
		is_shielded = false
		$bubble.hide()
	else:
		KillPlayer()
		

func _on_pickuper_area_entered(area: Area2D) -> void:
	if area.name == "pickup_shield":
		is_shielded = true
		$bubble.show()
	if area.name == "pickup_wing":
		is_winged = true
		extra_jump = true
		$wings.show()


func _on_arrow_delay_timeout() -> void:
	can_shoot = true


func KillPlayer() -> void:
		PlayerData.deaths += 1
		queue_free()
