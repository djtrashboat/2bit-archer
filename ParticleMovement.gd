extends AnimationPlayer
onready var line: = $"../draw line"

func _physics_process(delta: float) -> void:
	self.get_animation("JumpingSenoidAnimation").track_set_key_value(0, 0, Vector2(0,0))
	
