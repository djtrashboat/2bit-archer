extends Control

onready var scene_tree: = get_tree()
onready var pause_overlay: ColorRect = get_node("PauseOverlay")
var paused: = false setget SetIsPaused, GetIsPaused
onready var score: Label = get_node("Label")
onready var pause_title: Label = get_node("PauseOverlay/Title")


signal game_paused

func _ready() -> void:
	PlayerData.connect("score_updated", self, "update_interface")
	PlayerData.connect("player_died", self, "_PlayerData_player_died")
	update_interface()
	
func _PlayerData_player_died() -> void:
	self.paused = true
	pause_title.text = "You died"
	
func update_interface() -> void:
	score.text = "Score: %s" % PlayerData.score
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		self.paused = not paused
		scene_tree.set_input_as_handled()

func SetIsPaused(value: bool) -> void:
	paused = value
	scene_tree.paused = value
	pause_overlay.visible = value
	emit_signal("game_paused")

func GetIsPaused() -> bool:
	return paused
