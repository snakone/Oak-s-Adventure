extends Node

const BICYCLE = preload("res://Assets/Sounds/Bicycle.ogg");
const BATTLE_WILD = preload("res://Assets/Sounds/Battle wild.ogg");
const BATTLE_VICTORY_WILD = preload("res://Assets/Sounds/Battle victory wild.ogg");
const SONG_PATH = "/root/SceneManager/Song";

var audio: AudioStreamPlayer;
var current_song: AudioStream;

func _ready():
	audio = get_node(SONG_PATH);
	audio.connect("finished", _on_song_finished);

func play(song: AudioStream) -> void:
	if(!song || (
			current_song && 
			current_song.get_instance_id() == song.get_instance_id()
	)): return;
	current_song = song;
	if(GLOBAL.on_bike): return;
	stop_and_play(song);

func play_bike() -> void: if(!GLOBAL.on_bike): stop_and_play(BICYCLE);
func stop_and_play_last_song() -> void: stop_and_play(current_song);
func play_battle_wild() -> void: stop_and_play(BATTLE_WILD);

func stop_battle_and_play_last_song() -> void:
	if(GLOBAL.on_bike): stop_and_play(BICYCLE);
	else: stop_and_play(current_song);

func play_battle_win() -> void:
	BATTLE.on_victory = true;
	match BATTLE.type:
		BATTLE.Type.WILD: stop_and_play(BATTLE_VICTORY_WILD);

func _on_song_finished() -> void:
	if(GLOBAL.on_battle): 
		if(BATTLE.on_victory): stop_and_play(BATTLE_VICTORY_WILD);
		else: stop_and_play(BATTLE_WILD);
	elif(GLOBAL.on_bike): stop_and_play(BICYCLE);
	else: stop_and_play_last_song();

func stop_and_play(song: AudioStream) -> void:
	audio.stop();
	audio.stream = song;
	audio.play();
