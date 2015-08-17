package efc.body;

import flambe.System;
import flambe.Component;
import flambe.display.Sprite;
import flambe.display.ImageSprite;
import flambe.animation.Ease;
import flambe.util.Assert;
import flambe.math.FMath;

import nape.shape.Polygon;
import nape.shape.Shape;
import nape.phys.BodyType;
import nape.geom.GeomPoly;
import nape.geom.Vec2;

class Body extends Component
{
	public var body (default, null): nape.phys.Body;

	public function new(?type :BodyType) : Void
	{
		_bodyContainer = System.root.get(BodyContainer);
		body = new nape.phys.Body();
		if(type != null)
			body.type = type;
	}

	override public function onUpdate(dt) : Void
	{
		if(body.type != BodyType.STATIC) {
			// _sprite.centerAnchor();
			_sprite.x._ = body.position.x;
			_sprite.y._ = body.position.y;
			_sprite.rotation._ = FMath.toDegrees(body.rotation);
		}
	}

	override public function onStart() : Void
	{
		var spr :ImageSprite;
		spr = cast owner.get(Sprite);

		var poly :GeomPoly = new GeomPoly(BodyTracer.traceTexture(spr.texture, 0));
		var convexList = poly.convexDecomposition();
		for(geomPoly in convexList) {
			body.shapes.add(new Polygon(geomPoly));
		}
		// body.align();
		var matrix = spr.getViewMatrix();
		var rotation = Math.atan2(-matrix.m01, matrix.m00);
		body.position = Vec2.weak(matrix.m02, matrix.m12);
		body.rotation = rotation;

		_bodyContainer.addBody(body);
		_sprite = spr;
	}

	private var _type          : BodyType;
	private var _bodyContainer : BodyContainer;
	private var _sprite        : Sprite;
}