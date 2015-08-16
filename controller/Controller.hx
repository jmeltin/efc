package efc.controller;

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
		if(_isRight && fnRight != null)
			fnRight(v);
		if(_isUp && fnUp != null)
			fnUp(v);

		_speed += 0.05;
	}

	override public function onStart() : Void
	{
		owner.addChild(_container);
	}

	private function init() : Void
	{
		_speed = _min;
		_container = new Entity()
			.add(new Disposer());

		_container.get(Disposer).connect1(System.keyboard.down, onKeyDown);
		_container.get(Disposer).connect1(System.keyboard.up, onKeyUp);
	}

	private inline function onKeyDown(e :KeyboardEvent) : Void
	{
		switch (e.key) {
			case A: _isLeft = true; _isRight = false; _isDown = false; _isSpace = false;
			case D: _isLeft = false; _isRight = true; _isDown = false; _isSpace = false;
			case W: _isUp = true; _isDown = false; _isSpace = false; //up
			default:
		}
	}

	private inline function onKeyUp(e :KeyboardEvent) : Void
	{
		switch (e.key) {
			case A: _isLeft  = false;
			case D: _isRight = false;
			case W: _isUp    = false;
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