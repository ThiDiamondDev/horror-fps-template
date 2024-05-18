extends StaticBody3D
class_name InteractionBase

func interact(_parameters=null):
	pass
func is_player_in_front(player,object) -> bool:
	var player_position = player.position
	var player_forward_vector: Vector3 = player.global_transform.basis.x
	var player_to_door: Vector3 = object.position - player_position

	# Normalize the player-to-door vector
	var player_to_door_normalized: Vector3 = player_to_door.normalized()
	
	# Calculate the dot product between player-to-door and player forward vector
	var dot_product: float = player_to_door_normalized.dot(player_forward_vector)

	# If dot product is positive, player is in front of the door
	return dot_product > 0
