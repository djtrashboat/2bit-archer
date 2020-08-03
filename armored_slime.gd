extends "res://Source/Actors/enemys/enemy.gd"

# Constants
export var directionfrequency: int = 5#de quantos em quantos pulos ele muda de direcao
var changedirectionin: int
export var initial_direction: int = 1#se 1, ele comeca para a direita, se -1 ele comeca para a esquerda
export var jump_timer = 1.0#de quanto em quanto tempo ele pula
export var base_Slime_score: = 100 #base score for slime
#######################


func _on_arrow_detector_area_entered(area: Area2D) -> void:
	if area.name == "ArrowCol":
		die()

func _on_Timer_timeout() -> void:#no final do timer, o slime pula
	_jump()#go wush

func _ready():
	$Timer.wait_time = jump_timer#o tempo sera igual ao exportado
	$Timer.start()#o tiemer eh iniciado
	changedirectionin = directionfrequency

func _physics_process(delta: float) -> void:
	_velocity.y += gravity * delta#aplicando a gravidade
	if is_on_wall():#bounce effect
		_velocity.x *= -0.3
	move_and_slide(_velocity * _speed)#mov

func _jump():
	_velocity = -_speed * 8#velocidade do pulo, 8 eh um balanco bom (src: trust me m8)
	_velocity.x *= initial_direction#multiplica a v.x pela direcao
	changedirectionin -= 1#decrementa a variavel, que em 0, faz o slime trocar de direcao
	if changedirectionin == 0:
		initial_direction *= -1#muda a direcao
		changedirectionin = directionfrequency#reinstancia a variavel

#func _process(delta: float) -> void:
#	_update()

#func _update():
#	pass
func die():
	queue_free()
	PlayerData.score += base_Slime_score



func _on_enemy_shield1_area_entered(area: Area2D) -> void:
	if area.name == "ArrowCol":
		$shield1.queue_free()
func _on_enemy_shield2_area_entered(area: Area2D) -> void:
	if area.name == "ArrowCol":
		$shield2.queue_free()
