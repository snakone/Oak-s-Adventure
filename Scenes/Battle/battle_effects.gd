extends Node


@onready var player_status: Node2D = $Info/PlayerInfo/Status;
@onready var enemy_status: Node2D = $Info/EnemyInfo/Status;
var dialog: Object;

var pokemon: Object;
var enemy: Object;

func _init(player: Object, _enemy: Object, _dialog: Object) -> void:
	pokemon = player;
	enemy = _enemy;
	dialog = _dialog;
	check_after_hit();

#CHECK AFTER HIT
func check_after_hit() -> void:
	var result = get_attack_result();
	if(result.keys().size() > 0 && "data" in result.effect):
		var status = result.target.status;
		var data = result.effect.data;
		if(data.on != ENUMS.BattleCheck.AFTER_HIT): return;
		if(should_apply_move_effect(result.target, data)):
			status.current = data.status;
			status.on_status = true;
			dialog.quick(generate_text(result.target, data.status), 1.5);
			BATTLE.must_show_status_dialog = true;
			BATTLE.attack_effect_finished.emit(data.status);
			return;
	BATTLE.attack_effect_finished.emit(ENUMS.PokemonStatus.NONE);

func get_attack_result() -> Dictionary:
	var result = {};
	if(BATTLE.current_turn == BATTLE.Turn.PLAYER && !enemy.data.death):
		result["effect"] = BATTLE.player_attack.effect;
		result["target"] = enemy.data;
	elif(BATTLE.current_turn == BATTLE.Turn.ENEMY && !pokemon.data.death):
		result["effect"] = BATTLE.enemy_attack.effect;
		result["target"] = pokemon.data;
	return result;

func should_apply_move_effect(target: Dictionary, effect_data: Dictionary) -> bool:
	if(target.status.on_status): return false;
	return (randi_range(1, 100) <= effect_data.chance && 
		check_pokemon_can_get_status(target, effect_data.status))

func check_pokemon_can_get_status(target: Dictionary, status: ENUMS.PokemonStatus) -> bool:
	match status:
		ENUMS.PokemonStatus.BURN:
			if(ENUMS.Types.FIRE in target.types): return false;
		ENUMS.PokemonStatus.PARALYZE:
			if(ENUMS.Types.ELECTRIC in target.types): return false;
	return true;

func generate_text(target: Dictionary, status: ENUMS.PokemonStatus) -> Array:
	var text = "";
	match status:
		ENUMS.PokemonStatus.BURN: text = target.name + " was burned.";
	if(BATTLE.is_wild_and_enemy()): text = "Wild " + text;
	return [text];
