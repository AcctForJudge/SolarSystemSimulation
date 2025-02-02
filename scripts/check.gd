extends RigidBody3D

#func _ready() -> void:
	#var exp1 = preload("res://scenes/big_explosion.tscn").instantiate()
	#add_child(exp1)
	#print(exp1.position)
var sizing = {
	'Sun':10, 'Mercury':1, 'Venus':2, 'Earth':3,'Mars':4,'Jupiter':5,'Saturn':6,'Uranus':7,'Neptune':8
}
var count = 0
func _on_area_3d_body_entered(body: Node3D) -> void:
	
	if body != self:	
		if count == 0:
			var self_name = str(self).split(":")[0]
			var body_name = str(body).split(":")[0]
			#print("I, {0} collided with {1}".format([self_name, body_name]))
			var smaller = self_name if (sizing[self_name] < sizing[body_name]) else body_name
			if sizing[smaller] < 5:
				var exp1 = preload("res://scenes/small_explosion.tscn").instantiate()
				add_child(exp1)
			else:
				var exp1 = preload("res://scenes/big_explosion.tscn").instantiate()
				add_child(exp1)
			if smaller == self_name:
				count += 1
				self.get_child(0).visible = false
				self.get_child(1).visible = false
				self.get_child(2).visible = false
