extends CanvasLayer

@onready var left: TouchScreenButton = $Buttons/Left;
@onready var top: TouchScreenButton = $Buttons/Top;
@onready var right: TouchScreenButton = $Buttons/Right;
@onready var down: TouchScreenButton = $Buttons/Down;
@onready var a_button: TouchScreenButton = $"Buttons/A-Button";
@onready var b_button: TouchScreenButton = $"Buttons/B-Button";
@onready var start: TouchScreenButton = $Buttons/Start;
@onready var select: TouchScreenButton = $Buttons/Select;

@onready var active_a: TextureRect = $Active/A;
@onready var active_b: TextureRect = $Active/B;
@onready var active_right: TextureRect = $Active/Right;
@onready var active_left: TextureRect = $Active/Left;
@onready var active_top: TextureRect = $Active/Top;
@onready var active_down: TextureRect = $Active/Down;
@onready var active_start: TextureRect = $Active/Start;
@onready var active_select: TextureRect = $Active/Select;

func _ready():
	left.connect("pressed", _on_button_pressed.bind(left));
	top.connect("pressed", _on_button_pressed.bind(top));
	right.connect("pressed", _on_button_pressed.bind(right));
	down.connect("pressed", _on_button_pressed.bind(down));
	a_button.connect("pressed", _on_button_pressed.bind(a_button));
	b_button.connect("pressed", _on_button_pressed.bind(b_button));
	start.connect("pressed", _on_button_pressed.bind(start));
	select.connect("pressed", _on_button_pressed.bind(select));
	
	left.connect("released", _on_button_released.bind(left));
	top.connect("released", _on_button_released.bind(top));
	right.connect("released", _on_button_released.bind(right));
	down.connect("released", _on_button_released.bind(down));
	a_button.connect("released", _on_button_released.bind(a_button));
	b_button.connect("released", _on_button_released.bind(b_button));
	start.connect("released", _on_button_released.bind(start));
	select.connect("released", _on_button_released.bind(select));

func _on_button_pressed(button: TouchScreenButton):
	match button.name:
		'A-Button': active_a.visible = true;
		'B-Button': active_b.visible = true;
		'Right': active_right.visible = true;
		'Left': active_left.visible = true;
		'Top': active_top.visible = true;
		'Down': active_down.visible = true;
		'Start': active_start.visible = true;
		'Select': active_select.visible = true;

func _on_button_released(button: TouchScreenButton):
	match button.name:
		'A-Button': active_a.visible = false;
		'B-Button': active_b.visible = false;
		'Right': active_right.visible = false;
		'Left': active_left.visible = false;
		'Top': active_top.visible = false;
		'Down': active_down.visible = false;
		'Start': active_start.visible = false;
		'Select': active_select.visible = false;
