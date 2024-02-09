extends CanvasLayer

@onready var time_label: RichTextLabel = $TrainerCard/Time/Value;
@onready var timer: Timer = $TrainerCard/Time/Timer;
@onready var money_value: RichTextLabel = $TrainerCard/Money/Value;
@onready var audio: AudioStreamPlayer = $TrainerCard/AudioStreamPlayer;

var last_minute;

func _process(delta: float) -> void: GLOBAL.play_time += delta;

func _ready() -> void:
	timer.wait_time = 1.0;
	_on_timer_timeout();
	timer.start();
	money_value.text = "$" + str(GLOBAL.current_money);

#RIGHT ALIGNED
func get_played_time(separator = ":") -> void:
	var time = GLOBAL.get_time_played();
	var split = time.split(":");
	var format = split[0] + separator + split[1];
	if(last_minute && split[1] != last_minute): audio.play();
	last_minute = split[1];
	if(separator == " "): format = split[1] + separator + split[0];
	time_label.text = format;

func _on_timer_timeout() -> void:
	get_played_time();
	await GLOBAL.timeout(0.7);
	get_played_time(" ");
