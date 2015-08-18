package efc.body;

import flambe.System;
import flambe.Component;
import flambe.display.Sprite;
import flambe.util.Assert;
import flambe.math.FMath;

import nape.shape.Polygon;
import nape.shape.Shape;
import nape.geom.Vec2;

class Body extends Component
{
	public var body (default, null): nape.phys.Body;

	public function new() : Void
	{
		_bodyContainer = System.root.get(BodyContainer);
		body = new nape.phys.Body();
	}

	override public function onUpdate(dt :Float) : Void
	{
		if(body.isSleeping)
			return;
		
		_sprite.rotation._ = FMath.toDegrees(body.rotation);
		_sprite.x._ = body.position.x;
		_sprite.y._ = body.position.y;
	}

	override public function onStart() : Void
	{
		_sprite = owner.get(Sprite);
		body.shapes.add(new Polygon(Polygon.rect(0, 0, _sprite.getNaturalWidth(), _sprite.getNaturalHeight())));
		body.align();
		body.position = Vec2.weak(_sprite.x._, _sprite.y._);
		body.rotation = _sprite.rotation._;


		_bodyContainer.addBody(body);
	}

	private var _bodyContainer : BodyContainer;
	private var _sprite        : Sprite;
	private var _lastX         : Float;
	private var _lastY         : Float;
	private var _lastR         : Float;
}