extends Node3D

@export var heavenly_bodies:Array[RigidBody3D]
@export var heavenly_body_meshes:Array[MeshInstance3D]
@export var heavenly_body_collisionshapes:Array[CollisionShape3D]
@export var area3d_collisionshapes:Array[CollisionShape3D]

@onready var distance_label = $Scales/VBoxContainer/PanelContainer/MarginContainer/GridContainer/DistanceLabel
@onready var distance_scale_label = $Scales/VBoxContainer/PanelContainer/MarginContainer/GridContainer/DistanceScaleLabel
@onready var radius_label = $Scales/VBoxContainer/PanelContainer/MarginContainer/GridContainer/RadiusLabel
@onready var radius_scale_label = $Scales/VBoxContainer/PanelContainer/MarginContainer/GridContainer/RadiusScaleLabel
@onready var mass_label = $Scales/VBoxContainer/PanelContainer/MarginContainer/GridContainer/MassLabel
@onready var mass_scale_label = $Scales/VBoxContainer/PanelContainer/MarginContainer/GridContainer/MassScaleLabel

@onready var user_planet = $ChangeValues/PanelContainer/MarginContainer/GridContainer/OptionButton
@onready var user_m = $ChangeValues/PanelContainer/MarginContainer/GridContainer/M
@onready var user_d = $ChangeValues/PanelContainer/MarginContainer/GridContainer/D
@onready var user_G = $ChangeValues/PanelContainer/MarginContainer/GridContainer/G
@onready var change = $ChangeValues/PanelContainer/MarginContainer/GridContainer/Button
var selected

@onready var asteroids1 = $AsteroidBelt/MultiMeshInstance3D
@onready var asteroids2 = $AsteroidBelt/MultiMeshInstance3D2

var rotation_axis: Vector3 = Vector3.UP  # Default to Y-axis (local up)

var rotation_speeds = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0] #calculate afai
var orbital_inclination = [0, 7.01, 3.39, 0, 1.85, 1.31, 2.49, 0.77, 1.77]

var	heavenly_bodies_data = Global.data


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for body in heavenly_bodies:
		body.custom_integrator = true
		body.contact_monitor = true
	start()
	
func update_ui():
	var screen_size = get_viewport().get_visible_rect().size

	distance_label.text = "Distance Scale "
	distance_scale_label.text = "1 unit = %sm" % str(Global.scientific_notation(Global.distance_scale))
	radius_label.text = "Radius Scale "
	radius_scale_label.text = "1 unit = %sm" % str(Global.scientific_notation(Global.radii_scale))
	mass_label.text = "Mass Scale "
	mass_scale_label.text = "1 unit = %skg" % str(Global.scientific_notation(Global.mass_scale))
	
func start():
	set_physics_process(true)
	set_process(true)
	Global.instantiate_values()
	update_ui()
	initial_planet_set_up()
	for ind in range(len(heavenly_bodies)):
		var body = heavenly_bodies[ind]
		var mesh = heavenly_body_meshes[ind]
		var shape = heavenly_body_collisionshapes[ind]
		var collide = area3d_collisionshapes[ind]
		var radius = Global.radii[ind] / Global.radii_scale
		body.mass = Global.data[ind]["mass"] / Global.mass_scale
		print(body, body.position)
		#print(mesh.scale)
		if ind == 0:
			radius = radius / 10
			body.get_child(3).scale = Vector3(radius,radius,radius)
			mesh.scale = Vector3(radius, radius, radius)
			collide.scale = Vector3(radius,radius,radius)
			shape.scale = Vector3(radius, radius, radius)
		else:
			mesh.scale = Vector3(radius, radius, radius)
			collide.scale = Vector3(radius,radius,radius)
			shape.scale = Vector3(radius, radius, radius)
		#mesh.scale = Vector3(radius, radius, radius)
		#collide.scale = Vector3(radius,radius,radius)
		#shape.scale = Vector3(radius, radius, radius)		
		var path = str(body).split(":")[0] + "/Label3D"
		var label = get_node(path)
		label.position.y = radius + 5000	
		label.scale = Vector3(5,5,5)
		#var angle = deg_to_rad(orbital_inclination[ind])
		#var d = distances[ind]
		#var x = d * cos(angle)
		#var y = d * sin(angle)
		#var z = 0
		#body.translate(Vector3(x,y,z))
		
		#var distance =  body.position.distance_to(heavenly_bodies[0].position)
		#var velocity = (Global.G * masses[0] / distance) ** 0.5

		#var velocity = Vector3.ZERO
		#
		#if ind != 0:
			#velocity = orbital_velocity(body)
#
		#if ind in [2, 7]:
			#velocity = -velocity
		#body.linear_velocity = velocity

