extends CanvasLayer

@onready var audio: AudioStreamPlayer = $AudioStreamPlayer;
@onready var sprite_2d: AnimatedSprite2D = $Specie/Container/Sprite2D;
@onready var cancel: RichTextLabel = $Cancel;

#INFO
@onready var poke_name: RichTextLabel = $Info/Name;
@onready var number: RichTextLabel = $Info/Number;
@onready var nature: RichTextLabel = $Info/Nature;
@onready var gender: Sprite2D = $Specie/Gender;
@onready var level: RichTextLabel = $Specie/Level;
@onready var specie_name: RichTextLabel = $Specie/Name;
@onready var description: RichTextLabel = $Info/Description;
@onready var pokeball: Sprite2D = $Specie/Pokeball;
@onready var title: RichTextLabel = $Title;
@onready var animation_player: AnimationPlayer = $Specie/AnimationPlayer;
@onready var specie: Node2D = $Specie;
@onready var specie_container: BoxContainer = $Specie/Container;
@onready var ground: TextureRect = $Specie/Ground;
@onready var shadow: Sprite2D = $Specie/Container/Shadow;
@onready var item: RichTextLabel = $Info/Item;

#SKILLS
@onready var hp: RichTextLabel = $Skills/HP;
@onready var attack: RichTextLabel = $Skills/Attack;
@onready var defense: RichTextLabel = $Skills/Defense;
@onready var sp_atk: RichTextLabel = $Skills/SP_Atk;
@onready var sp_def: RichTextLabel = $Skills/SP_Def;
@onready var speed: RichTextLabel = $Skills/Speed;
@onready var experience: RichTextLabel = $Skills/EXP;
@onready var next_exp: RichTextLabel = $Skills/Next_EXP;
@onready var ability: RichTextLabel = $Skills/Ability;
@onready var ability_desc: RichTextLabel = $Skills/Ability_Desc;

@onready var stat_key_to_node = {
	"ATK": attack,
	"DEF": defense,
	"S.ATK": sp_atk,
	"S.DEF": sp_def,
	"SPD": speed
}

@onready var type_1: Sprite2D = $Info/Types/Type1;
@onready var type_2: Sprite2D = $Info/Types/Type2;
@onready var hp_progress: TextureRect = $Skills/HP_Bar/Progress;
@onready var exp_progress: TextureRect = $Skills/EXP_Bar/Progress;

#MOVES
@onready var moves_info: Node2D = $Moves/Info
@onready var moves_marker: TextureRect = $Moves/RedMarker;
@onready var blue_marker: TextureRect = $Moves/BlueMarker
@onready var moves_cancel: RichTextLabel = $Moves/Cancel;
@onready var move_power: RichTextLabel = $Moves/Info/Power
@onready var move_accuracy: RichTextLabel = $Moves/Info/Accuracy
@onready var move_description: RichTextLabel = $Moves/Info/Description
@onready var poke_type_1: Sprite2D = $Moves/Pokemon_Info/Types/Type1
@onready var poke_type_2: Sprite2D = $Moves/Pokemon_Info/Types/Type2;
@onready var move_sprite_2d: Sprite2D = $Moves/Pokemon_Info/Sprite2D;
@onready var pokemon_info: Node2D = $Moves/Pokemon_Info;
@onready var poke_move_name: RichTextLabel = $Moves/Pokemon_Info/Name;
@onready var move_anim_player: AnimationPlayer = $Moves/AnimationPlayer
@onready var page: RichTextLabel = $Page;
@onready var move_background: TextureRect = $Moves/Background;
@onready var move_category: Sprite2D = $Moves/Info/Category;

const BACKGROUND_MOVES = preload("res://Assets/UI/Summary/background_moves.png");
const BACKGROUND_MOVES_SWITCH = preload("res://Assets/UI/Summary/background_moves_switch.png");

var moves_length;

@onready var view_list = {
	Views.INFO: {
		"node": $Info,
		"title": "POKéMON  INFO"
	},
	Views.SKILLS: {
		"node": $Skills,
		"title": "POKéMON  SKILLS"
	},
	Views.MOVES: {
		"node": $Moves,
		"title": "KNOWN  MOVES"
	}
}

enum Views { INFO, SKILLS, MOVES }
enum Moves { FIRST, SECOND, THIRD, FOURTH, CANCEL }

const default_cancel = "CANCEL";
var pokemon: Object;
var selected_view = int(Views.INFO);
var party: Array;
var selected_pokemon = 0;
var on_move_detail = false;
var on_switch_mode = false;
var selected_move = int(Moves.FIRST);
var last_switch_index = 0;

var current_moves = {};
var current_markers = {};

