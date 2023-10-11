@tool
class_name Mass
extends Node3D


var mass: float = 0.1
var friction_coef: float = 0.01
var inf_mass: bool = false

var velocity: Vector3
var force: Vector3


func reset() -> void:
	force = Vector3.ZERO

func apply_forces(delta: float) -> void:
	if inf_mass:

		return
	var acceleration := force / mass
	velocity += acceleration * delta
	position += velocity * delta

func apply_friction() -> void:
	var friction := -friction_coef*velocity*velocity.length()
	force += friction

func apply_gravity(gravity: Vector3) -> void:
	force += gravity * mass

func collide_with_plane(plane: Vector3) -> void:
	if position.dot(plane) < 0.0:
		velocity -= velocity.project(plane)
		position -= position.project(plane)
