package;

import flambe.System;
import flambe.Component;
import flambe.display.Sprite;
import flambe.util.Assert;

import differ.shapes.Polygon;
import differ.data.ShapeCollision;

class Body extends Component
{
	public var shape (default, null): differ.shapes.Shape;

	public function new(name :String) : Void
	{
		Assert.that((_bodyContainer = System.root.get(BodyContainer)) != null, "BodyContainer not found in root. :Body.hx -> createPlatform()");
		_name = name;
	}

	override public function onUpdate(dt :Float) : Void
	{
		shape.x = _sprite.getViewMatrix().m02;
		shape.y = _sprite.getViewMatrix().m12;
		_bodyContainer.test(this, handleCollision);
	}

	override public function onStart() : Void
	{
		_sprite = owner.getFromChildren(Sprite);

		shape = Polygon.rectangle(_sprite.getViewMatrix().m02, _sprite.getViewMatrix().m12, _sprite.getNaturalWidth(), _sprite.getNaturalHeight(), false);
		shape.name = _name;
	}

	public function toSpace() : Body
	{
		_bodyContainer.addBody(this);
		return this;
	}

	private function handleCollision(data :ShapeCollision) : Void
	{
	}

	private var _name          : String;
	private var _bodyContainer : BodyContainer;
	private var _sprite        : Sprite;
}