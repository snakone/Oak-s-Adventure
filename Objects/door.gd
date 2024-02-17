extends Area2D

@export_file("*.tscn") var next_scene: String;
@export var enter_direction = GLOBAL.Directions.UP;
@export var spawn_position = Vector2.ZERO;
@export var animated = true;
@export var sprite_image: Texture;
@export var type: GLOBAL.DoorType;
@export var DOOR_ENTER: AudioStream = preload("res://Assets/Sounds/Door enter.ogg");
@export var DOOR_EXIT: AudioStream = preload("res://Assets/Sounds/Door exit.ogg");
@export var category: GLOBAL.DoorCategory = GLOBAL.DoorCategory.DOOR;
@export var shared: bool = false;

@onready var anim_player = $AnimationPlayer;
@onready var sprite_2d = $Sprite2D;
@onready var audio = $AudioStreamPlayer;

var can_be_opened = false;
var door_open_direction: Vector2;

func _ready():
	door_open_direction = GLOBAL.DIRECTIONS[enter_direction];
	sprite_2d.texture = sprite_image;
	check_close_animation();

func _on_body_entered(body) -> void:
	check_direction();
	if(can_be_opened && body.name == "Oak"):
		if(category == GLOBAL.DoorCategory.TUNNEL): body.visible = false;
		MAPS.spawn_position = spawn_position;
		if(type == GLOBAL.DoorType.IN): audio.stream = DOOR_ENTER;
		else:
			audio.stream = DOOR_EXIT;
			audio.play();
		if(animated): anim_player.play("Open");
		else:
			audio.play();
			enter_house();
	elif(!can_be_opened): GLOBAL.emit_signal("cant_enter_door", self);

func check_direction() -> void:
	if(door_open_direction != Vector2.ZERO):
		can_be_opened = door_open_direction == GLOBAL.last_direction && (
			next_scene != "" || shared);

func enter_house() -> void:
	await GLOBAL.timeout(.1);
	if(shared && type == GLOBAL.DoorType.OUT): next_scene = MAPS.get_next_map();
	if(next_scene != ""):
		if(type == GLOBAL.DoorType.IN && shared): 
			MAPS.last_map = MAPS.get_map_name(true);
		GLOBAL.last_used_door = self.name;
		get_node("/root/SceneManager").transition_to_scene(next_scene);

func check_close_animation() -> void:
	if(GLOBAL.last_used_door == self.name && type == GLOBAL.DoorType.IN):
		await GLOBAL.timeout(0.3);
		anim_player.play("Close");
		GLOBAL.last_used_door = "";
