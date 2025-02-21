extends VBoxContainer
@onready var label_key_value: LabelKeyValue = $LabelKeyValue
@onready var label_key_value_2: LabelKeyValue = $LabelKeyValue2
@onready var progress_bar: ProgressBar = $ProgressBar


func set_info(item: Dictionary) -> void:
	if !item.is_empty():
		label_key_value.value = str(item["lvl"])
		label_key_value_2.value = str(item["max_lvl"])
		progress_bar.max_value = item["next_lvl_exp"]
		progress_bar.value = item["exp"]
	else:
		label_key_value.value = "0"
		label_key_value_2.value = "10"
		progress_bar.max_value = 100
		progress_bar.value = 0
