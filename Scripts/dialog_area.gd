extends Area2D;
@onready var object = $".."

var dialog: Array;

func _ready():
	dialog = DIALOG.get_dialog(object.name, object.location);
