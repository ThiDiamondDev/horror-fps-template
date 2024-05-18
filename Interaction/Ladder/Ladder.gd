extends InteractionBase

class_name Ladder

@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var position_reference: Node3D = $PlayerPositionReference
var height

func _ready():
	var aabb = mesh.get_aabb()
	height = aabb.size.y
	
func interact(player=null):
	if not is_player_in_front(player,self):
		player.get_parent().set_on_ladder(true,height,position_reference)
