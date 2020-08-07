extends Node2D

export var base_Coin_score: = 100 #base score for coins

func _on_pickup_coin_area_entered(area: Area2D) -> void:
	if area.name == "pickuper":
		PlayerData.score += base_Coin_score
		queue_free()
