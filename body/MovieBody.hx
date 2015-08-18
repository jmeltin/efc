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
import nape.phys.BodyType.KINEMATIC;
import nape.geom.GeomPoly;
import nape.geom.Vec2;

class MovieBody extends Component
{
	public var body (default, null): nape.phys.Body;

	public function new() : Void
	{
		_bodyContainer = System.root.get(BodyContainer);
		body = new nape.phys.Body(KINEMATIC);
	}

	override public function onUpdate(dt :Float) : Void
	{
		var matrix = _sprite.getLocalMatrix();
		var rotation = Math.atan2(-matrix.m01, matrix.m00);
		body.position = Vec2.weak(matrix.m02 + _offsetX, matrix.m12 + _offsetY);
	}

	override public function onStart() : Void
	{
		_sprite = owner.get(ImageSprite);
		var poly :GeomPoly = new GeomPoly(BodyTracer.traceTexture(_sprite.texture, 2)).simplify(4);
		var convexList = poly.convexDecomposition();
		for(geomPoly in convexList)
			body.shapes.add(new Polygon(geomPoly));
		var vMatrix = _sprite.getViewMatrix();
		var lMatrix = _sprite.getLocalMatrix();

		_offsetX = vMatrix.m02 - lMatrix.m02;
		_offsetY = vMatrix.m12 - lMatrix.m12;

		_bodyContainer.addBody(body);
	}

	private var _offsetX       : Float;
	private var _offsetY       : Float;
	private var _bodyContainer : BodyContainer;
	private var _sprite        : ImageSprite;
}