extends RigidBody2D

export(PackedScene) var COMPONENTS
export(PackedScene) var PROJECTILE

export(Vector2) var target
export(float) var turn
export(float) var speed
export(bool) var shoot

onready var last_linear_velocity = linear_velocity
var collision_force = Vector2.ZERO

onready var turret = $TurretSprite
onready var firing = $TurretSprite/FiringRayCast
onready var spray = $TurretSprite/FiringParticles
onready var tracks = $TrackParticles

func _ready():
	firing.add_exception(self)

func _process(delta):
	var target_rotation = target.angle_to_point(global_position)
	var x = delta * PI
	turret.global_rotation += clamp(angle_between(turret.global_rotation, target_rotation), -x, x)
	
	if turn == 0:
		apply_central_impulse((Vector2.RIGHT * speed).rotated(rotation) * delta)
	else:
		apply_torque_impulse(turn * delta)
	
	tracks.emitting = linear_velocity.length() > 10 or angular_velocity > 1
	
	if shoot:
		var collision = firing.get_collision_point()
		var components = PROJECTILE.instance()
		components.global_position = collision
		get_parent().add_child(components)
		spray.emitting = true
		shoot = false

func angle_between(a, b):
	var x = b - a
	x -= TAU if x > PI else 0.0
	x += TAU if x < -PI else 0.0
	return x

func _integrate_forces(state):
	if state.get_contact_count() > 0:
		var delta = linear_velocity - last_linear_velocity
		collision_force = delta / (state.inverse_mass * state.step)
		
	last_linear_velocity = linear_velocity

func _on_body_entered(_body):
	if collision_force.length() > 10000:
		var components = COMPONENTS.instance()
		components.position = position
		get_parent().add_child(components)
