////@func Vector2([x], [y])
function Vector2(_x = 0, _y = 0) constructor {
	x = _x;
	y = _y;

	static add = function (_vector, _scalar = 1) {
		if (instanceof(_vector) == "Vector2") {
			var _xx = x + (_scalar * _vector.x);
			var _yy = y + (_scalar * _vector.y);
			x = _xx;
            y = _yy;
		}
	}

    static set = function (_x = x, _y = y) {
        x = _x;
        y = _y;
    }

}
