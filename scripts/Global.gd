extends Node
var G = 6.67e-11
var data = [
	{ "heavenly_body": "Sun", "distance": 0.0, "radius": 695_700_000.0, "mass": 1989099999999999887809347321856.0 },
	{ "heavenly_body": "Mercury", "distance": 57_000_000_000.0, "radius": 2_439_000.0, "mass": 330110000000000013107200.0 },
	{ "heavenly_body": "Venus", "distance": 108_000_000_000.0, "radius": 6_052_000.0, "mass": 4867500000000000349175808.0 },
	{ "heavenly_body": "Earth", "distance": 150_000_000_000.0, "radius": 6_371_000.0, "mass": 5972400000000000121634816.0 },
	{ "heavenly_body": "Mars", "distance": 228_000_000_000.0, "radius": 3_390_000.0, "mass": 641710000000000034078720.0 },
	{ "heavenly_body": "Jupiter", "distance": 779_000_000_000.0, "radius": 69_911_000.0, "mass": 1898186999999999908583047168.0 },
	{ "heavenly_body": "Saturn", "distance": 1_430_000_000_000.0, "radius": 58_232_000.0, "mass": 568316999999999991877730304.0 },
	{ "heavenly_body": "Uranus", "distance": 2_880_000_000_000.0, "radius": 25_362_000.0, "mass": 86812999999999999595249664.0 },
	{ "heavenly_body": "Neptune", "distance": 4_500_000_000_000.0, "radius": 24_622_000.0, "mass": 102413000000000007279214592.0 }
]

# for this scale, scale targets at 350000
# for e7 distance, scale targets at 70000
var distance_scale = 1e6 * 0.5
var radii_scale = 1e3
var mass_scale = 1e8
var distances: Array = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0] 	
var radii: Array = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
var masses: Array = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
var periods: Array = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
var rotation_angle = 0.002
var planet_eccentricities = [0.1, 0.2056, 0.0067, 0.0167, 0.0934, 0.0489, 0.0565, 0.0463, 0.0097]

func instantiate_values():
	G = 6.6e-11
	for ind in range(9):
		var body = data[ind]
		distances[ind] = body["distance"]	 
		masses[ind] = body["mass"]
		radii[ind] = body["radius"]

func scientific_notation(number):
	var _exp
	var _dec
	var ret
	if number > 1:
		_exp = str(number).split(".")[0].length() - 1
		_dec = number / pow(10,_exp)
		ret = "{dec}x10^{exp}"
	else:
		_exp = -1
		for i in str(number):
			if i in ['0', '.']:
				_exp += 1
			else:
				break
		_dec = number * pow(10, _exp)
		ret = "{dec}x10^-{exp}"
	return ret.format({"dec":("%1.2f" % _dec), "exp":str(_exp)})
