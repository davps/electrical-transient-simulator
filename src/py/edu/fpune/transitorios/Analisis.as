package py.edu.fpune.transitorios
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class Analisis 
	{
				
		/**
		 *Parámetros de entrada:
		 * Voltaje de la fuente 
		 */		
		public var voltaje:Number;		
		
		/**
		 * Parámetros de entrada:
		 * roR, del lado de la carga 
		 */		
		public var roR:Number; 	
		
		/**
		 * Parámetros de entrada:
		 * roS, del lado del generador 
		 */		
		public var roS:Number; 	//hacia el generador
		
		public var zC:Number;
		public var zS:Number;
		
		/**
		 *Periodo T 
		 */		
		public var period:Number;
		
		/**
		 *Objeto timer utilizado para manejar el periodo
		 * @see Timer
		 * @see Event 
		 */		
		public var periodTimer:Timer;
		
		/**
		 *Parámetros de salida:
		 * Array que contiene los valores correspondientes a la curva
		 * de voltaje en función del tiempo, medido sobre la carga 
		 */		
		public var graphicValuesR:Array = new Array();
		
		/**
		 *Parámetros de cálculo: 
		 * Utilizados en el diagrama de celosías, tras la aplicación de
		 * las multiplicaciones por roR y roS
		 * @ see roR
		 * @ see roS
		 */		
		public var celosias:Array = new Array();
		
		/*  */
		private var orientation:String = OrientationType.HACIA_LA_CARGA;
		
		public function Analisis(voltaje:Number, roR:Number, roS:Number, period:Number=1000, steps:Number=6, zC:Number=0, zS:Number=0)
		{
			this.zC = zC;
			this.zS = zS;
			this.voltaje = voltaje;
			this.roR = roR;
			this.roS = roS;
			this.period = period;
			init(steps);
		}
		private function init(steps:Number):void
		{
			//TODO:revisar si esto es necesario o no ==> celosias.push( 0.001);
			celosias.push( this.voltaje * zC / (zC+zS) );
			
			graphicValuesR.push( 0.0001 );
			
			var i:int=steps;			
			while(--i > -1)
			{
				onT(null);
			}
			
			periodTimer = new Timer(period, steps);
//			periodTimer.addEventListener(TimerEvent.TIMER, onT)
//			periodTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onCompleteT)
//			periodTimer.start();
		
		}
		private function onT(event:TimerEvent):void
		{
			//hacia el lado de la carga
			applyCelosiasRule();	
			
			var sumador:Number = 0;
			for( var i:int = 0; i<celosias.length; ++i)
			{
				sumador = sumador + celosias[i];
			}
			graphicValuesR.push( sumador );
//			trace(sumador);

			//hacia el lado del generador
			applyCelosiasRule();
			
		}
		private function applyCelosiasRule():void
		{
			//TODO
			celosias.push(  (orientation == OrientationType.HACIA_LA_CARGA) ? celosias[celosias.length-1]*roR    : celosias[celosias.length-1]*roS  );
			orientation = (orientation == OrientationType.HACIA_LA_CARGA) ? OrientationType.HACIA_EL_GENERADOR : OrientationType.HACIA_LA_CARGA;
		}

	}
}