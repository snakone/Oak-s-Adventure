extends Node2D

@onready var animation_player = $AnimationPlayer;
@onready var texture_rect = $TextureRect;
@onready var grass_effect = $GrassEffect;

@export var encounters: Array[POKEMON.Pokedex];
@export var zone: BATTLE.Zones;
@export var battle_type: BATTLE.Type; 
@export var level_range = [5, 6];

func _ready(): GLOBAL.connect("player_moving", reset_texture);

func _on_area_2d_body_entered(body) -> void:
	if(body.name == "Oak"):
		if(body.input_direction == Vector2.UP && !GLOBAL.on_bike):
			await GLOBAL.timeout(.1);
		animation_player.play("Stepped");
		
		var battle = BATTLE.pokemon_encounter();
		if(battle):
			var battle_data = {
				"enemy":  encounters[randi() % encounters.size()],
				"zone": zone,
				"type": battle_type,
				"levels": level_range
			}
			body.battle_data = battle_data;
			body.ready_to_battle = true;

func _on_area_2d_body_exited(_body): texture_rect.visible = false;
func active_effect() -> void: grass_effect.play();
func reset_texture(value: bool): if(value): texture_rect.visible = false;
