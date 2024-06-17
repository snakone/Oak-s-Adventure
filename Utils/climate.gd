extends Node

@onready var timer: Timer = $".";

var current_time_of_day: ENUMS.Climate;

func _ready():
	GLOBAL.current_time_of_day = get_initial_time_of_day();
	current_time_of_day = GLOBAL.current_time_of_day;
	#current_time_of_day = GLOBAL.Climate.NIGHT;

func get_initial_time_of_day() -> ENUMS.Climate:
	var current_time = Time.get_time_dict_from_system();
	var hour = current_time.hour;
	if hour >= 6 and hour <= 18: return ENUMS.Climate.DAY;
	else: return ENUMS.Climate.NIGHT;

func _on_timeout() -> void:
	var current_time = Time.get_time_dict_from_system();
	var hour = current_time.hour;
	if(hour >= 6 && hour <= 18 && current_time_of_day != ENUMS.Climate.DAY):
		current_time_of_day = ENUMS.Climate.DAY;
		GLOBAL.current_time_of_day = current_time_of_day;
		GLOBAL.emit_signal("time_of_day_changed", ENUMS.Climate.DAY);
	elif(hour <= 6 && hour >= 18 && current_time_of_day != ENUMS.Climate.NIGHT):
		current_time_of_day = ENUMS.Climate.NIGHT;
		GLOBAL.current_time_of_day = current_time_of_day;
		GLOBAL.emit_signal("time_of_day_changed", ENUMS.Climate.NIGHT);
