extends Area2D;
@onready var object = $".."

var dialog: Array;
var talk_direction: GLOBAL.Directions;

func _ready():
	dialog = DIALOG.get_dialog(object.name, object.location);
	talk_direction = object.talk_direction;
