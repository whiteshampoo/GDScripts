class_name RectUtil


## Contrains a given Rect2 within the boundaries of another Rect2. Returns a new Rect2 with the size of 'inner' and position changed accordingly.
func constrain(inner: Rect2, outer: Rect2)->Rect2:
	var _constrained_x = max(outer.position.x, min(inner.position.x, outer.position.x + outer.size.x - inner.size.x))
	var _constrained_y = max(outer.position.y, min(inner.position.y, outer.position.y + outer.size.y - inner.size.y))
	return Rect2(_constrained_x, _constrained_y, inner.size.x, inner.size.y)
