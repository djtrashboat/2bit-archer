extends Node2D

#func _on_pickup_shield_body_entered(body: Node) -> void:
#	queue_free()


func _on_pickup_shield_area_entered(area: Area2D) -> void:
	if area.name == "pickuper":
		queue_free()
