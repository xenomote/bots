extends Node2D

export(bool) var emitting setget set_emitting

func set_emitting(value):
	for particles in get_children():
		particles.emitting = value
