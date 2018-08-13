extends Panel

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var current_page = 0

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _set_page(page):
	for child in $Pages.get_children():
		child.visible = false
	current_page = page
	get_node("Pages/" + String(current_page)).visible = true
	$pager.text = "%d / %d" % [current_page, $Pages.get_child_count()]
	
func _prev_page():
	_set_page(max(1, current_page - 1))
	
func _next_page():
	_set_page(min($Pages.get_child_count(), current_page + 1))

func _unhandled_key_input(event):
	if event.is_action_pressed("help_button"):
		get_tree().paused = !get_tree().paused
		self.visible = !self.visible
		_set_page(1)
		get_tree().set_input_as_handled()
		return
		
	if not self.visible:
		return
		
	if event.is_action_pressed("ui_left"):
		_prev_page()
		get_tree().set_input_as_handled()
	elif event.is_action_pressed("ui_right"):
		_next_page()
		get_tree().set_input_as_handled()