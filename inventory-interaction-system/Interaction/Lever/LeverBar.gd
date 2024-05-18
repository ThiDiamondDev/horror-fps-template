extends DragInteraction


func is_player_in_front(player,object) -> bool:
	
	var a =  super(player, get_parent())
	print(a)
	return a
