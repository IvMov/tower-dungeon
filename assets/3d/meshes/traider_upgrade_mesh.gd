extends Node3D
@onready var coin: Coin = $Coin
@onready var coin_4: Coin = $Coin4
@onready var coin_2: Coin = $Coin2
@onready var coin_3: Coin = $Coin3


func set_disabled() -> void: 
	coin.set_disabled()
	coin_2.set_disabled()
	coin_3.set_disabled()
	coin_4.set_disabled()
