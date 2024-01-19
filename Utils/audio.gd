extends Node

var audio_player: AudioStreamPlayer;
var current_song_id: int;
var current_song: AudioStream;
const BICYCLE = preload("res://Assets/Sounds/Bicycle.ogg");

func _ready():
	audio_player = get_node("/root/SceneManager/Song");
	audio_player.connect("finished", _on_song_finished);

func play(song: AudioStream) -> void:
	if(!song): return;
	if(current_song_id == song.get_instance_id()): return;
	current_song_id = song.get_instance_id();
	current_song = song;
	if(GLOBAL.on_bike): return;
	stop_and_play(song);

func play_bike() -> void: if(!GLOBAL.on_bike): stop_and_play(BICYCLE)
func stop_and_play_last_song() -> void: stop_and_play(current_song);

func _on_song_finished() -> void:
	if(GLOBAL.on_bike): stop_and_play(BICYCLE);
	else: audio_player.play();

func stop_and_play(song: AudioStream) -> void:
	audio_player.stop();
	audio_player.stream = song;
	audio_player.play();
