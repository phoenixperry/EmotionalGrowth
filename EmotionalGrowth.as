package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	

	
	import starling.core.Starling; 
	[SWF(width="1280", height="800", frameRate="30", backgroundColor="#000000")]
	public class EmotionalGrowth extends Sprite
	{
		public function EmotionalGrowth()
		{
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			var st:Starling = new Starling(Main,stage); 
			st.start(); 
			
		}
	}
}