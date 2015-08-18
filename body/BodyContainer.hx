package efc.body;

import flambe.System;
import flambe.Component;
import flambe.display.Sprite;
import flambe.display.ImageSprite;
import flambe.animation.Ease;
import flambe.util.Assert;
import flambe.math.FMath;

import nape.space.Space;
import nape.geom.Vec2;

class BodyContainer extends Component
{
	public function new() : Void
	{
		_space = new Space(new Vec2(0, 1300));
	}

	override public function onStart() : Void
	{
		#if flash
			owner.add(new Debug(_space));
		#end
	}

	override public function onUpdate (dt :Float) : Void
	{
		_space.step(dt);
	}

	public function addBody(body :nape.phys.Body) : Void
	{
		body.space = _space;
	}

	private var _space :Space;
}