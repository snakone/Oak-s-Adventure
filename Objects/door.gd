extends Area2D

@export_file("*.tscn") var next_scene: String;
@export var enter_direction = GLOBAL.DIRECTIONS.UP;
@export var spawn_position = Vector2.ZERO;
@export var animated = true;
@export var sprite_image: Texture;
@export var type: DoorType;

@onready var animation_player = $AnimationPlayer;
@onready var sprite_2d = $Sprite2D;

enum DoorType { IN, OUT }

var can_be_opened = true;
var door_open_direction: Vector2;

func _ready():
	door_open_direction = GLOBAL.directions_array[enter_direction];
	sprite_2d.texture = sprite_image;
	check_close_animation();

func _on_body_entered(body) -> void:
	check_direction();
	if(can_be_opened && body.name == "Oak"):
		MAPS.spawn_position = spawn_position;
		if(animated): animation_player.play("Open");
		else: 
			await get_tree().create_timer(.2).timeout;
			enter_house();
	elif(!can_be_opened): GLOBAL.emit_signal("cant_enter_door", self);

func check_direction() -> void:
	if(door_open_direction != Vector2.ZERO):
		can_be_opened = door_open_direction == GLOBAL.last_player_direction && next_scene != "";

func enter_house() -> void:
	if(next_scene):
		GLOBAL.last_used_door = self.name;
		get_node("/root/SceneManager").transition_to_scene(next_scene);

func check_close_animation():
	if(GLOBAL.last_used_door == self.name && type == DoorType.IN):
		animation_player.play("Close");
		GLOBAL.last_used_door = "";
