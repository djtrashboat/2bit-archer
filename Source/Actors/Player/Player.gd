extends "res://Source/Actors/Actor.gd"


var global_position_i: Vector2#guarda a posicao do clique do mouse
var global_position_f: Vector2#guarda a posicao de quando solta o mouse
const Arrow_Projectile = preload("res://Source/Actors/Player/Arrow.tscn")

onready var arrow_position_i: Vector2 = get_viewport().get_mouse_position()#guarda a posicao do clique do mouse
onready var arrow_position_f: Vector2 = get_viewport().get_mouse_position()#guarda a posicao de quando solta o mouse
onready var gravitytemp = gravity#gravitytemp eh uma gravidade temporaria que recebe a gravidade constante no inicio da cena

var enable_mov: bool #se true o player pode comandar o personagem
#wooshed > var populo: bool = false#o player esta preparado paro o pulo
var mousehold: bool = false#eh true se o player esta segurando o botao do mouse
#wooshed > var mouserelease: bool = false
var is_shielded: bool = false#true se o player esta com escudo
var is_winged: bool = false#true se o player tem asas
var extra_jump: bool = false#quando o player tem asas, ele recebe um pulo extra
var can_shoot: bool = true#determina se o player pode atirar
var imune: bool = false#true se o player estiver imune

func _on_EnemyDetector_body_entered(body: Node) -> void:#quando o detector de inimigo intersecta com um corpo (marcado como inimigo)
	if !imune:#se nao estiver estiver imune
		take_damage()
		imune = true#se ele ainda nao morreu, depois de levar dano, torna-se imune por um tempo
		$dmg_delay.start()#comeca o timer pra deixar de ser imune

#pick power ups and interact with some areas
func _on_pickuper_area_entered(area: Area2D) -> void:
	if area.name == "pickup_shield":#se entrar na area do shield, pega o shield
		pickup_shield()
	if area.name == "pickup_wing":#se entrar na area da wing, pega a wing
		pickup_wing()
	if area.name == "sticky_wall_area":#se entrar na area da wall, ele gruda e vai caindo devagar
		stick_to_wall()# gravitytemp eh uma var temporaria, assim que ele sai dessa area gravitytemp recebe gravity (const)

#saindo da area (sticky_wall) a gravidade volta ao normal
func _on_pickuper_area_exited(area: Area2D) -> void:#saindo da area (sticky_wall) a gravidade volta ao normal
	gravitytemp = gravity

#no fim do time, o player pode atirar novamente
func _on_arrow_delay_timeout() -> void:
	can_shoot = true

#no fim da invencibilidade temporaria, o player pode levar dano novamente
func _on_dmg_delay_timeout() -> void:
	imune = false


#*******************************************
func _physics_process(delta: float) -> void:
	_velocity.y += gravitytemp * delta#aplicando a gravidade
	if $ceilingcast.is_colliding():#detecta se o player esta no teto
		_velocity.y = 20 #max(_velocity.y, -_velocity.y) * 0.3#se o player estiver no teto ele ganha velocidade em y para cair e nao grudar la
	elif is_on_wall():#bounce bounce (on walls)
		_velocity.x *= -0.3#coeficiente de bounce
		enable_mov = true#quando o player bate na parede, ele ganha o comando de volta
		if is_winged:#se ele estiver alado, ele tambem ganha seu pulo extra de volta
			extra_jump = true
	if enable_mov:#os comandos so funcionam se enablemov for true
		_get_input()
	move_and_slide(_velocity * _speed)#vrummmm
	#if can_shoot:
	#_get_arrow_strength()#chama o input da flecha
#*******************************************

#chamado todo frame
func _update():
	if !mousehold:#se o player nao esta segurando o botao do mouse
		play_animation(_velocity)#a animacao toca de acordo com a velocidade do player
		shake_stop()#a tela nao treme
	else:#se o player esta segurando o botao do mouse
		shake_screen()#a tela treme
		$AnimatedSprite.play("populo")#a animacao populo toca
	$bownarrow.rotation = (arrow_position_i - get_viewport().get_mouse_position()).angle()#roda o arco pro lugar certo
	_get_arrow_strength()

func _get_input():
	if Input.is_action_just_pressed("click_right"):#guarda a posicao do clique do mouse
		#global_position_i = get_global_mouse_position()
		global_position_i = get_viewport().get_mouse_position()
		mousehold = true
	if Input.is_action_just_released("click_right"):#guarda a posicao de quando solta o mouse
		#global_position_f = get_global_mouse_position()
		global_position_f = get_viewport().get_mouse_position()
		_velocity = calculate_impulse(global_position_i, global_position_f)#aplica o impulso a velocidade assim que o player solta o mouse
		if extra_jump:# se o player tem um pulo extra, ele perde esse pulo ao usa-lo
			extra_jump = false
		else:
			enable_mov = false#assim que o player aplica o impulso, ele perde o controle do personagem
		mousehold = false#quando solta o botao, mouse hold vira falso

#pega o input do mouse_left e guarda as variaveis
func _get_arrow_strength():
	if Input.is_action_just_pressed("click_left"):#guarda a posicao do clique do mouse
		arrow_position_i = get_viewport().get_mouse_position()
		show_bow()#mostra o arco
	
	if Input.is_action_just_released("click_left"):#guarda a posicao de quando solta o mouse
		arrow_position_f = get_viewport().get_mouse_position()
		hide_bow()#o arco desaaparece
		
		if can_shoot:#se pode atirar
			shoot_arrow()

#***
func _process(delta: float) -> void:
	_update()
#***

#woosh the arrow
func spawn_arrow():
	add_child(Arrow_Projectile.instance())
	$Arrow._set_pos(global_position)
	$Arrow.launch_arrow(arrow_position_i - arrow_position_f)#chama launch arrow do outro script

func take_damage():
	if is_winged:#perde as asas
			is_winged = false
			extra_jump = false
			$wings.hide()
	elif is_shielded:#ou perde o escudo
		is_shielded = false
		$bubble.hide()
	else:#ou morre
		KillPlayer()

#toca animacao
func play_animation(velocity: Vector2) -> void:
	#bow *********************
	if can_shoot:#se pode atirar, o arco fica com outline
		$bownarrow.frame = 0
	else:
		$bownarrow.frame = 1#se pode nao atirar, o arco fica sem outline
	#player *****************
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

#mata o player
func KillPlayer() -> void:
		PlayerData.deaths += 1
		queue_free()

func show_bow():
	$bownarrow.show()#mostra o arco

func hide_bow():
	$bownarrow.hide()

func shoot_arrow():
	spawn_arrow()#arrow goes woosh
	can_shoot = false#n pode mais atirar ate
	$arrow_delay.start()#o timer terminar

func shake_screen():
	$Camera2D/ScreenShake.start()

func shake_stop():
	$Camera2D/ScreenShake/Frequency.stop()

func pickup_shield():
	is_shielded = true
	$bubble.show()

func pickup_wing():
	is_winged = true
	extra_jump = true
	$wings.show()

func stick_to_wall():
	_velocity *= 0
	enable_mov = true
	gravitytemp *= 0.06
