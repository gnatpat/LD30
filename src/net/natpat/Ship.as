package net.natpat 
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.natpat.utils.WaypointConnection;
	/**
	 * ...
	 * @author Nathan Patel
	 */
	public class Ship 
	{
		
		public var sm:ShipManager;
		
		public var route:Route;
		
		public var x:Number;
		public var y:Number;
		
		public var xDest:int;
		public var yDest:int;
		
		public var speed:Number = 60;
		
		public var dir:Point;
		public var waypoint:int;
		public var next:int;
		
		public var dirSign:Point;
		
		public var ss:SpriteSheet;
		
		public var cost:int;
		
		public var canKillPirates:Boolean = false;
		
		public var homePort:Port;
		
		public function Ship(route:Route, cost:int = 50) 
		{
			
			this.route = route;
			waypoint = 0;
		    dir = new Point();
			next = 1;
			
			x = cc.from.x;
			y = cc.from.y;
			
			dirSign = new Point();
			dir = new Point();
			
			getDir();
			
			ss = new SpriteSheet(Assets.SHIP, 100, 74);
			
			this.cost = cost;
			
			homePort = route.from;
		}
		
		public function update():void
		{
			x += dir.x * GV.elapsed * speed;
			y += dir.y * GV.elapsed * speed;
			
			if (x * dirSign.x >= xDest * dirSign.x 
			 && y * dirSign.y >= yDest * dirSign.y)
			{
				x = xDest                                                                                      
				y = yDest;
				
				if ((waypoint == route.connections.length - 1 && next == 1)
				 || (waypoint == 0                            && next == -1))
				{
					if (waypoint == 0 && next == -1)
					{
						GV.makeGold(route.gold, x, y);
					}
					waypoint += next;
					next = -next;
				}
				else
				{
					if (cc.to.hasPirate)
					{
						if (canKillPirates)
						{
							cc.to.clearPirate();
						}
						else
						{
							cc.to.pirateKill();
							remove();
						}
					}
				}
				
				waypoint += next;
				getDir();
			}
			
			ss.update();
			
		}
		
		public function remove():void
		{
			sm.removeShip(this);
		}
		
		public function getDir():void
		{
			var oldX:int
			var oldY:int
			if (next == 1)
			{
				oldX = cc.from.x;
				oldY = cc.from.y;
				xDest = cc.to.x;
				yDest = cc.to.y;
			}
			else
			{
				oldX = cc.to.x;
				oldY = cc.to.y;
				xDest = cc.from.x;
				yDest = cc.from.y;
			}
			dir.x = xDest - oldX;
			dir.y = yDest - oldY;
			
			dir.normalize(1);
			
			dirSign.x = dir.x < 0 ? -1 : 1;
			dirSign.y = dir.y < 0 ? -1 : 1;
			
		}
		
		public function get cc():WaypointConnection
		{
			return route.connections[waypoint];
		}
		
		public function render(lineBuffer:BitmapData, buffer:BitmapData):void
		{
			
			var m:Matrix = new Matrix();
			m.translate( -GV.camera.x + (GC.SCREEN_WIDTH * GV.zoom / 2), - GV.camera.y + (GC.SCREEN_HEIGHT * GV.zoom / 2));
			lineBuffer.draw(route.lineGraphic, m);
			ss.render(buffer, x, y, true, GC.SPRITE_ZOOM_RATIO * 1.5);
		}
		
	}

}