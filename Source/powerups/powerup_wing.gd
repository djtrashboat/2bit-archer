extends Node2D

func _on_pickup_wing_area_entered(area: Area2D) -> void:
	if area.name == "pickuper":
		queue_free()
