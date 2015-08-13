package efc.body;

import flambe.System;
import flambe.Component;
import flambe.display.Sprite;
import flambe.animation.Ease;
import flambe.util.Assert;
import flambe.math.FMath;

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
		var matrix = _sprite.getViewMatrix();
		var rotation = FMath.toDegrees(Math.atan2(-matrix.m01, matrix.m00));
		shape.rotation = rotation;
		shape.x = matrix.m02;
		shape.y = matrix.m12;
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

	public function land(overlapX :Float, overlapY :Float, rotation :Float) : Void
	{
		owner.get(Gravity).clear();
		owner.get(Sprite).y._ += overlapY;
		owner.get(Sprite).x._ += overlapX + FMath.toRadians(rotation);
		owner.get(Sprite).rotation.animateTo(rotation, 0.05);
		if(fnLand != null)
			fnLand();
	}

	private function handleCollision(data :ShapeCollision) : Void
	{
		if(_type != Dynamic)
			return;
		if(data != null) {
			land(data.separation.x, data.separation.y, data.shape2.rotation);
		}
	}

	private var _type          : BodyType;
	private var _bodyContainer : BodyContainer;
	private var _sprite        : Sprite;
}