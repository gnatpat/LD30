package net.natpat {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
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
		
		public var map:Map;
		public var mapBD:BitmapData;
		public var scaleBD:BitmapData;
		public var objBD:BitmapData;
		
		public var wm:WaypointManager;
		
		public var pathGraphic:Shape;
		public var mouseLine:Shape;
		
		public var oldLength:int = 0;
		
		public var curvePoint:Point;
		
		public var sm:ShipManager;
		
		public var gold:Text;
		
		public function GameManager(stageWidth:int, stageHeight:int) 
		{
			
			GC.SCREEN_WIDTH = stageWidth;
			GC.SCREEN_HEIGHT = stageHeight;
			
			renderer = new BitmapData(stageWidth, stageHeight, false, 0x000000);
			
			bitmap = new Bitmap(renderer);
			
			map = new Map();
			
			mapBD = new BitmapData(GC.SCREEN_WIDTH * GC.MAX_ZOOM, GC.SCREEN_HEIGHT * GC.MAX_ZOOM, true, 0);
			scaleBD = new BitmapData(GC.SCREEN_WIDTH * GC.MAX_ZOOM, GC.SCREEN_HEIGHT * GC.MAX_ZOOM, true, 0);
			objBD = new BitmapData(GC.SCREEN_WIDTH, GC.SCREEN_HEIGHT, true, 0);
			
			GV.screen = renderer;
			
			wm = new WaypointManager(objBD);
			
			wm.add(new Port(7965, 1650, "Bristol"));
			wm.add(new Waypoint(7490, 2090));
			wm.add(new Waypoint(7700, 1872));
			wm.waypoints[1].hasPirate = true;
			wm.add(new Port(7724, 1594, "Dublin"));
			wm.add(new Port(8069, 1934, "Calais"));
			wm.add(new Port(7784, 2234, "Bayonne"));
			wm.add(new Port(8405, 1749, "Rotterdam"));
			wm.add(new Port(7603, 2300, "Santander"));
			wm.add(new Port(7733, 2697, "Seville")); 
			
			
			wm.connectWaypoints();
			
			sm = new ShipManager(scaleBD, objBD);
			
			pathGraphic = new Shape();
			pathGraphic.graphics.lineStyle(1, 0, 1);
			
			mouseLine = new Shape();
			mouseLine.graphics.lineStyle(1, 0, 1);
			
			GV.camera.x = 8000;
			GV.camera.y = 1750;
			
			GV.zoom = 2.3;
			
			gold = new Text(10, 10, "Gold: 0", 2);
			GuiManager.add(gold);
		}
		
		public function render():void
		{
			renderer.lock();
			
			//Render the background
			renderer.fillRect(new Rectangle(0, 0, renderer.width, renderer.height), 0x68c8ff);
			scaleBD.fillRect(scaleBD.rect, 0);
			objBD.fillRect(objBD.rect, 0);
			
			map.render(mapBD);
			
			m = new Matrix();
			m.translate( -GV.camera.x + (GC.SCREEN_WIDTH * GV.zoom / 2), - GV.camera.y + (GC.SCREEN_HEIGHT * GV.zoom / 2));
			scaleBD.draw(pathGraphic, m);
			scaleBD.draw(mouseLine, m);
			
			wm.render();
			
			sm.render();
			
			var m:Matrix = new Matrix();
			m.scale(1 / GV.zoom, 1 / GV.zoom);
			renderer.draw(mapBD, m);
			renderer.draw(scaleBD, m);
			renderer.draw(objBD);
			
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
					for each(var wc:WaypointConnection in GV.currentRoute)
					{
						drawLine(wc);
					}
					oldLength = GV.currentRoute.length;
				}
				
				mouseLine.graphics.clear();
				if (Input.mouseDown)
				{
					mouseLine.graphics.lineStyle(15, 0x3333ff, 0.6);
					mouseLine.graphics.moveTo(Waypoint.selected.x, Waypoint.selected.y);
					mouseLine.graphics.lineTo(GV.mouseX, GV.mouseY);
				}
			}
			else
			{
				if (GV.currentRoute.length != 0)
				{
					drawLine(GV.currentRoute[oldLength]);
					
					addShip();
					
					pathGraphic = new Shape();
					GV.currentRoute = new Vector.<WaypointConnection>();
				}
				mouseLine.graphics.clear();
			}
			
			sm.update();
			
			if (Input.keyDown(Key.LEFT))
			{
				GV.camera.x -= GC.CAMERA_SCROLL * GV.zoom * GV.elapsed;
			}
			
			if (Input.keyDown(Key.RIGHT))
			{
				GV.camera.x += GC.CAMERA_SCROLL * GV.zoom * GV.elapsed;
			}
			
			if (Input.keyDown(Key.UP))
			{
				GV.camera.y -= GC.CAMERA_SCROLL * GV.zoom * GV.elapsed;
			}
			
			if (Input.keyDown(Key.DOWN))
			{
				GV.camera.y += GC.CAMERA_SCROLL * GV.zoom * GV.elapsed;
			}
			
			if (Input.keyDown(Key.Q))
			{
				GV.zoom -= 1 * GV.elapsed;
				GV.zoom = Math.max(1, GV.zoom);
			}
			
			if (Input.keyDown(Key.A))
			{
				GV.zoom += 1 * GV.elapsed;
				GV.zoom = Math.min(GC.MAX_ZOOM, GV.zoom);
			}
			
			gold.text = "Gold: " + GV.gold;
			
			Input.update();
		}
		
		public function addShip():void
		{
			var s:Ship = new Ship(new Route(GV.currentRoute, pathGraphic));
			sm.addShip(s, GV.routePort, GV.routeIndex);
		}
		
		public function drawLine(wc:WaypointConnection):void
		{
			pathGraphic.graphics.lineStyle(15, 0x3333ff, 0.6);
			pathGraphic.graphics.moveTo(wc.from.x, wc.from.y);
			pathGraphic.graphics.lineTo(wc.to.x, wc.to.y);
		}
	}

}