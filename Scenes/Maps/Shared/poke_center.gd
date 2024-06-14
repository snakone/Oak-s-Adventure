extends HouseController

@onready var poke_center_door: Area2D = $PokeCenterDoor;
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer;
@onready var joy_animation: AnimationPlayer = $Joy/AnimationPlayer;
@onready var anim_player: AnimationPlayer = $AnimationPlayer;
@onready var timer: Timer = $Timer;
@onready var poke_preview: Sprite2D = $HealAnimation/PokePreview;

const POKEMON_HEAL = preload("res://Assets/Sounds/pokemon heal.mp3");
const BATTLE_BALL_SHAKE = preload("res://Assets/Sounds/Battle ball shake.ogg");

var heal_anim_duration = 11;
var party: Array = [];
var party_size: int = 0;
var index = 0;

var npc_properties = [
	"texture",
	"position",
	"frames",
	"positive_limits",
	"negative_limits",
	"state",
	"can_left",
	"can_right",
	"can_up",
	"can_down",
	"interval",
	"dialog_id"
];

func _ready() -> void:
	super();
	check_out_scene();
	party = PARTY.get_party();
	party_size = party.size();
	GLOBAL.connect("selection_value_select", _on_selection_value_select);

func check_out_scene() -> void:
	if(self.name in MAPS.CONNECTIONS &&
		MAPS.last_map in MAPS.CONNECTIONS[self.name]): 
			poke_center_door.spawn_position = MAPS.CONNECTIONS[self.name][MAPS.last_map];

func handle_heal() -> void:
	if(GLOBAL.healing): return;
	GLOBAL.healing = true;
	party = PARTY.get_party();
	party_size = party.size();
	await GLOBAL.timeout(0.2);
	GLOBAL.start_dialog.emit(24);
	joy_animation.play("HealPokemon");
	var anim_name = "PokeballHeal_" + str(party_size);
	anim_player.play(anim_name);
	await GLOBAL.timeout(heal_anim_duration);
	PARTY.healh_party_pokemon();
	GLOBAL.start_dialog.emit(25);
	await GLOBAL.close_dialog;
	await GLOBAL.timeout(0.2);
	GLOBAL.healing = false;

func start_timer(_show_poke = true) -> void:
	timer.start();

func stop_timer() -> void: 
	timer.stop();
	await GLOBAL.timeout(timer.wait_time);
	index = 0;

func play_heal_sound() -> void:
	audio.stream = POKEMON_HEAL;
	audio.play();

func _on_timer_timeout() -> void:
	audio.stop();
	audio.stream = BATTLE_BALL_SHAKE;
	audio.play();

func _on_selection_value_select(value: int, category) -> void:
	if(category != GLOBAL.SelectionCategory.HEAL): return;
	match value:
		int(GLOBAL.BinaryOptions.YES): handle_heal();
