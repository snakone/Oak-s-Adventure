extends HouseController

@onready var poke_center_door: Area2D = $PokeCenterDoor;
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer;
@onready var joy_animation: AnimationPlayer = $Joy/AnimationPlayer;
@onready var anim_player: AnimationPlayer = $AnimationPlayer;
@onready var timer: Timer = $Timer;

var heal_anim_duration = 11;
var party: Array = [];
var party_size: int = 0;
var index = 0;
var healing = false

func _ready() -> void:
	super();
	check_out_scene();
	party = PARTY.get_party();
	party_size = party.size();
	GLOBAL.connect("selection_value_select", _on_selection_value_select);

func handle_heal() -> void:
	if(healing): return;
	healing = true;
	party = PARTY.get_party();
	party_size = party.size();
	await GLOBAL.timeout(0.2);
	GLOBAL.start_dialog.emit(24);
	joy_animation.play("HealPokemon");
	var anim_name = "PokeballHeal_" + str(party_size);
	anim_player.play(anim_name);
	await GLOBAL.timeout(heal_anim_duration);
	PARTY.healh_party_pokemon();
	BOXES.healh_boxes_pokemon();
	GLOBAL.start_dialog.emit(25);
	await GLOBAL.close_dialog;
	await GLOBAL.timeout(0.2);
	healing = false;

func start_timer(_show_poke = true) -> void:
	timer.start();

func stop_timer() -> void: 
	timer.stop();
	await GLOBAL.timeout(timer.wait_time);
	index = 0;

func play_heal_sound() -> void:
	audio.stream = LIBRARIES.SOUNDS.POKEMON_HEAL;
	audio.play();

func _on_timer_timeout() -> void:
	audio.stop();
	audio.stream = LIBRARIES.SOUNDS.BATTLE_BALL_SHAKE;
	audio.play();

func _on_selection_value_select(value: int, category) -> void:
	if(category != ENUMS.SelectionCategory.HEAL): return;
	match value:
		int(ENUMS.BinaryOptions.YES): handle_heal();

func check_out_scene() -> void:
	if(self.name in LIBRARIES.MAPS.CONNECTIONS &&
		MAPS.last_map in LIBRARIES.MAPS.CONNECTIONS[self.name]): 
			poke_center_door.spawn_position = LIBRARIES.MAPS.CONNECTIONS[self.name][MAPS.last_map];
