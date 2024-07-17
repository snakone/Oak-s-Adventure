extends CanvasLayer

@onready var audio: AudioStreamPlayer = $AudioStreamPlayer;
@onready var anim_player: AnimationPlayer = $AnimationPlayer;

func _ready() -> void:
	await GLOBAL.timeout(0.2);
	play_audio(LIBRARIES.SOUNDS.POKEMON_HEAL);

func _on_audio_stream_player_finished() -> void:
	await GLOBAL.timeout(1.2);
	anim_player.play("FadeOut");

func play_audio(stream: AudioStream) -> void:
	audio.stream = stream;
	audio.play();

func close() -> void:
	queue_free();
