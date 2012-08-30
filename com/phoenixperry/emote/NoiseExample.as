package com.phoenixperry.emote {
	
	import flash.utils.getTimer;
	
	import nl.ronvalstar.math.OptimizedPerlin;
	
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class NoiseExample extends Sprite {
		private var q; 
		private static var iW:int;
		private static var iH:int;
		public  var xpos:Number; 
		public  var ypos:Number; 
		
		public function NoiseExample() {
			addEventListener(Event.ADDED_TO_STAGE, onAdded); 
		
		}
		
		private function onAdded(e:Event):void
		{	iW = this.stage.stageWidth;
			iH = this.stage.stageHeight;
			
			q = new Quad(10,10,0xFFF000);
			this.addChild(q);
			this.addEventListener( Event.ENTER_FRAME, run);
			removeEventListener(Event.ADDED_TO_STAGE, onAdded); 
		}
		private function run(e:Event):void{
			//change the value getTimer is beting multiplied by to control the 
			// craziness of the motion. 00012 - 00005 work well. get timer is returning
			//the time passed in ms. the muliplication scales it down 
			var iTimeX:Number = getTimer()*.00005;
			var iTimeY:Number = iTimeX+123.123;
		//	var t:Number = OptimizedPerlin.noise(iTimeX); 
		//	trace(t); 
			
			//sample motion cube 
		//	q.x = iW*.5 + 3*iW*(OptimizedPerlin.noise(iTimeX)-.5);
		//	q.y = iH*.5 + 3*iH*(OptimizedPerlin.noise(iTimeY)-.5);
			
			//puliclly accessible values 
			xpos = iW*.5 + 3*iW*(OptimizedPerlin.noise(iTimeX)-.5);
			ypos = iH*.5 + 3*iH*(OptimizedPerlin.noise(iTimeY)-.5); 
		//	trace (xpos); 
			ypos = map(ypos, 250, 650, 0, stage.stageHeight); 
			xpos = map(xpos,-100, 2000, 0, stage.stageWidth); 
			q.x= xpos; 
			q.y = ypos; 
		}
		private function map(v:Number, a:Number, b:Number, x:Number = 0, y:Number = 1):Number {
			return (v == a) ? x : (v - a) * (y - x) / (b - a) + x;
		}
	}
}