extends Node

const HAND_POSITIONS = {
	#SELECTION ROW
	Vector2(0, -2): Vector2(104, 2),
	Vector2(1, -2): Vector2(192, 2),
	#BOX ROW
	Vector2(0, -1): Vector2(145, -4),
	Vector2(1, -1): Vector2(145, -4),
	Vector2(2, -1): Vector2(145, -4),
	Vector2(3, -1): Vector2(145, -4),
	Vector2(4, -1): Vector2(145, -4),
	Vector2(5, -1): Vector2(145, -4),
	#FIRST ROW
	Vector2.ZERO: Vector2(84, 20),
	Vector2(1, 0): Vector2(108, 20),
	Vector2(2, 0): Vector2(132, 20),
	Vector2(3, 0): Vector2(156, 20),
	Vector2(4, 0): Vector2(180, 20),
	Vector2(5, 0): Vector2(204, 20),
	#SECOND ROW
	Vector2(0, 1): Vector2(84, 42),
	Vector2(1, 1): Vector2(108, 42),
	Vector2(2, 1): Vector2(132, 42),
	Vector2(3, 1): Vector2(156, 42),
	Vector2(4, 1): Vector2(180, 42),
	Vector2(5, 1): Vector2(204, 42),
	#THIRD ROW
	Vector2(0, 2): Vector2(84, 64),
	Vector2(1, 2): Vector2(108, 64),
	Vector2(2, 2): Vector2(132, 64),
	Vector2(3, 2): Vector2(156, 64),
	Vector2(4, 2): Vector2(180, 64),
	Vector2(5, 2): Vector2(204, 64),
	#FOURTH ROW
	Vector2(0, 3): Vector2(84, 86),
	Vector2(1, 3): Vector2(108, 86),
	Vector2(2, 3): Vector2(132, 86),
	Vector2(3, 3): Vector2(156, 86),
	Vector2(4, 3): Vector2(180, 86),
	Vector2(5, 3): Vector2(204, 86),
	#FIFTH ROW
	Vector2(0, 4): Vector2(84, 108),
	Vector2(1, 4): Vector2(108, 108),
	Vector2(2, 4): Vector2(132, 108),
	Vector2(3, 4): Vector2(156, 108),
	Vector2(4, 4): Vector2(180, 108),
	Vector2(5, 4): Vector2(204, 108),
	#PARTY
	Vector2(6, 0): Vector2(88, 36),
	Vector2(6, 1): Vector2(137, -12),
	Vector2(6, 2): Vector2(137, 12),
	Vector2(6, 3): Vector2(137, 36),
	Vector2(6, 4): Vector2(137, 60),
	Vector2(6, 5): Vector2(137, 84),
	Vector2(6, 6): Vector2(137, 115),
}

var boxes_background = {
	1: {
		"texture": preload("res://Assets/UI/Boxes/box1.png"),
		"name": "BOX 1"
	},
	2: {
		"texture": preload("res://Assets/UI/Boxes/box2.png"),
		"name": "BOX 2"
	},
	3: {
		"texture": preload("res://Assets/UI/Boxes/box3.png"),
		"name": "BOX 3"
	},
	4: {
		"texture": preload("res://Assets/UI/Boxes/box4.png"),
		"name": "BOX 4"
	},
	5: {
		"texture": preload("res://Assets/UI/Boxes/box5.png"),
		"name": "BOX 5"
	},
	6: {
		"texture": preload("res://Assets/UI/Boxes/box6.png"),
		"name": "BOX 6"
	},
	7: {
		"texture": preload("res://Assets/UI/Boxes/box7.png"),
		"name": "BOX 7"
	},
	8: {
		"texture": preload("res://Assets/UI/Boxes/box8.png"),
		"name": "BOX 8"
	},
	9: {
		"texture": preload("res://Assets/UI/Boxes/box9.png"),
		"name": "BOX 9"
	},
	10: {
		"texture": preload("res://Assets/UI/Boxes/box10.png"),
		"name": "BOX 10"
	},
	11: {
		"texture": preload("res://Assets/UI/Boxes/box11.png"),
		"name": "BOX 11"
	},
	12: {
		"texture": preload("res://Assets/UI/Boxes/box12.png"),
		"name": "BOX 12"
	},
	13: {
		"texture": preload("res://Assets/UI/Boxes/box13.png"),
		"name": "BOX 13"
	},
	14: {
		"texture": preload("res://Assets/UI/Boxes/box14.png"),
		"name": "BOX 14"
	},
	15: {
		"texture": preload("res://Assets/UI/Boxes/box15.png"),
		"name": "BOX 15"
	}
}

const BOXES_SLOTS = {
	#FIRST ROW
	0: Vector2.ZERO,
	1: Vector2(24, 0),
	2: Vector2(48, 0),
	3: Vector2(72, 0),
	4: Vector2(96, 0),
	5: Vector2(120, 0),
	#SECOND ROW
	6: Vector2(0, 22),
	7: Vector2(24, 22),
	8: Vector2(48, 22),
	9: Vector2(72, 22),
	10: Vector2(96, 22),
	11: Vector2(120, 22),
	#THRID ROW
	12: Vector2(0, 44),
	13: Vector2(24, 44),
	14: Vector2(48, 44),
	15: Vector2(72, 44),
	16: Vector2(96, 44),
	17: Vector2(120, 44),
	#FOURTH ROW
	18: Vector2(0, 66),
	19: Vector2(24, 66),
	20: Vector2(48, 66),
	21: Vector2(72, 66),
	22: Vector2(96, 66),
	23: Vector2(120, 66),
	#FIFTH ROW
	24: Vector2(0, 88),
	25: Vector2(24, 88),
	26: Vector2(48, 88),
	27: Vector2(72, 88),
	28: Vector2(96, 88),
	29: Vector2(120, 88),
}

# 15 BOXES
var boxes_array = [
	get_empty_box(),
	get_empty_box(),
	get_empty_box(),
	get_empty_box(),
	get_empty_box(),
	get_empty_box(),
	get_empty_box(),
	get_empty_box(),
	get_empty_box(),
	get_empty_box(),
	get_empty_box(),
	get_empty_box(),
	get_empty_box(),
	get_empty_box(),
	get_empty_box()
];

func get_empty_box() -> Array:
	var array = [];
	array.resize(30);
	return array.duplicate();
