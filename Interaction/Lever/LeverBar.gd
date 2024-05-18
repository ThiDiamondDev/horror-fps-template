extends DragInteraction


func is_player_in_front(_player,_object) -> bool:
	
	return super(_player, get_parent())
