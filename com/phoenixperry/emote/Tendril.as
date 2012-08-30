package com.phoenixperry.emote
{
	import com.greensock.*;
	import com.phoenixperry.emote.StarSpriteCostume;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.events.TimerEvent;
	import flash.events.UncaughtErrorEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import org.osmf.events.TimeEvent;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	
	public class Tendril extends starling.display.Sprite
	{
		private var c:ColorTransform = new ColorTransform; 
		private var bitData:BitmapData; 
		
		private var radius:Number;
		private var color:uint; 
		private var xpos:uint; 
		private var ypos:uint; 
		private var img:Image;
		private var step:Number = 0.2; 
		private var r:Number; 
		private var v:Number = 0; 
		private var theta:Number; 
		private var curl:Number; 
		private var len:Number;  
		private var distance:Number = 5.0; 
		private var texture_:Texture; 
		private var sprites:StarSpriteCostume; 
		private var rect:Rectangle; 
		public var container:starling.display.Sprite; 
		private var img_:Image; 
		private var rStart:Number; 
		private var lifeSpan:Number; 
		private var lifeTimer:Timer; 
		private var fadeTimer:Timer; 

		private var happyColors:Vector.<uint>; 
		private var engagedColors:Vector.<uint>; 
		private var neutralColors:Vector.<uint>; 
		private var angryColors:Vector.<uint>; 
		private var sadColors:Vector.<uint>; 
		private var num:Number; 
		private var timer:Timer; 
		private var scale:Number=0; 
		private var color2:uint; 
		private var pickedColors:Vector.<uint>; 
		private var spin:Number
		public var mood_:String; 
		private var engagedColor2:uint = 0x00a3ef;
		private var happyColor2:uint = 0xffc600;
		private var fullLen:uint;  
		//		private var sprites:
		
		public function Tendril(xpos_:Number, ypos_:Number, r_:Number, curl_:Number, len_:Number, dist:Number,mood:String)
		{
			xpos = xpos_; 
			ypos = ypos_; 
			r = r_; 
			curl = curl_; 
			len= len_; 
			
			distance = dist; 
			theta = rangeForTwo(6.28, -3.14); 
			addEventListener(Event.ADDED_TO_STAGE, start); 
			rStart = r;
//			engagedColors =new <uint> [0x00a3ef,0xd0ff3f, 0x4dce2a, 0x55cbb5,];
//			 happyColors= new <uint> [0xf9f73b, 0xf1640e, 0xe6007e]; 
//			neutralColors = new <uint> [ 0xFFFFFF, 0xb4b4b4]; 
//			angryColors = new <uint> [0xae0a06, 0x00000]; 
//			sadColors = new <uint> [0x2a2a2a, 0x252525]; 
			engagedColors =new <uint> [0xFFFFFF];
			happyColors= new <uint> [0xFFFFFF]; 
			neutralColors = new <uint> [0xFFFFFF];; 
			angryColors = new <uint> [0xFFFFFF]; 
			sadColors = new <uint> [0xFFFFFF];
			fullLen = len_;
			mood_ = mood
			if(mood == "sad") {
				pickedColors = sadColors; 
				sadSettings(); 
			}
			if(mood == "angry"){
				pickedColors = angryColors; 
				angrySettings(); 
			}
			if(mood =="neutral"){ 
				pickedColors = neutralColors; 
				neutralSettings(); 
			}
			if(mood =="engaged"){ 
				pickedColors = engagedColors; 
				engagedSettings(); 
			}
			if(mood =="happy") {
				pickedColors = happyColors; 
				happySettings(); 
			}
			lifeTimer = new Timer(1000,lifeSpan);
			lifeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, kill); 
//			timer= new Timer(500,num);  
//			timer.addEventListener(TimerEvent.TIMER, removeTendril);
			
			
		}
		private function start(e:Event):void { 
			lifeTimer.start();
			addEventListener(Event.ENTER_FRAME, curveDraw); 
			removeEventListener(Event.ADDED_TO_STAGE, start); 
		//	lifeTimer.start(); 
			if(r<=40) { 
			
				sprites = new StarSpriteCostume("40cir", 1); 
				rect = new Rectangle(209,247, 42,42); 
				texture_ = Texture.fromTexture(sprites.myTexture,rect); 
				
			}
			
			if(r<= 80 && r>40) { 
				
				sprites = new StarSpriteCostume("80cir", 1); 
				rect = new Rectangle(147,164, 82,82); 
				texture_ = Texture.fromTexture(sprites.myTexture,rect); 
			}
			
			if(r<= 10) { 
				
				sprites = new StarSpriteCostume("10cir", 1); 
				rect = new Rectangle(229,164,15,15); 
				texture_ = Texture.fromTexture(sprites.myTexture,rect); 
			}
			container = new Sprite(); 
			addChild(container); 
			setColors(pickedColors); 
		}
		
		private function setColors(colorSet:Vector.<uint>):void
		{
			num = Math.ceil(Math.random()*colorSet.length); 
			color = colorSet[num-1];
			color2 = Math.ceil(Math.random()*colorSet.length); 	
		}
		
		private function curveSet():void
		{
			xpos+= Math.cos(theta) *distance; 
			ypos += Math.sin(theta)*distance; 
			v= v+ range(step);
			//note this value before curl is giving all the vary curl is how much
			v*= curl+ curl*0.1; //place to play? 
			
		
			theta =theta+ v; 
			//trace(theta, "i'm the curve"); 
			r -=0.5; 
		
		}
		public function curveDraw(e:Event):void{ 
			if (len > 0) {	
					curveSet(); 
					drawDot(r);
					len --; 
			}
			if(len==0){
				removeEventListener(Event.ENTER_FRAME, curveDraw); 
				container.flatten();
			}
			if(r <=0) { 
				len = 0;  
				removeEventListener(Event.ENTER_FRAME, curveDraw); 
				container.flatten();
			}
			
		}
		
		 private function drawDot(r_:Number):void {


 				img_ = new Image(texture_); 
				if(rStart<=10){
					img_.scaleX =1;
					img_.scaleY =1;
				
					//trace(img_.scaleX); 
					} 
				if(rStart<=40 && rStart > 20) {
					img_.scaleX = r_/rStart; 
					img_.scaleY = r_/rStart; 
					trace(img_.scaleX); 
				}
				if(rStart>10 && rStart < 20) { 
					img_.scaleX = r_/rStart *0.8; 
					img_.scaleY = r_/rStart *0.8; 
				}
				if(rStart>40) { 
					img_.scaleX = r_/rStart *0.6; 
					img_.scaleY = r_/rStart *0.6; 
				}
				img_.x = xpos; 
				img_.y = ypos; 
				
				 
			//	color = fadeHex(0xFFFFFF,engagedColor2, fullLen); 
		//		img_.color = color;
				img_.smoothing = TextureSmoothing.TRILINEAR;
				
				container.addChild(img_); 
				img_.alpha = 1;
				
		 }
		 private function fadeHex(hex:uint, hex2:uint, ratio:uint):uint{
			 var r:Number = hex >> 16;
			 var g:Number = hex >> 8 & 0xFF;
			 var b:Number = hex & 0xFF;
			 r += ((hex2 >> 16)-r)*ratio;
			 g += ((hex2 >> 8 & 0xFF)-g)*ratio;
			 b += ((hex2 & 0xFF)-b)*ratio;
			 return(r<<16 | g<<8 | b);
		 }
		 
		 private function map(v:Number, a:Number, b:Number, x:Number = 0, y:Number = 1):Number {
			 return (v == a) ? x : (v - a) * (y - x) / (b - a) + x;
			 
			 //v = value, a - low 1, b high 1, x low 2, y high 2
		 }
		 
		 private function range(high:Number):Number {
			 //this function is for use when you have a range of two numbers
			 //that are the same only one is neg 
			//give me 1 or -1 
			var multiplier:Number= Math.random();
				if(multiplier > 0.5) {
					multiplier = 1;
				}else{
					multiplier = -1;
				}
				
			//give me a number from 0 - high 
			var someNum:Number = Math.random()*high;
			//multiply by 1 or -1 fixing our no neg prob
			var holder:Number = someNum *multiplier; 
			//trace(holder, "I'm the range to check"); 
			return someNum*multiplier; 	 
		
		 }
		 
		 private function rangeForTwo(high:Number, low:Number):Number{ 
		 //this one gets a random number between a neg and pos range
			 var check:Number= Math.floor(Math.random() * (1+high-low)) + low;
		//	trace(check); 
			 return check;
			 
		 } 
//		 public function tendrilHealth(e:TimerEvent):void { 
//			 removeEventListener(TimerEvent.TIMER_COMPLETE, tendrilHealth); 
//			 timer.start(); 
//			  num = container.numChildren;
//		 }
//		 public function removeTendril(e:TimerEvent) :void{
//			 num = container.numChildren;
//			 var image:Image = container.getChildAt(num-1) as Image;
//			 TweenLite.to(image, 1, {alpha:0});
//			//set timer to speed - tween alpha to 0 and then decrement
//		 }

		
		 private function happySettings():void{ 
			lifeSpan = Math.random()*300; 
			spin = 0.8;
			curl = 0.8;
			
		 }
		 private function engagedSettings():void{ 
			lifeSpan =  Math.random()*200; 
		 }
		 private function neutralSettings():void{ 
			 lifeSpan = Math.random()*80;
		 }
		 private function angrySettings():void{ 
			 lifeSpan = Math.random()*130; 
		 }
		 private function sadSettings():void{ 
			 lifeSpan = Math.random()*160;
			 spin = Math.random()*1; 
			 curl = Math.random() * 0.6; 
		 }
		 
		 private function kill(e:TimerEvent):void { 
			 destroy(); 
		 }
		 public function destroy():void {
			 
			 this.removeEventListeners(); 
			 this.removeChildren(); 
			 texture_.dispose(); 
			 this.dispose(); 
			 
		 }
		 
	}
}