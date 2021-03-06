package
{

	import com.phoenixperry.emote.NoiseExample;
	import com.phoenixperry.emote.Plant;
	import com.phoenixperry.emote.Ribbon;
	import com.phoenixperry.emote.StarSpriteCostume;
	import com.phoenixperry.emote.Tendril;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	import nl.ronvalstar.math.OptimizedPerlin;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;

	
	public class Main extends Sprite
	{
		private var sprites:StarSpriteCostume; 
		private var sadBtn:Button; 
		private var angryBtn:Button; 
		private var neutralBtn:Button; 
		private var engagedBtn:Button; 
		private var happyBtn:Button; 
		private var menuContainer:Sprite; 
		private var tend:Tendril;
		private var ribbon:Ribbon; 
		private var n:NoiseExample; 
		private var xpos:Number; 
		private var ypos:Number; 
		private var container:Sprite; 
		public function Main() 
		{
			//curl is something to set. 
			addEventListener(starling.events.Event.ADDED_TO_STAGE, onAdded); 
			
		}
		
		private function onAdded(e:starling.events.Event):void
		{
			removeEventListener(starling.events.Event.ADDED_TO_STAGE, onAdded); 

			//ribbon = new Ribbon(stage.stageWidth/2, 60, 20, 0.02, 0xFF00FF, 100); 
			//addChild(ribbon); 
	
//			tend = new Tendril(300,500,10,0.8, 60,5);
//			addChild(tend); 
//			
//			var tend2:Tendril = new Tendril(400,600,70,1.5, 4,70);
//			addChild(tend2); 
//			
			makeBtns(); 
			xpos = stage.stageWidth/2; 
			ypos = stage.stageHeight/2; 
			container = new Sprite();
			addChild(container); 

			NativeApplication.nativeApplication.addEventListener(flash.events.Event.DEACTIVATE, handleDeactivate, false, 0, true);
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, handleKeys, false, 0, true);
			
		}

		

	
		
		function handleKeys(event:KeyboardEvent):void
			
		{
			
			if(event.keyCode == Keyboard.BACK)
				
			{
				
				NativeApplication.nativeApplication.exit();
				
			}
		
		}
		private function handleDeactivate(e:flash.events.Event):void
		{

			NativeApplication.nativeApplication.exit();	
		}
		
		public function makeBtns():void {
			menuContainer = new Sprite(); 
			sprites = new StarSpriteCostume("sad",1); 
			var rect:Rectangle = new Rectangle(2,370,143,90);
			var texture_:Texture= Texture.fromTexture(sprites.myTexture,rect); 
			
			sadBtn = new Button(texture_); 
			sadBtn.x = 20; 
			sadBtn.y = stage.stageHeight - sadBtn.height-20;
			sadBtn.name = "sadBtn"; 
			menuContainer.addChild(sadBtn);
			sprites = new StarSpriteCostume("angry",1); 
			rect = new Rectangle(2,278,143,90); 
			texture_ = Texture.fromTexture(sprites.myTexture, rect); 
			angryBtn = new Button(texture_); 
			angryBtn.x = sadBtn.width + sadBtn.x + 10; 
			angryBtn.y = stage.stageHeight -angryBtn.height-20; 
			angryBtn.name = "angryBtn"; 
			menuContainer.addChild(angryBtn); 
			sprites = new StarSpriteCostume("netural",1); 
			rect = new Rectangle(2, 186, 143,90); 
			texture_ = Texture.fromTexture(sprites.myTexture, rect); 
			neutralBtn= new Button(texture_); 
			neutralBtn.x = angryBtn.x + angryBtn.width + 10; 
			neutralBtn.y = stage.stageHeight - neutralBtn.height -20;
			neutralBtn.name = "neutralBtn"; 
			menuContainer.addChild(neutralBtn); 
			sprites = new StarSpriteCostume("engaged",1); 
			rect = new Rectangle(2,94, 143,90); 
			texture_ = Texture.fromTexture(sprites.myTexture, rect); 
			engagedBtn = new Button(texture_); 
			engagedBtn.x = neutralBtn.x + neutralBtn.width + 10; 
			engagedBtn.y = stage.stageHeight -engagedBtn.height - 20; 
			engagedBtn.name = "engagedBtn"; 
			menuContainer.addChild(engagedBtn); 
			sprites = new StarSpriteCostume("happy",1); 
			rect = new Rectangle(2,2, 143,90); 
			texture_ = Texture.fromTexture(sprites.myTexture, rect); 
			happyBtn = new Button(texture_); 
			happyBtn.x = engagedBtn.x + engagedBtn.width + 10; 
			happyBtn.y = stage.stageHeight - happyBtn.height -20; 
			happyBtn.name = "happyBtn"; 
			menuContainer.addChild(happyBtn);  
			
			menuContainer.addEventListener(starling.events.Event.TRIGGERED, onTriggered); 		
			addChild(menuContainer); 
		}
		
		private function onTriggered(e:starling.events.Event):void
		{
			//trace(e.currentTarget, e.target); 
			
			if(e.target is DisplayObject){ 
				var btn:Button = e.target as Button;
			}
			if(btn.name == "sadBtn") { 
				
				trace("sad"); 
				var mood:String = "sad"; 
			
				var r:Number = Math.random() * 20; 
				var len:Number = Math.random() *120; 
				var tendril:Tendril = new Tendril(xpos,ypos,r,0.8,len, 5, mood); 
				container.addChild(tendril); 
				
				var count:Number= container.numChildren; 
				trace(count);
				if(count > 1){ 
					count = int(Math.ceil(Math.random() *count-1)); 
				var tenddy:Tendril = container.getChildAt(count) as Tendril; 
				tenddy.destroy();
				tenddy = null; 
				}
				
		
			 
			}
			if(btn.name == "angryBtn") {
				trace("angry"); 
				var mood:String = "angry"; 
			
				var r:Number = Math.random() * 10; 
				var len:Number = Math.random() *100; 
				var tendril:Tendril = new Tendril(xpos,ypos,r,0.8,len, 5, mood); 
				container.addChild(tendril); 
			}
			
			if(btn.name == "neutralBtn"){
 
				var mood:String = "neutral"; 
				
				var r:Number = Math.random() * 20; 
				var len:Number = Math.random() *40; 
				var tendril:Tendril = new Tendril(xpos,ypos,r,0.8,len, 5, mood); 
				container.addChild(tendril); 
			}
			if(btn.name == "engagedBtn"){
				trace("engaged"); 
				var mood:String = "engaged"; 
			
				var r:Number = Math.random() * 40; 
				var len:Number = Math.random() *80; 
				var tendril:Tendril = new Tendril(xpos,ypos,r,0.8,len, 6, mood); 
				container.addChild(tendril); 
			}
			if(btn.name == "happyBtn") { 
				trace("happyBtn"); 
				var mood:String = "happy"; 
		
				ypos = stage.stageHeight/2; 
				var r:Number = Math.random() * 40; 
				var len:Number = Math.random() *200; 
				var tendril:Tendril = new Tendril(xpos,ypos,r,0.8,len,8, mood); 
				container.addChild(tendril); 
			}
		}
		
	}
}