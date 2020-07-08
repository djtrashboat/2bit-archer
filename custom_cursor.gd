extends Node2D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$Sprite/AnimatedSprite.play("default")
	
func _process(delta: float) -> void:
	$Sprite.position = get_global_mouse_position()
	if Input.is_action_just_pressed("click_right"):
		$Sprite/AnimatedSprite.play("clicking")
	if Input.is_action_just_released("click_right"):
		$Sprite/AnimatedSprite.play("default")
