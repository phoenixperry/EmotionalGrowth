package com.phoenixperry.emote
{
	import com.phoenixperry.emote.Tendril;
	
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;

	public class Plant extends Sprite
	{
		private var xpos:Number; 
		private var ypos:Number; 
		private var tendrils:Array = []; 
		private var tends:Number =12; 
		private var w_:Number = 15; 
		private var mood:String; 
		private var  r:Number;
		private var len:Number;
		public function Plant(xpos_:Number, ypos_:Number,len_:Number, r_:Number, mood_:String, tends_:Number)
		{
			mood = mood_
			xpos = xpos_; 
			ypos = ypos_; 
			len=len_; 
			r = r_; 
		//	tends =tends_; 
			
			addEventListener(Event.ADDED_TO_STAGE, onAdded); 
		}
		private function playEm(e:Event):void{
		
			var tendril:Tendril = new Tendril(xpos,ypos,r,0.8,len, 5, mood); 
			addChild(tendril); 
			tends --; 
			//tendrils.push(tendril); 
		
			if(tends == 0) { 
				removeEventListener(Event.ENTER_FRAME, playEm); 
			}
		}
		private function onAdded(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAdded); 
			addEventListener(Event.ENTER_FRAME, playEm); 
			
			
		}
	}
}