var moves_marker_position = {
	Moves.FIRST: Vector2(120, 18),
	Moves.SECOND: Vector2(120, 46),
	Moves.THIRD: Vector2(120, 74),
	Moves.FOURTH: Vector2(120, 102),
	Moves.CANCEL: Vector2(120, 130)
}

func _ready() -> void:
	pokemon = GLOBAL.summary_pokemon;
	selected_pokemon = GLOBAL.summary_index;
	party = PARTY.get_party();
	set_selected_pokemon(false, false);
	await get_tree().process_frame;
	specie_container.visible = true;

func _unhandled_input(event: InputEvent) -> void:
	if(
		(!event is InputEventKey &&
		!event is InputEventScreenTouch) ||
		GLOBAL.on_transition ||
		GLOBAL.dialog_open ||
		event.is_echo() ||
		!event.is_pressed() ||
		Input.is_action_just_pressed("menu")
	): return;
	#CLOSE
	if(Input.is_action_just_pressed("backMenu")): 
		close_summary();
		return;
	elif(Input.is_action_just_pressed("space")): input_move();
	#DOWN
	elif(
		Input.is_action_just_pressed("moveDown") || 
		Input.is_action_just_pressed("ui_down")): handle_DOWN();
	#UP
	elif(
		Input.is_action_just_pressed("moveUp") || 
		Input.is_action_just_pressed("ui_up")): handle_UP();
	#RIGHT
	elif(
		Input.is_action_pressed("moveRight") || 
		Input.is_action_pressed("ui_right")): handle_RIGHT();
	#LEFT
	elif(
		Input.is_action_pressed("moveLeft") || 
		Input.is_action_pressed("ui_left")): handle_LEFT();

func handle_RIGHT() -> void:
	if(selected_view == int(Views.MOVES) || on_move_detail): return;
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
	set_view_visibility(false);
	selected_view += 1;
	set_view_visibility(true);
	if(selected_view == int(Views.MOVES)):
		cancel.text = "DETAIL";
	else: cancel.text = default_cancel;

func handle_LEFT() -> void:
	if(selected_view == int(Views.INFO) || on_move_detail): return;
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
	set_view_visibility(false);
	selected_view -= 1;
	set_view_visibility(true);
	cancel.text = default_cancel;

func handle_DOWN() -> void:
	if(on_move_detail): 
		handle_move_DOWN();
		return;
	selected_pokemon += 1;
	if(selected_pokemon > party.size() - 1): selected_pokemon = 0;
	set_selected_pokemon();

func handle_UP() -> void:
	if(on_move_detail): 
		handle_move_UP();
		return;
	selected_pokemon -= 1;
	if(selected_pokemon < 0): selected_pokemon = party.size() - 1;
	set_selected_pokemon();

func handle_move_UP() -> void:
	var minus = 0;
	if(on_switch_mode): minus = 1;
	if(selected_move == 0): selected_move = moves_length - minus;
	else: selected_move -= 1;
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
	moves_marker.position = current_markers[selected_move];
	if(!on_switch_mode): blue_marker.position = current_markers[selected_move];
	if(selected_move != moves_length): get_move_info();
	else: reset_move_info();

func handle_move_DOWN() -> void:
	var minus = 0;
	if(on_switch_mode): minus = 1;
	selected_move += 1;
	if(selected_move > moves_length - minus): 
		selected_move = int(Moves.FIRST);
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
	moves_marker.position = current_markers[selected_move];
	if(!on_switch_mode): blue_marker.position = current_markers[selected_move];
	if(selected_move != moves_length): get_move_info();
	else: reset_move_info();

func set_selected_pokemon(sound = true, include = true) -> void:
	current_moves = {};
	current_markers = {};
	if(party[selected_pokemon] != null):
		if(sound): play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
		if(include): pokemon = party[selected_pokemon];
		animation_player.play("Bounce")
		set_pokemon_info();
		set_pokemon_skills();
		set_pokemon_moves();
		reset_move_info();

func check_if_can_close() -> void:
	if(on_switch_mode):
		move_anim_player.stop();
		on_switch_mode = false;
		play_audio(LIBRARIES.SOUNDS.GUI_MENU_CLOSE);
		return;
	elif(selected_view == int(Views.MOVES)):
		play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
		if(!on_move_detail): active_move_detail();
		else: reset_move_detail();
		return;
	close_summary();

func active_move_detail() -> void:
	on_move_detail = true;
	specie.visible = false;
	moves_info.visible = true;
	cancel.text = "SWITCH";
	page.text = "PICK";
	selected_move = int(Moves.FIRST);
	moves_marker.position = current_markers[selected_move];
	blue_marker.position = current_markers[selected_move];
	moves_marker.visible = true;
	reset_move_info();
	get_move_info();
	pokemon_info.visible = true;
	move_background.texture = BACKGROUND_MOVES_SWITCH;
	moves_cancel.visible = true;

