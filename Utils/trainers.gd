extends Node

var defetead_trainers = [];

func _ready(): add_to_group(GLOBAL.group_name);

func add_defeat_trainer(id: ENUMS.Trainer) -> void:
	for trainer in defetead_trainers:
		if(trainer.id == id): return;
	defetead_trainers.push_back({"id": id, "defeated": true});

func is_already_defeated(id: ENUMS.Trainer) -> bool:
	for trainer in defetead_trainers:
		if(trainer.id == id): return trainer["defeated"];
	return false;

#SAVE
func save() -> Dictionary:
	var data := {
		"save_type": ENUMS.SaveType.TRAINERS,
		"defetead_trainers": defetead_trainers,
		"path": get_path()
	}
	return data;

func load(data: Dictionary) -> void:
	if("defetead_trainers" in data):
		defetead_trainers = data["defetead_trainers"];
