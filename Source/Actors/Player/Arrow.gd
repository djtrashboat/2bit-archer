extends Actor

var is_airborne = false

func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	if is_airborne:
		_arrow_velocity.y += gravity * delta
		move_and_slide(_arrow_velocity * max_speed)
	
	


	
