extends Node2D

export(float) var TURN
export(float) var SPEED

onready var parent = get_parent()

func _process(_delta):
	var speed = 0
	var turn = 0
	
	if Input.is_action_pressed("ui_up"):
		speed += 1
	if Input.is_action_pressed("ui_down"):
		speed -= 1
	if Input.is_action_pressed("ui_left"):
		turn -= 1
	if Input.is_action_pressed("ui_right"):
		turn += 1
	
	parent.turn = turn * TURN
	parent.speed = speed * SPEED
	
	parent.target = get_global_mouse_position()
	
	if Input.is_action_just_pressed("click"):
		parent.shoot = true
