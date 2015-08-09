package;

import flambe.Entity;
import flambe.System;
import flambe.Component;
import flambe.input.KeyboardEvent;
import flambe.Disposer;

class Controller extends Component
{
	public var fnLeft  (null, default): Float -> Void;
	public var fnRight (null, default): Float -> Void;
	public var fnUp    (null, default): Float -> Void;
	public var fnDown  (null, default): Float -> Void;
	public var fnSpace (null, default): Float -> Void;

	public function new(min :Float, max :Float) : Void
	{
		_min = min;
		_max = max;

		init();
	}	

	override public function onUpdate(dt :Float) : Void
	{
		var v = velocity();
		if(_isLeft && fnLeft != null) 
			fnLeft(v);
		else if(_isRight && fnRight != null)
			fnRight(v);
		else if(_isUp && fnUp != null)
			fnUp(v);
		else if(_isDown && fnDown != null)
			fnDown(v);
		else if(_isSpace && fnSpace != null)
			fnSpace(v);
		else {
			_speed = _min;
			return;
		}

		_speed += 0.05;
	}

	override public function onStart() : Void
	{
		owner.addChild(_container);
	}

	private function init() : Void
	{
		_speed = _min;
		var d : Disposer;
		_container = new Entity()
			.add(d = new Disposer());

		_container.get(Disposer).connect1(System.keyboard.down, onKeyDown);
		_container.get(Disposer).connect1(System.keyboard.up, onKeyUp);
	}

	private function onKeyDown(e :KeyboardEvent) : Void
	{
		switch (e.key) {
			case A: _isLeft = true; _isRight = false; _isUp = false; _isDown = false; _isSpace = false; _speed = _min; //left
			case D: _isLeft = false; _isRight = true; _isUp = false; _isDown = false; _isSpace = false; _speed = _min; //right
			case W: _isLeft = false; _isRight = false; _isUp = true; _isDown = false; _isSpace = false; //up
			case S: _isLeft = false; _isRight = false; _isUp = false; _isDown = true; _isSpace = false; //down
			case Space: _isLeft = false; _isRight = false; _isUp = false; _isDown = false; _isSpace = true; //action
			default:
		}
	}

	private function onKeyUp(e :KeyboardEvent) : Void
	{
		switch (e.key) {
			case A: _isLeft  = false;
			case D: _isRight = false;
			case W: _isUp    = false;
			case S: _isDown  = false;
			case Space: _isSpace = false;
			default:
		}
	}

	private inline function velocity() : Float
	{
		if(_speed > _max)
			return 0.4*Math.pow(_max, 3) + 1.3*Math.pow(_max, 3);
		return 0.4*Math.pow(_speed, 3) + 1.3*Math.pow(_speed, 3);
	}

	private var _speed     : Float;
	private var _isLeft    : Bool = false;
	private var _isRight   : Bool = false;
	private var _isUp      : Bool = false;
	private var _isDown    : Bool = false;
	private var _isSpace   : Bool = false;
	private var _container : Entity;
	private var _min       : Float;
	private var _max       : Float;
}