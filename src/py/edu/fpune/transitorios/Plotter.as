package py.edu.fpune.transitorios
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	public class Plotter
	{
		private var _displayObject:DisplayObject;
		
		public function Plotter(displayObject:DisplayObject, from:Point, tO:Point)
		{
			_displayObject = displayObject;			
		}

	}
}