func reset_move_detail() -> void:
	on_move_detail = false;
	specie.visible = true;
	moves_info.visible = false;
	cancel.text = "DETAIL";
	page.text = "PAGE";
	moves_marker.visible = false;
	blue_marker.visible = false;
	pokemon_info.visible = false;
	move_background.texture = BACKGROUND_MOVES;
	moves_cancel.visible = false;

func input_move() -> void:
	if(on_move_detail):
		if(selected_move != moves_length):
			if(!on_switch_mode):
				play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
				move_anim_player.play("Switch_Marker");
				on_switch_mode = true;
				blue_marker.visible = true;
				last_switch_index = selected_move;
			else:
				if(last_switch_index == selected_move):
					move_anim_player.stop();
					on_switch_mode = false;
					play_audio(LIBRARIES.SOUNDS.GUI_MENU_CLOSE);
				else: switch_move();
		else: check_if_can_close();
	else: check_if_can_close();

func switch_move() -> void:
	play_audio(LIBRARIES.SOUNDS.GUI_SEL_CURSOR);
	var old_move = pokemon.data.battle_moves[last_switch_index];
	var new_move = pokemon.data.battle_moves[selected_move];
	pokemon.data.battle_moves[selected_move] = old_move;
	pokemon.data.battle_moves[last_switch_index] = new_move;
	on_switch_mode = false;
	blue_marker.visible = false;
	blue_marker.position = current_markers[selected_move]; 
	moves_marker.visible = false;
	move_anim_player.stop();
	set_pokemon_moves();
	get_move_info();

func close_summary() -> void:
	if(on_switch_mode):
		blue_marker.visible = false;
		blue_marker.position = current_markers[selected_move];
	if(on_move_detail): 
		check_if_can_close();
		return;
	play_audio(LIBRARIES.SOUNDS.GUI_MENU_CLOSE);
	await GLOBAL.timeout(0.2);
	if(!GLOBAL.party_open):
		GLOBAL.on_overlay = false;
	GLOBAL.emit_signal("scene_opened", false, "CurrentScene/SummaryScreen");
	GLOBAL.summary_pokemon = null;
	GLOBAL.summary_index = 0;
	process_mode = Node.PROCESS_MODE_DISABLED;

func format_number(num: int) -> String:
	if(num < 10): return '00' + str(num);
	elif(num >= 10 && num < 100): return '0' + str(num);
	return str(num);

func convert_types(poke: Object) -> Array:
	var types = POKEDEX.get_pokemon_prop(poke.data.number, 'types')
	var type1_texture = MOVES.get_type_sprite(types[0]);
	var type2_texture = null;
	if(types.size() > 1): type2_texture = MOVES.get_type_sprite(types[1]);
	return [type1_texture, type2_texture];

func get_description() -> String:
	if("met" in pokemon.data && "met_level" in pokemon.data):
		return "Met in " + pokemon.data.met + " at Lv. " + str(pokemon.data.met_level);
	return "Obtained at mysterious place."

func set_view_visibility(val: bool) -> void:
	var view = view_list[int(selected_view)]; 
	view.node.visible = val;
	if(val): title.text = view.title;

#SETTERS
func set_pokemon_info() -> void:
	if(pokemon != null):
		poke_name.text = pokemon.name;
		poke_move_name.text = pokemon.name;
		sprite_2d.sprite_frames = pokemon.data.sprites.sprite_frames;
		sprite_2d.play("Front")
		sprite_2d.offset = pokemon.data.display.offset.summary.front;
		sprite_2d.scale = pokemon.data.display.scale.box;
		if("rotation" in pokemon.data.display):
			sprite_2d.rotation_degrees = pokemon.data.display.rotation;
		else: sprite_2d.rotation_degrees = 0;
		number.text = format_number(pokemon.data.number);
		nature.text = LIBRARIES.BATTLE.nature_strings[int(pokemon.data.nature)] + ' nature.';
		level.text = "Lv" + str(pokemon.data.level);
		specie_name.text = pokemon.name;
		description.text = get_description();
		pokeball.frame = 0;
		if("pokeball" in pokemon.data): 
			pokeball.frame = int(pokemon.data.pokeball);
		if("gender" in pokemon.data):
			gender.frame = pokemon.data.gender;
			gender.visible = true;
		else: 
			gender.visible = false;
			
		var types = convert_types(pokemon);
		type_1.texture = types[0];
		poke_type_1.texture = types[0];
		if(types.size() > 1):
			type_2.visible = true;
			type_2.texture = types[1];
			poke_type_2.visible = true;
			poke_type_2.texture = types[1];
		#GROUND
		ground.texture = LIBRARIES.POKEDEX.habitat_ground[pokemon.data.search.category];
		#SHADOW
		if("shadow" in pokemon.data.specie):
			shadow.visible = true;
			shadow.texture = BATTLE.get_shadow_texture(pokemon.data);
			shadow.offset = pokemon.data.display.offset.summary.shadow;
		else: shadow.visible = false;
		#HELD ITEM
		if(pokemon.data.held_item != null):
			var item_data = BAG.get_item_by_id(pokemon.data.held_item);
			if(item_data != null):
				item.text = item_data.name;
		else: item.text = "NONE";

