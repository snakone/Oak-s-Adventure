extends HouseController

@onready var poke_center_door: Area2D = $PokeCenterDoor;
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer;
@onready var npc_player: AnimationPlayer = $NPC/AnimationPlayer
@onready var anim_player: AnimationPlayer = $AnimationPlayer;
@onready var timer: Timer = $Timer;
@onready var poke_preview: Sprite2D = $HealAnimation/PokePreview;

const POKEMON_HEAL = preload("res://Assets/Sounds/pokemon heal.mp3");
const BATTLE_BALL_SHAKE = preload("res://Assets/Sounds/Battle ball shake.ogg");

var heal_anim_duration = 11;
var party: Array = [];
var party_size: int = 0;
var show_screen_poke = true;
var index = 0;
var selection_category = GLOBAL.SelectionCategory.HEAL;

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
	await GLOBAL.timeout(0.2);
	GLOBAL.start_dialog.emit(24);
	npc_player.play("HealPokemon");
	anim_player.play("PokeballHeal");
	await GLOBAL.timeout(heal_anim_duration);
	PARTY.healh_party_pokemon();
	GLOBAL.start_dialog.emit(25);
	await GLOBAL.close_dialog;
	await GLOBAL.timeout(0.2);
	GLOBAL.healing = false;

func start_timer(show_poke = true) -> void:
	show_screen_poke = show_poke;
	timer.start();

func stop_timer() -> void: 
	timer.stop();
	await GLOBAL.timeout(timer.wait_time);
	poke_preview.texture = null;
	poke_preview.visible = false;
	index = 0;

func play_heal_sound() -> void:
	audio.stream = POKEMON_HEAL;
	audio.play();

func _on_timer_timeout() -> void:
	audio.stop();
	audio.stream = BATTLE_BALL_SHAKE;
	audio.play();
	#if(show_screen_poke):
		#var texture = party[index].data.party_texture;
		#poke_preview.visible = true;
		#poke_preview.texture = texture;
		#index += 1;

func _on_selection_value_select(value: int, category) -> void:
	if(category != selection_category): return;
	match value:
		int(GLOBAL.BinaryOptions.YES): handle_heal();
