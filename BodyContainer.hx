package;

import flambe.Component;
import differ.data.ShapeCollision;

class BodyContainer extends Component
{
	public function new() : Void
	{
		_bodies = new Array<Body>();
	}

	public function addBody(body :Body) : Void
	{
		_bodies.push(body);
	}

	public function test(body :Body, fn :ShapeCollision -> Void) : Void
	{
		for(b in _bodies) {
			if(b != body)
				fn(body.shape.test(b.shape));
		}
	}

	private var _bodies    : Array<Body>;
}