func set_pokemon_skills() -> void:
	hp.text = str(pokemon.data.current_hp) + "/" + str(pokemon.data.battle_stats["HP"]);
	attack.text = str(pokemon.data.battle_stats["ATK"]);
	defense.text = str(pokemon.data.battle_stats["DEF"]);
	sp_atk.text = str(pokemon.data.battle_stats["S.ATK"]);
	sp_def.text = str(pokemon.data.battle_stats["S.DEF"]);
	speed.text = str(pokemon.data.battle_stats["SPD"]);
	experience.text = str(pokemon.data.total_exp);
	var exp_till_next = EXP.get_exp_for_next_level(pokemon.data);
	next_exp.text = str(exp_till_next);
	var poke_ability = get_ability();
	ability.text = poke_ability.name.to_upper();
	ability_desc.text = poke_ability.description;
	hp_progress.scale.x = min(float(pokemon.data.current_hp) / float(pokemon.data.battle_stats["HP"]), 1);
	#HP COLOR
	var perct = hp_progress.scale.x;
	if(perct >= BATTLE.GREEN_BAR_PERCT): 
		hp_progress.texture = LIBRARIES.IMAGES.GREEN_BAR;
	elif(perct < BATTLE.GREEN_BAR_PERCT && perct > BATTLE.YELLOW_BAR_PERCT): 
		hp_progress.texture = LIBRARIES.IMAGES.YELLOW_BAR;
	elif(perct < BATTLE.YELLOW_BAR_PERCT): 
		hp_progress.texture = LIBRARIES.IMAGES.RED_BAR;
	exp_progress.size.x = min(floor(get_exp_bar_size() * 64), 64);
	#NATURE
	var natures = LIBRARIES.FORMULAS.get_nature_multiplier(pokemon.data.nature, 'all');
	for key in natures.keys():
		var node: RichTextLabel = stat_key_to_node[key];
		if(natures[key] == 1.1):
			node.text = "[color=#0099FF]" + node.text + "[/color]";
		elif(natures[key] == 0.9):
			node.text = "[color=#FF000C]" + node.text + "[/color]";

func set_pokemon_moves() -> void:
	moves_length = pokemon.data.battle_moves.size();
	move_sprite_2d.texture = pokemon.data.specie.party_texture;
	reset_all_moves();
	for index in range(0, moves_length):
		if(pokemon.data.battle_moves[index] != null):
			var move = pokemon.data.battle_moves[index];
			current_moves[index] = move;
			current_markers[index] = moves_marker_position[index];
			var move_node = get_node("Moves/Move" + str(index + 1));
			var type_node = move_node.get_node("Type");
			type_node.visible = true;
			var type_texture = MOVES.get_type_sprite(move.type);
			type_node.texture = type_texture;
			move_node.get_node("Name").text = move.name.to_upper();
			move_node.get_node("PP").text = "PP " + str(move.pp) + "/" + str(move.total_pp);
	#CANCEL LAST SLOT
	current_moves[moves_length] = moves_cancel;
	current_markers[moves_length] = moves_marker_position[Moves.CANCEL];

func get_move_info() -> void:
	var new_move = pokemon.data.battle_moves[selected_move];
	move_power.text = str(new_move.power);
	move_accuracy.text = str(new_move.accuracy);
	move_description.text = new_move.description;
	move_category.frame = new_move.category;
	move_category.visible = true;

func reset_all_moves() -> void:
	for index in range(0, 4):
		var node = get_node("Moves/Move" + str(index + 1));
		node.get_node("Type").visible = false;
		node.get_node("Name").text = "-";
		node.get_node("PP").text = "      -- PP";

func reset_move_info() -> void:
	move_power.text = "";
	move_accuracy.text = "";
	move_description.text = "";
	move_category.visible = false;

func get_exp_bar_size() -> float:
	var base_exp_level = pokemon.get_exp_by_level();
	var base_exp_to_next_level = EXP.get_exp_by_level(pokemon.data.exp_type, pokemon.data.level + 1);
	return float(pokemon.data.total_exp - base_exp_level
	) / float(base_exp_to_next_level - base_exp_level)

func get_ability() -> Dictionary:
	return LIBRARIES.POKEDEX.ABILITIES[int(pokemon.data.ability)];

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream;
	audio.play();
