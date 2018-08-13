extends Spatial

const STATE = preload("res://common/enums.gd").InteractionState
const Interactable = preload("res://explore/Interactable.gd")

# level id to save in memory
export(String) var id

var _state = {
	"__treasure_found": 0,
}

func _exit_tree():
	"""
	Every time we dispose of a dungeon, we should save its state
	somewhere in memory so we can return to it.
	"""
	Player.dungeons[id] = _state.duplicate()
	
func _ready():
	"""
	Load this dungeon's state from memory if it exists
	"""
	var treasure_total = 0
	var count_treasure = not _state.has("__treasure_total")
	for child in $Items.get_children():
		if child is Interactable:
			if count_treasure and child.name.find("Treasure"):
				treasure_total += 1
			if child.name in _state:
			 	child.update_state(_state[child.name])
			else:
				_state[child.name] = STATE.PRESENT
			child.connect("update_state", self, "update_flag")
	if count_treasure:
		_state["__treasure_total"] = treasure_total

func _enter_tree():
	if id in Player.dungeons:
		_state = Player.dungeons[id].duplicate()

func update_flag(id, state):
	"""
	Update an object's state in the room
	"""
	_state[id] = state
	
	if id.find("Treasure") != -1 and state == STATE.REMOVED:
		_state["__treasure_found"] += 1
