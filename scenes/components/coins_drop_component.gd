class_name CoinsDropComponent extends Node3D

var coins: int = 0
var deviation: int = 3

func set_coins(coins: float) -> void:
	self.coins = coins

func drop() -> void:
	if coins == 0:
		return
	for i in coins:
		var coin_instance: Coin = Constants.COIN.instantiate();
		Constants.SOULS.add_child(coin_instance)
		#coin_instance.emit(get_parent().soul_component.souls)
		coin_instance.global_position = get_parent().global_position + Vector3(randf_range(-deviation,deviation), 0.5, randf_range(-deviation,deviation))
		coin_instance.global_position.y = 0.6
		coin_instance.rotate_y(randf_range(-PI, PI))
		coin_instance.rotate_x(randf_range(-PI, PI))
		coin_instance.rotate_z(randf_range(-PI, PI))
		coin_instance.collect()