func maxa(a):
	var m = 0
	var ind = 0
	var max_ind = 0
	for i in a:
		if i > m:
			m = i
			max_ind = ind
		ind += 1
	return [m, max_ind]
func mina(a):
	var m = 999999999999
	var ind = 0
	var min_ind = 0
	for i in a:
		if i < m:
			m = i
			min_ind = ind
		ind += 1
	return [m, min_ind]

func maxv(a):
	var m = Vector3.ZERO
	for i in a:
		if i > m:
			m = i
	return m
func minv(a):
	var m = Vector3(99999999999999999999.0,99999999999999999999.0,99999999999999999999.0)
	for i in a:
		if i < m:
			m = i
	return m

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	update_velocity(delta)
	rotate_axis(delta)
	#for body in heavenly_bodies:
		##print(str(body).split(":")[0], ": ", calculate_eccentricity(body))
		#if str(body).split(":")[0] == "Venus":
			#distance_for_eccentricity.append(body.position.distance_to(heavenly_bodies[0].position))

	#print(maxa(distance_for_eccentricity), ", ", mina(distance_for_eccentricity))
	
		#if body == heavenly_bodies[1]:
		#print(str(body).split(":")[0], ": ", body.position.distance_to(heavenly_bodies[0].position), body.linear_velocity)
			#if body.position.distance_to(heavenly_bodies[0].position) >= 56999 and body.position.distance_to(heavenly_bodies[0].position) <= 57001:
				#print("same place")
				#print()
			#print(body.position)
			#if body.position.distance_to(Vector3(56573.92, 6956.427, 0))< 1000:
				#print("same place")
		#print(body.position)

#func orbital_velocity(body: RigidBody3D) -> Vector3:
	#var d = heavenly_bodies[0].position - body.position
	#var speed = (Global.G * masses[0] / d.length()) ** 0.5
	#var dirn = d.normalized().cross(Vector3.UP)
	#return dirn * speed

func update_velocity(delta):
	var body
	var other_body
	var a = []
	for ind1 in range(len(heavenly_bodies)): # loop over each body to calculate its overall change in velocity
		for ind2 in range(len(heavenly_bodies)): # loop over each body to calculate the change caused by another body
			body = heavenly_bodies[ind1]
			other_body = heavenly_bodies[ind2]
			if body != other_body: # why would a body's gravity affect itself
				var sqrdist:float = body.position.distance_squared_to(other_body.position) # Distance squared
				var forceDir:Vector3 = (other_body.position - body.position).normalized()  # Direction vector
				var force:Vector3 = forceDir * Global.G * (Global.masses[ind2] / Global.mass_scale) * (Global.masses[ind1] / Global.mass_scale)/ sqrdist  # Gravitational force
				var acceleration:Vector3 = force * 1 / (Global.masses[ind1] / Global.mass_scale)  # Newton's 2nd law (F = ma)
				body.linear_velocity += acceleration * delta # Update velocity based on acceleration
				a.append(force)
	#print(maxv(a))
	# Log values for debugging
	#print("dist = {0}, forceDir = {1}, force = {2}, a = {3}, v = {4}".format([sqrdist ** 0.5, forceDir, force, wacceleration, body.linear_velocity]))

func rotate_axis(delta: float) -> void:
	for ind in range(9):
		var body = heavenly_body_meshes[ind]
		var rotation_angle = rotation_speeds[ind] * delta
		body.rotate_object_local(rotation_axis, rotation_angle)
		if ind == 6:
			$Saturn/MeshInstance3D/MeshInstance3D2.rotate(rotation_axis, rotation_angle)
		asteroids1.rotate_object_local(rotation_axis, Global.G * 1e3)
		asteroids2.rotate_object_local(rotation_axis, Global.G * 1e3)

var distance_for_eccentricity = []
func calculate_eccentricity(body: RigidBody3D):
	var max_distance = 0.0
	var min_distance = 999999999999
	
	# Track the distances over time (for example, every frame or periodically)
	var distance = body.position.distance_to(heavenly_bodies[0].position)  # Assuming body[0] is the Sun
	distance_for_eccentricity.append(distance)
	# Eccentricity calculation
	#if max_distance + min_distance != 0:
		#return (((max_distance ** 2) - (min_distance ** 2)) ** 0.5) / max_distance
	#else:
		#return 0.0  # If both max and min distances are the same, eccentricity is 0
var velocities:Array[Vector3] = [Vector3.ZERO,Vector3.ZERO,Vector3.ZERO,Vector3.ZERO,Vector3.ZERO,Vector3.ZERO,Vector3.ZERO,Vector3.ZERO,Vector3.ZERO]

