@tool
class_name Spring
extends Node3D

var l0: float
var l: float
var k: float = 5.0

var m1: Mass
var m2: Mass


func _ready() -> void:
	$MeshInstance3D.scale_object_local(Vector3(1, l0, 1))
	l = l0


func _process(delta: float) -> void:
	align_visual()


func align_visual() -> void:
	var tm: Transform3D
	tm.origin = (m1.position + m2.position) * 0.5
	tm.basis.y = (m2.position - m1.position).normalized()
	if abs(tm.basis.y.dot(Vector3.DOWN)) < 0.9:
		tm.basis.x = tm.basis.y.cross(Vector3.DOWN).normalized()
	else:
		tm.basis.x = tm.basis.y.cross(Vector3.LEFT).normalized()
	tm.basis.z = tm.basis.y.cross(tm.basis.x).normalized()
	
	tm.basis.x /= sqrt(l / l0);
	tm.basis.y *= l / l0;
	tm.basis.z /= sqrt(l / l0);
	transform = tm

func update() -> void:
	l = m1.position.distance_to(m2.position)
	var force_direction = (m2.position-m1.position) / l
	m2.force += -k*(l-l0) * force_direction
	m1.force += k*(l-l0) * force_direction
