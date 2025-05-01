class_name MetaUpgrade extends Resource

@export var id: int

@export var is_skill: bool
@export var object: PackedScene # view of upgrade, need method set_disabled()
@export var title: String
@export var description: String
@export var price: Vector4
