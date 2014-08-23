
package net.natpat
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import flash.utils.getTimer;
	
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.display.StageDisplayState;
	
	/**
	 * ...
	 * @author Nathan Patel
	 */
	public class Main extends Sprite 
	{
		private var game:GameManager;
		
		/**
		 * Time at the beginning of the previous frame
		 */
		private var prevTime:int;
		
		private var currentTime:int;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			//Set GV.stage to the stage, for easier access
			GV.stage = stage;
			
			game = new GameManager(stage.stageWidth, stage.stageHeight);
			
			//Add the game bitmap to the screen
			addChild(game.bitmap);
			
			//Create the main game loop
			addEventListener(Event.ENTER_FRAME, run);
			Input.setupListeners();
			stage.align = StageAlign.TOP_LEFT;
			stage.quality = StageQuality.HIGH;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.displayState = StageDisplayState.NORMAL;
		}
		
		private function run(e:Event):void
		{
			//Works out GV.elapsed, or how many milliseconds have passed since the last frame
			currentTime = getTimer();
			GV._elapsed = (currentTime - prevTime) / 1000;
			prevTime = currentTime;
			
			game.update();
			game.render();
			
		}
		
	}
	
}