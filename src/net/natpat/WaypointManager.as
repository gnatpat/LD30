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
		
		public var id:int;
		
		public function WaypointManager(buffer:BitmapData) 
		{
			waypoints = new Vector.<Waypoint>();
			this.buffer = buffer;
			id = 0;
		}
		
		public function add(waypoint:Waypoint):void
		{
			waypoints.push(waypoint);
			waypoint.wm = this;
			waypoint.id = id;
			id++;
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
			removeConnection(30, 179);
			removeConnection(31, 179);
			removeConnection(32, 179);
			removeConnection(33, 179);
			removeConnection(75, 179);
		}
		
		public function removeConnection(w1:int, w2:int):void
		{
			waypoints[w1].removeConnectionTo(waypoints[w2]);
			waypoints[w2].removeConnectionTo(waypoints[w1]);
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