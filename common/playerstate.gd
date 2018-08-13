extends Node

const Direction = preload("res://common/enums.gd").Direction

# variable stats
var experience = 0
var currently_exploring = "dungeon_001"

# computed stats
var hp setget , _get_hp
var next_hp setget , _get_next_hp
var level setget , _get_level
var needed_to_level setget , _get_next_exp

signal pickup(ItemMessage)
signal end_reached # play when a dungeon has been completed

var inventory = []
"""
Memory of all dungeons explored and their valuables claimed
"""
var dungeons = {}
var keys = 0
var position = Vector3(0,0,0)
var facing = Direction.NORTH

func _ready():
	pass

func pickup_item(item):
	inventory.append(item)
	emit_signal("pickup", [item.description, item.name])

func _get_hp():
	"""
	Get hp the player should have when entering combat
	"""
	return 100 + 10 * _get_level()

func _get_next_hp():
	"""
	get amount of hp player will have after leveling up
	"""
	return 100 + 10 * (_get_level() + 1)
	
func _get_level():
	return 1

func _get_next_exp():
	return 100
