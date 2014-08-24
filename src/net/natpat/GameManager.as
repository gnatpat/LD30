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
			
			wm.add(new Waypoint(7490, 2090));
			wm.add(new Waypoint(7700, 1872));
			wm.add(new Waypoint(7446, 2312));
			wm.add(new Waypoint(7369, 2469));
			wm.add(new Waypoint(7494, 2597));
			wm.add(new Waypoint(7498, 2742));
			wm.add(new Waypoint(7626, 2770));
			wm.add(new Waypoint(7367, 2845));
			wm.add(new Waypoint(7289, 3006));
			wm.add(new Waypoint(7909, 2788));
			wm.add(new Waypoint(8086, 2891));
			wm.add(new Waypoint(8150, 2749));
			wm.add(new Waypoint(8307, 2521));
			wm.add(new Waypoint(8440, 2440));
			wm.add(new Waypoint(8435, 2714));
			wm.add(new Waypoint(8208, 2882));
			wm.add(new Waypoint(8451, 2845));
			wm.add(new Waypoint(8477, 3088));
			wm.add(new Waypoint(8673, 2943));
			wm.add(new Waypoint(8751, 3097));
			wm.add(new Waypoint(8953, 3058));
			wm.add(new Waypoint(8960, 2867));
			wm.add(new Waypoint(9018, 2648));
			wm.add(new Waypoint(9137, 3032));
			wm.add(new Waypoint(9209, 3099));
			wm.add(new Waypoint(9282, 2993));
			wm.add(new Waypoint(9393, 3106));
			wm.add(new Waypoint(9464, 2759));
			wm.add(new Waypoint(8914, 2487));
			wm.add(new Waypoint(9409, 2931));
			wm.add(new Waypoint(7884, 1906));
			wm.add(new Waypoint(8130, 1821));
			wm.add(new Waypoint(8277, 1763));
			wm.add(new Waypoint(8332, 1586));
			wm.add(new Waypoint(7095, 3151));
			wm.add(new Waypoint(7014, 3315));
			wm.add(new Waypoint(7014, 3447));
			wm.add(new Waypoint(6913, 3606));
			wm.add(new Waypoint(6908, 3707));
			wm.add(new Waypoint(6920, 3851));
			wm.add(new Waypoint(6853, 4018));
			wm.add(new Waypoint(6913, 4184));
			wm.add(new Waypoint(6987, 4322));
			wm.add(new Waypoint(7066, 4484));
			wm.add(new Waypoint(7343, 4609));
			wm.add(new Waypoint(7614, 4604));
			wm.add(new Waypoint(7872, 4524));
			wm.add(new Waypoint(6809, 3442));
			wm.add(new Waypoint(6997, 3978));
			wm.add(new Waypoint(6777, 4310));
			wm.add(new Waypoint(6855, 4482));
			wm.add(new Waypoint(7133, 4723));
			wm.add(new Waypoint(7545, 4800));
			wm.add(new Waypoint(7846, 4784));
			wm.add(new Waypoint(8056, 4933));
			wm.add(new Waypoint(7894, 5127));
			wm.add(new Waypoint(7906, 5210));
			wm.add(new Waypoint(8053, 5471));
			wm.add(new Waypoint(7979, 5649));
			wm.add(new Waypoint(8181, 5642));
			wm.add(new Waypoint(8281, 5860));
			wm.add(new Waypoint(8111, 5967));
			wm.add(new Waypoint(8271, 6260));
			wm.add(new Waypoint(7192, 2573));
			wm.add(new Waypoint(8302, 6100));
			wm.add(new Waypoint(8438, 6401));
			wm.add(new Waypoint(7185, 2876));
			wm.add(new Waypoint(7725, 4967));
			wm.add(new Waypoint(8399, 1388));
			wm.add(new Waypoint(8552, 1513));
			wm.add(new Waypoint(8706, 1674));
			wm.add(new Waypoint(8875, 1674));
			wm.add(new Waypoint(8906, 1538));
			wm.add(new Waypoint(9031, 1580));
			wm.add(new Waypoint(9020, 1424));
			wm.add(new Waypoint(7800, 1453));
			wm.add(new Waypoint(7669, 1264));
			wm.add(new Waypoint(7722, 1103));
			wm.add(new Waypoint(7852, 940));
			wm.add(new Waypoint(7991, 992));
			wm.add(new Waypoint(8246, 964));
			wm.add(new Waypoint(8274, 1225));
			wm.add(new Waypoint(8407, 915));
			
			
			wm.add(new Port(7965, 1650, "Bristol"));
			wm.add(new Port(7724, 1594, "Dublin"));
			wm.add(new Port(8069, 1934, "Calais"));
			wm.add(new Port(7784, 2234, "Bayonne"));
			wm.add(new Port(8405, 1749, "Rotterdam"));
			wm.add(new Port(7603, 2300, "Santander"));
			wm.add(new Port(7733, 2697, "Gibraltar")); 
			wm.add(new Port(3762, 1525, "Quebec City"));
			wm.add(new Port(2673, 2301, "Carabelle"));
			wm.add(new Port(3214, 1985, "Richmond"));
			wm.add(new Port(2690, 2788, "Havana"));
			wm.add(new Port(2367, 3319, "Cartagena"));
			wm.add(new Port(2751, 3292, "Caracas"));
			wm.add(new Port(3862, 3677, "Fortaleza"));
			wm.add(new Port(4004, 4177, "Salvador"));
			wm.add(new Port(3559, 4921, "Rio de Janeiro"));
			wm.add(new Port(6118, 1234, "Reykjavik"));
			wm.add(new Port(3069, 5421, "Buenos Aires"));
			wm.add(new Port(3218, 5166, "Porto Allegre"));
			wm.add(new Port(2958, 6065, "Rio Gallegos"));
			wm.add(new Port(3600, 6064, "Stanley"));
			wm.add(new Port(3461, 1737, "Boston"));
			wm.add(new Port(3067, 2938, "San Juan"));
			wm.add(new Port(7042, 4129, "Dakar"));
			wm.add(new Port(7177, 4360, "Freetown"));
			wm.add(new Port(8023, 4399, "Lagos"));
			wm.add(new Port(8141, 5218, "Port Gentil"));
			wm.add(new Port(8380, 5717, "Luanda"));
			wm.add(new Port(8502, 6273, "Cape Town"));
			wm.add(new Port(8625, 2664, "Naples"));
			wm.add(new Port(7914, 2929, "Algiers"));
			wm.add(new Port(8280, 3029, "Tunis"));
			wm.add(new Port(9615, 3125, "Beirut"));
			wm.add(new Port(9017, 3231, "Alexandria"));
			wm.add(new Port(9357, 2842, "Athens"));
			wm.add(new Port(9422, 2587, "Thessaloniki"));
			wm.add(new Port(9071, 2428, "Split"));
			wm.add(new Port(7475, 2980, "Casablanca"));
			wm.add(new Port(8194, 2419, "Barcelona"));
			wm.add(new Port(8611, 1326, "Oslo"));
			wm.add(new Port(8739, 1576, "Gothenburg"));
			wm.add(new Port(9288, 1555, "Saint Petersburg"));
			wm.add(new Port(9067, 1707, "Tallinn"));
			wm.add(new Port(8489, 1104, "Bergen"));

			
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
			
			trace(GV.mouseX, GV.mouseY);
			
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