package efc.body;

import flambe.Component;
import flambe.System;
import flambe.math.Point;

import nape.space.Space;

class Debug extends Component
{
	private var _space :Space;
	
	#if flash
		private var _debugView:nape.util.ShapeDebug;
	#end
	
	public function new(space :Space) :Void 
	{
		_space = space;

		#if flash 
			_debugView = new nape.util.ShapeDebug(System.stage.width, System.stage.height, 0xFF0000);
			_debugView.thickness = 1.4;
			_debugView.drawConstraints = true;
			flash.Lib.current.stage.addChild(_debugView.display);
		#end
	}

	override public function onUpdate(dt:Float) 
	{
		super.onUpdate(dt);
		
		#if flash
			_debugView.clear();
			_debugView.draw(_space);
		#end
	}
	
	override public function dispose() 
	{
		#if flash
			flash.Lib.current.stage.removeChild(_debugView.display);
			_debugView = null;
		#end
		
		super.dispose();
	}

}