func initial_planet_set_up():
	heavenly_bodies[0].position = Vector3.ZERO
	heavenly_bodies[0].linear_velocity = Vector3.ZERO
	var heaviest = maxa(Global.masses)
	for ind in range(9):
		var planet = heavenly_bodies[ind]
		planet.position = Vector3.ZERO
		planet.linear_velocity = Vector3.ZERO
		var semi_major_axis = Global.distances[ind] / Global.distance_scale #avg distance

		var eccentricity = Global.planet_eccentricities[ind]
		var periapsis = semi_major_axis * (1 - eccentricity)
		var apiapsis = semi_major_axis * (1 + eccentricity)
		var inclination = deg_to_rad(orbital_inclination[ind])
			
		var x = periapsis * cos(inclination)
		var y = periapsis * sin(inclination)
		
		planet.position = Vector3(x,y,0)
		
		#print(planet.position)
		if  ind != heaviest[1]:
			semi_major_axis = abs(Global.distances[heaviest[1]] - Global.distances[ind]) / Global.distance_scale
			periapsis = semi_major_axis * (1 - eccentricity)
			var speed = (Global.G * (heaviest[0] / Global.mass_scale) * (2/periapsis - 1/semi_major_axis)) ** 0.5
			var distance = heavenly_bodies[heaviest[1]].position - planet.position
			var dirn = distance.normalized().cross(Vector3.UP)
			var velocity = dirn * speed
			if ind in [2,7]:
				velocity = -velocity
			planet.linear_velocity = velocity
			Global.periods[ind] = 2 * PI * ( ( semi_major_axis ** 3) / ( Global.G * (heaviest[0] / Global.mass_scale) ) ) ** 0.5
		
		velocities[ind] = planet.linear_velocity
		planet.force_update_transform()
	apply_rotation_speed()
		#var orbit_path:GPUParticles3D = GPUParticles3D.new()
		#var process_material = ParticleProcessMaterial.new()
		#process_material.directional_velocity_max = 0
		#process_material.directional_velocity_min = 0
		#process_material.gravity = Vector3(0,0,0)
		#orbit_path.process_material = process_material
		#var pass1 = TubeTrailMesh.new()
		#pass1.radius = 100
		#pass1.section_length = 500
		#var material:StandardMaterial3D = StandardMaterial3D.new()
		#material.emission_enabled = true
		#material.emission = "#00ffff"
		#pass1.material = material
		#orbit_path.draw_pass_1 = pass1
		#orbit_path.lifetime = round(periods[ind])
		#orbit_path.amount = 1000 * ind
#
			#get_node(Global.data[ind]["heavenly_body"]).add_child(orbit_path)
			
var real_life_orbital_time = [0,7600528.0,19414128.0,31557600.0,59356800.0,374355840.0,929596800.0,2651376000.0,5200416000.0]
var real_life_day_length = [0,5068800.0,20995200.0,86400.0,88903.2,35462.4,38880.0,62208.0,57888.0]
func apply_rotation_speed():
	#print(Global.periods)
	for ind in range(9):
		var scaling_factor = Global.periods[ind] / real_life_orbital_time[ind]
		
		var simulated_day_length = real_life_day_length[ind] * scaling_factor
		var simulated_rotation_speed = (2 * PI) / simulated_day_length
		rotation_speeds[ind] = float(simulated_rotation_speed)
		#print(float(simulated_rotation_speed))
			
func _on_check_button_toggled(toggled_on: bool) -> void:
	var panel = $ChangeValues/PanelContainer
	var value = 0
	var screen_size = get_viewport().get_visible_rect().size	
	if !toggled_on:
		var tween = $ChangeValues.create_tween()

		tween.tween_property(
			panel, "position", Vector2(screen_size.x + 275,panel.position.y), 0.5
		)
		
	else:
		var tween = $ChangeValues.create_tween()

		tween.tween_property(
			panel, "position", Vector2(screen_size.x - 275,panel.position.y), 0.35
		)
	$ChangeValues/PanelContainer2/MarginContainer/GridContainer/GridContainer/CheckButton.release_focus()	
func _on_button_pressed() -> void:

	if selected:
		if user_m.text.is_valid_float():
			Global.masses[user_planet] = absf(float(user_m.text))
		else:
			user_m.text = ""
		if user_d.text.is_valid_float():
			Global.distances[user_planet] = abs(float(user_d.text))
		else:
			user_d.text = ""
		if user_G.text.is_valid_float():
			Global.G = abs(float(user_G.text))
		else:
			user_G.text = ""
	$ChangeValues/PanelContainer/MarginContainer/GridContainer/Button.release_focus()
	if user_d.text != "" or user_G.text != "" or user_m.text != "":
		initial_planet_set_up()

