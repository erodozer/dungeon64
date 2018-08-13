extends Node

class Skill:
	var name
	var combo
	var out
	var rank
	
	func _init(name, combo, out, rank):
		self.name = name
		self.combo = combo
		self.out = out
		self.rank = rank

	static func sort_by_rank(a, b):
		return a.rank > b.rank

var ALL = [
	Skill.new(
		"Magic 3s",
		[3,3,3],
		16,
		0
	),
	Skill.new(
		"Breaker",
		[7,1,2,4],
		30,
		4
	),
	Skill.new(
		"Hell Driver",
		[4,2,2],
		16,
		1
	),
	Skill.new(
		"Commando",
		[1,2,1,2,1],
		30,
		2
	),
	Skill.new(
		"Basic Math",
		[2,2,4],
		22,
		3
	),
	Skill.new(
		"Prime Rib",
		[1, 3, 5, 7],
		43,
		5
	)
]

var RANKED = ALL.duplicate()

func _ready():
	RANKED.sort_custom(Skill, "sort_by_rank")