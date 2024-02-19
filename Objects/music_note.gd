extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D;
@onready var audio: AudioStreamPlayer = $AudioStreamPlayer;

@export var note: Notes;

const DO = preload("res://Assets/Sounds/Notes/do.mp3");
const RE = preload("res://Assets/Sounds/Notes/re.mp3");
const MI = preload("res://Assets/Sounds/Notes/mi.mp3")
const FA = preload("res://Assets/Sounds/Notes/fa.mp3");
const SOL = preload("res://Assets/Sounds/Notes/sol.mp3");
const LA = preload("res://Assets/Sounds/Notes/la.mp3");

enum Notes { DO, RE, MI, FA, SOL, LA }

func _on_area_2d_body_entered(_body: Node2D) -> void:
	sprite_2d.frame = 1;
	match note:
		Notes.DO: play_audio(DO)
		Notes.RE: play_audio(RE)
		Notes.MI: play_audio(MI)
		Notes.FA: play_audio(FA)
		Notes.SOL: play_audio(SOL)
		Notes.LA: play_audio(LA)

func _on_area_2d_body_exited(_body: Node2D) -> void:
	sprite_2d.frame = 0;
	
func play_audio(stream: AudioStream) -> void:
	audio.stop();
	audio.stream = stream;
	audio.play();
