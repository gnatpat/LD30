package net.natpat 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Nathan Patel
	 */
	public class GC 
	{
		
		public static var SCREEN_WIDTH:int;
		
		public static var SCREEN_HEIGHT:int;
	
		public static const ZERO:Point = new Point(0, 0);
		
		public static const MAX_CONNECTION_LENGTH:int = 400 * 0.43554;
		
		public static const CAMERA_SCROLL:Number = 300;
		
		public static const SPRITE_ZOOM_RATIO:Number = 0.3;
		
		public static const MAX_ZOOM:Number = 5.5;
		
		public static const DIST_TO_COST_RATIO:int = 50;
		
		public static const SCROLL_BORDER:int = 60;
		
		public static const PIRATE_CHANCE:Number = 1 / 600000;
		
		public static const MAX_RED_SHIPS:int = 3;
		
		public static const FULL_LEVEL_INCREASE:Number = 52 * GC.SECONDS_IN_WEEK * 3;
		
		public static const SECONDS_IN_WEEK:int = 1;
		
		public static const GOLD_LOSS_AT_RICHEST_PORT_PER_SECOND:Number = 4;
	}

}