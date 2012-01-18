package py.edu.fpune.transitorios
{
	import caurina.transitions.Tweener;
	
	import flash.display.BlendMode;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class Grafico extends Sprite
	{
		public var analisis:Analisis;

		private var cartesianPlane:Sprite = new Sprite();

		private var tPixelsMax:Number = 800;
		private var vPixelsMax:Number = 500;		
		private var tAxisMax:Number;
		private var vAxisMax:Number;
		private var tToPixelScale:Number;
		private var vToPixelScale:Number;		
		
		private var shapesZero:Array;
		private var shapesMedium:Array;
		public function Grafico(analisis:Analisis)
		{
			this.analisis = analisis;
			
			this.tAxisMax = analisis.period * analisis.graphicValuesR.length;
			
			this.vAxisMax = 0;
			for(var i:int=0; i<analisis.graphicValuesR.length; ++i)
			{
				this.vAxisMax = Math.max( vAxisMax, analisis.graphicValuesR[i] ); 
			}
			
			this.tToPixelScale = tPixelsMax/tAxisMax;
			this.vToPixelScale = vPixelsMax/vAxisMax;			
			
			init();
		}
		private function init():void
		{
			initCartesianPlane();
			periodComplete(null);
			analisis.periodTimer.addEventListener(TimerEvent.TIMER, periodComplete);
			analisis.periodTimer.start();						
		}
		private function initCartesianPlane():void
		{			
			var axis:Shape = new Shape();
				axis.graphics.lineStyle(5,0xff0000,1,false,LineScaleMode.VERTICAL,
											CapsStyle.NONE, JointStyle.MITER, 10);
				axis.graphics.moveTo(100,0);
				axis.graphics.lineTo(100,vPixelsMax);
				axis.graphics.lineTo(tPixelsMax+100,vPixelsMax);
			
			cartesianPlane.addChild(axis);
			cartesianPlane.y = 50;
			addChild(cartesianPlane);
		}
 		private function periodComplete(event:TimerEvent):void
		{
			var periodNumber:Number;
			
			//to solve the problem of the first iteration, where event=null
			if(event !=null)
			{
				periodNumber = event.currentTarget.currentCount;
			}else
			{
				periodNumber = 0;
			}
			
			//the amplitude in real scale of the voltage
			var amplitude:Number = analisis.graphicValuesR[periodNumber];
			//the period in pixels scale
			var shapeWidth:Number = analisis.period*tToPixelScale;
			//the amplitude in pixel scale of the voltage
			var shapeHeight:Number = amplitude*vToPixelScale;

			/* 
			graphics of the 0xaaaaaa blocks
			using a alpha transition
			 */
			var shape:Shape = new Shape();
			shape.graphics.beginFill(0xaaaaaa - 0*0x111111*periodNumber,1);
			shape.graphics.drawRect(100 + shapeWidth*periodNumber,
									vPixelsMax-shapeHeight,
									shapeWidth,
									shapeHeight);
			shape.graphics.endFill();
			shape.blendMode = BlendMode.MULTIPLY;
			shape.alpha = 0;
			cartesianPlane.addChild(shape);
			Tweener.addTween( shape, {alpha:0.1, time:analisis.period/1000, transition:"easeInExpo"} );
			
			/* 
			graphics of the lines, with transitions
			and indetermination solves 			
			 */			 
			//where begin the graphics (x position, in pixels)
			//i use +100 to center in the cartesian plane (translation)
 			var _beginX:Number = (shapeWidth*periodNumber ) + 100;
 			//where begin the graphics (y position, in pixels)
 			//i use -50 to center in the cartesian plane (translation)
 			var _beginY:Number = shapeHeight-50;
 			//where end the graphics (x position, in pixels)
 			var _endX:Number = _beginX +  shapeWidth;
 			//where end the graphics, same to the init (y position, in pixels)
 			var _endY:Number = _beginY;
 			//the previous _endY (the amplitude of the previous period)
 			//to use for draw the indetermination line (horizontal) betwen the old and the new interval
 			var _oldY:Number = analisis.graphicValuesR[periodNumber-1]*vToPixelScale-50;
 			//the auxiliar object used for tween
 			var _obj:Object = new Object();
 				_obj.goTo = _beginX; 				
 			
 			//don't draw the indetermination solver in the first step
 			if(periodNumber > 0)	
 			{
 				//the indetermination solver
 				//used to draw the horizontal lines betwen two periods
	 			var verticalLineForIndetermination:Shape = new Shape();
					verticalLineForIndetermination.graphics.
											lineStyle(3,0x0000ff,1,false,
											LineScaleMode.VERTICAL, CapsStyle.NONE, 
											JointStyle.MITER, 10);
					verticalLineForIndetermination.graphics.moveTo(_beginX,vPixelsMax-_beginY);
					verticalLineForIndetermination.graphics.lineTo(_beginX,vPixelsMax-_oldY);
					addChild(verticalLineForIndetermination);
			} 			
			//drawing the voltage function defining a shape, and tweening it
			//in the time=period
 			var voltageLine:Shape = new Shape();
				voltageLine.graphics.lineStyle(3,0x0000ff,1,false,
										LineScaleMode.VERTICAL, CapsStyle.NONE, 
										JointStyle.MITER, 10);
 			
 				voltageLine.graphics.moveTo(_beginX, vPixelsMax - _beginY);
 			addChild(voltageLine);	
 			trace("beginX: "+_beginX + "; beginY: "+_beginY + "; endX: "+_endX + "; endY: "+_endY );      
 			Tweener.addTween( _obj, {time:0.98*analisis.period/1000,
 									transition:"linear",
 									goTo:_endX,

 									onUpdate:function():void
 									{
 										//trace("goTo de x" + 
 										voltageLine.graphics.lineTo(_obj.goTo,vPixelsMax - _endY);
 									},
 									onComplete:function():void
 									{
 										trace("end rect draw");
 										trace("se movio desde _beginX:" + _beginX + "hasta _endX:"+ _endX+"con un _endY:"+_endY);
 										var a:int;
 									}
 									
 								});

			
			var txtDecimalsValue:Number = int( (amplitude - int(amplitude))*1000 );
			var txtIntegerValue:Number = int(amplitude);
			var txtText:String = txtIntegerValue.toString() + "." + txtDecimalsValue.toString();
			 
			var txtformat:TextFormat = new TextFormat(null,20,0x0);
 			var txt:TextField = new TextField();
 				txt.text = txtText; //showing 3 decimals only //amplitude.toString();
 				txt.autoSize = TextFieldAutoSize.CENTER; 											
 				txt.setTextFormat(txtformat);
 				txt.x = _obj.goTo+10;
 				txt.y = vPixelsMax-_endY - txt.width-10 - 20* Math.pow(-1,periodNumber) ;
 				
 				addChild( txt );

 								
 								 
 			Tweener.addTween( _obj, {time:0.98*analisis.period/1000/2, 
 									transition:"linear",
 									onComplete:function():void
 									{
 									}
 									
 							});
 			
 
		}
		
	}
}












