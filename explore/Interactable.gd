extends Spatial
const STATE = preload("res://common/enums.gd").InteractionState

signal update_state

func interact():
	pass

func update_state(state):
	match state:
		STATE.REMOVED:
			queue_free()