func make_meshes_visible_if_collisions_occur():
	for planet in heavenly_bodies:
		planet.get_child(0).visible = true
		planet.get_child(1).visible = true
		planet.get_child(2).visible = true
		
func _on_m_mouse_exited() -> void:
	$ChangeValues/PanelContainer/MarginContainer/GridContainer/M.release_focus()
func _on_d_mouse_exited() -> void:
	$ChangeValues/PanelContainer/MarginContainer/GridContainer/D.release_focus()
func _on_G_mouse_exited() -> void:
	$ChangeValues/PanelContainer/MarginContainer/GridContainer/G.release_focus()

@onready var planet_label = $BodyInfo/MarginContainer/GridContainer/Planet
@onready var planet_name = $"BodyInfo/MarginContainer/GridContainer/PlanetName"
@onready var planet_mass_label = $"BodyInfo/MarginContainer/GridContainer/Mass"
@onready var mass_value = $"BodyInfo/MarginContainer/GridContainer/MassValue"
@onready var radius  = $"BodyInfo/MarginContainer/GridContainer/Radius"
@onready var radius_value = $"BodyInfo/MarginContainer/GridContainer/RadiusValue"
@onready var distance = $"BodyInfo/MarginContainer/GridContainer/Distance"
@onready var distance_value = $"BodyInfo/MarginContainer/GridContainer/DistanceValue"
@onready var orbit_time_label = $"BodyInfo/MarginContainer/GridContainer/OrbitTime"
@onready var orbit_time_value = $"BodyInfo/MarginContainer/GridContainer/OrbitTimeValue"
func _on_option_button_item_selected(index: int) -> void:
	user_planet = index
	selected = true
	if index == 0:
		user_d.visible = false
		$ChangeValues/PanelContainer/MarginContainer/GridContainer/Distance.visible = false
		$ChangeValues/PanelContainer.size.y = 298.0 - 50
	else:
		user_d.visible = true
		$ChangeValues/PanelContainer/MarginContainer/GridContainer/Distance.visible = true
		$ChangeValues/PanelContainer.size.y = 298.0
	$ChangeValues/PanelContainer/MarginContainer/GridContainer/OptionButton.release_focus()	

	var body = Global.data[index]
	if index == 0:
		planet_label.text = "Sun"
		planet_name.text = ""
		planet_mass_label.text = "Mass:"
		mass_value.text = str(Global.scientific_notation(body["mass"])) + "kg"
		radius.text = "Radius:"
		radius_value.text = str(Global.scientific_notation(body["radius"])) + "m"
		distance.text = ""
		distance_value.text = ""	
		orbit_time_label.text = ""
		orbit_time_value.text = ""
		
	else:
		var orbit_time = Global.periods[index]
		#orbit_time = orbit_time / (60 * 60 * 24 * 365)
		orbit_time = orbit_time / 60
		var split = str(orbit_time).split(".")
		var min = int(split[0])
		var sec = int(round(float("0." + split[1]) * 60))
		
		planet_label.text = "Planet:"
		planet_name.text = body["heavenly_body"]
		planet_mass_label.text = "Mass:"
		mass_value.text = str(Global.scientific_notation(body["mass"])) + "kg"
		radius.text = "Radius:"
		radius_value.text = str(Global.scientific_notation(body["radius"])) + "m"
		distance.text = "Distance to Sun:"
		distance_value.text = str(Global.scientific_notation(heavenly_bodies[index].position.distance_to(heavenly_bodies[0].position) * Global.distance_scale)) + "m"	
		orbit_time_label.text = "Orbit Time:"
		orbit_time_value.text = str(min) + "min, " + str(sec) + "sec"



func _on_restart_pressed() -> void:
	start()
	$ChangeValues/PanelContainer2/MarginContainer/GridContainer/GridContainer2/Restart.release_focus()

var paused = false
func _on_play_pressed() -> void:
	if paused:
		for ind in range(9):
			var body = heavenly_bodies[ind]
			body.linear_velocity = velocities[ind]
		paused = false
	set_process(true)
	set_physics_process(true)
	$ChangeValues/PanelContainer2/MarginContainer/GridContainer/GridContainer2/Play.release_focus()

func _on_pause_pressed() -> void:
	if not paused:
		for ind in range(9):
			var body = heavenly_bodies[ind]
			velocities[ind] = body.linear_velocity
			body.linear_velocity = Vector3.ZERO
		paused = true
	set_process(false)
	set_physics_process(false)
	$ChangeValues/PanelContainer2/MarginContainer/GridContainer/GridContainer2/Pause.release_focus()
