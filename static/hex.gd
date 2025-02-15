class_name Hex
extends Object

## This is a helper class for games/applications that use a hexagon based grid. 
## 
## This is based on the methods described at redblobgames ([url]https://www.redblobgames.com/grids/hexagons[/url]).
## [br][br]
## Some methods are functionally the same as a simple Vector addition/subtraction. They are kept in the class for informational purposes and readability of certain functions.
## [br][br]
## This implementation is currently limited to axial, cube and oddq coordinate systems.

enum COORD_SYSTEM { AXIAL, CUBE, ODDQ}

enum DIR { SOUTHWEST, SOUTH, SOUTHEAST, NORTHEAST, NORTH, NORTHWEST } # Changing this order would break compatibility with AXIAL_DIRECTION

## This maps 1:1 to [member DIR]. Allows for better readability by using 'DIR.SOUTH' instead of '1' when using AXIAL_DIRECTION.
## [code]AXIAL_DIRECTION[DIR.SOUTH] -> (0, 1)[/code]
static var AXIAL_DIRECTION : Array = [Vector2i(-1, 1),Vector2i(0, 1), Vector2i(1, 0), Vector2i(1, -1), Vector2i(0, -1), Vector2i(-1, 0)] # SW,S,SE,NE,N,NW


#region CONVERSION

## Converts coordinate system from cube to axial.
static func cube_to_axial(cube:Vector3i)->Vector2i:
	var q = cube.x
	var r = cube.y
	return Vector2i(q, r)


## Converts coordinate system from axial to cube.
static func axial_to_cube(hex:Vector2i)->Vector3i:
	var q = hex.x
	var r = hex.y
	var s = -q-r
	return Vector3i(q, r, s)


## Converts coordinate system from axial to oddq.
static func axial_to_oddq(coord:Vector2i)->Vector2i:
	if coord == Vector2i.ZERO:
		return Vector2i.ZERO
	var col = coord.x # x -> q | y -> r
	var row = coord.y + (coord.x - (coord.x&1)) / 2
	return Vector2i(col, row)


## Converts coordinate system from oddq to axial.
static func oddq_to_axial(coord:Vector2i)->Vector2i:
	if coord == Vector2i.ZERO:
		return Vector2i.ZERO
	var q = coord.x # x->column | y->row
	var r = coord.y - (coord.x - (coord.x&1)) / 2
	return Vector2i(q, r)


## Converts coordinate system from oddq to cube.
static func oddq_to_cube(coord:Vector2i)->Vector3i:
	return axial_to_cube(oddq_to_axial(coord))


## Converts coordinate system from cube to oddq.
static func cube_to_oddq(coord:Vector3i)->Vector2i:
	return axial_to_oddq(Vector2i(coord.x,coord.y))

#endregion

#region AXIAL


## Adds one Vector2i representing an axial coordinate to another.
static func axial_add(hex_coord:Vector2i, add_vector:Vector2i)->Vector2i:
	return Vector2i(hex_coord.x + add_vector.x, hex_coord.y + add_vector.y)


## Subtracts one Vector2i representing an axial coordinate from another.
static func axial_subtract(a:Vector2i, b:Vector2i)->Vector2i:
	return Vector2i(a.x - b.x, a.y - b.y)


## Returns the axial neighbor coordinate of a given axial coordinate and a direction. See [member AXIAL_DIRECTION] and [member DIR]. [br][br]
## Example:
## [codeblock]
## axial_neighbor(Vector2i(2,1), AXIAL_DIRECTION[DIR.NORTH])
## [/codeblock]
static func axial_neighbor(hex_coord:Vector2i, direction:Vector2i)->Vector2i:
	return axial_add(hex_coord, direction)

## Returns the distance between two axial coordinates.
static func axial_distance(a:Vector2i, b:Vector2i)->Vector2i:
	var vec = axial_subtract(a, b)
	return (abs(vec.x)
		+ abs(vec.x + vec.y)
		+ abs(vec.y)) / 2

#endregion

#region CUBE

## Adds one Vector3i representing a cube coordinate to another.
static func cube_add(hex: Vector3i, vec: Vector3i)->Vector3i:
	return Vector3i(hex.x + vec.x, hex.y + vec.y, hex.z + vec.z)

## Subtracts one Vector3i representing a cube coordinate from another.
static func cube_subtract(a: Vector3i, b: Vector3i)->Vector3i:
	return Vector3i(a.x - b.x, a.y - b.y, a.z - b.z)

## Returns the distance between two cube coordinates.
static func cube_distance(a: Vector3i, b: Vector3i):
	var vec = cube_subtract(a, b)
	return (abs(vec.x) + abs(vec.y) + abs(vec.z)) / 2

#endregion

#region ROTATION (CONVERT TO CUBE FIRST)

## Returns the amount of 60 degree steps required to rotate from one [member DIR] to another. 
## Negative values represent counter clockwise rotations.[br][br]
## Example:
## [code]get_rotation_steps(DIR.NORTH, DIR.SOUTHEAST) -> -2[/code]
## [br][br]
## [url]https://www.redblobgames.com/grids/hexagons/#rotation[/url]
static func get_rotation_steps(from_dir: DIR, to_dir: DIR) -> int:
	var total_directions = Hex.DIR.size()
	# Difference between the given directions.
	var diff = to_dir - from_dir
	diff = wrapi(diff, 0, total_directions)
	# If the difference is larger than half the amount of directions, the shorter path
	# is counter clockwise.
	if diff > total_directions / 2:
		diff -= total_directions
	return diff

## Rotates a given cube coordinate clockwise.
static func rotate_clockwise(vec: Vector3i)->Vector3i:
	var return_vector: Vector3i = Vector3i(-vec.z,-vec.x,-vec.y)
	return return_vector

## Rotates a given cube coordinate counter clockwise.
static func rotate_counter_clockwise(vec: Vector3i)->Vector3i:
	var return_vector: Vector3i = Vector3i(-vec.y,-vec.z,-vec.x)
	return return_vector

## Rotates a given cube coordinate by a given amount of rotation steps. See [member get_rotation_steps()].
static func rotate(vec: Vector3i,rotation_steps:int)->Vector3i:
	for step in range(abs(rotation_steps)):
		if rotation_steps > 0:
			vec = rotate_clockwise(vec)
		else:
			vec = rotate_counter_clockwise(vec)
	return vec
	

#endregion


#region RANGE

## Returns coordinates in range of a given axial coordinate.
static func cells_in_range_axial(of_axial_position:Vector2i,cell_range:int)->Array[Vector2i]:
	var cells : Array[Vector2i] = []
	var q = -cell_range
	while q <= cell_range:
		var r = max(-cell_range, -q-cell_range)
		while r <= min(cell_range,-q+cell_range):
			cells.append(Hex.axial_add(of_axial_position,Vector2i(q,r)))
			r+=1
		q+=1 
	return cells

## Returns coordinates in range of a given oddq coordinate.
static func cells_in_range_oddq(of_oddq_position:Vector2i,cell_range:int)->Array[Vector2i]:
	var of_position_axial = Hex.oddq_to_axial(of_oddq_position)
	var cells = cells_in_range_axial(of_position_axial,cell_range)
	for i in range(cells.size()):
		cells[i] = Hex.axial_to_oddq(cells[i])
	return cells


#endregion
