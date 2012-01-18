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
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class CelosiasDiagram extends Sprite
	{
		public var celosiaSprite:Sprite = new Sprite();

		private var maxWidth:Number = 300;
		private var maxHeight:Number = 550;
		
		private var analisis:Analisis;
		
		private var p1:Point = new Point();
		private var p2:Point = new Point();
		private var line:Shape = new Shape();
		
		public function CelosiasDiagram(analisis:Analisis)
		{
			super();
			this.analisis = analisis;
			init();
		}
		private function init():void
		{
			initAxis();
			addChild(line);

			drawLines(null);
			analisis.periodTimer.addEventListener(TimerEvent.TIMER, drawLines);
		}
		private function initAxis():void
		{
			var axisLeft:Shape = new Shape();
				axisLeft.graphics.lineStyle(5,0xff0000,1,false,LineScaleMode.VERTICAL,
											CapsStyle.NONE, JointStyle.MITER, 10);
				axisLeft.graphics.lineTo(0,maxHeight);			
			celosiaSprite.addChild(axisLeft);	
			
			var axisRight:Shape = new Shape();
				axisRight.graphics.lineStyle(5,0xff0000,1,false,LineScaleMode.VERTICAL,
											CapsStyle.NONE, JointStyle.MITER, 10);
				axisRight.graphics.moveTo(maxWidth,0)
				axisRight.graphics.lineTo(maxWidth,maxHeight);
			celosiaSprite.addChild(axisRight);
			
			addChild(celosiaSprite);		
			
		}
		private var obj:Object = new Object();
		private function drawLines(event:TimerEvent):void
		{
			
			var periodNumber:Number;
			if(event !=null)
			{
				periodNumber = event.currentTarget.currentCount;
			}else
			{
				periodNumber = 0;
			}
			
			var inclination:Number = Math.pow( -1, periodNumber+1 );
			var rectHeight:Number = maxHeight / analisis.graphicValuesR.length;
			p2.y += rectHeight; 
			p2.x = maxWidth/2 + maxWidth/2 * (-1*inclination) ;
			
			line.graphics.lineStyle(1,0x0000ff,1,false,LineScaleMode.VERTICAL,
										CapsStyle.NONE, JointStyle.MITER, 10);
 			line.graphics.moveTo( p1.x, p1.y );

 			obj.f = 1;
 			obj.x = p1.x;
 			obj.y = p1.y;
 			Tweener.addTween(obj, {f:0, x:p2.x, y:p2.y, time:analisis.period/1000, transition:"linear",
										onUpdate:function():void
										{
				 							line.graphics.lineTo( obj.x, obj.y );
				 						}
 									});
 									
 			Tweener.addTween(obj, { time:analisis.period/2000,
 									transition:"linear",
 									onComplete:function():void
 									{
 										var celosiasValue:Number = analisis.celosias[periodNumber];
										var txtDecimalsValue:Number = int( (celosiasValue - int(celosiasValue))*1000 );
										var txtIntegerValue:Number = int(celosiasValue);
										var txtText:String = txtIntegerValue.toString() + "." + txtDecimalsValue.toString();
										 
										var txtformat:TextFormat = new TextFormat(null,20,0xffffff);
							 			var txt:TextField = new TextField();
							 				txt.text = txtText; 
							 				txt.autoSize = TextFieldAutoSize.CENTER; 											
							 				txt.setTextFormat(txtformat);
							 				txt.x = obj.x-15;
							 				txt.y = obj.y-15;
							 				txt.opaqueBackground=true;
							 				addChild( txt );
 									}				
 			
							});
 			//trace( "grafico en: p1("+p1.x+","+p1.y+"); p2("+p2.x+","+p2.y+");" ); 
			p1.y += rectHeight;	
			p1.x = p2.x; 
			
			
		}
	}
}