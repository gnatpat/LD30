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
		
		public var shoreLeave:Number;
		
		public var paid:Boolean;
		
		public var scales:Boolean = true;
		
		public var scale:Number = 0.4;
		
		public var move:Boolean = true;
		
		
		public function Ship(route:Route, cost:int = 50) 
		{
			
			this.route = route;
			waypoint = 0;
		    dir = new Point();
			next = 1;
			
			if (cc != null)
			{
				x = cc.from.x;
				y = cc.from.y;
			}
			
			dirSign = new Point();
			dir = new Point();
			
			getDir();
			
			var wobbleTime:Number = 0.2;
			
			ss = new SpriteSheet(Assets.SHIP, 354, 316, 0.01);
			ss.addAnim("wobble", [[0, 2, wobbleTime], [1, 2, wobbleTime], [2, 2, wobbleTime], [3, 2, wobbleTime], [4, 2, wobbleTime], [5, 2, wobbleTime], [6, 2, wobbleTime], [7, 2, wobbleTime], [8, 2, wobbleTime], [9, 2, wobbleTime], [10, 2, wobbleTime]], true);
			ss.addAnim("death", [[0, 0, 0.1], [1, 0, 0.1], [2, 0, 0.1], [3, 0, 0.1], [4, 0, 0.1], [5, 0, 0.1], [6, 0, 0.3, remove]], true);
			ss.changeAnim("wobble");
			this.cost = cost;
			
			if(cc != null)
				homePort = route.from;
			
			shoreLeave = 0;
			paid = true;
		}
		
		public function update():void
		{
			
			ss.update();
			if (shoreLeave > 0)
			{
				shoreLeave -= GV.elapsed;
				ss.masterScale = 0;
				if (waypoint == 0 && shoreLeave < 1 && !paid)
				{
					GV.makeGold(route.gold, x, y);
					paid = true;
				}
				return;
			}
			shoreLeave = 0;
			
			if (move)
			{
				x += dir.x * GV.elapsed * speed;
				y += dir.y * GV.elapsed * speed;
			}
			
			if (scales)
			{
				if ((waypoint == route.connections.length - 1 && next == 1)
				 || (waypoint == 0                            && next == -1))
				{
					ss.masterScale = Math.min(scale, (GV.dist(x, y, xDest, yDest)) / 25 * scale);
				}
				else if (waypoint == 0 && next == 1)
				{
					ss.masterScale = Math.min(scale, (GV.dist(x, y, route.connections[waypoint].from.x, route.connections[waypoint].from.y)) / 25 * scale);
				}
				else if (waypoint == route.connections.length - 1 && next == -1) 
				{
					ss.masterScale = Math.min(scale, (GV.dist(x, y, route.connections[waypoint].to.x, route.connections[waypoint].to.y)) / 25 * scale);
				}
				else
				{
					ss.masterScale = scale;
				}
			}
			else 
				ss.masterScale = scale;
			
			
			if (move && x * dirSign.x >= xDest * dirSign.x 
			 && y * dirSign.y >= yDest * dirSign.y)
			{
				gotToDest();
			}
			
		}
		
		public function gotToDest():void
		{
			x = xDest                                                                                      
			y = yDest;
			
			var dirUpdate:Boolean = true;
			
			if ((waypoint == route.connections.length - 1 && next == 1)
			 || (waypoint == 0                            && next == -1))
			{
				shoreLeave = 2;
				if (waypoint == 0 && next == -1 && scales)
				{
					homePort.checkForReplace(this);
					paid = false;
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
						ss.changeAnim("death");
						move =false;
					}
				}
			}
			
			waypoint += next;
			if (dirUpdate)
				getDir();
		}
		
		public function remove():void
		{
			sm.removeShip(this);
		}
		
		public function getDir():void
		{
			if (cc == null)
			{
				xDest = x;
				yDest = y;
				getDirDir(x, y);
				return;
			}
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
			
			getDirDir(oldX, oldY);
		}
		
		public function getDirDir(oldX:int, oldY:int):void
		{
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