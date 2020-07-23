extends Node2D

func _on_pickup_shield_body_entered(body: Node) -> void:
	print("scudo")
	queue_free()
