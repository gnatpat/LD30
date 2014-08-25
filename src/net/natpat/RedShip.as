package net.natpat 
{
	import net.natpat.utils.WaypointConnection;
	/**
	 * ...
	 * @author Nathan Patel
	 */
	public class RedShip extends Ship 
	{
		
		public var w:Waypoint;
		
		public var circle:Array = [[-3, 0], [0, -3], [3, 0], [0, 3]];
		
		public var circleint:int = 0;
		
		public var hasSm:Boolean = false;
		
		public function RedShip(w:Waypoint, route:Route, cost:int=50) 
		{
			super(route, cost);
			canKillPirates = true;
			scales = false;
			this.w = w;
		}
		
		override public function gotToDest():void 
		{
			if (route.connections.length >= 1)
			{
				super.gotToDest();
				if (waypoint == 1)
				{
					route.connections.shift();
				}
				if (next == -1)
				{
					w = route.connections[0].to;
					route.connections.shift();
					gotToDest();
				}
			}
			else
			{
				next = 1;
				w.redShip = this;
				var oldx:int = w.x + circle[circleint][0];
				var oldy:int = w.y + circle[circleint][1];
				circleint++;
				circleint = circleint % 4;
				xDest = w.x + circle[circleint][0]
				yDest = w.y + circle[circleint][1]
				getDirDir(oldx, oldy);
				trace(dir.x, dir.y);
				trace(circleint);
			}
			waypoint = 0;
			shoreLeave = 0;
			
		}
		
		
		public function started():void
		{
			//gotToDest();
			next = -1;
		}
		
		override public function get cc():WaypointConnection 
		{
			if (route == null) { x = GV.routePort.x; y = GV.routePort.y; return null }
			return super.cc;
		}
	}

}