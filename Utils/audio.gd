extends Node

const SONG_PATH = "/root/SceneManager/Song";

var audio: AudioStreamPlayer;
var current_song: AudioStream;

func _ready():
	audio = get_node(SONG_PATH);
	audio.connect("finished", _on_song_finished);

func play(song: AudioStream) -> void:
	if(!song || is_same_song(song)): return;
	current_song = song;
	if(GLOBAL.on_bike): return;
	stop_and_play(song);

func play_bike() -> void: if(!GLOBAL.on_bike): stop_and_play(LIBRARIES.SOUNDS.BICYCLE);
func stop_and_play_last_song() -> void: stop_and_play(current_song);

func stop_battle_and_play_last_song() -> void:
	if(GLOBAL.on_bike): stop_and_play(LIBRARIES.SOUNDS.BICYCLE);
	else: stop_and_play(current_song);

func play_battle_song() -> void: 
	match BATTLE.type:
		ENUMS.BattleType.WILD: 
			stop_and_play(LIBRARIES.SOUNDS.BATTLE_WILD);
		ENUMS.BattleType.TRAINER: 
			stop_and_play(LIBRARIES.SOUNDS.BATTLE_TRAINER);

func play_battle_win() -> void:
	BATTLE.on_victory = true;
	match BATTLE.type:
		ENUMS.BattleType.WILD: 
			stop_and_play(LIBRARIES.SOUNDS.BATTLE_VICTORY_WILD);
		ENUMS.BattleType.TRAINER: 
			stop_and_play(LIBRARIES.SOUNDS.BATTLE_VICTORY_TRAINER);

func _on_song_finished() -> void:
	if(GLOBAL.on_battle): 
		if(BATTLE.on_victory): play_battle_win();
		else: play_battle_song();
	elif(GLOBAL.on_bike): stop_and_play(LIBRARIES.SOUNDS.BICYCLE);
	else: stop_and_play_last_song();

func is_same_song(song: AudioStream) -> bool:
	return (
		current_song && song &&
		current_song.get_instance_id() == song.get_instance_id()
	);

func stop_and_play(song: AudioStream) -> void:
	audio.stop();
	audio.stream = song;
	audio.play();

func stop() -> void:
	audio.stop();
