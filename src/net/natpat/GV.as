package net.natpat 
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import net.natpat.gui.Button;
	import net.natpat.gui.GoldPlus;
	import net.natpat.gui.GuiManager;
	import net.natpat.gui.IGuiElement;
	import net.natpat.utils.WaypointConnection;
	
	/**
	 * ...
	 * @author Nathan Patel
	 */
	public class GV 
	{
		
		public static var onGUI:IGuiElement = null;
		
		public static var makingRoute:Boolean = false;
		
		public static var currentRoute:Vector.<WaypointConnection> = new Vector.<WaypointConnection>();
		
		public static var routeDistance:int = 0;
		
		public static var routePort:Port = null
		
		public static var routeForReplace:Boolean = false;
		
		public static var routeIndex:int = 0;
		
		public static var redShip:RedShip = null;
		
		public static var zoom:Number = 5;
		
		public static var goldShip:Boolean = false;
		
		public static function get redShipAdded():Boolean
		{
			return (GV.redShip != null && GV.redShip.sm != null);
		}
		
		public static function zoomIn():void
		{
			GV.zoom -= 5 * GV.elapsed;
			GV.zoom = Math.max(1, GV.zoom);
		}
		
		public static function zoomOut():void
		{
			GV.zoom += 5 * GV.elapsed;
			GV.zoom = Math.min(5, GV.zoom);
		}
		
		public static var gold:int = 100;
		
		public static var shipCost:int = 50;
		public static var redShipCost:int = 70;
		public static var goldShipCost:int = 30;
		
		public static var w:Waypoint;
		
		public static const debuggingConnections:Boolean = false;
		
		public static function get routeCost():int
		{
			return GV.redShipAdded  ? 0 : int(routeDistance / GC.DIST_TO_COST_RATIO) + (routeForReplace ? 0 : (GV.redShip != null? redShipCost : (GV.goldShip ? goldShipCost : shipCost)));
		}
		
		public static function get mouseX():int
		{
			return GV.camera.x + ( -GC.SCREEN_WIDTH / 2 + Input.mouseX) * GV.zoom;
		}
		
		public static function get mouseY():int
		{
			return GV.camera.y + ( -GC.SCREEN_HEIGHT / 2 + Input.mouseY) * GV.zoom;
		}
		
		public static function get canClick():Boolean
		{
			return (onGUI == null);
		}
		
		public static function spendGold(gold:int, x:int, y:int):void
		{
			GV.gold -= gold;
		}
		
		public static function makeGold(gold:int, x:int, y:int):void
		{
			GV.gold += gold;
			GuiManager.add(new GoldPlus(x, y, gold));
		}
		
		public static function getScreenX(x:int):int
		{
			return (x - GV.camera.x + (GC.SCREEN_WIDTH / 2 * GV.zoom)) * 1/GV.zoom;
		}
		
		public static function getScreenY(y:int):int
		{
			return (y - GV.camera.y + (GC.SCREEN_HEIGHT / 2 * GV.zoom)) * 1/GV.zoom;
		}
		
		/**
		 * Reference to the stage
		 */
		public static var stage:Stage;
		
		/**
		 * The bitmapData for the screen.
		 */
		public static var screen:BitmapData;
		
		/**
		 * Milliseconds elapsed since last frame
		 */
		public static var _elapsed:Number = 0;
		
		/**
		 * Factor to multiply elapsed by to give the illusion of speeding up
		 */
		public static var timeFactor:Number = 1;
		
		/**
		 * The camera point. Use it as you will
		 */
		public static var camera:Point = new Point();
		
		/**
		 * The number of seconds elapsed adjusted by timeFactor
		 */
		public static function get elapsed():Number
		{
			return _elapsed * timeFactor;
		}
		
		/**
		 * The actual time elapsed in seconds
		 */
		public static function get actualElapsed():Number
		{
			return _elapsed;
		}
		
		/**
		 * The frame rate currently running at
		 */
		public static function get frameRate():Number
		{
			return 1 / _elapsed;
		}
		
		/**
		 * Using math random, gives a random number between 0 and limit.
		 * @param	limit	The limit for the number.
		 * @return	Random number between 0 and limit
		 */
		public static function rand(limit:int):int
		{
			return Math.random() * limit;
		}
		
		/**
		 * Finds the angle (in degrees) from point 1 to point 2.
		 * @param	x1		The first x-position.
		 * @param	y1		The first y-position.
		 * @param	x2		The second x-position.
		 * @param	y2		The second y-position.
		 * @return	The angle from (x1, y1) to (x2, y2).
		 */
		public static function angle(x1:Number, y1:Number, x2:Number, y2:Number):Number
		{
			var a:Number = Math.atan2(y2 - y1, x2 - x1) * DEG;
			return a < 0 ? a + 360 : a;
		}
		
		// Used for rad-to-deg and deg-to-rad conversion.
		/** @private */ public static const DEG:Number = -180 / Math.PI;
		/** @private */ public static const RAD:Number = Math.PI / -180;
		
		public static function pointInRect(x:int, y:int, xRect:int, yRect:int, width:int, height:int):Boolean
		{
			return (x > xRect &&
					x < xRect + width &&
					y > yRect &&
					y < yRect + height);
		}
		
		public static function intersects(x1:int, y1:int, width1:int, height1:int,
										  x2:int, y2:int, width2:int, height2:int):Boolean
		{
			if (x1 > x2 + width2) return false;
			if (x2 > x1 + width1) return false;
			if (y1 > y2 + height2) return false;
			if (y2 > y1 + height1) return false;
			return true;
		}
		
		private static var duration:Number;
		private static var intensity:Number;
		private static var offset:Point;
		
		public static function shake(duration:Number, intensity:Number):void
		{
			GV.duration = duration;
			GV.intensity = intensity;
			offset = new Point(0, 0);
			stage.addEventListener(Event.ENTER_FRAME, shakeUpdate);
		}
		
		private static function shakeUpdate(e:Event):void
		{
			camera.x -= offset.x;
			camera.y -= offset.y;
			
			duration -= elapsed;
			if (duration < 0)
			{
				stage.removeEventListener(Event.ENTER_FRAME, shakeUpdate);
				return;
			}
			offset.x = Math.random() * intensity - (intensity / 2);
			offset.y = Math.random() * intensity - (intensity / 2);
			camera.x += offset.x;
			camera.y += offset.y;
		}
		
		public static function loadBitmapDataFromSource(source:*):BitmapData
		{
			if (source is Class) return Bitmap(new source).bitmapData;
			if (source is BitmapData) return source;
			return null;
		}
		
		public static function dist(x1:int, y1:int, x2:int, y2:int):Number
		{
			return Math.sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2));
		}
		
		public static var seed:int = 777;

		public static const MAX_RATIO:Number = 1 / int.MAX_VALUE;
		public static const  MIN_MAX_RATIO:Number = -MAX_RATIO;

		public static function random():Number
		{
		   seed ^= (seed << 21);
		   seed ^= (seed >>> 35);
		   seed ^= (seed << 4);
		   if (seed < 0) return seed * MAX_RATIO;
		   return seed * MIN_MAX_RATIO;
		}
	}

}