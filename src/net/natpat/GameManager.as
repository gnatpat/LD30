package net.natpat {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.natpat.gui.Button;
	import net.natpat.gui.InputBox;
	import net.natpat.particles.Emitter;
	import net.natpat.utils.Sfx;
	
	import net.natpat.gui.Text;
	import net.natpat.gui.GuiManager
	import net.natpat.utils.Ease;
	import net.natpat.utils.Key;
	
	import net.natpat.utils.WaypointConnection;
	
	/**
	 * ...
	 * @author Nathan Patel
	 */
	public class GameManager 
	{
		
		/**
		 * Bitmap and bitmap data to be drawn to the screen.
		 */
		public var bitmap:Bitmap;
		public static var renderer:BitmapData;
		
		public var mapBD:BitmapData;
		
		public var wm:WaypointManager;
		
		public var pathGraphic:Shape;
		public var mouseLine:Shape;
		
		public var oldLength:int = 0;
		
		public var curvePoint:Point;
		
		public var ship:Ship;
		
		public function GameManager(stageWidth:int, stageHeight:int) 
		{
			
			GC.SCREEN_WIDTH = stageWidth;
			GC.SCREEN_HEIGHT = stageHeight;
			
			renderer = new BitmapData(stageWidth, stageHeight, false, 0x000000);
			
			bitmap = new Bitmap(renderer);
			
			mapBD = new BitmapData(10 * 400, 6 * 400, true, 0);
			
			GV.screen = renderer;
			
			wm = new WaypointManager(renderer);
			
			for(var i:int = 0; i < 70; i++)
			{
				wm.add(new Waypoint(GV.rand(GC.SCREEN_WIDTH), GV.rand(GC.SCREEN_HEIGHT)));
			}
			
			for(var i:int = 0; i < 10; i++)
			{
				wm.add(new Port(GV.rand(GC.SCREEN_WIDTH), GV.rand(GC.SCREEN_HEIGHT), "Port"));
			}
			
			wm.connectWaypoints();
			
			pathGraphic = new Shape();
			pathGraphic.graphics.lineStyle(1, 0, 1);
			
			mouseLine = new Shape();
			mouseLine.graphics.lineStyle(1, 0, 1);
			
		}
		
		public function render():void
		{
			renderer.lock();
			
			//Render the background
			renderer.fillRect(new Rectangle(0, 0, renderer.width, renderer.height), 0x68c8ff);
			
			wm.render();
			
			renderer.draw(pathGraphic);
			renderer.draw(mouseLine);
			
			if (ship != null)
			{
				ship.render(GV.screen);
			}
			
			GuiManager.render();
			
			renderer.unlock();
		}
		
		public function update():void
		{
			
			GuiManager.update();
			
			wm.update();
			
			if (GV.makingRoute)
			{
				if (oldLength < GV.currentRoute.length)
				{
					drawLine(GV.currentRoute[oldLength]);
					oldLength = GV.currentRoute.length;
				}
				else if (oldLength > GV.currentRoute.length)
				{
					pathGraphic.graphics.clear();
					pathGraphic.graphics.lineStyle(1, 0, 1);
					for each(var wc:WaypointConnection in GV.currentRoute)
					{
						drawLine(wc);
					}
					oldLength = GV.currentRoute.length;
				}
				
				mouseLine.graphics.clear();
				if (Input.mouseDown)
				{
					mouseLine.graphics.lineStyle(1, 0, 1);
					mouseLine.graphics.moveTo(Waypoint.selected.x, Waypoint.selected.y);
					mouseLine.graphics.lineTo(Input.mouseX, Input.mouseY);
				}
			}
			else
			{
				if (GV.currentRoute.length != 0)
				{
					ship = new Ship(new Route(GV.currentRoute, pathGraphic));
					pathGraphic = new Shape();
					GV.currentRoute = new Vector.<WaypointConnection>();
				}
			}
			
			if (ship != null)
			{
				ship.update();
			}
			
			Input.update();
		}
		
		public function drawLine(wc:WaypointConnection):void
		{
			pathGraphic.graphics.moveTo(wc.from.x, wc.from.y);
			pathGraphic.graphics.lineTo(wc.to.x, wc.to.y);
		}
	}

}