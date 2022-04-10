extends Node2D

signal emitting

func _ready():
	emit_signal("emitting")
