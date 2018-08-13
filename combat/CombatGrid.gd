extends Control

const CombatNodeTypes = preload("res://common/enums.gd").CombatNodeType

const MOUSE_INPUT_ENABLED = false

export(bool) var enabled = false
var dragging = false
var last_touched = null
var touched = 0

const adjacents = {
	"7": ["8", "5", "4"],
	"8": ["7", "9", "4", "5", "6"],
	"9": ["8", "5", "6"],
	"4": ["7", "8", "5", "2", "1"],
	"5": ["1", "2", "3", "4", "6", "7", "8", "9"],
	"6": ["8", "9", "5", "2", "3"],
	"1": ["4", "5", "2"],
	"2": ["1", "4", "5", "6", "3"],
	"3": ["2", "5", "6"],
}

signal touched
signal next_puzzle
signal completed_attack(amount)
signal incompleted_attack(amount)

func _ready():
	randomize()
	setup_grid()

func setup_grid():
	dragging = false
	last_touched = null
	
	for child in $Grid/Cells.get_children():
		child.touched = false
		child.set_node_type(CombatNodeTypes.EMPTY)
	
	get_node("Grid/Cells/" + String(randi() % 9 + 1)).set_node_type(CombatNodeTypes.ENEMY)
	var node = get_node("Grid/Cells/" + String(randi() % 9 + 1))
	while node.enemy_cell:
		node = get_node("Grid/Cells/" + String(randi() % 9 + 1))
	node.set_node_type(CombatNodeTypes.PLAYER)
	
	# clear line
	while $Grid/Traced.points.size() > 0:
		$Grid/Traced.remove_point(0)
	touched = -1
	_set_last_touched(node)
	
func _set_last_touched(cell):
	if cell == null:
		return

	var rect = cell.get_rect()
	var center = Vector2(
		rect.position.x + rect.size.x / 2,
		rect.position.y + rect.size.y / 2
	)
	$Grid/Traced.add_point(center)
	last_touched = cell
	cell.touched = true
	emit_signal("touched")
	touched += 1
	
	if cell.enemy_cell or not _can_move():
		if $AttackTimer.time_left > 0:
			if cell.enemy_cell:
				emit_signal("completed_attack", touched)
			else:
				# incompleted attacks don't count towards damage
				emit_signal("incompleted_attack", touched)
			emit_signal("next_puzzle")
	
func _can_move():
	if last_touched == null:
		return true

	var adj = adjacents[last_touched.name]
	for child in adj:
		if not get_node("Grid/Cells/" + child).touched:
			return true
	return false
	
func is_adjacent(cell):
	return cell.name in adjacents[last_touched.name]
	
func _mouse_in_cells(position):
	for child in $Cells.get_children():
		if child.get_global_rect().has_point(position):
			if last_touched == null:
				return child
			if last_touched == child:
				return child	
			if is_adjacent(child):
				return child
				
	return null

func _unhandled_key(event):
	if not enabled:
		return
	
	if MOUSE_INPUT_ENABLED:		
		if event is InputEventMouseButton:
			if event.is_pressed():
				var cell = _mouse_in_cells(event.position)
				if cell != last_touched:
						_set_last_touched(cell)
						dragging = true
			if not event.is_pressed():
				dragging = false
				emit_signal("next_puzzle")
			return
			
		if dragging and event is InputEventMouseMotion:
			var cell = _mouse_in_cells(event.position)
			if cell != null and !cell.touched:
				if last_touched == null or \
				   (last_touched != cell and is_adjacent(cell)):
					_set_last_touched(cell)
			return

func _unhandled_key_input(event):			
	if dragging or not enabled:
		return

	for i in range(1, 10):
		if event.is_action_pressed("grid_%d" % i):
			var cell = get_node("Grid/Cells/%d" % i)
			if cell != null \
				and !cell.touched \
				and last_touched != cell \
				and is_adjacent(cell):
				_set_last_touched(cell)
			return

func _on_AttackTimer_timeout():
	enabled = false

