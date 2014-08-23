package net.natpat {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
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
		
		public var oldLength:int = 0;
		
		public function GameManager(stageWidth:int, stageHeight:int) 
		{
			
			GC.SCREEN_WIDTH = stageWidth;
			GC.SCREEN_HEIGHT = stageHeight;
			
			renderer = new BitmapData(stageWidth, stageHeight, false, 0x000000);
			
			bitmap = new Bitmap(renderer);
			
			mapBD = new BitmapData(10 * 400, 6 * 400, true, 0);
			
			GV.screen = renderer;
			
			wm = new WaypointManager(renderer);
			
			for(var i:int = 0; i < 50; i++)
			{
				wm.add(new Waypoint(GV.rand(GC.SCREEN_WIDTH), GV.rand(GC.SCREEN_HEIGHT)));
			}
			
			var w:Waypoint = new Waypoint(GV.rand(GC.SCREEN_WIDTH), GV.rand(GC.SCREEN_HEIGHT));
			wm.add(w);
			Waypoint.selected = w;
			
			wm.connectWaypoints();
			
			GV.makingPath = true;
			
			pathGraphic = new Shape();
			pathGraphic.graphics.moveTo(w.x + 4, w.y + 4);
			pathGraphic.graphics.lineStyle(1, 0, 1);
			
		}
		
		public function render():void
		{
			renderer.lock();
			
			//Render the background
			renderer.fillRect(new Rectangle(0, 0, renderer.width, renderer.height), 0xffffff);
			
			wm.render();
			
			renderer.draw(pathGraphic);
			
			GuiManager.render();
			
			renderer.unlock();
		}
		
		public function update():void
		{
			
			GuiManager.update();
			
			wm.update();
			
			if (oldLength != GV.currentPath.length)
			{
				pathGraphic.graphics.lineTo(GV.currentPath[oldLength].to.x + 4, GV.currentPath[oldLength].to.y + 4);
				oldLength = GV.currentPath.length;
			}
			
			Input.update();
		}
		
	}

}