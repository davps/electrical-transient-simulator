package {
	import py.edu.fpune.transitorios.Analisis;
	import py.edu.fpune.transitorios.Grafico;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.TimerEvent;

	[SWF(backgroundColor="#ffffff", frameRate="32")]

	public class Main extends Sprite
	{
		private var analisis:Analisis;
		public function Main()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			analisis = new Analisis(100,-0.5,-1,100,10);
			var grafico:Grafico = new Grafico(analisis);
			addChild(grafico);			
		}
	}
}

