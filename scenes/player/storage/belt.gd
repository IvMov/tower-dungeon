class_name Belt extends Storage

const NAME: String = "belt"

func _ready():
	GameEvents.item_remove.connect(on_item_remove)
	GameEvents.item_add.connect(on_item_add)
	var data: Dictionary = PlayerParameters.player_data[MetaProgression.STORAGES_KEY][NAME]
	load_storage(data)


	
