extends Node

@onready var timer: Timer = $".";

func _ready():
	GLOBAL.current_time_of_day = get_initial_time_of_day();

func get_initial_time_of_day() -> ENUMS.Climate:
	var current_time = Time.get_time_dict_from_system();
	var hour = current_time.hour;
	if hour >= 6 and hour <= 18: return ENUMS.Climate.DAY;
	else: return ENUMS.Climate.NIGHT;

func _on_timeout() -> void:
	var current_time = Time.get_time_dict_from_system();
	var hour = current_time.hour;
	var range_day = hour >= 6 && hour <= 18;
	var range_night = hour < 6 && hour >= 18;
	var should_change_to_day = range_day && GLOBAL.current_time_of_day != ENUMS.Climate.DAY;
	var should_change_to_night = range_night && GLOBAL.current_time_of_day != ENUMS.Climate.NIGHT;

	if(should_change_to_day):
		GLOBAL.current_time_of_day = ENUMS.Climate.DAY;
		GLOBAL.emit_signal("time_of_day_changed", ENUMS.Climate.DAY);
	elif(should_change_to_night):
		GLOBAL.current_time_of_day = ENUMS.Climate.NIGHT;
		GLOBAL.emit_signal("time_of_day_changed", ENUMS.Climate.NIGHT);
