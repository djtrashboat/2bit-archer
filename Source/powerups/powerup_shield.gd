extends Node2D

func _on_pickup_shield_body_entered(body: Node) -> void:
	queue_free()
