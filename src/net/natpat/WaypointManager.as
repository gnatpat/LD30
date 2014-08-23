package net.natpat 
{
	import flash.display.BitmapData;
	import net.natpat.utils.WaypointConnection;
	/**
	 * ...
	 * @author Nathan Patel
	 */
	public class WaypointManager 
	{
		
		public var waypoints:Vector.<Waypoint>;
		
		public var buffer:BitmapData
		
		
		public function WaypointManager(buffer:BitmapData) 
		{
			waypoints = new Vector.<Waypoint>();
			this.buffer = buffer;
		}
		
		public function add(waypoint:Waypoint):void
		{
			waypoints.push(waypoint);
			waypoint.wm = this;
		}
		
		public function connectWaypoints():void
		{
			var xDist:int = 0;
			var yDist:int = 0;
			var dist:Number;
			for (var i:int = 0; i < waypoints.length - 1; i++)
			{
				for (var j:int = i + 1; j < waypoints.length; j++)
				{
					xDist = waypoints[i].x - waypoints[j].x;
					yDist = waypoints[i].y - waypoints[j].y;
					dist = Math.sqrt(xDist * xDist + yDist * yDist);
					if (dist < GC.MAX_CONNECTION_LENGTH)
					{
						waypoints[i].connections.push(new WaypointConnection(dist, waypoints[i], waypoints[j]));
						waypoints[j].connections.push(new WaypointConnection(dist, waypoints[j], waypoints[i]));
					}
				}
			}
		}
		
		public function render():void
		{
			for each(var w:Waypoint in waypoints)
			{
				w.render(buffer);
			}
		}
		
		public function update():void
		{
			for each(var w:Waypoint in waypoints)
			{
				w.update();
			}
		}
		
	}

}