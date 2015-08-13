package efc.body;

import flambe.System;
import flambe.Component;
import flambe.display.Sprite;
import flambe.util.Assert;

import differ.shapes.Polygon;
import differ.data.ShapeCollision;

class Body extends Component
{
	public var shape (default, null): differ.shapes.Shape;
	public var fnLand (null, default): Void -> Void;

	public function new(type :BodyType) : Void
	{
		Assert.that((_bodyContainer = System.root.get(BodyContainer)) != null, "BodyContainer not found in root. :Body.hx -> createPlatform()");
		_type = type;
	}

	override public function onUpdate(dt :Float) : Void
	{
		shape.x = _sprite.getViewMatrix().m02;
		shape.y = _sprite.getViewMatrix().m12;
		if(_type == Dynamic)
			_bodyContainer.test(this, handleCollision);
	}

	override public function onStart() : Void
	{
		owner.add(new Gravity(_type));
		_sprite = owner.getFromChildren(Sprite);

		shape = Polygon.rectangle(_sprite.getViewMatrix().m02, _sprite.getViewMatrix().m12, _sprite.getNaturalWidth(), _sprite.getNaturalHeight(), false);
	}

	public function toSpace() : Body
	{
		_bodyContainer.addBody(this);
		return this;
	}

	public function gravityOff() : Void
	{
		owner.get(Gravity).isOn = false;
	}

	public function gravityOn() : Void
	{
		owner.get(Gravity).isOn = true;
	}

	public function land(overlap :Float) : Void
	{
		owner.get(Gravity).clear();
		owner.get(Sprite).y._ += overlap;
		if(fnLand != null)
			fnLand();
	}

	private function handleCollision(data :ShapeCollision) : Void
	{
		if(_type != Dynamic)
			return;
		if(data != null)
			land(data.overlap);
	}

	private var _type          : BodyType;
	private var _bodyContainer : BodyContainer;
	private var _sprite        : Sprite;
}