package efc.body;

import flambe.Component;
import flambe.display.Texture;
import flambe.util.Assert;
import haxe.io.Bytes;
import nape.geom.Vec2;

class BodyTracer extends Component
{
	public static function traceTexture(texture :Texture, tolerance :Int) :Array<Vec2> 
	{
		var data :Bytes = texture.readPixels(0, 0, texture.width, texture.height);

		var arra = populateArray(data, texture.width, texture.height);
		var startPoint = getStartingPixel(tolerance, arra, texture.width, texture.height);
		return marchingSquares(startPoint, arra, tolerance, texture.width, texture.height);
	}

	private static function populateArray(data :Bytes, width :Int, height :Int) :Array<Array<Int>>
	{
		var val :Int;
		var alphaData = [for (i in 0...width) [for (i in 0...height) 0]];

		for(i in 0...data.length) {
			if((val = data.get(i)) != 0 && (i+1)%4 == 0) {
				var row = Math.floor(Math.floor(i/4)/width);
				var column = Math.floor(i/4)%width;
				alphaData[row][column] = val;
			}
		}
		return alphaData;
	}

	private static function getStartingPixel(tolerance :Int, arra :Array<Array<Int>>, width: Int, height :Int) :Vec2 
	{
		for (x in 0...width) {
			for (y in 0...height) {
				if(arra[x][y] > tolerance)
					return new Vec2(x, y);
			}
		}

		Assert.fail("no starting pixel");
		return null;
	}

	private static function getSquareValue(p :Vec2, tolerance :Int, arra :Array<Array<Int>>) :Int
	{
		Assert.that(tolerance > -1, "Tolerance must be positive. :BodyTracer.hx getSquareValue()");
		var squareValue :Int = 0;
		var x = cast p.x;
		var y = cast p.y;

		if(x!=0 && y!=0 && arra[x-1][y-1] > tolerance)
			squareValue |=1;
		if(y!=0 && arra[x][y-1] > tolerance)
			squareValue |=2;
		if(x!=0 && arra[x-1][y] > tolerance)
			squareValue |=4;
		if(arra[x][y] > tolerance)
			squareValue |=8;

		return squareValue;
	}

	private static function marchingSquares(startV :Vec2, arra :Array<Array<Int>>, tolerance :Int, width :Int, height :Int) :Array<Vec2> 
	{
		var contourVector :Array<Vec2> = new Array<Vec2>();
		var walkerV = new Vec2(startV.x, startV.y);
		var prevDirection : Direction; 

		var closedLoop :Bool = false;

		while (!closedLoop) {
			var squareValue :Int = getSquareValue(walkerV, tolerance, arra);
			switch (squareValue) {
				case 1: prevDirection = stepUp(walkerV);
				case 2: prevDirection = stepRight(walkerV);
				case 3: prevDirection = stepRight(walkerV);
				case 4: prevDirection = stepLeft(walkerV);
				case 5: prevDirection = stepUp(walkerV);
				case 6: prevDirection = handleCase6(prevDirection, walkerV);
				case 7: prevDirection = stepRight(walkerV);
				case 8: prevDirection = stepDown(walkerV);
				case 9: prevDirection = handleCase9(prevDirection, walkerV);
				case 10: prevDirection = stepDown(walkerV);
				case 11: prevDirection = stepDown(walkerV);
				case 12: prevDirection = stepLeft(walkerV);
				case 13: prevDirection = stepUp(walkerV);
				case 14: prevDirection = stepLeft(walkerV);
			}
			contourVector.push(new Vec2(walkerV.y, walkerV.x));
			if (walkerV.x == startV.x && walkerV.y == startV.y)
				closedLoop=true;
		}

		startV.dispose();
		return contourVector;
	}

	private static function stepLeft(v :Vec2) :Direction
	{
		v.x -= 1;
		return LEFT;
	}

	private static function stepUp(v :Vec2) :Direction
	{
		v.y -= 1;
		return UP;
	}

	private static function stepRight(v :Vec2) :Direction
	{
		v.x += 1;
		return RIGHT;
	}

	private static function stepDown(v :Vec2) :Direction
	{
		v.y += 1;
		return DOWN;
	}

	private static function handleCase6(prevDir :Direction, v :Vec2) :Direction
	{
		if(prevDir == UP) {
			return stepLeft(v);
		}
		return stepRight(v);
	}

	private static function handleCase9(prevDir :Direction, v :Vec2) :Direction
	{
		if(prevDir == RIGHT) {
			return stepUp(v);
		}
		return stepDown(v);
	}
}

enum Direction {
	UP;
	DOWN;
	LEFT;
	RIGHT;
}



