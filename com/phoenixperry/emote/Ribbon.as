package com.phoenixperry.emote
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class Ribbon extends starling.display.Sprite
	{	
		private var xpos:Number; 
		private var ypos:Number; 
		private var theta:Number; 
		private var r:Number; 
		private var angle2:Number; 
		private var v:Number = 0.03; 
		private var texture:Texture;  
		public var array:Array = []; 
		private var col:uint; 
		private var len:int; 
		private var curl:Number = 0.7; 
		private var step:Number =0.2;
		private var y_map:Number; 
		public function Ribbon(xpos_:Number, ymap_:Number, r_:Number, theta_:Number, col_:uint, len_:int)
		{
			xpos = xpos_; 
			y_map = ymap_; 
			r = r_; 
			theta = theta_; 
			col = col_; 
			len = len_; 
			addEventListener(Event.ADDED_TO_STAGE, curveSet); 
		}
		
		private function curveSet(e:Event):void { 
			removeEventListener(Event.ADDED_TO_STAGE, curveSet); 	
			addEventListener(Event.ENTER_FRAME,  drawCurve);
		
		}
		private function drawCurve(e:Event):void{ 
			drawX(); 
		}
	
		private function drawX():void
		{	var angle:Number; 
			angle= Math.sin(theta); 
	
			//trace(angle); 
			ypos = map(angle,-1,1,0,y_map);  
		//	trace(ypos); 
			xpos=xpos+6; 
			
			r-= 0.3; 
			len --; 
			theta -= 0.14;
			drawDot(r); 
			if(r < 3) { 
				removeEventListener(Event.ENTER_FRAME, drawCurve); 
				len = 0
					
			}
			if(len == 0) { 
				removeEventListener(Event.ENTER_FRAME, drawCurve); 
				
			
			}
			
		}		
		
	
		
		
		private function rangeForTwo(high:Number, low:Number):Number{ 
			//this one gets a random number between a neg and pos range
			var check:Number= Math.floor(Math.random() * (1+high-low)) + low;
			//	trace(check); 
			return check;
			
		} 
		
		private function map(v:Number, a:Number, b:Number, x:Number = 0, y:Number = 1):Number {
			return (v == a) ? x : (v - a) * (y - x) / (b - a) + x;
		}
		
		private function drawDot(r_:Number):void {
			
			//for alpha
			//var a:Number = Math.random();
			//color = Math.random() * 0xFFFFFF; 
			
			//	radius  = Math.random() * radius;
			
			var _shape:flash.display.Sprite = new flash.display.Sprite();  
			with(_shape.graphics) {
				lineStyle(1, 0x000000); 
				beginFill(col, 1); 
				drawCircle(r_, r_, r_); 
				endFill(); 
			}
			//account for stroke in buffer 
			var buffer:BitmapData = new BitmapData(_shape.width+10, _shape.height+10, true, col); 
			buffer.draw(_shape);
			texture = Texture.fromBitmapData(buffer); 
			var img:Image = new Image(texture); 
			img.x = xpos; 
			img.y = ypos; 
			addChild(img); 
			array.push(img); 
			
			
		}
		public function destroy():void { 
			
			this.removeEventListeners(); 
			this.removeChildren(); 
			texture.dispose(); 
			this.dispose(); 
		
		}
	}
}