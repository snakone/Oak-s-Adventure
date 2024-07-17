extends Node2D

@onready var animation_player = $AnimationPlayer;
@onready var texture_rect = $TextureRect;
@onready var grass_effect = $GrassEffect;
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer;

@export var encounters: Array[ENUMS.Pokedex];
@export var zone: ENUMS.BattleZones;
@export var battle_type: ENUMS.BattleType; 
@export var level_range = [5, 6];
@export var zone_number: int = 1;

func _ready(): 
	GLOBAL.connect("player_moving", reset_texture);
	GLOBAL.connect("close_battle", _on_end_battle);

func _on_area_2d_body_entered(body) -> void:
	if(body.name == "Oak"):
		if(!BATTLE.coming_from_battle):
			if(body.input_direction == Vector2.UP && !GLOBAL.on_bike):
				await GLOBAL.timeout(.1);
			animation_player.play("Stepped");
			if(encounters.size() == 0): return;
			check_for_battle(body);
		else: BATTLE.coming_from_battle = false;

func _on_area_2d_body_exited(_body): 
	BATTLE.coming_from_battle = false;
	texture_rect.visible = false;

func active_effect() -> void: grass_effect.play();

func _on_end_battle(_battle_data: Dictionary) -> void: 
	call_deferred("set_process", Node.PROCESS_MODE_INHERIT);

func reset_texture(value: bool): 
	if(value): 
		texture_rect.visible = false;
		BATTLE.coming_from_battle = false;

func check_for_battle(body: CharacterBody2D) -> void:
	var battle = BATTLE.pokemon_encounter();
	if(battle):
		var index = get_random_pokemon();
		var battle_data = {
			"enemies": [index],
			"zone": zone,
			"type": battle_type,
			"levels": level_range
		}
		body.set_battle_data(battle_data);
		texture_rect.visible = true;
		call_deferred("set_process", Node.PROCESS_MODE_DISABLED);

func get_random_pokemon() -> ENUMS.Pokedex:
	var map = MAPS.get_map_name(true);
	var map_encounters = LIBRARIES.MAPS.ENCOUNTERS[map][zone_number];
	if(encounters.size() == 1): return encounters[0];
	encounters.sort_custom(func(x, y): 
		return map_encounters[x] < map_encounters[y]);
	var random = randf_range(0.0, 99.0);
	var accumulated = 0.0;
	
	for key in encounters:
		accumulated += map_encounters[key];
		if random < accumulated: return key;
		
	return encounters[-1];
