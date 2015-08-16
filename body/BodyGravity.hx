package efc.body;

import flambe.Entity;
import flambe.Component;
import flambe.display.Sprite;

class BodyGravity extends Component
{
	public var isOn : Bool = true;

	public function new(type :BodyType) : Void
	{
		_type = type;
	}

	override public function onUpdate(dt :Float) : Void
	{
		if(_type == Static || !isOn)
			return;
		_sprite.y._ += velocity(dt);
	}

	override public function onStart() : Void
	{
		_sprite = owner.get(Sprite);
		_min = 0.9;
		_max = 4;
		_delta = _min;
	}

	public function clear() : Void
	{
		_delta = _min;
	}

	private inline function velocity(dt :Float) : Float
	{
		if((_delta+=dt) > _max)
			return 5*Math.pow(_max, 3) + 1.5*Math.pow(_max, 3);
		return 5*Math.pow(_delta, 3) + 1.5*Math.pow(_delta, 3);
	}

	private var _type   : BodyType;
	private var _isOn   : Bool;
	private var _sprite : Sprite;
	private var _delta  : Float;
	private var _min    : Float;
	private var _max    : Float;
}