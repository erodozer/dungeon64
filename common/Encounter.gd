extends Node

var current_enemy = null

const ENEMIES = [
	"grundle",
	"grilla",
	"bat",
]

func _ready():
	randomize()
	ready_random()

func ready_random():
	"""
	Picks a new enemy to fight in the encounter
	"""
	var choice = ENEMIES[randi() % len(ENEMIES)]
	ready_enemy(choice)
	
func ready_enemy(enemy_name):
	"""
	Readies a specific enemy to fight, good for bosses
	"""
	current_enemy = load("res://assets/enemies/%s.tres" % enemy_name)
