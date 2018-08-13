extends Control

const CombatNodeType = preload("../common/enums.gd").CombatNodeType

export(bool) var touched
export(bool) var enemy_cell
export(bool) var player_cell
	
func set_node_type(type):
	match type:
		CombatNodeType.PLAYER:
			self_modulate = Color(1,1,1,1)
			player_cell = true
			enemy_cell = false
		CombatNodeType.ENEMY:
			self_modulate = Color(.5,.5,.5,1)
			enemy_cell = true
			player_cell = false
		_:
			self_modulate = Color(1,1,1,0)
			enemy_cell = false
			player_cell = false
