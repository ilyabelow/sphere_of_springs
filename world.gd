@tool
extends Node3D

@onready var mass_scene := preload("res://mass.tscn")
@onready var spring_scene := preload("res://spring.tscn")

var masses: Array[Mass]
var springs: Array[Spring]
var pivot: Mass

const gravity := Vector3(0, -9.8, 0)


func _ready():
	const sides := 10
	const step := 5.0
	for i in range(sides):
		for j in range(sides):
			for k in range(sides):
				var x := i - sides*.5
				var y := j - sides*.5
				var z := k - sides*.5
				if x*x + y*y + z*z > sides*sides*.25:
					continue
				var mass := mass_scene.instantiate() as Mass
				if j == sides -1 and i == sides/2 and k == sides/2:
					mass.inf_mass = true
				if j == sides/2 and i == sides-1 and k == sides/2:
					pivot = mass
					mass.inf_mass = true
				mass.position = Vector3(x, y, z) * step# + Vector3(0, sides * step, 0)
				masses.append(mass)
				add_child(mass)

	for m1 in range(len(masses)):
		for m2 in range(m1+1, len(masses)):
			if m1 == m2:
				continue
			if masses[m1].position.distance_squared_to(masses[m2].position) <= step*step*3:
				var spring := spring_scene.instantiate() as Spring
				spring.m1 = masses[m1]
				spring.m2 = masses[m2]
				spring.l0 = masses[m1].position.distance_to(masses[m2].position) 
				springs.append(spring)
				add_child(spring)


func _physics_process(delta: float) -> void:
	for mass in masses:
		mass.reset()
	for spring in springs:
		spring.update()
	for mass in masses:
		mass.apply_gravity(gravity)
		mass.apply_friction()
		mass.apply_forces(delta)
	
	var time := Time.get_ticks_msec()/100.
	pivot.position.x = 10*sin(time)+20*sin(time/5)+20
