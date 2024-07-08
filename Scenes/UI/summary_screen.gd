extends CanvasLayer

@onready var audio: AudioStreamPlayer = $AudioStreamPlayer;
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D;

#INFO
@onready var poke_name: RichTextLabel = $Info/Name;
@onready var number: RichTextLabel = $Info/Number;
@onready var nature: RichTextLabel = $Info/Nature;
@onready var gender: Sprite2D = $Specie/Gender;
@onready var level: RichTextLabel = $Specie/Level;
@onready var specie_name: RichTextLabel = $Specie/Name;

@onready var type_1: Sprite2D = $Types/Type1;
@onready var type_2: Sprite2D = $Types/Type2;

var pokemon: Object;

func _ready() -> void:
	pokemon = GLOBAL.summary_pokemon;
	set_pokemon_data();

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
	
	if(Input.is_action_just_pressed("backMenu") ||
		Input.is_action_just_pressed("space")): 
		close_summary();
		return;

func set_pokemon_data() -> void:
	if(pokemon != null):
		poke_name.text = pokemon.name;
		sprite_2d.sprite_frames = pokemon.data.sprites.sprite_frames;
		sprite_2d.play("Front")
		sprite_2d.offset = pokemon.data.display.offset.pokedex;
		sprite_2d.scale = pokemon.data.display.scale.pokedex;
		number.text = format_number(pokemon.data.number);
		nature.text = LIBRARIES.BATTLE.nature_strings[int(pokemon.data.nature)] + ' nature.';
		level.text = "Lv" + str(pokemon.data.level);
		specie_name.text = pokemon.name;
		
		if("gender" in pokemon.data):
			gender.frame = pokemon.data.gender;
			gender.visible = true;
		else: 
			gender.visible = false;
			
		var types = convert_types(pokemon);
		type_1.texture = types[0];
		if(types.size() > 1):
			type_2.visible = true;
			type_2.texture = types[1];

func close_summary() -> void:
	play_audio(LIBRARIES.SOUNDS.GUI_MENU_CLOSE);
	await GLOBAL.timeout(.2);
	GLOBAL.emit_signal("scene_opened", false, "CurrentScene/SummaryScreen");
	GLOBAL.summary_pokemon = null;
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

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream;
	audio.play();
