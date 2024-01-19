extends Area2D;
@onready var object = $".."

var talk_direction: GLOBAL.Directions;
var dialog_id: int;

func _ready():
	talk_direction = object.talk_direction;
	dialog_id = object.id;
